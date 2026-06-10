// /assets/js/admin_prod/ad_regpkgitem.js
(function() {
	"use strict";

	// JSP에서: window.contextPath = "${ctx}";
	const contextPath = window.contextPath || "";

	function esc(s) {
		return String(s ?? "").replace(/[&<>"']/g, (m) => ({
			"&": "&amp;",
			"<": "&lt;",
			">": "&gt;",
			'"': "&quot;",
			"'": "&#39;"
		}[m]));
	}

	function renderPkgItems(data) {
		const header = data?.header || {};
		const items = data?.items || [];

		const headCard = `
      <div class="card" style="margin-bottom:14px;">
        <div class="panel-head" style="padding:10px 14px;">
          <div class="panel-titlebox">
            <div class="icon-pill pill-blue"><i class="fas fa-boxes-stacked"></i></div>
            <div>
              <h3 class="panel-title">패키지아이템</h3>
            </div>
          </div>
        </div>
      </div>`;

		const meta = `
      <div class="card" style="padding:14px;margin-bottom:14px;">
        <div style="display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:12px;">
          <div>
            <label>등록상품코드</label>
            <input type="text" value="${esc(header.regId)}" disabled />
          </div>
          <div>
            <label>패키지코드</label>
            <input type="text" value="${esc(header.packageId)}" disabled />
          </div>
          <div>
            <label>테마</label>
            <input type="text" value="${esc(header.themeTitle)}" disabled />
          </div>
          <div style="grid-column:1/-1;">
            <label>패키지명</label>
            <input type="text" value="${esc(header.packageTitle)}" disabled />
          </div>
        </div>
      </div>`;

		if (!items.length) {
			return headCard + meta + `
        <div class="card" style="padding:14px;border:1px dashed #e5e7eb;border-radius:14px;color:#64748b;font-weight:700;">
          포함된 아이템이 없습니다.
        </div>`;
		}

		const rows = items.map((it, idx) => `
      <tr>
	  <td style="white-space:nowrap;">${esc(it.byDate ?? "-")}</td>
        <td style="white-space:nowrap;">${esc(it.itemId)}</td>
        <td>${esc(it.itemTitle)}</td>
        <td style="white-space:nowrap;">${esc(it.ctryName || "-")}</td>
        <td style="white-space:nowrap;">${esc(it.locName || "-")}</td>
      </tr>
    `).join("");

		const table = `
      <div class="card" style="padding:14px;">
        <div style="overflow-x:auto;">
          <table class="table" style="width:100%;">
            <thead>
              <tr>
                <th>일차</th>
                <th>아이템ID</th>
                <th>아이템명</th>
                <th>국가</th>
                <th>지역</th>
              </tr>
            </thead>
            <tbody>${rows}</tbody>
          </table>
        </div>
      </div>`;

		return headCard + meta + table;
	}

	function renderError(msg) {
		return `
      <div class="card" style="padding:14px;color:#ef4444;font-weight:800;">
        ${esc(msg || "오류가 발생했습니다.")}
      </div>`;
	}

	function renderLoading() {
		return `<div class="card" style="padding:14px;">로딩중...</div>`;
	}

	/**
	 * 패키지아이템 탭 로드 (비동기)
	 * - JSP 탭 클릭 코드에서 loadPkgItems(regId)만 호출하면 됨.
	 */
	async function loadPkgItems(regId, opt = {}) {
		const pane = document.getElementById(`tab-pkg-item-${regId}`);
		if (!pane) return;

		const panel = pane.querySelector(`.async-panel[data-regid="${regId}"]`);
		const host = panel?.querySelector(".async-container");
		if (!panel || !host) return;

		// 기본: 1번만 로드. 강제 재로딩은 opt.force=true
		if (panel.dataset.loaded === "1" && !opt.force) return;

		host.innerHTML = renderLoading();

		try {
			const url = `${contextPath}/admin/prod/reg/pkgItems.do?regId=${encodeURIComponent(regId)}`;
			const resp = await fetch(url, { headers: { "Accept": "application/json" } });
			console.log("FETCH:", url);

			const json = await resp.json().catch(() => null);
			if (!resp.ok || !json) {
				host.innerHTML = renderError("서버 응답이 올바르지 않습니다.");
				return;
			}

			if (json.ok !== true) {
				host.innerHTML = renderError(json.message || "조회 실패");
				return;
			}

			host.innerHTML = renderPkgItems(json.data);
			panel.dataset.loaded = "1";
		} catch (e) {
			host.innerHTML = renderError("네트워크 오류");
		}
	}

	// 외부(JSP inline script)에서 호출할 수 있게 export
	window.loadPkgItems = loadPkgItems;
})();
