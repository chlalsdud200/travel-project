import csv
import datetime
import fnmatch
import hashlib
from pathlib import Path
import zipfile

# ==========================================
# 목적:
# - ChatGPT에게 "프로젝트 전체"를 보내되,
#   분석/수정에 불필요한 노이즈(.svn, lib jar, build 산출물, 이미지 등)는 제외하고
#   소스/설정(텍스트)만 묶어서 전달하기 위한 고정(Always) 추출기
# ==========================================

# 분석/수정 대상 텍스트 확장자만 포함
INCLUDE_EXTS = {
    ".java", ".jsp", ".js", ".css", ".html",
    ".xml", ".properties", ".sql", ".md", ".txt", ".json"
}

# 폴더 단위 노이즈 제외
EXCLUDE_DIR_NAMES = {
    ".git", ".svn", ".metadata", ".settings",
    ".idea", ".vscode", "__pycache__",
    "node_modules", "target", "build", "bin", "out", "dist", "classes", "logs",
    ".gradle", ".mvn"
}

# 경로 패턴(파일/폴더) 노이즈 제외
EXCLUDE_GLOBS = [
    "**/WEB-INF/lib/**",          # jar 라이브러리
    "**/*.class", "**/*.jar",     # 바이너리
    "**/*.war", "**/*.ear",

    "**/*.png", "**/*.jpg", "**/*.jpeg", "**/*.gif", "**/*.webp",
    "**/*.svg", "**/*.ico",       # 이미지

    "**/*.pdf", "**/*.zip", "**/*.7z", "**/*.rar",
    "**/*.db", "**/*.db-journal", "**/*.sqlite",
]

LANG_TAG = {
    ".java": "java",
    ".jsp": "jsp",
    ".js": "javascript",
    ".xml": "xml",
    ".css": "css",
    ".html": "html",
    ".properties": "properties",
    ".sql": "sql",
    ".md": "markdown",
    ".txt": "text",
    ".json": "json",
}

# 파트 파일이 너무 커지면 여러 개로 쪼갠다(업로드/학습 효율)
MAX_PART_CHARS = 250_000

# 너무 큰 파일은 보통 로그/덤프라 제외(기본 800KB)
MAX_FILE_BYTES = 800 * 1024


def is_excluded(root: Path, file_path: Path) -> bool:
    rel = file_path.relative_to(root).as_posix()

    # 제외 폴더가 경로 중간에 끼면 제외
    if any(part in EXCLUDE_DIR_NAMES for part in file_path.parts):
        return True

    # 제외 glob 패턴에 걸리면 제외
    for pat in EXCLUDE_GLOBS:
        if fnmatch.fnmatch(rel, pat):
            return True

    return False


def sha1_text(text: str) -> str:
    return hashlib.sha1(text.encode("utf-8", errors="ignore")).hexdigest()


def build_tree(selected_paths):
    tree = {}

    for rel in selected_paths:
        parts = rel.split("/")
        node = tree
        for part in parts[:-1]:
            node = node.setdefault(part, {})
        node.setdefault("__files__", []).append(parts[-1])

    lines = ["# Project Tree (filtered)", "", "```", "."]

    def render(node, prefix=""):
        dirs = sorted([k for k in node.keys() if k != "__files__"])
        files = sorted(node.get("__files__", []))
        entries = [("dir", d) for d in dirs] + [("file", f) for f in files]

        for i, (typ, name) in enumerate(entries):
            last = (i == len(entries) - 1)
            connector = "└── " if last else "├── "
            if typ == "dir":
                lines.append(prefix + connector + name + "/")
                extension = "    " if last else "│   "
                render(node[name], prefix + extension)
            else:
                lines.append(prefix + connector + name)

    render(tree, "")
    lines.append("```")
    return "\n".join(lines)


def export_ai_pack_fixed():
    # 스크립트 실행 위치(현재 폴더)를 프로젝트 루트로 본다.
    root = Path(".").resolve()

    # 출력 폴더/zip 이름: 실행 시각 기준으로 자동 생성(덮어쓰기 방지)
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    out = Path(f"AI_PACK_{ts}").resolve()
    out.mkdir(parents=True, exist_ok=True)

    file_infos = []
    selected_rel_paths = []

    # 1) 필요한 텍스트 소스만 골라서 수집
    for p in root.rglob("*"):
        if p.is_dir():
            continue

        if is_excluded(root, p):
            continue

        ext = p.suffix.lower()
        if ext not in INCLUDE_EXTS:
            continue

        try:
            size = p.stat().st_size
        except:
            continue

        if size > MAX_FILE_BYTES:
            continue

        rel = p.relative_to(root).as_posix()

        try:
            text = p.read_text(encoding="utf-8", errors="ignore")
        except:
            continue

        lines = text.count("\n") + 1 if text else 0
        h = sha1_text(text)

        file_infos.append((rel, ext, size, lines, h, text))
        selected_rel_paths.append(rel)

    file_infos.sort(key=lambda x: x[0])
    selected_rel_paths.sort()

    # 2) 트리 생성(구조 파악용)
    (out / "00_tree.md").write_text(build_tree(selected_rel_paths), encoding="utf-8")

    # 3) 인덱스 생성(파일 목록/메타)
    with (out / "01_index.csv").open("w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["path", "ext", "bytes", "lines", "sha1"])
        for rel, ext, size, lines, h, _ in file_infos:
            w.writerow([rel, ext, size, lines, h])

    # 4) 코드 본문 md 파트 파일로 분할 저장
    part_no = 1
    buf = []
    cur_chars = 0

    def flush_part():
        nonlocal part_no, buf, cur_chars
        if not buf:
            return
        (out / f"02_code_part{part_no:02d}.md").write_text("\n".join(buf), encoding="utf-8")
        part_no += 1
        buf = []
        cur_chars = 0

    for rel, ext, size, lines, h, text in file_infos:
        lang = LANG_TAG.get(ext, "")
        block = (
            f"## File: `{rel}`\n\n"
            f"- bytes: {size}, lines: {lines}, sha1: {h}\n\n"
            f"```{lang}\n{text}\n```\n\n---\n"
        )

        if cur_chars + len(block) > MAX_PART_CHARS and buf:
            flush_part()

        buf.append(block)
        cur_chars += len(block)

    flush_part()

    # 5) 결과 폴더를 zip 하나로 묶기(업로드 1개로 끝)
    zip_path = out.with_suffix(".zip")
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as z:
        for fp in out.rglob("*"):
            if fp.is_file():
                z.write(fp, arcname=fp.relative_to(out).as_posix())

    print(f"[완료] root = {root}")
    print(f"[완료] out  = {out}")
    print(f"[완료] zip  = {zip_path}")
    print(f"[완료] files= {len(file_infos)}")


if __name__ == "__main__":
    export_ai_pack_fixed()
