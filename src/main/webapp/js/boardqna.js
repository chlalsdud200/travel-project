/**
 * boardqna.js
 * - 게시판 관련 서버 통신(Fetch) 및 화면 렌더링 로직
 * - 구조: 전역변수 -> 목록 -> 상세 -> 게시글 작성/수정/삭제 -> 답변 관리
 */

/* ==============================================================================
 * [1] 전역 변수 및 상태 관리
 * ============================================================================== */
var qna_curPage = 1;
var qnaF;          // 의미: 검색/페이징 조건을 담는 form / 존재이유: 페이지 이동 시 조건 유지
var qnaTbody;      // 의미: 목록 테이블 tbody / 존재이유: 목록 HTML을 여기로 렌더링
var qnaPagelist;   // 의미: 페이징 영역 / 존재이유: 서버가 준 pglist HTML을 여기로 넣음
var qnaTotalCount; // 의미: 총 게시물 수 표시 영역 / 존재이유: 현재 조건의 총 개수를 화면에 표시

// ✅ 중요: "번호 공백(예: 103 다음 106)"을 없애기 위한 화면용 번호 계산에 사용
var QNA_PER_LIST = 10; // 의미: 한 페이지에 보여주는 일반글 개수 / 존재이유: totalCount로 순번 계산 시 필요(서버 perList=10과 맞춰야 함)


/* ==============================================================================
 * [2] 목록 조회 및 렌더링 (List)
 * ============================================================================== */

/**
 * [서버 호출] 목록 데이터 조회
 * - page 번호를 받아 검색 조건과 함께 서버로 전송
 * - 결과 수신 후 목록 및 페이징 렌더링 함수 호출
 */
const fn_qnaListServer = async (page) => {
  const fd = new FormData(qnaF); // 의미: 검색폼의 현재 조건을 그대로 가져옴 / 존재이유: 페이지 이동해도 검색조건 유지
  fd.set("page", page);          // 의미: 서버에 요청할 페이지 지정 / 존재이유: 페이징 이동을 서버가 알게 함

  const qs = new URLSearchParams(fd).toString(); // 의미: form데이터를 querystring으로 변환 / 존재이유: GET 호출 간단화
  const res = await fetch(`${CTX}/board/qnaData.do?${qs}`); // 의미: 목록 API 호출 / 존재이유: 서버에서 목록 JSON 받기
  const data = await res.json();

  qna_curPage = page; // 의미: 현재 페이지 상태 저장 / 존재이유: 수정 후 돌아가기 등에서 페이지 유지

  // 의미: 총 개수 표시 / 존재이유: 번호(순번) 계산도 totalCount 기반이라 화면/로직 모두에서 필요
  if (qnaTotalCount) qnaTotalCount.innerText = data.totalCount;

  // ✅ 핵심: totalCount와 page를 넘겨서 "화면 번호(순번)"를 계산해 공백 제거
  fn_qnaRenderList(data.notices, data.list, data.totalCount, page);

  // 의미: 서버가 만든 페이징 HTML 반영 / 존재이유: 프론트에서 페이지 버튼을 직접 구성하지 않기
  fn_qnaRenderPage(data.pglist);
};

/**
 * [렌더링] 게시글 목록 테이블 그리기
 * - 공지사항(notices)과 일반 게시글(list)을 구분하여 출력
 * - 데이터가 없을 경우 '데이터가 없습니다' 메시지 출력
 */
const fn_qnaRenderList = (notices, list, totalCount, page) => {
  const hasNotice = (notices && notices.length > 0);
  const hasList = (list && list.length > 0);

  // 의미: 공지/일반 모두 없을 때 처리 / 존재이유: 빈 화면 방지
  if (!hasNotice && !hasList) {
    qnaTbody.innerHTML = `<tr><td colspan="6" class="text-center text-muted fw-bold py-4">데이터가 없습니다.</td></tr>`;
    return;
  }

  let html = "";

  // 1) 공지사항 렌더링 (공지사항은 번호 대신 "공지사항" 뱃지)
  if (hasNotice) {
    for (const v of notices) {
      const writerClass = (v.writerRole === "ADMIN") ? "text-danger fw-bold" : "";
      html +=
        `<tr class="notice-row" data-qna-no="${v.qnaNo}">
          <td><span class="notice-badge">공지사항</span></td>
          <td class="fw-bold notice-title">${v.qnaTitle}</td>
          <td class="${writerClass}">${v.writerName || v.userId}</td>
          <td>${v.createdAt}</td>
          <td>-</td>
          <td>-</td>
        </tr>`;
    }
  }

  // 2) 일반 게시글 렌더링
  if (hasList) {
    // ✅ 핵심 계산
    // 의미: 현재 페이지 첫 줄의 "화면 번호(순번)" 시작값
    // 존재이유: DB의 qnaNo(예: 106,103...)는 삭제로 공백이 생기지만,
    //         화면 번호는 totalCount 기반으로 104,103,102...처럼 공백 없이 보이게 만들기 위함
    const startNo = totalCount - ((page - 1) * QNA_PER_LIST);

    for (let i = 0; i < list.length; i++) {
      const v = list[i];

      // 의미: 각 행의 화면용 번호(순번)
      // 존재이유: 예) 103 다음 106처럼 보이는 공백을 없애고, 103 다음 104로 "보이게" 만들기
      const viewNo = startNo - i;

      const writerClass = (v.writerRole === "ADMIN") ? "text-danger fw-bold" : "";
      const statusHtml = (v.qnaStatus === "WAIT")
        ? `<span class="badge bg-secondary bg-opacity-10 text-secondary px-2 py-1 rounded-3">답변대기</span>`
        : `<span class="badge bg-success bg-opacity-10 text-success px-2 py-1 rounded-3">답변완료</span>`;

      // ✅ 매우 중요:
      // - 화면 표시 번호: viewNo (공백 제거)
      // - 실제 글 식별/상세 이동: data-qna-no에 v.qnaNo 유지 (상세/수정/삭제/답변 기능 절대 안 깨짐)
      html +=
        `<tr data-qna-no="${v.qnaNo}">
          <td>${viewNo}</td>
          <td class="fw-bold">${v.qnaTitle}</td>
          <td class="${writerClass}">${v.writerName || v.userId}</td>
          <td>${v.createdAt}</td>
          <td>${v.hit}</td>
          <td>${statusHtml}</td>
        </tr>`;
    }
  }

  qnaTbody.innerHTML = html;
};

/**
 * [렌더링] 페이징 HTML 주입
 */
const fn_qnaRenderPage = (pglistHtml) => {
  if (qnaPagelist) qnaPagelist.innerHTML = pglistHtml;
};


/* ==============================================================================
 * [3] 상세 조회 및 렌더링 (View)
 * ============================================================================== */

/**
 * [서버 호출] 상세 데이터 조회
 * - 게시글 정보, 이전글/다음글 정보를 가져옴
 */
const fn_qnaViewServer = async (qnaNo) => {
  const res = await fetch(`${CTX}/board/qnaViewData.do?qnaNo=${qnaNo}`);
  const data = await res.json();

  fn_qnaRenderView(data.vo);                  // 의미: 본문 렌더링 / 존재이유: 상세화면 값 표시
  fn_qnaRenderAnswer(data.vo);                // 의미: 답변 영역 렌더링 / 존재이유: 관리자/유저 답변 처리
  fn_qnaRenderPrevNext(data.prev, data.next); // 의미: 이전/다음글 렌더링 / 존재이유: 네비게이션 제공
};

/**
 * [렌더링] 상세 본문 정보 표시
 * - 제목, 작성자, 작성일, 내용, 수정/삭제 버튼 제어
 * - DOM 로딩 타이밍 이슈 방지를 위해 requestAnimationFrame 재시도 포함
 */
const fn_qnaRenderView = (vo, tryCnt = 0) => {
  const elTitle = document.querySelector("#qnaViewTitle");
  if (!elTitle) {
    if (tryCnt < 20) {
      requestAnimationFrame(() => fn_qnaRenderView(vo, tryCnt + 1));
      return;
    }
    return;
  }

  elTitle.innerText = vo.qnaTitle;

  const elWriter = document.querySelector("#qnaViewWriter");
  if (elWriter) {
    elWriter.innerText = (vo.writerName || vo.userId);
    elWriter.classList.toggle("text-danger", vo.writerRole === "ADMIN");
    elWriter.classList.toggle("fw-bold", vo.writerRole === "ADMIN");
  }

  const elCreated = document.querySelector("#qnaViewCreated");
  if (elCreated) elCreated.innerText = vo.createdAt;

  const elHit = document.querySelector("#qnaViewHit");
  if (elHit) elHit.innerText = vo.hit;

  const elContent = document.querySelector("#qnaViewContent");
  if (elContent) elContent.innerText = vo.qnaCtt;

  const elStatus = document.querySelector("#qnaViewStatus");
  const elStatusRow = elStatus ? elStatus.parentElement : null;

  if (vo.isNotice === "Y") {
    if (elStatusRow) elStatusRow.style.display = "none";
  } else {
    if (elStatusRow) elStatusRow.style.display = "flex";
    if (elStatus) elStatus.innerText = (vo.qnaStatus === "WAIT") ? "답변대기" : "답변완료";
  }

  const loginId = document.querySelector("#qnaLoginId")?.value || "";
  const btnEdit = document.querySelector("#btnQnaEdit");
  const btnDel = document.querySelector("#btnQnaDelete");
  const mine = (loginId === vo.userId);

  if (btnEdit) btnEdit.style.display = mine ? "inline-flex" : "none";
  if (btnDel) btnDel.style.display = mine ? "inline-flex" : "none";
};

/**
 * [렌더링] 이전글 / 다음글 네비게이션
 */
const fn_qnaRenderPrevNext = (prev, next) => {
  const prevBox = document.querySelector("#qnaPrevBox");
  const nextBox = document.querySelector("#qnaNextBox");

  const setBox = (box, data, prefix) => {
    if (!box) return;
    if (!data) {
      box.style.display = "none";
      return;
    }
    box.style.display = "grid";
    box.dataset.qnaNo = data.qnaNo;
    document.querySelector(`#${prefix}No`).innerText = data.qnaNo;
    document.querySelector(`#${prefix}Title`).innerText = data.qnaTitle;

    const elWriter = document.querySelector(`#${prefix}Writer`);
    elWriter.innerText = (data.writerName || data.userId);
    elWriter.classList.toggle("text-danger", data.writerRole === "ADMIN");
    elWriter.classList.toggle("fw-bold", data.writerRole === "ADMIN");

    const elStatus = document.querySelector(`#${prefix}Status`);
    if (data.isNotice === "Y") {
      elStatus.style.display = "none";
    } else {
      elStatus.style.display = "inline-block";
      elStatus.innerText = (data.qnaStatus === "WAIT") ? "답변대기" : "답변완료";
    }
  };

  setBox(prevBox, prev, "qnaPrev");
  setBox(nextBox, next, "qnaNext");
};


/* ==============================================================================
 * [4] 질문글(User) 등록 / 수정 / 삭제
 * ============================================================================== */

const fn_qnaInsertServer = async () => {
  try {
    const resp = await fetch(`${CTX}/board/qnaWrite.do`, {
      method: "post",
      headers: { "content-type": "application/json;charset=utf-8" },
      body: JSON.stringify(qnaWriteBody)
    });
    const datas = await resp.json();

    if (datas.flag === "ok") {
      alert("등록 완료");
      const backHash = window.QNA_LAST_LIST_HASH || "#qna?page=1";
      history.replaceState(null, "", backHash);
      routePro();
    } else if (datas.flag === "login") {
      alert("로그인한 회원만 글쓰기가 가능합니다.");
      location.href = `${CTX}/login.do`;
    } else {
      alert("저장 실패");
    }
  } catch (err) { console.log(err); }
};

const fn_qnaEditLoadServer = async (qnaNo) => {
  const res = await fetch(`${CTX}/board/qnaEditData.do?qnaNo=${qnaNo}`);
  const data = await res.json();
  const vo = data.vo;

  document.querySelector("#qnaEditNo").value = vo.qnaNo;
  document.querySelector("#qnaEditTitle").value = vo.qnaTitle;
  document.querySelector("#qnaEditContent").value = vo.qnaCtt;
};

const fn_qnaUpdateServer = async () => {
  const resp = await fetch(`${CTX}/board/qnaUpdate.do`, {
    method: "post",
    headers: { "content-type": "application/json;charset=utf-8" },
    body: JSON.stringify(qnaUpdateBody)
  });
  const datas = await resp.json();

  if (datas.flag === "ok") {
    alert("수정 완료");
    location.hash = `#qna/view/${qnaUpdateBody.qnaNo}?page=${qna_curPage}`;
  } else if (datas.flag === "login") {
    alert("로그인한 회원만 수정할 수 있습니다.");
    location.href = `${CTX}/login.do`;
  } else {
    alert("수정 실패");
  }
};

const fn_qnaDeleteServer = async (qnaNo) => {
  try {
    const resp = await fetch(`${CTX}/board/qnaDelete.do`, {
      method: "post",
      headers: { "content-type": "application/json;charset=utf-8" },
      body: JSON.stringify({ qnaNo: qnaNo })
    });
    const datas = await resp.json();

    if (datas.flag === "ok") {
      alert("삭제 완료");
      history.replaceState(null, "", window.QNA_LAST_LIST_HASH);
      routePro();
    } else if (datas.flag === "login") {
      alert("로그인한 회원만 삭제할 수 있습니다.");
      location.href = `${CTX}/login.do`;
    } else {
      alert("삭제 실패");
    }
  } catch (err) { console.log(err); }
};


/* ==============================================================================
 * [5] 답변(Admin) 렌더링 / 등록 / 수정 / 삭제
 * ============================================================================== */

const fn_qnaRenderAnswer = (vo) => {
  const wrap = document.querySelector("#qnaAnswerWrap");
  if (!wrap) return;

  if (vo.isNotice === "Y") {
    wrap.style.display = "none";
    return;
  }

  const loginRole = (document.querySelector("#qnaLoginRole")?.value || "");
  const isAdmin = (loginRole === "ADMIN");

  const rawAns = String(vo.ansCtt || "").trim();
  const hasAnswer = (vo.ansCtt != null && rawAns !== "");

  if (!isAdmin && !hasAnswer) {
    wrap.style.display = "none";
    return;
  }

  wrap.style.display = "block";

  const elAt = document.querySelector("#qnaAnswerAt");
  const viewBox = document.querySelector("#qnaAnswerView");
  const viewText = document.querySelector("#qnaAnswerText");
  const editor = document.querySelector("#qnaAnswerEditor");
  const ta = document.querySelector("#qnaAnswerTextarea");

  const btnIns = document.querySelector("#btnQnaAnsInsert");
  const btnUpd = document.querySelector("#btnQnaAnsUpdate");
  const btnDel = document.querySelector("#btnQnaAnsDelete");

  if (elAt) elAt.innerText = (hasAnswer && vo.ansAt) ? `답변일 ${vo.ansAt}` : "";

  if (isAdmin) {
    if (viewBox) viewBox.style.display = "none";
  } else {
    if (viewBox) {
      viewBox.style.display = "block";
      viewBox.style.cssText = `
          display: block !important;
          width: 100% !important;
          height: fit-content !important; 
          min-height: 0 !important;
          background-color: #eff6ff !important;
          border: 1px solid #bfdbfe !important;
          border-radius: 8px !important;
          padding: 20px !important;
          margin-top: 10px !important;
          overflow: visible !important;
      `;
    }
    if (viewText) {
      viewText.innerText = rawAns;
      viewText.style.cssText = `
          white-space: pre-wrap !important;
          color: #1e3a8a !important;
          font-weight: 500 !important;
          font-size: 15px !important;
          line-height: 1.6 !important;
      `;
    }
  }

  if (editor) {
    editor.style.display = isAdmin ? "block" : "none";
  }

  if (isAdmin) {
    if (ta) ta.value = hasAnswer ? rawAns : "";

    if (btnIns) btnIns.style.display = hasAnswer ? "none" : "inline-block";
    if (btnUpd) btnUpd.style.display = hasAnswer ? "inline-block" : "none";
    if (btnDel) btnDel.style.display = hasAnswer ? "inline-block" : "none";

    if (ta) {
      const setReadMode = () => {
        ta.style.backgroundColor = "#e2e8f0";
        ta.style.border = "1px solid #e2e8f0";
        ta.style.color = "#64748b";
        ta.style.boxShadow = "none";
      };

      const setEditMode = () => {
        ta.style.backgroundColor = "#ffffff";
        ta.style.border = "2px solid #3b82f6";
        ta.style.color = "#0f172a";
        ta.style.boxShadow = "0 4px 6px -1px rgba(0, 0, 0, 0.1)";
      };

      if (hasAnswer) setReadMode();
      else setEditMode();

      ta.onfocus = setEditMode;

      const autoResize = () => {
        ta.style.height = "auto";
        ta.style.height = (ta.scrollHeight) + "px";
      };
      setTimeout(autoResize, 0);
      ta.oninput = autoResize;
    }
  }
};

const fn_qnaAnswerInsertServer = async (qnaNo, ansCtt) => {
  try {
    const resp = await fetch(`${CTX}/board/qnaAnswerInsert.do`, {
      method: "post",
      headers: { "content-type": "application/json;charset=utf-8" },
      body: JSON.stringify({ qnaNo: qnaNo, ansCtt: ansCtt })
    });
    const datas = await resp.json();

    if (datas.flag === "ok") {
      alert("답변 등록 완료");
      fn_qnaRenderView(datas.vo);
      fn_qnaRenderAnswer(datas.vo);
    } else if (datas.flag === "login") {
      alert("로그인 후 이용해주세요.");
      location.href = `${CTX}/login.do`;
    } else if (datas.flag === "forbidden") {
      alert("관리자만 답변을 등록할 수 있습니다.");
    } else {
      alert("답변 등록 실패");
    }
  } catch (err) { console.log(err); }
};

const fn_qnaAnswerUpdateServer = async (qnaNo, ansCtt) => {
  try {
    const resp = await fetch(`${CTX}/board/qnaAnswerUpdate.do`, {
      method: "post",
      headers: { "content-type": "application/json;charset=utf-8" },
      body: JSON.stringify({ qnaNo: qnaNo, ansCtt: ansCtt })
    });
    const datas = await resp.json();

    if (datas.flag === "ok") {
      alert("답변 수정 완료");
      fn_qnaRenderView(datas.vo);
      fn_qnaRenderAnswer(datas.vo);
    } else if (datas.flag === "login") {
      alert("로그인 후 이용해주세요.");
      location.href = `${CTX}/login.do`;
    } else if (datas.flag === "forbidden") {
      alert("관리자만 답변을 수정할 수 있습니다.");
    } else {
      alert("답변 수정 실패");
    }
  } catch (err) { console.log(err); }
};

const fn_qnaAnswerDeleteServer = async (qnaNo) => {
  try {
    const resp = await fetch(`${CTX}/board/qnaAnswerDelete.do`, {
      method: "post",
      headers: { "content-type": "application/json;charset=utf-8" },
      body: JSON.stringify({ qnaNo: qnaNo })
    });
    const datas = await resp.json();

    if (datas.flag === "ok") {
      alert("답변 삭제 완료");
      fn_qnaRenderView(datas.vo);
      fn_qnaRenderAnswer(datas.vo);
    } else if (datas.flag === "login") {
      alert("로그인 후 이용해주세요.");
      location.href = `${CTX}/login.do`;
    } else if (datas.flag === "forbidden") {
      alert("관리자만 답변을 삭제할 수 있습니다.");
    } else {
      alert("답변 삭제 실패");
    }
  } catch (err) { console.log(err); }
};
