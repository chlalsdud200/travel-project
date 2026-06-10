<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
  /* [1] 뒤로가기 버튼 */
  .btn-back-custom {
    height: 40px;
    padding: 0 16px 0 12px;
    border-radius: 12px;
    border: 1px solid rgba(15, 23, 42, 0.12);
    background: #fff;
    color: rgba(15, 23, 42, 0.75);
    font-size: 13px;
    font-weight: 800;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    transition: all 0.2s ease;
    box-shadow: 0 2px 4px rgba(15, 23, 42, 0.03);
    cursor: pointer;
  }
  .btn-back-custom:hover {
    background: rgba(15, 23, 42, 0.03);
    border-color: rgba(15, 23, 42, 0.3);
    color: #0f172a;
    transform: translateY(-2px);
    box-shadow: 0 6px 12px rgba(15, 23, 42, 0.08);
  }
  .btn-back-custom:active {
    transform: translateY(0);
    box-shadow: 0 2px 4px rgba(15, 23, 42, 0.03);
  }

  /* [2] 수정/삭제 버튼 스타일 */
  .btn-edit-custom {
    display: none;
    border: 1px solid rgba(37, 99, 235, 0.25);
    color: #2563eb;
    background: #fff;
    border-radius: 999px;
    font-weight: 900;
    padding: 6px 14px;
    font-size: 13px;
    cursor: pointer;
    transition: all 0.2s ease;
  }
  .btn-edit-custom:hover {
    background: #4ade80;
    color: #ffffff;
    border-color: #4ade80;
    box-shadow: 0 4px 12px rgba(74, 222, 128, 0.25);
    transform: translateY(-1px);
  }

  .btn-delete-custom {
    display: none;
    border: 1px solid rgba(220, 38, 38, 0.25);
    color: #dc2626;
    background: #fff;
    border-radius: 999px;
    font-weight: 900;
    padding: 6px 14px;
    font-size: 13px;
    cursor: pointer;
    transition: all 0.2s ease;
  }
  .btn-delete-custom:hover {
    background: #dc2626;
    color: #ffffff;
    border-color: #dc2626;
    box-shadow: 0 4px 12px rgba(220, 38, 38, 0.25);
    transform: translateY(-1px);
  }

  /* [3] 이전글/다음글 커스텀 스타일 (개선판) */
  .nav-post-custom {
    display: none; /* JS 제어 */
    display: grid;
    /* 아이콘 | 라벨(이전/다음) | 제목 | 우측정보(작성자/상태) */
    grid-template-columns: 24px 60px 1fr auto; 
    align-items: center;
    column-gap: 12px;
    
    background: #fff;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    padding: 12px 16px;
    cursor: pointer;
    transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
    text-decoration: none;
    color: inherit;
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
    min-height: 48px;
  }

  /* 호버 효과 */
  .nav-post-custom:hover {
    background-color: #f8fafc;
    border-color: #cbd5e1;
    transform: translateY(-2px);
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  }

  /* 아이콘 영역 */
  .nav-icon {
    color: #94a3b8;
    display: flex;
    justify-content: center;
    transition: color 0.2s;
  }
  .nav-post-custom:hover .nav-icon {
    color: #334155; 
  }

  /* 라벨: 이전글/다음글 (색상 분리) */
  .nav-label {
    font-size: 13px;
    font-weight: 800;
    white-space: nowrap;
  }
  .nav-label.prev { color: #3b82f6; } /* Blue */
  .nav-label.next { color: #6366f1; } /* Indigo */

  /* 제목 */
  .nav-title {
    font-size: 14px;
    font-weight: 700;
    color: #1e293b;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    min-width: 0;
  }
  .nav-post-custom:hover .nav-title {
    color: #0f172a;
    text-decoration: underline;
    text-decoration-color: rgba(15,23,42,0.2);
  }

  /* 우측 정보 영역 */
  .nav-info-wrap {
    display: flex;
    align-items: center;
    gap: 10px; 
    font-size: 13px;
  }

  /* "작성자" 텍스트 라벨 */
  .nav-meta-label {
    color: #94a3b8;
    font-weight: 500;
    margin-right: 2px;
    font-size: 12px;
  }

  /* 작성자 이름 */
  .nav-writer-name {
    color: #475569;
    font-weight: 700;
  }

  /* 상태 배지 */
  .nav-status-badge {
    background-color: #f1f5f9;
    color: #64748b;
    padding: 2px 8px;
    border-radius: 6px;
    font-size: 11px;
    font-weight: 800;
    letter-spacing: -0.02em;
    border: 1px solid #e2e8f0;
  }
</style>

<div class="d-flex justify-content-between align-items-end mb-4">
  <div>
    <div class="fw-bold fs-4" style="letter-spacing:-0.03em; color:#0f172a;">Q&amp;A</div>
    <div class="text-muted small fw-bold" style="opacity:0.8;">문의 상세 내용을 확인하세요</div>
  </div>

  <div class="d-flex align-items-center gap-2">
    <button type="button" class="btn-back-custom" id="btnQnaViewBack">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
        <path d="M15 18l-6-6 6-6"/>
      </svg>
      목록으로
    </button>
  </div>
</div>

<div class="card mb-4" style="border-radius:16px; border:1px solid rgba(15,23,42,0.08); box-shadow:0 10px 30px -10px rgba(0,0,0,0.05);">
  <div class="card-body" style="padding:24px;">

    <div class="mb-3 border-bottom pb-3 d-flex align-items-center justify-content-between"
         style="border-color: rgba(15,23,42,0.06) !important;">

      <div class="fw-bold fs-5" id="qnaViewTitle" style="letter-spacing:-0.01em;">-</div>

      <div class="d-flex align-items-center gap-2">
        <button type="button" id="btnQnaEdit" class="btn-edit-custom">수정</button>
        <button type="button" id="btnQnaDelete" class="btn-delete-custom">삭제</button>
      </div>
    </div>

    <input type="hidden" id="qnaLoginId" value="${sessionScope.loginUser.userId}" />
    <input type="hidden" id="qnaLoginRole" value="${sessionScope.loginUser.role}" />
	
	<input type="hidden" id="qnaLoginName" value="${sessionScope.loginUser.userName}"> <!--관리자실명부분  -->
	
	


    <div class="d-flex flex-wrap gap-3 small mb-4 align-items-center" style="color: rgba(15,23,42,0.6); font-weight: 600;">
      <div class="d-flex align-items-center gap-1">
        <span class="badge bg-light text-dark border" style="font-weight:500;">작성자</span>
        <span id="qnaViewWriter" class="text-dark fw-bold">-</span>
      </div>
      <div class="vr" style="opacity:0.2;"></div>
      <div><span id="qnaViewCreated">-</span></div>
      <div class="vr" style="opacity:0.2;"></div>
      <div>조회 <span id="qnaViewHit">0</span></div>
      <div class="ms-auto">
        <span id="qnaViewStatus" class="badge bg-secondary bg-opacity-10 text-secondary px-2 py-1 rounded-3">-</span>
      </div>
    </div>

    <div class="rounded-3 p-4"
         style="min-height:300px; white-space:pre-wrap; background-color:#f8fafc; color:#334155; line-height:1.7;"
         id="qnaViewContent">-</div>

  </div>
</div>

<div id="qnaAnswerWrap" class="card mb-4"
     style="display:none; 
            border-radius:16px; 
            border:1px solid rgba(15,23,42,0.08); 
            box-shadow:0 10px 30px -10px rgba(0,0,0,0.05);">
  <div class="card-body" style="padding:20px;">

    <div class="d-flex justify-content-between align-items-center mb-2">
      <div class="fw-bold" style="letter-spacing:-0.01em; color:#0f172a;">관리자 답변</div>
      <div class="text-muted small fw-bold" id="qnaAnswerAt">-</div>
    </div>

    <div id="qnaAnswerView" class="rounded-3"
         style="display:none; 
                white-space:pre-wrap; 
                background-color:#eff6ff; /* 연한 파란색 */
                border:1px solid #bfdbfe; /* 파란 테두리 */
                color:#1e3a8a;            /* 진한 파란 글씨 */
                font-weight: 500;
                line-height:1.6; 
                font-size:15px; 
                padding: 20px;            
                height: fit-content !important; /* 내용물만큼만 높이 잡기 */
                min-height: 0 !important;">
         <div id="qnaAnswerText" style="margin:0; padding:0;">-</div>
    </div>

    <div id="qnaAnswerEditor" style="margin-top:15px; display:none;">
      <textarea id="qnaAnswerTextarea"
               class="qna-ans-ta"
               name="ansCtt"
               rows="4"
               style="width:100%; resize:none; overflow-y:hidden; line-height:1.5; padding:15px; border:1px solid #cbd5e1; border-radius:12px; outline:none;"
               placeholder="답변을 입력해주세요"></textarea>

      <div class="d-flex gap-2 justify-content-end mt-2">
        <button type="button" id="btnQnaAnsInsert" class="btn btn-primary btn-sm fw-bold px-3">등록</button>
        <button type="button" id="btnQnaAnsUpdate" class="btn btn-success btn-sm fw-bold px-3">수정</button>
        <button type="button" id="btnQnaAnsDelete" class="btn btn-outline-danger btn-sm fw-bold px-3">삭제</button>
      </div>
    </div>

  </div>
</div>

<!-- ===== 댓글 영역 ===== -->
<div id="qnaReplyWrap" class="card mb-4"
     style="border-radius:16px; border:1px solid rgba(15,23,42,0.08); box-shadow:0 10px 30px -10px rgba(0,0,0,0.05);">
  <div class="card-body" style="padding:20px;">
    
    <!-- 댓글 헤더 -->
    <div class="d-flex justify-content-between align-items-center mb-3">
      <div class="fw-bold" style="letter-spacing:-0.01em; color:#0f172a;">
        댓글 <span id="qnaReplyCount" class="text-primary">0</span>
      </div>
    </div>


    <!-- 댓글 목록 영역 -->
    <div id="qnaReplyList" class="d-flex flex-column gap-2">
      <!-- 댓글이 여기에 동적으로 추가됩니다 -->
    </div>
    <!-- 댓글 작성 영역 (로그인한 사용자만) -->
    <div id="qnaReplyEditor" class="mb-3" style="padding:10px 12px; background-color:#f8fafc; border-radius:12px;">
      <textarea id="qnaReplyTextarea"
                rows="3"
                style="width:100%; resize:none; overflow:hidden; line-height:1.5; padding:10px 12px; border:1px solid rgba(15,23,42,0.12); border-radius:8px;"
                placeholder="댓글을 입력해주세요 (로그인 필요)"></textarea>
      <div class="d-flex justify-content-end mt-2">
        <button type="button" id="btnQnaReplySubmit" class="btn btn-primary btn-sm fw-bold">댓글 등록</button>
      </div>
    </div>

  </div>
</div>




<div id="qnaPrevNextWrap" class="d-flex flex-column gap-3">


  <div id="qnaPrevBox" class="nav-post-custom" data-qna-no="">
    <div class="nav-icon">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg>
    </div>
    <div class="nav-label prev">이전글</div>
    <div class="nav-title" id="qnaPrevTitle">-</div>
    <div class="nav-info-wrap">
        <div>
            <span class="nav-meta-label">작성자</span>
            <span id="qnaPrevWriter" class="nav-writer-name">-</span>
        </div>
        <span id="qnaPrevStatus" class="nav-status-badge">-</span>
        <span class="d-none" id="qnaPrevNo"></span> 
    </div>
  </div>

  <div id="qnaNextBox" class="nav-post-custom" data-qna-no="">
    <div class="nav-icon">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"></polyline></svg>
    </div>
    <div class="nav-label next">다음글</div>
    <div class="nav-title" id="qnaNextTitle">-</div>
    <div class="nav-info-wrap">
        <div>
            <span class="nav-meta-label">작성자</span>
            <span id="qnaNextWriter" class="nav-writer-name">-</span>
        </div>
        <span id="qnaNextStatus" class="nav-status-badge">-</span>
        <span class="d-none" id="qnaNextNo"></span>
    </div>
  </div>

</div>