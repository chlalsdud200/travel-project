<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<style>
/* admin-dashboard.css 기반 위에 덮어쓰기 최소 */
.btnX {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	height: 36px;
	padding: 0 12px;
	border-radius: 12px;
	font-weight: 800;
	font-size: 12px;
	cursor: pointer;
	user-select: none;
	border: 1px solid transparent;
	transition: opacity .15s ease, background-color .15s ease;
	white-space: nowrap;
}

.btnX.md {
	height: 44px;
	padding: 0 16px;
	font-size: 14px
}

.btnX.dark {
	background: #0f172a;
	color: #fff
}

.btnX.dark:hover {
	opacity: .92
}

.btnX.indigo {
	background: #4f46e5;
	color: #fff
}

.btnX.green {
	background: green;
	color: #fff
}

.btnX.indigo:hover {
	opacity: .92
}

.btnX.gray {
	background: #f3f4f6;
	color: #374151;
	border-color: #e5e7eb
}

.btnX.gray:hover {
	background: #e5e7eb
}

.btnX.danger {
	background: #ef4444;
	color: #fff
}

.btnX.danger:hover {
	opacity: .92
}

a.btnX.gray.md {
	margin-top: 13px;
}

#search-btn {
	margin-top: 13px;
}

.detail-wrap label {
	font-size: 11px;
	font-weight: 800;
	color: #6b7280
}

.detail-wrap input, .detail-wrap select {
	height: 42px;
	width: 100%;
	border: 1px solid #e5e7eb;
	border-radius: 12px;
	padding: 0 12px;
	outline: none;
	background: #fff
}

.detail-wrap input:focus, .detail-wrap select:focus {
	box-shadow: 0 0 0 3px rgba(79, 70, 229, .15);
	border-color: rgba(79, 70, 229, .35)
}

.tct-tabs {
	display: inline-flex;
	gap: 8px;
	flex-wrap: wrap
}

.tct-tabs button {
	border: 1px solid #e5e7eb;
	background: #fff;
	border-radius: 999px;
	padding: 8px 12px;
	font-weight: 900;
	font-size: 12px;
	cursor: pointer
}

.tct-tabs button.active {
	background: rgba(79, 70, 229, .12);
	border-color: rgba(79, 70, 229, .35);
	color: #3730a3
}

.tct-tab-body {
	display: none
}

.tct-tab-body.active {
	display: block
}

/* 상세 폼 하단 액션 바 */
.form-actions {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 12px;
	margin-top: 14px;
	padding-top: 14px;
	border-top: 1px solid #eef2f7;
}

.form-actions .left, .form-actions .right {
	display: flex;
	align-items: center;
	gap: 8px;
}

.form-actions .left form, .form-actions .right form {
	margin: 0;
}
</style>

<!-- =========================
     1) 상품 검색
========================== -->
<div class="card" style="margin-bottom: 14px;">
	<div class="panel-head"
		style="padding-bottom: 10px; padding-top: 10px;">
		<div class="panel-titlebox">
			<div class="icon-pill pill-blue">
				<i class="fas fa-search"></i>
			</div>
			<div>
				<h3 class="panel-title">상품 검색</h3>
				<p class="panel-desc">등록코드 / 상품명</p>
			</div>
		</div>
	</div>

	<form method="get" action="${ctx}/admin/prod/adminProducts.do"
		style="padding: 16px;">
		<input type="hidden" name="tab" value="list" />

		<div
			style="display: grid; grid-template-columns: 2fr 2fr auto; gap: 12px; align-items: end;">

			<div>
				<div style="font-size: 12px; font-weight: 900; color: #6b7280;">등록코드</div>
				<input id="filterRegId" name="qId" value="${param.qId}" type="text"
					placeholder="상품등록코드 or 패키지코드"
					style="margin-top: 8px; width: 100%; height: 44px; border: 1px solid #e5e7eb; border-radius: 14px; padding: 0 12px; outline: none;" />
			</div>

			<div>
				<div style="font-size: 12px; font-weight: 900; color: #6b7280;">상품명</div>
				<input id="filterRegTitle" name="qTitle" value="${param.qTitle}"
					type="text" placeholder="예: 오사카 3박4일"
					style="margin-top: 8px; width: 100%; height: 44px; border: 1px solid #e5e7eb; border-radius: 14px; padding: 0 12px; outline: none;" />
			</div>

			<div style="display: flex; gap: 8px;">
				<a class="btnX gray md"
					href="${ctx}/admin/prod/adminProducts.do?tab=list">초기화</a>
				<button type="submit" id="search-btn" class="btnX indigo md">검색</button>
			</div>

			<!-- 			<div> -->
			<!-- 				<div style="font-size: 12px; font-weight: 900; color: #6b7280;">분류</div> -->
			<!-- 				<select name="qType" -->
			<!-- 					style="margin-top: 8px; width: 100%; height: 44px; border: 1px solid #e5e7eb; border-radius: 14px; padding: 0 12px; outline: none; background: #fff;"> -->
			<%-- 					<option value="" ${empty param.qType ? 'selected' : ''}>전체</option> --%>
			<%-- 					<option value="REG" ${param.qType eq 'REG' ? 'selected' : ''}>등록상품</option> --%>
			<%-- 					<option value="PKG" ${param.qType eq 'PKG' ? 'selected' : ''}>패키지</option> --%>
			<!-- 				</select> -->
			<!-- 			</div> -->
		</div>


	</form>
</div>

<!-- =========================
 2) 목록 
========================== -->
<div class="panel-head"
	style="display: flex; align-items: center; justify-content: space-between; gap: 12px; padding-top: 5px; padding-bottom: 13px; ">
	<div class="panel-titlebox">
		<div class="icon-pill pill-blue">
			<i class="fas fa-list"></i>
		</div>
		<div>
			<h3 class="panel-title">목록</h3>
			<p class="panel-desc">

				<c:choose>
					<c:when test="${not empty regList}">${fn:length(regList)}건</c:when>
					<c:otherwise>0건</c:otherwise>
				</c:choose>
			</p>
		</div>
	</div>

	<!-- 상품등록 버튼 -->
	<button type="button" id="btn-new-regprod"
		class="btn bg-teal-600 hover:bg-teal-700 text-white"
		style="display: flex; align-items: center; gap: 8px; border: none; padding: 8px 16px; border-radius: 6px;">
		<i class="fas fa-plus"></i>새상품 등록
	</button>
</div>


<div style="overflow-x: auto;">
	<div id="regprod-new-host" style="display: none; margin-bottom: 14px;"></div>
	<table class="table" style="width: 100%;">
		<thead>
			<tr>
				<th>상품등록코드</th>
				<th>패키지코드</th>
				<th>등록상품명</th>
				<th>출발일</th>
				<th>도착일</th>
				<th>판매중</th>
				<th>가격</th>
				<th style="text-align: center;">관리</th>
			</tr>
		</thead>

		<tbody>
			<c:if test="${empty regList}">
				<tr>
					<td colspan="8" style="padding: 20px; text-align: center; color: #9ca3af;">
					상품 데이터가 없습니다.
					</td>
				</tr>
			</c:if>

			<c:forEach var="r" items="${regList}">
				<!-- 메인 행 -->
				<tr class="row-hover" data-regid="${fn:toLowerCase(r.regId)}"
					data-title="${fn:toLowerCase(r.regTitle)}">
					<td
						style="font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, 'Liberation Mono', 'Courier New', monospace;">
						<c:out value="${r.regId}" default="-" />
					</td>
					<td><c:out value="${r.pkgId}" default="-" /></td>
					<td style="font-weight: 900;"><c:out value="${r.regTitle}"
							default="-" /></td>
					<td><c:out value="${r.startDt}" default="-" /></td>
					<td><c:out value="${r.endDt}" default="-" /></td>
					<td
						style="font-weight:900; color:${fn:trim(r.forSale) == 'Y' ? '#00FF00' : '#6b7280'};">
						<c:out value="${fn:trim(r.forSale)}" default="-" />
					</td>
					<td><c:choose>
							<c:when test="${not empty r.regPrice}">
								<fmt:formatNumber value="${r.regPrice}" pattern="#,###" />
							</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose></td>
					<td style="text-align: center;">
						<button type="button" class="btnX dark btn-toggle"
							data-regid="${r.regId}">상세/수정</button>
					</td>
				</tr>

				<!-- 상세/수정(아코디언) -->
				<tr id="detail-${r.regId}" class="detail-row"
					style="display: none; background: #f8fafc;">
					<td colspan="8" style="padding: 16px;">

						<div class="detail-wrap"
							style="background: #fff; border: 1px solid #eef2f7; border-radius: 16px; padding: 16px;">

							<!-- 헤더 -->
							<div
								style="display: flex; align-items: flex-start; justify-content: space-between; gap: 12px;">
								<div>
									<div style="font-weight: 900; font-size: 15px; color: #0f172a;">상품상세 / 수정</div>
									<div style="margin-top: 4px; font-size: 12px; color: #94a3b8;"></div>
								</div>
								<button type="button" class="btnX gray btn-close"
									data-regid="${r.regId}">접기</button>
							</div>

							<!-- 탭 버튼 -->
							<div style="margin-top: 14px;">
								<div class="tct-tabs">
									<button type="button" class="tab-btn active"
										data-target="tab-reg-${r.regId}" data-async="false">등록상품정보</button>
									<button type="button" class="tab-btn"
										data-target="tab-pkg-item-${r.regId}" data-async="true">패키지아이템</button>
									<button type="button" class="tab-btn"
										data-target="tab-img-${r.regId}" data-async="true">이미지
										관리</button>
								</div>

								<!-- =======================
             					등록상품 탭(동기 렌더 + JS 비동기 저장)
        						======================== -->
								<div id="tab-reg-${r.regId}" class="tct-tab-body active"
									style="margin-top: 14px;">

									<form class="reg-update-form" data-regid="${r.regId}">
										<input type="hidden" name="regId" value="${r.regId}" /> <input
											type="hidden" name="pkgId" value="${r.pkgId}" />

										<div
											style="display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px;">

											<div>
												<label>상품등록코드</label> <input type="text" value="${r.regId}"
													disabled />
											</div>

											<div>
												<label>패키지코드</label> <input type="text" value="${r.pkgId}"
													disabled />
											</div>

											<div>
												<label>판매중</label> <select name="forSale">
													<option value="Y"
														<c:if test="${fn:trim(r.forSale) == 'Y'}">selected</c:if>>Y</option>
													<option value="N"
														<c:if test="${fn:trim(r.forSale) == 'N'}">selected</c:if>>N</option>
												</select>
											</div>

											<div>
												<label>판매시작일</label> <input type="date" name="saleStartDt"
													value="${fn:substring(r.saleStartDt,0,10)}" />
											</div>

											<div>
												<label>판매종료일</label> <input type="date" name="saleEndDt"
													value="${fn:substring(r.saleEndDt,0,10)}" />
											</div>

											<div>
												<label>가격</label> <input type="number" name="regPrice"
													value="${r.regPrice}" min="0" step="10000" />
											</div>

											<div>
												<label>출발일</label> <input type="date" name="startDt"
													value="${fn:substring(r.startDt,0,10)}" />
											</div>

											<div>
												<label>도착일</label> <input type="date" name="endDt"
													value="${fn:substring(r.endDt,0,10)}" />
											</div>

											<div>
												<label>수용가능인원</label> <input type="number" name="regQty"
													value="${r.regQty}" min="0" step="1" />
											</div>

											<div style="grid-column: 1/-1;">
												<label>등록상품명</label> <input type="text" name="regTitle"
													value="${r.regTitle}" />
											</div>

											<div style="grid-column: 1/-1;">
												<label>핵심문구</label> <input type="text" name="highlight"
													value="${r.highlight}" />
											</div>

											<div style="grid-column: 1/-1;">
												<label>설명A</label> <input type="text" name="descriptionA"
													value="${r.descriptionA}" />
											</div>

											<div style="grid-column: 1/-1;">
												<label>설명B</label> <input type="text" name="descriptionB"
													value="${r.descriptionB}" />
											</div>

										</div>

										<div class="form-actions">
											<div class="left">
												<label>&nbsp;</label>
											</div>
											<div class="right">
												<button type="button" class="btnX gray md btn-cancel"
													data-regid="${r.regId}">취소</button>
												<button type="submit" class="btnX indigo md btn-reg-update">적용(수정)</button>
											</div>
										</div>

									</form>

								</div>

								<!-- =======================
        					     패키지아이템 탭(비동기)
       							 ======================== -->
								<div id="tab-pkg-item-${r.regId}" class="tct-tab-body"
									style="margin-top: 14px;">
									<div class="async-panel" data-loaded="0"
										data-regid="${r.regId}">
										<div id="pkgitem-container-${r.regId}" class="async-container"></div>
									</div>
								</div>

								<!-- =======================
          						   이미지 관리 탭(비동기)
      							  ======================== -->
								<div id="tab-img-${r.regId}" class="tct-tab-body"
									style="margin-top: 14px;">
									<div class="async-panel" data-loaded="0"
										data-regid="${r.regId}">
										<div id="img-container-${r.regId}" class="async-container"></div>
									</div>
								</div>

							</div>
							<!-- /margin-top:14px(탭 영역 전체) -->

						</div> <!-- /.detail-wrap -->

					</td>
				</tr>

			</c:forEach>
		</tbody>
	</table>
</div>

<script>
    // JSTL 변수 ${ctx}의 값을 자바스크립트 상수 contextPath에 할당
    window.contextPath = '${ctx}'; 
</script>
<script	src="${pageContext.request.contextPath}/assets/js/admin_prod/ad_regimg.js"></script>
<script	src="${pageContext.request.contextPath}/assets/js/admin_prod/ad_regprod.js"></script>
<script	src="${pageContext.request.contextPath}/assets/js/admin_prod/ad_regpkgitem.js"></script>

<script>
  // 한 번에 하나만 열리게 (회원관리 UX)
  const openDetail = (regId) => {
    document.querySelectorAll(".detail-row").forEach(r => r.style.display = "none");
    const row = document.getElementById("detail-" + regId);
    if(!row) return;
    row.style.display = "";
    row.scrollIntoView({ behavior:"smooth", block:"center" });
  };
  const closeDetail = (regId) => {
    const row = document.getElementById("detail-" + regId);
    if(!row) return;
    row.style.display = "none";
  };

  document.querySelectorAll(".btn-toggle").forEach(btn=>{
    btn.addEventListener("click", ()=>{
      const regId = btn.dataset.regid;
      const row = document.getElementById("detail-" + regId);
      if(!row) return;
      const hidden = (row.style.display === "none" || row.style.display === "");
      if(hidden) openDetail(regId);
      else closeDetail(regId);
    });
  });
  document.querySelectorAll(".btn-close").forEach(btn=>{
    btn.addEventListener("click", ()=> closeDetail(btn.dataset.regid));
  });
  document.querySelectorAll(".btn-cancel").forEach(btn=>{
    btn.addEventListener("click", ()=> closeDetail(btn.dataset.regid));
  });

  // 탭 전환(각 상세영역 내부에서만)
  document.querySelectorAll(".tab-btn").forEach(btn=>{
    btn.addEventListener("click", ()=>{	// 탭 리스너
      console.log("[tab click]", btn.dataset.target);	// 탭 리스너 콘솔로그 확인용
    	
      const wrap = btn.closest(".detail-wrap");
      if(!wrap) return;

      wrap.querySelectorAll(".tab-btn").forEach(b=> b.classList.remove("active"));
      btn.classList.add("active");

      wrap.querySelectorAll(".tct-tab-body").forEach(b=> b.classList.remove("active"));
      const target = document.getElementById(btn.dataset.target);
      if(target) target.classList.add("active");
      
      const targetId = btn.dataset.target;

      if (targetId.startsWith("tab-img-")) {
        const regId = targetId.replace("tab-img-", "");
        window.loadRegImg?.(regId);
      }

      if (targetId.startsWith("tab-pkg-item-")) {
        const regId = targetId.replace("tab-pkg-item-", "");
        window.loadPkgItems?.(regId);
    	}
    });
  });
  
  
  
  // 서치바 키업 필터링 기능
  (function(){
    const idInput = document.getElementById("filterRegId");
    const titleInput = document.getElementById("filterRegTitle");
    if(!idInput || !titleInput) return;

    const form = idInput.closest("form"); // 검색 폼
    if(form){
      // 실시간만: 폼 submit 자체를 막음(엔터 포함)
      form.addEventListener("submit", (e)=> e.preventDefault());
    }

    function norm(s){
      return (s || "").toString().trim().toLowerCase();
    }

    function applyFilter(){
      const qId = norm(idInput.value);
      const qTitle = norm(titleInput.value);

      document.querySelectorAll("tbody tr.row-hover").forEach(mainRow => {
        const regId = mainRow.dataset.regid || "";
        const title = mainRow.dataset.title || "";

        // AND 조건: 둘 다 입력되면 둘 다 포함해야 통과
        const ok =
          (qId === "" || regId.includes(qId)) &&
          (qTitle === "" || title.includes(qTitle));

        mainRow.style.display = ok ? "" : "none";

        // 상세 아코디언 행도 같이 숨김(열려있던 건 닫기)
        const rid = mainRow.querySelector(".btn-toggle")?.dataset?.regid;
        const detailRow = rid ? document.getElementById("detail-" + rid) : null;
        if(detailRow && !ok) detailRow.style.display = "none";
      });
    }

    idInput.addEventListener("input", applyFilter);
    titleInput.addEventListener("input", applyFilter);

    // 엔터 눌러도 아무 일 없게
    [idInput, titleInput].forEach(inp=>{
      inp.addEventListener("keydown", (e)=>{
        if(e.key === "Enter") e.preventDefault();
      });
    });

    applyFilter(); // 초기 1회
  })();

</script>


