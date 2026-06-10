<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ page import="java.util.Map" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>
<%@ page import="kr.or.ddit.tct.util.MyBatisUtil" %>
<%@ page import="kr.or.ddit.tct.users.vo.UserVO" %>

<c:set var="CTX" value="${pageContext.request.contextPath}" />

<%
  // ✅ 장바구니 요약: wish.jsp에서 직접 조회 (cart 파일 수정 없이)
  // 헤더(tctHeader.jsp)와 변수명 충돌 방지: loginUser2
  UserVO loginUser2 = (UserVO) session.getAttribute("loginUser");
  Map<String,Object> cartSum = null;

  if (loginUser2 != null) {
    SqlSession ss = null;
    try {
      ss = MyBatisUtil.getSqlSession();
      cartSum = ss.selectOne("wish.selectCartSummary", loginUser2.getUserId());
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      if (ss != null) ss.close();
    }
  }
  request.setAttribute("cartSum", cartSum);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>TryCatchTrip - 관심상품</title>

<style>
:root {
  --max: 1200px;
  --padX: 16px;
  --gap: 24px;
  --r: 14px;
  --bg: #f6f8ff;
  --card: #ffffff;
  --ink: #0f172a;
  --muted: #64748b;
  --line: rgba(15, 23, 42, .10);
  --primary: #1b7bff;
  --primary-dark: #1565d8;
  --danger: #ff4d4d;
  --shadow: 0 10px 30px rgba(15, 23, 42, .08);
}
*{ box-sizing:border-box; }
body{
  margin:0;
  font-family: system-ui, -apple-system, "Noto Sans KR", sans-serif;
  color: var(--ink);
  background: var(--bg);
}
a{ color:inherit; text-decoration:none; }
button, input, select { font:inherit; }
button{ cursor:pointer; }

main{
  max-width: var(--max);
  margin: 40px auto;
  padding: 0 var(--padX);
}
.page-title{
  font-size: 28px;
  font-weight: 800;
  margin: 0 0 30px;
  letter-spacing: -0.8px;
}

/* 좌 넓게 / 우 작게 */
.layout{
  display:grid;
  grid-template-columns: 1fr 260px;
  gap: var(--gap);
  align-items:start;
}
@media (max-width:960px){
  .layout{ grid-template-columns:1fr; }
}

/* 도구 모음 */
.tools{
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:12px;
  flex-wrap:wrap;
  margin-bottom:16px;
  padding:16px;
  background:var(--card);
  border:1px solid var(--line);
  border-radius:var(--r);
}
.tools-left{
  display:flex;
  align-items:center;
  gap:10px;
  font-size:13px;
  font-weight:800;
  color:var(--muted);
}
.tools-left input[type="checkbox"]{ width:16px; height:16px; cursor:pointer; }
.tools-right{ display:flex; gap:10px; flex-wrap:wrap; }

.sort-btn{
  height:36px;
  padding:0 12px;
  border-radius:999px;
  border:1px solid var(--line);
  background:#fff;
  font-size:13px;
  font-weight:800;
  color:var(--muted);
  transition: all .12s ease;
}
.sort-btn:hover{
  border-color: rgba(27,123,255,.35);
  color: var(--primary);
  background: rgba(27,123,255,.06);
}
.sort-btn.danger{ border-color: rgba(255,77,77,.35); color: var(--danger); }
.sort-btn.danger:hover{ background: rgba(255,77,77,.08); }

/* 목록 */
.wish-list{ display:flex; flex-direction:column; gap:16px; }
.wish-item{
  background:var(--card);
  border:1px solid var(--line);
  border-radius:var(--r);
  padding:20px;
  display:grid;
  grid-template-columns: 26px 160px 1fr 140px;
  gap:20px;
  align-items:flex-start;
  box-shadow: var(--shadow);
  transition: all .12s ease;
}
.wish-item:hover{
  border-color: rgba(27,123,255,.2);
  box-shadow: 0 14px 34px rgba(27,123,255,.1);
}

/* ✅ 선택됨/담김 카드만 배경색 변경 */
.wish-item.is-selected{
  background:#f3f8ff;
  border-color: rgba(27,123,255,.28);
}
.wish-item.is-added{
  background: rgba(27,123,255,.12);
  border-color: rgba(27,123,255,.45);
}
.wish-item.is-added.is-selected{
  background: rgba(27,123,255,.16);
}

.wish-check{ display:flex; align-items:center; justify-content:center; padding-top:6px; }
.wish-check input{ width:18px; height:18px; cursor:pointer; }

.wish-thumb{
  width:160px;
  height:110px;
  border-radius:12px;
  object-fit:cover;
  background:#eaf1ff;
  display:block;
}

.wish-info{ display:flex; flex-direction:column; gap:12px; min-width:0; padding-top:2px; }
.wish-title{ font-size:17px; font-weight:950; margin:0; line-height:1.3; word-break:break-word; }
.wish-meta-section{ display:flex; flex-direction:column; gap:6px; }
.wish-meta{ font-size:14px; color:var(--muted); font-weight:700; margin:0; line-height:1.4; }

.wish-actions{
  display:flex;
  flex-direction:column;
  align-items:flex-end;
  gap:10px;
  white-space:nowrap;
  padding-top:6px;
}
.wish-price{ font-size:17px; font-weight:950; color:var(--primary); }
.action-btns{ display:flex; gap:8px; }

.mini-btn{
  height:36px;
  padding:0 12px;
  border-radius:10px;
  border:1px solid var(--line);
  background:#fff;
  font-weight:900;
  font-size:13px;
  transition: all .12s ease;
  white-space:nowrap;
}
.mini-btn:hover{ transform: translateY(-1px); }
.mini-btn.cart{ border-color: rgba(27,123,255,.35); color: var(--primary); }
.mini-btn.cart:hover{ background: rgba(27,123,255,.08); }
.mini-btn.del{ border-color: rgba(255,77,77,.35); color: var(--danger); }
.mini-btn.del:hover{ background: rgba(255,77,77,.08); }

/* ✅ 담김 표시(버튼 파란색) */
.mini-btn.cart.is-added{
  background: var(--primary);
  border-color: var(--primary);
  color: #fff;
}
.mini-btn.cart.is-added:hover{
  background: var(--primary-dark);
  border-color: var(--primary-dark);
}

/* 빈 상태 */
.empty-box{
  text-align:center;
  padding:80px 20px;
  background:var(--card);
  border:1px solid var(--line);
  border-radius:var(--r);
  box-shadow:var(--shadow);
}
.empty-box h2{ margin:0 0 12px; font-weight:900; font-size:20px; }
.empty-box a{ color:var(--primary); font-weight:800; }
.empty-box a:hover{ text-decoration:underline; }

/* 우측 카드 */
.side-stack{
  position: sticky;
  top: 120px;
  display:flex;
  flex-direction:column;
  gap:12px;
}
@media (max-width:960px){ .side-stack{ position: static; top:auto; } }

.side-card{
  background:var(--card);
  border:1px solid var(--line);
  border-radius:var(--r);
  padding:14px;
  box-shadow:var(--shadow);
  width:100%;
}

/* ✅ 타이틀 + 옆 버튼(작게) */
.side-head{
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:10px;
  margin:0 0 10px;
  padding-bottom:10px;
  border-bottom:1px solid rgba(15,23,42,.12);
}
.side-title{
  font-size:15px;
  font-weight:950;
  margin:0;
}
.btn-go-cart-sm{
  height:28px;
  padding:0 10px;
  border-radius:10px;
  border:1px solid rgba(27,123,255,.35);
  background: rgba(27,123,255,.08);
  color: var(--primary);
  font-weight:900;
  font-size:12px;
  white-space:nowrap;
}
.btn-go-cart-sm:hover{ background: rgba(27,123,255,.14); }

.side-row{
  display:flex;
  justify-content:space-between;
  gap:10px;
  padding:8px 0;
  border-bottom:1px dashed rgba(15,23,42,.10);
  font-size:12px;
  font-weight:800;
  color:var(--muted);
}
.side-row:last-child{ border-bottom:0; }
.side-row b{ color:var(--ink); font-weight:900; text-align:right; word-break:break-word; }

/* 장바구니 요약 */
.cart-mini-box{ display:flex; gap:10px; align-items:flex-start; }
.cart-mini-thumb{
  width:86px;
  height:62px;
  border-radius:10px;
  object-fit:cover;
  background:#eaf1ff;
  flex-shrink:0;
}
.cart-mini-meta{
  flex:1;
  min-width:0;
  display:flex;
  flex-direction:column;
  gap:6px;
  font-size:12px;
  font-weight:800;
  color:var(--muted);
}
.cart-mini-title{
  color:var(--ink);
  font-weight:950;
  line-height:1.2;
  display:-webkit-box;
  -webkit-line-clamp:2;
  -webkit-box-orient:vertical;
  overflow:hidden;
}
.cart-mini-line{ display:flex; gap:6px; line-height:1.2; }
.cart-mini-line b{ color:var(--ink); font-weight:900; }

/* 토스트(상단) */
.toast{
  position:fixed;
  left:50%;
  top:110px;
  transform: translateX(-50%);
  background: rgba(15,23,42,.92);
  color:#fff;
  padding:12px 16px;
  border-radius:999px;
  font-size:13px;
  font-weight:800;
  opacity:0;
  pointer-events:none;
  transition: opacity .2s ease;
  z-index:99999;
}
.toast.show{ opacity:1; }

@media (max-width:720px){
  .wish-item{ grid-template-columns: 26px 1fr; padding:16px; gap:16px; }
  .wish-thumb{ grid-column:1/-1; width:100%; height:150px; }
  .wish-info{ grid-column:1/-1; gap:10px; }
  .wish-actions{
    grid-column:1/-1;
    flex-direction:row;
    justify-content:space-between;
    align-items:center;
    white-space:normal;
    margin-top:8px;
    padding-top:0;
  }
  .wish-title{ font-size:15px; }
  .wish-meta{ font-size:13px; }
  .mini-btn{ height:32px; font-size:12px; padding:0 10px; }
  .tools{ flex-direction:column; align-items:flex-start; }
  .tools-right{ width:100%; }
  .sort-btn{ font-size:12px; padding:0 10px; }
}

.sort-btn.is-active{
  border-color: rgba(27,123,255,.55);
  color: var(--primary);
  background: rgba(27,123,255,.12);
}
</style>
</head>

<body>
  <%@ include file="/WEB-INF/views/common/tctHeader.jsp" %>

  <main>
    <h1 class="page-title">관심상품</h1>

    <div class="layout">
      <!-- ===== 왼쪽 ===== -->
      <div>
        <c:choose>
          <c:when test="${empty wishList}">
            <div class="empty-box">
              <h2>관심상품이 비어 있습니다.</h2>
              <a href="${CTX}/regProdResults.do">상품 보러 가기</a>
            </div>
          </c:when>

          <c:otherwise>
            <div class="tools">
              <div class="tools-left">
                <input type="checkbox" id="chkAll">
                <span>전체 선택</span>
                <span>선택 <b id="selCount">0</b>개 / 총 <b id="wishCount">0</b>개</span>
                <button type="button" class="sort-btn danger" id="btnDelSelected">선택 삭제</button>
              </div>
              <div class="tools-right">
                <button type="button" class="sort-btn" id="sortRecent">최근 저장순</button>
                <button type="button" class="sort-btn" id="sortLow">가격 낮은순</button>
                <button type="button" class="sort-btn" id="sortHigh">가격 높은순</button>
              </div>
            </div>
<div class="empty-box" id="emptyFiltered" style="display:none;">
  <h2>관심상품이 비어 있습니다.</h2>
  <div style="margin:0 0 12px; color:var(--muted); font-weight:800; font-size:13px;">
    장바구니에 담긴 상품은 목록에서 숨김 처리됩니다.
  </div>
  <a href="${CTX}/regProdResults.do">상품 보러 가기</a>
</div>

            <div class="wish-list" id="wishGrid">
              <c:forEach var="w" items="${wishList}">
                <article class="wish-item card" data-regid="${w.REG_ID}" data-price="${w.REG_PRICE}">
                  <div class="wish-check">
                    <input type="checkbox" class="chkItem" value="${w.REG_ID}">
                  </div>

                  <!-- ✅ 사진 클릭 시 상세 이동 -->
                  <a href="${CTX}/regProdDetail.do?regId=${w.REG_ID}" aria-label="상품 상세로 이동">
                    <img
                      src="${CTX}${not empty w.IMG_PATH ? w.IMG_PATH : '/assets/images/location/reg_default.jpg'}"
                      class="wish-thumb"
                      alt="상품 이미지"
                    >
                  </a>

                  <div class="wish-info">
                    <h3 class="wish-title">${w.REG_TITLE}</h3>
                    <div class="wish-meta-section">
                      <p class="wish-meta">
                        📅
                        <fmt:formatDate value="${w.START_DT}" pattern="yyyy-MM-dd" />
                        ~
                        <fmt:formatDate value="${w.END_DT}" pattern="yyyy-MM-dd" />
                      </p>
                      <p class="wish-meta">📍 ${w.CTRY_NAME}, ${w.LOC_NAME}</p>
                    </div>
                  </div>

                  <div class="wish-actions">
                    <div class="wish-price">
                      <fmt:formatNumber value="${w.REG_PRICE}" type="number"/>원
                    </div>
                    <div class="action-btns">
                      <button type="button" class="mini-btn cart" data-act="cart" data-regid="${w.REG_ID}">담기</button>
                      <button type="button" class="mini-btn del"  data-act="del"  data-regid="${w.REG_ID}">삭제</button>
                    </div>
                  </div>
                </article>
              </c:forEach>
            </div>
          </c:otherwise>
        </c:choose>
      </div>

      <!-- ===== 오른쪽 ===== -->
      <aside class="side-stack">

        <!-- ✅ 장바구니 요약을 위로 -->
        <section class="side-card" id="cartSummary">
          <div class="side-head">
            <h2 class="side-title">장바구니 요약</h2>
            <button type="button" class="btn-go-cart-sm" id="btnGoCart">장바구니 이동</button>
          </div>

          <!-- map 키 대문자/카멜케이스 대응 -->
          <c:set var="cs" value="${cartSum}" />
          <c:set var="csCnt"   value="${empty cs['CNT'] ? cs['cnt'] : cs['CNT']}" />
          <c:set var="csRegId" value="${empty cs['REG_ID'] ? cs['regId'] : cs['REG_ID']}" /> 
          <c:set var="csTitle" value="${empty cs['TITLE'] ? cs['title'] : cs['TITLE']}" />
          <c:set var="csImg"   value="${empty cs['IMG_PATH'] ? cs['imgPath'] : cs['IMG_PATH']}" />
          <c:set var="csStart" value="${empty cs['START_YMD'] ? cs['startYmd'] : cs['START_YMD']}" />
          <c:set var="csEnd"   value="${empty cs['END_YMD'] ? cs['endYmd'] : cs['END_YMD']}" />
          <c:set var="csPrice" value="${empty cs['PRICE'] ? cs['price'] : cs['PRICE']}" />

          <div id="cartEmpty"
               style="${not empty csCnt && csCnt ne 0 ? 'display:none;' : ''} font-size:12px; font-weight:800; color:var(--muted);">
            장바구니가 비어 있습니다.
          </div>

          <div class="cart-mini-box" id="cartBox" style="${not empty csCnt && csCnt ne 0 ? '' : 'display:none;'}">
            <img id="cartThumb" class="cart-mini-thumb"
                 src="${CTX}${empty csImg ? '/assets/images/location/reg_default.jpg' : csImg}"
                 alt="장바구니 상품 이미지">

            <div class="cart-mini-meta">
              <div class="cart-mini-title" id="cartTitle">${empty csTitle ? '-' : csTitle}</div>
              <div class="cart-mini-line">📅 <b id="cartDate">${empty csStart ? '-' : csStart} ~ ${empty csEnd ? '-' : csEnd}</b></div>
              <div class="cart-mini-line">💰 <b id="cartPrice">
                <c:choose>
                  <c:when test="${not empty csPrice}">
                    <fmt:formatNumber value="${csPrice}" type="number"/>원
                  </c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </b></div>
            </div>
          </div>
        </section>

        <!-- ✅ 상품 요약을 아래로 -->
        <section class="side-card">
          <div class="side-head">
            <h2 class="side-title">선택 상품</h2>
            <span style="font-size:12px; font-weight:800; color:var(--muted);">체크 1개 권장</span>
          </div>
          <div class="side-row"><span>일정</span><b id="sumDate">-</b></div>
          <div class="side-row"><span>목적지</span><b id="sumDest">-</b></div>
          <div class="side-row"><span>숙박</span><b id="sumStay">-</b></div>
          <div class="side-row"><span>금액</span><b id="sumPrice">-</b></div>
        </section>

      </aside>
    </div>
  </main>

  <div class="toast" id="wishToast"></div>
    <%@ include file="/WEB-INF/views/common/tctFooter.jsp" %>

<script>
(function(){
  const CTX = "${CTX}";
  const IS_LOGIN = <%= (session.getAttribute("loginUser") != null) ? "true" : "false" %>;

  // ✅ 서버에서 내려온 “현재 장바구니 regId” (없으면 빈값)
  let currentCartRegId = "${csRegId}";
  if (!currentCartRegId || currentCartRegId === "null") currentCartRegId = "";

  function showToast(msg) {
    const el = document.getElementById("wishToast");
    if(!el) { alert(msg); return; }
    el.textContent = msg;
    el.classList.add("show");
    clearTimeout(showToast._t);
    showToast._t = setTimeout(() => el.classList.remove("show"), 1600);
  }

  // ✅ "3박 4일"만 표시
  function calcStay(startYmd, endYmd){
    if(!startYmd || !endYmd) return "-";
    const s = new Date(startYmd + "T00:00:00");
    const e = new Date(endYmd + "T00:00:00");
    const diffMs = e - s;
    if (isNaN(diffMs)) return "-";
    const nights = Math.round(diffMs / (1000*60*60*24));
    if (nights < 0) return "-";
    if (nights === 0) return "0박 1일";
    return nights + "박 " + (nights + 1) + "일";
  }

  // ✅ 날짜 파싱 강화
  function extractDates(text){
    const arr = String(text || "").match(/\d{4}-\d{2}-\d{2}/g);
    if(!arr || arr.length < 2) return null;
    return { start: arr[0], end: arr[1] };
  }

  // ====== ✅ “보이는 카드만” 대상으로 집계/선택 ======
  function getAllCards(){
    return Array.from(document.querySelectorAll("#wishGrid .wish-item.card"));
  }
  function isHidden(card){
    return !card || card.style.display === "none";
  }
  function getVisibleCards(){
    return getAllCards().filter(c => !isHidden(c));
  }
  function getVisibleChecked(){
    return Array.from(document.querySelectorAll(".chkItem:checked"))
      .filter(chk => {
        const card = chk.closest(".card");
        return card && !isHidden(card);
      });
  }

  // ✅ 장바구니에 있는 regId는 관심상품 목록에서 숨김(교체/취소 시 다시 노출)
  function applyCartFilter(){
    getAllCards().forEach(card => {
      const regid = (card.dataset.regid || "").trim();
      const shouldHide = (currentCartRegId && regid === currentCartRegId);

      if(shouldHide){
        const chk = card.querySelector(".chkItem");
        if(chk) chk.checked = false;
        card.classList.remove("is-selected");
        card.style.display = "none";
      }else{
        card.style.display = "";
      }
    });

    updateCounts();
    updateSummary();
    syncSelectedCards();
    updateEmptyState();
  }

  function updateEmptyState(){
    const emptyEl = document.getElementById("emptyFiltered");
    const toolsEl = document.querySelector(".tools");
    const gridEl  = document.getElementById("wishGrid");
    if(!emptyEl || !gridEl) return;

    const hasVisible = getVisibleCards().length > 0;

    emptyEl.style.display = hasVisible ? "none" : "block";
    if (toolsEl) toolsEl.style.display = hasVisible ? "" : "none";
    gridEl.style.display  = hasVisible ? "" : "none";
  }

  function updateCounts() {
    const grid = document.getElementById("wishGrid");
    if(!grid) return;

    const visibleCards = getVisibleCards();
    const total = visibleCards.length;

    const selected = visibleCards.reduce((acc, card) => {
      const chk = card.querySelector(".chkItem");
      return acc + (chk && chk.checked ? 1 : 0);
    }, 0);

    const wishCountEl = document.getElementById("wishCount");
    const selCountEl  = document.getElementById("selCount");
    const chkAllEl    = document.getElementById("chkAll");

    if (wishCountEl) wishCountEl.textContent = total;
    if (selCountEl)  selCountEl.textContent  = selected;

    if (chkAllEl) {
      chkAllEl.indeterminate = (selected > 0 && selected < total);
      chkAllEl.checked = (selected === total && total > 0);
    }
  }

  function updateSummary() {
	  // ✅ 1) 먼저 요소를 잡아야 합니다(아직 없는데 closest 쓰면 에러)
	  const dateEl  = document.getElementById("sumDate");
	  const destEl  = document.getElementById("sumDest");
	  const stayEl  = document.getElementById("sumStay");
	  const priceEl = document.getElementById("sumPrice");
	  if(!dateEl || !destEl || !stayEl || !priceEl) return;

	  // ✅ 2) 행(row) / 라벨(label) 참조
	  const dateRow  = dateEl.closest(".side-row");
	  const destRow  = destEl.closest(".side-row");
	  const stayRow  = stayEl.closest(".side-row");
	  const priceRow = priceEl.closest(".side-row");

	  const dateLbl  = dateRow  ? dateRow.querySelector("span")  : null;
	  const destLbl  = destRow  ? destRow.querySelector("span")  : null;
	  const stayLbl  = stayRow  ? stayRow.querySelector("span")  : null;
	  const priceLbl = priceRow ? priceRow.querySelector("span") : null;

	  // [왜] 다중→단일로 돌아올 때 라벨이 바뀐 채로 남으면 UX가 깨짐
	  // [역할] 기본 라벨로 원복
	  const resetLabels = () => {
	    if (dateLbl)  dateLbl.textContent  = "일정";
	    if (destLbl)  destLbl.textContent  = "목적지";
	    if (stayLbl)  stayLbl.textContent  = "숙박";
	    if (priceLbl) priceLbl.textContent = "금액";
	  };

	  // [왜] 다중 선택에서 숨긴 행을 다시 보여줘야 함
	  // [역할] 숨김 해제
	  const showAllRows = () => {
	    if (dateRow)  dateRow.style.display  = "";
	    if (destRow)  destRow.style.display  = "";
	    if (stayRow)  stayRow.style.display  = "";
	    if (priceRow) priceRow.style.display = "";
	  };

	  const checks = getVisibleChecked();

	  // ✅ 선택 0개: 전부 기본으로
	  if (checks.length === 0) {
	    showAllRows();
	    resetLabels();
	    dateEl.textContent  = "-";
	    destEl.textContent  = "-";
	    stayEl.textContent  = "-";
	    priceEl.textContent = "-";
	    return;
	  }

	  // ✅ 선택 2개 이상: 일정/숙박 행 숨기고, "목적지"를 "선택 상품"으로 바꾸기
	  if (checks.length > 1) {
	    let sum = 0;
	    checks.forEach(chk => sum += Number(chk.closest(".card")?.dataset?.price || 0));

	    if (dateRow) dateRow.style.display = "none";
	    if (stayRow) stayRow.style.display = "none";
	    if (destRow) destRow.style.display = "";
	    if (priceRow) priceRow.style.display = "";

	    if (destLbl) destLbl.textContent = "선택 상품"; // 원하시면 "선택"으로 변경 가능

	    dateEl.textContent  = "-";
	    stayEl.textContent  = "-";
	    destEl.textContent  = checks.length + "개 선택됨";
	    priceEl.textContent = sum.toLocaleString() + "원";
	    return;
	  }

	  // ✅ 선택 1개: 다시 기본 라벨/행으로 원복하고 상세 표시
	  showAllRows();
	  resetLabels();

	  const card = checks[0].closest(".card");
	  if (!card) return;

	  const dateText = card.querySelector(".wish-meta-section .wish-meta")?.textContent || "";
	  const destText = card.querySelector(".wish-meta-section .wish-meta:last-child")?.textContent || "";
	  const price    = Number(card.dataset.price || 0);

	  const ds = extractDates(dateText);
	  const stay = ds ? calcStay(ds.start, ds.end) : "-";

	  dateEl.textContent  = dateText.replace("📅", "").trim();
	  destEl.textContent  = destText.replace("📍", "").trim();
	  stayEl.textContent  = stay;
	  priceEl.textContent = price.toLocaleString() + "원";
	}


  // ✅ 체크 상태에 따라 카드 클래스 동기화
  function syncSelectedCards(){
    document.querySelectorAll("#wishGrid .wish-item.card").forEach(card => {
      if(isHidden(card)) return;
      const checked = card.querySelector(".chkItem")?.checked;
      card.classList.toggle("is-selected", !!checked);
    });
  }

  /* =========================
   * ✅ 정렬(최근/낮은/높은) - 최소 수정 버전
   * =========================
   * [왜] gridEl/initialNodes를 공용으로 만들어야 정렬 버튼에서 재사용 가능
   * [무슨 기능] wishGrid DOM을 잡고, 처음 카드 순서를 저장해서 “최근 저장순(원래 순서)” 복원이 가능
   */
   
   
//[왜] 어떤 정렬이 적용 중인지 버튼 색으로 표시하기 위해
//[역할] 세 버튼에서 is-active를 초기화 후, 지정한 버튼만 활성화
function setSortActive(which){
 const btnRecent = document.getElementById("sortRecent");
 const btnLow    = document.getElementById("sortLow");
 const btnHigh   = document.getElementById("sortHigh");

 [btnRecent, btnLow, btnHigh].forEach(b => b && b.classList.remove("is-active"));

 if (which === "recent" && btnRecent) btnRecent.classList.add("is-active");
 if (which === "low"    && btnLow)    btnLow.classList.add("is-active");
 if (which === "high"   && btnHigh)   btnHigh.classList.add("is-active");
}

   
  const gridEl = document.getElementById("wishGrid");
  let initialNodes = gridEl ? Array.from(gridEl.querySelectorAll(".card")) : [];

  /* [왜] 가격 낮은/높은 정렬이 안 먹는 원인이 gridEl 미정의였음 → gridEl 사용으로 통일
   * [무슨 기능] data-price 숫자를 기준으로 정렬 후 appendChild로 DOM 순서를 바꿈
   */
  function sortList(type) {
    if(!gridEl) return;

    const items = getVisibleCards(); // ✅ 숨김(장바구니) 제외한 카드만 정렬

    if (type === "asc") {
      items.sort((a, b) => Number(a.dataset.price) - Number(b.dataset.price));
    } else if (type === "desc") {
      items.sort((a, b) => Number(b.dataset.price) - Number(a.dataset.price));
    }

    items.forEach(item => gridEl.appendChild(item));

    // [왜] 정렬 후에도 장바구니 상품은 계속 숨겨져야 함
    // [무슨 기능] 숨김 필터 재적용 + 카운트/요약 갱신
    applyCartFilter();
  }

  /* [왜] location.reload()는 숨김 상태가 깨질 수 있음 → 새로고침 없이 “원래 순서 복구”
   * [무슨 기능] 처음에 저장한 initialNodes 순서대로 다시 붙여서 최근 저장순(초기 순서)로 되돌림
   */
  document.getElementById("sortRecent")?.addEventListener("click", () => {
    if(!gridEl) return;

    // ✅ 혹시 중간에 카드가 DOM에서 바뀌었으면(삭제/추가 등) 스냅샷 갱신
    // (대부분은 필요 없지만, 안전장치로 두면 덜 꼬입니다)
    const nowCount = gridEl.querySelectorAll(".card").length;
    if (initialNodes.length !== nowCount) {
      initialNodes = Array.from(gridEl.querySelectorAll(".card"));
    }

    initialNodes.forEach(n => { if(n && n.isConnected) gridEl.appendChild(n); });

    applyCartFilter();
    setSortActive("recent");
  });

  document.getElementById("sortLow")?.addEventListener("click", () => {
	  sortList("asc");
	  setSortActive("low");
	});

	document.getElementById("sortHigh")?.addEventListener("click", () => {
	  sortList("desc");
	  setSortActive("high");
	});


  // chkAll: 다중 선택 (✅ 보이는 카드만)
  document.getElementById("chkAll")?.addEventListener("change", (e) => {
    const on = e.target.checked;
    getVisibleCards().forEach(card => {
      const chk = card.querySelector(".chkItem");
      if(chk) chk.checked = on;
    });
    updateCounts();
    updateSummary();
    syncSelectedCards();
  });

  document.addEventListener("change", (e) => {
	  if (!e.target.classList.contains("chkItem")) return;

	  // ✅ 이제는 항상 다중 선택 허용(선택삭제용)
	  updateCounts();
	  updateSummary();
	  syncSelectedCards();
	});

  // 카드 클릭으로 선택(사진 링크/버튼/체크박스 제외)
  document.addEventListener("click", (e) => {
    if (e.target.closest('input[type="checkbox"]')) return;
    if (e.target.closest("button")) return;
    if (e.target.closest("a")) return;

    const card = e.target.closest(".wish-item.card");
    if (!card || isHidden(card)) return;

    const chk = card.querySelector(".chkItem");
    if (!chk) return;

    const multiMode = !!document.getElementById("chkAll")?.checked;
    if (!multiMode) {
      document.querySelectorAll(".chkItem").forEach(x => x.checked = false);
      chk.checked = true;
    } else {
      chk.checked = !chk.checked;
    }
    updateCounts();
    updateSummary();
    syncSelectedCards();
  });

  async function removeWish(regId){
    const res = await fetch(CTX + "/wish/remove.do", {
      method: "POST",
      headers: { "content-type": "application/x-www-form-urlencoded; charset=UTF-8" },
      body: "regId=" + encodeURIComponent(regId)
    });
    return res.json().catch(()=>({ ok:false }));
  }

  document.getElementById("btnDelSelected")?.addEventListener("click", async () => {
    const checked = getVisibleChecked();
    if (checked.length === 0) { showToast("삭제할 상품을 선택해주세요."); return; }
    if (!confirm("선택한 상품을 삭제할까요?")) return;

    let okCnt = 0;
    for (const chk of checked) {
      const regId = chk.value;
      const data = await removeWish(regId);
      if (data.ok) { chk.closest(".card")?.remove(); okCnt++; }
    }
    updateCounts();
    updateSummary();
    syncSelectedCards();
    updateEmptyState();
    showToast(okCnt > 0 ? "삭제되었습니다." : "삭제 실패");
    if (getVisibleCards().length === 0) location.reload();
  });

  document.addEventListener("click", async (e) => {
    const delBtn = e.target.closest('button[data-act="del"]');
    if (!delBtn) return;

    e.preventDefault();
    e.stopPropagation();

    const regId = delBtn.dataset.regid;
    const data = await removeWish(regId);

    if (data.ok) {
      delBtn.closest(".card")?.remove();
      updateCounts();
      updateSummary();
      syncSelectedCards();
      updateEmptyState();
      showToast(data.msg || "삭제되었습니다.");
      if (getVisibleCards().length === 0) location.reload();
    } else {
      showToast(data.msg || "삭제 실패");
    }
  });

  // 장바구니 요약 DOM 업데이트(담기 성공 후)
  function setCartSummaryFromCard(card){
    const emptyEl = document.getElementById("cartEmpty");
    const boxEl   = document.getElementById("cartBox");
    const thumbEl = document.getElementById("cartThumb");
    const titleEl = document.getElementById("cartTitle");
    const dateEl  = document.getElementById("cartDate");
    const priceEl = document.getElementById("cartPrice");
    if(!emptyEl || !boxEl || !thumbEl || !titleEl || !dateEl || !priceEl) return;

    const imgSrc = card.querySelector(".wish-thumb")?.getAttribute("src") || (CTX + "/assets/images/location/reg_default.jpg");
    const title = card.querySelector(".wish-title")?.textContent?.trim() || "-";
    const dateText = card.querySelector(".wish-meta-section .wish-meta")?.textContent || "";
    const price = Number(card.dataset.price || 0);

    thumbEl.src = imgSrc;
    titleEl.textContent = title;
    dateEl.textContent = dateText.replace("📅", "").trim() || "-";
    priceEl.textContent = price ? (price.toLocaleString() + "원") : "-";

    emptyEl.style.display = "none";
    boxEl.style.display = "flex";
  }

  // 장바구니로 이동
  document.getElementById("btnGoCart")?.addEventListener("click", () => {
    if (!IS_LOGIN) {
      alert("로그인이 필요한 서비스입니다. 로그인 페이지로 이동합니다.");
      location.href = CTX + "/login.do";
      return;
    }
    location.href = CTX + "/cart/view.do";
  });

  // ✅ 담기: 체크된 카드만 가능 + (다중체크면 1개로 강제) + (이미 담긴 동일상품은 토스트)
  document.addEventListener("click", async (e) => {
    const cartBtn = e.target.closest('button[data-act="cart"]');
    if (!cartBtn) return;

    e.preventDefault();
    e.stopPropagation();

    if(!IS_LOGIN){
      alert("로그인이 필요한 서비스입니다. 로그인 페이지로 이동합니다.");
      location.href = CTX + "/login.do";
      return;
    }

    const card  = cartBtn.closest(".card");
    if (!card || isHidden(card)) return;

    const regId = (cartBtn.dataset.regid || "").trim();

    // ✅ 0) 장바구니에 이미 같은 상품이면 서버 호출 없이 토스트
    if(currentCartRegId && currentCartRegId === regId){
      showToast("이미 장바구니에 담긴 상품입니다.");
      return;
    }

    // ✅ 1) 체크된 카드만 담기 가능
    const chk = card.querySelector(".chkItem");
    if (!chk || !chk.checked) {
      showToast("체크한 상품만 담을 수 있습니다.");
      return;
    }

    // ✅ 2) 다중 체크 상태에서는 담기 “1개만” (선택삭제는 그대로 가능)
    const checked = getVisibleChecked();
    if(checked.length > 1){
      const ok = confirm("장바구니 담기는 1개만 가능합니다.\n지금 누른 상품만 남기고 나머지 선택을 해제할까요?");
      if(!ok){
        showToast("장바구니 담기는 1개만 선택해주세요.");
        return;
      }
      // 다른 선택 해제
      getVisibleCards().forEach(c => {
        const x = c.querySelector(".chkItem");
        if(x) x.checked = false;
      });
      chk.checked = true;
      updateCounts();
      updateSummary();
      syncSelectedCards();
    }

    //if(!confirm("장바구니에 담을까요?")) return;

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

    const markAdded = () => {
      document.querySelectorAll('button[data-act="cart"].is-added')
        .forEach(b => b.classList.remove("is-added"));
      cartBtn.classList.add("is-added");

      document.querySelectorAll("#wishGrid .wish-item.card.is-added")
        .forEach(c => c.classList.remove("is-added"));
      card.classList.add("is-added");
    };

    // ✅ “이미 담김” 판별(서버가 별도 code를 주는 경우/메시지로 오는 경우 모두 대응)
    const isAlreadyInCart = (data) => {
      const code = String(data?.code || "");
      const msg  = String(data?.msg  || "");
      return (code === "ALREADY" || code === "DUPLICATE" || code === "EXISTS"
              || msg.includes("이미") && msg.includes("장바구니"));
    };

    try{
      let data = await postCart("N");

      if(data.ok){
        currentCartRegId = regId;           // ✅ 현재 장바구니 regId 갱신
        markAdded();
        setCartSummaryFromCard(card);
        applyCartFilter();                  // ✅ 관심상품 목록에서 숨김/복귀 반영
        showToast("장바구니에 담았습니다.");
        return;
      }

      if(isAlreadyInCart(data)){
        currentCartRegId = regId;           // 혹시 서버가 “이미 담김”을 준 경우도 동기화
        applyCartFilter();
        showToast("이미 장바구니에 담긴 상품입니다.");
        return;
      }

      if(data.code === "CONFLICT"){
        if(confirm(data.msg || "장바구니에 상품이 있습니다. 교체할까요?")){
          data = await postCart("Y");
          if(data.ok){
            currentCartRegId = regId;
            markAdded();
            setCartSummaryFromCard(card);
            applyCartFilter();
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
  });

  // ===== 초기화 =====
  applyCartFilter(); // ✅ 먼저 숨김 적용(카운트/요약도 같이 갱신됨)
  setSortActive("recent");
})();
</script>


</body>
</html>
