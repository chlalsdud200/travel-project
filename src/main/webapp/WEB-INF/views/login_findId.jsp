<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>아이디 찾기</title>

<style>
  *{ box-sizing:border-box; font-family: 'Pretendard', system-ui, -apple-system, "Noto Sans KR", sans-serif; }
  body{
    margin:0;
    background:#ffffff;
  }

  /* 모달 iframe 안에서 잘 보이게 */
  .wrap{
    padding: 18px 18px 16px;
  }

  .title{
    font-size: 18px;
    font-weight: 900;
    color:#111827;
    margin: 4px 0 6px;
  }
  .desc{
    margin:0 0 14px;
    font-size: 13px;
    color:#6b7280;
    line-height:1.55;
  }

  .card{
    border:1px solid rgba(0,0,0,.08);
    border-radius: 14px;
    padding: 14px;
    background:#fff;
  }

  .field{ margin: 10px 0; }
  .label{
    display:block;
    font-size: 12px;
    font-weight: 800;
    color:#374151;
    margin-bottom: 6px;
  }
  .input{
    width:100%;
    height:44px;
    border:1px solid rgba(0,0,0,.12);
    border-radius: 12px;
    padding: 0 12px;
    outline: none;
    font-size: 14px;
  }
  .input:focus{
    border-color: rgba(27,123,255,.55);
    box-shadow: 0 0 0 3px rgba(27,123,255,.15);
  }

  .row{
    display:flex;
    gap:10px;
    margin-top: 12px;
  }
  .btn{
    flex:1;
    height:44px;
    border-radius: 12px;
    border:1px solid rgba(0,0,0,.12);
    background:#fff;
    font-weight: 900;
    cursor:pointer;
  }
  .btn.primary{
    background:#1b7bff;
    border-color:#1b7bff;
    color:#fff;
  }
  .btn:active{
    transform: translateY(1px);
  }

  .msg{
    margin-top: 12px;
    padding: 10px 12px;
    border-radius: 12px;
    font-size: 13px;
    font-weight: 800;
    text-align:center;
  }
  .msg.err{
    color:#b00020;
    background: rgba(255,0,0,.06);
    border:1px solid rgba(255,0,0,.18);
  }
  .msg.ok{
    color:#0f5132;
    background: rgba(25,135,84,.08);
    border:1px solid rgba(25,135,84,.22);
  }

  .result{
    margin-top: 12px;
    padding: 12px;
    border-radius: 12px;
    border:1px dashed rgba(0,0,0,.18);
    background: rgba(0,0,0,.02);
    text-align:center;
  }
  .result .id{
    font-size: 16px;
    font-weight: 950;
    letter-spacing: .2px;
  }

  .hint{
    margin-top: 10px;
    font-size: 12px;
    color:#9ca3af;
    text-align:center;
  }
</style>
</head>

<body>
<%
  String msg = (String) request.getAttribute("msg");
  String foundId = (String) request.getAttribute("foundId");
%>

<div class="wrap">
  <div class="title">아이디 찾기</div>
  <p class="desc">가입 시 등록한 <b>이름</b>과 <b>전화번호</b>를 입력하시면 아이디를 안내해드립니다.</p>

  <div class="card">
    <form action="<%=request.getContextPath()%>/findId.do" method="post" autocomplete="off">
      <div class="field">
        <label class="label" for="userName">이름</label>
        <input class="input" id="userName" name="userName" placeholder="예) 홍길동" required />
      </div>

      <div class="field">
        <label class="label" for="userTel">전화번호</label>
        <input class="input" id="userTel" name="userTel" placeholder="예) 010-1234-5678" required />
      </div>

      <div class="row">
        <button class="btn primary" type="submit">아이디 찾기</button>
		<button class="btn" type="button" onclick="parent.closeModal()">로그인으로</button>

      </div>
    </form>

    <%-- 메시지 출력 --%>
    <% if(msg != null && !msg.trim().isEmpty()) { %>
      <div class="msg err"><%=msg%></div>
    <% } %>

    <%-- 결과 출력 --%>
    <% if(foundId != null && !foundId.trim().isEmpty()) { %>
      <div class="msg ok">조회가 완료되었습니다.</div>
      <div class="result">
        회원님의 아이디는<br/>
        <div class="id"><%=foundId%></div>
      </div>
    <% } %>

    <div class="hint">※ 정보가 일치하지 않으면 아이디가 조회되지 않습니다.</div>
  </div>
</div>

<script>
  // 모달(iframe) 안이든, 일반 페이지든 안전하게 로그인으로 이동
  function goLogin(){
    location.href = "<%=request.getContextPath()%>/login.do";
  }

  // 전화번호 자동 포맷
  (function(){
    var tel = document.getElementById("userTel");
    if(!tel) return;

    tel.addEventListener("input", function(){
      var v = tel.value.replace(/[^0-9]/g, "");
      if(v.length <= 3){
        tel.value = v;
      }else if(v.length <= 7){
        tel.value = v.slice(0,3) + "-" + v.slice(3);
      }else{
        tel.value = v.slice(0,3) + "-" + v.slice(3,7) + "-" + v.slice(7,11);
      }
    });
  })();
  
  
</script>
<script>
document.getElementById("goLoginBtn").addEventListener("click", function(){
    window.parent.postMessage({ type: "MODAL_CLOSE" }, "*");
  });

</script>

</body>
</html>
