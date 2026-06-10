<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.or.ddit.tct.users.vo.UserVO" %>
<%
  String ctx = request.getContextPath();
  UserVO loginUser = (UserVO) session.getAttribute("loginUser");
  boolean isAdminLogin = (loginUser != null && "ADMIN".equalsIgnoreCase(loginUser.getRole()));
%>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Jua&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">

<style>
:root {
	--tctH-max: 1200px;
	--tctH-padX: 16px;
	--tctH-gap: 14px;
	--tctH-bg: #f6f8ff;
	--tctH-ink: #0f172a;
	--tctH-muted: #64748b;
	--tctH-line: rgba(15, 23, 42, .10);
	--tctH-blue: #1b7bff;
	--tctH-blue-dark: #0f5fd6;
	--tctH-yellow-dark: #b08900;
	--tctH-hover-bg: #f1f5f9;
	
    /* 폰트 변수 */
	--tctH-font-logo: 'Jua', sans-serif; 
    --tctH-font-std: 'Noto Sans KR', "Malgun Gothic", "Apple SD Gothic Neo", sans-serif; 
}

/* 기본 폰트 설정 */
.tctH-header, .tctH-header * {
	font-family: var(--tctH-font-std) !important;
	letter-spacing: normal !important;
}

/* 아이콘 폰트 깨짐 방지 */
.tctH-header .fa, .tctH-header .fa-solid, .tctH-header .fa-regular {
    font-family: "Font Awesome 6 Free" !important;
}

.tctH-header {
	position: sticky;
	top: 0;
	z-index: 50;
	background: rgba(255, 255, 255, .96);
	backdrop-filter: blur(10px);
	border-bottom: 1px solid rgba(15, 23, 42, .08);
	box-shadow: 0 4px 20px rgba(0,0,0,0.03);
}

.tctH-container {
	width: min(var(--tctH-max), 100%);
	margin: 0 auto;
	padding: 12px var(--tctH-padX);
	display: grid;
	grid-template-columns: 280px 1fr 360px;
	align-items: center;
	gap: var(--tctH-gap);
}

/* 로고 */
.tctH-brand {
	display: flex;
	align-items: center;
	gap: 12px;
	text-decoration: none !important;
	color: var(--tctH-ink) !important;
    font-family: var(--tctH-font-logo) !important;
}

.tctH-brand img {
	width: 85px;
	height: 85px;
	border-radius: 50%;
	object-fit: contain;
	transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.tctH-brand:hover img { transform: scale(1.1) rotate(-5deg); }

.tctH-name {
	font-size: 24px;
	letter-spacing: 0.01em;
	color: var(--tctH-ink);
	font-family: var(--tctH-font-logo) !important;
	line-height: 1.05;
}

.tctH-cap {
	display: inline-block;
	font-weight: 900;
	text-shadow: 0 2px 6px rgba(0, 0, 0, .08);
	transition: transform .18s ease, filter .18s ease;
}

.tctH-cap.tctH-cap-blue { color: var(--tctH-blue-dark); }
.tctH-cap.tctH-cap-yellow { color: var(--tctH-yellow-dark); }

.tctH-brand:hover .tctH-cap {
	animation: tctHBounce .46s ease;
}

.tctH-brand:hover .tctH-cap.cap2 { animation-delay: .05s; }
.tctH-brand:hover .tctH-cap.cap3 { animation-delay: .1s; }

@keyframes tctHBounce {
	0% { transform: translateY(0) rotate(0deg); }
	35% { transform: translateY(-3px) rotate(-4deg); }
	70% { transform: translateY(1px) rotate(3deg); }
	100% { transform: translateY(0) rotate(0deg); }
}

.tctH-sub {
	font-size: 14px;
	color: #E6C200;
	margin-top: 2px;
}

/* 검색바 */
.tctH-searchbar {
	height: 44px;
	display: flex;
	align-items: center;
	gap: 12px;
	padding: 0 16px;
	border-radius: 99px;
	background: #f8fafc;
	border: 2px solid transparent;
	transition: all 0.2s ease;
}
.tctH-searchbar:focus-within {
	border-color: var(--tctH-blue);
	background: #fff;
	box-shadow: 0 0 0 3px rgba(27, 123, 255, .1);
}
.tctH-searchbar input {
	width: 100%;
	border: 0;
	outline: 0;
	background: transparent;
	font-size: 15px;
    padding-top: 2px;
    font-weight: 400; 
}
.tctH-search-icon {
    font-size: 18px;
    filter: drop-shadow(0 2px 3px rgba(0,0,0,0.1));
    cursor: default;
}

/* 우측 영역 */
.tctH-right {
	display: flex;
	flex-direction: column;
	align-items: flex-end;
	gap: 10px;
}

/* 상단 링크들 */
.tctH-toplinks { 
	display: flex; 
	gap: 12px; 
	margin-top: -8px; 
	padding-right: 4px; 
}

/* 상단 버튼 스타일 */
.tctH-pill {
	height: auto;
	padding: 0;
	border: none;
	background: transparent;
	font-size: 14px;
	color: #888;
	cursor: pointer;
	transition: all 0.2s;
    font-family: var(--tctH-font-logo) !important;
}
.tctH-pill:hover {
	background: transparent;
	color: var(--tctH-blue);
	transform: translateY(-2px);
}

/* 서브 링크 */
.tctH-sublinks {
	display: flex;
	gap: 20px;
	font-size: 14px;
	color: var(--tctH-muted);
}
.tctH-plain {
	border: 0;
	background: transparent;
	padding: 0;
	cursor: pointer;
	display: flex;
	align-items: center;
	gap: 6px;
	font-size: 14px;
	color: inherit;
	transition: color 0.2s ease;
    font-weight: 500; 
}

.tctH-plain i { font-size: 16px; }
#tctH_btnMypage i { color: #0f172a; } 
#tctH_btnCart i   { color: #0f172a; } 
#tctH_btnWish i   { color: #e11d48; } 

.tctH-plain:hover { color: var(--tctH-blue); }
.tctH-plain:hover i { color: var(--tctH-blue); } 


/* ===== GNB (메뉴 영역) ===== */
.tctH-categories {
	width: 100%;
	border-top: 1px solid var(--tctH-line);
	background: #fff;
}

.tctH-cat-wrap {
	width: min(var(--tctH-max), 100%);
	margin: 0 auto;
	padding: 0 var(--tctH-padX);
	display: flex;
	align-items: center;
	height: 52px;
	padding-left: 56px; 
}
.tctH-cat {
	background: transparent;
	border: none;

	/* ✅ hover 범위가 커지는 원인이라 제거 */
	/* height: 100%; */

	/* ✅ 버튼 내부 여백(hover 영역에 포함됨)은 최소화 */
	padding: 6px 0;        /* 세로만 최소(글씨 위/아래 약간만) */

	/* ✅ 메뉴 간격은 margin으로 줌 (margin은 hover 영역에 포함되지 않음) */
	margin: 0 22px;

	cursor: pointer;
	transition: color 0.3s;
	display: flex;
	align-items: center;
	justify-content: center;
	position: relative;
	color: #333;
}


.tctH-cat:not([data-menu="all"]) {
    font-family: var(--tctH-font-std) !important;
    font-size: 14px;
    font-weight: 500; 
    letter-spacing: -0.02em; 
    color: #444; 
}

.tctH-cat[data-menu="all"] {
	padding-left: 0;
	padding-right: 25px;
	margin-right: 10px;
	font-size: 18px;
    color: var(--tctH-ink);
    padding-top: 4px;
    font-family: var(--tctH-font-logo) !important;
}
.tctH-cat[data-menu="all"] i { margin-right: 8px; font-size: 18px; }
.tctH-cat[data-menu="all"]::after {
	content: "";
	position: absolute;
	right: 0;
	top: 50%;
	transform: translateY(-40%);
	width: 1px;
	height: 14px;
	background: #ddd;
}

.tctH-cat:hover, .tctH-cat.tctH-active {
	color: var(--tctH-blue);
    font-weight: 700; 
}

/* ===== 메가메뉴 (드롭다운) ===== */
.tctH-megaWrap {
	position: absolute;
	top: 100%; 
	left: 0;
	width: 100%;
}

.tctH-mega {
	display: none;
	width: min(var(--tctH-max), 100%);
	margin: 0 auto;
	background: #fff;
	border: 1px solid rgba(15, 23, 42, .10);
	border-top: none;
	border-bottom-left-radius: 20px;
	border-bottom-right-radius: 20px;
	padding: 24px 30px;
	box-shadow: 0 15px 40px rgba(0,0,0,0.08);
}

.tctH-mega.tctH-open {
	display: block;
	animation: softSlide 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}

@keyframes softSlide {
	0% { opacity: 0; transform: translateY(-15px) scaleY(0.96); transform-origin: top; }
	100% { opacity: 1; transform: translateY(0) scaleY(1); transform-origin: top; }
}

.tctH-megaTop {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding-bottom: 16px;
	border-bottom: 2px solid var(--tctH-ink);
	margin-bottom: 20px;
}

.tctH-megaTitle { 
    font-size: 20px; 
    color: var(--tctH-blue);
    font-family: var(--tctH-font-logo) !important; 
}

.tctH-megaClose {
	width: 32px; height: 32px;
	border: none;
	background: #f1f5f9;
	border-radius: 50%;
	font-size: 18px;
	cursor: pointer;
	transition: background 0.2s;
	display: flex; align-items: center; justify-content: center;
}
.tctH-megaClose:hover { background: #e2e8f0; }

.tctH-megaGrid {
	display: grid;
	grid-template-columns: repeat(5, 1fr);
	gap: 30px;
}

.tctH-megaCol h4 {
	margin: 0 0 12px;
	font-size: 16px;
	font-weight: 400;
    color: #333;      
	padding-bottom: 8px;
	border-bottom: 1px solid #eee; 
    font-family: var(--tctH-font-std) !important;
}

.tctH-megaCol a {
	display: block;
	padding: 6px 0;
	font-size: 14px;
	color: #666; 
    font-weight: 400; 
	text-decoration: none;
	transition: transform 0.2s ease, color 0.2s ease;
    font-family: var(--tctH-font-std) !important;
}

.tctH-megaCol a:hover {
	color: var(--tctH-blue);
	transform: translateX(4px);
    font-weight: 500;
}

.tctH-overlay {
	display: none;
	position: fixed;
	inset: 0;
	background: rgba(0, 0, 0, 0.2);
	z-index: 40;
	backdrop-filter: blur(2px);
	transition: opacity 0.3s;
	opacity: 0;
}
.tctH-overlay.tctH-open { display: block; opacity: 1; }

@media (max-width: 1050px) {
	.tctH-container { grid-template-columns: 1fr; gap: 10px; }
	.tctH-right { align-items: flex-start; flex-direction: row; justify-content: space-between; width: 100%; }
	.tctH-brand { justify-content: center; }
	.tctH-cat-wrap { overflow-x: auto; padding-left: 20px; } 
}
</style>

<div class="tctH-overlay" id="tctH_overlay" aria-hidden="true"></div>

<header class="tctH-header">
	<div class="tctH-container">
		<a class="tctH-brand" href="<%=ctx%>">
			<img src="<%=ctx%>/assets/images/logo/main_logo.png" alt="메인로고">
				<div>
					<div class="tctH-name"><span class="tctH-cap tctH-cap-blue">T</span>ry<span class="tctH-cap tctH-cap-yellow cap2">C</span>atch<span class="tctH-cap tctH-cap-blue cap3">T</span>rip</div>
					<div class="tctH-sub">Plan. Travel. Explore.</div>
				</div>
		</a>

		<form class="tctH-searchbar" action="<%=ctx%>/regProdResults.do" method="get">
			<span class="tctH-search-icon" aria-hidden="true">🔎</span>
			<input name="keyword" type="search" placeholder="어디로 떠나시나요?" />
		</form>

		<div class="tctH-right">
			<div class="tctH-toplinks" id="tctH_guestTop">
				<button class="tctH-pill" type="button" id="tctH_btnLogin">로그인</button>
				<button class="tctH-pill" type="button" id="tctH_btnJoin">회원가입</button>
				<button class="tctH-pill" type="button" onclick="location.href='<%=ctx%>/board.do'">게시판</button>
			</div>

			<div class="tctH-toplinks" id="tctH_userTop" style="display: none;">
				<button class="tctH-pill" type="button" id="tctH_userHello" style="cursor: default; color:var(--tctH-blue);"></button>
				<button class="tctH-pill" type="button" id="tctH_btnLogout">로그아웃</button>
				<button class="tctH-pill" type="button" onclick="location.href='<%=ctx%>/board.do'">게시판</button>
			</div>

			<div class="tctH-sublinks">
				<% if (!isAdminLogin) { %>
					<button class="tctH-plain" type="button" id="tctH_btnMypage">
						<i class="fa-regular fa-user"></i> 마이페이지
					</button>
					<button class="tctH-plain" type="button" id="tctH_btnWish">
						<i class="fa-regular fa-heart"></i> 관심상품
					</button>
					<button class="tctH-plain" type="button" id="tctH_btnCart">
						<i class="fa-solid fa-cart-shopping"></i> 장바구니
					</button>
				<% } %>
				<button class="tctH-plain" type="button" id="tctH_btnAdmin" 
				        style="<%= isAdminLogin ? "" : "display:none;" %>; color:#dc2626;">
					<i class="fa-solid fa-gear"></i> 관리자페이지
				</button>
			</div>
		</div>
	</div>

	<nav class="tctH-categories">
		<div class="tctH-cat-wrap">
			<button class="tctH-cat" type="button" data-menu="all">
				<i class="fa-solid fa-bars"></i> 전체메뉴
			</button>
			
			<button class="tctH-cat" type="button" data-menu="theme">테마여행</button>
			<button class="tctH-cat tctH-wide-text" type="button" data-menu="europe">유 럽</button>
			<button class="tctH-cat" type="button" data-menu="sea">동남아/서남아</button>
			<button class="tctH-cat" type="button" data-menu="asia">일본/중국/홍콩</button>
			<button class="tctH-cat" type="button" data-menu="island">괌/사이판/하와이</button>
			<button class="tctH-cat" type="button" data-menu="usa">미주/캐나다/중남미</button>
		</div>
	</nav>

	<div class="tctH-megaWrap" id="tctH_megaContainer">
		<section class="tctH-mega" id="tctH_mega">
			<div class="tctH-megaTop">
				<div class="tctH-megaTitle" id="tctH_megaTitle">전체메뉴</div>
				<button class="tctH-megaClose" type="button" id="tctH_megaClose">
					<i class="fa-solid fa-xmark"></i>
				</button>
			</div>
			<div class="tctH-megaGrid" id="tctH_megaGrid"></div>
		</section>
	</div>
</header>

<%@ include file="tctWidget.jsp" %>

<script>
(function(){
  const CTX = "<%=ctx%>";
  const IS_ADMIN = <%= isAdminLogin %>;

  const MENUS = {
    all: { title:"전체메뉴", cols:[
      { heading:"테마여행", items:[
        { label:"문화/역사관광", filter:"THM:CUL_HIS" },
        { label:"미식여행",     filter:"THM:FOD" },
        { label:"휴양/축제",     filter:"THM:VAC_FES" },
        { label:"골프/액티비티", filter:"THM:GLF_LEI" }
      ]},
      { heading:"유럽", items:["서유럽","동유럽","북유럽"]},
      { heading:"동남아/서남아", items:["태국","베트남","싱가포르"] },
      { heading:"일본/중국/홍콩", items:["도쿄/후쿠오카","베이징/상하이","홍콩/마카오"] },
      { heading:"고객센터", items:["공지사항","자주 묻는 질문","문의게시판"] },
    ]},
    theme: { title:"테마여행", cols:[
      { heading:"문화/역사관광", items:["박물관","미술관","관광지"] },
      { heading:"미식여행", items:["레스토랑","로컬맛집","디저트&카페"] },
      { heading:"휴양/축제", items:["휴양지","온천","축제"] },
      { heading:"골프/액티비티", items:["골프","레저","트레킹"] },
    ]},
    europe:{ title:"유럽", cols:[
      { heading:"서유럽", items:["스위스","영국","프랑스"] },
      { heading:"동유럽", items:["오스트리아","체코","헝가리"] },
      { heading:"북유럽", items:["아이슬란드","노르웨이","핀란드"] },
    ]},
    sea:{ title:"동남아/서남아", cols:[
      { heading:"태국", items:["방콕","푸켓","치앙마이"] },
      { heading:"베트남", items:["다낭","나트랑","하노이"] },
      { heading:"필리핀", items:["세부","보라카이","보홀"] },
    ]},
    asia:{ title:"일본/중국/홍콩", cols:[
      { heading:"일본", items:["도쿄","오사카","후쿠오카","삿포로"] },
      { heading:"중국", items:["베이징","상하이","광저우","칭다오"] },
      { heading:"홍콩", items:["홍콩","마카오"] },
    ]},
    island:{ title:"괌/사이판/하와이", cols:[
      { heading:"괌", items:["괌"] },
      { heading:"사이판", items:["사이판"] },
      { heading:"하와이", items:["호놀룰루","마우이","빅아일랜드"] },
    ]},
    usa:{ title:"미주/캐나다/중남미", cols:[
      { heading:"미국", items:["뉴욕","LA","라스베가스"] },
      { heading:"캐나다", items:["밴쿠버","토론토","밴프(로키)"] },
      { heading:"중남미", items:["멕시코","브라질","칠레"] },
    ]},
  };

  const mega      = document.getElementById("tctH_mega");
  const megaTitle = document.getElementById("tctH_megaTitle");
  const megaGrid  = document.getElementById("tctH_megaGrid");
  const overlay   = document.getElementById("tctH_overlay");
  const closeBtn  = document.getElementById("tctH_megaClose");
  const catBtns   = document.querySelectorAll(".tctH-cat");
  const megaContainer = document.getElementById("tctH_megaContainer");

  function renderMenu(key){
    const data = MENUS[key];
    if(!data) return;
    megaTitle.textContent = data.title;
    megaGrid.innerHTML = data.cols.map(function(col){
      const links = col.items.map(function(item){
        if (typeof item === "string") {
          const url = CTX + "/regProdResults.do?keyword=" + encodeURIComponent(item);
          return '<a href="' + url + '">' + item + '</a>';
        }
        if (item && item.label && item.filter) {
          const url = CTX + "/regProdResults.do?filter=" + encodeURIComponent(item.filter);
          return '<a href="' + url + '">' + item.label + '</a>';
        }
        return "";
      }).join("");
      return '<div class="tctH-megaCol"><h4>' + col.heading + '</h4>' + links + '</div>';
    }).join("");
  }

  let closeTimer = null;

  function openMenu(key, btn){
    if(closeTimer) clearTimeout(closeTimer);
    renderMenu(key);
    mega.classList.add("tctH-open");
    overlay.classList.add("tctH-open");
    catBtns.forEach(b => b.classList.remove("tctH-active"));
    if(btn) btn.classList.add("tctH-active");
  }

  function scheduleClose(){
    closeTimer = setTimeout(() => {
      mega.classList.remove("tctH-open");
      overlay.classList.remove("tctH-open");
      catBtns.forEach(b => b.classList.remove("tctH-active"));
    }, 35); 
  }

  function cancelClose(){
    if(closeTimer) clearTimeout(closeTimer);
  }

  let openTimer = null; // ✅ 살짝 스칠 때 바로 열리지 않게 딜레이용 타이머

  catBtns.forEach(btn => {
    btn.addEventListener("mouseenter", () => {
      const key = btn.dataset.menu;

      // ✅ 기존 닫기 예약이 있으면 취소(열려는 의도가 생겼으니까)
      cancelClose();

      // ✅ 이미 열기 예약이 있으면 덮어쓰기
      if (openTimer) clearTimeout(openTimer);

      // ✅ 140ms 뒤에 열기: "의도된 호버"만 열리게
      openTimer = setTimeout(() => openMenu(key, btn), 140);
    });

    btn.addEventListener("mouseleave", () => {
      // ✅ 버튼에서 바로 빠지면 열기 예약도 취소
      if (openTimer) clearTimeout(openTimer);
      scheduleClose();
    });
  });


  mega.addEventListener("mouseenter", cancelClose);
  mega.addEventListener("mouseleave", scheduleClose);

  closeBtn.addEventListener("click", () => {
    scheduleClose();
    mega.classList.remove("tctH-open");
    overlay.classList.remove("tctH-open");
  });

  overlay.addEventListener("click", () => {
    mega.classList.remove("tctH-open");
    overlay.classList.remove("tctH-open");
  });

  
  window.addEventListener("DOMContentLoaded", async () => {
    const guestTop  = document.getElementById("tctH_guestTop");
    const userTop   = document.getElementById("tctH_userTop");
    const userHello = document.getElementById("tctH_userHello");

    const btnLogin  = document.getElementById("tctH_btnLogin");
    const btnJoin   = document.getElementById("tctH_btnJoin");
    const btnLogout = document.getElementById("tctH_btnLogout");
    
    const btnMypage = document.getElementById("tctH_btnMypage");
    const btnWish   = document.getElementById("tctH_btnWish");
    const btnCart   = document.getElementById("tctH_btnCart");
    const btnAdmin  = document.getElementById("tctH_btnAdmin");
    
    // [위젯] 컨테이너 가져오기 (tctWidget.jsp에 선언됨)
    const ddayDock = document.getElementById("ddayDock");

    if (btnLogin)  btnLogin.onclick  = () => location.href = CTX + "/login.do";
    if (btnJoin)   btnJoin.onclick   = () => location.href = CTX + "/join.do";
    if (btnLogout) btnLogout.onclick = () => {
      sessionStorage.removeItem("TCT_DDAY_FOLD_SECOND"); // 접기 상태 초기화
      location.href = CTX + "/logout.do";
    };

    if (!IS_ADMIN) {
      if (btnMypage) btnMypage.onclick = () => location.href = CTX + "/mypage.do#pay";
      if (btnCart)   btnCart.onclick   = () => location.href = CTX + "/cart/view.do";
      if (btnWish)   btnWish.onclick   = () => location.href = CTX + "/wish/page.do";
    }
    if (btnAdmin) btnAdmin.onclick = () => location.href = CTX + "/admin/dashboard.do";

    try {
      const res = await fetch(CTX + "/session.do", { method: "GET" });
      const data = await res.json();

      if (data.loggedIn) {
        // 로그인 상태
        if (guestTop) guestTop.style.display = "none";
        if (userTop)  userTop.style.display  = "flex";
        if (userHello) userHello.textContent = (data.userName ? data.userName : data.loginId) + "님";
        
        const isAdmin = String(data.role || "").toUpperCase() === "ADMIN";
        if (btnAdmin) btnAdmin.style.display = isAdmin ? "inline-flex" : "none";
        
        // [위젯] 로그인 상태일 때 위젯 로드 함수 실행
        // loadDdayDock 함수는 tctWidget.jsp에 정의되어 있습니다.
        if (typeof loadDdayDock === 'function') {
            await loadDdayDock(ddayDock, CTX);
        }

        // [팝업] 일반유저 로그인 + 출발 5일 이내면 출발임박 팝업을 띄우기 위함
        if (!isAdmin && typeof loadDdayPopup === 'function') {
            await loadDdayPopup(CTX);
        }

      } else {
        // 로그아웃 상태
        if (guestTop) guestTop.style.display = "flex";
        if (userTop)  userTop.style.display  = "none";
        if (btnAdmin) btnAdmin.style.display = "none";
      }
    } catch (e) {
      if (guestTop) guestTop.style.display = "flex";
      if (userTop)  userTop.style.display  = "none";
      if (btnAdmin) btnAdmin.style.display = "none";
    }
  });
})();
</script>
