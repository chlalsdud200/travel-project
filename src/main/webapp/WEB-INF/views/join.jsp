<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>

<style>
/* =========================================
   [Cleaned Style] Soft Blue & Modern Theme
   ========================================= */
:root {
  --brand-primary: #3b82f6; 
  --brand-hover: #2563eb;
  --text-main: #1e293b;
  --text-sub: #64748b;
  --bg-input: #f8fafc;
  --line-color: #e2e8f0;
  --shadow-soft: 0 10px 40px -10px rgba(59, 130, 246, 0.15);
}

* { box-sizing: border-box; }

body {
  margin: 0;
  background: linear-gradient(135deg, #f0f7ff 0%, #e0eaff 100%);
  color: var(--text-main);
  font-family: system-ui, -apple-system, sans-serif;
  min-height: 100vh;
}

.auth-wrap {
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 40px 20px;
}

.auth-card {
  width: 100%;
  max-width: 500px;
  background: #ffffff;
  border-radius: 24px;
  box-shadow: var(--shadow-soft);
  overflow: hidden;
}

.auth-card .hd {
  padding: 32px 32px 10px;
  text-align: center;
}

.auth-card .hd h1 {
  margin: 0;
  font-size: 24px;
  font-weight: 800;
  color: #1e3a8a;
}

.auth-card .bd {
  padding: 10px 32px 40px;
}

/* 입력 필드 레이아웃 */
.field {
  display: flex;
  flex-direction: column;
  gap: 6px;
  margin-top: 18px;
}

.field label {
  font-weight: 700;
  font-size: 13px;
  color: #475569;
  margin-left: 4px;
}

.field input, .field select {
  height: 48px;
  padding: 0 16px;
  border-radius: 12px;
  border: 1px solid var(--line-color);
  background: var(--bg-input);
  color: #334155;
  font-size: 14px;
  outline: none;
  transition: all 0.2s ease;
}

.field input:focus {
  background: #fff;
  border-color: var(--brand-primary);
  box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
}

/* 버튼 및 행 배치 */
.row {
  display: flex;
  gap: 8px;
  align-items: center;
}
.row .grow { flex: 1; }

.btn-mini {
  height: 48px;
  padding: 0 18px;
  border-radius: 12px;
  background: #eff6ff;
  color: var(--brand-primary);
  font-weight: 700;
  font-size: 13px;
  cursor: pointer;
  border: 1px solid #dbeafe;
  transition: all 0.2s;
}
.btn-mini:hover:not(:disabled) {
  background: #dbeafe;
  color: #1d4ed8;
}
.btn-mini:disabled {
  background: #f1f5f9;
  color: #cbd5e1;
  cursor: not-allowed;
}

.btn-dark {
  background: #334155;
  color: #fff;
  border: none;
}
.btn-dark:hover { background: #1e293b; color:#fff;}

/* 텍스트 메시지 */
.msg {
  font-size: 12px;
  margin-top: 4px;
  margin-left: 4px;
  min-height: 16px;
  font-weight: 500;
}
.help {
  font-size: 12px;
  color: #94a3b8;
  margin-top: 4px;
  margin-left: 4px;
}

/* 약관 박스 스타일 */
.terms-box {
  height: 80px;
  overflow-y: auto;
  border: 1px solid #e2e8f0;
  background: #f8fafc;
  border-radius: 10px;
  padding: 12px;
  font-size: 12px;
  color: #64748b;
  line-height: 1.6;
  margin-bottom: 8px;
}

.agree-row {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 13px;
  color: #334155;
  cursor: pointer;
  margin-bottom: 12px;
  padding-left: 4px;
}
.agree-row input[type="checkbox"] {
  width: 18px;
  height: 18px;
  accent-color: var(--brand-primary);
  cursor: pointer;
}
.agree-row.all-agree {
  padding: 16px;
  background: #eff6ff;
  border: 1px solid #bfdbfe;
  border-radius: 12px;
  font-weight: 700;
  color: #1e40af;
  margin-bottom: 16px;
}

/* 제출 버튼 */
.submit {
  margin-top: 30px;
  width: 100%;
  height: 52px;
  border: 0;
  border-radius: 14px;
  background: var(--brand-primary);
  color: #fff;
  font-weight: 800;
  font-size: 16px;
  cursor: pointer;
  box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25);
  transition: transform 0.1s, background 0.2s;
}
.submit:hover {
  background: var(--brand-hover);
  transform: translateY(-1px);
}

.linkRow {
  margin-top: 20px;
  font-size: 13px;
  color: var(--text-sub);
  text-align: center;
}
.linkRow a {
  color: var(--brand-primary);
  font-weight: 700;
  text-decoration: none;
  margin-left: 4px;
}
.panel {
  background: #fef2f2;
  border: 1px solid #fecaca;
  padding: 12px 16px;
  border-radius: 12px;
  margin-bottom: 20px;
  font-weight: 700;
  color: #dc2626;
  font-size: 13px;
}
.field input::placeholder{
  color: #94a3b8;    /* 연한 회색 */
}
</style>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>

<body data-ctx="${pageContext.request.contextPath}">

<div class="auth-wrap">
  <div class="auth-card">
    <div class="hd">
      <h1>회원가입</h1>
    </div>

    <div class="bd">
      <c:if test="${not empty err}">
        <div class="panel">⚠️ ${err}</div>
      </c:if>

      <form id="join" method="post" action="${pageContext.request.contextPath}/join.do">

        <div class="field">
          <label for="name">이름</label>
          <input id="name" name="userName" placeholder="실명을 입력하세요" value="${f_userName}">
        </div>

        <div class="field">
          <label for="id">아이디</label>
          <div class="row">
            <input class="grow" id="id" name="userId" placeholder="아이디 입력" value="${f_userId}">
            <button class="btn-mini" type="button" id="idCheck" disabled>중복확인</button>
          </div>
          <div id="idspan" class="msg"></div>
        </div>

        <div class="field">
          <label for="pass">비밀번호</label>
          <input type="password" id="pass" name="userPass" placeholder="영문, 숫자 포함 8자 이상">
          <div class="help">영문 + 숫자 조합 8자 이상</div>
        </div>

        <div class="field">
          <label for="passcheck">비밀번호 확인</label>
          <input type="password" id="passcheck" placeholder="비밀번호를 다시 입력하세요">
          <div id="passspan" class="msg"></div>
        </div>

        <div class="field">
          <label for="email">이메일</label>
          <input type="email" id="email" name="userEmail" placeholder="example@email.com" value="${f_userEmail}">
          <div class="row" style="margin-top:8px;">
            <input type="button" value="인증메일 발송" id="btnEmailSend" class="btn-mini btn-dark" style="width:100%; cursor:pointer;">
          </div>
          <div class="msg" id="emailVerifyMsg"></div>
        </div>

        <div class="field">
          <label for="bir">생년월일</label>
          <input type="date" id="bir" name="userBir" value="${f_userBir}">
        </div>

        <div class="field">
          <label for="tel">전화번호</label>
          <input type="tel" id="tel" name="userTel" placeholder="010-0000-0000" value="${f_userTel}">
        </div>

        <div class="field">
          <label>주소</label>
          <div class="row">
            <input class="grow" id="postcode" name="userZip" readonly placeholder="우편번호" value="${f_userZip}">
            <button class="btn-mini btn-dark" type="button" onclick="execDaumPostcode()">검색</button>
          </div>
          <div style="height:8px;"></div>
          <input id="roadAddress" name="userAddr1" readonly placeholder="기본주소" value="${f_userAddr1}">
          <div style="height:8px;"></div>
          <input id="detailAddress" name="userAddr2" placeholder="상세주소" value="${f_userAddr2}">
        </div>

        <div class="field" style="margin-top: 32px;">
          <label style="margin-bottom:8px; display:block;">약관동의</label>
          
          <div class="agree-row all-agree">
            <input type="checkbox" id="checkAll">
            <label for="checkAll">약관 전체 동의하기</label>
          </div>

          <div class="terms-box">
            제1조(목적)<br>
            본 약관은 회사(이하 "갑")가 제공하는 서비스의 이용조건 및 절차... (생략)
          </div>
          <div class="agree-row">
            <input type="checkbox" id="term1" name="agreeTerms">
            <label for="term1"><span style="color:var(--brand-primary)">(필수)</span> 이용약관에 동의합니다.</label>
          </div>

          <div class="terms-box">
            1. 수집하는 개인정보 항목<br>
            ... (개인정보 방침 내용) ...
          </div>
          <div class="agree-row">
            <input type="checkbox" id="term2" name="agreePrivacy">
            <label for="term2"><span style="color:var(--brand-primary)">(필수)</span> 개인정보 수집 및 이용에 동의합니다.</label>
          </div>
        </div>
        
        <button class="submit" type="submit">가입하기</button>

        <div class="linkRow">
          이미 계정이 있으신가요?
          <a href="${pageContext.request.contextPath}/login.do">로그인하기</a>
        </div>
      </form>
    </div>
  </div>
</div>

<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/@emailjs/browser@4/dist/email.min.js"></script>
<script type="text/javascript">
  // EmailJS 초기화 (기존 키 유지)
  emailjs.init({ publicKey: "q_5VW9U-UOb5wx-8u" });

  window.addEventListener("DOMContentLoaded", function () {
    var ctx = document.body.dataset.ctx || "";

    // ===== 상태 =====
    var idCheckedOk = false; //나중에 중복확인으로사용할거임
    var checkedId = ""; // 나중에 여기에 userId넣을거임
    var emailVerifiedOk = false;

    // ===== 요소 =====
    var joinForm = document.getElementById("join");

    var idText = document.getElementById("id");
    var btnId = document.getElementById("idCheck");
    var idSpan = document.getElementById("idspan");

    var passText = document.getElementById("pass");
    var passCheckText = document.getElementById("passcheck");
    var passSpan = document.getElementById("passspan");

    var checkAll = document.getElementById("checkAll");
    var term1 = document.getElementById("term1");
    var term2 = document.getElementById("term2");

    var telInput = document.getElementById("tel");

    var emailInput = document.getElementById("email");
    var nameInput = document.getElementById("name");
    var btnEmailSend = document.getElementById("btnEmailSend");
    var emailMsg = document.getElementById("emailVerifyMsg");

    // EmailJS (기존 값 유지)
    var SERVICE_ID  = "service_yv5z8nu";
    var TEMPLATE_ID = "template_sicowx5";

    // ===== 공통 =====
    function setMsg(el, text, color){
      if(!el) return; //널이면 true -> return
      
      el.textContent = text || ""; 
      if(color) el.style.color = color;
      else el.style.color = "";
    }

    const getJson = async (url) => {
    	  const res = await fetch(url);
    	  if (!res.ok) throw new Error("HTTP " + res.status);
    	  return await res.json();
    	};

    // =========================
    // 1) 아이디 중복검사
    // =========================
    var idReg = /^[a-z][a-zA-Z0-9]{3,19}$/;

    idText.addEventListener("input", function(){
      idCheckedOk = false;
      checkedId = "";
      setMsg(idSpan, "");    //idSpan에 찍히는 , 텍스트 ( 첫번쨰 아니면  리턴 있으면 text내용 아니면 공백 현재는 공백) 의색, color로해라(지금은 없으니 undegfined)
    });

    idText.addEventListener("keyup", function(){
      var v = idText.value.trim();
      if (idReg.test(v)) { //.test는 패턴확인 검사 기본제공 기능 합격이면 true반환
        idText.style.border = "2px solid #3b82f6";
        btnId.disabled = false;
      } else {
        idText.style.border = "2px solid #ef4444";
        btnId.disabled = true; //불합격이면 즉시 버튼 비활성화
      }
    });

    btnId.addEventListener("click", async function(){
      var userId = idText.value.trim();

      if (!userId) { alert("아이디를 입력해주세요"); return; } //널이면
      if (!idReg.test(userId)) { // 형식에 안맞으면
        setMsg(idSpan, "아이디 형식이 올바르지 않습니다.", "#ef4444");
        return;   //사실 일반적으로는 괜찮지만 f12를통한 html조작이나 또는 keyup에서 키보드를 치지않고 마우스우클릭으로 복붙할때 를 방지하기위한 이중장치 
      }

      try {
        var data = await getJson(ctx + "/existsId.do?userId=" + encodeURIComponent(userId));

        if (!data.success) { // false면 = result.put("message", "userId is required")result.put("exists", false);
        	setMsg(idSpan, data.message || "중복검사 중 오류가 발생했습니다.", "#ef4444");
          idCheckedOk = false; checkedId = "";
          return;
        }

        if (data.exists) { //true면 =  result.put("success", true);result.put("count", cnt);
          setMsg(idSpan, "이미 사용 중인 아이디입니다.", "#ef4444");
          idCheckedOk = false; checkedId = "";
        } else {
          setMsg(idSpan, "사용 가능한 아이디입니다.", "#3b82f6");
          idCheckedOk = true; checkedId = userId;
        }
      } catch (e) {
        console.error(e);
        setMsg(idSpan, "서버 통신 오류가 발생했습니다.", "#ef4444");
        idCheckedOk = false; checkedId = "";
      }
    });

    // =========================
    // 2) 비밀번호 일치 확인
    // =========================
    function checkPasswordMatch(){
      var p1 = passText.value.trim();
      var p2 = passCheckText.value.trim();

      if (!p1 && !p2) { setMsg(passSpan, ""); return true; }

      if (p1 !== p2) {
        setMsg(passSpan, "비밀번호가 일치하지 않습니다.", "#ef4444");
        return false;
      }
      setMsg(passSpan, "비밀번호가 일치합니다.", "#3b82f6");
      return true;
    }

    passText.addEventListener("keyup", checkPasswordMatch);
    passCheckText.addEventListener("keyup", checkPasswordMatch); 
    // 뒤에 괄호가 없는데 괄호있으면 당장실행 , 괄호없으면  keyup할때 실행
    // 둘다 하는 이유 : 1234,1234 쓰고 나중에 위에서 12345 고치면 아래서만 체크하면 일치한다고 뜨니까

    // =========================
    // 3) 약관 전체동의 ↔ 개별동의
    // =========================
    checkAll.addEventListener("change", function(){
      var checked = checkAll.checked;
      term1.checked = checked;
      term2.checked = checked;
    });

    function updateCheckAll(){
      checkAll.checked = (term1.checked && term2.checked);
    }
    term1.addEventListener("change", updateCheckAll);
    term2.addEventListener("change", updateCheckAll);

    // =========================
    // 4) 전화번호 자동 하이픈(간단)
    // =========================
    function formatKRTel(v){
      var digits = String(v || "").replace(/\D/g, "").slice(0, 11);
      if (digits.length <= 3) return digits;
      if (digits.length <= 7) return digits.slice(0,3) + "-" + digits.slice(3);
      return digits.slice(0,3) + "-" + digits.slice(3,7) + "-" + digits.slice(7);
    }

    telInput.addEventListener("input", function(){
      telInput.value = formatKRTel(telInput.value);
    });

    telInput.addEventListener("blur", function(){
      var v = telInput.value.trim();
      telInput.style.border = (v && !/^010-\d{4}-\d{4}$/.test(v)) ? "1px solid #ef4444" : "";
    });

    // =========================
    // 5) 이메일 인증(토큰 발급 + EmailJS 발송 + 서버 인증여부 확인)
    // =========================
    function setEmailMsg(text, ok){
      if (!emailMsg) return;
      emailMsg.textContent = text || "";
      if (ok === true) emailMsg.style.color = "#059669";
      else if (ok === false) emailMsg.style.color = "#dc2626";
      else emailMsg.style.color = "#475569";
    }

    function pendingEmail(){
      var v = emailInput.value.trim();
      return v ? v : (localStorage.getItem("tct_email_pending_email") || "").trim();
    }

    function savePendingEmail(){
      var v = emailInput.value.trim();
      if (v) localStorage.setItem("tct_email_pending_email", v);
      else localStorage.removeItem("tct_email_pending_email");
    }
    
    var emailCheckSeq = 0;
    async function checkVerified(email){
    	  if (!email) return false;

    	  // 이 호출의 고유 번호(나중에 입력이 바뀌면 무효화)
    	  var mySeq = ++emailCheckSeq;
    	  var emailAtCall = email;

    	  try {
    	    var data = await getJson(ctx + "/email/checkVerified.do?email=" + encodeURIComponent(emailAtCall));

    	    // 입력값이 바뀌었거나, 더 최신 요청이 있으면 이번 결과는 무시
    	    var nowEmail = (emailInput && emailInput.value) ? emailInput.value.trim() : "";
    	    if (mySeq !== emailCheckSeq) return false;
    	    if (nowEmail && nowEmail !== emailAtCall) return false;

    	    if (data && data.verified) {
    	      emailVerifiedOk = true;
    	      setEmailMsg("✅ 이메일 인증 완료", true);
    	      return true;
    	    }

    	    emailVerifiedOk = false;
    	    setEmailMsg("아직 인증이 완료되지 않았습니다.", false);
    	    return false;
    	  } catch (e) {
    	    console.error(e);

    	    // 최신 요청이 아니면 무시
    	    if (mySeq !== emailCheckSeq) return false;

    	    emailVerifiedOk = false;
    	    setEmailMsg("인증 확인 중 오류 발생", false);
    	    return false;
    	  }
    	}

    // 이메일 입력 변경 시: 인증상태 초기화 + pending 저장
    emailInput.addEventListener("input", function(){
      emailVerifiedOk = false;
      setEmailMsg("");
      savePendingEmail();
    });

    // 인증 완료 신호(localStorage) 수신 시 서버 재확인
    window.addEventListener("storage", function(e){
      if ((e.key === "tct_email_verified" && e.newValue === "1") || e.key === "tct_email_verified_at") {
        var em = pendingEmail();
        setEmailMsg("인증 확인 중...", null);
        checkVerified(em);
        localStorage.removeItem("tct_email_verified");
        localStorage.removeItem("tct_email_verified_at");
      }
    });

    // 초기 부팅 시: pending 또는 기존 입력으로 확인 시도
    (function boot(){
      // ★ 자동으로 checkVerified를 돌리지 않음(여기서 즉시 완료로 바뀌는 문제의 원인)
      // 오직 '인증 완료 신호'가 있을 때만 서버 재확인
      if (localStorage.getItem("tct_email_verified") === "1") {
        var em = pendingEmail();
        setEmailMsg("인증 확인 중...", null);
        checkVerified(em);
        localStorage.removeItem("tct_email_verified");
        localStorage.removeItem("tct_email_verified_at");
      }
    })();

    // 이메일 발송 버튼
    btnEmailSend.addEventListener("click", async function(){
      var email = emailInput.value.trim();
      var userName = nameInput.value.trim();

      if (!email) { setEmailMsg("이메일을 입력하세요.", false); return; }

      localStorage.setItem("tct_email_pending_email", email);

      try {
        setEmailMsg("⏳ 토큰 발급/메일 발송 중...", null);

        var issueData = await getJson(ctx + "/email/issueToken.do?email=" + encodeURIComponent(email));
        if (!issueData || !issueData.success) {
          setEmailMsg((issueData && issueData.message) ? issueData.message : "토큰 발급 실패", false);
          return;
        }

        await emailjs.send(SERVICE_ID, TEMPLATE_ID, {
          to_email: email,
          user_name: userName,
          verify_link: issueData.verifyLink,
          expires_minutes: issueData.expiresMinutes
        });

        setEmailMsg("📧 인증메일이 발송되었습니다. 메일함을 확인해주세요.", null);
      } catch (e) {
        console.error(e);
        setEmailMsg("메일 발송 실패", false);
      }
    });

    // =========================
    // 6) 최종 제출 검증
    // =========================
    joinForm.addEventListener("submit", function(e){
      var currentId = idText.value.trim();

      if (!checkPasswordMatch()) {
        e.preventDefault();
        passCheckText.focus();
        return;
      }

      if (!idCheckedOk || checkedId !== currentId) {
        e.preventDefault();
        setMsg(idSpan, "아이디 중복검사를 먼저 해주세요.", "#ef4444");
        return;
      }

      if (!term1.checked) {
        e.preventDefault();
        alert("이용약관(필수)에 동의해주셔야 가입이 가능합니다.");
        term1.focus();
        return;
      }
      if (!term2.checked) {
        e.preventDefault();
        alert("개인정보 수집 및 이용(필수)에 동의해주셔야 가입이 가능합니다.");
        term2.focus();
        return;
      }

      var tel = telInput.value.trim();
      if (!/^010-\d{4}-\d{4}$/.test(tel)) {
        e.preventDefault();
        alert("휴대폰 번호는 010-0000-0000 형식으로 입력해주세요.");
        telInput.focus();
        return;
      }

      if (!emailVerifiedOk) {
        e.preventDefault();
        setEmailMsg("⚠️ 이메일 인증을 완료해주세요.", false);
        return;
      }
    });
  });
</script>

<script>
  // 다음 주소 API (기존 로직 유지)
  function execDaumPostcode() {
    new daum.Postcode({
      oncomplete: function (data) {
        var roadAddr = data.roadAddress;
        document.getElementById("postcode").value = data.zonecode;
        document.getElementById("roadAddress").value = roadAddr;
        document.getElementById("detailAddress").focus();
      }
    }).open();
  }
</script>
</body>
</html>