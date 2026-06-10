<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  String ctx = request.getContextPath();

  String returnUrl = (String) request.getAttribute("returnUrl");
  if (returnUrl == null || returnUrl.trim().isEmpty()) {
    returnUrl = ctx + "/editProfile.do?embed=1";
  }

  String msg = (String) request.getAttribute("msg");
%>

<style>
  /* fragment 내부에서만 쓰는 스타일: prefix로 충돌 최소화 */
 .pwchk-wrap{
  width:100%;
  display:flex;
  flex-direction:column;
  gap:14px;

  /* 카드처럼 보이는 요소 제거 */
  padding: 6px 0;          /* 안쪽 여백 최소화 (원하면 10px) */
  border-radius: 0;        /* 라운드 제거 */
  background: transparent; /* 카드 배경 제거 */
  border: 0;               /* ✅ 테두리 제거 */
  box-shadow: none;        /* ✅ 그림자 제거 */
}


  /* ✅ 마이페이지 안에서는 절대 max-width 제한하지 않음 */
  .pwchk-wrap{ max-width:none; }

  .pwchk-head{
    display:flex;
    align-items:flex-start;
    justify-content:space-between;
    gap:12px;
  }
  .pwchk-title{
    display:flex;
    flex-direction:column;
    gap:4px;
  }
  .pwchk-title b{
    font-size:16px;
    font-weight:900;
    letter-spacing:-.2px;
    color:#111827;
  }
  .pwchk-title span{
    font-size:12px;
    font-weight:700;
    color: rgba(17,24,39,.55);
  }
  .pwchk-badge{
    display:inline-flex;
    align-items:center;
    gap:8px;
    padding:8px 10px;
    border-radius:999px;
    background: rgba(37,99,235,.08);
    border:1px solid rgba(37,99,235,.16);
    color:#1d4ed8;
    font-size:12px;
    font-weight:900;
    white-space:nowrap;
  }
  .pwchk-msg{
    padding:10px 12px;
    border-radius:12px;
    background: rgba(220,38,38,.07);
    border:1px solid rgba(220,38,38,.16);
    color:#b91c1c;
    font-size:12px;
    font-weight:900;
  }

  .pwchk-field{
    display:flex;
    flex-direction:column;
    gap:8px;
  }
  	/* ✅ 입력 영역 폭을 적당히 제한 (너무 길어 보이는 것 방지) */
.pwchk-field,
.pwchk-msg{
  max-width: 520px;   /* 원하는 값으로 조절: 420~560 추천 */
}

/* ✅ 화면이 좁을 때는 다시 100%로 */
@media (max-width: 700px){
  .pwchk-field,
  .pwchk-msg{
    max-width: 100%;
  }
}
  	
  .pwchk-label{
    font-size:12px;
    font-weight:900;
    color:#111827;
  }
  .pwchk-inputbox{
    position:relative;
    display:flex;
    align-items:center;
  }
  .pwchk-input{
    width:100%;
    height:44px;
    padding:0 56px 0 12px;
    border:1px solid rgba(17,24,39,.14);
    border-radius:12px;
    background: rgba(255,255,255,.9);
    outline:none;
    font-size:14px;
  }
  .pwchk-input:focus{
    border-color: rgba(37,99,235,.45);
    box-shadow: 0 0 0 4px rgba(37,99,235,.12);
  }
  .pwchk-toggle{
    position:absolute;
    right:8px;
    height:32px;
    padding:0 10px;
    border-radius:10px;
    border:1px solid rgba(17,24,39,.12);
    background: rgba(255,255,255,.9);
    cursor:pointer;
    display:flex;
    align-items:center;
    justify-content:center;
    font-weight:900;
    color: rgba(17,24,39,.65);
    user-select:none;
  }

  .pwchk-help{
    display:flex;
    justify-content:space-between;
    align-items:center;
    gap:10px;
    font-size:12px;
    color: rgba(17,24,39,.55);
    font-weight:700;
  }
  .pwchk-caps{
    display:none;
    padding:8px 10px;
    border-radius:12px;
    background: rgba(245,158,11,.10);
    border:1px solid rgba(245,158,11,.22);
    color:#92400e;
    font-weight:900;
  }

  .pwchk-actions{
    display:flex;
    justify-content:flex-end;
    gap:10px;
    margin-top:4px;
  }
  .pwchk-btn{
    height:40px;
    padding:0 14px;
    border-radius:12px;
    border:1px solid rgba(17,24,39,.12);
    background: rgba(255,255,255,.85);
    font-weight:900;
    cursor:pointer;
  }
  .pwchk-btn-primary{
    border:1px solid rgba(37,99,235,.32);
    background: rgba(37,99,235,.10);
    color:#1d4ed8;
  }
  .pwchk-btn-primary:hover{
    background: rgba(37,99,235,.14);
  }
</style>

<div class="pwchk-wrap">
  <div class="pwchk-head">
    <div class="pwchk-title">
      <b>비밀번호 확인</b>
      <span>개인정보 보호를 위해 한 번 더 확인합니다.</span>
    </div>
    <div class="pwchk-badge" aria-label="보안 확인">
      <span style="font-size:14px; line-height:1;">🔒</span>
      보안 확인
    </div>
  </div>

  <% if (msg != null && !msg.trim().isEmpty()) { %>
    <div class="pwchk-msg"><%= msg %></div>
  <% } %>

  <form id="pwCheckForm" action="<%=ctx%>/pwCheck.do?embed=1" method="post" autocomplete="off">
    <input type="hidden" name="return" value="<%=returnUrl%>" />
	<input type="hidden" name="embed" value="1" />

    <div class="pwchk-field">
      <label class="pwchk-label" for="userPass">비밀번호</label>

      <div class="pwchk-inputbox">
        <input id="userPass" class="pwchk-input" type="password" name="userPass" required
               placeholder="비밀번호를 입력하세요" />
      </div>

      <div class="pwchk-help">
        <div id="capsWarn" class="pwchk-caps">Caps Lock이 켜져 있습니다</div>
      </div>
    </div>

    <div class="pwchk-actions">
      <!-- ✅ 마이페이지 내부에선 history.back() 쓰면 탭 흐름이 꼬일 수 있음 -->
      <button type="button" class="pwchk-btn" id="pwCancelBtn">취소</button>
      <button type="submit" class="pwchk-btn pwchk-btn-primary">확인</button>
    </div>
  </form>
</div>
<!-- 
<script>
  (function(){
    const input = document.getElementById('userPass');
    const toggle = document.getElementById('pwToggle');
    const caps = document.getElementById('capsWarn');
    const cancelBtn = document.getElementById('pwCancelBtn');

    // show/hide
    if (toggle && input){
      toggle.addEventListener('click', function(){
        const isPw = input.type === 'password';
        input.type = isPw ? 'text' : 'password';
        toggle.textContent = isPw ? '숨김' : '표시';
        input.focus();
      });
    }

    // CapsLock 경고
    if (input && caps){
      input.addEventListener('keyup', function(e){
        const on = e.getModifierState && e.getModifierState('CapsLock');
        caps.style.display = on ? 'inline-flex' : 'none';
      });
    }

    // ✅ 취소: 마이페이지 탭 UX에 맞게 profileArea를 초기 안내로 되돌림
    if (cancelBtn){
      cancelBtn.addEventListener('click', function(){
        const area = document.getElementById('profileArea');
        if (!area) return;

        area.innerHTML =
          '<div id="profilePlaceholder" class="empty">' +
          '  <div class="icon">🔒</div>' +
          '  <div>비밀번호 확인이 필요합니다.</div>' +
          '  <div class="ctaRow">' +
          '    <button class="cta" type="button" id="btnOpenPwCheck">비밀번호 확인</button>' +
          '  </div>' +
          '</div>';

        // mypage.jsp의 기존 함수(loadPwCheckIntoProfileArea)가 전역이면 재바인딩 가능
        const btn = document.getElementById('btnOpenPwCheck');
        if (btn && typeof loadPwCheckIntoProfileArea === 'function'){
          btn.addEventListener('click', loadPwCheckIntoProfileArea);
        }
      });
    }
  })();
</script> -->
