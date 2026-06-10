<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<style>
.btnX{
  display:inline-flex; align-items:center; justify-content:center;
  height:36px; padding:0 12px; border-radius:12px;
  font-weight:800; font-size:12px; cursor:pointer; user-select:none;
  border:1px solid transparent;
  transition:opacity .15s ease, background-color .15s ease;
  white-space:nowrap;
}
.btnX.md{height:44px; padding:0 16px; font-size:14px}
.btnX.dark{background:#0f172a; color:#fff}
.btnX.dark:hover{opacity:.92}
.btnX.gray{background:#f3f4f6; color:#374151; border-color:#e5e7eb}
.btnX.gray:hover{background:#e5e7eb}

.badgeCount{font-size:12px; font-weight:900; color:#64748b}
.muted{color:#94a3b8}
.mono{font-family:ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, 'Liberation Mono', 'Courier New', monospace;}

.detail-wrap label{font-size:11px; font-weight:900; color:#64748b}
.detail-wrap input{
  height:42px; width:100%;
  border:1px solid #e5e7eb; border-radius:12px; padding:0 12px;
  outline:none; background:#fff;
}
.detail-wrap input:disabled{
  background:#f8fafc;
  color:#334155;
  border-color:#e5e7eb;
  cursor:not-allowed;
}
</style>

<!-- =========================
  1) 아이템 검색 (입력 즉시 필터링 - 클라이언트)
========================== -->
<div class="card" style="margin-bottom:14px;">
  <div class="panel-head" style="padding-bottom:10px; padding-top:10px;">
    <div class="panel-titlebox">
      <div class="icon-pill pill-blue"><i class="fas fa-search"></i></div>
      <div>
        <h3 class="panel-title">아이템 검색</h3>
        <p class="panel-desc">아이템코드 / 아이템명 (입력 즉시 검색)</p>
      </div>
    </div>
  </div>

  <!-- 서버로 submit 안함: JS로만 필터링 -->
  <div style="padding:16px;">
    <div style="display:grid; grid-template-columns:2fr 2fr auto; gap:12px; align-items:end;">
      <div>
        <div style="font-size:12px; font-weight:900; color:#6b7280;">아이템코드</div>
        <input id="qItemId" type="text" placeholder="예: ZI, SEOUL..."
          style="margin-top:8px; width:100%; height:44px; border:1px solid #e5e7eb; border-radius:14px; padding:0 12px; outline:none;" />
      </div>

      <div>
        <div style="font-size:12px; font-weight:900; color:#6b7280;">아이템명</div>
        <input id="qItemTitle" type="text" placeholder="예: 서울, 힐링..."
          style="margin-top:8px; width:100%; height:44px; border:1px solid #e5e7eb; border-radius:14px; padding:0 12px; outline:none;" />
      </div>

      <div style="display:flex; gap:8px;">
        <button type="button" id="btnReset" class="btnX gray md">초기화</button>
      </div>
    </div>

    <div style="margin-top:10px; display:flex; justify-content:space-between; align-items:center;">
      <div class="muted" style="font-size:12px;">
        * 대소문자 무시, 포함 검색
      </div>
      <div class="badgeCount">
        표시 <span id="visibleCount">0</span> / 전체 <c:out value="${itemTotalCount}" default="0"/> 건
      </div>
    </div>
  </div>
</div>

<!-- =========================
  2) 아이템 목록 (상세 + 삭제만)
========================== -->
<div class="panel-head"
  style="display:flex; align-items:center; justify-content:space-between; gap:12px; padding-top:5px; padding-bottom:13px;">
  <div class="panel-titlebox">
    <div class="icon-pill pill-blue"><i class="fas fa-list"></i></div>
    <div>
      <h3 class="panel-title">아이템 목록</h3>
      <p class="panel-desc">
        <c:out value="${itemTotalCount}" default="0" />건
      </p>
    </div>
  </div>
</div>

<div style="overflow-x:auto;">
  <table class="table" style="width:100%;">
    <thead>
      <tr>
        <th>아이템코드</th>
        <th>아이템명</th>
        <th>지역코드</th>
        <th>테마패키지코드</th>
        <th style="text-align:center;">관리</th>
      </tr>
    </thead>

    <tbody id="itemTbody">
      <c:if test="${empty itemList}">
        <tr>
          <td colspan="5" style="padding:18px; text-align:center; color:#94a3b8;">
            아이템 데이터가 없습니다.
          </td>
        </tr>
      </c:if>

      <c:forEach var="it" items="${itemList}">
        <!-- 메인 행 -->
        <tr class="row-hover item-row"
          data-itemid="${fn:toLowerCase(it.itemId)}"
          data-title="${fn:toLowerCase(it.itemTitle)}">
          <td class="mono"><c:out value="${it.itemId}" default="-" /></td>
          <td style="font-weight:900;"><c:out value="${it.itemTitle}" default="-" /></td>
          <td><c:out value="${it.locId}" default="-" /></td>
          <td><c:out value="${it.themeId}" default="-" /></td>
          <td style="text-align:center;">
            <button type="button" class="btnX dark btn-detail" data-itemid="${it.itemId}">상세</button>
          </td>
        </tr>

        <!-- 상세(읽기) + 삭제 -->
		<tr id="detail-${it.itemId}" class="detail-row" style="display:none; background:#f8fafc;">
		  <td colspan="5" style="padding:16px;">
		    <div class="detail-wrap" style="background:#fff; border:1px solid #eef2f7; border-radius:16px; padding:16px;">
		
		      <div style="display:flex; align-items:flex-start; justify-content:space-between; gap:12px;">
		        <div>
		          <div style="font-weight:900; font-size:15px; color:#0f172a;">아이템 상세</div>
		          <div style="margin-top:4px; font-size:12px; color:#94a3b8;">
		            아이템코드:
		            <span class="mono"><c:out value="${it.itemId}" /></span>
		          </div>
		        </div>
		        <button type="button" class="btnX gray btn-close" data-itemid="${it.itemId}">접기</button>
		      </div>
		
		      <div style="margin-top:14px; display:grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap:12px;">
		        <div>
		          <label>아이템코드</label>
		          <input type="text" value="${it.itemId}" disabled />
		        </div>
		
		        <div>
		          <label>아이템명</label>
		          <input type="text" value="${it.itemTitle}" disabled />
		        </div>
		
		        <div>
		          <label>지역코드</label>
		          <input type="text" value="${it.locId}" disabled />
		        </div>
		
		        <div>
		          <label>테마패키지코드</label>
		          <input type="text" value="${it.themeId}" disabled />
		        </div>
		      </div>
		
		      <div style="margin-top:16px; padding-top:14px; border-top:1px solid #eef2f7; display:flex; justify-content:flex-end;">
		        <form method="post" action="${ctx}/admin/prod/deleteItem.do"
		              onsubmit="return confirm('정말 삭제할까요?');" style="margin:0;">
		          <input type="hidden" name="tab" value="create_item" />
		          <input type="hidden" name="itemId" value="${it.itemId}" />
		          <button type="submit" class="btnX gray md" style="border-color:#ef4444; color:#ef4444;">
		            삭제
		          </button>
		        </form>
		      </div>
		
		    </div>
		  </td>
		</tr>
      </c:forEach>
    </tbody>
  </table>
</div>

<script>
(function(){
  const qItemIdEl = document.getElementById('qItemId');
  const qTitleEl  = document.getElementById('qItemTitle');
  const btnReset  = document.getElementById('btnReset');
  const visibleCountEl = document.getElementById('visibleCount');

  // ✅ 한 번에 하나만 상세 열기
  function closeAllDetails(){
    document.querySelectorAll('.detail-row').forEach(r => r.style.display = 'none');
  }
  function toggleDetail(itemId){
    const row = document.getElementById('detail-' + itemId);
    if(!row) return;
    const isHidden = (row.style.display === 'none' || row.style.display === '');
    closeAllDetails();
    row.style.display = isHidden ? '' : 'none';
    if(isHidden) row.scrollIntoView({behavior:'smooth', block:'center'});
  }

  document.querySelectorAll('.btn-detail').forEach(btn=>{
    btn.addEventListener('click', ()=> toggleDetail(btn.dataset.itemid));
  });
  document.querySelectorAll('.btn-close').forEach(btn=>{
    btn.addEventListener('click', ()=> {
      const row = document.getElementById('detail-' + btn.dataset.itemid);
      if(row) row.style.display = 'none';
    });
  });

  // ✅ 즉시 검색(클라이언트 필터)
  function applyFilter(){
    const qId = (qItemIdEl.value || '').trim().toLowerCase();
    const qT  = (qTitleEl.value  || '').trim().toLowerCase();

    // 상세가 열려있던 상태에서 필터링하면 UX가 꼬일 수 있어서 닫음
    closeAllDetails();

    let visible = 0;
    document.querySelectorAll('#itemTbody .item-row').forEach(tr=>{
      const id = tr.dataset.itemid || '';
      const title = tr.dataset.title || '';

      const okId = !qId || id.includes(qId);
      const okT  = !qT  || title.includes(qT);
      const show = okId && okT;

      tr.style.display = show ? '' : 'none';

      // 바로 아래 상세row도 같이 숨김 처리
      const itemId = tr.querySelector('.btn-detail')?.dataset.itemid;
      const detail = itemId ? document.getElementById('detail-' + itemId) : null;
      if(detail) detail.style.display = 'none';

      if(show) visible++;
    });

    if(visibleCountEl) visibleCountEl.textContent = String(visible);
  }

  // 입력 즉시 적용
  qItemIdEl?.addEventListener('input', applyFilter);
  qTitleEl?.addEventListener('input', applyFilter);

  btnReset?.addEventListener('click', ()=>{
    qItemIdEl.value = '';
    qTitleEl.value = '';
    applyFilter();
    qItemIdEl.focus();
  });

  // 초기 표시 count 맞추기
  applyFilter();
})();
</script>
