/**
 * pwFind.js
 * - EmailJS REST 발송 + 코드 인증 + 비번 재설정(/pw/resetPw.do) + 로그인 이동
 * - 템플릿 변수명: to_email, code, name, email
 */

var CTX;
var pwFindPro;

pwFindPro = function(){

  if(typeof CTX === "undefined" || CTX === null) CTX = "";
  var userId = document.querySelector("#userId");

  var userEmail = document.querySelector("#userEmail");
  if(!userEmail) return;

  var code   = document.querySelector("#code");
  var newPw  = document.querySelector("#newPw");
  var newPw2 = document.querySelector("#newPw2");

  var btnSend    = document.querySelector("#btnSend");
  var btnVerify  = document.querySelector("#btnVerify");
  var btnResend  = document.querySelector("#btnResend");
  var btnReset   = document.querySelector("#btnReset");
  var btnGoLogin = document.querySelector("#btnGoLogin");
  var btnClose   = document.querySelector("#btnClose");

  var msgBox = document.querySelector("#msgBox");

  if(!code || !newPw || !newPw2 || !btnSend || !btnVerify || !btnResend || !btnReset || !btnGoLogin || !btnClose || !msgBox){
    console.log("pwFind.js: 필수 요소 누락");
    return;
  }

  var showMsg = function(ok, text){
    msgBox.innerHTML = '<div class="msg ' + (ok ? 'ok' : 'err') + '">' + (text || "") + '</div>';
  };

  var closeModal = function(){
    if(window.parent && typeof window.parent.closeModal === "function"){
      window.parent.closeModal();
    }
  };

  var goLogin = function(){
    closeModal();
    if(window.parent){
      window.parent.location.href = CTX + "/login.do";
    }else{
      location.href = CTX + "/login.do";
    }
  };

  btnGoLogin.addEventListener("click", goLogin);
  btnClose.addEventListener("click", closeModal);

  var now = function(){ return new Date().getTime(); };
  var isEmail = function(v){ return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v); };
  var make6Digit = function(){ return String(Math.floor(100000 + Math.random() * 900000)); };

  // sessionStorage 키
  var KEY_MAIL = "PW_EMAIL";
  var KEY_ID   = "PW_ID";
  var KEY_CODE = "PW_CODE";
  var KEY_EXP  = "PW_EXP";
  var KEY_VER  = "PW_VERIFIED"; // "Y"/"N"

  var saveCode = function(userIdValue, email, codeValue){
      sessionStorage.setItem(KEY_ID, userIdValue);
      sessionStorage.setItem(KEY_MAIL, email);
      sessionStorage.setItem(KEY_CODE, codeValue);
      sessionStorage.setItem(KEY_EXP, String(now() + (3 * 60 * 1000)));
      sessionStorage.setItem(KEY_VER, "N");
    };

  var isExpired = function(){
    var exp = Number(sessionStorage.getItem(KEY_EXP) || "0");
  };

  var stepSent = function(){
    code.disabled = false;
    btnVerify.disabled = false;
    btnResend.disabled = false;
  };

  var stepVerified = function(){
    code.disabled = true;
    btnVerify.disabled = true;
    sessionStorage.setItem(KEY_VER, "Y");

    // ✅ 비번 입력 활성화
    newPw.disabled = false;
    newPw2.disabled = false;
    btnReset.disabled = false;
  };

  // EmailJS REST 발송
  var sendEmailByEmailJS = function(toEmail, codeValue){
    var url = "https://api.emailjs.com/api/v1.0/email/send";

    var payload = {
      service_id: window.EMAILJS_SERVICE_ID,
      template_id: window.EMAILJS_TEMPLATE_ID,
      user_id: window.EMAILJS_PUBLIC_KEY, // 브라우저는 Public Key
      template_params: {
        to_email: toEmail,
        code: codeValue,
        name: "TRYCATCHTRIP",
        email: toEmail
      }
    };

    return fetch(url, {
      method: "POST",
      headers: { "content-type": "application/json;charset=UTF-8" },
      body: JSON.stringify(payload)
    }).then(function(resp){
      if(!resp.ok){
        return resp.text().then(function(t){ throw new Error("EmailJS HTTP " + resp.status + " " + t); });
      }
      return resp.text();
    });
  };

  // ✅ 서버로 비밀번호 업데이트 (getParameter용: x-www-form-urlencoded)
  var postForm = function(url, obj){
    var params = new URLSearchParams();
    for(var k in obj){ params.append(k, obj[k]); }

    return fetch(url, {
      method: "post",
      headers: { "content-type": "application/x-www-form-urlencoded;charset=UTF-8" },
      body: params.toString()
    }).then(function(resp){
      if(!resp.ok){
        return resp.text().then(function(t){ throw new Error("HTTP " + resp.status + " " + t); });
      }
      // 서버가 json 주면 json, 아니면 text -> 일단 json 시도
      return resp.text().then(function(t){
        try { return JSON.parse(t); } catch(e) { return { flag:"ok", msg:t }; }
      });
    });
  };
  var checkIdEmailMatch = function(vId, vEmail){
     return postForm(CTX + "/pw/matchIdEmail.do", { userId: vId, userEmail: vEmail });
   };

  // 1) 발송
  btnSend.addEventListener("click", function(){
    var vId    = (userId && userId.value ? userId.value : "").trim();
    var vEmail = (userEmail.value || "").trim();

    if(vId.length === 0){
      showMsg(false, "아이디를 입력하세요.");
      return;
    }
    if(vEmail.length === 0){
      showMsg(false, "이메일을 입력하세요.");
      return;
    }
    if(!isEmail(vEmail)){
      showMsg(false, "이메일 형식이 올바르지 않습니다.");
      return;
    }

    btnSend.disabled = true;
    btnVerify.disabled = true;
    btnResend.disabled = true;

    // 0) 먼저 아이디/이메일 매칭 검사
    checkIdEmailMatch(vId, vEmail)
      .then(function(r){
        // r: {ok:true/false, msg:"..."}
        if(!r || r.ok !== true){
          showMsg(false, (r && r.msg) ? r.msg : "아이디/이메일이 일치하지 않습니다.");
          btnSend.disabled = false;
          return;
        }

        // 1) 매칭 OK면 인증코드 발송 진행
        var codeValue = make6Digit();
        saveCode(vId, vEmail, codeValue);

        return sendEmailByEmailJS(vEmail, codeValue)
          .then(function(){
            showMsg(true, "아이디/이메일 확인 완료. 인증코드를 발송했습니다. (3분 제한)");
            stepSent();
          });
      })
      .catch(function(err){
        console.log(err);
        showMsg(false, "처리 실패(매칭/메일 발송). 서버/네트워크를 확인하세요.");
        btnSend.disabled = false;
      });
  });


  // 재발송
  btnResend.addEventListener("click", function(){
    btnSend.disabled = false;
    btnSend.click();
  });

  // 2) 코드 확인
  btnVerify.addEventListener("click", function(){
    var vEmail = (userEmail.value || "").trim();
    var vCode  = (code.value || "").trim();
	var savedId = (sessionStorage.getItem(KEY_ID) || "");
	if(savedId !== (userId.value || "").trim()){
	  showMsg(false, "처음 입력한 아이디와 현재 아이디가 다릅니다.");
	  return;
	}


    if(vEmail.length === 0 || vCode.length === 0){
      showMsg(false, "이메일/코드를 확인하세요.");
      return;
    }

    if(isExpired()){
      showMsg(false, "인증시간이 만료되었습니다. 재발송 해주세요.");
      return;
    }

    var savedEmail = (sessionStorage.getItem(KEY_MAIL) || "");
    var savedCode  = (sessionStorage.getItem(KEY_CODE) || "");

    if(savedEmail !== vEmail){
      showMsg(false, "발송한 이메일과 입력한 이메일이 다릅니다.");
      return;
    }
    if(savedCode !== vCode){
      showMsg(false, "인증코드가 일치하지 않습니다.");
      return;
    }

    stepVerified();
    showMsg(true, "인증이 완료되었습니다. 새 비밀번호를 입력하세요.");
  });

  // 3) 비번 변경 → 성공 시 로그인 이동
  btnReset.addEventListener("click", function(){
    var verified = (sessionStorage.getItem(KEY_VER) || "N");
    if(verified !== "Y"){
      showMsg(false, "먼저 이메일 인증을 완료하세요.");
      return;
    }

    if(isExpired()){
      showMsg(false, "인증시간이 만료되었습니다. 재발송 해주세요.");
      return;
    }

    var vEmail = (userEmail.value || "").trim();
    var p1 = (newPw.value || "").trim();
    var p2 = (newPw2.value || "").trim();

    if(p1.length === 0 || p2.length === 0){
      showMsg(false, "새 비밀번호를 입력하세요.");
      return;
    }
    if(p1 !== p2){
      showMsg(false, "비밀번호가 일치하지 않습니다.");
      return;
    }

    btnReset.disabled = true;

    // ✅ 서버 서블릿 매핑: /pw/resetPw.do
    postForm(CTX + "/pw/resetPw.do", { userEmail: vEmail, newPw: p1 })
	var vId = (userId.value || "").trim();

	    postForm(CTX + "/pw/resetPw.do", { userId: vId, userEmail: vEmail, newPw: p1 })
      .then(function(data){
        // 서버 응답 형태가 제각각일 수 있어서 flag/msg 둘 다 대응
        var ok = (data && (data.flag === "ok" || data.ok === true));
        var msg = (data && data.msg) ? data.msg : (ok ? "비밀번호가 변경되었습니다." : "변경 실패");

        if(ok){
          showMsg(true, msg);
          // 인증정보 정리
          sessionStorage.removeItem(KEY_VER);
          sessionStorage.removeItem(KEY_CODE);
          sessionStorage.removeItem(KEY_EXP);
          // 로그인으로 이동
          goLogin();
        }else{
          showMsg(false, msg);
          btnReset.disabled = false;
        }
      })
      .catch(function(err){
        console.log(err);
        showMsg(false, "서버 통신 오류(비밀번호 변경)");
        btnReset.disabled = false;
      });
  });

  // 초기 상태
  btnVerify.disabled = true;
  btnResend.disabled = true;
  btnReset.disabled = true;
};

window.addEventListener("DOMContentLoaded", pwFindPro);
