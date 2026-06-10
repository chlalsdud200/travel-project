/**
 * mypage.profile.js
 * - 역할: 회원정보수정(profile) 탭의 fragment 로딩 + submit 처리 + 이메일 인증(UI)
 * - 존재이유: profile 로직이 core의 탭/데이터 로딩과 성격이 달라서 독립 모듈로 분리
 */

window.MypageProfile = (function(){

  // [의미] profileArea는 profile 탭 내부에서만 갱신되는 영역(비번확인/수정폼이 이곳에 들어옴)
  const profileArea = document.getElementById("profileArea");

  // [의미] EmailJS 초기화(있을 때만) - 이메일 인증메일 발송을 위해
  try {
    if (window.emailjs) {
      emailjs.init({ publicKey: "q_5VW9U-UOb5wx-8u" });
    }
  } catch(e) { console.error(e); }

  /* =========================
     1) pwCheck fragment 로드
     ========================= */

  async function loadPwCheckIntoProfileArea(){
    if(!profileArea) return;

    const returnUrl = CTX + "/editProfile.do?embed=1";
    const url = CTX + "/pwCheck.do?embed=1&return=" + encodeURIComponent(returnUrl);

    const res = await fetch(url, { method: "GET" });
    const html = await res.text();

    // [의미] 최초 placeholder 제거(있으면)
    const ph = document.getElementById("profilePlaceholder");
    if (ph) ph.remove();

    profileArea.innerHTML = html;
  }

  // [의미] profile 탭을 열 때 호출되는 진입점(core가 여기만 호출)
  function open(){
    // profile 탭이면 항상 pwCheck부터 보여주는 현재 정책을 유지
    setTimeout(() => loadPwCheckIntoProfileArea(), 0);
  }

  /* =========================
     2) profile submit(비번확인/저장)
     ========================= */

  if (profileArea) {
    // [의미] profileArea 내부는 fragment로 계속 바뀌므로 "event delegation"으로 submit 1곳에서 받는다.
    profileArea.addEventListener("submit", async (e) => {
      const form = e.target;
      if (!(form instanceof HTMLFormElement)) return;
      if (form.id !== "pwCheckForm" && form.id !== "editProfileForm") return;

      e.preventDefault();

      // (A) 비밀번호 변경 검증(회원가입과 동일 규칙) - 변경 의사 있을 때만 검사
      if (form.id === "editProfileForm") {
        const newPass  = (form.querySelector("#userPass")?.value || "").trim();
        const newPass2 = (form.querySelector("#userPass2")?.value || "").trim();

        const pwRule = /^(?=.*[A-Za-z])(?=.*\d).{8,}$/;

        const pwRuleMsg  = form.querySelector("#pwRuleMsg");
        const pwMatchMsg = form.querySelector("#pwMatchMsg");

        const setMsg = (el, msg, ok) => {
          if (!el) return;
          el.textContent = msg || "";
          el.style.color = ok ? "#15803d" : "#b91c1c";
        };

        if (newPass.length > 0 || newPass2.length > 0) {
          if (!pwRule.test(newPass)) {
            setMsg(pwRuleMsg, "영문+숫자 포함 8자 이상만 가능합니다.", false);
            setMsg(pwMatchMsg, "", false);
            alert("새 비밀번호 규칙을 확인하세요.");
            return;
          } else {
            setMsg(pwRuleMsg, "비밀번호 형식 OK", true);
          }

          if (newPass !== newPass2) {
            setMsg(pwMatchMsg, "비밀번호가 일치하지 않습니다.", false);
            alert("새 비밀번호 확인이 일치하지 않습니다.");
            return;
          } else {
            setMsg(pwMatchMsg, "비밀번호 일치", true);
          }
        } else {
          if (pwRuleMsg) pwRuleMsg.textContent = "";
          if (pwMatchMsg) pwMatchMsg.textContent = "";
        }
      }

      // (B) 이메일 변경 시 인증 상태 체크(미인증이면 저장 차단)
      if (form.id === "editProfileForm") {
        const emailInput  = form.querySelector("#userEmail");
        const origEmailEl = profileArea.querySelector("#origEmail");

        const now  = (emailInput  && emailInput.value) ? emailInput.value.trim() : "";
        const orig = (origEmailEl && origEmailEl.value) ? origEmailEl.value.trim() : "";

        if (now && orig && now !== orig) {
          const checkUrl = CTX + "/email/checkVerified.do?email=" + encodeURIComponent(now);
          const vr = await fetch(checkUrl, { method: "GET" });
          const vd = await vr.json();
          if (!vd || !vd.verified) {
            alert("Email verification is required after changing your email. Please verify first.");
            return;
          }
        }
      }

      // (C) 폼 전송은 기존 정책대로 x-www-form-urlencoded로 보낸다.
      const fd = new FormData(form);
      const params = new URLSearchParams();
      fd.forEach((v, k) => params.append(k, v));

      const method = (form.method || "POST").toUpperCase();

      const res = await fetch(form.action, {
        method,
        headers: { "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8" },
        body: params.toString()
      });

      const html = await res.text();
      profileArea.innerHTML = html;

      // [의미] 저장 성공 표시가 있으면 pay 탭으로 이동(기존 동작 유지)
      const ok = document.getElementById("profileSaveOk");
      if (ok) {
        location.hash = '#pay';
      }

      try { refreshProfileEmailStatus(); } catch(e) {}
    });
  }

  /* =========================
     3) 이메일 인증 UI(발송/확인)
     ========================= */

  const PROFILE_SERVICE_ID  = "service_yv5z8nu";
  const PROFILE_TEMPLATE_ID = "template_sicowx5";

  function profileEls(){
    if(!profileArea) return {};
    return {
      emailInput: profileArea.querySelector('#userEmail'),
      nameInput:  profileArea.querySelector('#userName'),
      origEmail:  profileArea.querySelector('#origEmail'),
      btnSend:    profileArea.querySelector('#btnEmailSendProfile'),
      btnCheck:   profileArea.querySelector('#btnEmailCheckProfile'),
      msgEl:      profileArea.querySelector('#emailVerifyMsgProfile')
    };
  }

  function setProfileEmailMsg(text, ok){
    const els = profileEls();
    if(!els.msgEl) return;
    els.msgEl.textContent = text || '';
    if(ok === true) els.msgEl.style.color = '#059669';
    else if(ok === false) els.msgEl.style.color = '#dc2626';
    else els.msgEl.style.color = '#475569';
  }

  function isProfileEmailChanged(){
    const els = profileEls();
    const now  = (els.emailInput && els.emailInput.value) ? els.emailInput.value.trim() : '';
    const orig = (els.origEmail && els.origEmail.value) ? els.origEmail.value.trim() : '';
    return (now && orig && now !== orig);
  }

  async function profileCheckVerified(email){
    const checkUrl = CTX + '/email/checkVerified.do?email=' + encodeURIComponent(email);
    const res = await fetch(checkUrl, { method: 'GET' });
    const data = await res.json();
    return !!(data && data.verified);
  }

  async function refreshProfileEmailStatus(){
    const els = profileEls();
    if(!els.emailInput) return;

    const now = (els.emailInput.value || '').trim();
    if(!now){
      if(els.btnCheck) els.btnCheck.disabled = true;
      setProfileEmailMsg('', null);
      return;
    }

    if(!isProfileEmailChanged()){
      if(els.btnCheck) els.btnCheck.disabled = true;
      setProfileEmailMsg('현재 이메일 유지 중(인증 불필요)', true);
      return;
    }

    if(els.btnCheck) els.btnCheck.disabled = false;
    setProfileEmailMsg('인증 확인 중...', null);

    const ok = await profileCheckVerified(now);
    if(ok) setProfileEmailMsg('✅ 이메일 인증 완료', true);
    else   setProfileEmailMsg('⚠️ 변경한 이메일은 인증이 필요합니다.', false);
  }

  // [의미] confirm 페이지가 localStorage를 갱신했을 때 상태를 다시 읽어 UI 갱신
  window.addEventListener('storage', function(e){
    if ((e.key === 'tct_email_verified' && e.newValue === '1') || e.key === 'tct_email_verified_at') {
      refreshProfileEmailStatus();
    }
  });

  if (profileArea) {
    // [의미] fragment가 교체되어도 버튼 이벤트가 유지되게 click delegation으로 처리
    profileArea.addEventListener('click', async (e) => {
      const t = e.target;
      if(!(t instanceof HTMLElement)) return;

	  
	  // (0) placeholder의 "비밀번호 확인" 버튼 클릭 → pwCheck fragment 로드
	  if (t.id === 'btnOpenPwCheck') {
	    loadPwCheckIntoProfileArea();
	  }

	  
      // (1) 인증메일 발송
      if (t.id === 'btnEmailSendProfile') {
        const els = profileEls();
        const email = (els.emailInput && els.emailInput.value) ? els.emailInput.value.trim() : '';
        const userName = (els.nameInput && els.nameInput.value) ? els.nameInput.value.trim() : '';

        if(!email){ setProfileEmailMsg('이메일을 입력하세요.', false); return; }
        if(!isProfileEmailChanged()){
          setProfileEmailMsg('이메일을 변경한 경우에만 인증이 필요합니다.', null);
          return;
        }

        localStorage.setItem('tct_email_pending_email', email);

        const issueUrl = CTX + '/email/issueToken.do?email=' + encodeURIComponent(email);
        const issueRes = await fetch(issueUrl, { method: 'GET' });
        const issueData = await issueRes.json();

        if(!issueData || !issueData.success){
          setProfileEmailMsg((issueData && issueData.message) ? issueData.message : '토큰 발급 실패', false);
          return;
        }

        const params = {
          to_email: email,
          user_name: userName,
          verify_link: issueData.verifyLink,
          expires_minutes: issueData.expiresMinutes
        };

        await emailjs.send(PROFILE_SERVICE_ID, PROFILE_TEMPLATE_ID, params);
        setProfileEmailMsg('📧 인증메일이 발송되었습니다. 메일함을 확인해주세요.', null);

        if(els.btnCheck) els.btnCheck.disabled = false;
      }

      // (2) 인증확인
      if (t.id === 'btnEmailCheckProfile') {
        await refreshProfileEmailStatus();
      }
    });

    // [의미] 이메일 입력이 바뀌면 "인증 상태"는 다시 확인해야 하므로 메시지 초기화
    profileArea.addEventListener('input', (e) => {
      const t = e.target;
      if(!(t instanceof HTMLElement)) return;

      if(t.id === 'userEmail') {
        const els = profileEls();
        const v = (els.emailInput && els.emailInput.value) ? els.emailInput.value.trim() : '';
        if(v) localStorage.setItem('tct_email_pending_email', v);
        else  localStorage.removeItem('tct_email_pending_email');

        if(els.btnCheck) els.btnCheck.disabled = true;
        setProfileEmailMsg('', null);
      }
    });
  }

  return { open };
})();
