<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%-- 
  board_qna_frag.jsp (QNA fragment)
  - <section id="content"> 안에 끼워 넣는 조각 화면
  - DOCTYPE / html / head / body 같은 전체 문서 구조 금지
--%>

<style>
/* 목록(행) 스타일 */
#qnaTbody tr {
	cursor: pointer; /* 마우스 올리면 손가락 모양 */
	transition: all 0.2s ease; /* 부드러운 애니메이션 */
	border-bottom: 1px solid rgba(15, 23, 42, 0.05); /* 연한 구분선 */
}

/* 마우스 올렸을 때(Hover) 효과 */
#qnaTbody tr:hover {
	background-color: rgba(27, 123, 255, 0.04) !important; /* 배경색 살짝 파랗게 */
	transform: scale(1.010); /* 살짝 떠오르는 느낌 */
	box-shadow: 0 4px 12px rgba(15, 23, 42, 0.08); /* 그림자 추가 */
	z-index: 1;
	position: relative; /* z-index 적용을 위해 필요 */
	font-weight: 600; /* 글씨 약간 진하게 */
	border-radius: 6px; /* 모서리 둥글게 */
}

/* 셀 여백 조정 (클릭 영역 확보) */
#qnaTbody td {
	padding: 14px 12px;
	vertical-align: middle;
	color: #334155;
}
</style>

<div class="d-flex justify-content-between align-items-end mb-3">
	<div>
		<div class="fw-bold fs-4" style="letter-spacing: -0.02em;">Q&amp;A</div>
		<div class="text-muted small fw-bold">문의 목록</div>
	</div>

	<div class="d-flex align-items-center gap-2">
		<div class="text-muted small fw-bold">
			총 <span id="qnaTotalCount">0</span>건
		</div>

		<%-- 글쓰기 버튼 (JS에서 이벤트 연결할 것) --%>
		<button type="button" class="btn btn-primary btn-sm" id="btnQnaWrite"
			style="height: 38px;">
			<i class="fa-solid fa-pen-to-square me-1"></i>글쓰기
		</button>
	</div>
</div>

<div class="table-responsive">
	<table class="table align-middle">
		<thead style="background: #f4f6f8;">
			<tr>
				<th style="width: 90px;">번호</th>
				<th>제목</th>
				<th style="width: 160px;">작성자</th>
				<th style="width: 140px;">작성일</th>
				<th style="width: 90px;">조회</th>
				<th style="width: 120px;">답변현황</th>
				<%-- ✅ 추가 --%>
			</tr>
		</thead>


		<%-- JS가 목록을 (#qnaTbody)에 뿌린다 --%>
		<tbody id="qnaTbody">
			<tr>
				<td colspan="6" class="text-center text-muted fw-bold py-4">로딩중...</td>
			</tr>
		</tbody>
	</table>
</div>

<%-- JS가 페이지 버튼을 (#qnaPagelist)에 뿌린다 --%>
<div class="d-flex gap-2 justify-content-center py-2" id="qnaPagelist"></div>

<form id="qnaSearchF"
	class="d-flex gap-2 justify-content-center align-items-center pt-3">

	<select class="form-select form-select-sm" style="width: 140px;"
		name="period">
		<option value="">전체기간</option>
		<option value="1d">1일</option>
		<option value="1w">1주</option>
		<option value="1m">1개월</option>
		<option value="3m">3개월</option>
	</select> <select class="form-select form-select-sm" style="width: 140px;"
		name="stype">
		<option value="title">제목만</option>
		<option value="writer">작성자</option>
		<option value="content">내용</option>
	</select> <input class="form-control form-control-sm"
		style="width: min(420px, 55vw);" placeholder="검색어를 입력해주세요"
		name="sword" />

	<button class="btn btn-success btn-sm"
		style="width: 44px; height: 38px;" title="검색" type="submit">
		<i class="fa-solid fa-magnifying-glass"></i>
	</button>
</form>