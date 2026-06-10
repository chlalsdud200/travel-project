<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>로그인 | TryCatchTrip</title>

<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
	font-family: 'Pretendard', sans-serif;
}

body {
	background: #f4f7f9;
	display: flex;
	justify-content: center;
	align-items: center;
	height: 100vh;
}

.container {
	background: #fff;
	padding: 72px;
	border-radius: 16px;
	box-shadow: 0 8px 30px rgba(0, 0, 0, .1);
	width: 100%;
	max-width: 680px;;
}

h2 {
	text-align: center;
	margin-bottom: 10px;
	color: #333;
	font-size: 25px;
}

p {
	text-align: center;
	color: #777;
	margin-bottom: 20px;
	font-size: 15px;
}

.input-group {
	margin-bottom: 20px;
}

label {
	display: block;
	margin-bottom: 8px;
	font-size: 14px;
	font-weight: 600;
	color: #555;
}

input[type="text"], input[type="password"] {
	width: 100%;
	padding: 16px;
	border: 1px solid #ddd;
	border-radius: 10px;
	font-size: 17px;
}

.options {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 25px;
	font-size: 13px;
	color: #666;
}

.main-btn {
	width: 100%;
	padding: 16px;
	background: #007bff;
	color: #fff;
	border: 0;
	border-radius: 10px;
	font-size: 19px;
	font-weight: bold;
	cursor: pointer;
}

.main-btn:hover {
	background: #0056b3;
}

.footer {
	text-align: center;
	margin-top: 25px;
	font-size: 14px;
	color: #777;
}

.links {
	display: flex;
	gap: 10px;
	align-items: center;
}

.sep {
	color: #bbb;
}

.link {
	color: #007bff;
	text-decoration: none;
	cursor: pointer;
}

.link:hover {
	text-decoration: underline;
}

.msg {
	background: rgba(255, 0, 0, .06);
	border: 1px solid rgba(255, 0, 0, .18);
	color: #b00020;
	padding: 10px 12px;
	border-radius: 8px;
	font-size: 13px;
	margin: 10px 0 18px;
	text-align: center;
	font-weight: 700;
}

/* 모달 */
#fModalBg {
	display: none;
	position: fixed;
	inset: 0;
	background: rgba(0, 0, 0, .45);
	z-index: 999;
}

#fModal {
	display: none;
	position: fixed;
	inset: 0;
	z-index: 1000;
	align-items: center;
	justify-content: center;
	padding: 18px;
}

#fModalBox {
	width: min(560px, 92vw);
	height: min(62vh, 520px);
	background: #fff;
	border-radius: 12px;
	overflow: hidden;
	box-shadow: 0 12px 40px rgba(0, 0, 0, .18);
	display: flex;
	flex-direction: column;
}

#fModalHead {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 10px;
	border-bottom: 1px solid #eee;
}

#fModalTitle {
	font-weight: 800;
	color: #222;
}

#fModalClose {
	width: 34px;
	height: 34px;
	border-radius: 10px;
	border: 1px solid #e5e5e5;
	background: #fff;
	cursor: pointer;
	font-size: 18px;
	line-height: 1;
}

#fModalFrame {
	width: 100%;
	height: 100%;
	border: 0;
}
</style>
</head>

<body>
	<div class="container">
		<form action="<%=request.getContextPath()%>/login.do" method="post">
			<h2>반갑습니다!</h2>
			<p>서비스 이용을 위해 로그인해주세요.</p>

			<%
			String msg = (String) request.getAttribute("msg");
			if (msg != null && !msg.trim().isEmpty()) {
			%>
			<div class="msg"><%=msg%></div>
			<%
			}
			%>

			<div class="input-group">
				<label>아이디</label> <input type="text" name="userId"
					placeholder="아이디를 입력하세요" required autocomplete="username">
			</div>

			<div class="input-group">
				<label>비밀번호</label> <input type="password" name="userPass"
					placeholder="비밀번호를 입력하세요" required autocomplete="current-password">
			</div>

			<div class="options">
				<label style="cursor: pointer;"><input type="checkbox"
					name="rememberId"> 아이디 저장</label>

				<div class="links">
					<!-- ✅ JS가 이 id로 찾음 -->
					<a href="#" id="findIdLink" class="link">아이디 찾기</a> <span
						class="sep">|</span> <a href="#" id="findPwLink" class="link">비밀번호
						찾기</a>
				</div>
			</div>

			<button type="submit" class="main-btn">로그인</button>

			<div class="footer">
				아직 회원이 아니신가요? <a class="link"
					href="<%=request.getContextPath()%>/join.do">회원가입</a>
			</div>
		</form>
	</div>

	<!-- 모달 -->
	<div id="fModalBg"></div>
	<div id="fModal">
		<div id="fModalBox">
			<div id="fModalHead">
				<div id="fModalTitle">제목</div>
				<button type="button" id="fModalClose">×</button>
			</div>
			<iframe id="fModalFrame"></iframe>
		</div>
	</div>

	<script>
  /*  전역 변수 */
  var CTX = "<%=request.getContextPath()%>";
	</script>
	<script src="<%=request.getContextPath()%>/js/login.js"></script>
	<script>
  window.onload = function() {

    // ✅ 목적: 회원가입 직후 /login.do?joined=1 로 들어온 사용자에게 "가입 완료"를 즉시 알려주기 위함
    //    (JoinController에서 joined=1을 붙여서 redirect 해주고 있음)
    var joined = "<%= (request.getParameter("joined") == null) ? "" : request.getParameter("joined") %>";

    // ✅ joined=1일 때만 alert 띄우기: 가입 성공 피드백을 주기 위한 조건
    if (joined === "1") {
      alert("회원가입이 완료되었습니다! 로그인해 주세요.");

      // ✅ 목적: 새로고침/뒤로가기 때 alert가 계속 반복되는 걸 막기 위해
      //        브라우저 주소창에서 joined 파라미터만 제거(페이지 새로고침은 안 함)
      if (history && history.replaceState) {
        var u = new URL(location.href);     // 현재 주소를 다루기 쉽게 URL 객체로 변환
        u.searchParams.delete("joined");    // joined=1 제거
        history.replaceState(null, "", u.toString()); // 주소만 바꿔치기(리로드 X)
      }
    }

    // ✅ 기존 로그인 페이지 초기화(아이디/비번찾기 모달 이벤트 등)를 그대로 유지하기 위한 호출
    loginPro();
  }
</script>

	
	
</body>
</html>
