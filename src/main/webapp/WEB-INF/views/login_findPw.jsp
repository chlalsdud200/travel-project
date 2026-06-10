<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>비밀번호 찾기</title>
<style>
* {
	box-sizing: border-box;
	font-family: system-ui, -apple-system, "Noto Sans KR", sans-serif;
}

body {
	margin: 0;
	background: #fff;
}

.wrap {
	padding: 18px;
}

.card {
	border: 1px solid rgba(0, 0, 0, .08);
	border-radius: 14px;
	padding: 14px;
	background: #fff;
}

.row {
	display: flex;
	gap: 10px;
	margin-top: 12px;
}

.field {
	margin: 10px 0;
}

.label {
	display: block;
	font-size: 12px;
	font-weight: 800;
	color: #374151;
	margin-bottom: 6px;
}

.input {
	width: 100%;
	height: 44px;
	border: 1px solid rgba(0, 0, 0, .12);
	border-radius: 12px;
	padding: 0 12px;
	outline: none;
	font-size: 14px;
}

.btn {
	flex: 1;
	height: 44px;
	border-radius: 12px;
	border: 1px solid rgba(0, 0, 0, .12);
	background: #fff;
	font-weight: 900;
	cursor: pointer;
}

.btn.primary {
	background: #1b7bff;
	border-color: #1b7bff;
	color: #fff;
}

.btn:disabled {
	opacity: .55;
	cursor: not-allowed;
}

.msg {
	margin-top: 12px;
	padding: 10px 12px;
	border-radius: 12px;
	font-size: 13px;
	font-weight: 800;
	text-align: center;
}

.msg.err {
	color: #b00020;
	background: rgba(255, 0, 0, .06);
	border: 1px solid rgba(255, 0, 0, .18);
}

.msg.ok {
	color: #0f5132;
	background: rgba(25, 135, 84, .08);
	border: 1px solid rgba(25, 135, 84, .22);
}
</style>
</head>
<body>
	<div class="wrap">
		<div class="card">

			<!-- ✅ 이메일칸 반드시 존재 -->
			<div class="field">
				<label class="label" for="userEmail">이메일</label> <input
					class="input" id="userEmail" placeholder="예) user@domain.com"
					autocomplete="off" />
			</div>

			<div class="row">
				<button class="btn primary" type="button" id="btnSend">인증코드
					발송</button>
				<button class="btn" type="button" id="btnGoLogin">로그인으로</button>
			</div>

			<div class="field">
				<label class="label" for="code">인증코드</label> <input class="input"
					id="code" placeholder="6자리" disabled autocomplete="off" />
			</div>

			<div class="row">
				<button class="btn primary" type="button" id="btnVerify" disabled>코드
					확인</button>
				<button class="btn" type="button" id="btnResend" disabled>재발송</button>
			</div>

			<div class="field">
				<label class="label" for="newPw">새 비밀번호</label> <input class="input"
					id="newPw" type="password" disabled />
			</div>

			<div class="field">
				<label class="label" for="newPw2">새 비밀번호 확인</label> <input
					class="input" id="newPw2" type="password" disabled />
			</div>

			<div class="row">
				<button class="btn primary" type="button" id="btnReset" disabled>비밀번호
					변경</button>
				<button class="btn" type="button" id="btnClose">닫기</button>
			</div>

			<div id="msgBox"></div>
		</div>
	</div>

	<script>
  var CTX = "<%=request.getContextPath()%>
		";
	</script>
	<script src="<%=request.getContextPath()%>/js/pwFind.js"></script>
</body>
</html>
