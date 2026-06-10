/**
 * mypage.core.js
 * - 역할: 마이페이지 "공통 뼈대"만 담당 (CTX, 탭 전환, loadSection 디스패치)
 * - 존재이유: 결제/관심/프로필 등 기능별 JS를 분리해도, 탭/라우팅 흐름은 한 곳에서 유지하기 위해
 */

/* =========================
   1) 공통 상수/유틸
   ========================= */

// [의미] 컨텍스트 경로(예: /tryCatchTrip). JSP에서 body data-ctx로 내려준 값을 읽는다.
const CTX = document.body.dataset.ctx;

// [의미] XSS 방지용 이스케이프 (서버값을 innerHTML로 넣을 때 깨짐/오염 방지)
const esc = (s) => String(s ?? '').replace(/[&<>"']/g, (m) => ({
  '&':'&amp;', '<':'&lt;', '>':'&gt;', '"':'&quot;', "'":'&#39;'
}[m]));

// [의미] 돈 표시 포맷 (숫자→1,234,567 형태)
const money = (n) => {
  const v = Number(n);
  if (Number.isNaN(v)) return '-';
  return v.toLocaleString('ko-KR');
};

// [의미] 이미지 경로 정리 (절대/상대 경로 모두 CTX 기준으로 안전하게 만들기)
const imgUrl = (p) => {
  const v = String(p ?? '').trim();
  if (!v) return '';
  if (/^https?:\/\//i.test(v)) return v;
  if (v.startsWith('/')) return CTX + v;
  return CTX + '/' + v;
};

/* =========================
   2) 탭(사이드 메뉴) 제어
   ========================= */

// [의미] 좌측 메뉴와 우측 섹션들을 잡아두고, active 클래스로 보여줄 섹션만 켠다.
const sideItems = document.querySelectorAll('.sideItem[data-section]');
const sections  = document.querySelectorAll('.section');
// [의미] 공통 로더: type(=pay/wish/qna/review/profile)별 서버 호출 후, 각 모듈에 렌더링 위임
async function loadSection(type){

  // ✅ [핵심] profile은 JSON(mypageData.do)이 아니라 fragment(pwCheck/editProfile) 흐름이라 먼저 처리한다
  //          (profileBody가 없어서 아래 el 체크에서 return 되어버리는 문제를 막는 목적)
  if (type === 'profile') {
    if (window.MypageProfile && typeof window.MypageProfile.open === 'function') {
      window.MypageProfile.open(); // [의미] profileArea에 pwCheck fragment를 로드시키는 책임을 profile 모듈에 위임
    }
    return;
  }

  const targetId = type + 'Body';              // [의미] payBody / wishBody 같은 규칙을 사용
  const el = document.getElementById(targetId);
  if (!el) return;

  // [의미] 로딩 표시(각 모듈이 그리기 전까지 사용자에게 상태를 알려줌)
  el.innerHTML = '<div class="empty"><div class="icon">…</div><div>불러오는 중...</div></div>';

  // [의미] 공통 데이터 API: /mypageData.do?type=xxx
  const res  = await fetch(CTX + '/mypageData.do?type=' + encodeURIComponent(type));
  const data = await res.json();

  if (!res.ok || !data.ok) {
    el.innerHTML = '<div class="empty"><div class="icon">!</div><div>데이터 조회 실패</div></div>';
    return;
  }

  const items = Array.isArray(data.items) ? data.items : [];

  // [의미] 기능별 렌더러로 위임 (여기서 switch로 "딱 1곳"에서만 분기)
  switch(type){
    case 'pay':
      window.MypagePay && window.MypagePay.render(el, items, {CTX, esc, money, imgUrl, loadSection});
      break;
    case 'wish':
      window.MypageWish && window.MypageWish.render(el, items, {CTX, esc, money, imgUrl, loadSection});
      break;
    case 'qna':
      window.MypageQna && window.MypageQna.render(el, items, {CTX, esc, money, imgUrl, loadSection});
      break;
    case 'review':
      window.MypageReview && window.MypageReview.render(el, items, {CTX, esc, money, imgUrl, loadSection});
      break;
    default:
      let rows = '';
      for (let i = 0; i < items.length; i++) {
        rows += '<tr><td>' + (i+1) + '</td><td>' + esc(JSON.stringify(items[i])) + '</td></tr>';
      }
      el.innerHTML = '<table><thead><tr><th>#</th><th>내용</th></tr></thead><tbody>' + rows + '</tbody></table>';
  }
}



// [의미] 섹션을 실제로 보여주는 함수 (active 토글 + 필요한 섹션은 loadSection 호출)
function showSection(id){
  sections.forEach(s => s.classList.toggle('active', s.id === id));
  sideItems.forEach(a => a.classList.toggle('active', a.dataset.section === id));

  // [의미] profile은 profileArea 내부 fragment 기반이므로 type='profile'로 위임
  if(id === "profile"){
    loadSection('profile');
    return;
  }

  loadSection(id);
}

// [의미] 좌측 메뉴 클릭 → 섹션 전환 + 해시 갱신(새로고침/공유/뒤로가기에서 탭 상태 유지 목적)
sideItems.forEach(a => {
  a.addEventListener('click', (e) => {
    e.preventDefault();
    const id = a.dataset.section;
    showSection(id);
    history.replaceState(null, '', '#' + id);
  });
});

// [의미] "더보기" 같은 공통 버튼 처리(data-more로 어느 섹션을 재로드할지 지정)
document.querySelectorAll('[data-more]').forEach(btn => {
  btn.addEventListener('click', () => loadSection(btn.dataset.more));
});

// [의미] 최초 진입: 해시가 있으면 그 탭, 없으면 pay 탭
const hash = (location.hash || '').replace('#','');
if(hash && document.getElementById(hash)){
  showSection(hash);
}else{
  showSection('pay');
  history.replaceState(null, '', '#pay');
}
