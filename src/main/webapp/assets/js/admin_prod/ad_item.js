(function () {

  function openMenu(ss) {
    ss.querySelector('.ss-menu').hidden = false;
  }
  function closeMenu(ss) {
    ss.querySelector('.ss-menu').hidden = true;
    ss.querySelectorAll('.ss-item.is-active').forEach(b => b.classList.remove('is-active'));
  }

  function filterItems(ss, q) {
    const query = (q || '').trim().toLowerCase();
    const items = Array.from(ss.querySelectorAll('.ss-item'));
    let first = null;

    items.forEach(btn => {
      const label = (btn.dataset.label || '').toLowerCase();
      const value = (btn.dataset.value || '').toLowerCase();
      const ok = !query || label.includes(query) || value.includes(query);
      btn.style.display = ok ? 'flex' : 'none';
      if(ok && !first) first = btn;
    });

    items.forEach(b => b.classList.remove('is-active'));
    if(first) first.classList.add('is-active');
  }

  function bind(ss) {
    const input  = ss.querySelector('.ss-input');
    const hidden = ss.querySelector('.ss-value');

    const openAndFilter = () => { openMenu(ss); filterItems(ss, input.value); };

    input.addEventListener('focus', openAndFilter);
    input.addEventListener('click', openAndFilter);
    input.addEventListener('input', openAndFilter);

    ss.querySelectorAll('.ss-item').forEach(btn => {
      btn.addEventListener('click', () => {
        hidden.value = btn.dataset.value || '';
        input.value  = btn.dataset.label || '';
        closeMenu(ss);
      });
    });

    document.addEventListener('click', (e) => {
      if(!ss.contains(e.target)) closeMenu(ss);
    });

    input.addEventListener('keydown', (e) => {
      if(e.key === 'Escape') closeMenu(ss);
    });
  }

  document.querySelectorAll('.ss').forEach(bind);

})();

(function(){
  function bindCombo(root, hiddenId){
    const input = root.querySelector('.comboInput');
    const btn   = root.querySelector('.comboBtn');
    const panel = root.querySelector('.comboPanel');
    const items = Array.from(root.querySelectorAll('.comboItem'));
    const hidden = document.getElementById(hiddenId);

    function open(){
      root.classList.add('open');
      // 열릴 때 전체 보이게 + 포커스
      filter('');
      input.focus();
    }
    function close(){
      root.classList.remove('open');
    }
    function toggle(){
      root.classList.contains('open') ? close() : open();
    }

    function filter(q){
      const query = (q || '').trim().toLowerCase();
      let firstVisible = null;

      items.forEach(it=>{
        const label = (it.dataset.label || '').toLowerCase();
        const value = (it.dataset.value || '').toLowerCase();
        const ok = !query || label.includes(query) || value.includes(query);
        it.style.display = ok ? 'flex' : 'none';
        if(ok && !firstVisible) firstVisible = it;
      });

      // active 표시 초기화
      items.forEach(it=> it.classList.remove('active'));
      if(firstVisible) firstVisible.classList.add('active');
    }

    // 클릭 선택
    items.forEach(it=>{
      it.addEventListener('click', ()=>{
        const val = it.dataset.value;
        const label = it.dataset.label;

        hidden.value = val;
        input.value = label; // 화면에는 이름 표시
        close();
      });
    });

    // 검색 필터링
    input.addEventListener('input', (e)=> filter(e.target.value));

    // input 클릭/버튼 클릭
    input.addEventListener('click', open);
    btn.addEventListener('click', toggle);

    // 바깥 클릭 시 닫기
    document.addEventListener('click', (e)=>{
      if(!root.contains(e.target)) close();
    });

    // ESC 닫기
    input.addEventListener('keydown', (e)=>{
      if(e.key === 'Escape') close();
    });
  }

  // ✅ 각각 바인딩 (hidden input id와 맞춰줘)
  const locBox = document.querySelector('.comboBox[data-combo="loc"]');
  const themeBox = document.querySelector('.comboBox[data-combo="theme"]');
  if(locBox) bindCombo(locBox, 'locIdHidden');
  if(themeBox) bindCombo(themeBox, 'themeIdHidden');
})();
