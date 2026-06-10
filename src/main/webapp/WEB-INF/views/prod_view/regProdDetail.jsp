<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>TryCatchTrip - 상품 상세</title>

<link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.8/dist/web/static/pretendard.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

<style>
/* 1. 폰트 및 변수 정의 */
:root {
    --font-system: system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    --font-toss: "Pretendard Variable", Pretendard, -apple-system, BlinkMacSystemFont, system-ui, Roboto, sans-serif;

    --max: 1200px;
    --padX: 16px;
    --gap: 30px;
    --r: 16px;
    --bg: #f2f4f6;
    --card: #ffffff;
    --ink: #191f28;
    --muted: #8b95a1;
    --line: #e5e8eb;
    --primary: #3182f6; 
    --primarySoft: rgba(49, 130, 246, 0.1);
    --shadow2: 0 8px 30px rgba(0, 0, 0, 0.05);
}

* { box-sizing: border-box; outline: none; }

/* 2. Body 설정 */
body {
    margin: 0;
    font-family: var(--font-system);
    color: var(--ink);
    background: var(--bg);
}

/* 3. 본문 및 모달 폰트 설정 */
main, .payModal {
    font-family: var(--font-toss);
}

a { color: inherit; text-decoration: none; }

/* ===== 레이아웃 공통 ===== */
.container { max-width: var(--max); margin: 0 auto; padding: 0 var(--padX); }
.crumbs { padding: 24px 0 12px; color: var(--muted); font-size: 13px; font-weight: 500; }
.crumbs .sep { margin: 0 8px; opacity: .4; }

/* Grid 레이아웃 */
.grid { display: grid; grid-template-columns: 1fr 360px; gap: var(--gap); padding: 0 0 60px; align-items: start; }
@media (max-width: 900px) { .grid { grid-template-columns: 1fr; } }

.card {
    background: var(--card);
    border: 1px solid transparent; 
    border-radius: var(--r);
    box-shadow: var(--shadow2);
    overflow: hidden;
}

/* ===== 상단 상품 요약 ===== */
.summary { padding: 24px; }
.summaryTop { display: flex; justify-content: space-between; align-items: center; gap: 10px; padding-bottom: 16px; border-bottom: 1px solid var(--line); }
.summaryTop .tabs { display: flex; gap: 8px; flex-wrap: wrap; }

.pill { border: 1px solid var(--line); background: #fff; border-radius: 6px; padding: 6px 12px; font-size: 13px; cursor: pointer; transition: all 0.2s; color: var(--muted); font-weight: 600; }
.pill:hover { background: #f9fafb; }
.pill.primary { border-color: transparent; background: var(--primarySoft); color: var(--primary); font-weight: 700; }

.summaryBody { display: grid; grid-template-columns: 380px 1fr; gap: 30px; padding-top: 24px; }
@media (max-width: 860px) { .summaryBody { grid-template-columns: 1fr; } }

.thumb { width: 100%; aspect-ratio: 4/3; border-radius: 12px; overflow: hidden; background: #eee; position: relative; }
.thumb img { width: 100%; height: 100%; object-fit: cover; display: block; }

.badge { 
    display: inline-block; 
    padding: 5px 10px; 
    border-radius: 6px; 
    background: #fff9c4; 
    border: 1px solid #fff59d;
    font-size: 12px; 
    font-weight: 700; 
    color: #856404;
    margin-right: 6px; 
    margin-bottom: 6px; 
}

.h1 { margin: 10px 0 12px; font-size: 26px; font-weight: 800; line-height: 1.35; color: #191f28; word-break: keep-all; }
.metaLine { color: var(--muted); font-size: 14px; line-height: 1.6; margin-bottom: 24px; }

.kv { margin-top: 10px; display: flex; flex-direction: column; gap: 12px; border-top: 2px solid var(--ink); padding-top: 16px; }
.kvRow { display: flex; align-items: baseline; font-size: 15px; }
.kvRow b { width: 80px; color: #333; font-weight: 700; flex-shrink: 0; position: relative; }
.kvRow span { color: #555; font-weight: 500; line-height: 1.5; }

/* ===== 우측 사이드바 ===== */
.side { position: sticky; top: 100px; }
@media (max-width: 980px) { .side { position: relative; top: 0; } }

.sideBox { padding: 24px; }
.sideTitle { font-weight: 800; margin: 0 0 16px; font-size: 18px; }

.qtyRow { display: flex; align-items: center; justify-content: space-between; gap: 10px; padding: 16px 0; border-bottom: 1px dashed var(--line); }
.qtyLabel { display: flex; flex-direction: column; gap: 2px; }
.qtyLabel b { font-size: 15px; }
.qtyLabel .sub { font-size: 13px; color: var(--muted); }

.stepper { display: inline-flex; align-items: center; gap: 0; border: 1px solid var(--line); border-radius: 8px; overflow: hidden; }
.btnStep { width: 32px; height: 32px; background: #fff; cursor: pointer; font-weight: 600; color: #555; display: flex; align-items: center; justify-content: center; border:none; }
.btnStep:hover { background: #f2f2f2; }
.num { width: 40px; height: 32px; text-align: center; border: none; border-left: 1px solid var(--line); border-right: 1px solid var(--line); font-size: 14px; font-weight: 700; color: var(--ink); -moz-appearance: textfield; }
.num::-webkit-outer-spin-button, .num::-webkit-inner-spin-button { -webkit-appearance: none; margin: 0; }

.total { padding-top: 20px; margin-top: 0; display: flex; justify-content: space-between; align-items: center; }
.total .amt { font-size: 24px; font-weight: 800; color: var(--primary); }

.paymentBtn { margin-top: 20px; width: 100%; padding: 16px; border-radius: 12px; border: 0; background: var(--primary); color: #fff; font-weight: 700; font-size: 16px; cursor: pointer; transition: background 0.2s; box-shadow: 0 4px 10px rgba(49, 130, 246, 0.3); }
.paymentBtn:hover { background: #1b64da; }

.note { margin-top: 12px; color: var(--muted); font-size: 12px; line-height: 1.5; text-align: center; }

.benefit { margin-top: 16px; padding: 16px; border-radius: 12px; background: #f9fafb; border: 1px solid var(--line); }
.benefit b { font-size: 13px; display: block; margin-bottom: 8px; }
.benefit ul { margin: 0; padding-left: 18px; color: var(--muted); font-size: 13px; line-height: 1.6; }
.benefit a { display: block; margin-top: 10px; text-align: center; padding: 10px; border-radius: 8px; background: #fff; border: 1px solid var(--line); color: var(--primary); font-size: 12px; font-weight: 700; transition: all 0.2s; }
.benefit a:hover { border-color: var(--primary); background: var(--primarySoft); }

/* ===== 하단 탭 영역 ===== */
.section { margin-top: 24px; }
.secTabs { display: flex; gap: 8px; padding: 16px 24px; border-bottom: 1px solid var(--line); overflow-x: auto; }
.secTab { padding: 8px 16px; border-radius: 20px; border: 1px solid transparent; background: transparent; color: var(--muted); font-weight: 700; font-size: 15px; cursor: pointer; flex-shrink: 0; transition: all 0.2s; }
.secTab:hover { background: rgba(0,0,0,0.03); color: var(--ink); }
.secTab.active { background: #191f28; color: #fff; border-color: #191f28; }

.secBody { padding: 24px; }

.tabPane { display: none; }
.tabPane.active { display: block !important; animation: fadeIn 0.3s ease; }
@keyframes fadeIn { from { opacity: 0; transform: translateY(5px); } to { opacity: 1; transform: translateY(0); } }

.dayList { display: flex; flex-direction: column; gap: 12px; }
.dayItem { border: 1px solid var(--line); border-radius: 16px; background: #fff; padding: 16px; display: flex; align-items: center; justify-content: space-between; gap: 12px; transition: box-shadow 0.2s; }
.dayItem:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.04); }

.dayBadge { width: 50px; height: 50px; display: flex; align-items: center; justify-content: center; border-radius: 14px; background: #f2f4f6; color: var(--ink); font-weight: 800; font-size: 13px; flex-shrink: 0; }
.dayText { display: flex; flex-direction: column; gap: 4px; }
.dayText b { font-size: 15px; }
.dayText span { font-size: 13px; color: var(--muted); }

/* 가격표 스타일 */
.priceTable { width: 100%; border-collapse: separate; border-spacing: 0; border: 1px solid var(--line); border-radius: 12px; overflow: hidden; }
.priceTable th { background: #f9fafb; font-weight: 700; color: var(--ink); padding: 12px; border-bottom: 1px solid var(--line); font-size: 13px; }
.priceTable td { padding: 14px; font-size: 14px; border-bottom: 1px solid var(--line); text-align: center; color: var(--muted); }
.priceTable tr:last-child td { border-bottom: none; }
.priceTable td b { color: var(--ink); font-weight: 700; }

/* ===== 버튼류 호버 디자인 ===== */
.btn-wish-list, .btn-cart-detail {
    height: 40px; padding: 0 16px; border-radius: 8px; 
    border: 1px solid var(--line); background: #fff;
    display: inline-flex; align-items: center; gap: 6px; cursor: pointer;
    font-size: 13px; font-weight: 700; color: #555; 
    transition: all 0.2s ease;
}

.btn-wish-list:hover { border-color: #ff4d4f; color: #ff4d4f; background-color: #fff1f0; }
.btn-wish-list.on { background-color: #ff4d4f; border-color: #ff4d4f; color: #fff; }

.btn-cart-detail:hover { border-color: var(--primary); color: var(--primary); background-color: #e8f3ff; }
.btn-cart-detail.inCart { background-color: var(--primary); border-color: var(--primary); color: #fff; }

/* ===== [수정됨] 모달 스타일 (Flex 깨짐 방지 코드 추가) ===== */
.payModalBackdrop { 
    position: fixed; inset: 0; 
    background: rgba(0,0,0,0.5); 
    backdrop-filter: blur(4px); 
    z-index: 9999; /* 헤더보다 위로 */
    
    display: none; /* 기본 숨김 */
    align-items: center; 
    justify-content: center; 
}

/* ★ 중요: JS가 style="display: block"을 강제로 넣어도 Flex 유지 */
.payModalBackdrop[style*="display: block"],
.payModalBackdrop[style*="display:block"] {
    display: flex !important;
}

.payModal { 
    width: min(400px, calc(100% - 32px)); /* 모바일 대응 */
    background: #fff; 
    border-radius: 24px; 
    box-shadow: 0 20px 50px rgba(0,0,0,0.2); 
    animation: slideUp 0.3s ease-out; 
    border: none; 
}

@keyframes slideUp { from { transform: translateY(20px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }

.payModalHeader { padding: 24px; border: none; display: flex; justify-content: space-between; align-items: center;}
.payModalHeader b { font-size: 18px; font-weight: 800; }
.payModalClose { width: 32px; height: 32px; background: #f2f4f6; border-radius: 50%; border: none; font-size: 14px; color: var(--ink); cursor: pointer; }

.payModalBody { padding: 0 24px 24px; }
.payOption { display: flex; justify-content: space-between; align-items: center; padding: 16px; border-radius: 16px; border: 1px solid var(--line); margin-bottom: 12px; transition: all 0.2s; cursor: pointer;}
.payOption:hover, .payOption:has(input:checked) { border-color: var(--primary); background: rgba(49, 130, 246, 0.03); }
.payOption .title { font-size: 15px; font-weight: 700; margin-bottom: 2px; }
.payOption .desc { font-size: 13px; color: var(--muted); }

.payModalFooter { padding: 16px 24px; background: #f9fafb; border-top: none; display: flex; gap: 10px; }
.btnGhost { flex: 1; padding: 14px; border-radius: 14px; border: 1px solid var(--line); background:#fff; color: var(--muted); font-weight: 700; cursor: pointer; }
.btnPrimary { flex: 1; padding: 14px; border-radius: 14px; background: var(--primary); color:#fff; font-weight: 700; box-shadow: 0 4px 10px rgba(49, 130, 246, 0.2); border:0; cursor: pointer; }
.payModalHint { margin-top: 8px; font-size: 12px; color: var(--muted); }

/* Notice & Safety */
.noticeTitle { font-size: 16px; font-weight: 800; color: var(--ink); margin: 24px 0 12px; border-left: 4px solid var(--primary); padding-left: 12px; }
.noticeList li { margin-bottom: 6px; position: relative; padding-left: 12px; font-size: 14px; color: #444; line-height: 1.6; }
.noticeList li::before { content: "•"; position: absolute; left: 0; color: var(--muted); }
.noticeText { font-size: 14px; color: #444; line-height: 1.6; }

/* Hero Slider */
.heroSlider { border-radius: 12px; position: relative; width: 100%; height: 100%; overflow: hidden; }
.heroImg { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; opacity: 0; transition: opacity .35s ease; }
.heroImg.active { opacity: 1; }
.heroNav { position: absolute; top: 50%; transform: translateY(-50%); width: 32px; height: 32px; border-radius: 50%; border: 0; background: rgba(255,255,255,0.8); color: #000; cursor: pointer; transition: 0.2s; z-index: 2; }
.heroNav:hover { background: #fff; }
.heroNav.prev { left: 10px; }
.heroNav.next { right: 10px; }

/* 관광지 리스트 */
.spotList { margin-top: 12px; padding-left: 0; list-style: none; display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 16px; }
.spotItem { margin-bottom: 0; }
.spotItem span { font-weight: 700; display: block; margin-bottom: 8px; font-size: 15px; }
.spotThumb { width: 100%; height: 180px; object-fit: cover; border-radius: 12px; border: 1px solid var(--line); }

.dayBody { padding: 10px 0 0; }
.dayDetailList { margin: 0; padding: 0 0 10px 0; list-style: none; }
.dayDetailItem { padding: 6px 0; font-size: 14px; }
.dayItem.open .toggleBtn i { transform: rotate(180deg); transition: transform .2s ease; }
.muted { color: #64748b; font-size: 13px; }

/* =========================
   여행일정(타임라인) - 통교체
   ========================= */

.dayList{
  display:flex;
  flex-direction:column;
  gap:16px;
}

.dayCard{
  border: 1px solid var(--line);
  border-radius: 16px;
  background:#fff;
  padding: 18px 20px;
  display:grid;
  /* 왼쪽(일차/제목) | 가운데(라인) | 오른쪽(📍리스트) */
  grid-template-columns: 260px 34px 1fr;
  align-items:start; /* ✅ 핵심: 가운데/오른쪽을 위에서 시작 */
  gap: 0;
}

.dayLeft{
  display:flex;
  gap:14px;
  align-items:flex-start;
  width: 320px;      /* ✅ 가로 칸 키우기 (원하는 값으로) */
  min-height: 84px;  /* ✅ 세로 칸 키우기 */
  padding: 10px 14px;/* ✅ 안쪽 여백 */
}

.dayBadge{
  min-width: 56px;
  height: 40px;
  border-radius: 12px;
  background:#f1f5f9;
  display:flex;
  align-items:center;
  justify-content:center;
  font-weight:800;
  font-size:14px;
  color:#0f172a;
}

.dayText b{
  display:inline-block;
  font-size:16px;
  font-weight:900;
  color:#0f172a;
  margin-bottom:6px;
  line-height : 1.3;
}
.dayText span{
  display:block;
  font-size:13px;
  color: var(--muted);
}

/* 가운데 세로 라인 영역 */
.dayMid{
  position:relative;
  display:flex;
  justify-content:center;
  align-items:flex-start; /* ✅ 점/라인이 위에서 시작 */
}

/* 카드 안에서 세로 라인 */
.dayMid::before{
  content:"";
  position:absolute;
  top: 8px;
  bottom: 8px;
  width:2px;
  background: rgba(15,23,42,.12);
  left:50%;
  transform:translateX(-50%);
  border-radius: 2px;
}

/* 라인 위의 점(옵션) */
.dayDot{
  margin-top: 6px;
  width:10px;
  height:10px;
  border-radius:50%;
  background: var(--primary);
  box-shadow: 0 0 0 4px var(--primarySoft);
  position:relative;
  z-index:1;
}

/* 오른쪽 📍 리스트 */
.dayRight{
  padding-left: 120px; /* 라인과 간격 */
}

.planList{
  list-style:none;
  margin:0;
  padding:0;
  display:flex;
  flex-direction:column;
  gap:10px;
}

.planList li{
  display:flex;
  gap:10px;
  align-items:flex-start;
  font-size:14px;
  color:#0f172a;
  line-height:1.4;
}

.planList .ico{
  width:18px;
  flex: 0 0 18px;
  margin-top: 2px;
  opacity:.9;
}

.planList .hotel b{
  font-weight:900;
}

/* 반응형: 좁아지면 세로로 쌓기 */
@media (max-width: 900px){
  .dayCard{
    grid-template-columns: 1fr;
    gap: 12px;
  }
  .dayMid{
    display:none; /* 모바일에선 가운데 라인 숨김 */
  }
  .dayRight{
    border-top: 1px dashed rgba(15,23,42,.12);
    padding-top: 12px;
    padding-left: 35px;
  }
}



</style>
</head>

<body>
    <%@ include file="/WEB-INF/views/common/tctHeader.jsp"%>

    <main class="container">
        <div class="crumbs">
            <span>홈</span><span class="sep">›</span> <span>${detail.ctryName}</span><span
                class="sep">›</span> <span>${detail.regTitle}</span>
        </div>

        <c:if test="${empty detail}">
            <div class="card" style="padding: 16px;">
                <b>상품 정보를 찾을 수 없습니다.</b>
            </div>
        </c:if>

        <c:if test="${not empty detail}">
            <section class="grid">

                <div>
                    <div class="card summary">
                        <div class="summaryTop">
                          <div class="tabs">
						    <!-- 의미: 버튼 대신 "상품등록번호"를 사용자에게 보여줌 / 존재이유: 상세 화면에서 현재 상품을 식별하기 쉽게 -->
						    <span class="pill primary" style="cursor: default;">
						      상품등록번호 : ${detail.regId}
						    </span>
						  </div>
                            <div style="display:flex; gap:10px;">
                                <button type="button" class="btn-wish-list" data-id="${detail.regId}">
                                    <span class="heart-icon">♡</span> 관심상품
                                </button>
                                <button type="button" class="btn-cart-detail" data-regid="${detail.regId}" title="장바구니 담기">
                                    🛒 장바구니
                                </button>
                            </div>
                        </div>

                        <div class="summaryBody">
                            <div class="thumb">
                              <c:choose>
                                <c:when test="${not empty imgList}">
                                  <div class="heroSlider" id="heroSlider">
                                    <c:forEach var="img" items="${imgList}" varStatus="st">
                                      <img class="heroImg ${st.first ? 'active' : ''}"
                                           src="${ctx}${img}"
                                           alt="상품 이미지 ${st.index + 1}">
                                    </c:forEach>
                            
                                    <button type="button" class="heroNav prev" aria-label="이전">&#10094;</button>
                                    <button type="button" class="heroNav next" aria-label="다음">&#10095;</button>
                                  </div>
                                </c:when>
                            
                                <c:otherwise>
                                  <img
                                    src="https://images.unsplash.com/photo-1500375592092-40eb2168fd21?auto=format&fit=crop&w=1200&q=80"
                                    alt="대체 이미지">
                                </c:otherwise>
                              </c:choose>
                            </div>

                            <div>
                                <div>
                                    <span class="badge">${detail.pkgId}</span>
                                    <c:if test="${not empty detail.ctryName}">
                                        <span class="badge">${detail.ctryName}</span>
                                    </c:if>
                                    <c:if test="${not empty detail.locName}">
                                        <span class="badge">${detail.locName}</span>
                                    </c:if>
                                </div>

                                <h1 class="h1">${detail.regTitle}</h1>

                                <div class="metaLine">
                                    <b style="color: var(--ink)">대표핵심</b> ·
                                    <c:choose>
                                        <c:when test="${not empty detail.highlight}">${detail.highlight}</c:when>
                                        <c:otherwise>여행 핵심 포인트를 요약해서 제공합니다.</c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="kv">
                                    <div class="kvRow"><b>출발</b><span>${detail.startDt}</span></div>
                                    <div class="kvRow"><b>도착</b><span>${detail.endDt}</span></div>
                                    <div class="kvRow"><b>여행지역</b><span>${detail.ctryName} · ${detail.locName}</span></div>
                                    <div class="kvRow"><b>예약현황</b><span>전체 ${detail.regQty}명 / 예약 ${reservedQty}명 / 잔여 ${remainQty}명 </span></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mainCol">
                        <div class="card section">
                            <div class="secTabs">
                                <button class="secTab active" type="button" data-tab="plan">여행일정</button>
                                <button class="secTab" type="button" data-tab="spot">관광지</button>
                                <button class="secTab" type="button" data-tab="notice">참고사항</button>
                                <button class="secTab" type="button" data-tab="safety">해외 안전정보</button>
                            </div>

                            <div class="secBody">
								<div class="tabPane active" id="tab_plan">
									<div class="dayList">
									
									  <c:forEach var="d" begin="1" end="${dayCount}">
									
									    <div class="dayCard">
									
									      <div class="dayLeft">
									        <div class="dayBadge">${d}일차</div>
									
									        <div class="dayText">
									          <c:choose>
									            <c:when test="${d == 1}">
									              <b>인천 → ${detail.locName}(${detail.ctryName})</b>
									              <span>출발 · 기내식</span>
									            </c:when>
									
									            <c:when test="${d == dayCount}">
									              <b>${detail.locName} → 인천</b>
									              <span>귀국</span>
									            </c:when>
									
									            <c:when test="${d == 2}">
									              <b>${detail.locName} 핵심 관광</b>
									              <span>현지 투어</span>
									            </c:when>
									
									            <c:when test="${d == 3}">
									              <c:choose>
									                <c:when test="${detail.themeId == 'HIS'}">
									                  <b>역사 탐방 코스</b>
									                  <span>유적 · 박물관 · 구시가지</span>
									                </c:when>
									                <c:when test="${detail.themeId == 'CUL'}">
									                  <b>문화 · 예술 코스</b>
									                  <span>공연 · 미술관 · 랜드마크</span>
									                </c:when>
									                <c:when test="${detail.themeId == 'LEI'}">
									                  <b>레저 · 액티비티</b>
									                  <span>체험 · 전망 · 야외활동</span>
									                </c:when>
									                <c:when test="${detail.themeId == 'FOD'}">
									                  <b>미식 투어</b>
									                  <span>로컬 맛집 · 마켓 · 카페</span>
									                </c:when>
									                <c:when test="${detail.themeId == 'FES'}">
									                  <b>축제 · 이벤트</b>
									                  <span>현지 행사 · 야시장 · 퍼레이드</span>
									                </c:when>
									                <c:when test="${detail.themeId == 'VAC'}">
									                  <b>휴양 · 힐링</b>
									                  <span>휴식 · 산책 · 스파</span>
									                </c:when>
									                <c:otherwise>
									                  <b>테마 일정</b>
									                  <span>추천 코스 · 현지 체험</span>
									                </c:otherwise>
									              </c:choose>
									            </c:when>
									
									            <c:otherwise>
									              <b>자유 일정</b>
									              <span>근교투어 · 자유시간</span>
									            </c:otherwise>
									          </c:choose>
									        </div>
									      </div>
									
									      <!-- 가운데 라인/점 (CSS로 세로선 그리는 영역) -->
									      <div class="dayMid" aria-hidden="true">
									        <!-- <span class="dayDot"></span> -->
									      </div>
									
									      <!-- 우측(상세 리스트) -->
									      <div class="dayRight">
									
									        <div class="dayBody">
									          <c:set var="rows" value="${itinMap[d]}" />
									
									          <!-- 마지막날 제외: 일정 없으면 안내 -->
									          <c:if test="${empty rows && d != dayCount}">
									            <div class="muted">등록된 일정이 없습니다.</div>
									          </c:if>
									
									          <c:set var="shown" value="0" />
									
									          <ul class="dayDetailList">
									            <c:forEach var="r" items="${rows}">
									              <!-- 마지막날은 숙소(HOTEL) 숨김 -->
									              <c:if test="${!(d == dayCount && r.kind == 'HOTEL')}">
									                <c:set var="shown" value="${shown + 1}" />
									
									                <li class="dayDetailItem">
									                  <c:choose>
									                    <c:when test="${r.kind == 'HOTEL'}">
									                      <span class="pin">🏨</span>
									                      <span class="txt"><b>숙소</b> : ${r.hotelName}</span>
									                    </c:when>
									                    <c:otherwise>
									                      <span class="pin">📍</span>
									                      <span class="txt">${r.itemTitle}</span>
									                    </c:otherwise>
									                  </c:choose>
									                </li>
									
									              </c:if>
									            </c:forEach>
									
									            <!-- 마지막날에 rows가 없거나(혹은 HOTEL만 있어서 shown=0) 이면 귀국 문구 -->
									            <c:if test="${d == dayCount && shown == 0}">
									              <li class="dayDetailItem">
									                <span class="pin">🛫</span>
									                <span class="txt">귀국 일정입니다.</span>
									              </li>
									            </c:if>
									
									          </ul>
									        </div>
									
									      </div>
									    </div>
									
									  </c:forEach>
									
									</div>


								</div>

                                <div class="tabPane" id="tab_spot">
                                
                                  <c:if test="${empty itemList}">
                                    <div style="color: var(--muted); font-size: 13px; margin-top: 8px;">
                                      등록된 관광지가 없습니다.
                                    </div>
                                  </c:if>
                                
                                  <c:if test="${not empty itemList}">
                                    <ul class="spotList">
                                      <c:forEach var="item" items="${itemList}">
                                            <li class="spotItem">
                                              <span>${item.itemTitle}</span>
                                              <img class="spotThumb"
                                                 src="${pageContext.request.contextPath}${item.imgPath}"
                                                 alt="${item.itemTitle}">
                                            </li>
                                      </c:forEach>
                                    </ul>
                                  </c:if>
                                </div>

                                <div class="tabPane" id="tab_notice">
                                    <div class="noticeWrap">
                                        <hr class="noticeDivider">
                                        <h3 class="noticeTitle">여권/비자</h3>
                                        <ul class="noticeList">
                                            <li>여권에 낙서 또는 메모를 하거나 기념도장을 찍은 경우, 페이지를 임의로 뜯어내는 경우, 신원정보면에 얼룩이 묻은 경우, 여권 표지가 손상된 경우, 여권 잔여 유효기간 부족, 여권 사증란 부족한 경우 출입국 및 항공권 발권 등에 제한이 있을 수 있으므로 출발 전에 반드시 여권을 확인하여 주시기 바랍니다.</li>
                                            <li>서명이 없는 여권은 위조여권으로 의심받는 경우가 있으므로, 여권 소지인의 서명란에 반드시 서명하시기 바랍니다.</li>
                                            <li>서명란에 이름 외에 다른 글자나 기호(하트모양, 별모양 등 특수기호 포함)를 적지 않도록 유의하시기 바랍니다. 영유아의 경우 보호자가 아이의 이름으로 대신 서명(정자 기입)하시면 됩니다.</li>
                                        </ul>

                                        <hr class="noticeDivider">
                                        <h3 class="noticeTitle">외국/이중국적 주의사항</h3>
                                        <p class="noticeText">외국/이중국적자의 해외여행은 도착지국가(경유국가 포함)의 출입국정책이 상이하므로, 반드시 여행자 본인이 해당국의 대사관에 확인하셔야 합니다.</p>

                                        <hr class="noticeDivider">
                                        <h3 class="noticeTitle">항공사 관련 서비스</h3>
                                        <p class="noticeText">항공사 마일리지 적립 가능/불가능 여부는 해당 항공의 룰에 따라 달라지므로 예약하신 상품의 항공사로 확인하여 주시기 바랍니다.</p>

                                        <div class="noticeBox">
                                            <p class="noticeBoxTitle">아이를 위한 기내식 사전 신청 서비스</p>
                                            <p class="noticeBoxText">출발일 기준 3일 전까지 여행사를 통해 신청하시기 바랍니다.</p>
                                        </div>

                                        <hr class="noticeDivider">
                                        <h3 class="noticeTitle">공항이용</h3>
                                        <ul class="noticeList">
                                            <li>항공기 좌석 배정은 항공사의 고유권한으로 공항에서 선착순 배정됨에 따라 일행과 좌석이 분리될 수도 있으며, 대리수속은 불가합니다.</li>
                                            <li>항공기 이용 시 용기당 100ml 초과 액체류(화장품, 치약류, 젤 등) 물품 기내 반입 제한됩니다. (단, 탁송수하물은 제한 없음)</li>
                                            <li>수하물 탁송 시 각 항공사 규정에 따라 보상불가한 경우가 있으므로, 귀중품은 반드시 휴대하셔야 합니다.</li>
                                        </ul>

                                        <hr class="noticeDivider">
                                        <h3 class="noticeTitle">동/축산물 검역안내</h3>
                                        <ul class="noticeList">
                                            <li>대부분의 축산물(소세지, 육포 등) 및 생과실·열매채소 등은 휴대반입할 수 없으며, 휴대반입이 가능한 축산물과 식물류도 신고 및 검역을 받아야 하며, 불법 반입 시 최고 1,000만원의 과태료가 부과됩니다.</li>
                                            <li>해외 축산농장, 가축시장을 방문한 여행객과 가축전염병 발생 국가를 방문한 축산관계자는 농림축산검역본부에 신고하여 소독을 받아야 합니다.</li>
                                            <li>축산업 종사자는 가축전염병 발생국가로 출/입국 시 신고를 해야 합니다.</li>
                                        </ul>

                                        <div class="noticeBox">
                                            <p class="noticeBoxText">문의 : 농림축산검역본부 (인천공항 동축산물 032-740-2660, 식물 032-740-2077)</p>
                                        </div>

                                        <hr class="noticeDivider">
                                        <h3 class="noticeTitle">안전사고</h3>
                                        <p class="noticeText">여행일정 중 발생할 수 있는 모든 안전사고에 유의하시기 바라며, 가이드의 안내사항 및 안전수칙을 준수하시기 바랍니다. 여행자 본인의 과실로 인한 안전사고는 본인이 책임을 지게 됩니다.</p>
                                    </div>
                                </div>

                                <div class="tabPane" id="tab_safety">
                                    <div class="safetyWrap">
                                        <hr class="noticeDivider">
                                        <h3 class="noticeTitle">여행 금지국 현황</h3>
                                        <h4 class="noticeSubTitle">여행 금지국</h4>
                                        <ul class="noticeList">
                                            <li>소말리아 (2007.8.7.~2024.7.31.)</li>
                                            <li>이라크 (2007.8.7.~2024.7.31.)</li>
                                            <li>아프가니스탄 (2007.8.7.~2024.7.31.)</li>
                                            <li>예멘 (2011.6.28.~2024.7.31.)</li>
                                            <li>수단 (전 지역(2023.4.29.~2024.7.31.))</li>
                                            <li>아이티 (전 지역(2024.5.1.~2024.7.31.))</li>
                                            <li>우크라이나 (전 지역(2022.2.13.~2024.7.31.))</li>
                                            <li>리비아 (2014.8.4.~2024.7.31.)</li>
                                            <li>시리아 (2011.8.20.~2024.7.31.)</li>
                                            <li>아제르바이잔 일부지역: 아르메니아 접경 5km 구간(2023.4.15.~2024.7.31.)</li>
                                            <li>미얀마 일부지역: 샨州 북부, 샨州 동부, 까야州, 라카인주(2024.5.1.~2024.7.31.)</li>
                                            <li>필리핀 일부지역: 민다나오의 잠보앙가, 술루‧바실란‧타위타위 군도(2015.12.1.~2024.7.31.)</li>
                                            <li>러시아 일부지역: 러시아 로스토프·벨고로드·보로네시·쿠르스크·브랸스크 지역 내 우크라이나 국경에서 30km(2022.3.8.~2024.7.31.)</li>
                                            <li>벨라루스 일부지역: 벨라루스 브레스트·고멜 지역 내 우크라이나 국경에서 30km(2022.3.8.~2024.7.31.)</li>
                                            <li>아르메니아 일부지역: 아제르바이잔 접경 30km 구간(2023.4.15.~2024.7.31.)</li>
                                            <li>이스라엘 일부지역: 가자지구(2023.8.1.~2024.7.31.)</li>
                                            <li>팔레스타인 일부지역: 가자지구(2023.8.1.~2024.7.31.)</li>
                                            <li>팔레스타인 일부지역: 가자지구(2023.8.1.~2024.7.31.)</li>
                                            <li>라오스 일부지역: 골든트라이앵글 경제특구(2024.2.1.~2024.7.31.)</li>
                                        </ul>

                                        <hr class="noticeDivider">
                                        <h3 class="noticeTitle">여행 금지국 방문 시</h3>
                                        <p class="noticeText"><strong>여권법 제 26조</strong></p>

                                        <div class="noticeBox">
                                            <p class="noticeBoxText">
                                                방문 및 체류가 금지된 국가나 지역으로 고시된 사정을 알면서도 같은 조 제1항 단서에 따른 허가(제14조 제3항에 따라 준용되는 경우를 포함한다)를 받지 아니하고
                                                해당 국가나 지역에서 여권 등을 사용하거나 해당 국가나 지역을 방문하거나 체류한 사람은
                                                <strong>1년 이하의 징역 또는 1000만원 이하의 벌금</strong>에 처한다.
                                            </p>
                                        </div>

                                        <hr class="noticeDivider">
                                        <h3 class="noticeTitle">여행경보단계</h3>
                                        <p class="noticeText">
                                            외교부에서 운영하는 여행경보단계는 <strong>여행유의 / 여행자제 / 철수권고 / 여행금지</strong> 4단계로 구분되며
                                            외교부 ‘해외안전여행’ 사이트에서 상세정보를 확인할 수 있습니다.
                                        </p>

                                        <p class="noticeText">
                                            해당 국가는 해외여행 경보단계에 해당하지 않는 지역입니다. <strong>(2026-01-26 기준)</strong>
                                        </p>

                                        <div class="noticeBox">
                                            <p class="noticeBoxText">
                                                해외여행 등록제 ‘동행’에 가입하시면 목적지의 안전정보, 여행객의 안전정보, 해외여행 중 사고에 대해 가족에게 사고사실 전달이 가능합니다.
                                            </p>
                                        </div>

                                        <hr class="noticeDivider">
                                        <h3 class="noticeTitle">국가별 사건/사고</h3>
                                        <p class="noticeText">외교부(www.0404.go.kr)에 공지된 여행상품에 포함된 국가의 사건, 사고 입니다.</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="card section">
                            <div class="secTabs" style="justify-content: space-between;">
                                <b style="padding-left: 4px;">상품가격</b>
                                <button type="button" class="pill primary" style="margin-right: 4px;">상품가격 안내</button>
                            </div>
                            <div class="secBody">
                                <table class="priceTable" aria-label="상품 가격표">
                                    <thead>
                                        <tr>
                                            <th>구분</th>
                                            <th>성인<br />
                                                <span style="font-weight: 700; color: var(--muted); font-size: 12px;">만 12세 이상</span>
                                            </th>
                                            <th>아동<br />
                                                <span style="font-weight: 700; color: var(--muted); font-size: 12px;">만 12세 미만</span>
                                            </th>
                                            <th>유아<br />
                                                <span style="font-weight: 700; color: var(--muted); font-size: 12px;">만 2세 미만</span>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td><b>기본상품</b></td>
                                            <td><b>${detail.regPrice}</b>원</td>
                                            <td>(예시) ${detail.regPrice}원</td>
                                            <td>150,000원</td>
                                        </tr>
                                    </tbody>
                                </table>

                                <div style="margin-top: 10px; color: var(--muted); font-size: 12px; line-height: 1.6;">
                                    * 유류할증료/제세공과금은 변동될 수 있습니다.<br />
                                    * 1인 객실 사용 등 추가 비용은 결제 시점에 안내될 수 있습니다.
                                </div>
                            </div>
                        </div>

                    </div>
                </div>

                <aside class="side">
                    <div class="card sideBox">
                        <h3 class="sideTitle">인원선택</h3>

                        <div class="qtyRow">
                            <div class="qtyLabel">
                                <b>성인</b>
                                <span class="sub">만 12세 이상</span>
                                <span class="sub" data-price-adult>${detail.regPrice}원</span>
                            </div>
                            <div class="stepper">
                                <button class="btnStep" type="button" data-type="adult" data-dir="-">−</button>
                                <input type="number" id="adultCnt" class="num" value="1" min="1" max="50" step="1" inputmode="numeric"/>
                                <button class="btnStep" type="button" data-type="adult" data-dir="+">+</button>
                            </div>
                        </div>

                        <div class="total">
                            <div style="color: var(--muted); font-weight: 900;">총금액</div>
                            <div class="amt" id="totalAmt">0</div>
                        </div>

                        <div class="note">
                            * 유류할증료/제세공과금 포함<br/>
                        </div>

                        <button class="paymentBtn" id="payBtn" type="button">결제하기</button>

                       <!--  <div class="benefit">
                            <b>혜택</b>
                            <ul>
                                <li>추가 적립/할인</li>
                                <li>이달의 카드할인 혜택</li>
                            </ul>
                            <a href="javascript:void(0)" onclick="alert('비교/혜택 팝업은 추후 구현')">상품별 차별화 혜택 비교 ></a>
                        </div> -->
                    </div>
                </aside>

            </section>
        </c:if>

    </main>

    <div class="payModalBackdrop" id="payModalBackdrop" aria-hidden="true">
        <div class="payModal" role="dialog" aria-modal="true" aria-labelledby="payModalTitle">
            <div class="payModalHeader">
                <b id="payModalTitle">결제수단 선택</b>
                <button type="button" class="payModalClose" id="payModalClose" aria-label="닫기">
                    <i class="fa-solid fa-xmark"></i>
                </button>
            </div>

            <div class="payModalBody">
                <label class="payOption">
                    <div class="left">
                        <div class="title">간편결제</div>
                        <div class="desc">카카오페이</div>
                    </div>
                    <input type="radio" name="payMethod" value="kakaopay" checked>
                </label>

                <label class="payOption">
                    <div class="left">
                        <div class="title">신용카드 결제</div>
                        <div class="desc">토스페이먼츠</div>
                    </div>
                    <input type="radio" name="payMethod" value="uplus">
                </label>

                <div class="payModalHint">
                    * 결제수단은 결제창 호출 전에 선택됩니다.
                </div>
            </div>

            <div class="payModalFooter">
                <button type="button" class="btnGhost" id="payModalCancel">취소</button>
                <button type="button" class="btnPrimary" id="payModalConfirm">선택한 결제수단으로 결제</button>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/tctFooter.jsp" %>

    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
    <script src="${ctx}/assets/js/payment/tct-pay.js"></script>

    <script>
      // ===== 공용 결제 모듈 초기화 (detail) =====
      (function () {
        if (!window.TCTPay) {
          console.error("TCTPay not found.tct-pay.js 경로 확인");
          return;
        }

        TCTPay.init({
          ctx: "${ctx}",
          impCode: "imp77843200",
          radioName: "payMethod",
          ids: {
            payBtnId: "payBtn",
            backdropId: "payModalBackdrop",
            closeId: "payModalClose",
            cancelId: "payModalCancel",
            confirmId: "payModalConfirm"
          },
          endpoints: {
            payCreateUrl: "${ctx}/payCreate.do",
            paymentCompleteUrl: "${ctx}/paymentComplete.do"
          },
          getOrderData: function () {
            const adultCnt = Math.max(1, Number(document.getElementById("adultCnt")?.value || "1"));
            const totalAmount = Number((document.getElementById("totalAmt")?.textContent || "0").replace(/[^0-9]/g, "")) || 0;

            return {
              reg_id: "${detail.regId}",
              adult_cnt: adultCnt,
              amount: totalAmount,
              name: "${detail.regTitle}"
            };
          }
        });
      })();
    </script>

    <script>
      // ===== 인원(+/-) & 총금액 계산 =====
      document.addEventListener("DOMContentLoaded", function () {
        const elTotal = document.getElementById("totalAmt");
        const inputAdult = document.getElementById("adultCnt");
        if (!elTotal || !inputAdult) return;

        function readPrice() {
          const txt = document.querySelector("[data-price-adult]")?.textContent || "0";
          return Number(txt.replace(/[^0-9]/g, "")) || 0;
        }
        const adultPrice = readPrice();

        function clamp() {
          const min = Number(inputAdult.min || 1);
          const max = Number(inputAdult.max || 50);

          let v = parseInt(inputAdult.value, 10);
          if (isNaN(v)) v = min;

          v = Math.max(min, Math.min(max, v));
          inputAdult.value = v;
          return v;
        }

        function calc() {
          const a = clamp();
          const total = a * adultPrice;
          elTotal.textContent = total.toLocaleString("ko-KR");
        }

        document.querySelectorAll(".btnStep").forEach(function (btn) {
          btn.addEventListener("click", function () {
            if (btn.dataset.type !== "adult") return;

            let v = parseInt(inputAdult.value, 10);
            if (isNaN(v)) v = Number(inputAdult.min || 1);

            v += (btn.dataset.dir === "+") ? 1 : -1;
            inputAdult.value = v;

            calc();
          });
        });

        inputAdult.addEventListener("input", calc);
        inputAdult.addEventListener("blur", calc);

        calc();
      });
    </script>

    <script>
      // ✅ 변수 선언
      const CTX = "<%=request.getContextPath()%>";
      const IS_LOGIN = <%= (session.getAttribute("loginUser") != null) ? "true" : "false" %>;

      function showToast(msg){
        let el = document.getElementById("tctToast");
        if(!el){
          el = document.createElement("div");
          el.id = "tctToast";
          el.style.cssText = "position:fixed; left:50%; bottom:22px; transform:translateX(-50%); background:rgba(15,23,42,.92); color:#fff; padding:10px 14px; border-radius:999px; font-size:13px; font-weight:800; opacity:0; pointer-events:none; transition:opacity .18s ease; z-index:9999;";
          document.body.appendChild(el);
        }
        el.textContent = msg;
        el.style.opacity = "1";
        clearTimeout(showToast._t);
        showToast._t = setTimeout(()=> { el.style.opacity = "0"; }, 1600);
      }

      function updateWishButton(btn, wished, inCart){
        if(!btn) return;

        if(inCart){
          btn.style.display = "none";
        }else{
          btn.style.display = "inline-flex";
          btn.disabled = false;
          btn.style.pointerEvents = "auto";
          btn.style.opacity = "1";
          btn.style.background = "";
          btn.style.borderColor = "";
          btn.style.color = "";
          btn.style.cursor = "pointer";

          if(wished){
            btn.classList.add("on");
            btn.innerHTML = '<span class="heart-icon">♥</span> 관심상품';
          }else{
            btn.classList.remove("on");
            btn.innerHTML = '<span class="heart-icon">♡</span> 관심상품';
          }
        }
      }

      (function(){
        if(window.__wishDetailBound) return;
        window.__wishDetailBound = true;

        async function initWish(){
          try{
            const cartR = await fetch(CTX + "/cart/current.do");
            const cartData = cartR.ok ? await cartR.json() : {};
            const cartSet = new Set();
            if(cartData.regIds){
              cartData.regIds.forEach(x => cartSet.add(String(x).trim()));
            }else if(cartData.regId){
              cartSet.add(String(cartData.regId).trim());
            }

            const wishR = await fetch(CTX + "/wish/ids.do");
            const wishData = wishR.ok ? await wishR.json() : {};
            const wishSet = new Set((wishData.ids || []).map(x => String(x).trim()));

            const btn = document.querySelector(".btn-wish-list");
            if(!btn) return;

            const id = (btn.dataset.id || "").trim();
            const inCart = cartSet.has(id);
            const wished = wishSet.has(id);
            updateWishButton(btn, wished, inCart);
          }catch(err){
            console.log("initWish error:", err);
          }
        }

        if(IS_LOGIN) initWish();

        document.addEventListener("click", async function(e){
          const btn = e.target.closest(".btn-wish-list");
          if(!btn) return;

          e.preventDefault();
          e.stopPropagation();

          if(!IS_LOGIN){
            alert("로그인이 필요한 서비스입니다. 로그인 페이지로 이동합니다.");
            const here = location.pathname + location.search + location.hash;
            location.href = CTX + "/login.do?returnUrl=" + encodeURIComponent(here);
            return;
          }

          if(btn.style.display === "none"){
            return;
          }

          const regId = (btn.dataset.id || "").trim();
          if(!regId){
            alert("상품 ID가 없습니다.");
            return;
          }

          try{
            const params = new URLSearchParams({ regId });
            const r = await fetch(CTX + "/wish/toggle.do", {
              method: "POST",
              headers: {"Content-Type":"application/x-www-form-urlencoded;charset=UTF-8"},
              body: params
            });
            if(!r.ok) throw new Error("서버 응답 오류");
            const data = await r.json();

            if(!data.ok){
              alert(data.msg || "관심상품 처리 실패");
              return;
            }

            const cartR = await fetch(CTX + "/cart/current.do");
            const cartData = cartR.ok ? await cartR.json() : {};
            const cartSet = new Set();
            if(cartData.regIds){
              cartData.regIds.forEach(x => cartSet.add(String(x).trim()));
            }else if(cartData.regId){
              cartSet.add(String(cartData.regId).trim());
            }
            const inCart = cartSet.has(regId);

            updateWishButton(btn, data.wished, inCart);
            showToast(data.wished ? "관심상품에 등록되었습니다." : "관심상품이 취소되었습니다.");
          }catch(err){
            console.log(err);
            alert("관심상품 처리 중 오류가 발생했습니다.");
          }
        });
      })();

      async function initCart(){
        try{
          const r = await fetch(CTX + "/cart/current.do");
          const data = r.ok ? await r.json() : {};
          const cartSet = new Set();
          if(data.regIds){
            data.regIds.forEach(x => cartSet.add(String(x).trim()));
          }else if(data.regId){
            cartSet.add(String(data.regId).trim());
          }

          const btn = document.querySelector(".btn-cart-detail");
          if(!btn) return;

          const id = (btn.dataset.regid || "").trim();
          if(cartSet.has(id)){
            btn.classList.add("inCart");
            btn.textContent = "✓ 담김";
          }else{
            btn.classList.remove("inCart");
            btn.textContent = "🛒 장바구니";
          }
        }catch(err){
          console.log("initCart error:", err);
        }
      }

      if(IS_LOGIN) initCart();

      document.addEventListener("click", async function(e){
        const btn = e.target.closest(".btn-cart-detail");
        if(!btn) return;

        e.preventDefault();
        e.stopPropagation();

        if(!IS_LOGIN){
          alert("로그인이 필요한 서비스입니다. 로그인 페이지로 이동합니다.");
          const here = location.pathname + location.search + location.hash;
          location.href = CTX + "/login.do?returnUrl=" + encodeURIComponent(here);
          return;
        }

        const regId = (btn.dataset.regid || "").trim();

        // ✅ 현재 인원(성인) 입력값을 읽어서 서버로 보낼 사람 수로 쓰기
        const getPeopleCnt = () => {
          // adultCnt input에 들어있는 값을 숫자로 변환
          const v = parseInt(document.getElementById("adultCnt").value, 10) || 1;
          // 1명 미만은 의미 없으니 최소 1로 보정
          return (v < 1) ? 1 : v;
        };

        const postCart = async (forceYN) => {
          // ✅ 버튼 누른 시점의 인원수를 읽어서 peopleCnt로 보냄
          const peopleCnt = getPeopleCnt();

          // URLSearchParams = application/x-www-form-urlencoded 형태로 POST 바디 만들기
          const params = new URLSearchParams({
            regId,                 // 어떤 상품을 담는지
            force: forceYN,        // 다른 상품 담겨있을 때 교체 강제 여부
            peopleCnt: String(peopleCnt)  // ✅ 선택한 인원수
          });

          const resp = await fetch(CTX + "/cart/add.do", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8" },
            body: params
          });

          if(!resp.ok) throw new Error("서버 응답 오류");
          return resp.json();
        };

        const removeCart = async () => {
          const params = new URLSearchParams({ ajax: "Y", regId });
          const resp = await fetch(CTX + "/cart/remove.do", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8" },
            body: params
          });
          if(!resp.ok) throw new Error("서버 응답 오류");
          return resp.json();
        };

        // ✅ 이미 담긴 상태면 다시 누를 때 "삭제"로 동작
        if(btn.classList.contains("inCart")){
          if(!confirm("장바구니에서 제거하시겠습니까?")) return;

          try{
            const data = await removeCart();
            if(data.ok){
              btn.classList.remove("inCart");
              btn.textContent = "🛒 장바구니";
              const wishBtn = document.querySelector(".btn-wish-list");
              if(wishBtn) { wishBtn.style.display = "inline-flex"; }
              showToast("장바구니에서 제거했습니다.");
            }else if(data.code === "NEED_LOGIN"){
              alert("로그인이 필요한 서비스입니다. 로그인 페이지로 이동합니다.");
              const here = location.pathname + location.search + location.hash;
              location.href = CTX + "/login.do?returnUrl=" + encodeURIComponent(here);
            }else{
              alert(data.msg || "장바구니 제거에 실패했습니다.");
            }
          }catch(err){
            console.error(err);
            alert("장바구니 제거 중 오류가 발생했습니다.");
          }
          return;
        }


        try{
          btn.classList.add("inCart");
          btn.textContent = "✓ 담김";
          const wishBtn = document.querySelector(".btn-wish-list");
          if(wishBtn) { wishBtn.style.display = "none"; }

          let data = await postCart("N");

          if(data.ok){
            showToast("장바구니에 상품을 담았습니다.");
          }else if(data.code === "CONFLICT"){
            if(confirm(data.msg || "이미 담긴 상품이 있습니다. 교체할까요?")){
              data = await postCart("Y");
              if(data.ok){
                showToast("상품이 교체되었습니다.");
              }else{
                btn.classList.remove("inCart");
                btn.textContent = "🛒 장바구니";
                if(wishBtn) { wishBtn.style.display = "inline-flex"; }
              }
            }else{
              btn.classList.remove("inCart");
              btn.textContent = "🛒 장바구니";
              if(wishBtn) { wishBtn.style.display = "inline-flex"; }
            }
          }else{
            btn.classList.remove("inCart");
            btn.textContent = "🛒 장바구니";
            if(wishBtn) { wishBtn.style.display = "inline-flex"; }
            alert(data.msg || "장바구니 처리에 실패했습니다.");
          }
        }catch(err){
          console.error(err);
          btn.classList.remove("inCart");
          btn.textContent = "🛒 장바구니";
          const wishBtn = document.querySelector(".btn-wish-list");
          if(wishBtn) { wishBtn.style.display = "inline-flex"; }
          alert("장바구니 처리 중 오류가 발생했습니다.");
        }
      });

      document.addEventListener("DOMContentLoaded", () => {
        const tabs  = document.querySelectorAll(".secTab");
        const panes = document.querySelectorAll(".tabPane");

        tabs.forEach(tab => {
          tab.addEventListener("click", () => {
            const targetId = "tab_" + tab.dataset.tab;

            tabs.forEach(t => t.classList.remove("active"));
            tab.classList.add("active");

            panes.forEach(p => p.classList.remove("active"));
            document.getElementById(targetId)?.classList.add("active");
          });
        });
      });
      
      (function(){
          const slider = document.getElementById('heroSlider');
          if(!slider) return;

          const imgs = slider.querySelectorAll('.heroImg');
          const prev = slider.querySelector('.heroNav.prev');
          const next = slider.querySelector('.heroNav.next');

          if(imgs.length <= 1){
            if(prev) prev.style.display = 'none';
            if(next) next.style.display = 'none';
            return;
          }

          let idx = 0;
          const show = (n)=>{
            imgs[idx].classList.remove('active');
            idx = (n + imgs.length) % imgs.length;
            imgs[idx].classList.add('active');
          };

          prev.addEventListener('click', ()=>show(idx - 1));
          next.addEventListener('click', ()=>show(idx + 1));

          // 자동재생(원치 않으면 삭제)
          setInterval(()=>show(idx + 1), 4000);
        })();
      
      document.addEventListener("click", function(e){
    	  const btn = e.target.closest(".toggleBtn");
    	  if(!btn) return;

    	  const item = btn.closest(".dayItem");
    	  const body = item.querySelector(".dayBody");
    	  if(!body) return;

    	  const isOpen = body.style.display === "" || body.style.display === "block";

    	  if(isOpen){
    	    body.style.display = "none";
    	    item.classList.remove("open");
    	  }else{
    	    body.style.display = "block";
    	    item.classList.add("open");
    	  }
    	});
    </script>
</body>
</html>
