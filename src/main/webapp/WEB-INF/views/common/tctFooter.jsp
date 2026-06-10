<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
.tct-footer{
  margin-top: 40px;
  color:#111;
  background:#fff;
  border-top:1px solid rgba(15,23,42,.10);
  font-family: ui-sans-serif, system-ui, -apple-system, "Noto Sans KR","Malgun Gothic";
}

.tct-footer .container{
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 16px;
}

.tct-footer-top{
  padding: 26px 0;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 40px;
}

.tct-ft-grid{
  display:grid;
  grid-template-columns: 1.2fr 1px 1.8fr;
  gap: 26px;
  align-items: start;
}

.tct-ft-divider{
  width:1px;
  background: rgba(15,23,42,.10);
  height: 100%;
}

.tct-ft-title{
  margin:0 0 12px;
  font-size: 22px;
  font-weight: 900;
}

.tct-ft-hours{
  margin:0 0 14px;
  display:grid;
  grid-template-columns: 64px 1fr;
  gap: 10px;
  font-size: 13px;
}
.tct-ft-hours dt{ color:#333; font-weight: 800; }
.tct-ft-hours dd{ margin:0; color:#555; }

.tct-ft-bullets{
  margin:0;
  padding-left: 16px;
  color:#444;
  font-size: 13px;
  line-height: 1.75;
}

.tct-ft-right{
  display : flex;
  grid-template-columns: repeat(3, 1fr);
  gap: 18px;
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 80px;
  text-align: center;
  height : 100%;
}

.tct-ft-call{
  display:flex;
  flex-direction: column;
  gap: 8px;
  align-items: center;
  text-align:center;
}

.tct-ft-label{
  font-size: 14px;
  color:#333;
  font-weight: 800;
  margin-bottom: 6px;
}

.tct-ft-tel{
  font-size: 26px;
  font-weight: 900;
  letter-spacing: -.3px;
}

.tct-ft-btn{
  margin-top: 2px;
  padding: 10px 12px;
  border-radius: 8px;
  border:1px solid rgba(15,23,42,.15);
  background:#fff;
  font-size: 12px;
  font-weight: 900;
  cursor:pointer;
}

.tct-footer-mid{
  border-top:1px solid rgba(15,23,42,.10);
  border-bottom:1px solid rgba(15,23,42,.10);
  padding: 14px 0;
}

.tct-ft-midrow{
  display:flex;
  align-items:center;
  justify-content: space-between;
  gap: 16px;
  flex-wrap: wrap;
}

.tct-ft-links{
  display:flex;
  gap: 16px;
  flex-wrap: wrap;
  font-size: 13px;
  color:#333;
}
.tct-ft-links a{ color:#333; text-decoration:none; }
.tct-ft-links a.strong{ color:#1b7bff; font-weight: 900; }

.tct-ft-sns{
  display:flex;
  gap: 10px;
}
.tct-ft-sns a{
  width: 34px;
  height: 34px;
  border-radius: 999px;
  border:1px solid rgba(15,23,42,.12);
  display:flex;
  align-items:center;
  justify-content:center;
  color:#111;
  text-decoration:none;
}

.tct-footer-bottom{
  padding: 22px 0 28px;
}

.tct-ft-bottomgrid{
  display:grid;
  grid-template-columns: 1.6fr 1fr;
  gap: 26px;
  align-items:start;
}

.tct-ft-company-head{
  display:flex;
  gap: 12px;
  align-items:center;
  margin-bottom: 10px;
}
.tct-ft-company-head b{ font-size: 14px; }
.tct-ft-company-head .muted{ font-size: 12px; color:#777; }

.tct-ft-company-txt{
  font-size: 12px;
  color:#444;
  line-height: 1.75;
}

.tct-ft-cs-title{
  display:block;
  margin-bottom: 10px;
  font-size: 13px;
}

.tct-ft-cs-row{
  display:flex;
  justify-content: space-between;
  gap: 10px;
  padding: 6px 0;
  font-size: 12px;
  border-bottom: 1px dashed rgba(15,23,42,.10);
}
.tct-ft-cs-row b{ font-weight: 1000; }

.tct-ft-mails{
  margin-top: 12px;
  display:flex;
  flex-direction: column;
  gap: 6px;
  font-size: 12px;
  color:#444;
}
.tct-ft-mails span{ display:inline-block; width: 70px; color:#777; }
.tct-ft-mails a{ color:#1b7bff; text-decoration:none; }

@media (max-width: 980px){
  .tct-ft-grid{ grid-template-columns: 1fr; }
  .tct-ft-divider{ display:none; }
  .tct-ft-right{ grid-template-columns: 1fr; }
  .tct-ft-bottomgrid{ grid-template-columns: 1fr; }
}
</style>
</head>
<body>

<!-- Footer -->
<footer class="tct-footer">

  <!-- 상단: 고객센터 큰 영역 -->
  <section class="tct-footer-top">
    <div class="container tct-ft-grid">

      <!-- 좌측: 고객센터 안내 -->
      <div class="tct-ft-left">
        <h3 class="tct-ft-title">TryCatchTrip 고객센터</h3>

        <dl class="tct-ft-hours">
          <dt>상담시간</dt>
          <dd>평일 오전 9시 ~ 오후 6시 (토, 일요일 및 공휴일 휴무)</dd>
        </dl>

        <ul class="tct-ft-bullets">
          <li>해외항공권 변경, 투어&티켓, 렌터카 취소/변경/환불: <b>평일 오후 5시까지</b></li>
          <li>호텔 취소/변경/환불: <b>평일 오후 4시까지</b></li>
        </ul>
      </div>

      <div class="tct-ft-divider" aria-hidden="true"></div>

      <!-- 우측: 상담번호 3칸 -->
      <div class="tct-ft-right">

        <div class="tct-ft-call">
          <div class="tct-ft-label">패키지여행 상담</div>
          <div class="tct-ft-tel">1544-2288</div>
        </div>

        <div class="tct-ft-call">
          <div class="tct-ft-label">자유여행 상담</div>
          <div class="tct-ft-tel">1644-3399</div>
        </div>

        <div class="tct-ft-call">
          <div class="tct-ft-label">지방출발 상담</div>
          <div class="tct-ft-tel">1744-3355</div>
        </div>

      </div>
    </div>
  </section>

  <!-- 중간: 링크 + SNS -->
  <section class="tct-footer-mid">
    <div class="container tct-ft-midrow">
      <nav class="tct-ft-links" aria-label="푸터 링크">
        <a href="#">회사소개</a>
        <a href="#" class="strong">개인정보처리방침</a>
        <a href="#">이용약관</a>
        <a href="#">여행약관</a>
        <a href="#">여행자보험</a>
        <a href="#">오시는 길</a>
      </nav>
    </div>
  </section>

  <!-- 하단: 회사정보 + 고객센터 요약 -->
  <section class="tct-footer-bottom">
    <div class="container tct-ft-bottomgrid">

      <div class="tct-ft-company">
        <div class="tct-ft-company-head">
          <b>(주)트라이캐치트립</b>
        </div>

        <div class="tct-ft-company-txt">
          대표 : 이용로  |  대전광역시 중구 계룡로 846 3층<br/>
        </div>

        <div class="tct-ft-company-txt muted" style="margin-top:10px;">
          Copyright © 2026 TryCatchTrip✈️ All Rights Reserved.
        </div>
      </div>

      <div class="tct-ft-cs">
 
        <div class="tct-ft-mails">
          <div><span>대표메일</span> <a href="mailto:master@trycatchtrip.com">master@trycatchtrip.com</a></div>
          <div><span>판매제휴</span> <a href="mailto:salespartner@trycatchtrip.com">salespartner@trycatchtrip.com</a></div>
          <div><span>마케팅제휴</span> <a href="mailto:marketing@trycatchtrip.com">marketing@trycatchtrip.com</a></div>
          <div><span>대리점문의</span> <a href="mailto:sales.agent@trycatchtrip.com">sales.agent@trycatchtrip.com</a></div>
        </div>
      </div>

    </div>
  </section>
  
</footer>

</body>
</html>