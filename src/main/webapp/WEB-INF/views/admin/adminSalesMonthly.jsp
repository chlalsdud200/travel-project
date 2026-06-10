<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
request.setAttribute("adminActive", "salesMonthly");
String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>TryCatchTrip - 월별 매출통계</title>

<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet" href="<%=ctx%>/css/admin-dashboard.css">

<style>
/* ========================================
   월별 매출 페이지 전용 스타일
   ======================================== */

/* 차트 2열 / 표 1열 레이아웃 */
.sales-grid2 {
	display: grid;
	grid-template-columns: 2fr 1fr;
	gap: 16px;
}

/* 화면 작아지면 1열로 변경 */
@media ( max-width : 980px) {
	.sales-grid2 {
		grid-template-columns: 1fr;
	}
}

/* 기존: 1fr 1fr 1fr auto  → 기간 1칸 추가 (2fr로 넓게) */
.sales-form {
	display: grid;
	grid-template-columns: 1fr 1fr 2fr 1fr auto;
	gap: 12px;
	align-items: end;
}

@media ( max-width : 980px) {
	.sales-form {
		grid-template-columns: 1fr 1fr;
	}
}

/* 폼 필드 (라벨 + 입력상자) */
.sales-field {
	display: flex;
	flex-direction: column;
	gap: 6px;
}

.sales-label {
	font-size: 12px;
	font-weight: 800;
	color: var(--muted);
}

/* 드롭다운 */
.sales-select {
	height: 42px;
	border: 1px solid rgba(15, 23, 42, .10);
	border-radius: 12px;
	padding: 0 12px;
	background: #fff;
	font-weight: 800;
	outline: none;
}

/* 버튼 영역 */
.sales-actions {
	display: flex;
	gap: 10px;
	justify-content: flex-end;
	align-items: center;
	min-height: 42px;
}

.btn-ghost {
	height: 42px;
	padding: 0 14px;
	border-radius: 12px;
	border: 1px solid rgba(15, 23, 42, .10);
	background: #fff;
	font-weight: 900;
	cursor: pointer;
}

/* 차트 크기 */
.chart-box { position: relative; height: 260px; }
.chart-box canvas { width: 100% !important; height: 100% !important; }

/* 표 스타일 */
.table-wrap {
	overflow: auto;
}

.sales-table {
	width: 100%;
	border-collapse: collapse;
}

.sales-table thead th {
	text-align: left;
	font-size: 12px;
	color: var(--muted);
	font-weight: 900;
	padding: 12px 14px;
	border-bottom: 1px solid rgba(15, 23, 42, .06);
	background: #f4f6f8;
}

.sales-table tbody td {
	padding: 12px 14px;
	border-bottom: 1px solid rgba(15, 23, 42, .06);
	font-size: 13px;
	font-weight: 700;
}

.sales-empty {
	text-align: center;
	color: var(--muted);
	font-weight: 900;
	padding: 22px 12px;
}

/* 기간 입력(시작~종료) */
.date-range {
	display: flex;
	gap: 8px;
	align-items: center;
}

.date-tilde {
	font-weight: 900;
	color: var(--muted);
	font-size: 12px;
	white-space: nowrap;
}
</style>
</head>

<body>
	<div class="app">

		<!-- 왼쪽 사이드바 (공통) -->
		<%@ include file="/WEB-INF/views/admin/adminSidebar.jspf"%>

		<!-- 메인 콘텐츠 -->
		<main class="main">

			<!-- 상단 헤더 -->
			<header class="topbar">
				<div class="crumb">
					통계 / <strong>매출통계</strong> / 월별
				</div>

				<div class="topbar-right">
					<div class="bell" title="알림">
						<i class="fas fa-bell"></i> <span class="badge"></span>
					</div>

					<div class="admin-chip">
						<div class="admin-avatar">A</div>
						<div class="admin-name">관리자님</div>
					</div>
				</div>
			</header>

			<!-- 메인 콘텐츠 -->
			<div class="content">
				<div class="container">

					<!-- 페이지 제목 -->
					<div class="page-head">
						<div>
							<h2 class="page-title">월별 매출통계</h2>
							<p class="page-sub">결제일 기준 월별 매출과 환불률을 확인합니다.</p>
						</div>

						<div class="updated">
							Last updated: <span id="lastUpdated">-</span>
						</div>
					</div>

					<!-- KPI 카드 4개 -->
					<section class="grid-kpi">
						<!-- 이번달 매출 -->
						<div class="card card-pad">
							<div class="kpi-top">
								<div>
									<div class="kpi-label">이번달 매출</div>
									<div class="kpi-value" id="kpiThisSales">-</div>
								</div>
								<div class="icon-pill pill-green">
									<i class="fas fa-won-sign"></i>
								</div>
							</div>
							<div class="kpi-foot">총매출 기준</div>
						</div>

						<!-- 전월 대비 증감률 -->
						<div class="card card-pad">
							<div class="kpi-top">
								<div>
									<div class="kpi-label">전월 대비</div>
									<div class="kpi-value" id="kpiMoM">-</div>
								</div>
								<div class="icon-pill pill-blue">
									<i class="fas fa-chart-line"></i>
								</div>
							</div>
							<div class="kpi-foot">증감률(%)</div>
						</div>

						<!-- 환불률 -->
						<div class="card card-pad">
							<div class="kpi-top">
								<div>
									<div class="kpi-label">환불률(금액)</div>
									<div class="kpi-value" id="kpiRefundRate">-</div>
								</div>
								<div class="icon-pill pill-red">
									<i class="fas fa-undo"></i>
								</div>
							</div>
							<div class="kpi-foot">환불/결제</div>
						</div>

						<!-- 결제건수 -->
						<div class="card card-pad">
							<div class="kpi-top">
								<div>
									<div class="kpi-label">결제건수</div>
									<div class="kpi-value" id="kpiPaidCount">-</div>
								</div>
								<div class="icon-pill pill-amber">
									<i class="fas fa-receipt"></i>
								</div>
							</div>
							<div class="kpi-foot">PAID 기준</div>
						</div>
					</section>

					<!-- 검색 폼 -->
					<section class="card" style="margin-top: 16px;">
						<div class="panel-head">
							<div class="panel-titlebox">
								<div class="icon-pill pill-indigo">
									<i class="fas fa-magnifying-glass"></i>
								</div>
								<div>
									<h3 class="panel-title">매출 검색</h3>
									<p class="panel-desc">연도 / 기준월 / 표시 기준</p>
								</div>
							</div>
							<div class="panel-meta">통계</div>
						</div>

						<div class="panel-body">
							<form id="salesMonthlyF" class="sales-form">
								<!-- 연도 선택 -->
								<div class="sales-field">
									<div class="sales-label">연도</div>
									<select id="year" name="year" class="sales-select"></select>
								</div>

								<!-- 월 선택 -->
								<div class="sales-field">
									<div class="sales-label">기준월</div>
									<select id="month" name="month" class="sales-select">
										<option value="0">전체</option>
										<option value="1">1월</option>
										<option value="2">2월</option>
										<option value="3">3월</option>
										<option value="4">4월</option>
										<option value="5">5월</option>
										<option value="6">6월</option>
										<option value="7">7월</option>
										<option value="8">8월</option>
										<option value="9">9월</option>
										<option value="10">10월</option>
										<option value="11">11월</option>
										<option value="12">12월</option>
									</select>
								</div>

								<!-- 기간 선택 (시작일 ~ 종료일) -->
								<div class="sales-field">
									<div class="sales-label">기간</div>
									<div class="date-range">
										<input type="date" id="startDate" name="startDate"
											class="sales-select" /> <span class="date-tilde">~</span> <input
											type="date" id="endDate" name="endDate" class="sales-select" />
									</div>
								</div>


								<!-- 매출 기준 선택 (총매출 / 순매출) -->
								<div class="sales-field">
									<div class="sales-label">표시</div>
									<select id="mode" name="mode" class="sales-select">
										<option value="gross">총매출</option>
										<option value="net">순매출</option>
									</select>
								</div>

								<!-- 초기화 / 검색 버튼 -->
								<div class="sales-actions">
									<button type="button" class="btn btn-ghost" id="btnReset">초기화</button>
									<button type="submit" class="btn btn-indigo" id="btnSearch">검색</button>
								</div>
							</form>
						</div>
					</section>

					<!-- 차트 2개 -->
					<section class="sales-grid2" style="margin-top: 16px;">
						<!-- 막대 차트: 월별 매출 -->
						<section class="card">
							<div class="panel-head">
								<div class="panel-titlebox">
									<div class="icon-pill pill-blue">
										<i class="fas fa-calendar"></i>
									</div>
									<div>
										<h3 class="panel-title">월별 매출</h3>
										<p class="panel-desc">Bar (월별)</p>
									</div>
								</div>
								<div class="panel-meta" id="chartMeta">총매출</div>
							</div>

							<div class="panel-body">
								<div class="chart-box">
									<canvas id="salesBar"></canvas>
								</div>
							</div>
						</section>

						<!-- 도넛 차트: 환불률 -->
						<section class="card">
							<div class="panel-head">
								<div class="panel-titlebox">
									<div class="icon-pill pill-red">
										<i class="fas fa-percent"></i>
									</div>
									<div>
										<h3 class="panel-title">환불률</h3>
										<p class="panel-desc">Doughnut</p>
									</div>
								</div>
								<div class="panel-meta">선택 기준</div>
							</div>

							<div class="panel-body">
								<div class="chart-box">
									<canvas id="refundDonut"></canvas>
								</div>
							</div>
						</section>
					</section>

					<!-- 월별 상세 표 -->
					<section class="card" style="margin-top: 16px;">
						<div class="panel-head">
							<div class="panel-titlebox">
								<div class="icon-pill pill-amber">
									<i class="fas fa-table"></i>
								</div>
								<div>
									<h3 class="panel-title">월별 상세</h3>
									<p class="panel-desc">결제일 기준 집계</p>
								</div>
							</div>
							<div class="panel-meta">12개월</div>
						</div>

						<div class="panel-body" style="padding-top: 0;">
							<div class="table-wrap">
								<table class="sales-table">
									<thead>
										<tr>
											<th style="width: 90px;">월</th>
											<th>총매출</th>
											<th>환불</th>
											<th>순매출</th>
											<th>환불률</th>
											<th>결제건수</th>
										</tr>
									</thead>
									<tbody id="salesTbody">
										<tr>
											<td colspan="6" class="sales-empty">조회해주세요.</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</section>

				</div>
			</div>
		</main>
	</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	<script src="<%= request.getContextPath() %>/js/salesMonthly.js"></script>
	<script src="<%= request.getContextPath() %>/js/salesMonthlyEvent.js"></script>

	<script>
  // 화면 우측 상단 시간표시
  document.getElementById("lastUpdated").innerText = new Date()
    .toISOString().slice(0, 16).replace("T", " ");

  // 전역 경로 설정
  var ctx = "<%= request.getContextPath() %>";
  window.CTX = ctx;
  window.SALES_MONTHLY_API = window.CTX + "/admin/api/salesMonthly.do";
  
  console.log("🔍 전역 변수 설정:");
  console.log("  CTX:", window.CTX);
  console.log("  SALES_MONTHLY_API:", window.SALES_MONTHLY_API);

  // ⭐ DOMContentLoaded가 이미 발생했을 수 있으니 직접 호출
  console.log("직접 초기화 시작...");
  if (document.readyState === "loading") {
    // 아직 로딩 중이면 DOMContentLoaded 대기
    document.addEventListener("DOMContentLoaded", function() {
      console.log("DOMContentLoaded 이벤트 발생");
      if (window.fn_salesMonthlyLoad) {
        window.fn_salesMonthlyLoad();
      }
    });
  } else {
    // 이미 로드됨 - 바로 실행
    console.log("DOM 이미 로드됨 - 직접 실행");
    setTimeout(function() {
      if (window.fn_salesMonthlyLoad) {
        window.fn_salesMonthlyLoad();
      }
    }, 100);
  }
  
  console.log("환불률 요소:", document.querySelector("#kpiRefundRate"));
  console.log("환불률 값:", document.querySelector("#kpiRefundRate").textContent);

  // API 응답 데이터 다시 확인
  fetch('/tryCatchTrip/admin/api/salesMonthly.do?year=2026&month=0')
    .then(r => r.json())
    .then(data => {
      console.log("API 데이터:", JSON.stringify(data, null, 2));
      console.log("refundAmt:", data.list[0].REFUNDAMT || data.list[0].refundAmt);
      console.log("paidAmt:", data.list[0].PAIDAMT || data.list[0].paidAmt);
    })
</script>
	
</body>
</html>
</html>