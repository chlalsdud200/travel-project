<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%@ page import="kr.or.ddit.tct.users.vo.UserVO"%>
<%
UserVO loginUser = (UserVO) session.getAttribute("loginUser");
if (loginUser == null) {
	response.sendRedirect(request.getContextPath() + "/login.do");
	return;
}
%>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>마이페이지 - TryCatchTrip</title>

<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/mypage.css">
</head>

<body data-ctx="<%=request.getContextPath()%>">
	<jsp:include page="/WEB-INF/views/common/tctHeader.jsp" />

	<main>
		<section class="mypage">
			<aside class="side" aria-label="마이페이지 메뉴">
				<div class="sideHead">마이페이지</div>
				<div class="sideList">
					<a class="sideItem" href="#pay" data-section="pay">결제내역</a> <a
						class="sideItem" href="#qna" data-section="qna">문의게시판</a> <a
						class="sideItem" href="#review" data-section="review">후기게시판</a> <a
						class="sideItem" href="#wish" data-section="wish">관심상품</a> <a
						class="sideItem" href="#profile" data-section="profile"
						id="goPwCheck">회원정보수정</a>
				</div>
			</aside>

			<div class="content">
				<section id="pay" class="section" aria-label="결제내역">
					<div class="card">
						<div class="cardHeader">
							<h2>결제내역</h2>
						</div>
						<div id="payBody"></div>
					</div>
				</section>

				<section id="qna" class="section" aria-label="문의게시판">
					<div class="card">
						<div class="cardHeader">
							<h2>문의게시판</h2>
						</div>
						<div id="qnaBody"></div>
					</div>
				</section>

				<section id="review" class="section" aria-label="후기게시판">
					<div class="card">
						<div class="cardHeader">
							<h2>후기게시판</h2>
							<button class="more" type="button" data-more="review">새로고침</button>
						</div>
						<div id="reviewBody"></div>
					</div>
				</section>

				<section id="wish" class="section" aria-label="관심상품">
					<div class="card">
						<div class="cardHeader">
							<h2>관심상품</h2>
							<button class="more" type="button" data-more="wish">새로고침</button>
						</div>
						<div id="wishBody"></div>
					</div>
				</section>

				<section id="profile" class="section" aria-label="회원정보수정">
					<div class="card">
						<div class="cardHeader">
							<h2>회원정보 수정</h2>
						</div>

						<div id="profileArea">
							<div id="profilePlaceholder" class="empty">
								<div class="icon">🔒</div>
								<div>비밀번호 확인이 필요합니다.</div>
								<div class="ctaRow">
									<button class="cta" type="button" id="btnOpenPwCheck">비밀번호
										확인</button>
								</div>
							</div>
						</div>
					</div>
				</section>
			</div>
		</section>
	</main>

	<%@ include file="/WEB-INF/views/common/tctFooter.jsp"%>

	<script
		src="https://cdn.jsdelivr.net/npm/@emailjs/browser@4/dist/email.min.js"></script>

	<script src="${ctx}/js/mypage.profile.js"></script>
	<script src="${ctx}/js/mypage.pay.js"></script>
	<script src="${ctx}/js/mypage.wish.js"></script>
	<script src="${ctx}/js/mypage.qna.js"></script>
	<script src="${ctx}/js/mypage.review.js"></script>
	<script src="${ctx}/js/mypage.core.js"></script>



	<div class="wishToast" id="wishToast"></div>

</body>
</html>