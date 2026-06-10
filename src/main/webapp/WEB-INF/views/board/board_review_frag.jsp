<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- 
  board_review_frag.jsp (REVIEW fragment)
  - <section id="content"> 안에 끼워 넣는 조각 화면
  - DOCTYPE / html / head / body 같은 전체 문서 구조 금지
  - 목록 데이터/페이징은 JS(boardreview.js)에서 /board/reviewData.do(JSON)로 받아서 그린다
--%>

<style>
  /* 목록(행) hover 효과(원하면 삭제해도 됨) */
  #reviewTbody tr {
    cursor: pointer;
    transition: all 0.2s ease;
    border-bottom: 1px solid rgba(15, 23, 42, 0.05);
  }
  #reviewTbody tr:hover {
    background-color: rgba(27, 123, 255, 0.04) !important;
    transform: scale(1.005);
    box-shadow: 0 4px 12px rgba(15, 23, 42, 0.08);
    z-index: 1;
    position: relative;
    font-weight: 600;
    border-radius: 6px;
  }
  #reviewTbody td {
    padding: 14px 12px;
    vertical-align: middle;
    color: #334155;
  }
  
  .stars{
  font-size: 15px;
  letter-spacing: 1px;
  font-weight: 900;
  color: #f59e0b;
}

/* ✅ 리뷰 검색바 (스크린샷 스타일) */
.reviewSearchBar{
  width: 100%;
  display: flex;
  align-items: center;
  gap: 14px;

  background: #fff;
  border: 1px solid rgba(15, 23, 42, 0.10);
  border-radius: 999px;
  padding: 14px 18px;

  box-shadow: 0 14px 30px -18px rgba(15,23,42,0.18);
}

.reviewSelect{
  height: 44px;
  min-width: 140px;
  padding: 0 16px;
  border-radius: 999px;
  border: 1px solid rgba(15,23,42,0.10);
  background: #fff;
  font-weight: 800;
  font-size: 14px;
  color: #0f172a;
  outline: none;
}

.reviewInput{
  flex: 1;
  height: 44px;
  padding: 0 18px;
  border-radius: 999px;
  border: 1px solid rgba(15,23,42,0.10);
  background: #fff;
  font-weight: 700;
  font-size: 14px;
  color: #0f172a;
  outline: none;
}

.reviewInput::placeholder{
  color: rgba(15,23,42,0.35);
  font-weight: 700;
}

.reviewSearchBtn{
  width: 46px;
  height: 46px;
  border: 0;
  border-radius: 999px;
  background: #0f7a5b; /* 스샷 초록 느낌 */
  color: #fff;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: transform .15s ease, box-shadow .15s ease;
  box-shadow: 0 10px 18px -10px rgba(15, 122, 91, 0.45);
}

.reviewSearchBtn:hover{
  transform: translateY(-1px);
  box-shadow: 0 14px 24px -14px rgba(15, 122, 91, 0.55);
}

.reviewSearchBtn:active{
  transform: translateY(0);
  box-shadow: 0 10px 18px -10px rgba(15, 122, 91, 0.45);
}

</style>

<div class="d-flex justify-content-between align-items-end mb-3">
  <div>
    <div class="fw-bold fs-4" style="letter-spacing:-0.02em;">Review</div>
    <div class="text-muted small fw-bold">리뷰 목록</div>
  </div>

  <div class="d-flex align-items-center gap-2">
    <div class="text-muted small fw-bold">
      총 <span id="reviewTotalCount">0</span>건
    </div>

    <%-- 글쓰기 버튼(이벤트는 boardreview.js에서 연결) --%>
    <button type="button" class="btn btn-primary btn-sm" id="btnReviewWrite" style="height:38px;">
      <i class="fa-solid fa-pen-to-square me-1"></i>글쓰기
    </button>
  </div>
</div>

<div class="table-responsive">
  <table class="table align-middle">
    <thead style="background:#f4f6f8;">
      <tr>
        <th style="width:60px;" class="text-center">번호</th>
        
        <th class="text-center">제목</th>
        
        <th style="width:120px;" class="text-center">작성자</th>
        
        <th style="width:100px;" class="text-center">작성일</th>
        
        <th style="width:90px;" class="text-center">별점</th>
        
        <th style="width:60px;" class="text-center">조회</th>
        
        <th style="width:140px;" class="text-center">주문상품</th>
      </tr>
    </thead>

    <%-- JS가 목록을 (#reviewTbody)에 뿌린다 --%>
    <tbody id="reviewTbody">
      <tr>
        <td colspan="7" class="text-center text-muted fw-bold py-4">로딩중...</td>
      </tr>
    </tbody>
  </table>
</div>

<%-- JS가 페이지 버튼을 (#reviewPagelist)에 뿌린다 --%>
<div class="d-flex gap-2 justify-content-center py-2" id="reviewPagelist"></div>

<!-- ✅ 검색 바 -->
<form id="reviewSearchF" class="reviewSearchBar" autocomplete="off">
  <!-- 기간 -->
  <select id="reviewPeriod" name="period" class="reviewSelect">
    <option value="">전체기간</option>
    <option value="7">최근 7일</option>
    <option value="30">최근 30일</option>
    <option value="90">최근 3개월</option>
    <option value="180">최근 6개월</option>
    <option value="365">최근 1년</option>
  </select>

  <!-- 검색 조건 -->
  <select id="reviewStype" name="stype" class="reviewSelect">
    <option value="title">제목만</option>
    <option value="content">내용만</option>
    <option value="title_content">제목+내용</option>
    <option value="writer">작성자</option>
    <option value="orderNo">주문상품</option>
  </select>

  <!-- 검색어 -->
  <input
    type="text"
    id="reviewQ"
    name="q"
    class="reviewInput"
    placeholder="검색어를 입력해주세요"
  />

  <button type="submit" class="reviewSearchBtn" aria-label="검색">
    <i class="fa-solid fa-magnifying-glass"></i>
  </button>
</form>
