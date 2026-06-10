/**
 * mypage.pay.js
 * - 역할: 결제내역(pay) 섹션 렌더링 + 결제취소 버튼 동작
 * - 존재이유: 결제 UI/환불 로직이 길어서 core에서 분리(가독성/유지보수)
 */

window.MypagePay = (function(){

  /* =========================
   * [추가] 여행 시작일 기준 "시작 7일 전부터 취소 불가" 판정 유틸
   * - 왜 필요한지: startDt(문자열)로 '오늘 >= (startDt-7일)'인지 계산해야 함
   * - 무슨 기능인지: 날짜 파싱 + 취소 잠금 여부(true/false) 반환
   * ========================= */
  function parseYMD(s){
    if (!s) return null;

    let t = String(s).trim();
    if (!t) return null;

    // "YYYY.MM.DD" / "YYYY/MM/DD" / "YYYY-MM-DD 00:00:00" / "YYYY-MM-DDTHH:mm:ss" 대응
    t = t.replace(/\./g, "-").replace(/\//g, "-");
    t = t.split("T")[0].split(" ")[0];

    const p = t.split("-");
    if (p.length < 3) return null;

    const y = Number(p[0]);
    const m = Number(p[1]) - 1;
    const d = Number(p[2]);
    if (!y || isNaN(m) || !d) return null;

    const dt = new Date(y, m, d);
    dt.setHours(0,0,0,0);
    return dt;
  }

  function isCancelLocked(startDtStr, days){
    const sd = parseYMD(startDtStr);
    if (!sd) return false; // 파싱 실패 시 프론트는 일단 허용(서버에서 최종 차단 권장)

    const lock = new Date(sd);
    lock.setDate(lock.getDate() - days);
    lock.setHours(0,0,0,0);

    const now = new Date();
    now.setHours(0,0,0,0);

    // 시작일-7일(포함)부터 잠금
    return now.getTime() >= lock.getTime();
  }


  // [의미] 결제 카드 1개를 HTML로 만드는 함수(렌더링 책임을 분리)
  function renderPayCard(it, h){
    const title = h.esc(it.regTitle || it.packageTitle || '상품');
    const loc   = h.esc([it.ctryName, it.locName].filter(Boolean).join(' · '));

    const start = h.esc(it.startDt || '');
    const end   = h.esc(it.endDt || '');
    const qty   = Number(it.orderQty ?? 0);

    const paidAt = h.esc(it.paidAt || it.orderDate || '');
    const amount = h.money(it.payAmount ?? it.itemTotal ?? it.totalPrice);

    const thumb = h.imgUrl(it.imgPath);
    const thumbHtml = thumb
      ? '<img src="' + h.esc(thumb) + '" alt="' + title + '">'
      : '<div style="font-weight:950;color:rgba(15,23,42,.55);font-size:12px;">NO IMAGE</div>';

    const period = (start && end) ? (start + ' ~ ' + end) : '-';
    const people = qty ? (qty + '명') : '-';

    // [의미] DB의 상태값(PAID/CANCELED/FAILED)을 사용자 문구 + 클래스(색상)로 변환
    const payStatus = it.payStatus; // PAID / CANCELED / FAILED
    let statusText = '결제상태';
    let statusCls  = 'payStatus--failed';

    if (payStatus === 'PAID') {
      statusText = '결제완료';
      statusCls  = 'payStatus--paid';
    } else if (payStatus === 'CANCELED') {
      statusText = '취소완료';
      statusCls  = 'payStatus--canceled';
    } else {
      statusText = '결제실패';
      statusCls  = 'payStatus--failed';
    }

    // [의미] 상태는 항상 보이게 넣어서 "PAID인지"를 한 눈에 보이게 한다.
    const statusHtml = '<span class="payStatus ' + statusCls + '">' + statusText + '</span>';

    // [의미] 결제완료(PAID)일 때만 취소 버튼을 만든다(취소완료/실패는 버튼 자체 숨김)
    let cancelBtnHtml = '';
    if (payStatus === 'PAID') {

      /* =========================
       * [추가] 시작일 7일 전부터 취소 불가 -> 버튼 disabled 렌더링
       * - 왜 필요한지: UI에서 취소 버튼을 막아 사용자 혼란/오동작 방지
       * - 무슨 기능인지: locked면 '취소불가' + disabled, 아니면 기존 '결제취소'
       * ========================= */
      const locked = isCancelLocked(it.startDt, 7);

      if (!locked) {
        cancelBtnHtml =
          '<button type="button" class="payCancel" data-action="cancel"'
        + ' data-orderno="' + h.esc(it.orderNo) + '"'
        + ' data-startdt="' + h.esc(it.startDt || '') + '">'
        +   '결제취소'
        + '</button>';
		} else {
		  cancelBtnHtml =
		    '<button type="button" class="payCancel" data-action="cancel" disabled'
		  + ' style="background:#cbd5e1;border-color:#cbd5e1;color:rgba(15,23,42,.55);cursor:not-allowed;opacity:1;box-shadow:none;"'
		  + ' data-orderno="' + h.esc(it.orderNo) + '"'
		  + ' data-startdt="' + h.esc(it.startDt || '') + '"'
		  + ' title="여행 시작 7일 전부터는 취소할 수 없습니다.">'
		  +   '취소불가'
		  + '</button>';
		}

    }

    // [의미] 취소완료면 금액 취소선 + 카드 회색톤을 주기 위한 클래스
    const amountCls = (payStatus === 'CANCELED') ? 'payAmount isCanceled' : 'payAmount';
    const cardCls   = (payStatus === 'CANCELED') ? 'payCard isCanceled' : 'payCard';

    return ''
      + '<div class="' + cardCls + '" data-regid="' + h.esc(it.regId) + '" title="클릭하면 상품 상세로 이동">'
      +   '<div class="payThumb">' + thumbHtml + '</div>'
      +   '<div class="payMeta">'
      +     '<div class="payTitle"><span class="payTitleText">' + title + '</span>' + statusHtml + '</div>'
      +     '<div class="paySub">'
      +       (loc ? '<span class="payTag payTag--loc">지역: ' + loc + '</span>' : '')
      +     '</div>'
      +     '<div class="payRows">'
      +       '<div><b>여행기간</b>' + period + '</div>'
      +       '<div><b>인원</b>' + people + '</div>'
      +       '<div><b>결제일</b>' + (paidAt || '-') + '</div>'
      +       '<div><b>주문번호</b><small>' + h.esc(it.orderNo || '') + '</small></div>'
      +     '</div>'
      +   '</div>'
      +   '<div class="payActions">'
      +     '<div class="' + amountCls + '">' + amount + '원</div>'
      +     cancelBtnHtml
      +   '</div>'
      + '</div>';
  }

  // [의미] pay 섹션 전체를 그리는 함수
  function render(el, items, h){
    if (!items || items.length === 0) {
      el.innerHTML = '<div class="empty"><div class="icon">0</div><div>표시할 내역이 없습니다.</div></div>';
      return;
    }

    let cards = '';
    for (let i = 0; i < items.length; i++) cards += renderPayCard(items[i], h);
    el.innerHTML = '<div class="payList">' + cards + '</div>';

    // [의미] 이벤트는 섹션 엘리먼트에 딱 1번만 바인딩(재렌더링될 때 중복 바인딩 방지)
    if (!el.dataset.boundPayClick) {
      el.addEventListener('click', async (e) => {

        // (1) 취소 버튼 클릭이면 환불 처리
        const btn = e.target.closest(".payCancel[data-action='cancel']");
        if (btn) {
          e.preventDefault();
          e.stopPropagation();

          const orderNo = btn.dataset.orderno;

          /* =========================
           * [추가] 클릭 이벤트에서도 "7일 전 잠금" 2차 가드
           * - 왜 필요한지: DOM 조작으로 disabled를 풀어도 여기서 차단
           * - 무슨 기능인지: 잠금이면 alert 후 return
           * ========================= */
          const startDt = btn.dataset.startdt;
          if (isCancelLocked(startDt, 7)) {
            alert("여행 시작 7일 전부터는 취소할 수 없습니다.");
            return;
          }

          if (!confirm("정말 결제를 취소(환불)하시겠습니까?")) return;

          btn.disabled = true;
          const prevText = btn.textContent;
          btn.textContent = "취소 처리중...";

          try {
            const resp = await fetch(h.CTX + "/paymentCancel.do", {
              method: "POST",
              headers: { "Content-Type":"application/json;charset=UTF-8" },
              body: JSON.stringify({ orderNo, reason: "사용자 요청" })
            });

            const text = await resp.text();

            let data;
            try { data = JSON.parse(text); }
            catch(e) {
              alert("서버가 JSON이 아닌 응답을 보냈습니다. 콘솔(response) 확인!");
              btn.disabled = false;
              btn.textContent = prevText;
              return;
            }

            if (!resp.ok) {
              alert("HTTP 오류: " + resp.status + "\n" + (data.message || text));
              btn.disabled = false;
              btn.textContent = prevText;
              return;
            }

            if (data.ok) {
              alert("취소 완료!");
              await h.loadSection('pay');   // [의미] 성공 후 재조회해서 UI를 최신 상태로 맞춘다.
              return;
            }

            alert("취소 실패: " + (data.message || ""));
            btn.disabled = false;
            btn.textContent = prevText;
            return;

          } catch (err) {
            console.error(err);
            alert("환불 서버 통신 오류");
            btn.disabled = false;
            btn.textContent = prevText;
            return;
          }
        }

        // (2) 카드 클릭이면 상품 상세로 이동
        const card = e.target.closest('.payCard');
        if (card) {
          const regId = card.dataset.regid;
          if (regId) {
            location.href = h.CTX + '/regProdDetail.do?regId=' + encodeURIComponent(regId);
          }
        }
      });

      el.dataset.boundPayClick = '1';
    }
  }

  return { render };
})();
