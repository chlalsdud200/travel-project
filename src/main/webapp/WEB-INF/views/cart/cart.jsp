<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>장바구니 - TryCatchTrip</title>

<link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.8/dist/web/static/pretendard.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
<style>
    :root {
        /* [수정 1] 폰트 변수 분리: 헤더용(기본) vs 본문용(Pretendard) */
        --font-standard: system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", "Liberation Sans", sans-serif;
        --font-pretendard: "Pretendard Variable", Pretendard, -apple-system, BlinkMacSystemFont, system-ui, Roboto, "Helvetica Neue", "Segoe UI", "Apple SD Gothic Neo", "Noto Sans KR", "Malgun Gothic", "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", sans-serif;

        --max-width: 1100px;
        --primary: #333d4b;
        --primary-accent: #3182f6; /* Toss Blue style */
        --bg-body: #f2f4f6;
        --bg-card: #ffffff;
        --text-bold: #191f28;
        --text-sub: #4e5968;
        --text-muted: #8b95a1;
        --border-color: #e5e8eb;
        --shadow-soft: 0 8px 30px rgba(0, 0, 0, 0.04);
        --radius: 20px;
    }

    * { box-sizing: border-box; outline: none; }
    
    /* [수정 2] body는 기본 폰트 사용 (헤더가 board.jsp와 같아짐) */
    body { 
        margin: 0; 
        font-family: var(--font-standard); /* 기본 폰트 적용 */
        color: var(--text-bold); 
        background: var(--bg-body); 
        -webkit-font-smoothing: antialiased; 
    }

    a { text-decoration: none; color: inherit; transition: color 0.2s; }
    button { border: none; background: none; cursor: pointer; font-family: inherit; }
    input { font-family: inherit; }

    /* [수정 3] 실제 컨텐츠(main)와 모달에만 Pretendard 폰트 적용 */
    main, .payModal { 
        font-family: var(--font-pretendard);
    }
    
    main { max-width: var(--max-width); margin: 60px auto; padding: 0 20px; }
    
    .page-header { margin-bottom: 30px; }
    .page-title { font-size: 22px; font-weight: 800; color: #034c5c; margin: 0; letter-spacing: -0.5px; }

    /* Layout */
    .cart-layout { display: grid; grid-template-columns: 1fr 360px; gap: 30px; align-items: start; }
    @media (max-width: 900px) { .cart-layout { grid-template-columns: 1fr; } }

    /* Card Common */
    .card-box {
        background: var(--bg-card);
        border-radius: var(--radius);
        box-shadow: var(--shadow-soft);
        padding: 30px;
        border: 1px solid transparent;
        transition: transform 0.2s, box-shadow 0.2s;
    }
    /* Left: Item Card */
    .cart-item-card { display: flex; gap: 24px; position: relative;  border: 1px solid #7db3de;}
    @media (max-width: 600px) { .cart-item-card { flex-direction: column; } }

    .item-img-box {
        width: 160px; height: 160px; flex-shrink: 0; border-radius: 16px; overflow: hidden; background: #eee;
    }
    .item-img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.3s; }
    .item-img:hover { transform: scale(1.05); }

    .item-content { flex: 1; display: flex; flex-direction: column; justify-content: space-between; padding: 4px 0; }
    
    .tag-area { display: flex; gap: 6px; margin-bottom: 8px; }
    .tag { font-size: 11px; font-weight: 700; color: var(--primary-accent); background: rgba(49, 130, 246, 0.1); padding: 4px 8px; border-radius: 6px; }

    .item-title { font-size: 22px; font-weight: 700; line-height: 1.3; margin: 0 0 12px 0; color: var(--text-bold); }
    
    .item-details { display: flex; flex-direction: column; gap: 6px; font-size: 14px; color: var(--text-sub); }
    .detail-row i { width: 20px; color: var(--text-muted); text-align: center; margin-right: 4px; }

    /* Quantity Capsule */
    .qty-capsule {
        display: inline-flex; align-items: center; background: #f2f4f6;
        border-radius: 12px; padding: 4px; margin-top: 20px; width: fit-content;
    }
    .qty-btn {
        width: 32px; height: 32px; border-radius: 8px; font-weight: 600; color: var(--text-sub);
        display: flex; align-items: center; justify-content: center; transition: background 0.2s;
    }
    .qty-btn:hover { background: #fff; color: var(--text-bold); box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
    .qty-input {
        width: 40px; border: none; background: transparent; text-align: center;
        font-weight: 700; font-size: 15px; color: var(--text-bold); -moz-appearance: textfield;
    }
    .qty-input::-webkit-inner-spin-button { -webkit-appearance: none; margin: 0; }

    .btn-remove {
        position: absolute; top: 0; right: 0; padding: 10px;
        color: var(--text-muted); font-size: 18px; transition: color 0.2s;
    }
    .btn-remove:hover { color: #ff4d4d; }

    .back-link {
        display: inline-flex; align-items: center; gap: 6px; margin-top: 20px;
        font-size: 14px; font-weight: 600; color: var(--text-muted);
    }
    .back-link:hover { color: var(--primary-accent); }

    /* Right: Summary Card (Sticky) */
    .summary-card { position: sticky; top: 100px; padding: 32px; }
    .summary-title { font-size: 18px; font-weight: 700; margin-bottom: 24px; color: var(--text-bold); }
    
    .sum-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; font-size: 15px; color: var(--text-sub); }
    .sum-row.accent { color: #6fde7b; }
    .sum-row.total {
        margin-top: 24px; padding-top: 24px; border-top: 1px dashed var(--border-color);
        font-size: 18px; font-weight: 700; color: var(--text-bold); align-items: flex-end;
    }
    .total-price { font-size: 26px; font-weight: 800; color: var(--primary-accent); }

    .btn-pay {
        width: 100%; margin-top: 24px; padding: 18px;
        background: var(--primary-accent); color: #fff; font-size: 17px; font-weight: 700;
        border-radius: 16px; transition: all 0.2s; box-shadow: 0 4px 14px rgba(49, 130, 246, 0.3);
    }
    .btn-pay:hover { background: #1b64da; transform: translateY(-2px); box-shadow: 0 6px 20px rgba(49, 130, 246, 0.4); }

    /* Modal (Refined) */
    .payModalBackdrop {
        position: fixed; inset: 0; background: rgba(0, 0, 0, 0.5); backdrop-filter: blur(4px);
        display: none; align-items: center; justify-content: center; z-index: 9999;
    }
    .payModal { width: 400px; background: #fff; border-radius: 24px; overflow: hidden; box-shadow: 0 20px 50px rgba(0,0,0,0.2); animation: slideUp 0.3s ease-out; }
    @keyframes slideUp { from { transform: translateY(20px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }

    .payModalHeader { padding: 24px; display: flex; justify-content: space-between; align-items: center; }
    .payModalTitle { font-size: 18px; font-weight: 800; }
    .btnClose { width: 32px; height: 32px; background: #f2f4f6; border-radius: 50%; font-size: 14px; }
    
    .payModalBody { padding: 0 24px 24px; }
    .payOption {
        display: flex; align-items: center; justify-content: space-between;
        padding: 16px; border: 1px solid var(--border-color); border-radius: 16px;
        cursor: pointer; margin-bottom: 12px; transition: all 0.2s;
    }
    .payOption:hover, .payOption:has(input:checked) { border-color: var(--primary-accent); background: rgba(49, 130, 246, 0.03); }
    .payOptionContent .main { font-weight: 700; font-size: 15px; margin-bottom: 2px; }
    .payOptionContent .sub { font-size: 12px; color: var(--text-muted); }
    
    .payModalFooter { padding: 16px 24px; background: #f9fafb; display: flex; gap: 12px; }
    .btn-action { flex: 1; padding: 14px; border-radius: 14px; font-weight: 700; font-size: 15px; }
    .btn-cancel { background: #fff; border: 1px solid var(--border-color); color: var(--text-sub); }
    .btn-confirm { background: var(--primary-accent); color: #fff; border: none; }

    /* Empty State */
    .empty-cart { text-align: center; padding: 80px 0; color: var(--text-muted); }
    .empty-icon { font-size: 48px; margin-bottom: 20px; opacity: 0.3; }
</style>
</head>
<body>

    <%@ include file="/WEB-INF/views/common/tctHeader.jsp" %> 
    <%-- <jsp:include page="/WEB-INF/views/common/tctHeader.jsp" /> --%>
    <main>
        <div class="page-header">
            <h3 class="page-title">장바구니</h3>
        </div>

        <c:choose>
            <c:when test="${empty cart}">
                <div class="card-box empty-cart">
                    <i class="fa-solid fa-cart-shopping empty-icon"></i>
                    <h2 style="font-size: 20px; color: var(--text-bold); margin-bottom: 10px;">장바구니가 비어있어요</h2>
                    <p style="font-size: 14px; margin-bottom: 30px;">원하는 여행 상품을 담아보세요.</p>
                    <a href="${ctx}/regProdResults.do?keyword=" class="btn-pay" style="display:inline-block; width:auto; padding: 14px 30px;">상품 보러 가기</a>
                </div>
            </c:when>

            <c:otherwise>
                <div class="cart-layout">
                    <div class="cart-left">
                        <div class="card-box cart-item-card">
                            <form action="${ctx}/cart/remove.do" method="post" style="position: absolute; right: 20px; top: 20px; z-index: 10;">
                                <button type="submit" class="btn-remove" title="삭제"><i class="fa-solid fa-trash-can"></i></button>
                            </form>

                            <div class="item-img-box">
                                <img src="${ctx}${not empty cart.imgPath ? cart.imgPath : '/assets/images/location/reg_default.jpg'}" class="item-img" alt="상품이미지">
                            </div>
                            
                            <div class="item-content">
                                <div>
                                    <div class="tag-area">
                                        <span class="tag">패키지</span>
                                        <span class="tag">${cart.ctryName}</span>
                                    </div>
                                    <h2 class="item-title">${cart.regTitle}</h2>
                                    
                                    <div class="item-details">
                                        <div class="detail-row"><i class="fa-regular fa-calendar"></i> ${cart.startDt} ~ ${cart.endDt}</div>
                                        <div class="detail-row"><i class="fa-solid fa-location-dot"></i> ${cart.locName}</div>
                                    </div>
                                </div>

                                <div class="qty-capsule">
                                    <button class="qty-btn" type="button" id="qtyMinus"><i class="fa-solid fa-minus"></i></button>
                                    <input type="number" id="peopleCnt" class="qty-input" value="${cart.peopleCnt}" readonly>
                                    <button class="qty-btn" type="button" id="qtyPlus"><i class="fa-solid fa-plus"></i></button>
                                </div>
                            </div>
                        </div>
                        
                        <a href="${ctx}/regProdDetail.do?regId=${cart.regId}" class="back-link">
                           <i class="fa-solid fa-chevron-left"></i> 상품 상세 정보 다시보기
                        </a>
                    </div>

                    <aside class="card-box summary-card">
                        <div class="summary-title">결제 금액</div>
                        
                        <div class="sum-row">
                            <span>상품 금액</span>
                            <span style="font-weight: 600;" id="subtotal-display">0원</span>
                        </div>
                        <div class="sum-row accent">
                            <span>할인 금액</span>
                            <span>- 0원</span>
                        </div>
                        <div class="sum-row">
                            <span>세금/수수료</span>
                            <span id="tax-display">0원</span>
                        </div>
                        <div class="sum-row">
                            <span>총 인원</span>
                            <span id="summary-qty">${cart.peopleCnt}명</span>
                        </div>
                        
                        <div class="sum-row total">
                            <span>총 결제금액</span>
                            <span class="price-val"><span id="total-price-display" class="total-price">0</span>원</span>
                        </div>

                        <button class="btn-pay" id="payBtn">결제하기</button>
                        <div style="margin-top: 16px; font-size: 12px; color: var(--text-muted); text-align: center;">
                            <i class="fa-solid fa-shield-halved"></i> 안전한 결제를 위해 암호화됩니다.
                        </div>
                    </aside>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <div class="payModalBackdrop" id="payModalBackdrop" aria-hidden="true">
        <div class="payModal" role="dialog" aria-modal="true">
            <div class="payModalHeader">
                <span class="payModalTitle">결제수단 선택</span>
                <button type="button" class="btnClose" id="payModalClose"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <div class="payModalBody">
                <label class="payOption">
                    <div class="payOptionContent">
                        <div class="main">카카오페이</div>
                        <div class="sub">간편결제</div>
                    </div>
                    <input type="radio" name="payMethod" value="kakaopay" checked>
                </label>
                <label class="payOption">
                    <div class="payOptionContent">
                        <div class="main">신용/체크카드</div>
                        <div class="sub">토스페이먼츠</div>
                    </div>
                    <input type="radio" name="payMethod" value="uplus">
                </label>
            </div>
            <div class="payModalFooter">
                <button type="button" class="btn-action btn-cancel" id="payModalCancel">취소</button>
                <button type="button" class="btn-action btn-confirm" id="payModalConfirm">결제하기</button>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/tctFooter.jsp" %>
    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/payment/tct-pay.js"></script>
    
    <script>
    (function(){
        // Data Init
        window.unitPrice = ${empty cart ? 0 : cart.regPrice};
        const TAX_RATE = 0.10;
        
        const qtyInput = document.getElementById("peopleCnt");
        const btnMinus = document.getElementById("qtyMinus");
        const btnPlus = document.getElementById("qtyPlus");

        // Logic: Update UI
        function updateSummary() {
            if(!qtyInput) return;
            const qty = parseInt(qtyInput.value, 10) || 1;
            
            const total = window.unitPrice * qty;
            const subtotal = Math.ceil(total / (1 + TAX_RATE));
            const tax = total - subtotal;
            
            // Text Content Update
            document.getElementById('summary-qty').textContent = qty + "명";
            document.getElementById('subtotal-display').textContent = subtotal.toLocaleString() + "원";
            document.getElementById('tax-display').textContent = tax.toLocaleString() + "원";
            document.getElementById('total-price-display').textContent = total.toLocaleString();
        }

        // Logic: Sync Server
        const CTX = "${ctx}";
        const syncQtyToServer = async (qty) => {
          const params = new URLSearchParams({ peopleCnt: String(qty) });
          await fetch(CTX + "/cart/updatePeopleCnt.do", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8" },
            body: params
          });
        };

        async function changeQty(delta) {
          let v = parseInt(qtyInput.value, 10) || 1;
          v += delta;
          if (v < 1) v = 1;

          qtyInput.value = v;
          updateSummary();
          await syncQtyToServer(v);
        }

        // Event Listeners
        if(btnMinus) btnMinus.addEventListener("click", () => changeQty(-1));
        if(btnPlus) btnPlus.addEventListener("click", () => changeQty(1));

        // Init Run
        if(qtyInput) updateSummary();

        // Payment Module Init
        if (typeof TCTPay !== 'undefined' && document.getElementById("payBtn")) {
            TCTPay.init({
                ctx: "${pageContext.request.contextPath}",
                impCode: "imp77843200",
                radioName: "payMethod",
                ids: {
                    payBtnId: "payBtn",
                    backdropId: "payModalBackdrop",
                    closeId: "payModalClose",
                    cancelId: "payModalCancel",
                    confirmId: "payModalConfirm"
                },
                endpoints: {
                    payCreateUrl: "${pageContext.request.contextPath}/payCreate.do",
                    paymentCompleteUrl: "${pageContext.request.contextPath}/paymentComplete.do"
                },
                getOrderData: function(){
                    const qty = parseInt(document.getElementById("peopleCnt").value, 10) || 1;
                    const totalAmount = qty * window.unitPrice;
                    return {
                        reg_id: "${cart.regId}",
                        adult_cnt: qty,
                        amount: totalAmount,
                        name: "${cart.regTitle}"
                    };
                }
            });
        }
    })();
    </script>
</body>
</html>