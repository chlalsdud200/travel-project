<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
// 사이드바 활성화 (필수)
request.setAttribute("adminActive", "products");

String ctx = request.getContextPath();

// 컨트롤러에서 넘어온 tab 값
String tab = (String) request.getAttribute("tab");
if (tab == null || tab.isBlank())
	tab = "list";
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<link rel="stylesheet" href="<%=ctx%>/css/admin-dashboard.css">

<style>
/* ===== btn-yellow : 아이템 관리 탭 노란색 버튼 ===== */
.btn.btn-yellow{
  background: #facc15;          /* yellow-400 */
  color: #0f172a;               /* slate-900 */
  border: 1px solid rgba(15,23,42,.18);
  box-shadow: 0 6px 14px rgba(250, 204, 21, .20);
}
.btn.btn-yellow:hover{
  background: #eab308;          /* yellow-500 */
  border-color: rgba(15,23,42,.22);
  transform: translateY(-1px);
}
.btn.btn-yellow:active{
  transform: translateY(0);
  box-shadow: 0 3px 10px rgba(250, 204, 21, .18);
}
.btn.btn-yellow:focus{ outline: none; }
.btn.btn-yellow:focus-visible{
  outline: 3px solid rgba(250, 204, 21, .35);
  outline-offset: 2px;
}
.btn.btn-yellow i{
  color: rgba(15,23,42,.95);
}
</style>

<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>TryCatchTrip - 상품관리</title>

<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet" href="<%=ctx%>/css/admin-dashboard.css">
</head>

<body>
	<div class="app">
		
		<!-- LEFT SIDEBAR -->
		<%@ include file="/WEB-INF/views/admin/adminSidebar.jspf"%>

		<!-- MAIN -->
		<main class="main">

			<!-- TOP BAR -->
			<header class="topbar">
				<div class="crumb">
					전체보기 / <strong>상품관리</strong>
				</div>

				<div class="topbar-right">
					<div class="admin-chip">
						<div class="admin-avatar">A</div>
						<div class="admin-name">관리자님</div>
					</div>
				</div>
			</header>

			<!-- CONTENT -->
			<div class="content">
				<div class="container">

					<!-- PAGE HEAD -->
					<div class="page-head">
						<div>
							<h2 class="page-title">상품관리</h2>
							<p class="page-sub">상품 리스트 조회 및 상품 등록을 관리합니다.</p>
						</div>
					</div>

					<!-- 🔹 상단 탭 -->
					<div style="display: flex; gap: 10px; margin-bottom: 14px;">
						<a href="<%=ctx%>/admin/prod/adminProducts.do?tab=list"
							class="btn <%="list".equals(tab) ? "btn-dark" : "btn-ghost"%>"
							style="display: flex; align-items: center; gap: 8px;"> <i
							class="fas fa-list"></i> 등록상품 관리
						</a> <a href="<%=ctx%>/admin/prod/adminProducts.do?tab=create"
							class="btn <%="create".equals(tab) ? "btn-indigo" : "btn-ghost"%>"
							style="display: flex; align-items: center; gap: 8px;"> <i
							class="fas fa-plus"></i> 패키지 관리
						</a> <a href="<%=ctx%>/admin/prod/adminProducts.do?tab=create_item"
							class="btn <%="create_item".equals(tab) ? "btn-yellow" : "btn-ghost"%>"
							style="display: flex; align-items: center; gap: 8px;"> <i
							class="fas fa-plus"></i> 아이템 관리
						</a>
					</div>

					<!-- 🔹 본문 카드 -->
					<section class="card">

						<!-- 						<div class="panel-head" -->
						<!-- 						</div> -->

						<div class="panel-body" style="padding-top: 10px;">
							<c:choose>
								<c:when test="${tab eq 'create'}">
									<jsp:include page="/WEB-INF/views/admin/products_create.jsp" />
								</c:when>
								
								<c:when test="${tab eq 'create_item'}">
							      <jsp:include page="/WEB-INF/views/admin/items_create.jsp" />
							      <jsp:include page="/WEB-INF/views/admin/items_list.jsp" />
							    </c:when>
    
								<c:otherwise>
									<jsp:include page="/WEB-INF/views/admin/products_list.jsp" />
								</c:otherwise>
							</c:choose>
						</div>

					</section>

				</div>
			</div>

		</main>
	</div>
</body>
</html>
