<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.or.ddit.tct.users.vo.UserVO"%>
<%
  String ctx = request.getContextPath();
  UserVO user = (UserVO) request.getAttribute("user");
  String msg = (String) request.getAttribute("msg");

  String userId    = (user != null && user.getUserId()    != null) ? user.getUserId()    : "";
  String userName  = (user != null && user.getUserName()  != null) ? user.getUserName()  : "";
  String userEmail = (user != null && user.getUserEmail() != null) ? user.getUserEmail() : "";
  String userTel   = (user != null && user.getUserTel()   != null) ? user.getUserTel()   : "";
  String userAddr1 = (user != null && user.getUserAddr1() != null) ? user.getUserAddr1() : "";
  String userAddr2 = (user != null && user.getUserAddr2() != null) ? user.getUserAddr2() : "";
  String userZip   = (user != null && user.getUserZip()   != null) ? user.getUserZip()   : "";
  String userBir = "";
  try {
    if (user != null && user.getUserBir() != null) userBir = user.getUserBir().toString();
  } catch (Exception ignore) {}

  // return 파라미터(성공 후 이동 목적지)
  String returnUrl = request.getParameter("return");
  if (returnUrl == null || returnUrl.isBlank()) {
    returnUrl = ctx + "/editProfile.do?embed=1";
  }
%>

<style>
:root{
  --line:rgba(15, 23, 42, .10);
  --muted:rgba(15, 23, 42, .60);
  --brand:#1b7bff;
}

.profile-card{
  width:100%;
  background:transparent;
}

.profile-note{
  font-size:12px;
  color:rgba(15, 23, 42, .60);
  line-height:1.55;
  margin:0 0 10px;
}

.profile-panel{
  border:1px solid rgba(239, 68, 68, .35);
  background:rgba(239, 68, 68, .06);
  padding:10px 12px;
  border-radius:12px;
  margin-bottom:12px;
  font-size:12px;
  font-weight:900;
  color:#b91c1c;
}

.field{
  display:flex;
  flex-direction:column;
  gap:8px;
  margin-top:10px;
}
.field label{
  font-weight:800;
  font-size:12px;
  color:rgba(17, 24, 39, .75);
}

.field input{
  height:44px;
  padding:0 12px;
  border-radius:12px;
  border:1px solid var(--line);
  outline:0;
  background:#fff;
}
.field input:focus{
  border-color:rgba(27, 123, 255, .55);
  box-shadow:0 0 0 3px rgba(27, 123, 255, .12);
}

.row{ display:flex; gap:10px; align-items:center; }
.grid2{ display:grid; grid-template-columns:1fr 1fr; gap:12px; }
@media (max-width:860px){ .grid2{ grid-template-columns:1fr; } }

.btn-mini{
  height:44px;
  padding:0 12px;
  border-radius:12px;
  border:0;
  background:#6b7280;
  color:#fff;
  font-weight:900;
  font-size:12px;
  white-space:nowrap;
  cursor:pointer;
}
.btn-mini.primary{ background:#111827; }
.btn-mini:disabled{ opacity:.55; cursor:not-allowed; }

.help{ font-size:12px; color:var(--muted); margin-top:-4px; line-height:1.5; font-weight:900; }

.submit{
  margin-top:12px;
  width:100%;
  height:44px;
  border:0;
  border-radius:12px;
  background:var(--brand);
  color:#fff;
  font-weight:950;
  font-size:14px;
  cursor:pointer;
}

.readonly{
  background:rgba(15, 23, 42, .04) !important;
  color:rgba(15, 23, 42, .65) !important;
}

/* =========================================
   [추가] 회원탈퇴 영역 전용 스타일
   ========================================= */
.withdraw-zone {
  margin-top: 40px;
  padding: 24px;
  border: 1px solid rgba(239, 68, 68, .2);
  background: #fff5f5;
  border-radius: 16px;
}

.withdraw-title {
  font-size: 14px;
  font-weight: 900;
  color: #991b1b;
  margin-bottom: 6px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.withdraw-desc {
  font-size: 12px;
  color: #b91c1c;
  line-height: 1.6;
  margin-bottom: 20px;
  opacity: 0.85;
}

/* 상단 '저장하기' 버튼과 동일한 형태 (색상만 레드) */
.btn-danger-full {
  width: 100%;
  height: 44px;
  border: 0;
  border-radius: 12px;
  background: #ef4444; /* danger color */
  color: #fff;
  font-weight: 950;
  font-size: 14px;
  cursor: pointer;
  transition: background .2s;
}

.btn-danger-full:hover {
  background: #dc2626;
}
</style>

<div class="profile-card">
  <p class="profile-note">아이디는 변경할 수 없습니다. 이메일을 변경하는 경우, 인증 완료 후 저장 가능합니다.</p>

  <% if (msg != null && !msg.isBlank()) { %>
    <div class="profile-panel"><%=msg%></div>
  <% } %>

  <form id="editProfileForm" method="post" action="<%=ctx%>/editProfile.do?embed=1" autocomplete="off">
    <input type="hidden" name="return" value="<%=returnUrl%>">
    <input type="hidden" name="userId" value="<%=userId%>">

    <input type="hidden" id="origEmail" value="<%=userEmail%>">

    <div class="field">
      <label>이름</label>
      <input name="userName" id="userName" value="<%=userName%>" placeholder="이름을 입력하세요">
    </div>

    <div class="field">
      <label>아이디</label>
      <input class="readonly" value="<%=userId%>" readonly>
      <div class="help">아이디는 변경할 수 없습니다.</div>
    </div>

    <div class="grid2">
	  <div class="field">
	    <label>새 비밀번호 (변경 시에만 입력)</label>
	    <input type="password" id="userPass" name="userPass" placeholder="영문+숫자 포함 8자 이상">
	    <div class="help" id="pwRuleMsg" style="font-weight:900;"></div>
	  </div>
	
	  <div class="field">
	    <label>새 비밀번호 확인</label>
	    <input type="password" id="userPass2" name="userPass2" placeholder="비밀번호 재입력">
	    <div class="help" id="pwMatchMsg" style="font-weight:900;"></div>
	  </div>
    </div>

    <div class="field">
      <label>이메일</label>
      <input name="userEmail" id="userEmail" value="<%=userEmail%>" placeholder="example@email.com">

      <div class="row" style="margin-top:8px;">
        <button type="button" class="btn-mini primary" id="btnEmailSendProfile">인증메일 발송</button>
        <button type="button" class="btn-mini" id="btnEmailCheckProfile" disabled>인증확인</button>
      </div>
      <div class="help" id="emailVerifyMsgProfile"></div>
    </div>

    <div class="grid2">
      <div class="field">
        <label>생년월일</label>
        <input type="date" name="userBir" id="userBir" value="<%=userBir%>">
      </div>

      <div class="field">
        <label>전화번호</label>
        <input name="userTel" id="userTel" value="<%=userTel%>" placeholder="010-0000-0000">
      </div>
    </div>

    <div class="field">
      <label>주소 1</label>
      <input name="userAddr1" id="userAddr1" value="<%=userAddr1%>" placeholder="주소">
    </div>

    <div class="field">
      <label>주소 2</label>
      <input name="userAddr2" id="userAddr2" value="<%=userAddr2%>" placeholder="상세주소">
    </div>

    <div class="field">
      <label>우편번호</label>
      <input name="userZip" id="userZip" value="<%=userZip%>" placeholder="우편번호">
    </div>

    <button class="submit" type="submit">저장하기</button>
  </form>


  <div class="withdraw-zone">
    <div class="withdraw-title">
      <i class="fas fa-exclamation-triangle"></i> 회원 탈퇴
    </div>
    <p class="withdraw-desc">
      탈퇴 시  이후 해당 아이디로 로그인할 수 없습니다!
    </p>

   <form id="withdrawForm" method="post" action="<%=ctx%>/withdraw.do">
      <div class="field">
        <label style="color:#b91c1c;">현재 비밀번호 확인</label>
        <input type="password" name="currentPass" required 
               placeholder="현재 비밀번호를 다시입력해주세요."
               style="border-color: rgba(239,68,68,0.3); max-width: 300px;">
      </div>

      <div style="margin-top: 12px;">
        <button type="submit" class="btn-danger-full"
                onclick="return confirm('정말 회원 탈퇴 처리할까요?\n탈퇴 후에는 로그인할 수 없습니다.');">
          회원탈퇴
        </button>
      </div>
    </form>
  </div>

</div>