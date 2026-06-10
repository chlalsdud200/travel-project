<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  request.setAttribute("adminActive", "salesStats");
  String ctx = request.getContextPath();
  String today = java.time.LocalDate.now().toString();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>TryCatchTrip - 매출 통계</title>

<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet" href="<%=ctx%>/css/admin-dashboard.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0/dist/chartjs-plugin-datalabels.min.js"></script>

<style>
.sales-grid2{ display:grid; grid-template-columns: 1.6fr 1fr; gap:16px; }
@media (max-width: 980px){ .sales-grid2{ grid-template-columns: 1fr; } }

.sales-form{ display:grid; grid-template-columns: 1fr 1fr 2fr auto; gap:12px; align-items:end; }
@media (max-width: 980px){ .sales-form{ grid-template-columns: 1fr 1fr; } }

.field{ display:flex; flex-direction:column; gap:6px; }
.label{ font-size:12px; font-weight:800; color:var(--muted); }

.select, .input{
  height:42px; border:1px solid rgba(15,23,42,.10); border-radius:12px;
  padding:0 12px; background:#fff; font-weight:800; outline:none;
}

.range{ display:flex; gap:8px; align-items:center; }
.range .tilde{ font-weight:900; color:var(--muted); font-size:12px; white-space:nowrap; }

.actions{ display:flex; gap:10px; justify-content:flex-end; align-items:center; min-height:42px; }
.btn-ghost{
  height:42px; padding:0 14px; border-radius:12px;
  border:1px solid rgba(15,23,42,.10); background:#fff; font-weight:900; cursor:pointer;
}

.chart-box{ position:relative; height: 300px; }
.chart-box canvas{ width:100% !important; height:100% !important; }

/* =========================
   ✅ 테이블 정렬/가독성 보조
   - (JS 문제는 아니지만) 화면에서 칼럼 흔들림/줄바꿈 난리 방지
   ========================= */
.table-wrap{ overflow:auto; }
.sales-table{
  width:100%;
  border-collapse:collapse;
  table-layout:fixed; /* ✅ 칼럼 폭 안정 */
}
.sales-table thead th{
  text-align:left; font-size:12px; color:var(--muted); font-weight:900;
  padding:12px 14px; border-bottom:1px solid rgba(15,23,42,.06); background:#f4f6f8;
  white-space:nowrap;
  overflow:hidden;
  text-overflow:ellipsis;
}
.sales-table tbody td{
  padding:12px 14px; border-bottom:1px solid rgba(15,23,42,.06);
  font-size:13px; font-weight:700;
  vertical-align:middle;
  overflow:hidden;
  text-overflow:ellipsis;
}
.sales-empty{ text-align:center; color:var(--muted); font-weight:900; padding:22px 12px; }
.mono{ font-variant-numeric: tabular-nums; }
.small-note{ font-size:12px; color:var(--muted); font-weight:800; margin-top:10px; }
.num{ text-align:right; }
.center{ text-align:center; }

/* 패키지 판매검색 (연도/기준 제거) */
.sales-form--pkg{
  display:flex; gap:12px; align-items:end; flex-wrap:wrap;
}
.sales-form--pkg .field{ min-width:150px; }
.sales-form--pkg .field--wide{ flex:1; min-width:200px; }
.sales-form--pkg .field--range{ min-width:350px; }

/* =========================
   ✅ 등록행(REG) 비교 레이아웃 개선
   1) 왼쪽(패키지/기간) 폭 키움
   2) 왼쪽은 2카드로 분리(스택)
   3) 오른쪽(등록행 선택)은 화면 줄이면 wrap 처리로 "잘림" 방지
   ========================= */

/* ✅ 왼쪽 넓히고 오른쪽 줄이기 */
/* ✅ (교체) 기본은 1열이라서 창 줄이면 무조건 아래로 내려옵니다 */
.reg-compare-wrapper{
  display:grid;
  grid-template-columns: 1fr !important;
  gap:16px;
  align-items:stretch;
}

/* ✅ 화면이 충분히 넓을 때만 2열로 표시 (원하시면 1200/1400 숫자 조절) */
@media (min-width: 1200px){
  .reg-compare-wrapper{
    grid-template-columns: clamp(360px, 34vw, 480px) minmax(0, 1fr) !important;
  }
}

/* ✅ 내용이 길어서 폭이 안 줄어드는 버그 방지 */
.reg-left-stack, .reg-step, .reg-choices-wrapper, .reg-choices{ min-width:0; }


/* ✅ 왼쪽: 카드 2개 세로 스택 */
.reg-left-stack{
  display:flex;
  flex-direction:column;
  gap:12px;
  height:100%;
}

.reg-step{
  padding:18px; background:#f8fafc; border-radius:12px;
  display:flex; flex-direction:column;
  height:100%;
  min-height: 150px;
  overflow:visible; /* 혹시 상위 overflow로 잘리는 경우 방지 */
}
.reg-step-title{
  font-size:14px; font-weight:900; color:#0f172a;
  margin-bottom:12px; display:flex; align-items:center; gap:8px;
}
.reg-step-num{
  display:inline-flex; align-items:center; justify-content:center;
  width:24px; height:24px; background:#a5b4fc; color:#312e81;
  border-radius:50%; font-size:12px; font-weight:900;
}
.reg-step .field + .field{ margin-top:12px; }

/* 등록행 선택 영역 - 기본: 가로 스크롤 */
.reg-choices-wrapper{
  flex:1;
  overflow-x:auto;
  overflow-y:hidden;
  padding-bottom:6px; /* 스크롤바 공간 */
}

.reg-choices{
  display:flex; gap:10px; padding:12px;
  border:1px solid rgba(15,23,42,.08); border-radius:12px; background:#fff;
   width:100%;          /* ✅ 추가 */
  min-width:0;
  align-items:stretch;
}

.reg-chip{
  display:flex; gap:8px; align-items:flex-start;
  padding:10px 12px; border-radius:12px;
  border:1px solid rgba(15,23,42,.10); cursor:pointer;
  background:#fff;
  min-width:240px; width:240px;      /* ✅ 칩 폭 고정 -> 줄 정렬 안정 */
  white-space:normal;                /* ✅ 내용 줄바꿈 허용 */
  min-height:72px;                   /* ✅ 높이 들쭉날쭉 완화 */
}
.reg-chip input{ margin-top:3px; flex-shrink:0; }
.reg-chip .t1{ font-weight:900; font-size:13px; color:#0f172a; }
.reg-chip .t2{
  font-weight:800; font-size:12px; color:rgba(15,23,42,.62);
  line-height:1.35;
  word-break:keep-all;
}

/* ✅ 화면이 더 줄어들면: wrap으로 잘림 방지 */
@media (max-width: 720px){
  .reg-choices{
    flex-wrap:wrap;
    overflow-x:visible;
  }
  .reg-chip{
    flex:1 1 240px;   /* 2열/1열 유동 */
    width:auto;
    min-width:240px;
  }
}

.chart-shell{
  position:relative; height:420px; border:1px solid rgba(15,23,42,.08);
  border-radius:12px; background:#fff; overflow:hidden;
}
.chart-shell canvas{ width:100% !important; height:100% !important; }

#btnRegCompare:disabled{ opacity:.6; cursor:not-allowed; }


/* ✅ 버튼이 덮여서 클릭 안 되는 상황 방지 */
.reg-step{ position:relative; }
#btnRegCompare{ position:relative; z-index:10; pointer-events:auto; }

</style>

<script>
  window.CTX = "<%=request.getContextPath()%>";
  window.SALES_STATS_API = window.CTX + "/admin/stats/api/sales.do";
  window.PACKAGE_SALES_API = window.CTX + "/admin/stats/api/packageSales.do";
  window.PACKAGE_AUTOCOMPLETE_API = window.CTX + "/admin/stats/api/packageAutocomplete.do";
  window.PACKAGE_COMPARISON_API = window.CTX + "/admin/stats/api/packageComparison.do";
  window.PACKAGE_REG_LIST_API = window.CTX + "/admin/stats/api/packageRegList.do";
  window.PACKAGE_REG_COMPARE_API = window.CTX + "/admin/stats/api/packageRegCompare.do";
</script>
</head>

<body>
<div class="app">
  <%@ include file="/WEB-INF/views/admin/adminSidebar.jspf"%>

  <main class="main">
    <header class="topbar">
      <div class="crumb">통계 / <strong>매출 통계</strong></div>
      <div class="topbar-right">
        <div class="bell" title="알림"><i class="fas fa-bell"></i> <span class="badge"></span></div>
        <div class="admin-chip">
          <div class="admin-avatar">A</div>
          <div class="admin-name">관리자님</div>
        </div>
      </div>
    </header>

    <div class="content">
      <div class="container">

        <div class="page-head">
          <div>
            <h2 class="page-title">매출 통계</h2>
            <p class="page-sub">총매출은 PAID 기준, 환불은 <b>환불(REQUESTED)</b> 기준으로 표시합니다.</p>
          </div>
          <div class="updated">Last updated: <span id="lastUpdated">-</span></div>
        </div>

        <!-- KPI -->
        <section class="grid-kpi">
          <div class="card card-pad">
            <div class="kpi-top">
              <div>
                <div class="kpi-label">누적 총매출</div>
                <div class="kpi-value mono" id="kpiThisGross">-</div>
              </div>
              <div class="icon-pill pill-blue"><i class="fas fa-won-sign"></i></div>
            </div>
            <div class="kpi-foot">검색 기간 PAID 금액 합</div>
          </div>

          <div class="card card-pad">
            <div class="kpi-top">
              <div>
                <div class="kpi-label">총 주문건수</div>
                <div class="kpi-value mono" id="kpiTotalOrders">-</div>
              </div>
              <div class="icon-pill pill-indigo"><i class="fas fa-shopping-cart"></i></div>
            </div>
            <div class="kpi-foot">검색 기간 결제완료 건수</div>
          </div>

          <div class="card card-pad">
            <div class="kpi-top">
              <div>
                <div class="kpi-label">누적 환불금액율</div>
                <div class="kpi-value mono" id="kpiRefundRate">-</div>
              </div>
              <div class="icon-pill pill-red"><i class="fas fa-rotate-left"></i></div>
            </div>
            <div class="kpi-foot">환불액 / 총매출</div>
          </div>

          <div class="card card-pad">
            <div class="kpi-top">
              <div>
                <div class="kpi-label">누적 순매출</div>
                <div class="kpi-value mono" id="kpiNetSales">-</div>
              </div>
              <div class="icon-pill pill-green"><i class="fas fa-calculator"></i></div>
            </div>
            <div class="kpi-foot">총매출 - 환불액</div>
          </div>
        </section>

        <!-- 매출 검색 -->
        <section class="card" style="margin-top:16px;">
          <div class="panel-head">
            <div class="panel-titlebox">
              <div class="icon-pill pill-indigo"><i class="fas fa-magnifying-glass"></i></div>
              <div>
                <h3 class="panel-title">매출 검색</h3>
                <p class="panel-desc">연도 / 기준 / 기간</p>
              </div>
            </div>
            <div class="panel-meta">필터</div>
          </div>

          <div class="panel-body">
            <form id="salesF" class="sales-form">
              <div class="field">
                <div class="label">연도</div>
                <select id="selYear" class="select">
                  <option value="2026" selected>2026년</option>
                  <option value="2025">2025년</option>
                  <option value="2024">2024년</option>
                </select>
              </div>

              <div class="field">
                <div class="label">기준</div>
                <select id="selBasis" class="select">
                  <option value="month" selected>월별</option>
                  <option value="week">주별</option>
                  <option value="day">일별</option>
                </select>
              </div>

              <div class="field">
                <div class="label">기간</div>
                <div class="range">
                  <input type="date" id="dateFrom" class="input" />
                  <span class="tilde">~</span>
                  <input type="date" id="dateTo" class="input" />
                </div>
              </div>

              <div class="actions">
                <button type="button" class="btn btn-ghost" id="btnReset">초기화</button>
                <button type="submit" class="btn btn-indigo" id="btnSearch">검색</button>
              </div>
            </form>
          </div>
        </section>

        <!-- 기간별 매출/환불 추이 -->
        <div class="sales-grid2" style="margin-top:16px;">
          <section class="card">
            <div class="panel-head">
              <div class="panel-titlebox">
                <div class="icon-pill pill-blue"><i class="fas fa-chart-line"></i></div>
                <div>
                  <h3 class="panel-title">기간별 매출/환불 추이</h3>
                  <p class="panel-desc" id="chartMeta">-</p>
                </div>
              </div>
              <div class="panel-meta">추이</div>
            </div>
            <div class="panel-body">
              <div class="chart-box" style="height:350px;"><canvas id="comboChart"></canvas></div>
            </div>
          </section>

          <section class="card">
            <div class="panel-head">
              <div class="panel-titlebox">
                <div class="icon-pill pill-indigo"><i class="fas fa-chart-pie"></i></div>
                <div>
                  <h3 class="panel-title">매출 구성 비율</h3>
                  <p class="panel-desc">총매출 vs 환불액 비율</p>
                </div>
              </div>
              <div class="panel-meta">비율</div>
            </div>
            <div class="panel-body">
              <div class="chart-box" style="height:350px;"><canvas id="donutChart"></canvas></div>
            </div>
          </section>
        </div>

        <!-- 테이블 -->
        <section class="card" style="margin-top:16px;">
          <div class="panel-head">
            <div class="panel-titlebox">
              <div class="icon-pill pill-indigo"><i class="fas fa-table"></i></div>
              <div>
                <h3 class="panel-title">기간별 상세 내역</h3>
                <p class="panel-desc" id="tableMeta">-</p>
              </div>
            </div>
            <div class="panel-meta">표</div>
          </div>

          <div class="panel-body" style="padding-top:0;">
            <div class="table-wrap">
              <table class="sales-table">
                <thead>
                  <tr>
                    <th>기간</th>
                    <th class="num">총매출(PAID)</th>
                    <th class="num">환불요청액(REQ)</th>
                    <th class="num">순매출</th>
                    <th class="center">환불율(%)</th>
                    <th class="center">결제건수</th>
                    <th class="center">환불건수</th>
                  </tr>
                </thead>
                <tbody id="tblBody">
                  <tr><td colspan="7" class="sales-empty">검색 버튼을 눌러주세요.</td></tr>
                </tbody>
              </table>
            </div>
          </div>
        </section>

        <!-- 패키지 검색 폼 (연도/기준 제거) -->
        <section class="card" style="margin-top:16px;">
          <div class="panel-head">
            <div class="panel-titlebox">
              <div class="icon-pill pill-blue"><i class="fas fa-box"></i></div>
              <div>
                <h3 class="panel-title">패키지별 판매 검색</h3>
                <p class="panel-desc">패키지명으로 판매 내역을 조회합니다.</p>
              </div>
            </div>
            <div class="panel-meta">검색</div>
          </div>

          <div class="panel-body">
            <form id="pkgSalesF" class="sales-form--pkg">
              <div class="field">
                <div class="label">정렬</div>
                <select id="pkgSort" class="select">
                  <option value="DATE_DESC" selected>출발일 최신순</option>
                  <option value="SALES_DESC">매출 높은순</option>
                  <option value="SALES_ASC">매출 낮은순</option>
                </select>
              </div>

              <div class="field field--wide" style="position:relative;">
                <div class="label">패키지명 *</div>
                <input type="text" id="pkgName" class="input" placeholder="패키지명 입력" autocomplete="off">
                <div id="pkgAutocomplete"
                  style="position:absolute; top:100%; left:0; right:0;
                         background:#fff; border:1px solid rgba(15,23,42,.10);
                         border-radius:8px; margin-top:4px; max-height:200px; overflow-y:auto;
                         display:none; z-index:1000; box-shadow:0 4px 6px rgba(0,0,0,.1);">
                </div>
              </div>

              <div class="field field--range">
                <div class="label">기간 (결제일 기준)</div>
                <div class="range">
                  <input type="date" id="pkgDateFrom" class="input" value="2024-01-01" style="width:150px;"/>
                  <span class="tilde">~</span>
                  <input type="date" id="pkgDateTo" class="input" value="<%=today%>" style="width:150px;"/>
                </div>
              </div>

              <div class="actions">
                <button type="button" class="btn btn-ghost" id="pkgBtnReset">초기화</button>
                <button type="submit" class="btn btn-indigo" id="pkgBtnSearch">검색</button>
              </div>
            </form>
          </div>
        </section>

        <!-- 패키지별 판매 리스트 (✅ 상품명은 등록 ID 뒤) -->
        <section class="card" style="margin-top:16px; margin-bottom: 20px;">
          <div class="panel-head">
            <div class="panel-titlebox">
              <div class="icon-pill pill-blue"><i class="fas fa-list-ul"></i></div>
              <div>
                <h3 class="panel-title">패키지별 판매 리스트</h3>
                <p class="panel-desc">검색된 패키지의 출발일별 상세 내역입니다. (최대 8줄)</p>
              </div>
            </div>
          </div>

          <div class="panel-body" style="padding-top:0;">
            <div class="table-wrap">
              <table class="sales-table">
                <thead>
                  <tr>
                    <th>출발일</th>
                    <th>상품명</th>
                    <th class="num">상품 가격</th>
                    <th class="center">판매 수량</th>
                    <th class="center">주문 건수</th>
                    <th class="num">총 판매 금액</th>
                    <th class="center">등록 ID</th>
                  </tr>
                </thead>
                <tbody id="packageTblBody">
                  <tr><td colspan="7" class="sales-empty">패키지명을 검색해 주세요.</td></tr>
                </tbody>
              </table>
            </div>

            <div id="pkgPager" class="pagination"
              style="display:flex; justify-content:center; align-items:center; gap:8px; margin-top:20px; padding-bottom:10px;">
            </div>
          </div>
        </section>

        <!-- =========================
             ✅ 등록행(REG) 비교
             - 왼쪽: 패키지 선택 카드 + 기간 선택 카드 (분리)
             - 오른쪽: 등록행 선택 (작아져도 wrap으로 잘림 방지)
             ========================= -->
        <section class="card" style="margin-top:16px;">
          <div class="panel-head">
            <div class="panel-titlebox">
              <div class="icon-pill pill-indigo"><i class="fas fa-chart-column"></i></div>
              <div>
                <h3 class="panel-title">등록행(REG) 비교</h3>
                <p class="panel-desc">
                  패키지 선택 → 기간 선택 → 등록행 최대 3개 선택 → 비교하기
                </p>
              </div>
            </div>
          </div>

          <div class="panel-body">
            <div class="reg-compare-wrapper">

              <!-- ✅ 왼쪽: 카드 2개 스택 -->
              <div class="reg-left-stack">

                <!-- 카드 1: 패키지 선택 -->
                <div class="reg-step">
                  <div class="reg-step-title">
                    <span class="reg-step-num">1</span> 패키지 선택
                  </div>

                  <div class="field" style="position:relative;">
                    <input type="text" id="regPkgName" class="input" placeholder="패키지명 입력" autocomplete="off">
                    <input type="hidden" id="regPkgId" value="">
                    <div id="regPkgAutocomplete"
                      style="position:absolute; top:100%; left:0; right:0;
                             background:#fff; border:1px solid rgba(15,23,42,.10);
                             border-radius:8px; margin-top:4px; max-height:200px; overflow-y:auto;
                             display:none; z-index:1000; box-shadow:0 4px 6px rgba(0,0,0,.1);">
                    </div>
                  </div>

                  <div class="small-note">
                    ※ 패키지 선택 후, 아래 기간을 설정해 주세요.
                  </div>
                </div>

                <!-- 카드 2: 기간 선택 -->
                <div class="reg-step">
                  <div class="reg-step-title">
                    <span class="reg-step-num">2</span> 기간 선택
                  </div>

                  <div class="field">
                    <div class="label">기간 (결제일 기준)</div>
                    <div class="range">
                      <input type="date" id="regDateFrom" class="input" value="2024-01-01" style="width:100%;" />
                      <span class="tilde">~</span>
                      <input type="date" id="regDateTo" class="input" value="<%=today%>" style="width:100%;" />
                    </div>
                  </div>

                  <div class="small-note">
                    ※ 패키지/기간 선택 후, 오른쪽에서 등록행을 선택해 주세요.
                  </div>
                </div>

              </div>

              <!-- ✅ 오른쪽: 등록행 선택 -->
              <div class="reg-step">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;">
                  <div class="reg-step-title" style="margin-bottom:0;">
                    <span class="reg-step-num">3</span> 등록행 선택 (최대 3개)
                  </div>
                  <button id="btnRegCompare" type="button" class="btn btn-indigo">
                    <i class="fas fa-chart-line" style="margin-right:6px;"></i>비교하기
                  </button>
                </div>

                <div class="reg-choices-wrapper">
                  <div id="regChoices" class="reg-choices">
                    <div style="font-weight:900; color:rgba(15,23,42,.62);">
                      패키지를 선택하면 등록행 목록이 표시됩니다.
                    </div>
                  </div>
                </div>

                <div class="small-note">
                </div>
              </div>

            </div>

            <!-- 차트 -->
            <div class="chart-shell" style="margin-top:16px;">
              <canvas id="regComparisonChart"></canvas>
            </div>
          </div>
        </section>

        <!-- 패키지별 비교 분석 -->
        <section class="card" style="margin-top:16px; margin-bottom: 40px;">
          <div class="panel-head">
            <div class="panel-titlebox">
              <div class="icon-pill pill-indigo"><i class="fas fa-chart-line"></i></div>
              <div>
                <h3 class="panel-title">패키지별 비교 분석</h3>
                <p class="panel-desc">최대 3개의 패키지를 선택하여 기간별 매출 추이를 비교합니다.</p>
              </div>
            </div>
          </div>

          <div class="panel-body">
            <div style="background:#fff; padding:15px; border-radius:12px; border:1px solid rgba(15,23,42,.08); margin-bottom:15px;">
              <div style="display:flex; gap:12px; align-items:end; flex-wrap:wrap;">
                <div class="field" style="flex:1; min-width:200px;">
                  <div class="label">조회 기간 (결제일 기준)</div>
                  <div class="range">
                    <input type="date" id="cmpDateFrom" class="input" value="2024-01-01" style="width:100%"/>
                    <span class="tilde">~</span>
                    <input type="date" id="cmpDateTo" class="input" value="<%=today%>" style="width:100%"/>
                  </div>
                </div>
              </div>
            </div>

            <div style="display:flex; gap:12px; margin-bottom:20px; align-items:center; background:#f8fafc; padding:15px; border-radius:12px;">
              <div style="flex:1; position:relative;">
                <div class="label" style="margin-bottom:5px;">상품 1</div>
                <input type="text" id="cmpPkg1" class="input" placeholder="패키지명 입력" autocomplete="off" style="width:100%">
                <div id="cmpAutocomplete1"
                  style="position:absolute; top:100%; left:0; right:0;
                         background:#fff; border:1px solid rgba(15,23,42,.10);
                         border-radius:8px; margin-top:4px; max-height:150px; overflow-y:auto;
                         display:none; z-index:1000; box-shadow:0 4px 6px rgba(0,0,0,.1);">
                </div>
              </div>

              <div style="font-weight:900; color:var(--muted); margin-top:15px;">VS</div>

              <div style="flex:1; position:relative;">
                <div class="label" style="margin-bottom:5px;">상품 2</div>
                <input type="text" id="cmpPkg2" class="input" placeholder="패키지명 입력" autocomplete="off" style="width:100%">
                <div id="cmpAutocomplete2"
                  style="position:absolute; top:100%; left:0; right:0;
                         background:#fff; border:1px solid rgba(15,23,42,.10);
                         border-radius:8px; margin-top:4px; max-height:150px; overflow-y:auto;
                         display:none; z-index:1000; box-shadow:0 4px 6px rgba(0,0,0,.1);">
                </div>
              </div>

              <div style="font-weight:900; color:var(--muted); margin-top:15px;">VS</div>

              <div style="flex:1; position:relative;">
                <div class="label" style="margin-bottom:5px;">상품 3 (선택)</div>
                <input type="text" id="cmpPkg3" class="input" placeholder="패키지명 입력" autocomplete="off" style="width:100%">
                <div id="cmpAutocomplete3"
                  style="position:absolute; top:100%; left:0; right:0;
                         background:#fff; border:1px solid rgba(15,23,42,.10);
                         border-radius:8px; margin-top:4px; max-height:150px; overflow-y:auto;
                         display:none; z-index:1000; box-shadow:0 4px 6px rgba(0,0,0,.1);">
                </div>
              </div>

              <button id="btnCompare" class="btn-indigo"
                style="margin-top:18px; height:42px; background:#4f46e5; color:#fff; border-radius:12px; padding:0 20px; font-weight:900;">
                비교하기
              </button>
            </div>

            <div class="chart-box" style="height:400px;">
              <canvas id="comparisonChart"></canvas>
            </div>
          </div>
        </section>

      </div>
    </div>
  </main>
</div>

<script defer src="<%=ctx%>/js/salesMonthly.js"></script>
<script defer src="<%=ctx%>/js/salesMonthlyEvent.js"></script>
<script defer src="<%=ctx%>/js/packageSales.js"></script>
<script defer src="<%=ctx%>/js/packageSalesEvent.js"></script>
<script defer src="<%=ctx%>/js/packageAutocomplete.js"></script>
<script defer src="<%=ctx%>/js/packageComparison.js"></script>
<script defer src="<%=ctx%>/js/packageRegCompare.js"></script>

</body>
</html>
