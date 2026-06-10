<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!--
  items_create.jsp
  - "상품관리 > +아이템 관리" 탭에서 로드되는 화면(프래그먼트) 용도
  - 기존 admin-dashboard.css (card/panel-head/btn 등) 스타일을 그대로 사용
  - 아래 form action(URL)만 프로젝트 컨트롤러 매핑에 맞게 조정하면 됩니다.
-->

<style>
/* ✅ item 화면에서만 쓰는 최소 스타일(기존 공통CSS는 그대로 사용) */
#item-create-root label {
  display: block;
  font-weight: 900;
  color: #0f172a;
  margin-bottom: 6px;
  font-size: 13px;
}

#item-create-root input[type="text"],
#item-create-root select {
  width: 100%;
  height: 40px;
  padding: 0 12px;
  border-radius: 12px;
  border: 1px solid rgba(15, 23, 42, .18);
  background: #ffffff;
  color: #0f172a;
  outline: none;
  transition: border-color .15s ease, box-shadow .15s ease;
}

#item-create-root input:focus,
#item-create-root select:focus {
  border-color: rgba(27, 123, 255, .65);
  box-shadow: 0 0 0 4px rgba(27, 123, 255, .15);
}

.item-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 12px;
}

@media (max-width: 820px) {
  .item-grid { grid-template-columns: 1fr; }
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

.mono {
  font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas,
    "Liberation Mono", "Courier New", monospace;
}

/* ===== Search Select (ss) : 예쁜 드롭다운 스타일 ===== */
.ss { position: relative; display: grid; gap: 8px; }
.ss label { font-weight: 800; font-size: 14px; color: #0f172a; }

/* input */
.ss-input{
  width: 100%;
  border: 1px solid rgba(15,23,42,.16);
  background: #fff;
  border-radius: 14px;
  padding: 12px 44px 12px 14px; /* 우측 화살표 공간 */
  font-size: 14px;
  color: #0f172a;
  outline: none;
  box-shadow: 0 1px 0 rgba(15,23,42,.02);
}

.ss-input:focus{
  border-color: rgba(59,130,246,.65);
  box-shadow: 0 0 0 3px rgba(59,130,246,.18);
}

/* 우측 화살표 */
.ss::after{
  content: "▾";
  position: absolute;
  right: 14px;
  top: 38px;            /* label 높이에 맞춰 조정 */
  color: #64748b;
  font-size: 14px;
  pointer-events: none;
}

/* dropdown panel */
.ss-menu{
  position: absolute;
  left: 0;
  right: 0;
  top: calc(100% + 8px);
  background: #fff;
  border: 1px solid rgba(15,23,42,.12);
  border-radius: 14px;
  box-shadow: 0 14px 28px rgba(15,23,42,.12);
  overflow: hidden;
  z-index: 40;

  max-height: 280px;
  overflow: auto;
}

/* empty */
.ss-empty{
  padding: 12px 14px;
  font-size: 13px;
  color: #64748b;
}

/* item button = 한 줄에 좌/우 정렬 */
.ss-item{
  width: 100%;
  border: 0;
  background: transparent;
  text-align: left;

  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;

  padding: 12px 14px;
  cursor: pointer;
}

/* 왼쪽 이름(굵게) */
.ss-item span{
  font-weight: 900;
  color: #0f172a;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* 오른쪽 코드(작게, 모노) */
.ss-sub{
  font-size: 12px;
  color: #64748b;
  font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
  white-space: nowrap;
}

/* hover/active */
.ss-item:hover{ background: rgba(59,130,246,.08); }
.ss-item.is-active{ background: rgba(59,130,246,.12); }

</style>

<div id="item-create-root" data-ctx="${ctx}">

  <!-- ✅ 화면 타이틀 영역 (원하는대로 텍스트만 바꾸면 됨) -->
  <div class="card" style="margin-bottom: 14px;">
    <div class="panel-head" style="padding-bottom: 10px; padding-top: 10px;">
      <div class="panel-titlebox">
        <div class="icon-pill pill-indigo">
          <i class="fas fa-cubes"></i>
        </div>
        <div>
          <h3 class="panel-title">ITEM 생성</h3>
          <p class="panel-desc">아이템코드/아이템명/지역코드/테마패키지코드를 입력해 ITEM을 등록합니다.</p>
        </div>
      </div>
    </div>

    <div class="panel-body" style="padding-top: 10px;">

      <!-- ✅ 서버가 msg를 내려주면 표시(등록 성공/실패 메시지 용) -->
      <c:if test="${not empty msg}">
        <div class="alert" style="margin-bottom: 12px;">
          ${msg}
        </div>
      </c:if>

      <!--
        ✅ action 매핑 예시
          - 컨트롤러: /admin/item/insert.do (POST)
          - 프로젝트에 맞게 변경하세요.
      -->
      <form id="itemCreateForm" method="post" action="${ctx}/admin/prod/createItem.do">
      
      <input type="hidden" name="tab" value="create_item">

        <div class="item-grid">
          <!-- 아이템코드 (ITEM_ID) -->
          <div>
            <label>아이템코드</label>
            <input type="text" name="itemId" class="mono" placeholder="예) PARCUL101" />
            <div class="help">ITEM.ITEM_ID</div>
          </div>

          <!-- 아이템명 (ITEM_TITLE) -->
          <div>
            <label>아이템명</label>
            <input type="text" name="itemTitle" placeholder="예) 개선문 & 샹제리제 거리 투어 " />
            <div class="help">ITEM.ITEM_TITLE</div>
          </div>
          
		<!-- ✅ 지역: 검색형 드롭다운 -->
		<div class="ss" data-ss="loc">
		  <label>대표지역</label>
		
		  <!-- 화면 표시/검색 -->
		  <input type="text" class="ss-input" placeholder="지역명을 입력해서 검색…" autocomplete="off" />
		
		  <!-- 실제 제출 값 -->
		  <input type="hidden" name="locId" class="ss-value" value="" />
		
		  <div class="ss-menu" hidden>
		    <c:if test="${empty locationList}">
		      <div class="ss-empty">locationList 비어있음 (컨트롤러 setAttribute 확인)</div>
		    </c:if>
		
		    <c:forEach var="l" items="${locationList}">
		      <button type="button" class="ss-item"
		              data-value="${l.locId}"
		              data-label="${l.locName}">
		        <span>${l.locName}</span>
		        <small class="ss-sub">LOC_ID: ${l.locId}</small>
		      </button>
		    </c:forEach>
		  </div>
		
		  <div class="help">ITEM.LOC_ID</div>
		</div>
		
		<!-- ✅ 메인 테마: 검색형 드롭다운 -->
		<div class="ss" data-ss="theme">
		  <label>메인 테마</label>
		
		  <!-- 화면 표시/검색 -->
		  <input type="text" class="ss-input" placeholder="테마명을 입력해서 검색…" autocomplete="off" />
		
		  <!-- 실제 제출 값 -->
		  <input type="hidden" name="themeId" class="ss-value" value="" />
		
		  <div class="ss-menu" hidden>
		    <c:if test="${empty pThemeList}">
		      <div class="ss-empty">pThemeList 비어있음 (컨트롤러 setAttribute 확인)</div>
		    </c:if>
		
		    <c:forEach var="t" items="${pThemeList}">
		      <button type="button" class="ss-item"
		              data-value="${t.themeId}"
		              data-label="${t.themeTitle}">
		        <span>${t.themeTitle}</span>
		        <small class="ss-sub">THEME_ID: ${t.themeId}</small>
		      </button>
		    </c:forEach>
		  </div>
		
		  <div class="help">ITEM.THEME_ID</div>
		</div>

          <!-- 버튼 영역 -->
          <div style="display:flex; gap:10px; align-items:flex-end;">
            <button type="submit" class="btn btn-indigo" form="itemCreateForm" style="flex:1;">
              <i class="fas fa-plus"></i> 아이템 생성
            </button>
            <button type="button" class="btn btn-ghost" id="btnItemReset" title="입력 초기화">
              <i class="fas fa-rotate-right"></i>
            </button>
          </div>
        </div>

        <div class="divider"></div>
      </form>
    </div>
  </div>
</div>

<script>
(function(){
  const form = document.getElementById('itemCreateForm');
  const btnReset = document.getElementById('btnItemReset');
  if(!form) return;

  // ✅ 입력값 trim + 간단 필수 검증
  form.addEventListener('submit', function(e){
    const itemId = form.itemId?.value?.trim();
    const itemTitle = form.itemTitle?.value?.trim();
    const locId = form.locId?.value?.trim();
    const themeId = form.themeId?.value?.trim();

    if(!itemId || !itemTitle || !locId || !themeId){
      e.preventDefault();
      alert('아이템코드/아이템명/지역코드/테마패키지코드는 필수입니다.');
      return;
    }
  });

  btnReset?.addEventListener('click', function(){
    form.reset();
    form.itemId?.focus?.();
  });
})();
</script>
<script src="${ctx}/assets/js/admin_prod/ad_item.js"></script>