<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>이메일 인증</title>

  <style>
    :root{
      --sky:#38bdf8;      /* 하늘색 */
      --mint:#34d399;     /* 연초록 */
      --ink:#0f172a;
      --muted:rgba(15,23,42,.65);
      --card:rgba(255,255,255,.78);
      --line:rgba(15,23,42,.10);
      --shadow: 0 18px 40px rgba(2,132,199,.18);
    }

    *{ box-sizing:border-box; }
    body{
      margin:0;
      font-family: system-ui, -apple-system, Segoe UI, Roboto, "Noto Sans KR", Arial, sans-serif;
      color: var(--ink);
      min-height:100vh;
      display:grid;
      place-items:center;
      padding:24px;
      background:
        radial-gradient(1200px 600px at 10% 10%, rgba(56,189,248,.28), transparent 60%),
        radial-gradient(1000px 520px at 90% 20%, rgba(52,211,153,.24), transparent 62%),
        linear-gradient(180deg, #f8fbff 0%, #f4fff9 100%);
    }

    .wrap{
      width:min(720px, 100%);
    }

    .card{
      position:relative;
      overflow:hidden;
      border:1px solid var(--line);
      background: var(--card);
      backdrop-filter: blur(10px);
      border-radius: 22px;
      box-shadow: var(--shadow);
      padding: 26px 24px;
    }

    /* 상단 그라데이션 라인 */
    .card::before{
      content:"";
      position:absolute;
      left:0; top:0;
      width:100%;
      height:6px;
      background: linear-gradient(90deg, var(--sky), var(--mint));
    }

    .row{
      display:flex;
      align-items:center;
      gap:16px;
    }

    .icon{
      width:52px; height:52px;
      border-radius: 16px;
      display:grid;
      place-items:center;
      flex:0 0 auto;
      background: linear-gradient(135deg, rgba(56,189,248,.18), rgba(52,211,153,.18));
      border:1px solid rgba(56,189,248,.22);
    }

    .title{
      margin:0;
      font-size: 22px;
      letter-spacing: -.02em;
      font-weight: 900;
    }

    .desc{
      margin: 10px 0 0;
      color: var(--muted);
      line-height: 1.55;
      font-size: 14px;
    }

    .actions{
      margin-top: 18px;
      display:flex;
      flex-wrap:wrap;
      gap:10px;
    }

    .btn{
      display:inline-flex;
      align-items:center;
      gap:10px;
      height:44px;
      padding:0 14px;
      border-radius: 14px;
      border:1px solid var(--line);
      background: rgba(255,255,255,.72);
      color: var(--ink);
      font-weight: 900;
      font-size: 13px;
      text-decoration:none;
      cursor:pointer;
      transition: transform .12s ease, box-shadow .12s ease, border-color .12s ease;
    }
    .btn:hover{
      transform: translateY(-1px);
      border-color: rgba(56,189,248,.35);
      box-shadow: 0 10px 22px rgba(2,132,199,.12);
    }

    .btn.primary{
      border:0;
      color:#fff;
      background: linear-gradient(90deg, var(--sky), var(--mint));
      box-shadow: 0 14px 30px rgba(2,132,199,.22);
    }
    .btn.primary:hover{
      box-shadow: 0 18px 36px rgba(2,132,199,.28);
    }

    .pill{
      margin-top: 14px;
      display:inline-flex;
      align-items:center;
      gap:8px;
      padding:8px 12px;
      border-radius: 999px;
      border:1px dashed rgba(15,23,42,.18);
      background: rgba(255,255,255,.58);
      color: rgba(15,23,42,.72);
      font-size: 12px;
      font-weight: 700;
    }

    .small{
      margin-top: 10px;
      color: rgba(15,23,42,.55);
      font-size: 12px;
    }

    /* 간단한 체크/엑스 아이콘(SVG) */
    svg{ display:block; }
  </style>
</head>
<body>
<%
  Boolean okObj = (Boolean) request.getAttribute("ok");
  boolean ok = (okObj != null && okObj.booleanValue());
  String ctx = request.getContextPath();
%>

  <div class="wrap">
    <div class="card">
      <div class="row">
        <div class="icon" aria-hidden="true">
          <% if(ok){ %>
            <!-- check -->
            <svg width="26" height="26" viewBox="0 0 24 24" fill="none">
              <path d="M20 6L9 17l-5-5" stroke="#0f172a" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          <% } else { %>
            <!-- x -->
            <svg width="26" height="26" viewBox="0 0 24 24" fill="none">
              <path d="M18 6L6 18M6 6l12 12" stroke="#0f172a" stroke-width="2.2" stroke-linecap="round"/>
            </svg>
          <% } %>
        </div>

        <div>
          <h1 class="title">
            <%= ok ? "이메일 인증이 완료되었습니다." : "이메일 인증에 실패했습니다." %>
          </h1>
          <p class="desc">
            <%= ok
              ? "이제 회원가입을 계속 진행할 수 있습니다. 이 창은 잠시 후 자동으로 닫히며, 회원가입 창에서 ‘이메일 인증 완료’가 자동으로 반영됩니다."
              : "링크가 만료되었거나 이미 사용된 토큰일 수 있습니다. 가입 화면에서 인증메일을 다시 발송해 주세요." %>
          </p>
        </div>
      </div>

      <div class="actions">
        <button class="btn primary" type="button" onclick="window.close()">창 닫기</button>
        <a class="btn" href="<%=ctx%>/join.do">회원가입 화면 열기</a>
      </div>

      <div class="pill">
        <span>TryCatchTrip</span>
        <span style="opacity:.7">|</span>
        <span><%= ok ? "Verified" : "Not Verified" %></span>
      </div>

      <div class="small">
        보안상 인증 링크는 일정 시간 후 만료됩니다.
      </div>
    </div>
  </div>
	
	<script>
(function(){
  // 서버에서 ok 값 전달받음
  var ok = <%= ((Boolean)request.getAttribute("ok") != null && ((Boolean)request.getAttribute("ok"))) ? "true" : "false" %>;

  if(ok){
    // ✅ 기존 회원가입 탭에게 "인증완료" 신호 남김
    localStorage.setItem("tct_email_verified", "1");
    localStorage.setItem("tct_email_verified_at", String(Date.now()));

    // ✅ 자동으로 창/탭 닫기 (사용자 클릭으로 열린 탭이면 대부분 닫힘)
    setTimeout(function(){
      window.close();

      // 닫기가 막힌 브라우저 대비: 버튼 노출 or 안내 유지
      // (닫기 실패해도 사용자가 탭만 닫으면 됨)
    }, 800);
  }
})();
</script>
	
</body>
</html>
