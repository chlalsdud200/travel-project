// assets/js/admin_prod/ad_regprod.js
// ✅ 4열 그리드 적용: 날짜 축소(4개 1열), 가격 확대(2칸), 수용인원 통합

console.log("ad_regprod.js LOADED (Layout Optimized: 4-Col Grid)");

; (function() {
	// ------------------------------
	// 신규 등록 폼 열기
	// ------------------------------
	document.addEventListener("click", (e) => {
		const btn = e.target.closest("#btn-new-regprod");
		if (!btn) return;
		openNewRegProdForm();
	});

	function openNewRegProdForm() {
		const host = document.getElementById("regprod-new-host");
		if (!host) {
			alert("regprod-new-host가 없습니다.");
			return;
		}

		if (host.dataset.open === "1") return;

		host.dataset.open = "1";
		host.style.display = "block";

		// ✅ 변경 포인트:
		// 기존 "4열 그리드" UI를 유지하던 신규등록 폼을
		// 네가 올린 "수정폼(reg-update-form)과 같은 구조(3열 그리드 + form-actions)"로 변경
		// ※ 패키지 자동완성 로직을 위해 pkg-field / pkg-inline-list 구조는 유지

		const styles = `
      <style>
        /* 신규 등록 폼: 수정폼과 동일한 느낌으로 최소 덮어쓰기 */
        #regprod-new-host .tct-tab-body { margin-top:14px; }
        #regprod-new-host label {
          display:block;
          font-size:13px;
          font-weight:600;
          color:#475569;
          margin-bottom:6px;
        }
        #regprod-new-host input,
        #regprod-new-host select,
        #regprod-new-host textarea {
          width:100%;
          padding:8px 10px;
          border:1px solid #cbd5e1;
          border-radius:10px;
          font-size:14px;
          box-sizing:border-box;
          background:#fff;
        }
        #regprod-new-host textarea {
		  height: 42px;
		  min-height: 42px;
		  padding: 8px 10px;
          resize: none;
          overflow-y: hidden;
          line-height: normal;
        }
      </style>
    `;

		host.innerHTML =
			styles +
			`
      <div class="detail-wrap"
           style="background:#fff;border:1px solid #eef2f7;border-radius:16px;padding:20px;">

        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:14px;">
          <div>
            <div style="font-weight:900;font-size:16px;color:#1e293b;">신규 등록상품</div>
            <div style="margin-top:4px;font-size:12px;color:#94a3b8;">필수 정보 입력 후 저장</div>
          </div>
          <button type="button" class="btnX gray" data-action="close-new-regprod">접기</button>
        </div>

        <div id="tab-reg-new" class="tct-tab-body active" style="margin-top: 14px;">
          <form id="new-regprod-form">

            <div style="display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px;">

              <div>
                <label>상품등록코드</label>
                <input type="text" name="regId" required placeholder="예: 20260109_01" autocomplete="off" />
              </div>

              <div class="pkg-field" style="position:relative;">
                <label>패키지코드</label>
                <input type="text" name="pkgId" required autocomplete="off" placeholder="예: FRPARCUL01 (패키지명 자동검색)" />

                <div class="pkg-inline-list"
                     style="display:none;
                            position:absolute;
                            left:0; right:0; top:100%;
                            margin-top:6px;
                            background:#fff;
                            border:1px solid #e5e7eb;
                            border-radius:8px;
                            box-shadow:0 10px 25px rgba(15,23,42,.15);
                            max-height:260px;
                            overflow:auto;
                            z-index:50;">
                </div>
              </div>

              <div>
                <label>판매중</label>
                <select name="forSale">
                  <option value="Y" selected>Y</option>
                  <option value="N">N</option>
                </select>
              </div>

              <div>
                <label>판매시작일</label>
                <input type="date" name="saleStartDt" />
              </div>

              <div>
                <label>판매종료일</label>
                <input type="date" name="saleEndDt" />
              </div>

              <div>
                <label>가격</label>
                <input type="number" name="regPrice" value="0" min="0" step="10000" />
              </div>

              <div>
                <label>출발일</label>
                <input type="date" name="startDt" required />
              </div>

              <div>
                <label>도착일</label>
                <input type="date" name="endDt" required />
              </div>

              <div>
                <label>수용가능인원</label>
                <input type="number" name="regQty" value="0" min="0" step="1" />
              </div>

              <div style="grid-column: 1/-1;">
                <label>등록상품명</label>
                <input type="text" name="regTitle" required placeholder="상품명을 입력하세요" />
              </div>

              <div style="grid-column: 1/-1;">
                <label>핵심문구</label>
                <input type="text" name="highlight" placeholder="강조할 문구를 입력하세요" />
              </div>

              <div style="grid-column: 1/-1;">
                <label>설명A</label>
                <textarea name="descriptionA"
                          placeholder="내용을 입력하세요."></textarea>
              </div>

              <div style="grid-column: 1/-1;">
                <label>설명B</label>
                <textarea name="descriptionB"
                          placeholder="내용을 입력하세요."></textarea>
              </div>

            </div>

            <div class="form-actions" style="margin-top:16px;">
              <div class="left">
                <label>&nbsp;</label>
              </div>
              <div class="right">
                <button type="button" class="btnX gray md" data-action="close-new-regprod">취소</button>
                <button type="submit" class="btnX indigo md">저장</button>
              </div>
            </div>

          </form>
        </div>
      </div>
    `;
	}

	// ------------------------------
	// 신규 등록 폼 닫기
	// ------------------------------
	document.addEventListener("click", (e) => {
		const closeBtn = e.target.closest('[data-action="close-new-regprod"]');
		if (!closeBtn) return;
		closeNewRegProdForm();
	});

	function closeNewRegProdForm() {
		const host = document.getElementById("regprod-new-host");
		if (!host) return;
		host.innerHTML = "";
		host.style.display = "none";
		host.dataset.open = "0";
	}

	// ------------------------------
	// 패키지 인라인 드롭다운 (기존 로직 유지 + UI 개선)
	// ------------------------------
	let pkgAbort = null;

	async function fetchPackages(keyword) {
		if (pkgAbort) pkgAbort.abort();
		pkgAbort = new AbortController();

		const q = (keyword || "").trim();
		const url = `${contextPath}/admin/prod/api/packages.do?q=${encodeURIComponent(q)}`;

		const resp = await fetch(url, { method: "GET", signal: pkgAbort.signal });
		if (!resp.ok) return { ok: false, data: [] };

		const json = await resp.json();
		if (!json || json.ok !== true) return { ok: false, data: [] };

		return { ok: true, data: Array.isArray(json.data) ? json.data : [] };
	}

	// ✅ 드롭다운 레이아웃: ID칸 축소, Title칸 확대
	function renderPkgList(listEl, items) {
		if (!listEl) return;

		if (!items || items.length === 0) {
			listEl.innerHTML = `<div style="padding:12px;color:#94a3b8;font-size:13px;">검색 결과 없음</div>`;
			listEl.style.display = "block";
			return;
		}

		const gridStyle = `display:grid; grid-template-columns: 110px 1fr 50px 50px 50px; gap:8px; align-items:center;`;

		const header = `
      <div style="${gridStyle} padding:8px 12px; font-size:11px; font-weight:800; color:#64748b; background:#f1f5f9; border-bottom:1px solid #e2e8f0;">
        <div>ID</div>
        <div>TITLE</div>
        <div>CTRY</div>
        <div>LOC</div>
        <div>THM</div>
      </div>
    `;

		const rows = items
			.map(
				(p) => `
        <div class="pkg-item"
             data-pkgid="${p.packageId}"
             style="${gridStyle} padding:10px 12px; font-size:12px; cursor:pointer; border-bottom:1px solid #f1f5f9; color:#334155;"
             onmouseover="this.style.background='#f8fafc'"
             onmouseout="this.style.background='transparent'">
          <div style="font-weight:700; color:#475569;">${p.packageId}</div>
          <div style="font-weight:600; color:#0f172a; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">
            ${p.packageTitle}
          </div>
          <div style="color:#64748b;">${p.ctryId ?? "-"}</div>
          <div style="color:#64748b;">${p.locId ?? "-"}</div>
          <div style="color:#64748b;">${p.themeId ?? "-"}</div>
        </div>
      `
			)
			.join("");

		listEl.innerHTML = header + rows;
		listEl.style.display = "block";
	}

	function hidePkgList(fieldEl) {
		const list = fieldEl?.querySelector(".pkg-inline-list");
		if (!list) return;
		list.style.display = "none";
		list.innerHTML = "";
	}

	const handlePkgInput = async (e) => {
		const input = e.target.closest('#regprod-new-host input[name="pkgId"]');
		if (!input) return;

		const field = input.closest(".pkg-field");
		const list = field.querySelector(".pkg-inline-list");
		if (!list) return;

		try {
			const { ok, data } = await fetchPackages(input.value);
			if (!ok) return hidePkgList(field);
			renderPkgList(list, data);
		} catch (err) {
			if (err?.name !== "AbortError") console.error(err);
			hidePkgList(field);
		}
	};

	document.addEventListener("focusin", handlePkgInput);
	document.addEventListener("input", handlePkgInput);

	document.addEventListener("click", (e) => {
		const item = e.target.closest("#regprod-new-host .pkg-inline-list .pkg-item");
		if (!item) return;

		const pkgId = item.dataset.pkgid || "";
		const list = item.closest(".pkg-inline-list");
		const field = list?.parentElement;
		const input = field?.querySelector('input[name="pkgId"]');

		if (input) input.value = pkgId;
		if (field) hidePkgList(field);
	});

	document.addEventListener("click", (e) => {
		const inPkg = e.target.closest(
			'#regprod-new-host input[name="pkgId"], #regprod-new-host .pkg-inline-list'
		);
		if (inPkg) return;
		document.querySelectorAll("#regprod-new-host .pkg-field").forEach((field) => hidePkgList(field));
	});
})();

// ------------------------------
// 신규 등록 저장 (INSERT)
// ------------------------------
document.addEventListener("submit", async (e) => {
	const form = e.target.closest("#new-regprod-form");
	if (!form) return;

	e.preventDefault();
	const fd = new FormData(form);

	const regId = (fd.get("regId") || "").toString().trim();
	if (!regId) {
		alert("상품등록코드(regId)는 필수입니다.");
		form.querySelector('input[name="regId"]')?.focus();
		return;
	}

	const pkgId = (fd.get("pkgId") || "").toString().trim();
	const regTitle = (fd.get("regTitle") || "").toString().trim();

	if (!pkgId) return alert("패키지코드를 선택해주세요.");
	if (!regTitle) return alert("등록상품명을 입력해주세요.");

	const body = {
		regId,
		pkgId,
		forSale: (fd.get("forSale") || "Y").toString(),
		saleStartDt: (fd.get("saleStartDt") || "").toString(), // yyyy-MM-dd
		saleEndDt: (fd.get("saleEndDt") || "").toString(),
		regPrice: Number(fd.get("regPrice") || 0),
		startDt: (fd.get("startDt") || "").toString(),
		endDt: (fd.get("endDt") || "").toString(),
		regQty: Number(fd.get("regQty") || 0),
		regTitle,
		highlight: (fd.get("highlight") || "").toString(),
		descriptionA: (fd.get("descriptionA") || "").toString(),
		descriptionB: (fd.get("descriptionB") || "").toString(),
	};

	const btn = form.querySelector('button[type="submit"]');
	if (btn) btn.disabled = true;

	try {
		const resp = await fetch(`${contextPath}/admin/prod/createReg.do`, {
			method: "POST",
			headers: { "Content-Type": "application/json;charset=UTF-8" },
			body: JSON.stringify(body),
		});

		const json = await resp.json();
		if (!json.ok) {
			alert(json.message || "등록 실패");
			return;
		}

		alert(`등록 완료: ${json.regId}`);
		location.reload();
	} catch (err) {
		console.error(err);
		alert("오류 발생");
	} finally {
		if (btn) btn.disabled = false;
	}
});

// 수정 폼 처리 (기존 유지)
document.addEventListener("submit", async (e) => {
	const form = e.target;
	if (!(form instanceof HTMLFormElement) || !form.classList.contains("reg-update-form")) return;

	e.preventDefault();
	const fd = new FormData(form);
	const regId = (fd.get("regId") || "").toString().trim();
	if (!regId) return alert("상품등록코드 필수");

	const body = {
		action: "update",
		regId,
		pkgId: (fd.get("pkgId") || "").toString(),
		regTitle: (fd.get("regTitle") || "").toString(),
		forSale: (fd.get("forSale") || "Y").toString(),
		saleStartDt: (fd.get("saleStartDt") || "").toString(),
		saleEndDt: (fd.get("saleEndDt") || "").toString(),
		regPrice: Number(fd.get("regPrice") || 0),
		startDt: (fd.get("startDt") || "").toString(),
		endDt: (fd.get("endDt") || "").toString(),
		regQty: Number(fd.get("regQty") || 0),
		highlight: (fd.get("highlight") || "").toString(),
		descriptionA: (fd.get("descriptionA") || "").toString(),
		descriptionB: (fd.get("descriptionB") || "").toString(),
	};

	const btn = form.querySelector('button[type="submit"]');
	if (btn) btn.disabled = true;

	try {
		const resp = await fetch(`${contextPath}/adRegProdModify.do`, {
			method: "POST",
			headers: { "Content-Type": "application/json;charset=UTF-8" },
			body: JSON.stringify(body),
		});
		const data = await resp.json().catch(() => null);
		if (!resp.ok || !data?.ok) {
			alert(data?.message || "수정 실패");
			return;
		}
		alert("수정 완료");
	} catch (err) {
		alert("통신 오류");
	} finally {
		if (btn) btn.disabled = false;
	}
});
