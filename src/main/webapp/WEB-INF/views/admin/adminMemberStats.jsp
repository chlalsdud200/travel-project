<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
request.setAttribute("adminActive", "memberStats");
String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>TryCatchTrip - 회원통계</title>

<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet" href="<%=ctx%>/css/admin-dashboard.css">

<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0"></script>

<style>
/* 회원통계 전용 스타일 */
.member-grid2 {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 16px;
}

@media ( max-width : 980px) {
	.member-grid2 {
		grid-template-columns: 1fr;
	}
}

.member-form {
	display: grid;
	grid-template-columns: 1fr 1fr 2fr 1fr auto;
	gap: 12px;
	align-items: end;
}

@media ( max-width : 980px) {
	.member-form {
		grid-template-columns: 1fr 1fr;
	}
}

.member-field {
	display: flex;
	flex-direction: column;
	gap: 6px;
}

.member-label {
	font-size: 12px;
	font-weight: 800;
	color: var(--muted);
}

.member-select {
	height: 42px;
	border: 1px solid rgba(15, 23, 42, .10);
	border-radius: 12px;
	padding: 0 12px;
	background: #fff;
	font-weight: 800;
	outline: none;
}

.member-actions {
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

.chart-box { position: relative; height: 260px; }
.chart-box canvas { width: 100% !important; height: 100% !important; }

.table-wrap {
	overflow: auto;
}

.member-table {
	width: 100%;
	border-collapse: collapse;
}

.member-table thead th {
	text-align: left;
	font-size: 12px;
	color: var(--muted);
	font-weight: 900;
	padding: 12px 14px;
	border-bottom: 1px solid rgba(15, 23, 42, .06);
	background: #f4f6f8;
}

.member-table tbody td {
	padding: 12px 14px;
	border-bottom: 1px solid rgba(15, 23, 42, .06);
	font-size: 13px;
	font-weight: 700;
}

.member-empty {
	text-align: center;
	color: var(--muted);
	font-weight: 900;
	padding: 22px 12px;
}

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
					통계 / <strong>회원통계</strong>
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
							<h2 class="page-title">회원 통계</h2>
							<p class="page-sub">플랫폼 기준 일별 회원통계를 확인합니다.</p>
						</div>

						<div class="updated">
							Last updated: <span id="lastUpdated">-</span>
						</div>
					</div>

					<!-- KPI 카드 4개 -->
					<section class="grid-kpi">
						<!-- 전체 회원 -->
						<div class="card card-pad">
							<div class="kpi-top">
								<div>
									<div class="kpi-label">전체 회원</div>
									<div class="kpi-value" id="kpiTotal">-</div>
								</div>
								<div class="icon-pill pill-blue">
									<i class="fas fa-users"></i>
								</div>
							</div>
							<div class="kpi-foot">총회원 기준</div>
						</div>

						<!-- 신규 회원 -->
						<div class="card card-pad">
							<div class="kpi-top">
								<div>
									<div class="kpi-label">신규 회원</div>
									<div class="kpi-value" id="kpiNew">-</div>
								</div>
								<div class="icon-pill pill-green">
									<i class="fas fa-arrow-up"></i>
								</div>
							</div>
							<div class="kpi-foot">최근 7일 신규</div>
						</div>

						<!-- 활성 회원 -->
						<div class="card card-pad">
							<div class="kpi-top">
								<div>
									<div class="kpi-label">활성 회원</div>
									<div class="kpi-value" id="kpiActive">-</div>
								</div>
								<div class="icon-pill pill-amber">
									<i class="fas fa-zap"></i>
								</div>
							</div>
							<div class="kpi-foot">결제 완료 회원</div>
						</div>

						<!-- 탈퇴 회원 -->
						<div class="card card-pad">
							<div class="kpi-top">
								<div>
									<div class="kpi-label">탈퇴 회원</div>
									<div class="kpi-value" id="kpiQuit">-</div>
								</div>
								<div class="icon-pill pill-red">
									<i class="fas fa-arrow-down"></i>
								</div>
							</div>
							<div class="kpi-foot">탈퇴 누적</div>
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
									<h3 class="panel-title">회원 검색</h3>
									<p class="panel-desc">연도 / 기준 / 기간</p>
								</div>
							</div>
							<div class="panel-meta">필터</div>
						</div>

						<div class="panel-body">
							<form id="memberStatsF" class="member-form">
								<!-- 연도 선택 -->
								<div class="member-field">
									<div class="member-label">연도</div>
									<select id="selYear" name="year" class="member-select">
										<option value="2026">2026년</option>
										<option value="2025">2025년</option>
										<option value="2024">2024년</option>
									</select>
								</div>

								<!-- 기준 선택 -->
								<div class="member-field">
									<div class="member-label">기준</div>
									<select id="selBasis" name="basis" class="member-select">
										<option value="month">월별</option>
										<option value="week">주별</option>
										<option value="day">일별</option>
									</select>
								</div>

								<!-- 기간 선택 (시작일 ~ 종료일) -->
								<div class="member-field">
									<div class="member-label">기간</div>
									<div class="date-range">
										<input type="date" id="dateFrom" name="dateFrom"
											class="member-select" /> <span class="date-tilde">~</span> <input
											type="date" id="dateTo" name="dateTo" class="member-select" />
									</div>
								</div>

						<input type="hidden" id="selType" name="type" value="all" />

								<!-- 초기화 / 검색 버튼 -->
								<div class="member-actions">
									<button type="button" class="btn btn-ghost" id="btnReset">초기화</button>
									<button type="submit" class="btn btn-indigo" id="btnSearch">검색</button>
								</div>
							</form>
						</div>
					</section>

					<!-- 차트 4개 (2x2 그리드) -->
					<section class="member-grid2" style="margin-top: 16px;">
						<!-- 월별 가입자 -->
						<section class="card">
							<div class="panel-head">
								<div class="panel-titlebox">
									<div class="icon-pill pill-blue">
										<i class="fas fa-chart-bar"></i>
									</div>
									<div>
										<h3 class="panel-title">월별 가입자</h3>
										<p class="panel-desc">Bar (월별)</p>
									</div>
								</div>
								<div class="panel-meta">신규 회원</div>
							</div>

							<div class="panel-body">
								<div class="chart-box">
									<canvas id="monthlyChart"></canvas>
								</div>
							</div>
						</section>

						<!-- 성별 분포 -->
						<section class="card">
							<div class="panel-head">
								<div class="panel-titlebox">
									<div class="icon-pill pill-green">
										<i class="fas fa-pie-chart"></i>
									</div>
									<div>
										<h3 class="panel-title">회원상태 분포</h3>
										<p class="panel-desc">Doughnut</p>
									</div>
								</div>
								<div class="panel-meta">회원 상태</div>
							</div>

							<div class="panel-body">
								<div class="chart-box">
									<canvas id="genderChart"></canvas>
								</div>
							</div>
						</section>

						<!-- 연령별 분포 -->
						<section class="card">
							<div class="panel-head">
								<div class="panel-titlebox">
									<div class="icon-pill pill-amber">
										<i class="fas fa-people-group"></i>
									</div>
									<div>
										<h3 class="panel-title">연령별 분포</h3>
										<p class="panel-desc">Doughnut</p>
									</div>
								</div>
								<div class="panel-meta">연령대 기준</div>
							</div>

							<div class="panel-body">
								<div class="chart-box">
									<canvas id="ageChart"></canvas>
								</div>
							</div>
						</section>

						<!-- 금액별 회원분포 -->
						<section class="card">
							<div class="panel-head">
								<div class="panel-titlebox">
									<div class="icon-pill pill-red">
										<i class="fas fa-money-bill"></i>
									</div>
									<div>
										<h3 class="panel-title">금액별 회원분포</h3>
										<p class="panel-desc">Doughnut</p>
									</div>
								</div>
								<div class="panel-meta">결제액 기준</div>
							</div>

							<div class="panel-body">
								<div class="chart-box">
									<canvas id="revenueChart"></canvas>
								</div>
							</div>
						</section>
					</section>

					<!-- 월별 상세 표 -->
					<section class="card" style="margin-top: 16px;">
						<div class="panel-head">
							<div class="panel-titlebox">
								<div class="icon-pill pill-indigo">
									<i class="fas fa-table"></i>
								</div>
								<div>
									<h3 class="panel-title">기간별 상세</h3>
									<p class="panel-desc">신규 / 활성 / 탈퇴 / 누적</p>
								</div>
							</div>
							<div class="panel-meta" id="tableInfo">-</div>
						</div>

						<div class="panel-body" style="padding-top: 0;">
							<div class="table-wrap">
								<table class="member-table">
									<thead>
										<tr>
											<th style="width: 90px;">월</th>
											<th>신규 회원</th>
											<th>활성 회원</th>
											<th>탈퇴 회원</th>
											<th>누적 회원</th>
										</tr>
									</thead>
									<tbody id="tblBody">
										<tr>
											<td colspan="5" class="member-empty">데이터를 불러오는 중...</td>
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

<script>
  window.CTX = "<%=request.getContextPath()%>";
  window.MEMBER_STATS_API = window.CTX + "/admin/stats/api/members.do";
</script>

<script src="<%=ctx%>/js/adminMemberStats.js"></script>
<script src="<%=ctx%>/js/adminMemberStatsEvent.js"></script>


</body>
</html>
