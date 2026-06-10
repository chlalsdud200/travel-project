/* =========================================================
 * 1. Global Variables & Router
 * - 흐름의 중심이 되는 라우터와 상태 변수를 맨 위에 배치했습니다.
 * ========================================================= */

var boardScreen = "";        // HOME | QNA_LIST | QNA_VIEW | QNA_WRITE | REVIEW
var boardRouteRunning = false;

var routePro = async function () {

  if (boardRouteRunning) return;
  boardRouteRunning = true;

  try {
    var raw = (location.hash || "").replace("#", "");
    if (raw === "") {
      location.hash = "#home";
      return;
    } // 해시가 비어있으면 강제로 #home을 세팅

    var tmp = raw.split("?");
    var path = tmp[0];
    var qs = tmp[1] || "";
    var sp = new URLSearchParams(qs);

    var parts = path.split("/");

    var menuContent = document.querySelector("#content");

    switch (parts[0]) {

      case "home": {
        // 아래에 정의된 boardHomePro를 여기서 호출해도, 실행 시점엔 이미 존재하므로 OK
        await loadUtil(`${CTX}/boardHomeFrag.do`, menuContent, boardHomePro);
        boardScreen = "HOME";
        break;
      }

      case "qna": {

        if (parts[1] === "view") {
          qna_view_no = Number(parts[2]);
          qna_curPage = Number(sp.get("page") || 1);

          await loadUtil(`${CTX}/boardQnaViewFrag.do`, menuContent, boardQnaViewPro);
          boardScreen = "QNA_VIEW";
          break;
        }

        if (parts[1] === "edit") {

          qna_edit_no = Number(parts[2]);
          qna_curPage = Number(sp.get("page") || 1);

          const sres = await fetch(`${CTX}/session.do`);
          const sdata = await sres.json();

          if (!sdata.loggedIn) {
            alert("로그인한 회원만 수정할 수 있습니다.");
            location.href = `${CTX}/login.do?returnUrl=${encodeURIComponent(location.href)}`;
            return;
          }

          const vres = await fetch(`${CTX}/board/qnaEditData.do?qnaNo=${qna_edit_no}`);
          const vdata = await vres.json();

          if (vdata.vo.userId !== sdata.loginId) {
            location.hash = `#qna/view/${qna_edit_no}?page=${qna_curPage}`;
            return;
          }

          await loadUtil(`${CTX}/boardQnaEditFrag.do`, menuContent, boardQnaEditPro);
          boardScreen = "QNA_EDIT";
          break;
        }

        if (parts[1] === "write") {

          const sres = await fetch(`${CTX}/session.do`);
          const sdata = await sres.json();

          if (!sdata.loggedIn) {
            alert("로그인한 회원만 글쓰기가 가능합니다.");
            location.href = `${CTX}/login.do?returnUrl=${encodeURIComponent(location.href)}`;
            return;
          }

          qna_curPage = Number(sp.get("page") || 1);

          await loadUtil(`${CTX}/boardQnaWriteFrag.do`, menuContent, boardQnaWritePro);
          boardScreen = "QNA_WRITE";
          break;
        }

        window.QNA_LAST_LIST_HASH = location.hash;

        if (boardScreen !== "QNA_LIST") {
          await loadUtil(`${CTX}/boardQnaFrag.do`, menuContent, boardQnaPro);
          boardScreen = "QNA_LIST";
        }

        qna_curPage = Number(sp.get("page") || 1);

        qnaF.period.value = sp.get("period") || "";
        qnaF.stype.value  = sp.get("stype")  || "title";
        qnaF.sword.value  = sp.get("sword")  || "";

        qna_from_router = true;
        qnaF.requestSubmit();
        break;
      }

	  case "review": {

	    // ✅ 상세: #review/view/123
	    if (parts[1] === "view") {
	      const no = Number(parts[2]);
	      if (!Number.isFinite(no) || no < 1) { location.hash="#review"; break; }

	      window.review_view_no = no;

	      await loadUtil(
	        `${CTX}/board/reviewView.do`,    // ✅ board 붙임
	        menuContent,
	        (typeof boardReviewViewPro === "function" ? boardReviewViewPro : function(){
	          console.error("boardReviewViewPro is not defined (boardreview.js 에러/로드 확인)");
	        })
	      );
	      boardScreen = "REVIEW_VIEW";
	      break;
	    }

	    // ✅ 수정: #review/edit/123
	    if (parts[1] === "edit") {
	      const no = Number(parts[2]);
	      if (!Number.isFinite(no) || no < 1) { location.hash="#review"; break; }

	      window.review_edit_no = no;

	      const sres  = await fetch(`${CTX}/session.do`);
	      const sdata = await sres.json();
	      if (!sdata.loggedIn) {
	        alert("로그인 필요");
	        location.href = `${CTX}/login.do?returnUrl=${encodeURIComponent(location.href)}`;
	        return;
	      }

	      await loadUtil(
	        `${CTX}/board/reviewEdit.do`,    // ✅ board 붙임
	        menuContent,
	        (typeof boardReviewEditPro === "function" ? boardReviewEditPro : null)
	      );
	      boardScreen = "REVIEW_EDIT";
	      break;
	    }

	    // ✅ 글쓰기: #review/write
        if (parts[1] === "write") {

          const sres  = await fetch(`${CTX}/session.do`);
          const sdata = await sres.json();

          if (!sdata.loggedIn) {
            alert("로그인한 회원만 리뷰를 작성할 수 있습니다.");
            location.href = `${CTX}/login.do?returnUrl=${encodeURIComponent(location.href)}`;
            return;
          }

		    await loadUtil(`${CTX}/board/reviewWrite.do`, menuContent,
		      (typeof reviewWritePro === "function" ? reviewWritePro : null)
		    );
		    boardScreen = "REVIEW_WRITE";
		    break;
		  }

        // : 목록 fragment
		  await loadUtil(`${CTX}/boardReviewFrag.do`, menuContent, boardReviewPro);
		  boardScreen = "REVIEW_LIST";
		  break;
		}

      default:
        location.hash = "#home";
        break;
    }

  } finally {
    boardRouteRunning = false;
  }
};


/* =========================================================
 * 2. Home Logic (boardHomePro)
 * - 라우터가 호출하는 실제 기능 함수입니다.
 * ========================================================= */

var boardHomePro = function () {

  homeCurrentPage = 1;

  // ===== 1) 홈 전용 폼 준비(없으면 생성) =====
  let f = document.querySelector("#homeF");
  if (!f) {
    f = document.createElement("form");
    f.id = "homeF";
    f.style.display = "none"; 

    const section = document.querySelector("#boardSection") || document.body;
    section.appendChild(f);
  }

  // ✅ 핵심: input[name=page]는 "있으면 재사용 / 없으면 생성"
  let pageInp = f.querySelector('input[name="page"]');
  if (!pageInp) {
    pageInp = document.createElement("input");
    pageInp.type = "hidden";
    pageInp.name = "page";
    pageInp.value = "1";
    f.appendChild(pageInp);
  }

  // ===== (추가) 검색조건 input도 homeF(hidden form)에 "항상" 존재하도록 보장 =====
  // 존재이유: fn_homeListServer가 FormData(homeF)로 쿼리스트링을 만들기 때문에,
  //          검색값이 homeF에 들어있어야만 서버로 같이 전달된다.
  let stypeInp = f.querySelector('input[name="stype"]');
  if (!stypeInp) {
    stypeInp = document.createElement("input");
    stypeInp.type = "hidden";
    stypeInp.name = "stype";     // 서버(SearchVO)가 받는 파라미터명
    stypeInp.value = "";         // 검색 전 기본값
    f.appendChild(stypeInp);
  }

  let swordInp = f.querySelector('input[name="sword"]');
  if (!swordInp) {
    swordInp = document.createElement("input");
    swordInp.type = "hidden";
    swordInp.name = "sword";     // 서버(SearchVO)가 받는 파라미터명
    swordInp.value = "";         // 검색 전 기본값
    f.appendChild(swordInp);
  }

  
  
  // ===== 2) submit 이벤트: 서버 호출은 오직 여기서만 =====
  f.onsubmit = function (e) {
    e.preventDefault();
    fn_homeListServer();
  };

  // ===== 3) 페이지 이동 헬퍼 =====
  const goPage = function (p) {
    const page = Number(p);
    if (!Number.isFinite(page) || page < 1) return;

    homeCurrentPage = page;
    pageInp.value = String(homeCurrentPage);

    f.requestSubmit();
  };

  
  
  
  // ===== (추가) 홈 검색 폼 submit 처리 =====
  // 존재이유: 사용자가 검색하면 1페이지부터 다시 조회해야 하고,
  //          검색조건(stype/sword)은 hidden form(homeF)에 복사돼야 페이징에도 유지된다.
  const homeSearchF = document.querySelector("#homeSearchF");
  homeSearchF.onsubmit = function (e) {
    e.preventDefault(); // 폼 submit으로 화면 새로고침 되는 걸 막는다(우리는 fetch로 갱신)

    // 화면의 검색값을 hidden input으로 복사
    stypeInp.value = homeSearchF.stype.value; // title|writer|content
    swordInp.value = homeSearchF.sword.value; // 검색어

    // 검색은 무조건 1페이지부터
    goPage(1);
  };

  
  
  // ===== 4) 최초 로딩 =====
  goPage(1);

  // ===== 5) 페이징 클릭(위임) =====
  const elPg = document.querySelector("#homePagelist");
  if (elPg) {
    elPg.onclick = function (e) {
      e.preventDefault();

      const a = e.target.closest("a");
      if (!a) return;

      if (a.id === "prev" || a.id === "next") {
        goPage(a.getAttribute("name") || "1");
        return;
      }

      if (a.classList.contains("pageno")) {
        goPage((a.textContent || "").trim());
      }
    };
  }

  // ===== 6) 행 클릭 → 상세 이동 =====
  const elTbody = document.querySelector("#homeTbody");
  if (elTbody) {
    elTbody.onclick = function (e) {
      const tr = e.target.closest("tr[data-type][data-no]");
      if (!tr) return;

      const type = tr.dataset.type;
      const no   = tr.dataset.no;

      if (type === "NOTICE" || type === "QNA") {
        location.hash = `#qna/view/${no}?page=1`;
        return;
      }

	  if (type === "REVIEW") {
	    e.preventDefault();
	    e.stopPropagation();

	    const hash = `#review/view/${no}`;
	    console.log("[HOME] go review view =", hash);

	    location.hash = hash;

	    // ✅ 어떤 이유로 hashchange가 안 먹어도 라우터 한 번 강제 실행
	    setTimeout(() => {
	      if (typeof routePro === "function") routePro();
	    }, 0);

	    return;
	  }

    };
  }

};


/* =========================================================
 * 3. Event Listeners (실행 트리거)
 * - 가장 마지막에 배치하여 위에서 정의한 모든 함수(routePro, boardHomePro)가
 * 완벽하게 준비된 상태에서 이벤트를 연결합니다.
 * ========================================================= */

// 새로고침하면 뒤에꺼(routePro) 실행
window.addEventListener("DOMContentLoaded", routePro);

// 해시태그 바껴도 뒤에꺼(routePro) 실행
window.addEventListener("hashchange", routePro);