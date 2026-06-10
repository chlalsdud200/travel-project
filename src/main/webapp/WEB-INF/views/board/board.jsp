<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>TryCatchTrip - 게시판</title>

<!-- Font Awesome -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<!-- Bootstrap -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>

<style>
:root {
	--b-bg: #f6f8ff;
	--b-card: #ffffff;
	--b-ink: #0f172a;
	--b-muted: rgba(15, 23, 42, .62);
	--b-line: rgba(15, 23, 42, .10);
	--b-shadow: 0 12px 30px rgba(15, 23, 42, .08);
	--b-shadow2: 0 10px 20px rgba(15, 23, 42, .10);
	--b-r: 18px;
	--b-pill: 999px;
	--b-accent: #1b7bff; /* 헤더 톤과 맞춤 */
	--b-accent2: #E6C200; /* 포인트(헤더 서브컬러) */
}

/* ===== 전체 톤 ===== */
html, body {
	height: auto; /* ✅ 내용만큼 늘어나도록 변경 */
	min-height: 100%; /* 내용이 적어도 화면 꽉 차게 */
	margin: 0;
}

body {
	background: var(--b-bg);
	color: var(--b-ink);
}

/* 메인 레이아웃(기존 유지 + 조금 부드럽게) */
.main-layout {
	height: auto; /* ✅ 내용만큼 늘어나게 */
	min-height: calc(100vh - 140px); /* 최소 높이만 유지 */
	/* overflow: hidden;  <-- 삭제 */
}
/* [수정 후] ✅ 스크롤 따라오게 변경 */
aside {
	background: transparent;
	padding: 16px !important;
	/* ✅ 스티키(Sticky) 설정 */
	position: sticky;
	top: 170px; /* 브라우저 상단에서 30px 떨어진 위치에 고정 (원하는 만큼 조절) */
	align-self: flex-start; /* ✅ 핵심: 부모 높이만큼 억지로 늘어나지 않아야 따라다닙니다 */
	height: auto; /* 높이는 내용물 크기만큼만 */
	overflow: visible; /* 스크롤바 제거 */
}

section#content {
    background: transparent;
    height: auto;
    overflow: visible;

    /* ✅ 우측 고정 위젯(ddayDock) 자리 확보용
       - 위젯 폭(290px) + 여백(약 60~80px) 합쳐서 약 360px 정도를 비워두면 겹침이 사라짐 */
    padding: 22px 100px 22px 8px;  /* 위/오른쪽/아래/왼쪽 */
}

/* ✅ 가로 폭 유지 + 왼쪽 정렬로 변경 */
#content > * {
    max-width: 1100px;   /* 폭 제한은 유지(원하면 숫자만 조절) */
    width: 100%;
    margin-left: 0;      /* ✅ 왼쪽으로 붙이기 */
    margin-right: auto;  /* ✅ 오른쪽 여백은 남김(왼쪽 정렬 유지) */
}


/* ===== 왼쪽 메뉴를 카드처럼 ===== */
aside .fw-bold {
	font-weight: 950 !important;
	letter-spacing: -0.02em;
	margin-bottom: 10px !important;
}

aside .nav {
	background: var(--b-card);
	border: 1px solid var(--b-line);
	border-radius: var(--b-r);
	padding: 10px;
	box-shadow: var(--b-shadow);
}

aside .nav-link {
	border-radius: 14px;
	padding: 10px 12px;
	font-weight: 900;
	color: rgba(15, 23, 42, .78);
	transition: background .15s ease, transform .12s ease, color .15s ease;
}

aside .nav-link:hover {
	background: rgba(27, 123, 255, .08);
	color: var(--b-accent);
	transform: translateY(-1px);
}

/* ===== content: 상단 타이틀 세련되게 ===== */
#content .fw-bold.fs-4 {
	font-weight: 950 !important;
	letter-spacing: -0.03em;
	position: relative;
	display: inline-block;
	padding-bottom: 12px; /* ✅ 밑줄 들어갈 공간 확보 */
}

#content .fw-bold.fs-4::after {
	content: "";
	position: absolute;
	left: 0;
	bottom: 2px; /* ✅ 밑줄이 아래로 튀어나오지 않게(겹침 방지) */
	width: 56px;
	height: 3px;
	border-radius: 999px;
	background: linear-gradient(90deg, var(--b-accent), var(--b-accent2));
	opacity: .9;
}

#content .text-muted.small.fw-bold {
	color: var(--b-muted) !important;
	margin-top: 6px; /* ✅ “최신 글”을 아래로 살짝 내려서 더 안정감 */
}
/* ===== 테이블을 카드처럼 (홈페이지 톤과 맞춤) ===== */
#content .table-responsive {
	background: var(--b-card);
	border: 1px solid var(--b-line);
	border-radius: var(--b-r);
	box-shadow: var(--b-shadow);
	padding: 10px 12px 6px;
	overflow: hidden;
}

#content .table {
	margin: 0;
}

#content .table thead {
	background: #f4f6f8 !important;
}

#content .table thead th {
	font-size: 12px;
	font-weight: 950;
	color: rgba(15, 23, 42, .75);
	border-bottom: 1px solid var(--b-line) !important;
	padding: 14px 12px;
}

#content .table tbody td {
	padding: 12px 12px; /* 패딩을 살짝 줄여서 오밀조밀하게 */
	border-top: 1px solid rgba(15, 23, 42, .06) !important;
	/* 핵심 변경 사항 */
	font-size: 14px; /* 글자 크기 축소 (기본보다 작게) */
	font-weight: 400; /* 700(Bold) -> 400(Regular)로 변경하여 굵기 제거 */
	color: rgba(15, 23, 42, .70); /* 색상을 약간 더 연하게 (.86 -> .70) */
	vertical-align: middle; /* 텍스트 세로 중앙 정렬 */
}

#content .table tbody tr {
	transition: background .15s ease, transform .12s ease;
}

#content .table tbody tr:hover {
	background: rgba(27, 123, 255, .05);
	transform: translateY(-1px);
}

/* ===== 페이지 버튼을 pill로 + hover 효과 ===== */
#content .d-flex.gap-2.justify-content-center.py-2 .btn {
	border-radius: var(--b-pill) !important;
	padding: 6px 12px;
	border-color: rgba(15, 23, 42, .14) !important;
	background: #fff !important;
	font-weight: 900;
	transition: transform .12s ease, background .15s ease, border-color .15s
		ease, color .15s ease, box-shadow .15s ease;
}

#content .d-flex.gap-2.justify-content-center.py-2 .btn:hover {
	background: rgba(27, 123, 255, .08) !important;
	border-color: rgba(27, 123, 255, .30) !important;
	color: var(--b-accent) !important;
	transform: translateY(-1px);
	box-shadow: 0 8px 18px rgba(15, 23, 42, .08);
}

/* ===== 검색바를 한 덩어리(부드러운 pill)로 ===== */
#content form.d-flex.gap-2.justify-content-center.align-items-center.pt-3
	{
	background: var(--b-card);
	border: 1px solid var(--b-line);
	border-radius: var(--b-pill);
	padding: 10px 12px;
	box-shadow: var(--b-shadow2);
}

#content form select.form-select, #content form input.form-control {
	border-radius: var(--b-pill) !important;
	border: 1px solid rgba(15, 23, 42, .12) !important;
	font-weight: 800;
}

#content form select.form-select:focus, #content form input.form-control:focus
	{
	border-color: rgba(27, 123, 255, .40) !important;
	box-shadow: 0 0 0 4px rgba(27, 123, 255, .12) !important;
}

#content form button.btn-success {
	border-radius: var(--b-pill) !important;
	box-shadow: 0 10px 18px rgba(27, 123, 255, .18);
	transition: transform .12s ease, box-shadow .15s ease, filter .15s ease;
}

#content form button.btn-success:hover {
	transform: translateY(-1px);
	filter: brightness(1.02);
}

/* ===== 살짝 부드러운 등장 효과(로드/전환 시) ===== */
@
keyframes rise {from { opacity:0;
	transform: translateY(6px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
#content>* {
	animation: rise .18s ease both;
}

/* 반응형: 너무 좁아지면 max-width 완화 */
@media ( max-width : 992px) {
	#content>* {
		max-width: 100%;
	}
	section#content {
		padding: 18px 10px;
	}
}

/* ✅ 레이아웃 전체를 중앙으로 모으기(좌측/우측이 화면 끝에 붙지 않게) */
.container-fluid.flex-grow-1 .row.main-layout {
	max-width: 1320px; /* 전체 폭(원하면 1200~1400 사이로 조절) */
	margin-left: auto;
	margin-right: auto;
	--bs-gutter-x: 18px; /* 좌측메뉴-우측영역 사이 간격(기본보다 살짝 줄임) */
}

/* ===== HOME 공지사항(테이블 상단 고정) 스타일 ===== */
tr.notice-row {
	background: #fff1f1;
}

.notice-badge {
	display: inline-block;
	padding: 3px 8px;
	border-radius: 999px;
	background: #ff4d4f;
	color: #fff;
	font-weight: 900;
	font-size: 12px;
}

.notice-title {
	color: #d32f2f;
	font-weight: 900;
}

tr.notice-row td {
	margin-left: font-weight: 700 !important; /* 공지는 굵게 유지 */
	color: #d32f2f !important; /* 공지 텍스트 색상 (붉은 계열 or 검정) */
	background-color: #fff1f1; /* 배경색 유지 */
	font-size: 14px; /* 크기는 일반글과 맞추거나 살짝 키움 */
}

/* [선택] 일반 글이라도 '제목'은 마우스 올렸을 때 조금 진해지게 하고 싶다면 */
#content .table tbody tr:hover td {
	color: rgba(15, 23, 42, 1); /* 호버 시 글자색 진하게 */
}

/* HOME 번호 색상 구분: 문의(어두운 하늘색), 리뷰(어두운 노란색) */
#content .table tbody td.board-no-qna,
#content .table tbody tr:hover td.board-no-qna {
	color: #1e6b8f !important;
	font-weight: 800;
}

#content .table tbody td.board-no-review,
#content .table tbody tr:hover td.board-no-review {
	color: #8a6d00 !important;
	font-weight: 800;
}
</style>
</head>

<body>
	<!-- 공통 헤더 -->
	<jsp:include page="/WEB-INF/views/common/tctHeader.jsp" />

	<!-- Main Layout -->
	<div class="container-fluid flex-grow-1">
		<div class="row main-layout">

			<!-- Aside -->
			<aside class="col-3 col-md-2 p-3 border-end">
				<div class="fw-bold mb-3">게시판</div>
				<ul class="nav flex-column">
					<li class="nav-item mb-2"><a class="nav-link" href="#"
						onclick="loadContent('HOME'); return false;">🏠 게시판 홈</a></li>
					<li class="nav-item mb-2"><a class="nav-link" href="#"
						onclick="loadContent('QNA'); return false;">💬 문의게시판</a></li>
					<li class="nav-item mb-2"><a class="nav-link" href="#"
						onclick="loadContent('REVIEW'); return false;">⭐ 리뷰게시판</a></li>
					<!-- 리턴의 차이는 없으면 페이지가 상단으로가버림 UX 나빠질수도있음
																					리턴 false있으면 100줄밑에 내려가있어도 그위치고정  -->
				</ul>
			</aside>

			<!-- Content -->
			<section class="col-9 col-md-10" id="content">
				<h2 class="fw-bold fs-4">게시판</h2>
				<p class="text-muted fw-bold">왼쪽 메뉴를 클릭하여 내용을 확인하세요.</p>
			</section>


		</div>
	</div>

	<!-- ===== 1) 컨텍스트 경로(CTX) 먼저 선언 ===== -->
	<script>
    //  : mypath는 "우리 프로젝트 컨텍스트 루트" (예: /tryCatchTrip)
    const mypath = "<%=request.getContextPath()%>";
	const CTX = "<%=request.getContextPath()%>";

	
    const loadUtil = async (url, element, callback) => {
      try {
        const res = await fetch(url);
       // if (!res.ok) throw new Error("HTTP " + res.status);
        const html = await res.text();
        
		/*board_review_frag 같은곳에 스크립트를 넣을 수 없는 이유
         innerHTML로 입력받은 데이터는 스크립트무시됨(보안상) 	*/
        element.innerHTML = html;
		
        //  : fragment를 끼워 넣은 뒤, 그 화면에 필요한 이벤트/초기 로딩을 다시 건다
        if (typeof callback === "function") callback();

      } catch (err) {
        console.log(err);
        element.innerHTML = `<p class="text-danger fw-bold">화면을 불러오지 못했습니다.</p>`;
      }
    };

    // 메뉴별 화면 전환
// ✅ 이제 "실제 화면 로딩"은 라우터(routePro)가 담당하고,
//    loadContent는 "hash만 바꾸는 함수"로 바꾼다. (뒤로가기/새로고침 자연스럽게)
const loadContent = (menu) => {
  switch (menu) {
    case "HOME":
      location.hash = "#home";
      break;
    case "QNA":
      location.hash = "#qna";
      break;
    case "REVIEW":
      location.hash = "#review";
      return false;
    default:
      location.hash = "#home";
      break;
  }
  return false;
};


  </script>

	<script src="<%=request.getContextPath()%>/js/boardhome.js?v=20260208"></script>
	<script src="<%=request.getContextPath()%>/js/boardhomeevent.js"></script>
	<script src="<%=request.getContextPath()%>/js/boardqna.js"></script>
	<script src="<%=request.getContextPath()%>/js/boardqnaevent.js"></script>
	<script src="<%=request.getContextPath()%>/js/boardreview.js"></script>
	<script src="<%=request.getContextPath()%>/js/boardqnareply.js"></script> <!--댓글추가기능 1.(서버qna) 2. boardqnaevent 다음에 올것  -->




	<!-- 	브라우저가 /board.do로 이동
		
		서버가 board.jsp를 렌더링해서 내려줌
		
		브라우저가 board.jsp의 DOM을 만듦 (#content는 존재)
		
		DOMContentLoaded 발생
		
		loadContent("HOME") 실행
		
		loadUtil("/boardHomeFrag.do", #content, boardHomePro) 실행
		
		frag가 #content에 들어감 → 이때 #homeTbody가 DOM에 생성됨
		
		callback으로 boardHomePro() 실행
		
		boardHomePro 안에서 document.querySelector("#homeTbody")가 이제 잡힘
    -->

  <%@ include file="/WEB-INF/views/common/tctFooter.jsp" %>

</body>
</html>
