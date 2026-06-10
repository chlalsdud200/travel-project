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

  /* [2] 수정/삭제 버튼(사진처럼 pill) */
  .btn-edit-custom {
    display: none; /* JS에서 canEdit일 때 보이게 */
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
    background: rgba(37,99,235,0.10);
    border-color: rgba(37,99,235,0.35);
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(37,99,235,0.12);
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
    background: rgba(220,38,38,0.10);
    border-color: rgba(220,38,38,0.35);
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(220,38,38,0.12);
  }

  /* [3] 메타 라인 뱃지/구분자 */
  .metaWrap{
    display:flex;
    flex-wrap:wrap;
    align-items:center;
    gap: 10px;
    color: rgba(15,23,42,0.62);
    font-weight: 700;
    font-size: 13px;
    margin-bottom: 18px;
  }
  .metaWrap .vr{
    width:1px;
    height:14px;
    background: rgba(15,23,42,0.15);
    opacity: .55;
  }
  .metaLabel{
    background:#fff;
    border:1px solid rgba(15,23,42,0.12);
    color:#0f172a;
    border-radius:999px;
    padding: 2px 10px;
    font-size: 12px;
    font-weight: 800;
  }
  .statusPill{
    margin-left:auto;
    background: rgba(100,116,139,0.10);
    color:#64748b;
    padding: 4px 10px;
    border-radius: 10px;
    font-size: 12px;
    font-weight: 900;
    border:1px solid rgba(100,116,139,0.18);
  }

  /* [4] 본문 박스 */
  .contentBox{
    min-height:300px;
    white-space:pre-wrap;
    background:#f8fafc;
    color:#334155;
    line-height:1.7;
    border-radius: 12px;
    padding: 20px;
    border: 1px solid rgba(15,23,42,0.06);
  }
  
  .stars{
  font-size: 15px;
  letter-spacing: 1px;
  font-weight: 900;
  color: #f59e0b;
}
</style>

<!-- ✅ 헤더(사진처럼) -->
<div class="d-flex justify-content-between align-items-end mb-4">
  <div>
    <div class="fw-bold fs-4" style="letter-spacing:-0.03em; color:#0f172a;">리뷰 상세</div>
    <div class="text-muted small fw-bold" style="opacity:0.8;">구매하신 상품 리뷰입니다.</div>
  </div>

  <div class="d-flex align-items-center gap-2">
    <button type="button" class="btn-back-custom" id="btnReviewViewBack">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
        <path d="M15 18l-6-6 6-6"/>
      </svg>
      목록
    </button>
  </div>
</div>

<!-- ✅ 카드(사진처럼) -->
<div class="card mb-4" style="border-radius:16px; border:1px solid rgba(15,23,42,0.08); box-shadow:0 10px 30px -10px rgba(0,0,0,0.05);">
  <div class="card-body" style="padding:24px;">

    <!-- 제목 + 수정/삭제 -->
    <div class="mb-3 border-bottom pb-3 d-flex align-items-center justify-content-between"
         style="border-color: rgba(15,23,42,0.06) !important;">

      <div class="fw-bold fs-5" id="vTitle" style="letter-spacing:-0.01em;">로딩중...</div>

      <div class="d-flex align-items-center gap-2">
        <button type="button" id="btnReviewEdit" class="btn-edit-custom">수정</button>
        <button type="button" id="btnReviewDelete" class="btn-delete-custom">삭제</button>
      </div>
    </div>

    <!-- 메타 라인(작성자/날짜/조회 + 상태 pill) -->
    <div class="metaWrap">

      <div class="vr"></div>

      <div id="vCreated">-</div>

      <div class="vr"></div>

      <div>조회 <span id="vHit">0</span></div>

    </div>

    <!-- (선택) 주문/상품/별점 정보 줄 -->
    <div class="d-flex flex-wrap gap-3 small mb-3 align-items-center"
         style="color: rgba(15,23,42,0.62); font-weight: 700;">
      <div>별점 <span id="vRating" class="text-dark fw-bold">-</span></div>
      <div class="vr" style="width:1px;height:14px;background:rgba(15,23,42,0.15);opacity:.55;"></div>
      <div>주문번호 <span id="vOrderNo" class="text-dark fw-bold">-</span></div>
      <div class="vr" style="width:1px;height:14px;background:rgba(15,23,42,0.15);opacity:.55;"></div>
      <div>상품명 <span id="vRegTitle" class="text-dark fw-bold">-</span></div>
    </div>

    <!-- 본문 -->
    <div class="contentBox" id="vCtt">로딩중...</div>

  </div>
</div>


<!-- ===== REVIEW 댓글 영역 (QNA 스타일 고정) ===== -->
<div id="reviewReplyWrap" class="card mb-4"
     style="border-radius:16px; border:1px solid rgba(15,23,42,0.08); box-shadow:0 10px 30px -10px rgba(0,0,0,0.05);">
  <div class="card-body" style="padding:20px;">

    <!-- 댓글 헤더 -->
    <div class="d-flex justify-content-between align-items-center mb-3">
      <div class="fw-bold" style="letter-spacing:-0.01em; color:#0f172a;">
        댓글 <span id="reviewReplyCount" class="text-primary">0</span>
      </div>
    </div>

    <!-- 로그인/권한/리뷰번호 (hidden) -->
    <input type="hidden" id="reviewLoginId" value="${sessionScope.loginUser.userId}">
    <input type="hidden" id="reviewLoginRole" value="${sessionScope.loginUser.role}">
    <input type="hidden" id="reviewLoginName" value="${sessionScope.loginUser.userName}">
    
    <!-- hash 기반(#review/view/번호)이면 param이 없을 수 있어요. JS에서 window.review_view_no로 보완합니다 -->
    <input type="hidden" id="reviewNo" value="${param.reviewNo}">


    <!-- 댓글 목록 -->
    <div id="reviewReplyList" class="d-flex flex-column gap-2"></div>
    <!-- 댓글 작성 -->
    <div id="reviewReplyEditor" class="mb-3"
         style="padding:10px 12px; background-color:#f8fafc; border-radius:12px;">
      <textarea id="reviewReplyTextarea"
                rows="3"
                style="width:100%; resize:none; overflow:hidden; padding:10px 12px; border:1px solid rgba(15,23,42,0.12); border-radius:8px;"
                placeholder="댓글을 입력해주세요"></textarea>
      <div class="d-flex justify-content-end mt-2">
        <button type="button" id="btnReviewReplySubmit" class="btn btn-primary btn-sm fw-bold">댓글 등록</button>
      </div>
    </div>

  </div>
</div>



