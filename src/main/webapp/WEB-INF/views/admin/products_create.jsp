<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<style>
/* admin-dashboard.css 위 최소 덮어쓰기 */
.pkg-grid {
	display: grid;
	grid-template-columns: repeat(3, minmax(0, 1fr));
	gap: 12px;
}

@media ( max-width : 1024px) {
	.pkg-grid {
		grid-template-columns: repeat(2, minmax(0, 1fr));
	}
}

@media ( max-width : 720px) {
	.pkg-grid {
		grid-template-columns: 1fr;
	}
}

.help {
	font-size: 12px;
	color: #64748b;
	margin-top: 6px;
	line-height: 1.4;
}

.divider {
	height: 1px;
	background: rgba(15, 23, 42, .10);
	margin: 14px 0;
}

.badge-step {
	display: inline-flex;
	align-items: center;
	gap: 8px;
	padding: 8px 12px;
	border-radius: 999px;
	background: #f1f5f9;
	color: #0f172a;
	font-weight: 900;
	border: 1px solid rgba(15, 23, 42, .10);
}

.badge-step.on {
	background: #e0f2fe;
	border-color: #93c5fd;
}

.badge-step.off {
	opacity: .55;
}

.table-mini {
	width: 100%;
	border-collapse: separate;
	border-spacing: 0;
}

.table-mini th, .table-mini td {
	padding: 10px;
	border-bottom: 1px solid rgba(15, 23, 42, .10);
	vertical-align: middle;
}

.table-mini th {
	text-align: left;
	font-weight: 900;
	color: #0f172a;
	font-size: 13px;
}

.small {
	font-size: 12px;
	color: #64748b;
}

.mono {
	font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas,
		"Liberation Mono", "Courier New", monospace;
}
/* ✅ 입력칸/드롭다운 구분(경계선) */
#pkg-create-root input[type="text"], #pkg-create-root input[type="date"],
	#pkg-create-root input[type="number"], #pkg-create-root select,
	#pkg-create-root textarea {
	width: 100%;
	height: 40px;
	padding: 0 12px;
	border-radius: 12px;
	border: 1px solid rgba(15, 23, 42, .18);
	background: #ffffff;
	color: #0f172a;
	outline: none;
	transition: border-color .15s ease, box-shadow .15s ease, background
		.15s ease;
}

/* textarea는 높이 자동 */
#pkg-create-root textarea {
	height: auto;
	min-height: 90px;
	padding: 10px 12px;
}

/* ✅ placeholder 색 */
#pkg-create-root input::placeholder, #pkg-create-root textarea::placeholder
	{
	color: #94a3b8;
}

/* ✅ 포커스 시 강조 */
#pkg-create-root input:focus, #pkg-create-root select:focus,
	#pkg-create-root textarea:focus {
	border-color: rgba(27, 123, 255, .65);
	box-shadow: 0 0 0 4px rgba(27, 123, 255, .15);
}

/* ✅ disabled 시 티나게 */
#pkg-create-root input:disabled, #pkg-create-root select:disabled,
	#pkg-create-root textarea:disabled {
	background: #f1f5f9;
	color: #64748b;
	border-color: rgba(15, 23, 42, .10);
	cursor: not-allowed;
}

/* ✅ readonly도 살짝 구분 */
#pkg-create-root input[readonly] {
	background: #f8fafc;
}

/* ✅ label도 조금 더 또렷하게 */
#pkg-create-root label {
	display: block;
	font-weight: 900;
	color: #0f172a;
	margin-bottom: 6px;
	font-size: 13px;
}

/* ===== Searchable Select (ss) ===== */
#pkg-create-root .ss {
	position: relative;
}

#pkg-create-root .ss-input {
	width: 100%;
	height: 40px;
	padding: 0 12px;
	border-radius: 12px;
	border: 1px solid rgba(15, 23, 42, .18);
	background: #fff;
	outline: none;
}

#pkg-create-root .ss-input:focus {
	border-color: rgba(27, 123, 255, .55);
	box-shadow: 0 0 0 3px rgba(27, 123, 255, .12);
}

#pkg-create-root .ss-menu {
	position: absolute;
	z-index: 50;
	top: calc(100% + 8px);
	left: 0;
	right: 0;
	background: #fff;
	border: 1px solid rgba(15, 23, 42, .14);
	border-radius: 14px;
	box-shadow: 0 14px 30px rgba(15, 23, 42, .10);
	max-height: 260px;
	overflow: auto;
	padding: 6px;
}

#pkg-create-root .ss-item {
	width: 100%;
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 10px;
	padding: 10px 10px;
	border-radius: 12px;
	border: 0;
	background: transparent;
	cursor: pointer;
	text-align: left;
}

#pkg-create-root .ss-item:hover, #pkg-create-root .ss-item.is-active {
	background: rgba(27, 123, 255, .08);
}

#pkg-create-root .ss-item span {
	font-weight: 900;
	color: #0f172a;
}

#pkg-create-root .ss-sub {
	color: #64748b;
	font-size: 12px;
}

#pkg-create-root .ss-empty {
	padding: 12px;
	color: #64748b;
	font-size: 13px;
}

/* ✅ ss-menu가 카드/패널에 잘리는 문제 해결 */
#pkg-create-root .card, #pkg-create-root .panel-body, #pkg-create-root .pkg-grid,
	#pkg-create-root .pkg-grid>div {
	overflow: visible !important;
}

/* ✅ z-index 확 올려서 뒤로 안 숨어들게 */
#pkg-create-root .ss-menu {
	z-index: 99999 !important;
}

/* ===== PACKAGE_ITEM 테이블 레이아웃 조정 ===== */
#pkg-create-root .pkg-item-card .table-mini th, #pkg-create-root .pkg-item-card .table-mini td
	{
	/* 전체적으로 촘촘하게 */
	padding: 8px 10px;
}

/* BY_DATE는 작게 */
#pkg-create-root .pkg-item-card .bydate-col {
	width: 90px;
	min-width: 90px !important;
}

#pkg-create-root .pkg-item-card input.bydate-inp {
	width: 80px;
	height: 34px;
	padding: 0 10px;
	text-align: center;
}

/* ITEM_ID는 넓게(드롭다운/검색형 둘 다 대비) */
#pkg-create-root .pkg-item-card .item-col {
	width: 360px;
	min-width: 360px !important;
}

/* 숙박(HOTEL)과 작업(ACTION) 사이 여백 줄이기 */
#pkg-create-root .pkg-item-card .hotel-col {
	width: 230px;
	min-width: 230px !important;
}

#pkg-create-root .pkg-item-card .action-col {
	width: 70px;
	min-width: 70px !important;
	padding-left: 6px !important;
	padding-right: 6px !important;
}

/* 작업 버튼(휴지통) 셀도 촘촘하게 */
#pkg-create-root .pkg-item-card .btn-item-row-del {
	padding: 0 10px;
	height: 34px;
}

/* ===== Item Search Select (item-ss) ===== */
#pkg-create-root .item-ss {
	position: relative;
}

#pkg-create-root .item-ss-input {
	width: 100%;
	height: 40px;
	padding: 0 12px;
	border-radius: 12px;
	border: 1px solid rgba(15, 23, 42, .18);
	background: #fff;
	outline: none;
}

#pkg-create-root .item-ss-input:focus {
	border-color: rgba(27, 123, 255, .55);
	box-shadow: 0 0 0 3px rgba(27, 123, 255, .12);
}

#pkg-create-root .item-ss-menu {
	position: absolute;
	z-index: 99999;
	top: calc(100% + 8px);
	left: 0;
	right: 0;
	background: #fff;
	border: 1px solid rgba(15, 23, 42, .14);
	border-radius: 14px;
	box-shadow: 0 14px 30px rgba(15, 23, 42, .10);
	max-height: 260px;
	overflow: auto;
	padding: 6px;
}

#pkg-create-root .item-ss-item {
	width: 100%;
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 10px;
	padding: 10px 10px;
	border-radius: 12px;
	border: 0;
	background: transparent;
	cursor: pointer;
	text-align: left;
}

#pkg-create-root .item-ss-item:hover, #pkg-create-root .item-ss-item.is-active
	{
	background: rgba(27, 123, 255, .08);
}

#pkg-create-root .item-ss-item span {
	font-weight: 900;
	color: #0f172a;
}

#pkg-create-root .item-ss-sub {
	color: #64748b;
	font-size: 12px;
}

#pkg-create-root .item-ss-empty {
	padding: 12px;
	color: #64748b;
	font-size: 13px;
}

/* item dropdown을 body에 띄우는 포탈 레이어 */
.item-portal-menu {
	position: absolute;
	z-index: 999999;
	background: #fff;
	border: 1px solid rgba(15, 23, 42, .14);
	border-radius: 14px;
	box-shadow: 0 14px 30px rgba(15, 23, 42, .10);
	max-height: 260px;
	overflow: auto;
	padding: 6px;
}
/* ===== item-ss portal 전역 스타일 (body에 붙는 메뉴용) ===== */
.item-portal-menu.item-ss-menu {
	position: absolute;
	z-index: 999999;
	top: 0;
	left: 0;
	background: #fff;
	border: 1px solid rgba(15, 23, 42, .14);
	border-radius: 14px;
	box-shadow: 0 14px 30px rgba(15, 23, 42, .10);
	max-height: 260px;
	overflow: auto;
	padding: 6px;
}

.item-portal-menu .item-ss-item {
	width: 100%;
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 10px;
	padding: 10px 10px;
	border-radius: 12px;
	border: 0;
	background: transparent;
	cursor: pointer;
	text-align: left;
}

.item-portal-menu .item-ss-item:hover, .item-portal-menu .item-ss-item.is-active
	{
	background: rgba(27, 123, 255, .08);
}

.item-portal-menu .item-ss-item span {
	font-size: 12px; font-weight : 700;
	color: #0f172a;
	font-weight: 700;
}

.item-portal-menu .item-ss-sub {
	color: #64748b;
	font-size: 12px;
}

.item-portal-menu .item-ss-empty {
	padding: 12px;
	color: #64748b;
	font-size: 13px;
}

/* ===== hotel portal 전역 스타일 ===== */
.hotel-portal-menu{
  position:absolute;
  z-index:999999;
  background:#fff;
  border:1px solid rgba(15,23,42,.14);
  border-radius:14px;
  box-shadow:0 14px 30px rgba(15,23,42,.10);
  max-height:260px;
  overflow:auto;
  padding:6px;
  font-size: 13px;
}

.hotel-portal-menu .hotel-ss-item{
  width:100%;
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:10px;
  padding:6px 8px;
  border-radius:12px;
  border:0;
  background:transparent;
  cursor:pointer;
  text-align:left;
}

.hotel-portal-menu .hotel-ss-item:hover,
.hotel-portal-menu .hotel-ss-item.is-active{
  background: rgba(27,123,255,.08);
}

.hotel-portal-menu .hotel-ss-item span{
  font-size:13px;
  font-weight:700;
  white-space:nowrap;
  overflow:hidden;
  text-overflow:ellipsis;
  flex:1;
}

.hotel-portal-menu .hotel-ss-sub{
  font-size:11px;
  color:#64748b;
  white-space:nowrap;
  margin-left:8px;
}

.hotel-portal-menu .hotel-ss-empty{
  padding:12px;
  color:#64748b;
  font-size:13px;
}

</style>

<!-- ======================================================
     패키지 관리 (레이아웃 확정판)
     - 동작은 /assets/js/admin_prod/ad_pkg.js 에서 처리
====================================================== -->
<div id="pkg-create-root" data-ctx="${ctx}"
	data-created-pkgid="{package_id}">

	<!-- STEP -->
	<div
		style="display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 14px;">
		<div class="badge-step on" data-step="1">
			<i class="fa-solid fa-1"></i> 패키지 생성
		</div>
	</div>

	<!-- ✅ form을 여기서 시작: 1번+2번 카드 전체를 한 폼처럼 감싸기 -->
	<form class="pkg-create-form" data-form="package">

		<!-- =========================
       1) PACKAGES
  ========================== -->
		<div class="card" style="margin-bottom: 14px;">
			<div class="panel-head"
				style="padding-bottom: 10px; padding-top: 10px;">
				<div class="panel-titlebox">
					<div class="icon-pill pill-indigo">
						<i class="fas fa-box"></i>
					</div>
					<div>
						<h3 class="panel-title">패키지</h3>
					</div>
				</div>
			</div>

			<div class="panel-body" style="padding-top: 10px;">

				<div class="pkg-grid">
					<!-- 패키지명(직접 입력) -->
					<div>
						<label>패키지명</label> <input type="text" name="packageTitle"
							class="inp-title" placeholder="예) 지중해 3박4일 해상레저" value="" />
					</div>

					<!-- ✅ 지역: 검색형 드롭다운 -->
					<div class="ss" data-ss="loc">
						<label>대표지역</label> <input type="text" class="ss-input"
							placeholder="지역명을 입력해서 검색…" autocomplete="off" /> <input
							type="hidden" name="locId" class="ss-value" value="" />

						<div class="ss-menu" hidden>

							<!-- 디버깅용 -->
							<c:if test="${empty locationList}">
								<div class="ss-empty">locationList 비어있음 (컨트롤러
									setAttribute확인)</div>
							</c:if>

							<c:forEach var="l" items="${locationList}">
								<!-- label은 화면 표시용(검색 대상), value는 실제 locId -->
								<button type="button" class="ss-item" data-value="${l.locId}"
									data-label="${l.locName}">
									<span>${l.locName}</span> <small class="ss-sub">LOC_ID:
										${l.locId}</small>
								</button>
							</c:forEach>
						</div>
					</div>

					<!-- ✅ 국가(자동 지정: hidden + readonly) -->
					<div>
						<label>국가 (지역 선택 시 자동)</label> <input type="hidden" name="ctryId"
							class="ctry-id" value="" /> <input type="text" class="ctry-name"
							value="" readonly placeholder="지역 선택 시 자동 지정" />
					</div>

					<!-- 메인 테마(드롭다운) -->
					<div class="ss" data-ss="theme">
						<label>메인 테마</label> <input type="text" class="ss-input"
							placeholder="테마명을 입력해서 검색…" autocomplete="off" /> <input
							type="hidden" name="themeId" class="ss-value" value="" />

						<div class="ss-menu" hidden>

							<!-- 디버깅용 -->
							<c:if test="${empty pThemeList}">
								<div class="ss-empty">pThemeList 비어있음 (컨트롤러
									setAttribute확인)</div>
							</c:if>

							<c:forEach var="t" items="${pThemeList}">
								<button type="button" class="ss-item" data-value="${t.themeId}"
									data-label="${t.themeTitle}">
									<span>${t.themeTitle}</span> <small class="ss-sub">THEME_ID:
										${t.themeId}</small>
								</button>
							</c:forEach>
						</div>

						<!-- 						<div class="help">PACKAGES.THEME_ID → P_THEME.THEME_ID</div> -->
					</div>

					<!-- 패키지ID(자동 생성 표시) -->
					<div>
						<label>패키지ID (자동 생성)</label> <input type="text"
							name="packageIdView" class="pkg-id-view mono"
							value="{package_id}" readonly placeholder="생성 후 자동 표시" />
						<!-- 						<div class="help"> -->
						<!-- 							규칙: <span class="mono">{CTRY_ID}{LOC_ID}{THEME_ID}{NN}</span> -->
						<!-- 							(NN=01~99 중 빈자리 최소값) -->
						<!-- 						</div> -->
					</div>

					<!-- ✅ 기존 버튼 블록 제거 대신 grid 깨짐 방지용 빈칸 -->
					<div></div>
				</div>

				<div class="divider"></div>

				<!-- 생성 로직 안내(레이아웃용) -->
				<div class="small">
					- 지역 선택 시 국가가 자동으로 채워집니다.<br /> - 패키지ID는 서버에서 <span class="mono">CTRY+LOC+THEME</span>
					prefix 기준으로 NNN을 계산해 생성합니다.<br />
				</div>

			</div>
		</div>

		<!-- =========================
       2) PACKAGE_ITEM 구성
  ========================== -->
		<div class="card pkg-item-card" data-section="packageItem">
			<div class="panel-head"
				style="padding-bottom: 10px; padding-top: 10px;">
				<div class="panel-titlebox">
					<div class="icon-pill pill-blue">
						<i class="fas fa-layer-group"></i>
					</div>
					<div>
						<h3 class="panel-title">패키지 구성</h3>
					</div>
				</div>
			</div>

			<div class="panel-body" style="padding-top: 10px;">
				<div
					style="display: flex; gap: 10px; align-items: center; flex-wrap: wrap; margin-bottom: 10px;">
					<div class="badge-step on" style="margin: 0;">
						<i class="fa-solid fa-tag"></i> PACKAGE_ID : <span
							class="pkg-id-badge mono" style="margin-left: 6px;">{package_id}</span>
					</div>

					<div style="margin-left: auto; display: flex; gap: 10px;">
						<button type="button" class="btn btn-dark btn-item-row-add">
							<i class="fas fa-plus"></i> 행 추가
						</button>
					</div>
				</div>

				<div style="overflow-x: auto;">
					<table class="table-mini">
						<!-- ✅ 컬럼 폭 고정 -->
						<colgroup>
							<col class="bydate-col" />
							<col class="item-col" />
							<col class="hotel-col" />
							<col class="action-col" />
						</colgroup>

						<thead>
							<tr>
								<th class="bydate-col">일차</th>
								<th class="item-col">아이템</th>
								<th class="hotel-col">숙박</th>
								<th class="action-col" style="text-align: right;">작업</th>
							</tr>
						</thead>

						<tbody class="pkg-item-tbody">
							<tr class="pkg-item-row" data-row="1">
								<!-- BY_DATE -->
								<td class="bydate-col"><input type="number" name="byDate"
									class="bydate-inp" value="1" min="1" /></td>

								<td>
									<div class="item-ss" data-item-ss="1">
										<input type="text" class="item-ss-input"
											placeholder="아이템명/코드 검색…" autocomplete="off" /> <input
											type="hidden" name="itemId" class="item-ss-value" value="" />

										<div class="item-ss-menu" hidden></div>
									</div>
								</td>

								<!-- HOTEL -->
								<td class="hotel-col">
									<div class="hotel-ss" data-hotel-ss="1">
										<input type="text" class="hotel-ss-input"
											placeholder="숙박시설명 or 지역명으로 검색..." autocomplete="off" /> <input
											type="hidden" name="hotelId" class="hotel-ss-value" value="" />
										<div class="hotel-ss-menu" hidden></div>
									</div>
								</td>

								<!-- ACTION -->
								<td class="action-col" style="text-align: right;">
									<button type="button" class="btn btn-ghost btn-item-row-del">
										<i class="fas fa-trash"></i>
									</button>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>

		<!-- ✅ 하단 우측 버튼바: 패키지 생성/초기화 -->
		<div
			style="display: flex; justify-content: flex-end; gap: 10px; margin-top: 14px;">
			<button type="button" class="btn btn-ghost btn-pkg-reset"
				title="입력 초기화">
				<i class="fas fa-rotate-right"></i> 초기화
			</button>
			<button type="button" class="btn btn-indigo btn-pkg-create">
				<i class="fas fa-plus"></i> 패키지 생성
			</button>
		</div>

	</form>
</div>

<script src="${ctx}/assets/js/admin_prod/ad_pkgitem.js"></script>
