/**
 * mypage.wish.js
 * - 역할: 관심상품(wish) 섹션 렌더링 + 체크/해제/장바구니 담기 로직
 * - 존재이유: 관심상품은 UI/이벤트가 길어서 core에서 완전히 분리
 */

window.MypageWish = (function(){

  function render(el, items, h){

    // [의미] 토스트(간단 안내) - 알림창 남발을 줄이기 위한 UX 장치
    function showWishToast(msg){
      const elToast = document.getElementById("wishToast");
      if(!elToast) { alert(msg); return; }
      elToast.textContent = msg;
      elToast.classList.add("show");
      clearTimeout(showWishToast._t);
      showWishToast._t = setTimeout(()=> elToast.classList.remove("show"), 1600);
    }

    if (!items || items.length === 0) {
      el.innerHTML = '<div class="empty"><div class="icon">0</div><div>관심상품이 없습니다.</div></div>';
      return;
    }

    // [의미] 데이터 키가 화면마다 섞여있어(대문자/카멜 혼재) 우선순위로 꺼내기 위한 유틸
    const g = (it, ...keys) => {
      for (const k of keys) {
        const v = it ? it[k] : null;
        if (v !== undefined && v !== null && String(v).trim() !== '') return v;
      }
      return '';
    };

    // [의미] 날짜 문자열을 YYYY-MM-DD 형태로 잘라서 통일
    const fmtYmd = (v) => {
      const s = String(v ?? '').trim();
      if (!s) return '-';
      return (s.length >= 10) ? s.substring(0, 10) : s;
    };

    // [의미] 카드 1개 렌더링
    const renderWishCard = (it) => {
      const regId   = g(it, 'REG_ID', 'regId');
      const title   = g(it, 'REG_TITLE', 'regTitle');
      const price   = g(it, 'REG_PRICE', 'regPrice');
      const ctry    = g(it, 'CTRY_NAME', 'ctryName');
      const loc     = g(it, 'LOC_NAME', 'locName');
      const imgPath = g(it, 'IMG_PATH', 'imgPath');

      const start = fmtYmd(g(it, 'START_DT', 'startDt', 'START_YMD', 'startYmd'));
      const end   = fmtYmd(g(it, 'END_DT', 'endDt', 'END_YMD', 'endYmd'));

      const thumb  = h.imgUrl(imgPath) || (h.CTX + '/assets/images/location/reg_default.jpg');
      const amount = h.money(price);

      return ''
        + '<div class="wishCard" data-regid="' + h.esc(regId) + '" data-price="' + h.esc(price) + '">'
        +   '<div class="wishCheck">'
        +     '<input type="checkbox" class="chkItem" value="' + h.esc(regId) + '">'
        +   '</div>'
        +   '<a class="wishThumb" href="' + h.CTX + '/regProdDetail.do?regId=' + encodeURIComponent(regId) + '" title="상품 상세로 이동">'
        +     '<img src="' + h.esc(thumb) + '" alt="' + h.esc(title || "상품") + '">'
        +   '</a>'
        +   '<div class="wishMeta">'
        +     '<div class="wishTitle">' + h.esc(title || "상품") + '</div>'
        +     '<div class="wishSub">'
        +       '<span class="wishTag loc">지역: ' + h.esc([ctry, loc].filter(Boolean).join(' · ') || '-') + '</span>'
        +       '<span class="wishTag date">기간: ' + h.esc(start + " ~ " + end) + '</span>'
        +     '</div>'
        +   '</div>'
        +   '<div class="wishActions">'
        +     '<div class="wishPrice">' + (amount === '-' ? '-' : (amount + '원')) + '</div>'
        +     '<div class="wishActionRow">'
        +       '<button type="button" class="wishBtn primary" data-action="cart" data-regid="' + h.esc(regId) + '">담기</button>'
        +       '<button type="button" class="wishBtn danger"  data-action="remove" data-regid="' + h.esc(regId) + '">해제</button>'
        +     '</div>'
        +   '</div>'
        + '</div>';
    };

    // [의미] 상단 도구(전체선택/선택담기/선택해제 등) + 리스트 렌더링
    el.innerHTML =
      ''
      + '<div class="wishTools">'
      +   '<div class="left">'
      +     '<label class="wishAll"><input type="checkbox" id="wishChkAll"> 전체선택</label>'
      +     '<span>선택 <b id="wishSelCount">0</b> / 총 <b id="wishTotalCount">0</b></span>'
      +   '</div>'
      +   '<div class="right">'
      +     '<button type="button" class="wishBtn primary" id="wishBtnAddCart">선택상품 담기</button>'
      +     '<button type="button" class="wishBtn danger"  id="wishBtnDelSel">선택 해제</button>'
      +     '<button type="button" class="wishBtn"         id="wishBtnGoCart">관심상품으로 이동</button>'
      +   '</div>'
      + '</div>'
      + '<div class="wishList" id="wishList">'
      +   items.map(renderWishCard).join('')
      + '</div>';

    // [의미] 섹션 내부에서만 찾는 전용 셀렉터(다른 탭과 충돌 방지)
    const $  = (sel) => el.querySelector(sel);
    const $$ = (sel) => Array.from(el.querySelectorAll(sel));

    function updateCounts(){
      const total = $$('.chkItem').length;
      const selected = $$('.chkItem:checked').length;

      const totalEl = $('#wishTotalCount');
      const selEl   = $('#wishSelCount');
      const allEl   = $('#wishChkAll');

      if (totalEl) totalEl.textContent = total;
      if (selEl)   selEl.textContent = selected;

      if (allEl) {
        allEl.indeterminate = (selected > 0 && selected < total);
        allEl.checked = (total > 0 && selected === total);
      }
    }

    function syncSelectedCards(){
      $$('.wishCard').forEach(card => {
        const chk = card.querySelector('.chkItem');
        card.classList.toggle('is-selected', !!(chk && chk.checked));
      });
    }

    function updateUI(){
      updateCounts();
      syncSelectedCards();
    }

    function getSelectedRegIds(){
      return $$('.chkItem:checked').map(chk => (chk.value || '').trim()).filter(Boolean);
    }

    // [의미] 장바구니에 이미 들어간 상품이면 "담김" 표시로 버튼 상태를 맞춘다.
    function setCartButtonState(regIds){
      const set = new Set();
      if(Array.isArray(regIds)){
        regIds.forEach(x => { if(x != null) set.add(String(x).trim()); });
      }else if(regIds != null && regIds !== ''){
        set.add(String(regIds).trim());
      }

      $$('.wishBtn.primary[data-action="cart"]').forEach(btn => {
        const id = (btn.dataset.regid || '').trim();
        if(set.size > 0 && set.has(id)){
          btn.classList.add('inCart');
          btn.textContent = '담김';
        }else{
          btn.classList.remove('inCart');
          btn.textContent = '담기';
        }
      });
    }

    async function loadCurrentCart(){
      try{
        const r = await fetch(h.CTX + '/cart/current.do');
        if(!r.ok) return;
        const data = await r.json().catch(()=>null);
        if(!data || !data.loggedIn) return;
        setCartButtonState(data.regIds || data.regId);
      }catch(err){
        console.error('장바구니 로딩 실패:', err);
      }
    }

    // [의미] 체크 안 된 상품은 담기 금지 + 여러 개 체크면 1개만 남기도록 유도
    function ensureCheckedForCart(card, regId){
      const chk = card ? card.querySelector('.chkItem') : null;
      if(!chk || !chk.checked){
        alert('체크한 상품만 담을 수 있습니다.');
        return false;
      }
      const ids = getSelectedRegIds();
      if(ids.length > 1){
        const ok = confirm('장바구니 담기는 1개만 가능합니다.\n지금 누른 상품만 남기고 나머지 선택을 해제할까요?');
        if(!ok){
          alert('장바구니에 담을 상품을 1개만 체크해주세요.');
          return false;
        }
        $$('.chkItem').forEach(x => x.checked = false);
        chk.checked = true;
        updateUI();
      }
      return true;
    }

    // [의미] 관심상품 해제(서버 요청)
    async function removeWish(regId){
      const res = await fetch(h.CTX + '/wish/remove.do', {
        method: 'POST',
        headers: { 'content-type': 'application/x-www-form-urlencoded; charset=UTF-8' },
        body: 'regId=' + encodeURIComponent(regId)
      });

      if (res.status === 401) {
        alert('로그인이 필요합니다. 로그인 페이지로 이동합니다.');
        location.href = h.CTX + '/login.do';
        return { ok:false };
      }
      return res.json().catch(()=>({ ok:false }));
    }

    // [의미] 장바구니 담기(서버 요청) - force=N/Y로 교체 여부 제어
    async function postCart(regId, forceYN){
      const params = new URLSearchParams({ regId, force: forceYN, peopleCnt: '1' });
      const resp = await fetch(h.CTX + '/cart/add.do', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
        body: params
      });

      if (resp.status === 401) {
        alert('로그인이 필요합니다. 로그인 페이지로 이동합니다.');
        location.href = h.CTX + '/login.do';
        return { ok:false };
      }
      if(!resp.ok) throw new Error('서버 응답 오류');
      return resp.json();
    }

    // [의미] 담기 플로우: 성공이면 담김 표시, 충돌이면 교체 1회 확인
    async function addToCartFlow(regId){
      try{
        let data = await postCart(regId, 'N');

        if (data.ok) {
          setCartButtonState(data.regIds || data.regId);
          alert('장바구니에 담았습니다.');
          return;
        }

        if (data.code === 'CONFLICT') {
          const ok = confirm(data.msg || '이미 다른 상품이 있습니다. 교체할까요?');
          if (!ok) return;

          data = await postCart(regId, 'Y');
          if (data.ok) {
            setCartButtonState(data.regIds || data.regId);
            showWishToast('상품이 교체되었습니다.');
          } else {
            alert(data.msg || '교체 실패');
          }
          return;
        }

        alert(data.msg || '장바구니 처리 실패');

      }catch(err){
        console.error(err);
        alert('장바구니 처리 중 오류가 발생했습니다.');
      }
    }

    // [의미] 이벤트 바인딩은 1회만
    if (!el.dataset.boundWish) {

      // (1) 체크 변경
      el.addEventListener('change', (e) => {
        const t = e.target;
        if(!(t instanceof HTMLElement)) return;

        if (t.id === 'wishChkAll') {
          const on = (t instanceof HTMLInputElement) ? t.checked : false;
          $$('.chkItem').forEach(chk => chk.checked = on);
          updateUI();
          return;
        }

        if (t.classList.contains('chkItem')) updateUI();
      });

      // (2) 클릭 처리
      el.addEventListener('click', async (e) => {
        const t = e.target;
        if(!(t instanceof HTMLElement)) return;

        // 상단 버튼
        if (t.closest('#wishBtnGoCart')) {
          location.href = h.CTX + '/wish/page.do';
          return;
        }

        if (t.closest('#wishBtnDelSel')) {
          const ids = [...getSelectedRegIds()];
          if (ids.length === 0) { alert('해제할 상품을 선택하세요.'); return; }
          if (!confirm('선택한 상품을 관심상품에서 해제할까요?')) return;

          const btnDel = el.querySelector('#wishBtnDelSel');
          if (btnDel) btnDel.disabled = true;

          try {
            for (const regId of ids) {
              const data = await removeWish(regId);
              if (data.ok) {
                const card = el.querySelector('.wishCard[data-regid="' + regId + '"]');
                if (card) card.remove();
              }
            }

            $$('.chkItem').forEach(chk => chk.checked = false);
            const all = $('#wishChkAll');
            if (all) { all.checked = false; all.indeterminate = false; }

            updateUI();
            showWishToast('선택한 상품을 해제했습니다.');
          } finally {
            if (btnDel) btnDel.disabled = false;
          }
          return;
        }

        if (t.closest('#wishBtnAddCart')) {
          const ids = getSelectedRegIds();
          if (ids.length === 0) { alert('담을 상품을 1개 선택하세요.'); return; }
          if (ids.length > 1) { alert('장바구니 담기는 1개만 가능합니다.'); return; }
          await addToCartFlow(ids[0]);
          return;
        }

        // 카드 안 버튼(담기/해제)
        const btn = t.closest('button[data-action]');
        if (btn) {
          e.preventDefault();
          e.stopPropagation();

          const act = btn.dataset.action;
          const regId = (btn.dataset.regid || '').trim();
          const card = btn.closest('.wishCard');

          if (act === 'remove') {
            if (!confirm('해제할까요?')) return;
            const data = await removeWish(regId);
            if (data.ok) {
              if (card) card.remove();
              updateUI();
              alert(data.msg || '해제되었습니다.');
            } else {
              alert(data.msg || '해제 실패');
            }
            return;
          }

          if (act === 'cart') {
            if (!ensureCheckedForCart(card, regId)) return;
            await addToCartFlow(regId);
            return;
          }
        }

        // 카드 클릭(인터랙티브 요소 제외) = 체크 토글
        const clickedOnInteractive =
          !!t.closest('button') || !!t.closest('a') || !!t.closest('input') || !!t.closest('label');

        if (!clickedOnInteractive) {
          const card = t.closest('.wishCard');
          if (card) {
            const chk = card.querySelector('.chkItem');
            if (chk) chk.checked = !chk.checked;
            updateUI();
          }
        }
      });

      el.dataset.boundWish = '1';
    }

    updateUI();
    loadCurrentCart();
  }

  return { render };
})();
