<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>TryCatchTrip</title>

<style>
:root {
  --max: 1200px;
  --padX: 16px;
  --gap: 24px;
  --leftW: 360px;
  --bannerH: 620px;
  --r: 14px;
  --pill: 999px;
  --bg: #f6f8ff;
  --ink: #0f172a;
  --muted: #64748b;
  --line: rgba(15, 23, 42, .10);
  --blue: #1b7bff;
}

* { box-sizing: border-box; }

body {
  margin: 0;
  font-family: system-ui, -apple-system, "Noto Sans KR", sans-serif;
  color: var(--ink);
  background: var(--bg);
}

a { color: inherit; text-decoration: none; }
button, input, select { font: inherit; }
button { cursor: pointer; }

main { padding: 18px 0 46px; }

.hero {
  width: min(var(--max), 100%);
  margin: 0 auto;
  padding: 0 var(--padX);
  display: grid;
  grid-template-columns: var(--leftW) 1fr;
  gap: var(--gap);
  align-items: start;
}

.filter {
  background: rgba(255, 255, 255, .88);
  border: 1px solid rgba(15, 23, 42, .06);
  border-radius: var(--r);
  padding: 18px;
  transform: translateY(55px);
}

.filter h2 {
  margin: 0 0 6px;
  font-size: 18px;
  letter-spacing: -0.02em;
}

.filter p {
  margin: 0 0 12px;
  font-size: 13px;
  color: var(--muted);
  line-height: 1.5;
}

.field { margin: 10px 0; }

.field label {
  display: block;
  margin-bottom: 6px;
  font-size: 12px;
  font-weight: 900;
  color: rgba(15, 23, 42, .80);
}

.field input {
  width: 100%;
  height: 46px;
  padding: 0 12px;
  border-radius: 12px;
  border: 1px solid var(--line);
  background: #fff;
  outline: 0;
}

.actions {
  display: flex;
  gap: 10px;
  margin-top: 14px;
}

.btn {
  flex: 1;
  height: 46px;
  border-radius: 12px;
  border: 1px solid var(--line);
  background: #fff;
  font-weight: 950;
}

.btn.primary {
  background: var(--blue);
  border-color: var(--blue);
  color: #fff;
}

.banner {
  height: var(--bannerH);
  border-radius: var(--r);
  overflow: hidden;
  border: 1px solid rgba(15, 23, 42, .06);
  background: #0b1220;
  position: relative;
  display: block;
}

.banner img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center;
  display: block;
}

.banner::before {
  content: "";
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(0, 0, 0, .06), rgba(0, 0, 0, .62));
  pointer-events: none;
}

.banner .content {
  position: absolute;
  left: 22px;
  right: 22px;
  bottom: 22px;
  color: #fff;
  max-width: 580px;
}

.badge {
  display: inline-block;
  padding: 6px 10px;
  border-radius: var(--pill);
  border: 1px solid rgba(255, 255, 255, .25);
  background: rgba(255, 255, 255, .12);
  font-size: 12px;
  font-weight: 900;
}

.banner h1 {
  margin: 10px 0 6px;
  font-size: 38px;
  line-height: 1.12;
}

.banner p {
  margin: 0;
  font-size: 14px;
  line-height: 1.6;
  opacity: .92;
}

@media (max-width: 1050px) {
  .hero { grid-template-columns: 1fr; }
  .filter { transform: none; }
  .banner { height: 420px; }
}

.heroVideoFrame{
  position: relative;
  width: 100%;
  height: 420px;
  border-radius: 18px;
  overflow: hidden;
}

.heroVideoFrame iframe{
  position:absolute;
  inset:0;
  width:100%;
  height:100%;
}

.heroVideoOverlay{
  position:absolute;
  inset:0;
  background: linear-gradient(90deg, rgba(0,0,0,.55), rgba(0,0,0,.15));
}

.heroVideoContent{
  position:absolute;
  left: 24px;
  bottom: 22px;
  color:#fff;
  z-index:2;
}

.pkgSec{
  margin: 28px 0 10px;
}

.pkgTitle{
  font-size: 20px;
  font-weight: 900;
  margin-bottom: 14px;
}

.pkgGrid{
  display: grid;
  grid-template-columns: repeat(5, minmax(220px, 1fr));
  gap: 18px;
}

.pkgCard{
  background: #fff;
  border: 1px solid rgba(15,23,42,.08);
  border-radius: 16px;
  overflow: hidden;
  text-decoration: none;
  color: inherit;
  box-shadow: 0 8px 18px rgba(15,23,42,.06);
  transition: transform .15s ease, box-shadow .15s ease;
}

.pkgCard:hover{
  transform: translateY(-4px);
  box-shadow: 0 14px 30px rgba(15,23,42,.12);
}

.pkgImg{
  position: relative;
  height: 160px;
}

.pkgImg img{
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.pkgBody{
  padding: 14px;
}

.pkgName{
  font-size: 15px;
  font-weight: 800;
  margin-bottom: 6px;
}

.pkgDate{
  font-size: 12px;
  color: #64748b;
  margin-bottom: 10px;
}

.pkgPrice{
  font-size: 14px;
  margin-bottom: 10px;
}

.pkgPrice b{
  font-size: 20px;
  font-weight: 900;
}

.pkgTags{
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
}

.pkgTags span{
  font-size: 12px;
  background: #eef4ff;
  color: #3b5bcc;
  padding: 6px 10px;
  border-radius: 10px;
}

.pkgImg{
  position: relative;
  height: 170px;
  background: #e8efff;
}

.pkgImg img{
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

</style>
</head>

<body>

  <!-- ✅ 공통 상단 include (이 경로 그대로!) -->
  <%@ include file="/WEB-INF/views/common/tctHeader.jsp" %>

  <main>
    <section class="hero">
      <aside class="filter" aria-label="검색 필터">
        <h2>고객님, 어떤 여행을 꿈꾸시나요?</h2>

        <form action="<%=request.getContextPath()%>/regProdResults.do" method="get" aria-label="여행 검색 폼">
          <div class="field">
            <label for="dest">목적지</label>
            <input id="destination" name="destination" placeholder="프랑스, 파리" />
          </div>

          <div class="field">
            <label for="start">여행 시작일</label>
            <input id="start" name="startDate" type="date" />
          </div>

          <div class="field">
            <label for="end">여행 종료일</label>
            <input id="end" name="endDate" type="date" />
          </div>

          <div class="actions">
            <button class="btn" type="reset">초기화</button>
            <button class="btn primary" type="submit">검색</button>
          </div>
        </form>
      </aside>

      <!-- ✅ 동영상 배너 -->
		<section class="heroVideo">
		  <div class="heroVideoInner">
		
		    <div class="heroVideoFrame">
		      <iframe
		        src="https://www.youtube.com/embed/VY6s_bOD11I?autoplay=1&mute=1&loop=1&playlist=VY6s_bOD11I&controls=0&modestbranding=1&rel=0&playsinline=1"
		        title="프로모션 영상"
		        frameborder="0"
		        allow="autoplay; encrypted-media; picture-in-picture"
		        allowfullscreen>
		      </iframe>
		    </div>
		  </div>
		</section>

		<section class="pkgSec" aria-label="추천 패키지">
		  <h2 class="pkgTitle">추천 패키지 상품</h2>
		
		  <div class="pkgGrid">
		    <c:forEach var="prod" items="${top5List}">
		    
		    <a class="pkgCard" href="<%=request.getContextPath()%>/regProdDetail.do?regId=${prod.regId}">
		      <div class="pkgImg">
		        <img src="${pageContext.request.contextPath}${prod.imgPath}" alt="${prod.originName}">
		      </div>
		      <div class="pkgBody">
		        <h3 class="pkgName">${prod.regTitle}</h3>
						        
						        <p class="pkgDate">
				  <small class="pkgDateLabel">판매기간</small>
				  <br>
				  ${prod.saleStartDt} ~ ${prod.saleEndDt}
				</p>
						        
		        
		     
		        
		        <p class="pkgPrice">
		        <b>
            	<fmt:formatNumber value="${prod.regPrice}" pattern="#,###" />
            	</b>원
		        </p>
		        
		        <div class="pkgTags">
		          <span>${prod.descriptionB}</span>
		        </div>
		      </div>
		    </a>
		    
		    </c:forEach>
		  </div>
		</section>
    </section>
  </main>
  <%@ include file="/WEB-INF/views/common/tctFooter.jsp" %>

</body>
</html>
