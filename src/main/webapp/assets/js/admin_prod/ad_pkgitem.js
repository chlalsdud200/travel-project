// /assets/js/admin_prod/ad_pkgitem.js
(function () {
  "use strict";

  // -------------------------
  // helpers
  // -------------------------
  function qs(sel, root = document) { return root.querySelector(sel); }

  async function getJson(url) {
    const res = await fetch(url, { method: "GET" });
    const json = await res.json().catch(() => null);
    if (!res.ok) throw new Error(json?.message || ("HTTP " + res.status));
    return json;
  }

  async function postJson(url, body) {
    const res = await fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json;charset=UTF-8" },
      body: JSON.stringify(body || {})
    });
    const json = await res.json().catch(() => null);
    if (!res.ok) throw new Error(json?.message || ("HTTP " + res.status));
    return json;
  }

  function debounce(fn, ms = 150) {
    let t = null;
    return (...args) => {
      clearTimeout(t);
      t = setTimeout(() => fn(...args), ms);
    };
  }

  // -------------------------
  // searchable select (지역/테마)
  // -------------------------
  function initSearchSelect(ss) {
    const input = ss.querySelector(".ss-input");
    const hidden = ss.querySelector(".ss-value");
    const menu = ss.querySelector(".ss-menu");
    const items = Array.from(ss.querySelectorAll(".ss-item"));
    if (!input || !hidden || !menu) return;

    let emptyNode = ss.querySelector(".ss-empty");
    if (!emptyNode) {
      emptyNode = document.createElement("div");
      emptyNode.className = "ss-empty";
      emptyNode.textContent = "일치하는 항목이 없습니다.";
      emptyNode.style.display = "none";
      menu.appendChild(emptyNode);
    }

    let activeIdx = -1;

    function openMenu() { menu.hidden = false; }
    function closeMenu() {
      menu.hidden = true;
      activeIdx = -1;
      items.forEach(i => i.classList.remove("is-active"));
    }

    function setActive(idx) {
      items.forEach(i => i.classList.remove("is-active"));
      activeIdx = idx;
      if (idx >= 0 && idx < items.length && items[idx].style.display !== "none") {
        items[idx].classList.add("is-active");
        items[idx].scrollIntoView({ block: "nearest" });
      }
    }

    function filter(q) {
      const qq = (q || "").trim().toLowerCase();
      let visibleCount = 0;

      items.forEach((btn) => {
        const label = (btn.dataset.label || btn.textContent || "").toLowerCase();
        const ok = !qq || label.includes(qq);
        btn.style.display = ok ? "" : "none";
        if (ok) visibleCount++;
      });

      emptyNode.style.display = visibleCount === 0 ? "" : "none";

      const firstVisible = items.find(i => i.style.display !== "none");
      setActive(firstVisible ? items.indexOf(firstVisible) : -1);
    }

    function choose(btn) {
      const value = btn.dataset.value || "";
      const label = btn.dataset.label || btn.textContent.trim();
      hidden.value = value;
      input.value = label;
      closeMenu();

      ss.dispatchEvent(new CustomEvent("ss:change", {
        bubbles: true,
        detail: { value, label }
      }));
    }

    input.addEventListener("focus", () => { openMenu(); filter(input.value); });
    input.addEventListener("click", () => { openMenu(); filter(input.value); });
    input.addEventListener("input", () => { openMenu(); filter(input.value); });

    input.addEventListener("keydown", (e) => {
      const visible = items
        .map((it, idx) => ({ it, idx }))
        .filter(x => x.it.style.display !== "none");

      if (e.key === "ArrowDown") {
        e.preventDefault();
        if (menu.hidden) openMenu();
        if (visible.length === 0) return;
        const curPos = visible.findIndex(x => x.idx === activeIdx);
        const nextPos = curPos < 0 ? 0 : Math.min(curPos + 1, visible.length - 1);
        setActive(visible[nextPos].idx);
      } else if (e.key === "ArrowUp") {
        e.preventDefault();
        if (visible.length === 0) return;
        const curPos = visible.findIndex(x => x.idx === activeIdx);
        const nextPos = curPos < 0 ? 0 : Math.max(curPos - 1, 0);
        setActive(visible[nextPos].idx);
      } else if (e.key === "Enter") {
        if (menu.hidden) return;
        e.preventDefault();
        const btn = items[activeIdx];
        if (btn && btn.style.display !== "none") choose(btn);
      } else if (e.key === "Escape") {
        closeMenu();
      }
    });

    menu.addEventListener("click", (e) => {
      const btn = e.target.closest(".ss-item");
      if (btn) choose(btn);
    });

    document.addEventListener("click", (e) => {
      if (!ss.contains(e.target)) closeMenu();
    });

    closeMenu();
  }

  // -------------------------
  // packageItem 카드 활성 + pkgId 표시
  // -------------------------
  function setStep2Enabled(root, pkgId) {
    const card2 = root.querySelector('.card[data-section="packageItem"]');
    const badge = root.querySelector(".pkg-id-badge");
    const view  = root.querySelector(".pkg-id-view");

    if (view) view.value = pkgId || "";
    if (badge) badge.textContent = pkgId || "{package_id}";

    if (card2) {
      card2.classList.remove("is-disabled");
      card2.style.opacity = "1";
      card2.style.pointerEvents = "auto";
    }

    root.dataset.createdPkgid = pkgId || "";
  }

  // =========================================================
  // ITEM 자동완성 (portal)
  // =========================================================
  const ITEM_LIMIT = 30;

  function initItemSS(wrap, CTX) {
    if (!wrap || wrap.dataset.bound === "1") return;

    const input  = wrap.querySelector(".item-ss-input");
    const hidden = wrap.querySelector(".item-ss-value");
    const menuInWrap = wrap.querySelector(".item-ss-menu");
    if (!input || !hidden) return;

    wrap.dataset.bound = "1";

    const portal = document.createElement("div");
    portal.className = "item-portal-menu item-ss-menu";
    portal.hidden = true;
    document.body.appendChild(portal);

    if (menuInWrap) menuInWrap.hidden = true;

    let items = [];
    let active = -1;

    function place() {
      const r = input.getBoundingClientRect();
      portal.style.left  = (window.scrollX + r.left) + "px";
      portal.style.top   = (window.scrollY + r.bottom + 8) + "px";
      portal.style.width = r.width + "px";
    }

    function open() { place(); portal.hidden = false; }
    function close() { portal.hidden = true; active = -1; render(); }

    function render() {
      portal.innerHTML = "";
      if (!items || items.length === 0) {
        const empty = document.createElement("div");
        empty.className = "item-ss-empty";
        empty.textContent = "일치하는 항목이 없습니다.";
        portal.appendChild(empty);
        return;
      }

      items.forEach((it, idx) => {
        const itemId = it.itemId || it.ITEM_ID || "";
        const title  = it.itemTitle || it.itemName || it.ITEM_TITLE || it.ITEM_NAME || "";

        const btn = document.createElement("button");
        btn.type = "button";
        btn.className = "item-ss-item" + (idx === active ? " is-active" : "");
        btn.dataset.value = itemId;
        btn.dataset.label = title;
        btn.innerHTML = `<span>${title}</span><small class="item-ss-sub">ITEM_ID: ${itemId}</small>`;
        portal.appendChild(btn);
      });
    }

    async function fetchList(q) {
      const url = `${CTX}/admin/prod/api/pkg/items.do?keyword=${encodeURIComponent(q || "")}&limit=${ITEM_LIMIT}`;
      const r = await getJson(url);
      if (!r?.ok) return [];

      const d = r.data;
      return Array.isArray(d) ? d
        : Array.isArray(d?.items) ? d.items
        : Array.isArray(d?.list) ? d.list
        : [];
    }

    const refresh = debounce(async () => {
      const q = (input.value || "").trim();
      try {
        items = await fetchList(q);
        active = items.length ? 0 : -1;
        render();
        open();
      } catch (e) {
        items = [];
        active = -1;
        render();
        open();
        console.error(e);
      }
    }, 120);

    function chooseByIndex(idx) {
      const it = items[idx];
      if (!it) return;

      const itemId = it.itemId || it.ITEM_ID || "";
      const title  = it.itemTitle || it.itemName || it.ITEM_TITLE || it.ITEM_NAME || "";

      hidden.value = itemId;
      input.value = title;
      close();
    }

    input.addEventListener("focus", refresh);
    input.addEventListener("click", refresh);
    input.addEventListener("input", refresh);

    input.addEventListener("keydown", (e) => {
      if (portal.hidden && (e.key === "ArrowDown" || e.key === "ArrowUp")) {
        refresh(); e.preventDefault(); return;
      }
      if (portal.hidden) return;

      if (e.key === "ArrowDown") {
        e.preventDefault();
        if (!items.length) return;
        active = Math.min(active + 1, items.length - 1);
        render();
        portal.querySelectorAll(".item-ss-item")[active]?.scrollIntoView({ block: "nearest" });
      } else if (e.key === "ArrowUp") {
        e.preventDefault();
        if (!items.length) return;
        active = Math.max(active - 1, 0);
        render();
        portal.querySelectorAll(".item-ss-item")[active]?.scrollIntoView({ block: "nearest" });
      } else if (e.key === "Enter") {
        e.preventDefault(); chooseByIndex(active);
      } else if (e.key === "Escape") {
        close();
      }
    });

    portal.addEventListener("click", (e) => {
      const btn = e.target.closest(".item-ss-item");
      if (!btn) return;
      const list = Array.from(portal.querySelectorAll(".item-ss-item"));
      const idx = list.indexOf(btn);
      if (idx >= 0) chooseByIndex(idx);
    });

    window.addEventListener("scroll", () => { if (!portal.hidden) place(); }, true);
    window.addEventListener("resize", () => { if (!portal.hidden) place(); });

    document.addEventListener("mousedown", (e) => {
      if (portal.hidden) return;
      if (wrap.contains(e.target) || portal.contains(e.target)) return;
      close();
    });

    const observer = new MutationObserver(() => {
      if (!document.body.contains(wrap)) {
        portal.remove();
        observer.disconnect();
      }
    });
    observer.observe(document.body, { childList: true, subtree: true });

    close();
  }

  // =========================================================
  // HOTEL 자동완성 (portal) - 지역명 검색 포함(서버에서 처리)
  // =========================================================
  const HOTEL_LIMIT = 30;

  function initHotelSS(wrap, CTX) {
    if (!wrap || wrap.dataset.bound === "1") return;

    const input  = wrap.querySelector(".hotel-ss-input");
    const hidden = wrap.querySelector(".hotel-ss-value");
    const menuInWrap = wrap.querySelector(".hotel-ss-menu");
    if (!input || !hidden) return;

    wrap.dataset.bound = "1";

    const portal = document.createElement("div");
    portal.className = "hotel-portal-menu";
    portal.hidden = true;
    document.body.appendChild(portal);

    if (menuInWrap) menuInWrap.hidden = true;

    let items = [];
    let active = -1;

    function place() {
      const r = input.getBoundingClientRect();
      portal.style.left  = (window.scrollX + r.left) + "px";
      portal.style.top   = (window.scrollY + r.bottom + 8) + "px";
      portal.style.width = r.width + "px";
    }

    function open() { place(); portal.hidden = false; }
    function close() { portal.hidden = true; active = -1; render(); }

    function render() {
      portal.innerHTML = "";
      if (!items || items.length === 0) {
        const empty = document.createElement("div");
        empty.className = "hotel-ss-empty";
        empty.textContent = "일치하는 항목이 없습니다.";
        portal.appendChild(empty);
        return;
      }

      items.forEach((it, idx) => {
        const hotelId   = it.hotelId || it.HOTEL_ID || "";
        const hotelName = it.hotelName || it.HOTEL_NAME || "";
        const hotelCode = it.hotelCode || it.HOTEL_CODE || "";
        const locName   = it.locName || it.LOC_NAME || "";

        const title = hotelName || hotelCode || hotelId;
        const label = locName ? `${title} (${locName})` : title;

        const btn = document.createElement("button");
        btn.type = "button";
        btn.className = "hotel-ss-item" + (idx === active ? " is-active" : "");
        btn.dataset.value = hotelId;
        btn.dataset.label = label;
        btn.innerHTML = `<span>${label}</span><small class="hotel-ss-sub">HOTEL_ID: ${hotelId}</small>`;
        portal.appendChild(btn);
      });
    }

    async function fetchList(q) {
      const url = `${CTX}/admin/prod/api/pkg/hotels.do?keyword=${encodeURIComponent(q || "")}&limit=${HOTEL_LIMIT}`;
      const r = await getJson(url);
      if (!r?.ok) return [];

      const d = r.data;
      return Array.isArray(d) ? d
        : Array.isArray(d?.items) ? d.items
        : Array.isArray(d?.list) ? d.list
        : [];
    }

    const refresh = debounce(async () => {
      const q = (input.value || "").trim();
      try {
        items = await fetchList(q);
        active = items.length ? 0 : -1;
        render();
        open();
      } catch (e) {
        items = [];
        active = -1;
        render();
        open();
        console.error(e);
      }
    }, 120);

    function chooseByIndex(idx) {
      const it = items[idx];
      if (!it) return;

      const hotelId   = it.hotelId || it.HOTEL_ID || "";
      const hotelName = it.hotelName || it.HOTEL_NAME || "";
      const hotelCode = it.hotelCode || it.HOTEL_CODE || "";
      const locName   = it.locName || it.LOC_NAME || "";

      const title = hotelName || hotelCode || hotelId;
      const label = locName ? `${title} (${locName})` : title;

      hidden.value = hotelId;
      input.value = label;
      close();
    }

    input.addEventListener("focus", refresh);
    input.addEventListener("click", refresh);
    input.addEventListener("input", refresh);

    input.addEventListener("keydown", (e) => {
      if (portal.hidden && (e.key === "ArrowDown" || e.key === "ArrowUp")) {
        refresh(); e.preventDefault(); return;
      }
      if (portal.hidden) return;

      if (e.key === "ArrowDown") {
        e.preventDefault();
        if (!items.length) return;
        active = Math.min(active + 1, items.length - 1);
        render();
        portal.querySelectorAll(".hotel-ss-item")[active]?.scrollIntoView({ block: "nearest" });
      } else if (e.key === "ArrowUp") {
        e.preventDefault();
        if (!items.length) return;
        active = Math.max(active - 1, 0);
        render();
        portal.querySelectorAll(".hotel-ss-item")[active]?.scrollIntoView({ block: "nearest" });
      } else if (e.key === "Enter") {
        e.preventDefault(); chooseByIndex(active);
      } else if (e.key === "Escape") {
        close();
      }
    });

    portal.addEventListener("click", (e) => {
      const btn = e.target.closest(".hotel-ss-item");
      if (!btn) return;
      const list = Array.from(portal.querySelectorAll(".hotel-ss-item"));
      const idx = list.indexOf(btn);
      if (idx >= 0) chooseByIndex(idx);
    });

    window.addEventListener("scroll", () => { if (!portal.hidden) place(); }, true);
    window.addEventListener("resize", () => { if (!portal.hidden) place(); });

    document.addEventListener("mousedown", (e) => {
      if (portal.hidden) return;
      if (wrap.contains(e.target) || portal.contains(e.target)) return;
      close();
    });

    const observer = new MutationObserver(() => {
      if (!document.body.contains(wrap)) {
        portal.remove();
        observer.disconnect();
      }
    });
    observer.observe(document.body, { childList: true, subtree: true });

    close();
  }

  // -------------------------
  // 행 추가 / 행 삭제
  // -------------------------
  function bindRowAddDel(root, CTX) {
    const tbody = qs(".pkg-item-tbody", root);
    const btnRowAdd = qs(".btn-item-row-add", root);
    if (!tbody) return;

    function getNextRowNo() {
      const rows = Array.from(tbody.querySelectorAll("tr.pkg-item-row"));
      if (rows.length === 0) return 1;
      const max = rows.reduce((m, r) => {
        const n = parseInt(r.getAttribute("data-row") || "0", 10);
        return Math.max(m, isNaN(n) ? 0 : n);
      }, 0);
      return max + 1;
    }

    function clearRowValues(row, nextNo) {
      const byDate = row.querySelector('input[name="byDate"]');
      if (byDate) byDate.value = String(nextNo || "");

      // item reset
      const itemWrap = row.querySelector(".item-ss");
      if (itemWrap) {
        const itemInp = itemWrap.querySelector(".item-ss-input");
        const itemHid = itemWrap.querySelector(".item-ss-value");
        if (itemInp) itemInp.value = "";
        if (itemHid) itemHid.value = "";
        delete itemWrap.dataset.bound;
      }

      // hotel reset
      const hotelWrap = row.querySelector(".hotel-ss");
      if (hotelWrap) {
        const hotelInp = hotelWrap.querySelector(".hotel-ss-input");
        const hotelHid = hotelWrap.querySelector(".hotel-ss-value");
        if (hotelInp) hotelInp.value = "";
        if (hotelHid) hotelHid.value = "";
        delete hotelWrap.dataset.bound;
      }
    }

    function addRow() {
      const nextNo = getNextRowNo();

      const last = tbody.querySelector("tr.pkg-item-row:last-child");
      let row;

      if (last) {
        row = last.cloneNode(true);
      } else {
        row = document.createElement("tr");
        row.className = "pkg-item-row";
        row.innerHTML = `
          <td class="bydate-col">
            <input type="number" name="byDate" class="bydate-inp" value="" min="1" />
          </td>

          <td class="item-col">
            <div class="item-ss">
              <input type="text" class="item-ss-input" placeholder="아이템명/코드 검색…" autocomplete="off" />
              <input type="hidden" name="itemId" class="item-ss-value" value="" />
              <div class="item-ss-menu" hidden></div>
            </div>
          </td>

          <td class="hotel-col">
            <div class="hotel-ss">
              <input type="text" class="hotel-ss-input" placeholder="숙박명/코드/지역 검색…" autocomplete="off" />
              <input type="hidden" name="hotelId" class="hotel-ss-value" value="" />
              <div class="hotel-ss-menu" hidden></div>
            </div>
          </td>

          <td class="action-col" style="text-align:right;">
            <button type="button" class="btn btn-ghost btn-item-row-del">
              <i class="fas fa-trash"></i>
            </button>
          </td>
        `;
      }

      row.setAttribute("data-row", String(nextNo));
      clearRowValues(row, nextNo);

      // ✅ 새 행의 item/hotel 초기화(포탈 바인딩)
      const itemWrap = row.querySelector(".item-ss");
      if (itemWrap) initItemSS(itemWrap, CTX);

      const hotelWrap = row.querySelector(".hotel-ss");
      if (hotelWrap) initHotelSS(hotelWrap, CTX);

      tbody.appendChild(row);
    }

    btnRowAdd?.addEventListener("click", addRow);

    // 삭제
    tbody.addEventListener("click", (e) => {
      const delBtn = e.target.closest(".btn-item-row-del");
      if (!delBtn) return;

      const row = delBtn.closest("tr.pkg-item-row");
      if (!row) return;

      const rows = tbody.querySelectorAll("tr.pkg-item-row");
      if (rows.length <= 1) {
        clearRowValues(row, 1);

        const itemWrap = row.querySelector(".item-ss");
        if (itemWrap) initItemSS(itemWrap, CTX);

        const hotelWrap = row.querySelector(".hotel-ss");
        if (hotelWrap) initHotelSS(hotelWrap, CTX);

        return;
      }
      row.remove();
    });

    // focusin으로 클론된 랩도 자동 바인딩
    tbody.addEventListener("focusin", (e) => {
      const iw = e.target.closest(".item-ss");
      if (iw) initItemSS(iw, CTX);

      const hw = e.target.closest(".hotel-ss");
      if (hw) initHotelSS(hw, CTX);
    });
  }

  // -------------------------
  // boot
  // -------------------------
  function boot() {
    const root = document.getElementById("pkg-create-root");
    if (!root) return;

    const CTX = root.dataset.ctx || "";

    // 1) 지역/테마 ss 초기화
    root.querySelectorAll(".ss").forEach(initSearchSelect);

    const locSS   = qs('.ss[data-ss="loc"]', root);
    const themeSS = qs('.ss[data-ss="theme"]', root);

    const locHidden   = locSS?.querySelector(".ss-value");
    const themeHidden = themeSS?.querySelector(".ss-value");

    const ctryIdInp   = qs("input.ctry-id", root);
    const ctryNameInp = qs("input.ctry-name", root);

    const pkgIdView  = qs(".pkg-id-view", root);
    const pkgIdBadge = qs(".pkg-id-badge", root);

    const btnCreate = qs(".btn-pkg-create", root);
    const btnReset  = qs(".btn-pkg-reset", root);
    const titleInp  = qs('input[name="packageTitle"]', root);

    // 2) packageItem 카드 활성
    setStep2Enabled(root, (pkgIdView?.value || "").trim());

    // 3) 행 추가/삭제 바인딩
    bindRowAddDel(root, CTX);

    // ✅ 최초 렌더된 item/hotel ss 바인딩
    root.querySelectorAll(".item-ss").forEach(w => initItemSS(w, CTX));
    root.querySelectorAll(".hotel-ss").forEach(w => initHotelSS(w, CTX));

    // 4) 지역 선택 → 국가 자동
    locSS?.addEventListener("ss:change", async (e) => {
      const locId = e.detail?.value || "";
      if (!locId) return;

      if (ctryIdInp) ctryIdInp.value = "";
      if (ctryNameInp) ctryNameInp.value = "불러오는 중...";

      try {
        const url = `${CTX}/admin/prod/api/pkg/countryByLoc.do?locId=${encodeURIComponent(locId)}`;
        const r = await getJson(url);

        if (!r?.ok) {
          if (ctryNameInp) ctryNameInp.value = "";
          alert(r?.message || "국가 조회 실패");
          return;
        }

        const c = r.data || {};
        if (ctryIdInp) ctryIdInp.value = c.ctryId || "";
        if (ctryNameInp) ctryNameInp.value = c.ctryName || "";
      } catch (err) {
        if (ctryNameInp) ctryNameInp.value = "";
        alert(err.message || "국가 조회 중 오류");
      }
    });

    // 5) 지역/테마 선택 → pkgId 미리보기
    const refreshPkgId = debounce(async () => {
      const locId = (locHidden?.value || "").trim();
      const themeId = (themeHidden?.value || "").trim();

      if (!locId || !themeId) {
        if (pkgIdView) pkgIdView.value = "";
        if (pkgIdBadge) pkgIdBadge.textContent = "{package_id}";
        setStep2Enabled(root, "");
        return;
      }

      try {
        const url = `${CTX}/admin/prod/api/pkg/nextPkgId.do?locId=${encodeURIComponent(locId)}&themeId=${encodeURIComponent(themeId)}`;
        const r = await getJson(url);

        if (!r?.ok) {
          setStep2Enabled(root, "");
          return;
        }

        const pkgId = r.data?.pkgId || "";
        setStep2Enabled(root, pkgId);
      } catch (e) {
        setStep2Enabled(root, "");
        console.error(e);
      }
    }, 120);

    locSS?.addEventListener("ss:change", refreshPkgId);
    themeSS?.addEventListener("ss:change", refreshPkgId);
    refreshPkgId();

    // 6) 패키지 생성 버튼 → INSERT
	btnCreate?.addEventListener("click", async () => {
	  const packageTitle = (titleInp?.value || "").trim();
	  const locId   = (locHidden?.value || "").trim();
	  const themeId = (themeHidden?.value || "").trim();

	  if (!packageTitle) {
	    alert("패키지명을 입력해주세요.");
	    titleInp?.focus();
	    return;
	  }
	  if (!locId) {
	    alert("지역을 선택해주세요.");
	    return;
	  }
	  if (!themeId) {
	    alert("메인 테마를 선택해주세요.");
	    return;
	  }

	  // =========================
	  // 패키지 구성 rows → items
	  // =========================
	  const tbody = qs(".pkg-item-tbody", root);
	  const rows = Array.from(tbody?.querySelectorAll("tr.pkg-item-row") || []);

	  if (rows.length === 0) {
	    alert("패키지 구성은 최소 1행 이상 필요합니다.");
	    return;
	  }

	  const items = [];

	  for (let i = 0; i < rows.length; i++) {
	    const row = rows[i];

	    // by_date (VARCHAR2 → 문자열로 보냄)
	    const byDateRaw = row.querySelector('input[name="byDate"]')?.value;
	    const byDate = (byDateRaw ?? "").toString().trim();

	    const itemId =
	      (row.querySelector('input[name="itemId"]')?.value || "").trim();

	    // ✅ hotelId는 optional
	    let hotelId =
	      (row.querySelector('input[name="hotelId"]')?.value || "").trim();
	    if (!hotelId) hotelId = null;

	    if (!byDate) {
	      alert(`패키지 구성 ${i + 1}행: 일차(byDate)를 입력해주세요.`);
	      row.querySelector('input[name="byDate"]')?.focus();
	      return;
	    }

	    if (!itemId) {
	      alert(`패키지 구성 ${i + 1}행: 아이템을 선택해주세요.`);
	      row.querySelector(".item-ss-input")?.focus();
	      return;
	    }

	    items.push({
	      byDate,   // 문자열
	      itemId,
	      hotelId  // null 허용
	    });
	  }

	  // =========================
	  // 서버 전송
	  // =========================
	  btnCreate.disabled = true;

	  try {
	    const url = `${CTX}/admin/prod/api/pkg/createAll.do`;

	    const r = await postJson(url, {
	      packageTitle,
	      locId,
	      themeId,
	      items
	    });

	    if (!r?.ok) {
	      alert(r?.message || "패키지 생성 실패");
	      return;
	    }

	    const pkgId = r.data?.pkgId || "";
	    if (!pkgId) {
	      alert("pkgId를 받지 못했습니다.");
	      return;
	    }

	    setStep2Enabled(root, pkgId);
	    alert("패키지 및 패키지 구성이 생성되었습니다.");

	  } catch (e) {
	    alert(e.message || "서버 오류");
	  } finally {
	    btnCreate.disabled = false;
	  }
	});

    // 7) 리셋
    btnReset?.addEventListener("click", () => {
      if (!confirm("입력을 초기화할까요?")) return;

      if (titleInp) titleInp.value = "";

      root.querySelectorAll(".ss").forEach(ss => {
        const inp = ss.querySelector(".ss-input");
        const val = ss.querySelector(".ss-value");
        if (inp) inp.value = "";
        if (val) val.value = "";
      });

      if (ctryIdInp) ctryIdInp.value = "";
      if (ctryNameInp) ctryNameInp.value = "";

      setStep2Enabled(root, "");
      refreshPkgId();

      // item/hotel ss 초기화
      root.querySelectorAll(".item-ss").forEach(w => {
        delete w.dataset.bound;
        const inp = w.querySelector(".item-ss-input");
        const hid = w.querySelector(".item-ss-value");
        if (inp) inp.value = "";
        if (hid) hid.value = "";
        initItemSS(w, CTX);
      });

      root.querySelectorAll(".hotel-ss").forEach(w => {
        delete w.dataset.bound;
        const inp = w.querySelector(".hotel-ss-input");
        const hid = w.querySelector(".hotel-ss-value");
        if (inp) inp.value = "";
        if (hid) hid.value = "";
        initHotelSS(w, CTX);
      });
    });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", boot);
  } else {
    boot();
  }
})();
