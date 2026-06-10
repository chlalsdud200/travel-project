// /assets/js/tct-pay.js
(function (w) {
  "use strict";

  function byId(id) { return document.getElementById(id); }

  function toNum(v) {
    const n = Number(String(v ?? "").replace(/[^0-9]/g, ""));
    return Number.isFinite(n) ? n : 0;
  }

  function pickRadioValue(name, root = document) {
    const el = root.querySelector('input[name="' + name + '"]:checked');
    return el ? el.value : null;
  }

  async function postJson(url, bodyObj) {
    const resp = await fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json;charset=UTF-8" },
      body: JSON.stringify(bodyObj || {})
    });
    return resp;
  }

  // ✅ 응답을 항상 text로 받고 JSON 파싱 시도(실패하면 raw 제공)
  async function readJsonOrRaw(resp) {
    const raw = await resp.text();
    let json = null;
    try { json = JSON.parse(raw); } catch (_) {}
    return { raw, json };
  }

  function defaultIds() {
    return {
      payBtnId: "payBtn",
      backdropId: "payModalBackdrop",
      closeId: "payModalClose",
      cancelId: "payModalCancel",
      confirmId: "payModalConfirm"
    };
  }

  function mapPg(payMethod) {
    // 너 JSP의 radio value 기준: "kakaopay", "uplus"
    // 프로젝트에서 이미 uplus 쓰고 있으니 그대로 유지
    if (!payMethod) return "kakaopay";
    return payMethod;
  }

  function init(opt) {
    if (!opt) throw new Error("TCTPay.init(options) required");

    const CTX = opt.ctx || "";
    const IMP_CODE = opt.impCode || "imp77843200";

    const ids = Object.assign(defaultIds(), opt.ids || {});
    const endpoints = opt.endpoints || {};

    const payCreateUrl = endpoints.payCreateUrl || (CTX + "/payCreate.do");
    const paymentCompleteUrl = endpoints.paymentCompleteUrl || (CTX + "/paymentComplete.do");

    const radioName = opt.radioName || "payMethod";
    const getOrderData = opt.getOrderData;
    const onSuccess = typeof opt.onSuccess === "function" ? opt.onSuccess : null;
    const onFail = typeof opt.onFail === "function" ? opt.onFail : null;

    const modalBg = byId(ids.backdropId);
    const btnPay = byId(ids.payBtnId);
    const btnClose = byId(ids.closeId);
    const btnCancel = byId(ids.cancelId);
    const btnOk = byId(ids.confirmId);

    if (!btnPay) return; // 결제버튼 없으면 초기화 안 함

    function openModal() {
      if (!modalBg) return;
      modalBg.style.display = "flex";
      modalBg.setAttribute("aria-hidden", "false");
    }

    function closeModal() {
      if (!modalBg) return;
      modalBg.style.display = "none";
      modalBg.setAttribute("aria-hidden", "true");
    }

    // backdrop 클릭으로 닫기(모달 박스 클릭은 제외)
    if (modalBg) {
      modalBg.addEventListener("click", function (e) {
        if (e.target === modalBg) closeModal();
      });
    }

    if (btnClose) btnClose.addEventListener("click", closeModal);
    if (btnCancel) btnCancel.addEventListener("click", closeModal);

    btnPay.addEventListener("click", function () {
      openModal();
    });

    async function runPay() {
      if (typeof getOrderData !== "function") {
        alert("결제 설정 오류: getOrderData가 없습니다.");
        return;
      }

      const order = getOrderData() || {};
      const regId = order.reg_id || order.regId;
      const qty = Number(order.adult_cnt || order.qty || 1) || 1;
      const amount = Number(order.amount || 0) || 0;
      const name = order.name || order.title || "TryCatchTrip 결제";

      if (!regId) { alert("상품 정보(reg_id)가 없습니다."); return; }
      if (qty < 1) { alert("수량이 올바르지 않습니다."); return; }
      if (amount <= 0) { alert("결제 금액이 올바르지 않습니다."); return; }

      const payMethod = pickRadioValue(radioName) || "kakaopay";
      const pg = mapPg(payMethod);

      // 1) 주문 생성 (서버)
      let created;
      try {
        const resp = await postJson(payCreateUrl, {
          reg_id: regId,
          adult_cnt: qty,
          amount: amount
        });

        const { raw, json } = await readJsonOrRaw(resp);

        if (!resp.ok) {
          console.error("payCreate http fail:", resp.status, raw);
          alert("주문 생성 실패(HTTP " + resp.status + ")");
          return;
        }

        created = json;
        if (!created) {
          console.error("payCreate not json:", raw);
          alert("서버가 JSON이 아닌 응답을 보냈습니다. 콘솔 raw 확인");
          return;
        }

        if (!created.ok) {
          alert(created.message || "주문 생성 실패");
          return;
        }
      } catch (e) {
        console.error("payCreate error:", e);
        alert("주문 생성 중 오류: " + (e.message || e));
        return;
      }

      const merchantUid = created.merchant_uid || created.order_no || created.orderNo;
      if (!merchantUid) {
        console.error("merchant_uid missing:", created);
        alert("주문번호(merchant_uid)를 받지 못했습니다.");
        return;
      }

      // 2) PortOne 결제창 호출
      if (!w.IMP) {
        alert("포트원 SDK(iamport.js)가 로드되지 않았습니다.");
        return;
      }

      w.IMP.init(IMP_CODE);

      const req = {
        pg: pg,
        pay_method: "card",         // 간편결제/카드 공통으로 card로 처리(필요하면 분기 가능)
        merchant_uid: merchantUid,
        name: name,
        amount: amount
      };

      w.IMP.request_pay(req, async function (rsp) {
        // rsp.success가 false면 사용자가 닫거나 실패
        if (!rsp || rsp.success === false) {
          closeModal();
          const msg = (rsp && rsp.error_msg) ? rsp.error_msg : "결제가 취소/실패했습니다.";
          if (onFail) onFail(rsp);
          else alert(msg);
          return;
        }

        // 3) 결제 완료/검증(서버)
        try {
          const completeResp = await postJson(paymentCompleteUrl, {
            imp_uid: rsp.imp_uid,
            merchant_uid: rsp.merchant_uid,
            amount: amount
          });

          const { raw, json } = await readJsonOrRaw(completeResp);

          if (!completeResp.ok) {
            console.error("paymentComplete http fail:", completeResp.status, raw);
            alert("결제 검증 실패(HTTP " + completeResp.status + ")");
            return;
          }

          if (!json) {
            console.error("paymentComplete not json:", raw);
            alert("서버가 JSON이 아닌 응답을 보냈습니다. 콘솔 raw 확인");
            return;
          }

          if (!json.ok) {
            alert(json.message || "결제 검증 실패");
            return;
          }

          closeModal();
          if (onSuccess) onSuccess(json, rsp);
          else alert("결제가 완료되었습니다.");

        } catch (e) {
          console.error("paymentComplete error:", e);
          alert("결제 완료 처리 중 오류: " + (e.message || e));
        }
      });
    }

    if (btnOk) btnOk.addEventListener("click", function () {
      runPay();
    });
  }

  w.TCTPay = { init: init };
})(window);
