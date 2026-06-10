<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
  .headRow{display:flex;align-items:flex-end;justify-content:space-between;margin-bottom:20px;}
  .title{margin:0;font-size:26px;font-weight:900;letter-spacing:-0.02em;color:#0f172a;}
  .sub{margin-top:6px;color:#64748b;font-weight:800;}
  .card-box{background:#fff;border:1px solid rgba(15,23,42,.10);border-radius:18px;padding:30px;box-shadow:0 12px 30px rgba(15,23,42,.08);}
  .form-row{display:flex;flex-direction:column;gap:8px;margin-bottom:18px;}
  .lbl{font-weight:900;font-size:15px;color:#334155;}
  .inp{width:100%;padding:12px 14px;border:1px solid rgba(15,23,42,.18);border-radius:12px;font-size:15px;}
  .ta{width:100%;min-height:240px;resize:vertical;padding:14px;border:1px solid rgba(15,23,42,.18);border-radius:12px;font-size:15px;}
  .hint{color:#64748b;font-size:13px;font-weight:700;margin-top:4px;}
  .btnRow{display:flex;justify-content:flex-end;gap:10px;margin-top:10px;}
  .btnPrimary{padding:12px 24px;border-radius:12px;background:#1b7bff;color:#fff;border:0;cursor:pointer;font-weight:900;font-size:15px;}
  .btnLine{padding:10px 18px;border-radius:12px;border:1px solid #cbd5e1;text-decoration:none;color:#475569;background:#fff;font-weight:900;font-size:14px;display:inline-flex;align-items:center;cursor:pointer;}
</style>

<div class="headRow">
  <div>
    <h2 class="title">리뷰 수정</h2>
    <div class="sub">내용을 수정한 뒤 저장하세요.</div>
  </div>
  <div class="headBtns">
    <a class="btnLine" href="#review">목록</a>
  </div>
</div>

<div class="card-box">
  <form id="reviewEditForm">
    <!-- ✅ JS에서 reviewNo 세팅 -->
    <input type="hidden" name="reviewNo" id="editReviewNo"/>

    <div class="form-row">
      <label class="lbl">주문번호</label>
      <input class="inp" type="text" name="orderNo" id="editOrderNo" readonly />
      <div class="hint">주문번호는 변경할 수 없습니다.</div>
    </div>

    <div class="form-row">
      <label class="lbl">상품명</label>
      <input class="inp" type="text" id="editRegTitle" readonly />
    </div>

    <div class="form-row">
      <label class="lbl">별점</label>
      <select class="inp" name="reviewRating" id="editRating">
        <option value="5">⭐⭐⭐⭐⭐ (5점)</option>
        <option value="4">⭐⭐⭐⭐ (4점)</option>
        <option value="3">⭐⭐⭐ (3점)</option>
        <option value="2">⭐⭐ (2점)</option>
        <option value="1">⭐ (1점)</option>
      </select>
    </div>

    <div class="form-row">
      <label class="lbl">제목</label>
      <input class="inp" type="text" name="reviewTitle" id="editTitle" maxlength="180" required />
    </div>

    <div class="form-row">
      <label class="lbl">내용</label>
      <textarea class="ta" name="reviewCtt" id="editCtt" maxlength="3000" required></textarea>
      <div class="hint">최대 3000자</div>
    </div>

    <div class="btnRow">
      <button type="button" class="btnLine" id="btnEditCancel">취소</button>
      <button type="submit" class="btnPrimary" id="btnEditSave">저장</button>
    </div>
  </form>
</div>
