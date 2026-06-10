/**
 * boardhome.js
 * - 서버 호출 + 렌더링(HOME 공지/최신글/페이징)
 * - 이벤트 바인딩은 boardhomeevent.js에서만 한다
 */

/* ===== 전역 ===== */

var homeCurrentPage = 1;

var HOME_PAGE_SIZE = 10;
var HOME_NOTICE_LIMIT = 5;

var homeF;
var homeTbody;
var homePagelist;
var homeTotalCount;


/* ===== 서버 호출: 목록 ===== */
const fn_homeListServer = async (page) => {

	if (typeof page !== "undefined" && page !== null) {
		homeCurrentPage = Number(page);
	}

	homeF          = document.querySelector("#homeF");
	homeTbody      = document.querySelector("#homeTbody");
	homePagelist   = document.querySelector("#homePagelist");
	homeTotalCount = document.querySelector("#homeTotalCount");

	try {

		const fd = homeF ? new FormData(homeF) : new FormData();

		fd.set("page", String(homeCurrentPage));
		fd.set("size", String(HOME_PAGE_SIZE));
		fd.set("noticeLimit", String(HOME_NOTICE_LIMIT));

		const qs = new URLSearchParams(fd).toString();
		const url = `${mypath}/board/homeData.do?${qs}`;

		const res = await fetch(url);
		if (!res.ok) throw new Error("HTTP " + res.status);

		const data = await res.json();

		if (!data || data.ok !== true) {
			alert((data && data.msg) ? data.msg : "홈 데이터를 불러오지 못했습니다.");
			return;
		}

		fn_homeRenderTotal(data.totalCount);
		fn_homeRenderList(data.notices, data.posts, data.totalCount, homeCurrentPage);
		fn_homeRenderPage(data.pglist);

	} catch (e) {
		console.log(e);
		alert("네트워크 오류로 홈 데이터를 불러오지 못했습니다.");
	}
};


/* ===== 렌더링: 총 건수 ===== */
const fn_homeRenderTotal = (totalCount) => {
	if (!homeTotalCount) return;
	homeTotalCount.textContent = String(totalCount ?? 0);
};


/* ===== 렌더링: tbody ===== */
const fn_homeRenderList = (notices, posts, totalCount, page) => {

	if (!homeTbody) return;

	const nlist = Array.isArray(notices) ? notices : [];
	const plist = Array.isArray(posts) ? posts : [];

	if (nlist.length === 0 && plist.length === 0) {
		homeTbody.innerHTML =
			`<tr><td colspan="5" class="text-center text-muted fw-bold py-4">글이 없습니다.</td></tr>`;
		return;
	}

	const rows = [];

	// (1) 공지
	nlist.forEach(n => {

		// ✅ ADMIN 작성글은 빨간색(보는 사람이 관리자여도 유지)
		const isAdminWriter = (String(n.writerRole || "") === "ADMIN");
		const wClass = isAdminWriter ? "text-danger fw-bold" : "";

		rows.push(`
      <tr class="notice-row"
          data-type="NOTICE"
          data-no="${escapeHtml(String(n.postNo))}"
          style="cursor:pointer;">
        <td><span class="notice-badge">공지사항</span></td>
        <td class="fw-bold"><span class="notice-title">${escapeHtml(n.title || "")}</span></td>
        <td class="${wClass}">${escapeHtml(n.writerName || "")}</td>
        <td>${escapeHtml(n.createdAt || "")}</td>
        <td>-</td>
      </tr>
    `);
	});

	// (2) 최신글

	plist.forEach((p) => {

		const isAdminWriter = (String(p.writerRole || "") === "ADMIN");
		const wClass = isAdminWriter ? "text-danger fw-bold" : "";

		const postType = String(p.postType || "");
		const badge = (postType === "QNA")
			? `<span class="badge bg-info text-dark me-2">문의</span>`
			: `<span class="badge bg-warning text-dark me-2">리뷰</span>`;
		const noClass = (postType === "QNA") ? "board-no-qna" : "board-no-review";
		const noStyle = (postType === "QNA")
			? "color:#1e6b8f !important;font-weight:800;"
			: "color:#8a6d00 !important;font-weight:800;";

		// 게시판별 당겨진 화면 번호(viewNo)를 우선 표시
		const displayNo = (p.viewNo != null && Number(p.viewNo) > 0) ? p.viewNo : p.postNo;

		rows.push(`
      <tr data-type="${escapeHtml(postType)}"
          data-no="${escapeHtml(String(p.postNo))}"
          style="cursor:pointer;">
        <td class="${noClass}" style="${noStyle}">${escapeHtml(String(displayNo ?? ""))}</td>
        <td class="fw-bold">${badge}${escapeHtml(p.title || "")}</td>
        <td class="${wClass}">${escapeHtml(p.writerName || "")}</td>
        <td>${escapeHtml(p.createdAt || "")}</td>
        <td>${escapeHtml(String(p.hit ?? 0))}</td>
      </tr>
    `);
	});

	homeTbody.innerHTML = rows.join("");
};


/* ===== 렌더링: 페이지 버튼 ===== */
const fn_homeRenderPage = (pglistHtml) => {
	if (!homePagelist) return;
	homePagelist.innerHTML = pglistHtml || "";
};


/* ===== escape ===== */
const escapeHtml = (s) => {
	return String(s)
		.replaceAll("&", "&amp;")
		.replaceAll("<", "&lt;")
		.replaceAll(">", "&gt;")
		.replaceAll('"', "&quot;")
		.replaceAll("'", "&#039;");
};
