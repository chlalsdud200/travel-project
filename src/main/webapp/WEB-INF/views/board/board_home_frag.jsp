<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="kr.or.ddit.tct.users.vo.UserVO" %>
<%
  UserVO loginUser = (UserVO) session.getAttribute("loginUser");
  boolean isAdmin = (loginUser != null && "ADMIN".equals(loginUser.getRole()));
%>

<!-- 지금 보는 사람이 ADMIN이면 Y (JS가 읽어서 관리자 글일 때만 작성자 아이디 표시) -->
<div id="homeMeta" data-is-admin="<%= isAdmin ? "Y" : "N" %>" style="display:none;"></div>

<%-- 
  board_home_frag.jsp (HOME fragment)
  - section에 끼워넣는 조각 화면
--%>

<div class="d-flex justify-content-between align-items-end mb-3">
	<div>
		<div class="fw-bold fs-4" style="letter-spacing: -0.02em;">게시판</div>
		<div class="text-muted small fw-bold">최신 글</div>
	</div>

	<div class="text-muted small fw-bold">
		총 <span id="homeTotalCount">0</span>건
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
			</tr>
		</thead>

		<tbody id="homeTbody">
			<tr>
				<td colspan="5" class="text-center text-muted fw-bold py-4">로딩중...</td>
			</tr>
		</tbody>
	</table>
</div>

<div class="d-flex gap-2 justify-content-center py-2" id="homePagelist"></div>

<!-- 홈 검색 폼: QNA 검색폼 규격 그대로 (stype/sword) -->
<form id="homeSearchF" class="d-flex justify-content-center align-items-center pt-3">

  <!-- 검색 대상 -->
  <select class="form-select form-select-sm" style="width: 140px;" name="stype">
    <option value="title">제목만</option>
    <option value="writer">작성자</option>
    <option value="content">내용</option>
  </select>

  <!-- 검색어 -->
  <input class="form-control form-control-sm"
         style="width: min(420px, 55vw);"
         placeholder="검색어를 입력해주세요"
         name="sword" />

  <!-- 검색 실행 -->
  <button class="btn btn-success btn-sm"
          style="width: 44px; height: 38px;"
          title="검색"
          type="submit">
    <i class="fa-solid fa-magnifying-glass"></i>
  </button>
</form>

