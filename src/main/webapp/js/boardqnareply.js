/**
 * boardqnareply.js
 * - QNA 댓글 이벤트 바인딩 + 서버 통신
 * - boardQnaViewPro()에서 호출: qnaReplyInit()
 */

// 댓글 객체 (등록 시 사용)
let qnaReply = {};

// ✅ HTML escape: 댓글 내용에 < > 들어가도 화면 깨지지 않게
const escHtml = function (s) {
  return String(s ?? "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#39;");
};

/**
 * qnaReplyInit
 * - QNA 상세 화면 로드 시 댓글 이벤트 초기화
 */
const qnaReplyInit = function() {

  const btnReplySubmit = document.querySelector("#btnQnaReplySubmit");
  const replyTextarea = document.querySelector("#qnaReplyTextarea");
  const replyList = document.querySelector("#qnaReplyList");

  // ✅ 로그인 상태에 따라 placeholder 변경
  const loginId = document.querySelector("#qnaLoginId")?.value || "";
  if (replyTextarea) {
    replyTextarea.placeholder = loginId
      ? "댓글을 입력해주세요"
      : "댓글을 입력해주세요 (로그인 필요)";
  }

  // 댓글 등록 버튼 클릭
  if (btnReplySubmit) {
    btnReplySubmit.onclick = async function() {

      // 로그인 체크
      const loginId = document.querySelector("#qnaLoginId")?.value || "";

      if (!loginId) {
        const tempReply = (replyTextarea?.value || "").trim();
        if (tempReply) {
          localStorage.setItem("qna_temp_reply", tempReply);
          localStorage.setItem("qna_temp_reply_no", qna_view_no);
        }

        if (confirm("로그인이 필요합니다. 로그인 페이지로 이동하시겠습니까?")) {
          const currentUrl = encodeURIComponent(location.href);
          location.href = `${CTX}/login.do?returnUrl=${currentUrl}`;
        }
        return;
      }

      // 댓글 내용 체크
      const reCtt = (replyTextarea?.value || "").trim();
      if (!reCtt) {
        alert("댓글 내용을 입력해주세요.");
        replyTextarea.focus();
        return;
      }

      // 댓글 객체 생성
      qnaReply = {
        qnaNo: qna_view_no,
        userId: loginId,
        reCtt: reCtt
      };

      // 서버로 전송
      await fn_qnaReplyInsertServer();

      // 입력창 초기화
      replyTextarea.value = "";
    };
  }

  // 댓글 목록 영역 이벤트 위임 (수정/삭제 버튼)
  if (replyList) {
    replyList.onclick = async function(e) {
      const target = e.target;
      const loginId = document.querySelector("#qnaLoginId")?.value || "";

      // 삭제 버튼
      if (target.classList.contains("btn-reply-delete")) {
        const reNum = target.dataset.reNum;

        // ✅ 이미 소프트삭제된 댓글이면 두 번째 클릭 = 물리삭제
        const isDeleted = (target.dataset.deleted === "1");

        const msg = isDeleted
          ? "이미 삭제된 댓글입니다. DB에서 완전 삭제할까요?"
          : "댓글을 삭제하시겠습니까?";

        if (!confirm(msg)) return;

        await fn_qnaReplyDeleteServer(reNum, isDeleted);
        return;
      }

      // 수정 버튼
      if (target.classList.contains("btn-reply-update")) {
        const reNum = target.dataset.reNum;
        const replyItem = target.closest(".reply-item");
        const contentDiv = replyItem.querySelector(".reply-content");

        // 수정 모드 전환
        let currentText = contentDiv.textContent.trim();

        // ✅ [ADMIN_EDITED] 마커 제거: 사용자가 재수정 시 마커 제거
        currentText = currentText.replace(/^\[ADMIN_EDITED\]\s*/i, "").trim();

        contentDiv.innerHTML = `
          <textarea class="form-control form-control-sm reply-edit-textarea" rows="2">${escHtml(currentText)}</textarea>
          <div class="d-flex gap-1 mt-2">
            <button class="btn btn-sm btn-success btn-reply-save" data-re-num="${reNum}">저장</button>
            <button class="btn btn-sm btn-secondary btn-reply-cancel">취소</button>
          </div>
        `;
        return;
      }

      // 수정 저장 버튼
      if (target.classList.contains("btn-reply-save")) {
        const reNum = target.dataset.reNum;
        const textarea = target.closest(".reply-content").querySelector(".reply-edit-textarea");
        const newCtt = (textarea?.value || "").trim();

        if (!newCtt) {
          alert("댓글 내용을 입력해주세요.");
          return;
        }

        await fn_qnaReplyUpdateServer(reNum, newCtt);
        return;
      }

      // 수정 취소 버튼
      if (target.classList.contains("btn-reply-cancel")) {
        await fn_qnaReplyListServer();
        return;
      }

      // 답글 버튼 클릭
      if (target.classList.contains("btn-reply-reply")) {
        const parentReNum = target.dataset.reNum;
        const replyItem = target.closest(".reply-item");

        // 이미 답글창이 있으면 제거
        const existingForm = document.querySelector(".nested-reply-form");
        if (existingForm) existingForm.remove();

        // 답글 입력창 생성
        const nestedForm = `
          <div class="nested-reply-form ms-5 mt-2 p-3" style="background-color:#f8fafc; border-radius:8px;">
            <textarea class="form-control form-control-sm nested-reply-textarea" rows="2" placeholder="답글을 입력하세요"></textarea>
            <div class="d-flex gap-1 justify-content-end mt-2">
              <button class="btn btn-sm btn-primary btn-nested-submit" data-parent-re-num="${parentReNum}">답글 등록</button>
              <button class="btn btn-sm btn-secondary btn-nested-cancel">취소</button>
            </div>
          </div>
        `;

        replyItem.insertAdjacentHTML('afterend', nestedForm);

        const textarea = document.querySelector(".nested-reply-textarea");
        if (textarea) textarea.focus();
        return;
      }

      // 답글 등록 버튼
      if (target.classList.contains("btn-nested-submit")) {
        const parentReNum = target.dataset.parentReNum;
        const textarea = document.querySelector(".nested-reply-textarea");
        const reCtt = (textarea?.value || "").trim();

        if (!reCtt) {
          alert("답글 내용을 입력해주세요.");
          return;
        }

        qnaReply = {
          qnaNo: qna_view_no,
          userId: loginId,
          parentReNum: parseInt(parentReNum, 10),
          reCtt: reCtt
        };

        await fn_qnaReplyInsertServer();
        document.querySelector(".nested-reply-form")?.remove();
        return;
      }

      // 답글 취소 버튼
      if (target.classList.contains("btn-nested-cancel")) {
        document.querySelector(".nested-reply-form")?.remove();
        return;
      }
    };
  }

  // 최초 댓글 목록 로드
  fn_qnaReplyListServer();

  const tempReply = localStorage.getItem("qna_temp_reply");
  const tempReplyNo = localStorage.getItem("qna_temp_reply_no");

  if (tempReply && tempReplyNo == qna_view_no) {
    const replyTextarea2 = document.querySelector("#qnaReplyTextarea");
    if (replyTextarea2) {
      replyTextarea2.value = tempReply;
      replyTextarea2.focus();
    }
    localStorage.removeItem("qna_temp_reply");
    localStorage.removeItem("qna_temp_reply_no");
  }
};


/**
 * fn_qnaReplyListServer
 * - 댓글 목록 조회
 */
const fn_qnaReplyListServer = async function() {
  try {
    const resp = await fetch(`${CTX}/qnaReplyList.do?qnaNo=${qna_view_no}`);
    const data = await resp.json();

    console.log("댓글 목록:", data);

    if (!data.list) {
      console.error("댓글 목록 조회 실패");
      return;
    }

    const replyList = data.list;

    const loginId = document.querySelector("#qnaLoginId")?.value || "";
    const loginRole = document.querySelector("#qnaLoginRole")?.value || "";
    const isAdminViewer = /^(ADMIN|A)$/.test(String(loginRole || "").trim().toUpperCase());
    const loginName = document.querySelector("#qnaLoginName")?.value || "";

    // 댓글 개수 업데이트
    const replyCount = document.querySelector("#qnaReplyCount");
    if (replyCount) replyCount.textContent = replyList.length;

    // 댓글 목록 HTML 생성
    const replyListDiv = document.querySelector("#qnaReplyList");
    if (!replyListDiv) return;

    if (replyList.length === 0) {
      replyListDiv.innerHTML = `
        <div class="text-center text-muted py-3" style="font-size:13px;">
          첫 댓글을 작성해보세요!
        </div>
      `;
      return;
    }

    const html = replyList.map(reply => {

      // 대댓글이면 들여쓰기
      const isChild = reply.parentReNum && reply.parentReNum > 0;
      const indentClass = isChild ? "ms-5" : "";

      const writerRole = String(reply.writerRole || "").trim().toUpperCase();
      const isAdminWriter = /^(ADMIN|A)$/.test(writerRole);

      // ✅ 마커 처리
      const rawCtt = String(reply.reCtt || "");
      const isDeletedByAdmin = rawCtt.startsWith("[ADMIN_DELETED]");
      const isEditedByAdmin  = rawCtt.startsWith("[ADMIN_EDITED]");

      let markerBadge = "";
      let showCtt = rawCtt;

      if (isDeletedByAdmin) {
        markerBadge = `<span class="badge bg-danger-subtle text-danger"
                         style="font-size:11px; font-weight:900;">🗑️ 관리자 삭제</span>`;

        if (isAdminViewer) {
          showCtt = rawCtt.replace(/^\[ADMIN_DELETED\]\s*/i, "").trim();
        } else {
          showCtt = "관리자에 의해 삭제된 댓글입니다.";
        }

      } else if (isEditedByAdmin) {
        markerBadge = `<span class="badge bg-warning-subtle text-warning"
                         style="font-size:11px; font-weight:900;">✏️ 관리자 수정</span>`;
        showCtt = rawCtt.replace(/^\[ADMIN_EDITED\]\s*/i, "").trim();
      }

      // ✅ 작성자 표시 규칙
      let nameHtml = `<span class="fw-bold" style="color:#0f172a; font-size:14px;">${escHtml(reply.userId)}</span>`;

      if (isAdminWriter) {
        if (isAdminViewer) {
          // 관리자 본인 댓글이면 로그인 실명 우선
          if (String(reply.userId) === String(loginId) && String(loginName).trim()) {
            nameHtml = `<span class="fw-bold" style="color:#dc2626; font-size:14px;">${escHtml(loginName)}</span>`;
          } else {
            const adminName = (reply.writerName && String(reply.writerName).trim())
              ? reply.writerName
              : reply.userId;
            nameHtml = `<span class="fw-bold" style="color:#dc2626; font-size:14px;">${escHtml(adminName)}</span>`;
          }
        } else {
          // 유저 화면에서는 "👑 관리자" 배지
          nameHtml = `
            <span class="fw-bold"
                  style="
                    display:inline-flex;
                    align-items:center;
                    gap:6px;
                    color:#dc2626;
                    background:rgba(220,38,38,0.08);
                    border:1px solid rgba(220,38,38,0.18);
                    padding:3px 10px;
                    border-radius:999px;
                    font-size:13px;
                  ">👑 관리자</span>
          `;
        }
      }

      // ✅ 버튼 노출 규칙
      // - 관리자: 관리 가능
      // - 유저: 본인 + 삭제아님 + 관리자수정 아님(관리자 수정된 댓글은 유저가 수정 불가)
      let buttons = "";

      const canUserEdit = !!loginId
        && (loginId === reply.userId)
        && !isDeletedByAdmin
        && !isEditedByAdmin;

      const canManage = !!loginId && (isAdminViewer || canUserEdit);

      if (canManage) {
        buttons = `
          <button class="btn btn-sm btn-outline-success btn-reply-update" data-re-num="${reply.reNum}">수정</button>
          <button class="btn btn-sm btn-outline-danger btn-reply-delete"
                  data-re-num="${reply.reNum}"
                  data-deleted="${isDeletedByAdmin ? "1" : "0"}">삭제</button>
        `;
      }

      // 답글 버튼 (대댓글에는 답글 불가, 삭제 마커 댓글에는 답글 불가)
      let replyButton = "";
      if (!isChild && loginId && !isDeletedByAdmin) {
        replyButton = `
          <button class="btn btn-sm btn-outline-primary btn-reply-reply" data-re-num="${reply.reNum}">답글</button>
        `;
      }

      return `
        <div class="reply-item ${indentClass} p-3"
             style="background-color:#fff; border:1px solid rgba(15,23,42,0.08); border-radius:12px;"
             data-reply-id="${reply.reNum}">
          <div class="d-flex justify-content-between align-items-start mb-2">
            <div class="d-flex align-items-center gap-2">
              ${isChild ? '<span style="color:#94a3b8;">↳</span>' : ''}
              ${nameHtml}
              ${markerBadge}
			  <span class="text-muted" style="font-size:12px;">
			    ${escHtml((reply.reUpdate && String(reply.reUpdate).trim()) ? reply.reUpdate : (reply.reCreate || ""))}
			  </span>
            </div>
            <div class="d-flex gap-1">
              ${replyButton}
              ${buttons}
            </div>
          </div>
          <div class="reply-content"
               style="white-space:pre-wrap; color:#334155; font-size:13px; line-height:1.6;">${escHtml(showCtt)}</div>
        </div>
      `;
    }).join("");

    replyListDiv.innerHTML = html;

  } catch (err) {
    console.error("댓글 목록 조회 오류:", err);
  }
};


/**
 * fn_qnaReplyInsertServer
 * - 댓글 등록
 */
const fn_qnaReplyInsertServer = async function() {
  try {
    const resp = await fetch(`${CTX}/qnaReplyInsert.do`, {
      method: "POST",
      headers: { "Content-Type": "application/json;charset=utf-8" },
      body: JSON.stringify(qnaReply)
    });

    const data = await resp.json();
    console.log("댓글 등록 결과:", data);

    if (data.flag === "ok") {
      await fn_qnaReplyListServer();
    } else {
      alert("댓글 등록에 실패했습니다.");
    }

  } catch (err) {
    console.error("댓글 등록 오류:", err);
    alert("댓글 등록 중 오류가 발생했습니다.");
  }
};


/**
 * fn_qnaReplyDeleteServer
 * - 댓글 삭제
 */
const fn_qnaReplyDeleteServer = async function(reNum, forceHardDelete) {
  try {
    const url = forceHardDelete
      ? `${CTX}/qnaReplyDelete.do?reNum=${reNum}&force=1`
      : `${CTX}/qnaReplyDelete.do?reNum=${reNum}`;

    const resp = await fetch(url);
    const data = await resp.json();

    if (data.flag === "ok") {
      await fn_qnaReplyListServer();
    } else {
      alert("댓글 삭제에 실패했습니다.");
    }
  } catch (err) {
    console.error("댓글 삭제 오류:", err);
    alert("댓글 삭제 중 오류가 발생했습니다.");
  }
};


/**
 * fn_qnaReplyUpdateServer
 * - 댓글 수정
 */
const fn_qnaReplyUpdateServer = async function(reNum, reCtt) {
  try {
    const resp = await fetch(`${CTX}/qnaReplyUpdate.do`, {
      method: "POST",
      headers: { "Content-Type": "application/json;charset=utf-8" },
      body: JSON.stringify({ reNum: reNum, reCtt: reCtt })
    });

    const data = await resp.json();
    console.log("댓글 수정 결과:", data);

    if (data.flag === "ok") {
      await fn_qnaReplyListServer();
    } else {
      alert("댓글 수정에 실패했습니다.");
    }

  } catch (err) {
    console.error("댓글 수정 오류:", err);
    alert("댓글 수정 중 오류가 발생했습니다.");
  }
};

window.qnaReplyInit = qnaReplyInit;
