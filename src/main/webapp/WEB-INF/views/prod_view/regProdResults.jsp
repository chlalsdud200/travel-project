<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>TryCatchTrip - 전체 상품</title>

  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

<style>
.highlightText{
  font-size: 15px;
  font-weight: 900;
  color: var(--ink);
  line-height: 1.4;
  padding-bottom: 6px;
}

:root {
  --max: 1200px;
  --padX: 16px;
  --gap: 18px;
  --r: 14px;
  --pill: 999px;
  --bg: #f6f8ff;
  --card: #ffffff;
  --ink: #0f172a;
  --muted: #64748b;
  --line: rgba(15, 23, 42, .10);
  --primary: #1b7bff;
  --primarySoft: rgba(27, 123, 255, .12);
  --shadow: 0 10px 30px rgba(15, 23, 42, .08);
  --shadow2: 0 8px 18px rgba(15, 23, 42, .08);
}

* { box-sizing: border-box; }
html, body { height: 100%; }

body {
  margin: 0;
  font-family: ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto,
    "Apple SD Gothic Neo", "Noto Sans KR", "Malgun Gothic", Arial;
  color: var(--ink);
  background: var(--bg);
}

/* ===== topline 우측 액션(공유) ===== */
.actions {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-left: auto; /* 핵심: 이 설정이 공유 버튼을 오른쪽 끝으로 밀어줍니다 */
  z-index: 2;
  position: relative;
}

.shareBtn{
  width: 34px;
  height: 34px;
  border-radius: 999px;
  border: 1px solid rgba(15,23,42,.12);
  background: #fff;
  display:grid;
  place-items:center;
  cursor:pointer;
  color: var(--muted);
  transition: transform .12s ease, background .12s ease, border-color .12s ease, color .12s ease;
  box-shadow: 0 6px 14px rgba(15,23,42,.06);
}
.shareBtn:hover{
  color: var(--primary);
  border-color: rgba(27,123,255,.45);
  background: rgba(27,123,255,.10);
  transform: translateY(-1px);
}
.shareBtn:active{ transform: translateY(0); }
.shareBtn:focus-visible{
  outline: 3px solid rgba(27,123,255,.25);
  outline-offset: 2px;
}

/* ===== 장바구니 버튼(단건) ===== */
.cartBtn{
  width: 44px;
  height: 38px;
  border-radius: 12px;
  border: 1px solid rgba(15,23,42,.12);
  background: #fff;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 12px;
  font-weight: 900;
  color: var(--muted);
  box-shadow: 0 6px 14px rgba(15,23,42,.06);
  transition: transform .12s ease, background .12s ease, border-color .12s ease, color .12s ease;
}
.cartBtn:hover{
  color: var(--primary);
  border-color: rgba(27,123,255,.45);
  background: rgba(27,123,255,.10);
  transform: translateY(-1px);
}
.cartBtn:active{ transform: translateY(0); }
.cartBtn.inCart{
  background: var(--primary);
  border-color: var(--primary);
  color: #fff;
}

/* ===== 토스트 ===== */
.tctToast{
  position: fixed;
  left: 50%;
  bottom: 22px;
  transform: translateX(-50%);
  background: rgba(15,23,42,.92);
  color: #fff;
  padding: 10px 14px;
  border-radius: 999px;
  font-size: 13px;
  font-weight: 800;
  box-shadow: 0 12px 30px rgba(15,23,42,.22);
  opacity: 0;
  pointer-events: none;
  transition: opacity .18s ease, transform .18s ease;
}
.tctToast.show{
  opacity: 1;
  transform: translateX(-50%) translateY(-6px);
}

a { color: inherit; text-decoration: none; }
button, input, select { font: inherit; }

.container {
  max-width: var(--max);
  margin: 0 auto;
  padding: 0 var(--padX);
}

.crumbs {
  padding: 18px 0 8px;
  color: var(--muted);
  font-size: 13px;
}

.crumbs .sep { margin: 0 8px; opacity: .6; }

.titleRow {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 12px;
  padding: 6px 0 14px;
  border-bottom: 1px solid var(--line);
}

.pageTitle {
  display: flex;
  align-items: baseline;
  gap: 12px;
}

.pageTitle h1 {
  margin: 0;
  font-size: 28px;
  letter-spacing: -0.8px;
}

.count { color: var(--muted); font-weight: 700; }

.layout {
  display: grid;
  grid-template-columns: 280px 1fr;
  gap: var(--gap);
  padding: 14px 0 28px;
  align-items: start;
}
@media ( max-width : 980px) {
  .layout { grid-template-columns: 1fr; }
}

.filterCard {
  background: var(--card);
  border: 1px solid var(--line);
  border-radius: var(--r);
  box-shadow: var(--shadow2);
  overflow: hidden;
  position: sticky;
  top: 118px;
}
@media ( max-width : 980px) {
  .filterCard { position: relative; top: 0; }
}

.filterTop {
  padding: 14px;
  border-bottom: 1px solid var(--line);
  display: flex;
  align-items: center;
  gap: 10px;
  justify-content: space-between;
}
.filterTop strong { font-size: 15px; }

.filterSearch {
  padding: 12px 14px;
  display: flex;
  gap: 10px;
  align-items: center;
  border-bottom: 1px solid var(--line);
}

.filterSearch input {
  width: 100%;
  padding: 10px 12px;
  border-radius: 12px;
  border: 1px solid var(--line);
  outline: 0;
  background: #fff;
}

.filterSearch button {
  width: 42px;
  height: 42px;
  border-radius: 12px;
  border: 1px solid var(--line);
  background: #fff;
  cursor: pointer;
}

.filterSection {
  border-bottom: 1px solid var(--line);
  padding: 12px 14px;
}

.filterHead {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  user-select: none;
}

.filterHead .label {
  font-weight: 900;
  font-size: 14px;
}

.departControls {
  margin-top: 10px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.controlRow {
  display: flex;
  gap: 10px;
  align-items: center;
}

.controlRow select, .controlRow input[type="date"] {
  width: 100%;
  padding: 10px 12px;
  border-radius: 12px;
  border: 1px solid var(--line);
  outline: 0;
  background: #fff;
  color: var(--ink);
}

.listHeader {
  display: flex;
  align-items: flex-end;
  justify-content: flex-end;
  gap: 12px;
  padding: 8px 0 10px;
}

.sort {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  align-items: center;
  color: var(--muted);
  font-size: 14px;
}

.sort a {
  color: var(--muted);
  padding: 6px 8px;
  border-radius: 10px;
  border: 1px solid transparent;
}

.sort a.active {
  color: var(--ink);
  font-weight: 900;
  border-color: var(--line);
  background: #fff;
}

.cartGo{
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  padding: 6px 10px;
  border-radius: 10px;
  border: 1px solid var(--line);
  background: #fff;
  color: var(--ink);
  font-weight: 900;
  font-size: 13px;
}

.cards { display: flex; flex-direction: column; gap: 14px; }

/* .card { */
/*   background: var(--card); */
/*   border: 1px solid var(--line); */
/*   border-radius: var(--r); */
/*   box-shadow: var(--shadow2); */
/*   overflow: hidden; */
/*   cursor: pointer; */
/*   display: grid; */
/*   grid-template-columns: 240px 1fr; */
/* } */

.card {
  background: var(--card);
  border: 1px solid var(--line);
  border-radius: var(--r);
  box-shadow: var(--shadow2);
  overflow: hidden;
  cursor: pointer;
  display: grid;
  grid-template-columns: 240px 1fr;
  /* 높이를 내용물에 맞추되, 최소 높이를 지정하고 싶다면 설정 (선택사항) */
  min-height: 200px; 
}

@media ( max-width : 720px) {
  .card { grid-template-columns: 1fr; }
}

/* .thumb { */
/*   position: relative; */
/*   min-height: 160px; */
/*   background: #e8efff; */
/*   overflow: hidden; */
/* } */

.thumb {
  position: relative;
  /* 높이를 고정값으로 설정하여 이미지 크기에 상관없이 통일감을 줍니다 */
  height: 100%; 
  min-height: 200px; /* 카드의 최소 높이와 맞춤 */
  background: #e8efff;
  overflow: hidden;
}

/* .thumb img { */
/*   width: 100%; */
/*   height: 100%; */
/*   object-fit: cover; */
/*   display: block; */
/* } */

.thumb img {
  width: 100%;
  height: 100%;
  /* 핵심: 이미지 비율이 달라도 영역을 꽉 채우고 넘치는 부분은 자름 */
  object-fit: cover; 
  display: block;
}
/* .content { */
/*   padding: 14px; */
/*   display: flex; */
/*   flex-direction: column; */
/*   gap: 10px; */
/* } */
.content {
  padding: 14px;
  display: flex;
  flex-direction: column;
  justify-content: space-between; /* 위쪽 텍스트와 아래쪽 가격/버튼 사이 간격 확보 */
  gap: 10px;
}

.topline {
  display: flex;
  align-items: center; /* 세로 중앙 정렬 */
  gap: 12px;           /* 요소 간 일정한 간격 */
  margin-bottom: 5px;
  width: 100%;         /* 전체 너비 확보 */
}

.badges {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  align-items: center;
}

.badge {
  padding: 6px 8px;
  border-radius: 10px;
  border: 1px solid var(--line);
  background: rgb(255, 255, 128);
  font-size: 12px;
  font-weight: 900;
  color: var(--muted);
}

.title {
  font-size: 18px;
  font-weight: 1000;
  letter-spacing: -0.4px;
  line-height: 1.25;
  margin: 0;
  padding-left: 2px;
  padding-bottom: 4px;
}

/* .subTags { */
/*   background: rgba(15, 23, 42, .03); */
/*   border: 1px dashed rgba(15, 23, 42, .12); */
/*   border-radius: 12px; */
/*   padding: 10px 12px; */
/*   color: var(--muted); */
/*   font-size: 13px; */
/*   line-height: 1.8; */
/* } */

.subTags {
  display: -webkit-box;
  -webkit-line-clamp: 3; /* 최대 3줄까지만 노출 */
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
  /* 기존 스타일 유지 */
  background: rgba(15, 23, 42, .03);
  border: 1px dashed rgba(15, 23, 42, .12);
  border-radius: 12px;
  padding: 10px 12px;
  color: var(--muted);
  font-size: 13px;
/*   line-height: 1.8; */
  min-height: 80px;
  flex-grow: 1; /* 남은 공간을 차지하도록 설정 */
  
  /* 추가: 내용이 넘칠 경우 줄임표 처리 (선택사항) */
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.metaRow {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
  align-items: center;
  color: var(--muted);
  font-size: 13px;
}

.metaRow b { color: var(--ink); font-weight: 900; }

.bottomRow {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 12px;
  margin-top: 2px;
}

.price {
  display: flex;
  align-items: baseline;
  gap: 6px;
  white-space: nowrap;
  margin-top: -16px;
}

.price-label{
  font-size: 13px;
  font-weight: 700;
  color: var(--muted);
}

.price-value{
  font-size: 22px;
  font-weight: 1000;
  color: rgb(0, 0, 160);
}

.price-unit{
  font-size: 14px;
  font-weight: 700;
  color: black;
}

/* ===== 관심상품(찜) 버튼: cartBtn 느낌으로 ===== */
.btn-wish-list{
  height: 38px;
  padding: 0 10px;
  border-radius: 12px;
  border: 1px solid rgba(15,23,42,.12);
  background: #fff;
  display: inline-flex;
  align-items: center;
  gap: 6px;
  cursor: pointer;
  font-size: 12px;
  font-weight: 900;
  color: var(--muted);
  box-shadow: 0 6px 14px rgba(15,23,42,.06);
  transition: transform .12s ease, background .12s ease, border-color .12s ease, color .12s ease;
}

.btn-wish-list:hover{
  color: #ff4d4f;
  border-color: rgba(255,77,79,.45);
  background: rgba(255,77,79,.10);
  transform: translateY(-1px);
}

.btn-wish-list:active{ transform: translateY(0); }

.btn-wish-list.on{
  background: #ff4d4f;
  border-color: #ff4d4f;
  color: #fff;
}

.btn-wish-list.on .heart-icon{ color:#fff; }

.heart-icon{ font-size: 14px; }

.filterCard{
  border-radius: 18px;
  border: 1px solid rgba(15,23,42,.10);
  box-shadow: 0 14px 30px rgba(15,23,42,.06);
  overflow: hidden;
}

/* 상단 타이틀 */
.filterTop{
  padding: 16px 16px 12px;
  background: linear-gradient(180deg, rgba(27,123,255,.08), transparent);
}
.filterTop strong{
  font-size: 15px;
  font-weight: 1000;
  letter-spacing: -0.2px;
}

/* 검색바 */
.filterSearch{
  padding: 12px 16px;
  gap: 10px;
}
.filterSearch input{
  height: 42px;
  border-radius: 14px;
  border: 1px solid rgba(15,23,42,.12);
  background: #fff;
  padding: 0 12px;
  transition: box-shadow .15s ease, border-color .15s ease;
}
.filterSearch input:focus{
  border-color: rgba(27,123,255,.55);
  box-shadow: 0 0 0 4px rgba(27,123,255,.12);
}
.filterSearch button{
  width: 42px;
  height: 42px;
  border-radius: 14px;
  border: 1px solid rgba(15,23,42,.12);
  background: #fff;
  cursor: pointer;
  transition: transform .12s ease, background .12s ease, border-color .12s ease;
}
.filterSearch button:hover{
  background: rgba(27,123,255,.08);
  border-color: rgba(27,123,255,.35);
  transform: translateY(-1px);
}

/* 섹션 공통 */
.filterSection{
  padding: 14px 16px;
}
.filterSection + .filterSection{
  border-top: 1px solid rgba(15,23,42,.08);
}

/* 섹션 제목 */
.filterHead{
  margin-bottom: 8px;
}
.filterHead .label{
  font-size: 13px;
  font-weight: 1000;
  color: rgba(15,23,42,.88);
}
.filterHead.filterToggle{
  width: 100%;
  border: 0;
  background: transparent;
  padding: 0;
  cursor: pointer;
  text-align: left;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
}
.filterHead .chev{
  font-size: 12px;
  color: rgba(15,23,42,.55);
  transition: transform .15s ease;
}
.filterSection.isCollapsed .filterBody{
  display: none;
}
.filterSection.isCollapsed .filterHead .chev{
  transform: rotate(-90deg);
}

/* 날짜/입력 컨트롤 */
.controlRow{
  gap: 10px;
}
.controlRow input[type="date"],
.controlRow input[type="number"]{
  height: 42px;
  border-radius: 14px;
  border: 1px solid rgba(15,23,42,.12);
  padding: 0 12px;
  background: #fff;
  transition: box-shadow .15s ease, border-color .15s ease;
}
.controlRow input[type="date"]:focus,
.controlRow input[type="number"]:focus{
  border-color: rgba(27,123,255,.55);
  box-shadow: 0 0 0 4px rgba(27,123,255,.12);
}
.budgetRow{
  display: grid;
  grid-template-columns: 1fr auto 1fr;
  gap: 8px;
  align-items: center;
}
.budgetRow input[type="number"]{
  min-width: 0;
  width: 100%;
}
.budgetRow .tilde{
  text-align: center;
  font-weight: 900;
  color: rgba(15,23,42,.55);
}

.chipWrap{
  display: grid;
  flex-wrap: wrap;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
  margin-top: 10px;
}

.chipWrap label{
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 10px 12px;
  border-radius: 14px;
  border: 1px solid rgba(15,23,42,.12);
  background: #fff;
  font-size: 13px;
  font-weight: 900;
  color: rgba(15,23,42,.82);
  cursor: pointer;
  user-select: none;
  transition: background .12s ease, border-color .12s ease, transform .12s ease, box-shadow .12s ease;
}

.chipWrap label input[type="checkbox"]{
  appearance: none;
  -webkit-appearance: none;
  width: 18px;
  height: 18px;
  border-radius: 6px;
  border: 2px solid rgba(15,23,42,.18);
  display: grid;
  place-items: center;
  background: #fff;
  transition: background .12s ease, border-color .12s ease;
}

.chipWrap label input[type="checkbox"]::after{
  content: "✓";
  font-size: 12px;
  font-weight: 1000;
  color: #fff;
  transform: scale(0);
  transition: transform .12s ease;
}

.chipWrap label input[type="checkbox"]:checked{
  background: var(--primary);
  border-color: var(--primary);
}

.chipWrap label input[type="checkbox"]:checked::after{
  transform: scale(1);
}

.chipWrap label:has(input[type="checkbox"]:checked){
  border-color: rgba(27,123,255,.55);
  background: rgba(27,123,255,.10);
  box-shadow: 0 10px 20px rgba(27,123,255,.10);
}

.chipWrap label:hover{
  border-color: rgba(27,123,255,.35);
  background: rgba(27,123,255,.06);
  transform: translateY(-1px);
}

.priceChip{
  height: 44px;
  padding: 0 14px;
  border-radius: 14px;
  border: 1px solid rgba(15,23,42,.12);
  background: #fff;
  cursor: pointer;
  font-size: 13px;
  font-weight: 900;
  letter-spacing: -0.02em;
  color: rgba(15,23,42,.88);
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  box-shadow: 0 6px 14px rgba(15,23,42,.06);
  transition: transform .12s ease, background .12s ease, border-color .12s ease, color .12s ease, box-shadow .12s ease;
}

.priceChip:hover{
  border-color: rgba(27,123,255,.35);
  background: rgba(27,123,255,.08);
  color: #0f172a;
  transform: translateY(-1px);
  box-shadow: 0 10px 20px rgba(15,23,42,.08);
}

.priceChip.active{
  background: rgba(27,123,255,.12);
  border-color: rgba(27,123,255,.45);
  color: #0f172a;
  box-shadow: 0 12px 26px rgba(27,123,255,.18);
}

.priceChip:active{
  transform: translateY(0);
  box-shadow: 0 6px 14px rgba(15,23,42,.06);
}

.filterSection .tctH-pill{
  height: 42px !important;
  border-radius: 14px;
  font-weight: 1000;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  transition: transform .12s ease, background .12s ease, border-color .12s ease, box-shadow .12s ease;
}

.filterSection .tctH-pill:hover{
  transform: translateY(-1px);
  border-color: rgba(27,123,255,.35);
  background: rgba(27,123,255,.06);
}

.chip input{
  position: absolute;
  opacity: 0;
  pointer-events: none;
}

.chip{
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 12px;
  border-radius: 14px;
  border: 1px solid rgba(15,23,42,.12);
  background: #fff;
  cursor: pointer;
  user-select: none;
  transition: background .15s ease, border-color .15s ease, color .15s ease, transform .1s ease;
}

.chip::before{
  content:"";
  width: 18px;
  height: 18px;
  border-radius: 6px;
  border: 2px solid rgba(15,23,42,.18);
  background: #fff;
  transition: background .15s ease, border-color .15s ease;
}

.chip:has(input:checked){
  background: rgba(27,123,255,.12);
  border-color: rgba(27,123,255,.45);
  color: #0f172a;
  font-weight: 900;
}

.chip:has(input:checked)::before{
  background: #1b7bff;
  border-color: #1b7bff;
  box-shadow: inset 0 0 0 3px #fff;
}

.chip:active{ transform: translateY(1px); }

</style>

</head>

<body>
<%@ include file="/WEB-INF/views/common/tctHeader.jsp" %>
  <c:set var="ctx" value="${pageContext.request.contextPath}" />
  <c:set var="dest" value="${search.destination}" />
  <c:set var="sd" value="${search.startDate}" />
  <c:set var="ed" value="${search.endDate}" />
  <c:set var="kw" value="${search.keyword}" />
  <c:set var="ft" value="${search.filter}" />
  <c:set var="sort" value="${search.sort}" />

  <c:set var="minP" value="${search.minPrice}" />
  <c:set var="maxP" value="${search.maxPrice}" />

  <c:url var="urlPriceAsc" value="/regProdResults.do">
    <c:if test="${not empty kw}"><c:param name="keyword" value="${kw}" /></c:if>
    <c:if test="${not empty ft}"><c:param name="filter" value="${ft}" /></c:if>
    <c:if test="${not empty dest}"><c:param name="destination" value="${dest}" /></c:if>
    <c:if test="${not empty sd}"><c:param name="startDate" value="${sd}" /></c:if>
    <c:if test="${not empty ed}"><c:param name="endDate" value="${ed}" /></c:if>
    <c:if test="${not empty minP}"><c:param name="minPrice" value="${minP}" /></c:if>
    <c:if test="${not empty maxP}"><c:param name="maxPrice" value="${maxP}" /></c:if>
    
    <c:if test="${not empty selectedThemes}">
	  <c:forEach var="t" items="${selectedThemes}">
	    <c:param name="themeIds" value="${t}" />
	  </c:forEach>
    </c:if>
    
    <c:param name="sort" value="priceAsc" />
  </c:url>

  <c:url var="urlPriceDesc" value="/regProdResults.do">
    <c:if test="${not empty kw}"><c:param name="keyword" value="${kw}" /></c:if>
    <c:if test="${not empty ft}"><c:param name="filter" value="${ft}" /></c:if>
    <c:if test="${not empty dest}"><c:param name="destination" value="${dest}" /></c:if>
    <c:if test="${not empty sd}"><c:param name="startDate" value="${sd}" /></c:if>
    <c:if test="${not empty ed}"><c:param name="endDate" value="${ed}" /></c:if>
    <c:if test="${not empty minP}"><c:param name="minPrice" value="${minP}" /></c:if>
    <c:if test="${not empty maxP}"><c:param name="maxPrice" value="${maxP}" /></c:if>
    
    <c:if test="${not empty selectedThemes}">
	  <c:forEach var="t" items="${selectedThemes}">
	    <c:param name="themeIds" value="${t}" />
	  </c:forEach>
    </c:if>
    
    <c:param name="sort" value="priceDesc" />
  </c:url>

  <main class="container">
    <div class="crumbs">
      <span>홈</span><span class="sep">›</span>
      <span>전체상품</span>
    </div>

    <div class="titleRow">
      <div class="pageTitle">
        <h1>전체상품</h1>
        <div class="count">상품 <span id="count">0</span>개</div>
      </div>
      <div class="listMeta">
        <span id="filterSummary">출발 일정: 전체</span>
      </div>
    </div>

    <section class="layout">

      <form method="get" action="${ctx}/regProdResults.do" id="filterForm" style="display:contents;">

        <input type="hidden" name="keyword" value="${kw}" />
        <input type="hidden" name="filter" value="${ft}" />
        <input type="hidden" name="destination" value="${dest}" />
        <input type="hidden" name="sort" value="${sort}" />

        <aside class="filterCard">
          <div class="filterTop">
            <strong>상세 필터 🪄</strong>
          </div>

<!--           <div class="filterSearch">
            <input id="detailSearch" type="text" placeholder="상품 상세 검색" />
            <button id="detailSearchBtn" type="button" title="검색">
              <i class="fa-solid fa-magnifying-glass"></i>
            </button>
          </div> -->

          <div class="filterSection" data-section="dates">
            <button type="button" class="filterHead filterToggle" aria-expanded="true">
              <div class="label">여행 일정</div>
              <i class="fa-solid fa-chevron-down chev" aria-hidden="true"></i>
            </button>
            <div class="filterBody">
              <div class="controlRow">
                <input type="date" name="startDate" value="${sd}" />
              </div>

              <div class="filterHead" style="margin-top:10px;"><div class="label">여행 종료일</div></div>
              <div class="controlRow">
                <input type="date" name="endDate" value="${ed}" />
              </div>

              <div style="margin-top:10px; display:flex; gap:10px;">
                <button type="submit" class="tctH-pill" style="height:40px;">적용</button>
                <a class="tctH-pill" style="height:40px; display:flex; align-items:center;"
                   href="${ctx}/regProdResults.do">초기화</a>
              </div>
            </div>
          </div>

          <div class="filterSection" data-section="themes">
            <button type="button" class="filterHead filterToggle" aria-expanded="true">
              <div class="label">테마</div>
              <i class="fa-solid fa-chevron-down chev" aria-hidden="true"></i>
            </button>

            <div class="filterBody">
              <div class="chipWrap">
			  <label class="chip">
			    <input type="checkbox" name="themeIds" value="GLF"
			      <c:if test="${not empty selectedThemes and selectedThemes.contains('GLF')}">checked</c:if>>
			    <span>골프</span>
			  </label>
			
			  <label class="chip">
			    <input type="checkbox" name="themeIds" value="CUL"
			      <c:if test="${not empty selectedThemes and selectedThemes.contains('CUL')}">checked</c:if>>
			    <span>문화</span>
			  </label>
			
			  <label class="chip">
			    <input type="checkbox" name="themeIds" value="HIS"
			      <c:if test="${not empty selectedThemes and selectedThemes.contains('HIS')}">checked</c:if>>
			    <span>역사</span>
			  </label>
			  
			  <label class="chip">
			    <input type="checkbox" name="themeIds" value="LEI"
			      <c:if test="${not empty selectedThemes and selectedThemes.contains('LEI')}">checked</c:if>>
			    <span>레저</span>
			  </label>
			  
			  <label class="chip">
			    <input type="checkbox" name="themeIds" value="VAC"
			      <c:if test="${not empty selectedThemes and selectedThemes.contains('VAC')}">checked</c:if>>
			    <span>휴양</span>
			  </label>
			  
			  <label class="chip">
			    <input type="checkbox" name="themeIds" value="FOD"
			      <c:if test="${not empty selectedThemes and selectedThemes.contains('FOD')}">checked</c:if>>
			    <span>맛집</span>
			  </label>
			  
			  <label class="chip">
			    <input type="checkbox" name="themeIds" value="FES"
			      <c:if test="${not empty selectedThemes and selectedThemes.contains('FES')}">checked</c:if>>
			    <span>축제</span>
			  </label>
			  
              </div>
            </div>
          </div>

          <div class="filterSection" data-section="budget">
            <button type="button" class="filterHead filterToggle" aria-expanded="true">
              <div class="label">여행예산(만원)</div>
              <i class="fa-solid fa-chevron-down chev" aria-hidden="true"></i>
            </button>
            <div class="filterBody">
              <div class="controlRow budgetRow">
                <input type="number" name="minPrice" id="minPriceInput" min="0" step="1" placeholder="최소" value="${minP}" />
                <div class="tilde">~</div>
                <input type="number" name="maxPrice" id="maxPriceInput" min="0" step="1" placeholder="최대" value="${maxP}" />
              </div>
              <div class="chipWrap" id="priceWrap" style="margin-top:10px;">
                <button type="button" class="priceChip ${minP == 0 and maxP == 100 ? 'active' : ''}" data-min="0" data-max="100">0~100만원</button>
                <button type="button" class="priceChip ${minP == 101 and maxP == 200 ? 'active' : ''}" data-min="101" data-max="200">101~200만원</button>
                <button type="button" class="priceChip ${minP == 201 and maxP == 300 ? 'active' : ''}" data-min="201" data-max="300">201~300만원</button>
                <button type="button" class="priceChip ${minP == 301 and maxP == 400 ? 'active' : ''}" data-min="301" data-max="400">301~400만원</button>
                <button type="button" class="priceChip ${minP == 401 and maxP == 500 ? 'active' : ''}" data-min="401" data-max="500">401~500만원</button>
              </div>
              <div style="margin-top:10px; display:flex; gap:10px;">
                <button type="submit" class="tctH-pill" style="height:40px;">적용</button>
                <button type="button" class="tctH-pill" id="budgetReset" style="height:40px;">초기화</button>
              </div>
            </div>
          </div>

        </aside>

        <section>
          <div class="listHeader">
            <div class="sort" aria-label="정렬">
              <!-- ✅ 여기서는 ctx를 또 붙이지 말고 urlPriceAsc/Desc 그대로 사용 -->
              <a href="${urlPriceAsc}" class="${sort == 'priceAsc' ? 'active' : ''}">
                낮은가격순
              </a>
              <a href="${urlPriceDesc}" class="${sort == 'priceDesc' ? 'active' : ''}">
                높은가격순
              </a>
            </div>
          </div>

          <!-- 이하 regList 출력은 그대로 -->
          <div class="cards" id="cards">
          <c:if test="${empty regList}">
            <div class="card" style="grid-template-columns:1fr;">
              <div class="content">
                <h3 class="title" style="margin-bottom:6px;">조회된 상품이 없습니다.</h3>
                <div class="subTags">조건을 조정해 보세요.</div>
              </div>
            </div>
          </c:if>

          <c:forEach var="p" items="${regList}">
            <article class="card" data-href="${ctx}/regProdDetail.do?regId=${p.regId}">
              <div class="thumb">
                <c:choose>
                  <c:when test="${not empty p.imgPath}">
                    <img alt="${p.originName}" src="${ctx}${p.imgPath}">
                  </c:when>
                  <c:otherwise>
                    <img alt="reg_default.jpg" src="${ctx}/assets/images/location/reg_default.jpg">
                  </c:otherwise>
                </c:choose>
              </div>

              <div class="content">
				<div class="topline">
				    <div class="badges">
				        <span class="badge">${p.pkgId}</span>
				    </div>
				
					<div class="actions">
				    <button type="button" class="btn-wish-list" data-id="${p.regId}">
				        <span class="heart-icon">♡</span> 관심상품
				    </button>
				    <button type="button" 
				            class="shareBtn" 
				            title="공유"
				            data-title="${p.regTitle}"
				            data-url="${ctx}/regProdDetail.do?regId=${p.regId}">
				        <i class="fa-solid fa-share-nodes"></i>
				    </button>
				    </div>
				</div>

                <h3 class="title">${p.regTitle}</h3>

                <div class="subTags">
                  <div>
                    <c:if test="${not empty p.highlight}">
                      <b class="highlightText">${p.highlight}</b>
                    </c:if>
                  </div>
                  <div>
                    <c:choose>
                      <c:when test="${not empty p.descriptionA}">
                        ${p.descriptionA}
                      </c:when>
                      <c:otherwise>&nbsp;</c:otherwise>
                    </c:choose>
                  </div>
                  <div>
                    <c:choose>
                      <c:when test="${not empty p.descriptionB}">
                        ${p.descriptionB}
                      </c:when>
                      <c:otherwise>&nbsp;</c:otherwise>
                    </c:choose>
                  </div>
                </div>

                <div class="metaRow">
                  <span><b>여행기간</b> ${p.startDt} ~ ${p.endDt}</span>
                  <span style="opacity:.35">|</span>
                  <span><b>지역</b>&nbsp;${p.ctryName}&nbsp;${p.locName}</span>
                </div>

                <div class="bottomRow">
                  <%-- regPrice가 원(예: 3000000)인지 만원(예: 300)인지 혼재될 수 있어,
                       "1,000,000 이상이면 원으로 보고 /10000" 하는 안전장치(필요 없으면 제거) --%>
                  <c:set var="priceMan" value="${p.regPrice}" />
                  <c:if test="${p.regPrice >= 1000000}">
                    <c:set var="priceMan" value="${p.regPrice/10000}" />
                  </c:if>

                  <div class="price">
                    <span class="price-label">가격</span>
                    <span class="price-value">
                      <fmt:formatNumber value="${priceMan}" type="number" groupingUsed="true" maxFractionDigits="0"/>
                    </span>
                    <span class="price-unit">만원</span>
                  </div>

                  <!-- 장바구니 담기(단건) -->
                  <button type="button" class="cartBtn" data-regid="${p.regId}" title="장바구니 담기">
                    담기
                  </button>
                </div>
              </div>
            </article>
          </c:forEach>
          </div>
        </section>

      </form><!-- end form -->
    </section>
  </main>

<%@ include file="/WEB-INF/views/common/tctFooter.jsp" %>
  <!-- 토스트 -->
  <div class="tctToast" id="tctToast"></div>

<script>

  const CTX = "<%=request.getContextPath()%>";
  const IS_LOGIN = <%= (session.getAttribute("loginUser") != null) ? "true" : "false" %>;

  function showToast(msg){
    const el = document.getElementById("tctToast");
    if(!el) { alert(msg); return; }
    el.textContent = msg;
    el.classList.add("show");
    clearTimeout(showToast._t);
    showToast._t = setTimeout(()=> el.classList.remove("show"), 1600);
  }

  (function init(){
    const cards = document.querySelectorAll("#cards article.card");
    const countEl = document.getElementById("count");
    if(countEl) countEl.textContent = cards.length;

    if(IS_LOGIN) loadCurrentCart();
  })();

  /* [2] 장바구니 버튼 상태 */
  function setCartButtonState(regIds){
    // regIds: string 또는 array 모두 대응
    const set = new Set();
    if(Array.isArray(regIds)){
      regIds.forEach(x => { if(x != null) set.add(String(x).trim()); });
    }else if(regIds != null && regIds !== ""){
      set.add(String(regIds).trim());
    }

    document.querySelectorAll(".cartBtn").forEach(btn => {
      const id = (btn.dataset.regid || "").trim();
      if(set.size > 0 && set.has(id)){
        btn.classList.add("inCart");
        btn.textContent = "담김";
      }else{
        btn.classList.remove("inCart");
        btn.textContent = "담기";
      }
    });
  }

  async function loadCurrentCart(){
    try{
      const r = await fetch(CTX + "/cart/current.do");
      if(!r.ok) return;
      const data = await r.json();

      // 기대 형태:
      // 1) {loggedIn:true, regId:"..."} (단건)
      // 2) {loggedIn:true, regIds:[...]} (다건)
      if(data && data.loggedIn){
        setCartButtonState(data.regIds || data.regId);
      }
    }catch(err){
      console.error("장바구니 로딩 실패:", err);
    }
  }

  /* [3] 클릭 이벤트 통합 */
  document.addEventListener("click", async (e) => {

    // A) 공유
    const shareBtn = e.target.closest(".shareBtn");
    if(shareBtn){
      e.preventDefault();
      e.stopPropagation();

      const title = shareBtn.dataset.title || document.title;
      const url = new URL(shareBtn.dataset.url || location.href, location.origin).toString();

      try{
        if(navigator.share){
          await navigator.share({ title, url });
          return;
        }
        await navigator.clipboard.writeText(url);
        showToast("링크가 복사되었습니다!");
      }catch(err){
        // clipboard 막힌 환경 대비
        const ta = document.createElement("textarea");
        ta.value = url;
        document.body.appendChild(ta);
        ta.select();
        document.execCommand("copy");
        ta.remove();
        showToast("링크가 복사되었습니다!");
      }
      return;
    }

    // B) 장바구니 담기
    const cartBtn = e.target.closest(".cartBtn");
    if(cartBtn){
      e.preventDefault();
      e.stopPropagation();

      if(!IS_LOGIN){
        alert("로그인이 필요한 서비스입니다. 로그인 페이지로 이동합니다.");
        const here = location.pathname + location.search + location.hash; location.href = CTX + "/login.do?returnUrl=" + encodeURIComponent(here); return;
      }

      const regId = (cartBtn.dataset.regid || "").trim();
      
      // ✅ 이미 담긴 상태(버튼에 inCart 클래스가 붙어있음)라면 "제거" 플로우로 보냄
      // 존재이유: 두 번 누르면 add가 아니라 remove confirm → 실제 삭제가 되게 하려는 목적
      if(cartBtn.classList.contains("inCart")){
        if(!confirm("장바구니에서 제거 하시겠습니까?")) return;

        try{
          // ✅ 서버에 AJAX 모드로 삭제 요청 (ajax=Y면 JSON 응답)
          const params = new URLSearchParams({ ajax: "Y", regId: regId });

          const resp = await fetch(CTX + "/cart/remove.do", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8" },
            body: params
          });

          if(!resp.ok) throw new Error("서버 응답 오류");

          const data = await resp.json();

          if(data.ok){
            // ✅ 장바구니가 비었으니 모든 버튼을 "담기" 상태로 되돌림
            // (이 함수가 실행되면 wish 스크립트가 자동으로 initWish() 재호출하도록 되어있음)
            setCartButtonState(null);
            showToast("장바구니에서 제거했습니다.");
          }else if(data.code === "NEED_LOGIN"){
            // ✅ 세션 만료 같은 케이스에서 로그인으로 보내기 위함
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
        return; // ✅ 제거 플로우 끝났으니 add 플로우로 내려가지 않게 종료
      }


      const postCart = async (forceYN) => {
        const params = new URLSearchParams({ regId, force: forceYN, peopleCnt: "1" });
        const resp = await fetch(CTX + "/cart/add.do", {
          method: "POST",
          headers: { "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8" },
          body: params
        });
        if(!resp.ok) throw new Error("서버 응답 오류");
        return resp.json();
      };

      try{
        let data = await postCart("N");

        // 기대 형태:
        // - 성공: {ok:true, regId:"..."} 또는 {ok:true, regIds:[...]}
        // - 충돌: {ok:false, code:"CONFLICT", msg:"..."}
        if(data.ok){
          setCartButtonState(data.regIds || data.regId);
          showToast("장바구니에 상품을 담았습니다.");
        }else if(data.code === "CONFLICT"){
          if(confirm(data.msg || "이미 담긴 상품이 있습니다. 교체할까요?")){
            data = await postCart("Y");
            if(data.ok){
              setCartButtonState(data.regIds || data.regId);
              showToast("상품이 교체되었습니다.");
            }
          }
        }else{
          alert(data.msg || "장바구니 처리에 실패했습니다.");
        }
      }catch(err){
        console.error(err);
        alert("장바구니 처리 중 오류가 발생했습니다.");
      }
      return;
    }

    // C) 카드 클릭 → 상세 이동
    const card = e.target.closest("#cards article.card");
    if(card){
      // 카드 내부 버튼 눌렀을 때는 이동 금지
      if(e.target.closest(".shareBtn") || e.target.closest(".cartBtn")|| e.target.closest(".btn-wish-list") ||e.target.closest(".btn-wish")) return;

    

      const href = card.dataset.href;
      if(href) location.href = href;
    }
  });

  /* [4] 정렬 버튼 active 표시(서버 이동은 그대로) */
  document.querySelectorAll(".sort a").forEach(a=>{
    a.addEventListener("click", ()=>{
      document.querySelectorAll(".sort a").forEach(x=> x.classList.remove("active"));
      a.classList.add("active");
    });
  });
  
</script>
  
<script>
/* ===== wish(관심상품) 전용 ===== */
(function(){
  if(window.__wishBound) return;
  window.__wishBound = true;

  const getCTX = () => (typeof CTX !== "undefined" ? CTX : "<%=request.getContextPath()%>");
  const isLogin = () => (typeof IS_LOGIN !== "undefined" ? IS_LOGIN : false);

  function toast(msg){
    if(typeof showToast === "function") showToast(msg);
    else alert(msg);
  }

//✅ wish 버튼을 장바구니 상태에 따라 렌더링
  function updateWishButton(btn, wished, inCart){
    if(!btn) return;
    
    if(inCart){
      // 장바구니에 담긴 상품 = wish 버튼 회색
      btn.classList.remove("on");
      btn.dataset.inCart = "true";
      btn.style.opacity = "0.5";
      btn.style.background = "#999";
      btn.style.borderColor = "#999";
      btn.style.color = "#fff";
      // btn.style.cursor = "not-allowed";  // ❌ 이 줄 삭제!
      btn.innerHTML = '<span class="heart-icon">✓</span> ♥관심상품';
    }else{
      // 장바구니에 없는 상품 = wish 정상 활성화
      btn.dataset.inCart = "false";
      btn.style.opacity = "1";
      btn.style.background = "";
      btn.style.borderColor = "";
      btn.style.color = "";
      btn.style.cursor = "pointer";  // ✅ 이건 유지해도 됨
      
      if(wished){
        btn.classList.add("on");
        btn.innerHTML = '<span class="heart-icon">♥</span> 관심상품';
      }else{
        btn.classList.remove("on");
        btn.innerHTML = '<span class="heart-icon">♡</span> 관심상품';
      }
    }
  }

  // ✅ 페이지 로드: 장바구니 상태 확인 후 wish 업데이트
  async function initWish(){
    try{
      // 장바구니 상태 먼저 가져오기
      const cartR = await fetch(getCTX() + "/cart/current.do");
      const cartData = cartR.ok ? await cartR.json() : {};
      const cartSet = new Set();
      if(cartData.regIds){
        cartData.regIds.forEach(x => cartSet.add(String(x).trim()));
      }else if(cartData.regId){
        cartSet.add(String(cartData.regId).trim());
      }

      // wish 상태 가져오기
      const wishR = await fetch(getCTX() + "/wish/ids.do");
      const wishData = wishR.ok ? await wishR.json() : {};
      const wishSet = new Set((wishData.ids || []).map(x => String(x).trim()));

      // 모든 wish 버튼 업데이트
      document.querySelectorAll(".btn-wish-list").forEach(btn=>{
        const id = (btn.dataset.id || "").trim();
        const inCart = cartSet.has(id);
        const wished = wishSet.has(id);
        updateWishButton(btn, wished, inCart);
      });
    }catch(err){
      console.log("initWish error:", err);
    }
  }

  if(isLogin()) initWish();
  window.addEventListener("pageshow", (e) => {
	    if(e.persisted && isLogin()){
	      loadCurrentCart();  // 장바구니 버튼 상태 새로 로드
	      initWish();         // wish 버튼 상태 새로 로드
	    }
	  });

  // ✅ 장바구니 담기 후 wish 버튼 다시 업데이트
  const originalSetCartButtonState = window.setCartButtonState;
  if(originalSetCartButtonState){
    window.setCartButtonState = function(regIds){
      originalSetCartButtonState.call(this, regIds);
      
      // 장바구니 상태 변경됐으니 wish 다시 로드
      if(isLogin()) initWish();
    };
  }

  // ✅ wish 클릭 핸들러
  document.addEventListener("click", async function(e){
    const btn = e.target.closest(".btn-wish-list");
    if(!btn) return;

    e.stopPropagation();
    e.preventDefault();

    if(!isLogin()){
      alert("로그인이 필요한 서비스입니다. 로그인 페이지로 이동합니다.");
      const here = location.pathname + location.search + location.hash;
      location.href = getCTX() + "/login.do?returnUrl=" + encodeURIComponent(here);
      return;
    }

    // ✅ 장바구니에 담긴 상품이면 클릭 막기
    if(btn.dataset.inCart === "true"){
        toast("이미 장바구니에 담긴 상품입니다.");
        return;
      }

    const regId = (btn.dataset.id || "").trim();
    if(!regId){
      alert("상품 ID가 없습니다.");
      return;
    }

    try{
      const params = new URLSearchParams({ regId });
      const r = await fetch(getCTX() + "/wish/toggle.do", {
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

      // 장바구니 상태 유지하면서 wish만 업데이트
      const cartBtn = document.querySelector(`.cartBtn[data-regid="${regId}"]`);
      const inCart = cartBtn && cartBtn.classList.contains("inCart");
      updateWishButton(btn, data.wished, inCart);
      
      toast(data.wished ? "관심상품에 등록되었습니다." : "관심상품이 취소되었습니다.");
    }catch(err){
      console.log(err);
      alert("관심상품 처리 중 오류가 발생했습니다.");
    }
  });
})();

(function(){
	  const form = document.getElementById("filterForm");
	  if(!form) return;

	  let timer = null;

	  form.addEventListener("change", function(e){
	    if(e.target.name === "themeIds"){
	      clearTimeout(timer);
	      timer = setTimeout(() => {
	        form.submit();
	      }, 150); // 연속 클릭 방지
	    }
	  });
	})();

(function(){
  const form = document.getElementById("filterForm");
  if(!form) return;

  const btnReset = document.getElementById("budgetReset");
  const minEl = document.getElementById("minPriceInput");
  const maxEl = document.getElementById("maxPriceInput");
  const wrap = document.getElementById("priceWrap");

  if(btnReset){
    btnReset.addEventListener("click", () => {
      if(minEl) minEl.value = "";
      if(maxEl) maxEl.value = "";
      form.submit();
    });
  }

  if(wrap){
    wrap.addEventListener("click", (e) => {
      const btn = e.target.closest(".priceChip");
      if(!btn) return;

      const min = btn.dataset.min;
      const max = btn.dataset.max;
      if(!min || !max) return;

      wrap.querySelectorAll(".priceChip").forEach(b => b.classList.remove("active"));
      btn.classList.add("active");

      if(minEl) minEl.value = min;
      if(maxEl) maxEl.value = max;

      form.submit();
    });
  }
})();

(function(){
  const sections = document.querySelectorAll(".filterSection[data-section]");
  if(!sections.length) return;

  const key = "TCT_FILTER_SECTIONS";
  let state = {};
  try{
    state = JSON.parse(sessionStorage.getItem(key) || "{}");
  }catch(e){ state = {}; }

  sections.forEach(sec => {
    const name = sec.getAttribute("data-section");
    const toggle = sec.querySelector(".filterToggle");
    if(!toggle) return;

    const isCollapsed = state[name] === "0";
    if(isCollapsed){
      sec.classList.add("isCollapsed");
      toggle.setAttribute("aria-expanded", "false");
    }

    toggle.addEventListener("click", () => {
      const nowCollapsed = sec.classList.toggle("isCollapsed");
      toggle.setAttribute("aria-expanded", nowCollapsed ? "false" : "true");
      state[name] = nowCollapsed ? "0" : "1";
      sessionStorage.setItem(key, JSON.stringify(state));
    });
  });
})();
</script>
</body>
</html>
