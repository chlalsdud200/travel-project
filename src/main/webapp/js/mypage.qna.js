/**
 * mypage.qna.js
 * - 마이페이지 > 문의내역(QNA) 렌더링 전용
 * - 존재이유: mypage.core.js가 받은 items를 "화면 형태"로만 그리게 분리하기 위해
 */
(function () {

  // [의미] innerHTML로 넣기 전에 최소한의 XSS 깨짐 방지용 escape
  const h = (s) => String(s ?? '').replace(/[&<>"']/g, (m) => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
  }[m]));

  window.MypageQna = {

    /**
     * @param {HTMLElement} el  - 마이페이지 우측 section 영역
     * @param {Array} items     - /mypageData.do?type=qna 에서 내려온 items
     * @param {Object} opts     - { CTX, ... }  (mypage.core.js에서 전달)
     */
    render: function (el, items, opts) {

      const CTX = opts.CTX; // [의미] 컨텍스트 경로(/tryCatchTrip) - 상세 이동 URL에 사용

      if (!items || items.length === 0) {
        el.innerHTML = '<div class="empty"><div class="icon">0</div><div>문의 내역이 없습니다.</div></div>';
        return;
      }

      // [의미] 헤더(6칸) + 리스트 렌더
      let html = '';
      html += '<div class="qnaContainer">';
      html += '  <div class="qnaGroup">';
      html += '    <div class="qnaGrid qnaHeader">';
      html += '      <div>번호</div>';
      html += '      <div class="col-title">제목</div>';
      html += '      <div>작성일</div>';
      html += '      <div>상태</div>';
      html += '      <div>상세</div>';
      html += '      <div></div>';
      html += '    </div>';

      items.forEach((it) => {

        const qnaNo = it.qnaNo;
        const viewNo = (it.displayNo != null) ? it.displayNo : qnaNo; // [의미] 목록 표시번호 / 존재이유: 문의게시판 목록과 같은 번호(공백 없는 순번)로 맞추기
        const title = h(it.qnaTitle || '');
        const createdAt = h(it.createdAt || '');
        const qnaCtt = h(it.qnaCtt || '');
        const ansCtt = h(it.ansCtt || '');
        const ansAt = h(it.ansAt || '');

        // [의미] 상태 판정(필드가 없거나 공백이면 대기)
        const isDone = (it.qnaStatus === 'DONE') || (!!it.ansAt) || (!!it.ansCtt);
        const badgeCls = isDone ? 'done' : 'wait';
        const badgeText = isDone ? '답변완료' : '답변대기';

        html += '    <div class="qnaItem">';
        html += '      <div class="qnaGrid">';
        html += `        <div class="qnaNo">${viewNo}</div>`;

        html += '        <div class="qnaTitleArea">';
        html += `          <span class="qnaSubject">${title}</span>`;
        html += '        </div>';

        html += `        <div class="qnaDate">${createdAt}</div>`;

        html += '        <div class="qnaState">';
        html += `          <span class="qnaBadge ${badgeCls}">${badgeText}</span>`;
        html += (isDone && ansAt) ? (`<div class="qnaAnsAt">${ansAt}</div>`) : '';
        html += '        </div>';

        // [의미] 상세 버튼 클릭 시 게시판 QNA 상세로 이동(기존 라우터 규칙 재사용)
        html += `        <div class="qnaGoCell"><button type="button" class="qnaGoBtn" data-qnano="${qnaNo}" title="문의 상세로 이동">↗</button></div>`;

        // [의미] 아코디언 토글 표시
        html += '        <div class="qnaArrow">⌄</div>';
        html += '      </div>';

        // [의미] 상세(아코디언) - 문의/답변 내용 표시
        html += '      <div class="qnaDetail">';
        html += '        <div class="row"><div class="lb">문의내용</div><div class="val">' + qnaCtt + '</div></div>';
        html += '        <div class="ans">';
        html += '          <div class="row"><div class="lb">답변일</div><div class="val">' + (ansAt || '-') + '</div></div>';
        html += '          <div class="row"><div class="lb">답변내용</div><div class="val">' + (ansCtt || '-') + '</div></div>';
        html += '        </div>';
        html += '      </div>';

        html += '    </div>';
      });

      html += '  </div>';
      html += '</div>';

      el.innerHTML = html;

      // [의미] 이벤트:
      //  - ↗ 버튼: 상세 이동
      //  - 그 외 클릭: 아코디언 토글(아래 카드가 밀리게)
      el.querySelectorAll('.qnaItem').forEach((box) => {
        box.addEventListener('click', (e) => {

          const goBtn = e.target.closest('.qnaGoBtn');
          if (goBtn) {
            const no = goBtn.dataset.qnano;
            location.href = `${CTX}/board.do#qna/view/${no}`;
            return;
          }

          const detail = box.querySelector('.qnaDetail');
          const opened = box.classList.contains('is-open');

          box.classList.toggle('is-open', !opened);
          detail.style.display = opened ? 'none' : 'block';
        });
      });

    }
  };

})();
