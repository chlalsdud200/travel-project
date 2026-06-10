/**
 * boardqnaevent.js
 * - fragment 주입 직후 실행되는 콜백: boardQnaPro()
 * - 요소 찾기/이벤트 바인딩은 여기서만
 * - 서버 호출(fetch)은 submit 흐름에서만 (qnaF.requestSubmit → onsubmit에서 fn_qnaListServer 호출)
 */

var qna_view_no;
var qna_edit_no;

// 라우터가 requestSubmit으로 태울 때만 true로 올렸다가, submit에서 다시 false로 내린다.
var qna_from_router = false;

/* ===== 라우팅용: 현재 목록 hash 만들기 (page + 검색조건) ===== */
var fn_qnaMakeListHash = function (page) {
  const fd = new FormData(qnaF);
  fd.set("page", page);
  const qs = new URLSearchParams(fd).toString();
  return "#qna?" + qs;
};

/**
 * boardQnaPro
 * - QNA 목록 fragment(board_qna_frag.jsp) 주입 직후 실행
 */
var boardQnaPro = function () {

  /* ===== 요소 ===== */
  qnaF = document.querySelector("#qnaSearchF");
  qnaTbody = document.querySelector("#qnaTbody");
  qnaPagelist = document.querySelector("#qnaPagelist");
  qnaTotalCount = document.querySelector("#qnaTotalCount");
  const btnWrite = document.querySelector("#btnQnaWrite");

  /* ===== submit: 서버 호출은 여기서만 =====
   * - 사용자가 Enter/검색버튼으로 submit → hash만 변경(라우터가 requestSubmit로 다시 태움)
   * - 라우터가 requestSubmit로 submit → 여기서 fn_qnaListServer 실행
   */
  qnaF.onsubmit = function (e) {
    e.preventDefault();

    // 사용자가 직접 submit(엔터/검색)한 경우: hash만 바꾸고 끝
    if (!qna_from_router) {
      qna_curPage = 1;
      location.hash = fn_qnaMakeListHash(1);
      return;
    }

    // 라우터가 태운 submit만 여기로 내려온다
    qna_from_router = false;
    fn_qnaListServer(qna_curPage);
  };

  /* ===== 페이지 클릭: hash만 변경 (뒤로/앞으로 기록 남김) ===== */
  qnaPagelist.onclick = function (e) {
    e.preventDefault(); // ★ href="#"가 hash를 "#"로 바꾸는 걸 막는다

    const a = e.target.closest("a");
    if (!a) return;

    let page;

    // PageUtil: prev/next는 id + name 속성
    if (a.id === "prev" || a.id === "next") {
      page = Number(a.getAttribute("name"));
    }

    // PageUtil: 숫자 페이지는 class="pageno" + 텍스트가 번호
    if (a.classList.contains("pageno")) {
      page = Number((a.textContent || "").trim());
    }

    location.hash = fn_qnaMakeListHash(page);
  };



  /* ===== 글쓰기 버튼: 로그인한 사람만 진입 ===== */
  btnWrite.onclick = async function () {

    // 1) 로그인 체크
    const sres = await fetch(`${CTX}/session.do`);
    const sdata = await sres.json();

    if (!sdata.loggedIn) {
      alert("로그인한 회원만 글쓰기가 가능합니다.");
	  location.href = `${CTX}/login.do?returnUrl=${encodeURIComponent(location.href)}`;
      return;
    }

    // 2) 글쓰기 라우트로 전환
    location.hash = `#qna/write?page=${qna_curPage}`;
  };

  /* ===== 목록 행 클릭 → 상세 라우트로 ===== */
  qnaTbody.onclick = function (e) {
    const tr = e.target.closest("tr[data-qna-no]");
    if (!tr) return;

    qna_view_no = Number(tr.dataset.qnaNo);
    location.hash = `#qna/view/${qna_view_no}?page=${qna_curPage}`;
  };
};


/**
 * boardQnaWritePro
 * - QNA 글쓰기 fragment(board_qna_write_frag.jsp) 주입 직후 실행
 */
var boardQnaWritePro = function () {

  const writeF = document.querySelector("#qnaWriteF");
  const btnSubmit = document.querySelector("#btnQnaWriteSubmit");
  const btnCancel = document.querySelector("#btnQnaWriteCancel");

  // 취소 → 진짜 이전 화면으로
  btnCancel.onclick = function () {
    history.back();
  };

  // 등록
  btnSubmit.onclick = function () {
    const fdata = new FormData(writeF);
    qnaWriteBody = Object.fromEntries(fdata);
    fn_qnaInsertServer();
  };
};


/**
 * boardQnaViewPro
 * - QNA 상세 fragment(board_qna_view_frag.jsp) 주입 직후 실행
 */
var boardQnaViewPro = function () {

  const btnBack = document.querySelector("#btnQnaViewBack");
  const btnDel = document.querySelector("#btnQnaDelete");
  const btnEdit = document.querySelector("#btnQnaEdit");
  const prevBox = document.querySelector("#qnaPrevBox");
  const nextBox = document.querySelector("#qnaNextBox");
  
  
  // ===== 관리자 답변 버튼 바인딩 =====
  // 존재이유: 이벤트 바인딩은 event.js에서만 하기로 한 정책을 유지하면서,
  //           상세 화면에서 ADMIN이 답변 등록/수정/삭제를 수행할 수 있게 하기 위함
  const loginRole = (document.querySelector("#qnaLoginRole")?.value || "");
  const isAdmin = (loginRole === "ADMIN");

  if (isAdmin) {
    const ta = document.querySelector("#qnaAnswerTextarea");
    const btnAnsIns = document.querySelector("#btnQnaAnsInsert");
    const btnAnsUpd = document.querySelector("#btnQnaAnsUpdate");
    const btnAnsDel = document.querySelector("#btnQnaAnsDelete");

    // 답변 등록
    if (btnAnsIns) btnAnsIns.onclick = function () {
      const ans = (ta ? ta.value : "").trim();
      if (!ans) { alert("답변 내용을 입력해주세요."); return; }
      fn_qnaAnswerInsertServer(qna_view_no, ans);
    };

    // 답변 수정
    if (btnAnsUpd) btnAnsUpd.onclick = function () {
      const ans = (ta ? ta.value : "").trim();
      if (!ans) { alert("답변 내용을 입력해주세요."); return; }
      fn_qnaAnswerUpdateServer(qna_view_no, ans);
    };

    // 답변 삭제
    if (btnAnsDel) btnAnsDel.onclick = function () {
      if (!confirm("답변을 삭제할까요?")) return;
      fn_qnaAnswerDeleteServer(qna_view_no);
    };
  }

// 이전글
  prevBox.onclick = function () {
    const no = prevBox.dataset.qnaNo;
    location.hash = `#qna/view/${no}?page=${qna_curPage}`;
  };
  
  // 다음글
  nextBox.onclick = function () {
    const no = nextBox.dataset.qnaNo;
    location.hash = `#qna/view/${no}?page=${qna_curPage}`;
  };
  
  
  btnBack.onclick = function () {
    // 마지막으로 보고 있던 QNA 목록 해시로 돌아가야 "목록으로"가 된다
    // prev/next로 상세를 이동해도 목록 상태(검색어/페이지)를 유지하려고 저장해둔 값이 window.QNA_LAST_LIST_HASH
    const backHash = window.QNA_LAST_LIST_HASH || `#qna?page=${qna_curPage}`;

    // 뒤로가기 스택을 늘리지 않고(=history.back처럼 꼬이지 않게) 주소를 목록 해시로 바꾼다
    history.replaceState(null, "", backHash);

    // 해시에 맞는 화면(QNA_LIST)을 다시 렌더링한다
    routePro();
  };

  // 수정 화면으로 
   btnEdit.onclick = function () {
     location.hash = `#qna/edit/${qna_view_no}?page=${qna_curPage}`;
   };
  	
  // ✅ 삭제
  btnDel.onclick = function () {
    if (!confirm("정말 삭제할까요?")) return;
    fn_qnaDeleteServer(qna_view_no);
  };

  fn_qnaViewServer(qna_view_no);
  
  qnaReplyInit();  // *************************댓글 초기화!!!!!!!!!!!!!!!!!!!!!!!!!!!!
};

// 수정
var boardQnaEditPro = function () {

  const editF = document.querySelector("#qnaEditF");
  const btnSubmit = document.querySelector("#btnQnaEditSubmit");
  const btnCancel = document.querySelector("#btnQnaEditCancel");

  btnCancel.onclick = function () {
    history.back();
  };

  btnSubmit.onclick = function () {
    const fdata = new FormData(editF);
    qnaUpdateBody = Object.fromEntries(fdata);
    qnaUpdateBody.qnaNo = Number(qnaUpdateBody.qnaNo);
    
		fn_qnaUpdateServer();
  };

  fn_qnaEditLoadServer(qna_edit_no);
};
