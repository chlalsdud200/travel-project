/**
 * boardreview.js
 * - 리뷰 화면은 "조각 주입(loadUtil)" 후 callback에서만 DOM을 잡을 수 있다.
 * - 그래서 routePro()에서 콜백으로 호출하는 함수명을 반드시 전역으로 제공해야 한다.
 *
 * ✅ 전역으로 제공할 것:
 *   1) boardReviewPro  : 리뷰 목록 fragment 주입 직후 실행(버튼/검색/페이징 이벤트 연결 + 최초 목록 호출)
 *   2) reviewWritePro  : 리뷰 글쓰기 fragment 주입 직후 실행(주문번호 로딩 + 등록 submit)
 */

// : 리뷰 현재 페이지(목록에서만 사용)
var reviewCurrentPage = 1;

// : 리뷰 현재 검색어(목록에서만 사용)
var reviewCurrentQ = "";

// ✅ 추가: 검색 옵션(기간/조건)
var reviewCurrentPeriod = "";     // 예: "all" / "7" / "30" 등 네 서버가 받는 값
var reviewCurrentStype  = "title"; // 예: "title" / "content" / "tc" 등
var REVIEW_PER_LIST = 10; // 문의와 동일하게 "연속 번호" 계산용(서버 perList=10과 일치)

/**
 * : 해시(#review?... )에서 page/q를 읽어와서 전역 상태에 반영한다
 */
function review_syncStateFromHash() {
  const raw = (location.hash || "").replace("#", "");
  const tmp = raw.split("?");
  const path = tmp[0] || "";
  const qs = tmp[1] || "";

  // : #review/write면 목록 상태는 건드리지 않는다
  if (path.startsWith("review/write")) return;

  const sp = new URLSearchParams(qs);
  reviewCurrentPage = Number(sp.get("page") || 1);
  if (!Number.isFinite(reviewCurrentPage) || reviewCurrentPage < 1) reviewCurrentPage = 1;

  reviewCurrentQ = sp.get("q") || "";
  reviewCurrentPeriod = sp.get("period") || "";
  reviewCurrentStype  = sp.get("stype")  || "title";
}

// ✅ 별점 숫자 → 별 아이콘 HTML
function renderStars(rating) {
  const n = Math.max(0, Math.min(5, Number(rating) || 0));
  return `<span class="stars" aria-label="별점 ${n}점">${"★".repeat(n)}${"☆".repeat(5 - n)}</span>`;
}

/**
 * ✅ boardReviewPro
 * : 리뷰 목록 fragment(board_review_frag.jsp)이 #content에 들어온 "직후" 실행된다
 * : 여기서 버튼/검색/페이징 이벤트를 연결하고, 최초 목록을 서버에서 받아 그린다
 */
function boardReviewPro() {

  // : 해시에서 page/q를 읽어서 현재 상태를 맞춘다
  review_syncStateFromHash();

  // : 글쓰기 버튼(목록 화면에만 존재)
  const btnWrite = document.querySelector("#btnReviewWrite");
  if (btnWrite) {
    btnWrite.onclick = function () {
      // : 글쓰기 화면은 해시로 이동시키면 routePro()가 #review/write를 처리한다
      location.hash = "#review/write";
    };
  }

  // : 검색 폼(목록 화면에만 존재)
  const reviewSearchF = document.querySelector("#reviewSearchF");
  const reviewQ = document.querySelector("#reviewQ");
  if (reviewQ) reviewQ.value = reviewCurrentQ;

  const reviewPeriod = document.querySelector("#reviewPeriod");
  const reviewStype  = document.querySelector("#reviewStype");

  if (reviewPeriod) reviewPeriod.value = reviewCurrentPeriod;
  if (reviewStype)  reviewStype.value  = reviewCurrentStype;
  
  if (reviewSearchF) {
    reviewSearchF.onsubmit = function (e) {
      e.preventDefault();

      // : 검색하면 1페이지부터 보여준다
      const q = (reviewQ ? reviewQ.value : "").trim();
      reviewCurrentQ = q;
      reviewCurrentPage = 1;

	  // ✅ submit 시 현재 옵션도 같이 저장
	  reviewCurrentPeriod = reviewPeriod ? reviewPeriod.value : "";
	  reviewCurrentStype  = reviewStype  ? reviewStype.value  : "title";

	  location.hash =
	    `#review?page=${reviewCurrentPage}` +
	    `&q=${encodeURIComponent(reviewCurrentQ)}` +
	    `&period=${encodeURIComponent(reviewCurrentPeriod)}` +
	    `&stype=${encodeURIComponent(reviewCurrentStype)}`;

      // : 서버 호출은 여기서 바로 한다(목록 화면에서만)
      fn_reviewListServer();
    };
  }

  // : 페이징 영역 클릭(이벤트 위임)
  const elPg = document.querySelector("#reviewPagelist");
  if (elPg) {
    elPg.onclick = function (e) {
      const el = e.target.closest("a,button");
      if (!el) return;

      // a면 기본 이동 막기
      if (el.tagName === "A") e.preventDefault();

      // 1) data-page 우선
      let p = el.dataset ? el.dataset.page : null;

      // 2) 없으면 name(네 코드가 prev/next name을 쓰는 케이스를 이미 고려했음)
      if (!p) p = el.getAttribute("name");

      // 3) 없으면 href에서 page= 파싱
      if (!p && el.getAttribute("href")) {
        try {
          const u = new URL(el.getAttribute("href"), location.origin);
          p = u.searchParams.get("page");
        } catch (err) {}
      }

      p = Number(p || 1);
      if (!Number.isFinite(p) || p < 1) return;

      reviewCurrentPage = p;
      location.hash =
        `#review?page=${reviewCurrentPage}` +
        `&q=${encodeURIComponent(reviewCurrentQ)}` +
        `&period=${encodeURIComponent(reviewCurrentPeriod)}` +
        `&stype=${encodeURIComponent(reviewCurrentStype)}`;

      fn_reviewListServer();
    };
  }

  //목록 행 클릭 → 상세로 이동 (1번만 바인딩)
    const tbody = document.querySelector("#reviewTbody");
    if (tbody && !tbody.dataset.bound) {
      tbody.dataset.bound = "1";
      tbody.onclick = (e) => {
        const tr = e.target.closest("tr[data-no]");
        if (!tr) return;
        const no = tr.dataset.no;
        location.hash = `#review/view/${no}`;
      };
    }
  
  // ✅ 최초 목록 호출
  fn_reviewListServer();
}

/**
 * : 리뷰 목록 데이터를 서버에서 받아서 tbody/total/pagelist를 그린다
 * : 서버는 /board/reviewData.do 가정 (너 프로젝트에서 쓰는 경로 그대로)
 */
async function fn_reviewListServer() {
  try {
	const url =
	  `${CTX}/board/reviewData.do?page=${reviewCurrentPage}` +
	  `&q=${encodeURIComponent(reviewCurrentQ)}` +
	  `&period=${encodeURIComponent(reviewCurrentPeriod)}` +
	  `&stype=${encodeURIComponent(reviewCurrentStype)}`;

    const res = await fetch(url);
    const data = await res.json();

    // : JSON 구조는 { ok, list, totalCount, pgHtml } 형태로 가정
    // : 너 프로젝트가 다른 키를 쓰면 여기만 맞추면 된다
    const list = data.list || [];
    const totalCount = data.totalCount ?? 0;

    const elTotal = document.querySelector("#reviewTotalCount");
    if (elTotal) elTotal.textContent = String(totalCount);

    // : tbody 그리기
    const tbody = document.querySelector("#reviewTbody");
    if (tbody) {
      if (list.length === 0) {
        tbody.innerHTML = `<tr><td colspan="7" class="text-center text-muted fw-bold py-4">데이터가 없습니다.</td></tr>`;
      } else {
        const startNo = totalCount - ((reviewCurrentPage - 1) * REVIEW_PER_LIST);
        let html = "";
		for (let i = 0; i < list.length; i++) {
		          const vo = list[i];
		          const viewNo = startNo - i;
		          // 1. 먼저 HTML 특수문자를 이스케이프 (보안 필수)
		          let titleHtml = reviewEscapeHtml(vo.reviewTitle || "");

		          // 2. 대괄호 [...] 부분만 찾아서 진하게(span) 감싸기
		          // 정규식: \[ (대괄호열고) ... \] (대괄호닫고)
		          titleHtml = titleHtml.replace(
		            /\[(.*?)\]/g, 
		            '<span style="font-weight:800; color:#0f172a;">[$1]</span>'
		          );

				  html += `
				              <tr data-no="${vo.reviewNo}">
				                <td class="text-center">${viewNo}</td>
				                
				                <td class="text-start" style="font-weight: bold; color: #333; cursor:pointer;">
				                    ${titleHtml}
				                </td>
				                
				                <td class="text-center">${reviewEscapeHtml(vo.userId || "")}</td>
				                <td class="text-center">${reviewEscapeHtml(vo.reviewCreated || "")}</td>
				                <td class="text-center text-nowrap">${renderStars(vo.reviewRating)}</td>
				                <td class="text-center">${vo.reviewHit ?? ""}</td>
				                <td class="text-center text-truncate" style="max-width:140px;">
				                    ${reviewEscapeHtml(vo.regTitle ?? vo.REG_TITLE ?? vo.reg_title ?? vo.orderNo ?? "")}
				                </td>
				              </tr>
				            `;
		        }
        tbody.innerHTML = html;
      }
    }

    // : 페이징 HTML(서버가 이미 만들어 주는 방식이면 그대로 끼운다)
    const pg = document.querySelector("#reviewPagelist");
	if (pg) {
	  const html = data.pglist || data.pgHtml || data.pg || ""; // ✅ 서버 키 커버
	  pg.innerHTML = html;

	  // 아래 2)에서 설명하는 data-page 심기(보정)도 같이 적용
	  pg.querySelectorAll("a,button").forEach(el => {
	    if (el.dataset && el.dataset.page) return;

	    const t = (el.textContent || "").trim();
	    if (/^\d+$/.test(t)) el.dataset.page = t;

	    // prev/next가 name 속성에 페이지를 들고 오는 케이스
	    const nm = el.getAttribute("name");
	    if (!el.dataset.page && nm && /^\d+$/.test(nm)) el.dataset.page = nm;

	    // href에 page=가 있는 케이스
	    const href = el.getAttribute("href");
	    if (!el.dataset.page && href && href.includes("page=")) {
	      try {
	        const u = new URL(href, location.origin);
	        const p = u.searchParams.get("page");
	        if (p) el.dataset.page = p;
	      } catch (e) {}
	    }
	  });
	}

  } catch (e) {
    console.error(e);
    const tbody = document.querySelector("#reviewTbody");
    if (tbody) {
      tbody.innerHTML = `<tr><td colspan="7" class="text-center text-danger fw-bold py-4">리뷰 목록을 불러오지 못했습니다.</td></tr>`;
    }
  }
}

/**
 * ✅ reviewWritePro
 * : 리뷰 글쓰기 화면(reviewWrite.jsp)이 #content에 주입된 "직후" 실행된다
 * : (주입된 JSP 안의 <script>는 실행 안 될 수 있으니, 여기서 이벤트/로딩을 건다)
 */
function reviewWritePro() {

  const sel  = document.getElementById("orderNo");
  const hint = document.getElementById("orderHint");
  const btn  = document.getElementById("btnSubmit");
  const form = document.getElementById("reviewForm");

  // : 글쓰기 화면이 아닐 때 실행되면 그냥 종료
  if (!sel || !form) return;

  console.log("reviewWritePro ok");
  console.log("call url =", `${CTX}/board/writableOrderNos.do`);
  
  // : 주문번호 목록을 서버에서 받아서 select에 채운다
  (async () => {
    try {
      const res = await fetch(CTX + "/board/writableOrderNos.do");
      const data = await res.json();

      if (!data.success) {
        alert(data.msg || "로그인이 필요합니다.");
        location.href = CTX + "/login.do";
        return;
      }

	  console.log("writableOrderNos resp =", data);
	  
	  const orderList = data.orderList || data.orderNos || [];

      if (orderList.length === 0) {
        if (hint) {
          hint.textContent = "작성 가능한 주문이 없습니다.";
          hint.style.color = "#dc2626";
        }
        sel.disabled = true;
        btn.disabled = true;
        btn.style.opacity = ".6";
        return;
      }
	  
	  sel.querySelectorAll("option:not([value=''])").forEach(o => o.remove());

	  orderList.forEach(row => {
		const orderNo  = row.orderNo  ?? row.ORDERNO ?? row;
		const regTitle = row.regTitle ?? row.REGTITLE ?? "";
		
	    const opt = document.createElement("option");
	    opt.value = orderNo;
	    opt.textContent = regTitle || orderNo;
	    sel.appendChild(opt);
	  });

    } catch (e) {
      console.error(e);
    }
  })();

  // : 등록 submit 처리
  form.onsubmit = async (e) => {
    e.preventDefault();

    const fd = new FormData(form);
    const payload = {
      orderNo: fd.get("orderNo"),
      reviewRating: parseInt(fd.get("reviewRating"), 10),
      reviewTitle: (fd.get("reviewTitle") || "").trim(),
      reviewCtt: (fd.get("reviewCtt") || "").trim()
    };

    if (!payload.orderNo) return alert("주문번호 선택 필수");

    const res = await fetch(CTX + "/board/reviewInsert.do", {
      method: "POST",
      headers: {"Content-Type":"application/json"},
      body: JSON.stringify(payload)
    });

    const data = await res.json();

    if (data.success) {
      alert("등록 완료");
      location.hash = "#review?page=1&q=" + encodeURIComponent(reviewCurrentQ);
    } else {
      alert(data.msg || "실패");
    }
  };
}

/** : XSS 방지용 간단 이스케이프 */
function reviewEscapeHtml(s) {
  return String(s)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

// ✅ 수정 화면 콜백
async function boardReviewEditPro() {
  const no = window.review_edit_no;
  if (!no) return;

  // 1) 기존 데이터 로딩
  const res = await fetch(`${CTX}/board/reviewEditData.do?reviewNo=${no}`);
  const data = await res.json();

  if (!data.success || !data.vo) {
    alert(data.msg || "수정할 수 없습니다.");
    location.hash = "#review";
    return;
  }

  const vo = data.vo;

  // 2) 폼 채우기
  document.querySelector("#editReviewNo").value = vo.reviewNo;
  document.querySelector("#editOrderNo").value  = vo.orderNo || "";
  document.querySelector("#editRegTitle").value = vo.regTitle || "";
  document.querySelector("#editRating").value   = String(vo.reviewRating ?? 5);
  document.querySelector("#editTitle").value    = vo.reviewTitle || "";
  document.querySelector("#editCtt").value      = vo.reviewCtt || "";

  // 3) 취소
  document.querySelector("#btnEditCancel").onclick = () => {
    location.hash = `#review/view/${no}`;
  };

  // 4) 저장
  const form = document.querySelector("#reviewEditForm");
  form.onsubmit = async (e) => {
    e.preventDefault();

    const payload = {
      reviewNo: Number(document.querySelector("#editReviewNo").value),
      reviewRating: Number(document.querySelector("#editRating").value),
      reviewTitle: (document.querySelector("#editTitle").value || "").trim(),
      reviewCtt: (document.querySelector("#editCtt").value || "").trim()
    };

    const r = await fetch(`${CTX}/board/reviewUpdate.do`, {
      method: "POST",
      headers: {"Content-Type":"application/json"},
      body: JSON.stringify(payload)
    });
    const d = await r.json();

    if (d.success) {
      alert("수정 완료");
      location.hash = `#review/view/${payload.reviewNo}`;
    } else {
      alert(d.msg || "수정 실패");
    }
  };
}

function reviewViewPro() {
  const no = window.review_view_no;
  if (!no) return;

  //JSP id들
  const elTitle   = document.querySelector("#vTitle");
  const elWriter  = document.querySelector("#vWriter");
  const elCreated = document.querySelector("#vCreated");
  const elRating  = document.querySelector("#vRating");
  const elHit     = document.querySelector("#vHit");
  const elOrderNo = document.querySelector("#vOrderNo");
  const elRegTitle= document.querySelector("#vRegTitle");
  const elCtt     = document.querySelector("#vCtt");

  (async () => {
    try {
      const res = await fetch(`${CTX}/board/reviewData.do?reviewNo=${no}`);
      const data = await res.json();

      if (!data.success) {
        alert(data.msg || "상세를 불러오지 못했습니다.");
        location.hash = "#review";
        return;
      }

      const vo = data.vo || {};

      // ✅ VO 키가 카멜케이스(userId)로 내려오는 경우
      const userId      = vo.userId ?? vo.USER_ID ?? "-";
      const reviewTitle = vo.reviewTitle ?? vo.REVIEW_TITLE ?? "";
      const reviewCtt   = vo.reviewCtt ?? vo.REVIEW_CTT ?? "";
      const reviewHit   = vo.reviewHit ?? vo.REVIEW_HIT ?? 0;
      const rating      = vo.reviewRating ?? vo.REVIEW_RATING ?? "";
      const orderNo     = vo.orderNo ?? vo.ORDER_NO ?? "";
      const created     = vo.reviewCreated ?? vo.REVIEW_CREATED ?? "";
      const regTitle    = vo.regTitle ?? vo.REGTITLE ?? vo.REG_TITLE ?? ""; // ✅ 상품명 추가했으면 여기로

      if (elTitle)    elTitle.textContent = reviewTitle || "(제목 없음)";
      if (elWriter)   elWriter.textContent = userId;
      if (elCreated)  elCreated.textContent = created;
      if (elRating)   elRating.textContent = String(rating);
      if (elHit)      elHit.textContent = String(reviewHit);
      if (elOrderNo)  elOrderNo.textContent = orderNo;
      if (elRegTitle) elRegTitle.textContent = regTitle || "-";
      if (elCtt)      elCtt.textContent = reviewCtt || "";

    } catch (e) {
      console.error(e);
      alert("상세 로딩 실패(콘솔 확인)");
    }
  })();
}

// ✅ 상세 화면 콜백
async function boardReviewViewPro() {
	// ✅ 라우터에서 설정되지 않았다면 hash에서 추출
	if (!window.review_view_no) {
	  const hash = location.hash || "";
	  const match = hash.match(/#review\/view\/(\d+)/);
	  if (match) {
	    window.review_view_no = parseInt(match[1]);
	  }
	}
  const no = window.review_view_no;
  if (!no) {
    console.error("review_view_no 없음");
    return;
  }
  
  const btnBack = document.querySelector("#btnReviewViewBack");
  if (btnBack && !btnBack.dataset.bound) {
    btnBack.dataset.bound = "1";
    btnBack.addEventListener("click", (e) => {
      e.preventDefault();
      e.stopPropagation();
      location.hash = "#review";   // 목록으로
    });
  }

  const elTitle   = document.querySelector("#vTitle");
  const elWriter  = document.querySelector("#vWriter");
  const elCreated = document.querySelector("#vCreated");
  const elRating  = document.querySelector("#vRating");
  const elHit     = document.querySelector("#vHit");
  const elOrderNo = document.querySelector("#vOrderNo");
  const elRegTitle= document.querySelector("#vRegTitle");
  const elCtt     = document.querySelector("#vCtt");

  try {
    const url = `${CTX}/board/reviewViewData.do?reviewNo=${no}`;
    console.log("GET", url);

    const res = await fetch(url);

    // ✅ 여기서 바로 json() 쓰는게 “정석”
    if (!res.ok) {
      const text = await res.text();
      console.error("HTTP Error", res.status, text);
      if (elTitle) elTitle.textContent = `상세 로딩 실패 (HTTP ${res.status})`;
      if (elCtt)   elCtt.textContent = text;
      return;
    }

    const data = await res.json();

    if (!data.success || !data.vo) {
      alert(data.msg || "리뷰가 없습니다.");
      location.hash = "#review";
      return;
    }

    const vo = data.vo;

    if (elTitle)   elTitle.textContent = vo.reviewTitle || "";
    if (elWriter)  elWriter.textContent = vo.userId || "";
    if (elCreated) elCreated.textContent = vo.reviewCreated || "";
	if (elRating) elRating.innerHTML = renderStars(vo.reviewRating);
    if (elHit)     elHit.textContent = String(vo.reviewHit ?? 0);
    if (elOrderNo) elOrderNo.textContent = vo.orderNo || "";
    if (elRegTitle)elRegTitle.textContent = vo.regTitle || "-";
    if (elCtt)     elCtt.textContent = vo.reviewCtt || "";

    // 수정/삭제 버튼
	const btnEdit = document.querySelector("#btnReviewEdit");
	const btnDel  = document.querySelector("#btnReviewDelete");

	// ✅ 서버 응답 키가 canEdit / isOwner 둘 다 올 수 있으니 둘 다 커버
	const canEdit = (data.canEdit === true) || (data.isOwner === true);

	console.log("[reviewView] canEdit=", canEdit, "data.canEdit=", data.canEdit, "data.isOwner=", data.isOwner);

	// ✅ CSS(display:none) + inline style(display:none)를 이기려면 '명시적으로' 줘야 한다
	if (btnEdit) btnEdit.style.setProperty("display", canEdit ? "inline-flex" : "none", "important");
	if (btnDel)  btnDel.style.setProperty("display", canEdit ? "inline-flex" : "none", "important");

	if (canEdit) {
	  if (btnEdit) btnEdit.onclick = () => location.hash = `#review/edit/${no}`;

	  if (btnDel) btnDel.onclick = async () => {
	    if (!confirm("삭제할까요?")) return;

	    const r = await fetch(`${CTX}/board/reviewDelete.do`, {
	      method: "POST",
	      headers: {"Content-Type":"application/json"},
	      body: JSON.stringify({ reviewNo: no })
	    });
	    const d = await r.json();

	    if (d.success) {
	      alert("삭제 완료");
	      location.hash = "#review";
	    } else {
	      alert(d.msg || "삭제 실패");
	    }
	  };
	}
	// ✅ (추가): 댓글 스크립트 로드 + init // 댓글 관련 기능
	   ensureReviewReplyScriptLoaded();

  } catch (err) {
    console.error(err);
    if (elTitle) elTitle.textContent = "상세 로딩 실패";
    if (elCtt)   elCtt.textContent = String(err);
  }
}

// ✅ (추가) 리뷰 댓글 스크립트 로드 + init (기존 기능 영향 없음)
function ensureReviewReplyScriptLoaded() {

  // 이미 init 함수가 있으면 바로 실행
  if (window.reviewReplyInit) {
    window.reviewReplyInit();
    return;
  }

  // 이미 로딩 중이면 중복 로드 방지
  if (document.querySelector('script[data-review-reply="1"]')) return;

  const s = document.createElement("script");
  s.src = `${CTX}/js/boardreviewreply.js`;
  s.dataset.reviewReply = "1";
  s.onload = () => { if (window.reviewReplyInit) window.reviewReplyInit(); };
  document.head.appendChild(s);
}
