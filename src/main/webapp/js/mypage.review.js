/**
 * mypage.review.js
 * - 마이페이지 > 후기내역(REVIEW) 렌더링 전용
 * - qna와 동일한 CSS를 재사용하기 위해 qna 클래스명을 그대로 사용
 */
(function () {

  // XSS 방지 최소 escape
  function esc(s) {
    return String(s ?? '').replace(/[&<>"']/g, (m) => ({
      '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
    }[m]));
  }

  function fmtDate(v) {
    if (!v) return '';
    const s = String(v).trim();

    // 1) Date 파싱 시도 (ISO / "Jan 29, 2026" 같은 형태 대응)
    const d = new Date(s);
    if (!isNaN(d.getTime())) {
      const y = d.getFullYear();
      const m = String(d.getMonth() + 1).padStart(2, '0');
      const day = String(d.getDate()).padStart(2, '0');
      return `${y}-${m}-${day}`;
    }

    // 2) 문자열에 YYYY-MM-DD가 있으면 그거 사용
    const m1 = s.match(/(\d{4})[-/.](\d{1,2})[-/.](\d{1,2})/);
    if (m1) {
      const y = m1[1];
      const mm = String(m1[2]).padStart(2, '0');
      const dd = String(m1[3]).padStart(2, '0');
      return `${y}-${mm}-${dd}`;
    }

    return esc(s);
  }


  // 키가 프로젝트마다 흔들릴 때 대비 (camelCase/대문자 모두 대응)
  function pick(it, keys, def = '') {
    for (const k of keys) {
      if (it && it[k] != null && String(it[k]).trim() !== '') return it[k];
    }
    return def;
  }

  window.MypageReview = {
    /**
     * @param {HTMLElement} el
     * @param {Array} items
     * @param {Object} opts  { CTX, esc, ... }
     */
    render: function (el, items, opts) {
      const CTX = opts.CTX;

      if (!Array.isArray(items) || items.length === 0) {
        el.innerHTML = '<div class="empty"><div class="icon">0</div><div>후기 내역이 없습니다.</div></div>';
        return;
      }

      let html = '';
      html += '<div class="qnaContainer">';

      // 헤더(문의게시판 스타일 그대로)
      html += '  <div class="qnaGrid qnaHeader">';
      html += '    <div>번호</div>';
      html += '    <div class="col-title">제목</div>';
      html += '    <div>작성일</div>';
      html += '    <div>별점</div>';   // qna에 있던 칼럼 폭/정렬 재사용용
      html += '    <div>상세</div>';
      html += '    <div></div>';
      html += '  </div>';

      items.forEach((it) => {
        const reviewNo = pick(it, ['reviewNo', 'REVIEWNO', 'REVIEW_NO', 'no', 'id'], '');
        const titleRaw = pick(it, ['reviewTitle', 'REVIEWTITLE', 'REVIEW_TITLE', 'title'], '(제목없음)');
        const cttRaw   = pick(it, ['reviewCtt', 'REVIEWCTT', 'REVIEW_CTT', 'content'], '');
        const created  = pick(it, ['reviewCreated', 'REVIEWCREATED', 'REVIEW_CREATED', 'createdAt'], '');
        const rating   = pick(it, ['rating', 'RATING', 'REVIEWRATING', 'REVIEW_RATING', 'score'], '');
        const regTitle = pick(it, ['regTitle', 'REGTITLE', 'REG_TITLE'], '');

        const title = esc(titleRaw);
        const ctt   = esc(cttRaw).replace(/\n/g, '<br/>');
        const dateTxt = fmtDate(created);

        // 상태 칼럼 자리에 평점 표시 (qna 스타일 그대로 쓰기 위함)
		const r = Number(rating);
		let ratingTxt = '-';
		if (!isNaN(r) && r > 0) {
		  const full = Math.max(0, Math.min(5, Math.round(r))); // 1~5로 보정
		  ratingTxt = '★'.repeat(full) + '☆'.repeat(5 - full);  // 예: ★★★☆☆
		}

        html += '  <div class="qnaItem">';
        html += '    <div class="qnaGrid">';
        html += `      <div class="qnaNo">${esc(reviewNo)}</div>`;
        html += '      <div class="qnaTitleArea">';
        html += `        <span class="qnaSubject">${title}</span>`;
        html += (regTitle ? `        <div class="qnaSub">${esc(regTitle)}</div>` : '');
        html += '      </div>';
        html += `      <div class="qnaDate">${dateTxt}</div>`;
        html += `      <div class="qnaStatus">${ratingTxt}</div>`;
        html += `      <div class="qnaGoCell"><button type="button" class="qnaGoBtn" data-reviewno="${esc(reviewNo)}" title="후기 상세로 이동">↗</button></div>`;
        html += '      <div class="qnaArrow">⌄</div>';
        html += '    </div>';

        // 아코디언 상세
        html += '    <div class="qnaDetail" style="display:none;">';
        html += `      <div class="row"><div class="lb">후기내용</div><div class="val">${ctt || '-'}</div></div>`;
        html += '    </div>';

        html += '  </div>';
      });

      html += '</div>';

      el.innerHTML = html;

      // 이벤트: ↗ 버튼은 상세 이동 / 그 외 클릭은 아코디언 토글
      el.querySelectorAll('.qnaItem').forEach((box) => {
        box.addEventListener('click', (e) => {
          const goBtn = e.target.closest('.qnaGoBtn');
          if (goBtn) {
            e.preventDefault();
            e.stopPropagation();
            const no = goBtn.dataset.reviewno;

            // ⚠️ 프로젝트에 맞게 경로만 조정하면 됨
            // 예) /reviewView.do?reviewNo=...
            location.href = `${CTX}/board.do#review/view/${no}`;
            return;
          }

          const detail = box.querySelector('.qnaDetail');
          const opened = box.classList.contains('is-open');

          box.classList.toggle('is-open', !opened);
          if (detail) detail.style.display = opened ? 'none' : 'block';
        });
      });
    }
  };

})(); // ✅ 이게 빠지면 "Unexpected end of input" 터짐
