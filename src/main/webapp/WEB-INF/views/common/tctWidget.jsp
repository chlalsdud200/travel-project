<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
/* 위젯 위치 및 레이아웃 */
.ddayDock {
	position: fixed;
	right: 60px;
	top: 180px;
	transform: scale(0.85);          /* ✅ 위젯(1,2,체크리스트) 전체를 15% 축소하기 위함 */
	transform-origin: top right; /* 우측 고정 기준으로 자연스럽게 줄어들게 하기 위함 */
	z-index: 80;
	display: flex;
	flex-direction: column;
	gap: 16px;
	width: 290px;
}


/* (추가) 아이콘에서 다시 펼칠 때 '팝업처럼' 빠르게 펼쳐지는 느낌을 주기 위함 */
.ddayDock.isOpening{
  animation: ddayDockPop 180ms ease-out; /* 짧고 빠르게 */
  transform-origin: bottom right;        /* 아래/오른쪽에서 펼쳐지는 느낌 */
}
@keyframes ddayDockPop{
  from { opacity: 0; transform: translateY(10px) scale(0.816); } /* 0.96 * 0.85 */
  to   { opacity: 1; transform: translateY(0)  scale(0.85); }
}

/* =========================
 * (추가) 도크 → 아이콘 모드
 * - 창이 좁을 때 위젯이 컨텐츠를 가리는 상황을 사용자가 직접 회피할 수 있게 하기 위함
 * ========================= */
.ddayDock.isMini {
  display: none !important; /* JS가 display:flex를 줘도 "아이콘 모드"면 무조건 숨기기 위함 */
}




/* (추가) "접혀서 아이콘만 남는" 느낌을 주기 위한 빠른 접힘 애니메이션 */
.ddayDock.isCollapsing{
  opacity: 0;                 /* 내용이 사라지며 접히는 느낌을 주기 위함 */
  transform: scale(0.12);     /* 0.85 → 0.12로 줄어들며 '접힘'처럼 보이게 하기 위함 */
  transition: transform 160ms ease-out, opacity 160ms ease-out;
  pointer-events: none;       /* 접히는 중 클릭 오작동 방지 */
}

/* (추가) 접히는 동안 "카드 안 비행기 버튼"은 숨겨서, 화면에 아이콘이 2개로 보이지 않게 하기 위함 */
.ddayDock.isMiniing .ddayMiniBtn{
  visibility: hidden;
}


/* =========================
   (추가) 도크 드래그 핸들
   - 펼친 상태에서도 위치 이동 가능하게 만들기 위함
   ========================= */
.ddayDockHandle{
  height: 26px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: grab;
  user-select: none;
  touch-action: none; /* 모바일/터치에서 스크롤 대신 드래그가 되게 */
  border: 1px dashed rgba(15, 23, 42, 0.18);
  border-radius: 12px;
  background: rgba(15, 23, 42, 0.02);
  color: rgba(15, 23, 42, 0.55);
  font-weight: 900;
  font-size: 12px;
}

.ddayDockHandle:active{
  cursor: grabbing;
}

/* (추가) 아이콘 위치(드래그한 위치) 기준으로 도크를 띄우기 위한 모드 */
.ddayDock.isPopover{
  left: var(--dock-left) !important;   /* 아이콘 좌표에서 펼치기 위함 */
  top: var(--dock-top) !important;
  right: auto !important;             /* 기본 right/top 고정 위치를 무효화 */
  bottom: auto !important;
}

/* (추가) 1번 위젯 헤더의 "아이콘으로 줄이기" 버튼 */
.ddayHeadRight{
  display:flex;             /* 접기버튼/축소버튼을 한 줄로 정렬하기 위함 */
  align-items:center;       /* 버튼 세로 가운데 정렬 */
  gap:8px;                  /* 버튼 간격 */
}

.ddayMiniBtn{
  width: 44px;              /* 살짝 더 동글한 귀여운 느낌 */
  height: 44px;
  border-radius: 16px;      /* 더 말랑한 라운드 */
  border: 1px solid rgba(255, 180, 200, 0.65);
  background: linear-gradient(180deg, #fff4f8 0%, #ffffff 100%);
  cursor: pointer;          /* 클릭 가능한 UI라는 걸 명확히 */
  font-weight: 900;
  font-size: 19px;          /* 아이콘 자체도 더 크게 보이게 하기 위함 */
  line-height: 1;
  display: inline-flex;     /* 가운데 정렬을 쉽게 하기 위함 */
  align-items: center;
  justify-content: center;
  box-shadow: 0 6px 14px rgba(255, 182, 193, 0.35), inset 0 1px 0 rgba(255,255,255,0.8);
}

.ddayMiniBtn:hover{
  background: linear-gradient(180deg, #ffe7f0 0%, #fff 100%); /* 호버 피드백 */
  transform: translateY(-1px);
}

/* (추가) 도크를 접었을 때 남는 "드래그 가능한 아이콘" */
.ddayMini{
  position: fixed;          /* 스크롤해도 항상 화면에 떠 있게 하기 위함 */
  right: 24px;              /* 기본 위치(처음엔 우하단) */
  bottom: 24px;
  z-index: 90;              /* 컨텐츠 위로 올라오게 하기 위함 (도크 z-index=80보다 높게) */
  width: 64px;
  height: 64px;
  border-radius: 22px;
  display: none;            /* 기본은 숨김(아이콘 모드일 때만 보임) */
  align-items: center;
  justify-content: center;
  background: radial-gradient(circle at 30% 20%, #fff7fb 0%, #ffffff 60%, #ffeef6 100%);
  border: 1px solid rgba(255, 180, 200, 0.55);
  box-shadow: 0 12px 26px rgba(255, 182, 193, 0.35), inset 0 1px 0 rgba(255,255,255,0.7);
  cursor: grab;             /* 드래그 UI라는 걸 표현 */
  user-select: none;        /* 드래그 중 텍스트 선택 방지 */
}
.ddayMini:active{
  cursor: grabbing;         /* 잡고 끄는 느낌 */
}

.ddayMini.isShow{
  display: flex;            /* 아이콘 모드에서만 보이게 하기 위함 */
}

.ddayMiniIcon{
  font-size: 23px;          /* 아이콘 가독성 */
}




/* (추가) 접힌 아이콘 아래에 보여줄 D-day 라벨 */
.ddayMiniLabel{
  position: absolute;              /* 아이콘 박스(60x60) 기준으로 아래에 띄움 */
  left: 50%;
  top: 60px;                       /* 아이콘 박스 아래 */
  transform: translate(-50%, 6px);
  display: none;                   /* JS가 텍스트 있을 때만 보여줌 */
  align-items: center;
  justify-content: center;
  padding: 2px 8px;
  border-radius: 999px;
  background: #fff7fb;
  border: 1px solid rgba(255, 180, 200, 0.55);
  box-shadow: 0 6px 16px rgba(255, 182, 193, 0.25);
  font-size: 12px;
  font-weight: 900;
  color: #e11d48;
  line-height: 1;
  white-space: nowrap;
  pointer-events: none;            /* 드래그/클릭 방해 금지 */
}
/* 체크리스트 확인 버튼(위젯 아래) - 디자인 업그레이드 */
.ddayChecklistBtn {
	width: 100%; /* 위젯 카드 폭(290px)에 맞춰 꽉 차게 보여주기 위함 */
	padding: 14px 0; /* 버튼 높이를 조금 키워 터치/클릭 영역 확보 */
	border-radius: 14px; /* 말랑한 라운드 */
	
	/* [디자인 변경] 귀여운 파스텔 톤 */
	background: linear-gradient(180deg, #ffffff 0%, #fff3f7 100%); 
	border: 1px solid rgba(255, 180, 200, 0.7); 
	color: #e11d48; 
	
	font-weight: 900; /* '체크리스트 확인'을 강하게 보이게 하려는 목적 */
	cursor: pointer; /* 클릭 가능한 요소임을 전달 */
	box-shadow: 0 6px 16px rgba(255, 182, 193, 0.25); /* 카드처럼 떠있는 느낌 */
	transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1); /* 부드러운 전환 효과 */
	
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 6px;
}

.ddayChecklistBtn:hover {
	border-color: #fb7185; /* 호버 시 '눌러보라'는 피드백 */
	background: #ffe7f0;
	transform: translateY(-2px); /* 살짝 떠오르는 효과 */
	box-shadow: 0 8px 18px rgba(255, 182, 193, 0.3);
}

/* [추가] 팝업이 열려있을 때 버튼이 '눌린 상태'로 유지되게 하기 위함 */
.ddayChecklistBtn.active {
	background: linear-gradient(180deg, #fb7185 0%, #f43f5e 100%); /* 눌린 상태 강조 */
	color: #ffffff;            /* 텍스트는 흰색으로 반전 */
	border-color: #f43f5e;
	box-shadow: inset 0 2px 4px rgba(0,0,0,0.1); /* 살짝 눌린 깊이감 */
	transform: translateY(0);  /* 위치 원복 */
}

/* 공통 카드 스타일 */
.ddayCard {
	background: linear-gradient(180deg, #ffffff 0%, #fff7fb 100%);
	border-radius: 18px;
	box-shadow: 0 10px 24px rgba(255, 182, 193, 0.22);
	overflow: hidden;
	transition: all 0.3s ease;
	border: 1px solid rgba(255, 180, 200, 0.45);
}

/* 1번 위젯: 파란 테두리 강조 */
.ddayCard.isPrimary {
	border: 1.6px solid #fbcfe8;
	box-shadow: 0 12px 28px rgba(244, 114, 182, 0.25);
}

/* 2번 위젯: 은은한 톤 */
.ddayCard.isSecondary {
	background: linear-gradient(180deg, #ffffff 0%, #fef3f7 100%);
	border: 1px solid rgba(244, 114, 182, 0.25);
}

/* 헤더 영역 */
.ddayHead {
	padding: 16px 18px 14px;
	display: flex;
	flex-direction: column;
	gap: 8px;
}

/* [1] 윗줄: 라벨 + 접기버튼 */
.ddayHeadTop {
	display: flex;
	justify-content: space-between;
	align-items: center;
	height: 20px;
}

/* [2] 아랫줄: 제목 + D-day (나란히 배치) */
.ddayTitleRow {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 10px;
	width: 100%;
}

/* '다음여행' 라벨 */
.ddayTagNext {
	font-size: 11px;
	font-weight: 700;
	color: #ffffff;
	background: linear-gradient(180deg, #fb7185 0%, #f43f5e 100%);
	padding: 3px 8px;
	border-radius: 99px;
	letter-spacing: -0.02em;
	box-shadow: 0 4px 10px rgba(244, 114, 182, 0.35);
}

/* 접기 버튼 */
.ddayFoldBtn {
	background: #fff;
	border: 1px solid #cbd5e1;
	color: #64748b;
	font-size: 11px;
	padding: 2px 8px;
	border-radius: 12px;
	cursor: pointer;
	transition: all 0.2s;
	margin-left: auto;
}

.ddayFoldBtn:hover {
	background: #f1f5f9;
	color: #334155;
	border-color: #94a3b8;
}

/* 제목 */
.ddayTitle {
	flex: 1;
	min-width: 0;
	font-size: 15px;
	font-weight: 700;
	color: #1e293b;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

.ddayTitle a {
	text-decoration: none;
	color: inherit;
}

.ddayTitle a:hover {
	color: #1b7bff;
	text-decoration: underline;
}

.ddayCard.isSecondary .ddayTitle {
	color: #475569;
}

/* D-day 배지 */
.ddayBadge {
	flex-shrink: 0;
	font-family: 'Jua', sans-serif;
	font-size: 18px;
	color: #dc2626; /* 1번: 빨강 */
	white-space: nowrap;
}

.ddayCard.isSecondary .ddayBadge {
	color: #64748b; /* 2번: 회색 */
}

/* 달력 영역 */
.ddayCal {
	padding: 10px 18px 18px;
	background: #fff;
	border-top: 1px solid #f1f5f9;
}

.ddayCard.isSecondary .ddayCal {
	background: #f8fafc;
}

/* 접힘 상태 */
.ddayCard.isFolded .ddayCal {
	display: none;
}

.ddayCard.isFolded {
	padding-bottom: 0;
}

/* 달력 그리드 */
.ddayCalHead {
	font-size: 13px;
	font-weight: 800;
	color: #475569;
	margin-bottom: 12px;
	text-align: center;
}

.ddayDow, .ddayGrid {
	display: grid;
	grid-template-columns: repeat(7, 1fr);
	gap: 4px;
	text-align: center;
}

.ddayDow span {
	font-size: 10px;
	color: #94a3b8;
	margin-bottom: 6px;
}

.dCell {
	height: 24px;
	display: flex;
	align-items: center;
	justify-content: center;
	border-radius: 6px;
	font-size: 11px;
	font-weight: 600;
	color: #334155;
}

.dCell.isOther {
	color: #cbd5e1;
}

.dCell.isPast {
	color: #e2e8f0;
	text-decoration: line-through;
}



.dCell.isToday{
  text-decoration: underline;
  text-decoration-color: #ef4444;
  text-underline-offset: 3px;
  text-decoration-thickness: 2px;
}
.dCell.isStart {
	background: #1b7bff;
	color: #fff;
	font-weight: 800;
	box-shadow: 0 2px 6px rgba(27, 123, 255, 0.4);
}

/* [새로 추가] 무지개 텍스트 효과 클래스 */
.rainbow-text {
	/* 왼쪽에서 오른쪽으로 무지개 그라데이션 배경 설정 */
	background-image: linear-gradient(to right, #ff0000, #ff7f00, #ffd700, #008000, #0000ff,
		#4b0082, #9400d3);
	/* 배경을 텍스트 모양으로 잘라냄 */
	-webkit-background-clip: text;
	background-clip: text;
	/* 실제 텍스트 색상을 투명하게 만들어 배경이 비치게 함 */
	-webkit-text-fill-color: transparent;
	/* span 태그에 적용이 잘 되도록 설정 */
	display: inline-block;
}

/* 방법 3: 텍스트 글로우(Glow) 효과 */
.ddayCard.isPrimary .ddayTitle a {
	color: #2563eb; /* 베이스는 쨍한 파랑 */
	text-shadow: 0 0 20px rgba(37, 99, 235, 0.4); /* 뒤로 은은하게 번짐 */
}

/* =========================
   [출발임박 팝업] 체크리스트 모달 전용 스타일
   - : pop.html의 스타일을 공통영역(tctWidget.jsp)에 넣되, 다른 페이지/부트스트랩과 충돌하지 않게 범위를 고정하기 위함
========================= */

/* 팝업 배경(오버레이) */
#ddayPopupModal {
	display: none; /* 기본은 숨김: 출발 5일 이내일 때만 JS가 열기 위함 */
	position: fixed; /* 스크롤과 상관없이 화면에 고정하기 위함 */
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	
	/* [수정] 배경 블러 최소화 요청 반영 (4px -> 1.5px) */
	background: rgba(15, 23, 42, 0.65); 
	backdrop-filter: blur(1.5px); 
	
	z-index: 1000; /* 헤더/위젯보다 위에 뜨게 하려는 목적 */
	justify-content: center; /* 팝업을 가로 가운데 정렬하기 위함 */
	align-items: center; /* 팝업을 세로 가운데 정렬하기 위함 */
	
	animation: fadeIn 0.3s ease-out; /* 등장 애니메이션 추가 */
}

@keyframes fadeIn {
	from { opacity: 0; }
	to { opacity: 1; }
}

/* 팝업 본문 박스 */
#ddayPopupModal .ddayP-content {
	background: #fff; /* 흰 배경으로 내용 가독성 확보 */
	
	/* [수정] 스크롤 방지를 위해 폭은 늘리고(Wide), 패딩은 조금 줄임 */
	padding: 20px 24px; 
	width: 520px; /* 기존 440px -> 520px 확대 (줄바꿈 방지) */
	
	border-radius: 20px; /* 카드 느낌을 주기 위함 (더 둥글게) */
	box-shadow: 0 20px 50px rgba(0, 0, 0, 0.2); /* 떠있는 느낌을 주기 위함 (그림자 강화) */
	
	/* [수정] 높이 제한을 거의 풀어줌 (95vh) */
	max-height: 95vh; 
	overflow: auto; /* 혹시라도 넘치면 스크롤이 생기긴 해야 함 */
}

/* 팝업 헤더(제목 + D-day) */
#ddayPopupModal .ddayP-header {
	display: flex; /* 제목과 배지를 한 줄에 배치하기 위함 */
	justify-content: space-between; /* 좌/우로 깔끔하게 분리하기 위함 */
	align-items: center; /* 세로 정렬 */
	
	/* [수정] 간격 축소 (Compact) */
	margin-bottom: 15px; 
	border-bottom: 2px solid #f1f5f9; /* 헤더 영역 분리선 */
	padding-bottom: 10px;
}

#ddayPopupModal .ddayP-header h2 {
	margin: 0;
	font-size: 1.25rem; /* 제목 가독성 */
	color: #1e293b;
	font-weight: 800;
}

/* D-day 배지 */
#ddayPopupModal .ddayP-badge {
	display: inline-flex; /* pill 모양을 안정적으로 만들기 위함 */
	align-items: center;
	padding: 6px 14px;
	border-radius: 999px; /* pill 형태 */
	background: #eff6ff; /* 더 부드러운 블루 */
	color: #1b7bff;
	font-weight: 900;
	font-size: 0.95rem;
	white-space: nowrap; /* D-숫자 줄바꿈 방지 */
}

/* 상단 여행정보 박스 */
#ddayPopupModal .ddayP-tripBox {
	border: 1px solid #e2e8f0; /* 카드 테두리 (색상 미세조정) */
	border-radius: 12px; /* 둥근 모서리 */
	
	/* [수정] 내부 여백 축소 (Compact) */
	padding: 12px 16px; 
	
	background: #f8fafc; /* 체크리스트와 구분되는 은은한 배경 */
	
	/* [수정] 하단 여백 축소 (Compact) */
	margin-bottom: 15px; 
}

#ddayPopupModal .ddayP-row {
	display: flex; /* 라벨/값을 한 줄에 배치하기 위함 */
	justify-content: space-between;
	align-items: center;
	gap: 12px;
	
	/* [수정] 줄 높이 축소 (Compact) */
	padding: 5px 0; 
	
	border-bottom: 1px solid #f1f5f9; /* [디자인 변경] 점선 대신 아주 연한 실선 또는 제거 */
}

#ddayPopupModal .ddayP-row:last-child {
	border-bottom: 0; /* 마지막 줄은 구분선 제거 */
}

#ddayPopupModal .ddayP-k {
	font-size: 0.85rem;
	color: #64748b;
	font-weight: 600;
	white-space: nowrap; /* 라벨이 줄바꿈되면 지저분해져서 방지 */
}

#ddayPopupModal .ddayP-v {
	font-size: 0.95rem;
	color: #334155;
	font-weight: 700;
	text-align: right; /* 값은 오른쪽 정렬이 보기 좋아서 */
}

/* 체크리스트 그룹 */
#ddayPopupModal .ddayP-group {
	/* [수정] 그룹 간격 축소 (Compact) */
	margin-bottom: 12px; 
}

#ddayPopupModal .ddayP-groupTitle {
	font-size: 0.85rem;
	color: #94a3b8;
	font-weight: 800;
	margin-bottom: 6px;
	display: block;
	text-transform: uppercase;
}

#ddayPopupModal .ddayP-item {
	display: flex;
	align-items: center;
	
	/* [수정] 항목 간 여백 축소 (Compact) */
	padding: 4px 8px; 
	margin-bottom: 2px;
	
	font-size: 0.95rem;
	color: #334155;
	cursor: pointer; /* 클릭 가능하다는 느낌 */
	border-radius: 8px;
	transition: background 0.2s;
}

#ddayPopupModal .ddayP-item:hover {
	background: #f1f5f9; /* 호버 시 배경색 변경으로 클릭 유도 */
}

#ddayPopupModal .ddayP-item input {
	margin-right: 12px;
	transform: scale(1.2);
	cursor: pointer;
	accent-color: #1b7bff; /* 브라우저 기본 체크박스 색상 변경 */
}

/* 버튼 2개를 나란히 배치: '3일동안 보지않음'과 '닫기'를 한 줄에 두기 위함 */
#ddayPopupModal .ddayP-btnRow {
	display: flex; /* 가로 정렬을 위한 flex */
	gap: 12px; /* 버튼 간 간격 */
	
	/* [수정] 버튼 위 여백 축소 */
	margin-top: 15px; 
}

/* 3일동안 보지않음 버튼: 닫기 버튼보다 "덜 강한" 톤으로 보이게 하기 위함 */
#ddayPopupModal .ddayP-hideBtn {
	flex: 1; /* 두 버튼이 같은 폭으로 보이게 하기 위함 */
	padding: 14px;
	background: #f1f5f9; /* 회색: '나중에 보기' 성격을 표현 */
	color: #64748b;
	border: none;
	border-radius: 10px;
	font-weight: 700;
	cursor: pointer;
	transition: all 0.2s;
}

#ddayPopupModal .ddayP-hideBtn:hover {
	background: #e2e8f0; /* hover 피드백 */
	color: #475569;
}

/* 기존 닫기 버튼도 flex로 폭 맞추기: btnRow 안에서 깔끔하게 정렬되게 하기 위함 */
#ddayPopupModal .ddayP-closeBtn {
	flex: 1;
	padding: 14px;
	background-color: #1e293b; /* 조금 더 진한 네이비 */
	color: white;
	border: none;
	border-radius: 10px;
	font-weight: 700;
	cursor: pointer;
	transition: all 0.2s;
}

#ddayPopupModal .ddayP-closeBtn:hover {
	background-color: #0f172a;
	box-shadow: 0 4px 12px rgba(15, 23, 42, 0.2);
}

/* 상품명 링크: 클릭하면 상품상세로 이동하게 "링크처럼 보이게" 하는 목적 */
#ddayPopupModal .ddayP-prodLink {
	color: #1b7bff; /* 링크임을 직관적으로 보여주기 위함 */
	font-weight: 800; /* 팝업에서 상품명이 핵심이므로 강조 */
	text-decoration: none; /* 기본 밑줄 제거(호버 시만 밑줄) */
}

#ddayPopupModal .ddayP-prodLink:hover {
	text-decoration: underline; /* 마우스 올리면 링크라는 피드백 */
}
</style>

<div id="ddayDock" class="ddayDock" style="display: none;"></div>

<!-- (추가) 도크를 접었을 때 대신 보여줄 "미니 아이콘" (드래그 가능) -->
<div id="ddayMini" class="ddayMini" title="출발 위젯 열기">
  <span class="ddayMiniIcon">✈️</span>


  <!-- (추가) 접힌 상태(아이콘)에서 D-day를 표시할 라벨 -->
  <span id="ddayMiniLabel" class="ddayMiniLabel"></span>
</div>


<div id="ddayPopupModal">
	<div class="ddayP-content">

		<div class="ddayP-header">
			<h2>🛫 여행 전 필수 체크리스트</h2>
			<span class="ddayP-badge" id="ddayP_badge"></span>
		</div>

		<div class="ddayP-tripBox">
			<div class="ddayP-row">
				<div class="ddayP-k">상품명(등록상품번호)</div>
				<div class="ddayP-v" id="ddayP_prod"></div>
			</div>
			<div class="ddayP-row">
				<div class="ddayP-k">주문번호</div>
				<div class="ddayP-v" id="ddayP_orderNo"></div>
			</div>
			<div class="ddayP-row">
				<div class="ddayP-k">여행기간</div>
				<div class="ddayP-v" id="ddayP_period"></div>
			</div>
			<div class="ddayP-row">
				<div class="ddayP-k">결제 총가격</div>
				<div class="ddayP-v" id="ddayP_totalPrice"></div>
			</div>
			<div class="ddayP-row">
				<div class="ddayP-k">호텔정보</div>
				<div class="ddayP-v" id="ddayP_hotel"></div>
			</div>
		</div>

		<div class="ddayP-body">

			<div class="ddayP-group">
				<span class="ddayP-groupTitle">필수 서류 & 예약</span> <label
					class="ddayP-item"> <input type="checkbox"
					data-id="check_passport"> 여권 유효기간 (6개월 이상)
				</label> <label class="ddayP-item"> <input type="checkbox"
					data-id="check_eticket"> E-티켓 / 항공권 출력
				</label> <label class="ddayP-item"> <input type="checkbox"
					data-id="check_voucher"> 호텔 바우처 확인
				</label>
			</div>

			<div class="ddayP-group">
				<span class="ddayP-groupTitle">환전 & 데이터</span> <label
					class="ddayP-item"> <input type="checkbox"
					data-id="check_currency"> 현지 화폐 환전
				</label> <label class="ddayP-item"> <input type="checkbox"
					data-id="check_sim"> 유심/로밍/포켓와이파이
				</label>
			</div>

			<div class="ddayP-group">
				<span class="ddayP-groupTitle">물품 확인</span> <label
					class="ddayP-item"> <input type="checkbox"
					data-id="check_meds"> 상비약(소화제, 진통제, 감기약, 지사제, 대역폭), 선크림,
					선글라스, 우산/우의 등
				</label> <label class="ddayP-item"> <input type="checkbox"
					data-id="check_adapter"> 스마트폰, 충전기, 멀티 어댑터(어댑터 종류 필수),
					보조배터리
				</label> <label class="ddayP-item"> <input type="checkbox"
					data-id="check_clothing"> 현지 날씨에 맞는 옷, 속옷, 양말, 잠옷, 수영복, 칫솔
					세트, 기초 화장품 등
				</label>
			</div>
		</div>

		<div class="ddayP-btnRow">
			<button type="button" class="ddayP-hideBtn" id="btnDdayPopupHide3d">3일
				동안 보지 않기</button>

			<button type="button" class="ddayP-closeBtn" id="btnDdayPopupClose">확인
				및 닫기</button>
		</div>
	</div>
</div>

<script>
async function loadDdayDock(ddayDock, ctxPath){
    const res = await fetch(ctxPath + "/ddayWidget.do", { method: "GET" });
    const json = await res.json();

    if (!json.ok) {
        ddayDock.style.display = "none";
        return;
    }

    const list = json.data || [];
    if (list.length === 0) {
        ddayDock.style.display = "none";
        return;
    }

    const foldKey = "TCT_DDAY_FOLD_SECOND";               
	
 // (추가) "도크를 아이콘으로 줄인 상태"를 유지하기 위한 키(새로고침/재방문에도 유지하려고 localStorage 사용)
    const MINI_KEY     = "TCT_DDAY_DOCK_MINI";

    // (추가) 사용자가 드래그로 옮긴 "아이콘 좌표"를 저장하기 위한 키
    const MINI_POS_KEY = "TCT_DDAY_DOCK_MINI_POS";

    // (추가) 사용자가 "펼친 도크"를 드래그로 옮긴 좌표를 저장하기 위한 키
    const DOCK_POS_KEY = "TCT_DDAY_DOCK_POS";


    // (추가) 아이콘 DOM을 잡는 이유: 아이콘 표시/드래그/복원 이벤트를 붙이기 위함
    const miniEl = document.getElementById("ddayMini");

    // (추가) 아이콘 드래그 + (클릭 시) 도크 복원 이벤트를 "한 번만" 바인딩하기 위함
    _bindDdayMiniIcon(miniEl, ddayDock, MINI_KEY, MINI_POS_KEY);

    // 기본 접힘 상태 ('0'이 아니면 true)
    const isFoldedSecond = sessionStorage.getItem(foldKey) !== "0"; 

    const fmt = (n) => {
        if (n === 0) return "D-DAY";
        if (n > 0)   return "D-" + n;
        return "D+" + Math.abs(n);
    };

    
    // (추가) 0번째(가장 가까운 여행) D-day를 접힌 아이콘 아래 라벨로도 쓰기 위함
    if(miniEl && list.length > 0){
        let d0 = Number(list[0].dday);
        if(isNaN(d0)) d0 = 0;
        miniEl.dataset.ddayText = fmt(d0);
        _syncMiniDdayLabel(miniEl);
    }

// (추가) 펼친 상태에서도 도크를 드래그로 이동할 수 있게, 맨 위에 핸들을 렌더링한다

    ddayDock.innerHTML = list.map((it, idx) => {
        const isPrimary = (idx === 0);
        const toneCls   = isPrimary ? "isPrimary" : "isSecondary";
        const foldedCls = (!isPrimary && isFoldedSecond) ? " isFolded" : ""; 
        const href = ctxPath + "/regProdDetail.do?regId=" + encodeURIComponent(it.regId);

        const labelWrapperStyle = isPrimary ? "flex:1; text-align:center; cursor: grab; user-select:none;" : "";
        const labelClass = isPrimary ? "ddayDockDragLabel" : "";

        let leftLabel = "";
        if (!isPrimary) {
            leftLabel = '<span class="ddayTagNext">다음여행</span>';
        } else {
            leftLabel = '<span class="rainbow-text ' + labelClass + '" style="font-size:12px; font-weight:800;">Upcoming Trip</span>';
        }

        let foldBtn = "";
        if (!isPrimary) {
            const btnText = isFoldedSecond ? "펼치기" : "접기";
            foldBtn = '<button type="button" class="ddayFoldBtn">' + btnText + '</button>';
        }

        // (추가) 1번 위젯에만 "아이콘으로 줄이기" 버튼을 보여주기 위함
        let miniBtn = "";
        if (isPrimary) {
            miniBtn = '<button type="button" class="ddayMiniBtn" title="위젯을 아이콘으로 줄이기">✈️</button>';
        }

        const ddayBadge = '<span class="ddayBadge">' + fmt(Number(it.dday)) + '</span>';
        const titlePrefix = isPrimary ? "✈️ " : "";

        // ✅ 카드 1개 HTML
        const cardHtml =
            ""
          + '<div class="ddayCard ' + toneCls + foldedCls + '" data-idx="' + idx + '" data-start="' + it.startYmd + '">'
          + '  <div class="ddayHead">'
          + '    <div class="ddayHeadTop">'
          +        '<div style="' + labelWrapperStyle + '">' + leftLabel + '</div>'
          +        '<div class="ddayHeadRight">' + foldBtn + miniBtn + '</div>' // 접기/축소 버튼을 한 줄로 묶기 위함
          + '    </div>'
          + '    <div class="ddayTitleRow">'
          + '      <div class="ddayTitle" title="' + it.regTitle + '">'
          + '        <a href="' + href + '">' + titlePrefix + it.regTitle + '</a>'
          + '      </div>'
          +        ddayBadge
          + '    </div>'
          + '  </div>'
          + '  <div class="ddayCal"></div>'
          + '</div>';

        // ✅ 핵심: idx===0(첫 번째 위젯) 뒤에만 버튼을 “끼워 넣기”
        // - : 버튼을 "첫 번째 위젯 바로 아래"에 고정하기 위함
        const btnHtml = (idx === 0)
          ? '<button type="button" class="ddayChecklistBtn" id="btnDdayChecklistOpen">체크리스트 확인</button>'
          : '';

        return cardHtml + btnHtml;
    }).join("");

    // (추가) 펼친 상태에서도 도크를 이동(드래그)할 수 있게 바인딩
    _bindDockDrag(ddayDock, ddayDock.querySelector(".ddayDockDragLabel"), DOCK_POS_KEY, MINI_POS_KEY);

    // (추가) 이전에 사용자가 도크를 옮겼다면, 그 좌표로 복원(새로고침/페이지 이동에도 유지)
    const _savedDockPos = localStorage.getItem(DOCK_POS_KEY);
    if (_savedDockPos) {
      try {
        const p = JSON.parse(_savedDockPos);
        if (p && Number.isFinite(p.left) && Number.isFinite(p.top)) {
          _applyDockPos(ddayDock, p.left, p.top);
        }
      } catch (e) { /* 파싱 실패면 무시 */ }
    }




    // '체크리스트 확인' 버튼 클릭 → 사용자가 원할 때 언제든 팝업을 다시 볼 수 있게 하기 위함
    // ※ 자동 팝업의 '3일 동안 보지 않기'와는 별개로, 수동 버튼은 항상 팝업을 열어야 해서 force=true를 준다.
    var btnChecklist = document.getElementById("btnDdayChecklistOpen"); // 방금 만든 버튼을 잡는 이유: 클릭 이벤트를 붙이기 위함
    btnChecklist.addEventListener("click", function(){
        loadDdayPopup(ctxPath, true); // force=true → 3일 숨김 상태여도 팝업을 열기 위함
    });
	
    if (!ddayDock.dataset.foldBound) {
        ddayDock.dataset.foldBound = "1";
        ddayDock.addEventListener("click", (e) => {

            // (1) [축소] 1번 위젯의 "아이콘으로 줄이기" 버튼을 처리하기 위함
            const miniBtn = e.target.closest(".ddayMiniBtn");
            if (miniBtn) {

                // ✅ 요구사항: "비행기 아이콘만 남고" 도크 내용이 아이콘 쪽으로 접히는 느낌을 주기 위함
                // - 접히는 기준점(transform-origin)을 "클릭한 비행기 버튼 위치"로 잡는다
                // - 접히는 동안 버튼은 숨기고, 같은 위치에 떠있는 ✈️ 아이콘을 보여서 "변한 것처럼" 보이게 한다
                _collapseDockToMini(ddayDock, miniEl, MINI_KEY, MINI_POS_KEY, miniBtn);
                return; // 축소 버튼 클릭이면 아래 접기 로직은 타지 않게 하기 위함
            }

            // (2) [접기] 2번 위젯(다음여행)만 접기/펼치기 하려는 기존 기능 유지
            const foldBtnEl = e.target.closest(".ddayFoldBtn");
            if (!foldBtnEl) return;

            const card = foldBtnEl.closest(".ddayCard");
            const isFolded = card.classList.toggle("isFolded");
            sessionStorage.setItem(foldKey, isFolded ? "1" : "0");
            foldBtnEl.textContent = isFolded ? "펼치기" : "접기";
        });
    }

   

    ddayDock.querySelectorAll(".ddayCard").forEach(card => {
        const startYmd = card.dataset.start;
        const calHost  = card.querySelector(".ddayCal");
        calHost.innerHTML = _buildWidgetCal(startYmd);
    });

 // (추가) 이전에 아이콘 모드로 접어놨다면, 새로고침/재방문에도 그대로 유지하기 위함
    const isMiniSaved = (localStorage.getItem(MINI_KEY) === "1");
    if (isMiniSaved) {
        ddayDock.classList.add("isMini");  // 도크 숨김
        miniEl.classList.add("isShow");
  _syncMiniDdayLabel(miniEl); // (추가) 접힌 상태가 보일 때 라벨도 함께 갱신
    // 아이콘 표시

        // ✅ 저장된 아이콘 좌표 복원 (새로고침/재방문 후에도 같은 위치)
        try{
          const saved = localStorage.getItem(MINI_POS_KEY);
          if(saved){
            const p = JSON.parse(saved);
            if(p && p.left != null && p.top != null){
              miniEl.style.right  = "auto";
              miniEl.style.bottom = "auto";
              miniEl.style.left   = Number(p.left) + "px";
              miniEl.style.top    = Number(p.top)  + "px";
            }
          }
        }catch(e){}
    } else {
        ddayDock.classList.remove("isMini");
        miniEl.classList.remove("isShow");
    }

    
    ddayDock.style.display = "flex";
}


//=========================
//(추가) 도크 ↔ 아이콘 모드 전환
//=========================
function _setDdayMiniMode(ddayDock, miniEl, miniKey, on){
  if(on){
    // (추가) 도크를 숨기기 전에 위치 관련 inline 스타일을 초기화해두는 이유:
    // - 아이콘에서 다시 열 때, 아이콘 위치 기준으로 새 좌표를 계산해 정확히 붙이기 위함
    ddayDock.style.left = "";
    ddayDock.style.top = "";
    ddayDock.style.right = "";
    ddayDock.style.bottom = "";
    // (추가) 아이콘에서 열던(popover) 상태를 초기화하는 이유:
    // - 다음에 일반 모드(오른쪽 상단 고정)로 돌아갈 때 충돌 방지
    ddayDock.classList.remove("isPopover");
    ddayDock.style.removeProperty("--dock-left");
    ddayDock.style.removeProperty("--dock-top");

 ddayDock.classList.add("isMini");  // 도크를 숨겨서 컨텐츠 가림을 방지하기 위함
 miniEl.classList.add("isShow");    // 대신 조그만 아이콘을 보여주기 위함
 localStorage.setItem(miniKey, "1"); // 다음 방문에도 아이콘 모드를 유지하기 위함
}else{
 ddayDock.classList.remove("isMini");
    // (추가) 아이콘에서 열던 위치정보를 제거해서 기본 위치(오른쪽 상단)로 복귀하기 위함
    ddayDock.classList.remove("isPopover");
    ddayDock.style.removeProperty("--dock-left");
    ddayDock.style.removeProperty("--dock-top");
 // 다시 도크를 보여주기 위함
 miniEl.classList.remove("isShow");   // 아이콘은 숨김
 localStorage.setItem(miniKey, "0");  // 기본 모드로 복귀했다는 상태 저장
}
}


// =========================
// (추가) 도크를 "비행기 아이콘"으로 접기 (내용이 아이콘 쪽으로 접히는 느낌)
// =========================
// =========================
// (추가) 도크를 "비행기 아이콘"으로 접기 (내용이 아이콘 쪽으로 접히는 느낌)
// =========================
function _collapseDockToMini(ddayDock, miniEl, miniKey, posKey, anchorEl){

  if(!ddayDock || !miniEl) return;
  if(ddayDock.classList.contains("isMini")) return;
  if(ddayDock.dataset.animating === "1") return;

  const iconW = 60; // 아이콘 박스 가로(픽셀)
  const iconH = 60; // 아이콘 박스 세로(픽셀)
  const pad   = 8;  // 화면 밖으로 나가지 않게 여백

  // ✅ 핵심: "접는 순간의 버튼 위치"를 기준으로 아이콘을 배치해 제자리에서 접히는 느낌을 만든다.
  // - 저장 좌표는 보조적으로만 사용(버튼 좌표가 없을 때)
  let left, top;

  if (anchorEl) {
    const br = anchorEl.getBoundingClientRect();
    left = br.left + (br.width  / 2) - (iconW / 2);
    top  = br.top  + (br.height / 2) - (iconH / 2);
  } else {
    const saved = (posKey ? localStorage.getItem(posKey) : null);
    if (saved) {
      try {
        const p = JSON.parse(saved);
        left = Number(p.left);
        top  = Number(p.top);
      } catch(e) {}
    }
  }

  if (typeof left !== "number" || typeof top !== "number" || isNaN(left) || isNaN(top)) {
    const br = ddayDock.getBoundingClientRect();
    left = br.left + (br.width  / 2) - (iconW / 2);
    top  = br.top  + (br.height / 2) - (iconH / 2);
  }

  // 화면 밖으로 나가지 않게 clamp
  left = Math.max(pad, Math.min(left, window.innerWidth  - iconW - pad));
  top  = Math.max(pad, Math.min(top,  window.innerHeight - iconH - pad));

  // 아이콘 좌표는 항상 최신으로 저장해 "접기/펼치기 시 위치 점프"를 방지
  if (posKey) {
    localStorage.setItem(posKey, JSON.stringify({ left: Math.round(left), top: Math.round(top) }));
  }

  // (1) 아이콘 위치 적용 + 표시
  miniEl.style.right  = "auto";
  miniEl.style.bottom = "auto";
  miniEl.style.left   = Math.round(left) + "px";
  miniEl.style.top    = Math.round(top)  + "px";
  miniEl.classList.add("isShow");
  localStorage.setItem(miniKey, "1");

  // (2) 도크가 "아이콘 쪽으로 접히는" 느낌을 주기 위해 transform-origin을 아이콘 중심으로 잡는다.
  const dr = ddayDock.getBoundingClientRect();
  const cx = left + (iconW / 2);
  const cy = top  + (iconH / 2);
  const ox = ((cx - dr.left) / dr.width)  * 100;
  const oy = ((cy - dr.top)  / dr.height) * 100;
  ddayDock.style.transformOrigin = ox + "% " + oy + "%";

  // (3) 접힘 애니메이션 → 끝나면 도크 숨김(isMini)
  ddayDock.dataset.animating = "1";
  ddayDock.classList.add("isMiniing");    // 접히는 동안 버튼 숨김(중복 아이콘 방지)
  ddayDock.classList.add("isCollapsing"); // 접힘 효과

  if (ddayDock._collapseTimer) clearTimeout(ddayDock._collapseTimer);
  ddayDock._collapseTimer = setTimeout(() => {
    ddayDock.classList.add("isMini");
    ddayDock.classList.remove("isCollapsing");
    ddayDock.classList.remove("isMiniing");
    ddayDock.dataset.animating = "0";
  }, 160);
}

// =========================
// (추가) 아이콘 클릭 시 도크를 "우측 기본 위치"로 다시 펼치기
// =========================
function _expandDockFromMini(ddayDock, miniEl, miniKey){

  if(!ddayDock || !miniEl) return;

  // (1) 도크를 다시 보이게 하기 위함 (우측 기본 위치로)
  ddayDock.classList.remove("isMini");
  ddayDock.classList.remove("isCollapsing");
  ddayDock.classList.remove("isMiniing");

  // 혹시 inline display가 none으로 남아있으면 강제로 복구 (숨김 상태에서 복귀가 안 되는 경우 방지)
  ddayDock.style.display = "flex";

  // (2) 아이콘은 숨김 처리하기 위함
  miniEl.classList.remove("isShow");
  localStorage.setItem(miniKey, "0");

  // (3) 도크는 기본 위치에서 펼쳐져야 하므로 origin을 원래대로 복구
  ddayDock.style.transformOrigin = "top right";

  // (4) 빠르게 펼쳐지는 느낌을 주기 위함
  ddayDock.classList.add("isOpening");
  window.setTimeout(() => {
    ddayDock.classList.remove("isOpening");
  }, 220);
}


//=========================
//(추가) 아이콘 드래그 + 클릭(복원)
//- 아이콘을 원하는 위치로 옮길 수 있게 하기 위함
//- 클릭하면 도크를 다시 열 수 있게 하기 위함
//=========================

// =========================
// (추가) 아이콘 위치에서 도크를 다시 열기 + 빠른 펼침 애니메이션
// =========================
function _openDdayDockFromMini(ddayDock, miniEl, miniKey, posKey){

  if(!ddayDock || !miniEl) return;
  if(ddayDock._collapseTimer) {
    clearTimeout(ddayDock._collapseTimer);
    ddayDock._collapseTimer = null;
  }
  ddayDock.dataset.animating = "0";

  // ✅ 핵심: 아이콘 좌표는 "숨기기 전에" 먼저 읽어야 좌표가 (0,0)으로 깨지지 않는다.
  const iconRect = miniEl.getBoundingClientRect();
  const iconCx = iconRect.left + (iconRect.width / 2);
  const iconCy = iconRect.top  + (iconRect.height / 2);

  // (1) 도크를 다시 보이게 하기 위함
  ddayDock.classList.remove("isMini");
  ddayDock.classList.remove("isCollapsing");
  ddayDock.classList.remove("isMiniing");
  ddayDock.style.display = "flex";

  // (2) 아이콘은 숨김 처리하기 위함
  miniEl.classList.remove("isShow");
  localStorage.setItem(miniKey, "0");

  // (3) 도크가 보이는 상태에서 크기(폭/높이) 측정
  const dockRect = ddayDock.getBoundingClientRect();
  const dockW = ddayDock.offsetWidth || dockRect.width;
  const dockH = ddayDock.offsetHeight || dockRect.height;
  const scaleX = dockRect.width  / dockW || 1;
  const scaleY = dockRect.height / dockH || 1;
  const pad = 8;  // 화면 가장자리 안전 여백

  // (4) "미니 아이콘 위치"와 "도크의 비행기 버튼"이 정확히 겹치도록 정렬
  const miniBtn = ddayDock.querySelector(".ddayMiniBtn");
  let left, top, originX = "50%", originY = "50%";

  if (miniBtn) {
    const btnRect = miniBtn.getBoundingClientRect();
    const btnCx = btnRect.left + (btnRect.width / 2);
    const btnCy = btnRect.top  + (btnRect.height / 2);

    // ✅ 스케일을 제거한 "도크 내부 좌표"로 환산
    const dx = (btnCx - dockRect.left) / scaleX;
    const dy = (btnCy - dockRect.top)  / scaleY;

    // transform-origin은 버튼 중심으로 고정
    originX = (dx / dockW) * 100 + "%";
    originY = (dy / dockH) * 100 + "%";

    // ✅ 제자리 정렬: iconCenter = left/top + (버튼 중심 좌표)
    left = iconCx - dx;
    top  = iconCy - dy;
  } else {
    // 버튼을 못 찾으면 아이콘 중심에 도크 중심을 맞춤
    left = iconCx - (dockW / 2);
    top  = iconCy - (dockH / 2);
  }

  // (5) 화면 밖으로 나가지 않게 clamp (가까운 위치 유지)
  const maxLeft = window.innerWidth  - dockRect.width  - pad;
  const maxTop  = window.innerHeight - dockRect.height - pad;

  left = Math.max(pad, Math.min(left, maxLeft));
  top  = Math.max(pad, Math.min(top,  maxTop));

  // (6) popover 모드로 전환 + 좌표 세팅
  ddayDock.classList.add("isPopover");
  ddayDock.style.setProperty("--dock-left", left + "px");
  ddayDock.style.setProperty("--dock-top",  top  + "px");
  ddayDock.style.right = "auto";
  ddayDock.style.bottom = "auto";
  ddayDock.style.left = left + "px";
  ddayDock.style.top  = top  + "px";

  // (7) 펼침 방향에 맞춘 transform-origin (버튼 중심)
  ddayDock.style.transformOrigin = originX + " " + originY;

  // (8) 빠른 펼침 애니메이션 트리거
  ddayDock.classList.remove("isOpening");
  void ddayDock.offsetWidth;
  ddayDock.classList.add("isOpening");
  setTimeout(() => ddayDock.classList.remove("isOpening"), 220);

  // (9) (선택) 현재 도크 좌표 저장 → 새로고침해도 펼친 위치 유지
  try{
    localStorage.setItem("TCT_DDAY_DOCK_POS", JSON.stringify({ left: Math.round(left), top: Math.round(top) }));
  }catch(e){}
}


// ========================================================
// (추가) 접힌 아이콘 아래 D-day 라벨 동기화
// - 서버에서 받아온 "가장 가까운 여행"의 D-day 문자열을 miniEl.dataset.ddayText에 저장해두고
// - 아이콘 모드에서 라벨(#ddayMiniLabel)에 그 값을 그대로 출력하기 위함
// ========================================================
function _syncMiniDdayLabel(miniEl){
  const lab = document.getElementById("ddayMiniLabel");  // 아이콘 아래 라벨 span
  if(!miniEl || !lab) return;

  const txt = (miniEl.dataset.ddayText || "").trim();    // 저장해둔 D-day 문자열
  lab.textContent = txt;

  // 텍스트가 있으면 보이게 / 없으면 숨김
  lab.style.display = txt ? "inline-flex" : "none";
}

function _bindDdayMiniIcon(miniEl, ddayDock, miniKey, posKey){
if(!miniEl) return;                     // 아이콘 DOM이 없으면 바인딩 자체가 불가능
if(miniEl.dataset.bound === "1") return; // include 구조에서 중복 바인딩 방지
miniEl.dataset.bound = "1";

// (1) 저장된 좌표가 있으면 복원하기 위함
const saved = localStorage.getItem(posKey);
if(saved){
 const p = JSON.parse(saved);
 miniEl.style.left = p.left + "px";    // 좌표 기반 배치로 전환
 miniEl.style.top  = p.top + "px";
 miniEl.style.right = "auto";          // right/bottom 기본값 무효화
 miniEl.style.bottom = "auto";
}

let downX = 0, downY = 0;               // 포인터 눌렀을 때 좌표(드래그 시작점)
let startLeft = 0, startTop = 0;        // 아이콘의 시작 위치
let moved = false;                      // 클릭인지(안움직임) / 드래그인지(움직임) 구분하기 위함

miniEl.addEventListener("pointerdown", (e) => {
 moved = false;                        // 새 드래그 시도 시작
 const r = miniEl.getBoundingClientRect();
 downX = e.clientX;                    // 포인터 시작 좌표 저장
 downY = e.clientY;
 startLeft = r.left;                   // 아이콘 시작 좌표 저장
 startTop  = r.top;

 miniEl.setPointerCapture(e.pointerId); // 포인터를 아이콘이 계속 추적하게 하기 위함
});

miniEl.addEventListener("pointermove", (e) => {
 if(!miniEl.hasPointerCapture(e.pointerId)) return;

 const dx = e.clientX - downX;         // 시작점 대비 이동량
 const dy = e.clientY - downY;

 if(Math.abs(dx) + Math.abs(dy) > 4) moved = true; // 조금이라도 움직이면 드래그로 판단

 // (2) 화면 밖으로 나가지 않게 최소/최대 범위로 자르기 위함
 const maxLeft = window.innerWidth  - miniEl.offsetWidth;
 const maxTop  = window.innerHeight - miniEl.offsetHeight;

 const nextLeft = Math.max(0, Math.min(startLeft + dx, maxLeft));
 const nextTop  = Math.max(0, Math.min(startTop  + dy, maxTop));

 miniEl.style.left = nextLeft + "px";  // 실제 위치 이동
 miniEl.style.top  = nextTop  + "px";
 miniEl.style.right = "auto";          // right/bottom 기반 배치 해제
 miniEl.style.bottom = "auto";
});

miniEl.addEventListener("pointerup", (e) => {
 if(!miniEl.hasPointerCapture(e.pointerId)) return;
 miniEl.releasePointerCapture(e.pointerId);

 if(moved){
   // (3) 드래그로 옮겼으면 좌표 저장 → 다음에도 같은 위치에 보이게 하기 위함
   localStorage.setItem(posKey, JSON.stringify({
     left: parseInt(miniEl.style.left, 10),
     top : parseInt(miniEl.style.top,  10)
   }));
 }else{
   // (4) 안 움직였으면 "클릭"으로 간주 → 아이콘 위치에서 도크가 다시 뜨게 하기 위함
      _openDdayDockFromMini(ddayDock, miniEl, miniKey, posKey);
    }

});
}






// ========================================================
// (추가) 도크 좌표 고정(left/top) 적용
// - right/top 고정 대신 left/top로 "현재 위치"를 유지하기 위함
// ========================================================
function _applyDockPos(ddayDock, left, top){

  // 아이콘 기준 popover 모드로 전환(= left/top 사용)
  ddayDock.classList.add("isPopover");

  ddayDock.style.right = "auto";
  ddayDock.style.bottom = "auto";
  ddayDock.style.left = left + "px";
  ddayDock.style.top  = top  + "px";

  // CSS 변수도 같이 유지(기존 .ddayDock.isPopover 규칙이 변수를 참조)
  ddayDock.style.setProperty("--dock-left", left + "px");
  ddayDock.style.setProperty("--dock-top",  top  + "px");
}


// ========================================================
// (추가) 펼친 도크 드래그 이동 바인딩
// - 도크 전체를 드래그하면 클릭이 오작동하므로 "핸들"만 드래그 가능하게 한다
// ========================================================
function _bindDockDrag(ddayDock, handleEl, dockPosKey, miniPosKey){

  if (!ddayDock || !handleEl) return;

  // 중복 바인딩 방지
  if (handleEl.dataset.bound === "1") return;
  handleEl.dataset.bound = "1";

  let isDown = false;
  let startX = 0, startY = 0;
  let baseLeft = 0, baseTop = 0;

  handleEl.addEventListener("pointerdown", function(e){
    isDown = true;

    // ✅ 드래그하면 "좌표 기반(popover)" 모드로 고정해 두는 게 안정적
    ddayDock.classList.add("isPopover");

    const r = ddayDock.getBoundingClientRect();
    baseLeft = r.left;
    baseTop  = r.top;

    startX = e.clientX;
    startY = e.clientY;

    handleEl.setPointerCapture(e.pointerId);
  });

  handleEl.addEventListener("pointermove", function(e){
    if (!isDown) return;

    const dx = e.clientX - startX;
    const dy = e.clientY - startY;

    const dockW = ddayDock.offsetWidth;
    const dockH = ddayDock.offsetHeight;

    const pad = 8;
    const maxLeft = window.innerWidth  - dockW - pad;
    const maxTop  = window.innerHeight - dockH - pad;

    let nextLeft = baseLeft + dx;
    let nextTop  = baseTop  + dy;

    nextLeft = Math.max(pad, Math.min(nextLeft, maxLeft));
    nextTop  = Math.max(pad, Math.min(nextTop,  maxTop));

    // 좌표 기반 배치
    ddayDock.style.right  = "auto";
    ddayDock.style.bottom = "auto";
    ddayDock.style.left   = nextLeft + "px";
    ddayDock.style.top    = nextTop  + "px";
    ddayDock.style.setProperty("--dock-left", nextLeft + "px");
    ddayDock.style.setProperty("--dock-top",  nextTop  + "px");
  });

  handleEl.addEventListener("pointerup", function(e){
    if (!isDown) return;
    isDown = false;

    if (handleEl.hasPointerCapture(e.pointerId)) {
      handleEl.releasePointerCapture(e.pointerId);
    }

    // (1) 펼친 도크 좌표 저장 (새로고침/재방문 시 복원용)
    try{
      localStorage.setItem(dockPosKey, JSON.stringify({
        left: Math.round(parseFloat(ddayDock.style.left || "0")),
        top : Math.round(parseFloat(ddayDock.style.top  || "0"))
      }));
    }catch(err){}

    // (2) ✅ "접은 아이콘"도 현재 도크 위치를 따라오게(드래그 후 접었을 때 아이콘이 엉뚱한 곳에 뜨지 않게)
    // - 도크 안의 비행기 버튼(축소 버튼) 위치를 기준으로 아이콘 좌표를 업데이트한다.
    try{
      const miniBtn = ddayDock.querySelector(".ddayMiniBtn");
      if (miniBtn && miniPosKey) {
        const br = miniBtn.getBoundingClientRect();
        const iconW = 60, iconH = 60, pad = 8;

        let left = br.left + (br.width / 2) - (iconW / 2);
        let top  = br.top  + (br.height / 2) - (iconH / 2);

        left = Math.max(pad, Math.min(left, window.innerWidth  - iconW - pad));
        top  = Math.max(pad, Math.min(top,  window.innerHeight - iconH - pad));

        localStorage.setItem(miniPosKey, JSON.stringify({ left: Math.round(left), top: Math.round(top) }));
      }
    }catch(err){}
  });

}


function _buildWidgetCal(startYmd){
    var parts = String(startYmd).split("-");
    var y = parseInt(parts[0], 10);
    var m = parseInt(parts[1], 10);
    var d = parseInt(parts[2], 10);

    var startDate = new Date(y, m - 1, d);
    var today = new Date(); today.setHours(0,0,0,0);               

    var year  = startDate.getFullYear();   
    var month = startDate.getMonth();      

    var firstDay    = new Date(year, month, 1).getDay();       
    var daysInMonth = new Date(year, month + 1, 0).getDate();  
    var prevLast    = new Date(year, month, 0).getDate();      

    var head = year + "년 " + (month + 1) + "월";
    var dowArr = ["일","월","화","수","목","금","토"];
    var dow = "";
    for (var i=0; i<7; i++) dow += "<span>" + dowArr[i] + "</span>";

    var cells = "";
    for (var k=0; k<42; k++){
        var dateNum = k - firstDay + 1;
        var cellYear = year, cellMonth = month, cellDay = dateNum;
        var isOther = false;

        if (dateNum <= 0) { 
            isOther = true; cellMonth = month - 1; cellDay = prevLast + dateNum;
        } else if (dateNum > daysInMonth) { 
            isOther = true; cellMonth = month + 1; cellDay = dateNum - daysInMonth;
        }

        var cellDate = new Date(cellYear, cellMonth, cellDay);
        cellDate.setHours(0,0,0,0);
        
        var isPast = (cellDate < today);

        // (추가) 오늘 날짜 셀을 시각적으로 강조하기 위함(밑줄)
        var isToday = (cellDate.getTime() === today.getTime()); 
        var isStart = (
            cellDate.getFullYear() === startDate.getFullYear() &&
            cellDate.getMonth()    === startDate.getMonth() &&
            cellDate.getDate()     === startDate.getDate()
        ); 

        var cls = "dCell";               
        if (isOther) cls += " isOther";  
        if (isPast)  cls += " isPast";
        if (isToday) cls += " isToday";   
        if (isStart) cls += " isStart";  

        cells += '<span class="' + cls + '">' + cellDay + "</span>";
    }

    return '<div class="ddayCalHead">' + head + "</div>"
         + '<div class="ddayDow">' + dow + "</div>"
         + '<div class="ddayGrid">' + cells + "</div>";
}


/* 출발임박 체크리스트 팝업 */

var DDAY_POP_KEY_PREFIX = "TCT_DDAY_POP_DEFAULT_";
var DDAY_POP_HIDE_KEY = "TCT_DDAY_POP_HIDE_3D_DEFAULT";
var TCT_SESSION_ID = "<%= session.getId() %>";
var DDAY_POP_SESSION_HIDE_KEY = "TCT_DDAY_POP_HIDE_SESSION_DEFAULT";

var TCT_COOKIE_PATH = (typeof CTX !== "undefined" && CTX) ? CTX : "/tryCatchTrip";

function getCookie(name){
  var cookies = document.cookie.split("; ");

  for (var i = 0; i < cookies.length; i++){
    var kv = cookies[i].split("=");
    if (kv[0] === name) {
      return decodeURIComponent(kv[1] || "");
    }
  }

  return "";
}

function setCookie(name, value, maxAgeSeconds){
  document.cookie = name + "=" + encodeURIComponent(value)
    + "; Max-Age=" + maxAgeSeconds
    + "; Path=" + TCT_COOKIE_PATH
    + "; SameSite=Lax";
}

function _fmtMoney(n){
  return String(n).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function _fmtDday(n){
  n = Number(n);
  if (n === 0) return "D-DAY";
  if (n > 0)   return "D-" + n;
  return "D+" + Math.abs(n);
}

function ddayLoadChecklist(){
  var boxes = document.querySelectorAll("#ddayPopupModal .ddayP-item input[type='checkbox']");

  boxes.forEach(function(box){
    var id = box.getAttribute("data-id");
    var saved = localStorage.getItem(DDAY_POP_KEY_PREFIX + id);
    box.checked = (saved === "true");
  });
}

function ddayOpenModal(){
  var modal = document.getElementById("ddayPopupModal");
  var btn = document.getElementById("btnDdayChecklistOpen");
  
  modal.style.display = "flex";
  ddayLoadChecklist();

  if (btn) btn.classList.add("active");
}

function ddayCloseModal(){
  var modal = document.getElementById("ddayPopupModal");
  var btn = document.getElementById("btnDdayChecklistOpen");

  modal.style.display = "none";

  if (btn) btn.classList.remove("active");
}

function ddayConfirmClose(){
  try {
    if (typeof DDAY_POP_SESSION_HIDE_KEY !== "undefined" && DDAY_POP_SESSION_HIDE_KEY) {
      sessionStorage.setItem(DDAY_POP_SESSION_HIDE_KEY, "1");
    }
  } catch(e) {}

  ddayCloseModal();
}

function ddayBindPopupOnce(){
  var modal = document.getElementById("ddayPopupModal");
  if (modal.dataset.bound === "1") return;

  modal.dataset.bound = "1";

  var btnClose = document.getElementById("btnDdayPopupClose");
  btnClose.addEventListener("click", ddayConfirmClose);

  var btnHide3d = document.getElementById("btnDdayPopupHide3d");
  btnHide3d.addEventListener("click", function(){
    var threeDaysSec = 3 * 24 * 60 * 60;
    setCookie(DDAY_POP_HIDE_KEY, "1", threeDaysSec);

    try {
      if (DDAY_POP_SESSION_HIDE_KEY) {
        sessionStorage.setItem(DDAY_POP_SESSION_HIDE_KEY, "1");
      }
    } catch(e) {}

    ddayCloseModal();
  });

  modal.addEventListener("click", function(e){
    if (e.target === modal) ddayCloseModal();
  });

  var boxes = document.querySelectorAll("#ddayPopupModal .ddayP-item input[type='checkbox']");
  boxes.forEach(function(box){
    box.addEventListener("change", function(e){
      var id = e.target.getAttribute("data-id");
      localStorage.setItem(DDAY_POP_KEY_PREFIX + id, e.target.checked);
    });
  });
}

async function loadDdayPopup(ctxPath, force){
  var url = ctxPath + "/ddayPopup.do" + (force ? "?manual=1" : "");

  ddayBindPopupOnce();

  var res = await fetch(url, { method: "GET" });
  var json = await res.json();

  if (!json.ok) return;
  if (!json.data) return;

  var it = json.data;

  // 같은 브라우저에서 다른 계정의 팝업 숨김 상태가 섞이지 않게 분리한다.
  DDAY_POP_HIDE_KEY = "TCT_DDAY_POP_HIDE_3D_" + it.userId;
  DDAY_POP_SESSION_HIDE_KEY = "TCT_DDAY_POP_HIDE_SESSION_" + it.userId + "_" + TCT_SESSION_ID;

  var sessHidden = sessionStorage.getItem(DDAY_POP_SESSION_HIDE_KEY);
  if (!force && sessHidden === "1") return;

  // D-1, D-DAY는 3일 숨김 상태여도 자동 팝업을 다시 보여준다.
  var hidden = getCookie(DDAY_POP_HIDE_KEY);
  if (!force && hidden === "1" && Number(it.dday) >= 2) return;

  // 체크리스트 체크 상태는 주문 단위로 저장한다.
  DDAY_POP_KEY_PREFIX = "TCT_DDAY_POP_" + it.orderNo + "_";

  var hotelText = "-";
  if (it.hotelName) {
    if (Number(it.hotelCnt) > 1) hotelText = it.hotelName + " 외 " + (Number(it.hotelCnt) - 1) + "곳";
    else hotelText = it.hotelName;
    if (it.hotelTel) hotelText += " (" + it.hotelTel + ")";
  }

  var prodHref = ctxPath + "/regProdDetail.do?regId=" + encodeURIComponent(it.regId);
  var prodTitle = it.regTitle + " (#" + it.regId + ")";

  document.getElementById("ddayP_badge").textContent = _fmtDday(it.dday);
  document.getElementById("ddayP_prod").innerHTML = '<a class="ddayP-prodLink" href="' + prodHref + '">' + prodTitle + "</a>";
  document.getElementById("ddayP_orderNo").textContent = it.orderNo;
  document.getElementById("ddayP_period").textContent = it.startYmd + " ~ " + it.endYmd;
  document.getElementById("ddayP_totalPrice").textContent = _fmtMoney(it.totalPrice) + "원";
  document.getElementById("ddayP_hotel").textContent = hotelText;

  ddayOpenModal();
}

</script>
