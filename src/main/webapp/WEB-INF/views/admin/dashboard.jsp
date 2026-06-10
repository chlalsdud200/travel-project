<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  // 사이드바 활성화 표시(필수): adminSidebar.jspf에서 사용
  request.setAttribute("adminActive", "dashboard");

  Object todaySalesObj      = request.getAttribute("todaySales");
  Object newMembers7dObj    = request.getAttribute("newMembers7d");
  Object pendingOrdersObj   = request.getAttribute("pendingOrders");
  Object pendingRefundsObj  = request.getAttribute("pendingRefunds");

  Object totalMembersObj    = request.getAttribute("totalMembers");
  Object inactiveMembersObj = request.getAttribute("inactiveMembers");

  // 상품관리 요약
  Object totalProductsObj   = request.getAttribute("totalProducts");
  Object onSaleProductsObj  = request.getAttribute("onSaleProducts");
  Object hiddenProductsObj  = request.getAttribute("hiddenProducts");

  // 결제관리 요약
  Object payPendingCntObj   = request.getAttribute("payPendingCnt");
  Object payPaidCntObj      = request.getAttribute("payPaidCnt");
  Object payRefundCntObj    = request.getAttribute("payRefundCnt");
  
  // 게시판관리 요약
  Object boardQnaCntObj        = request.getAttribute("boardQnaCnt");
  Object boardReviewCntObj     = request.getAttribute("boardReviewCnt");
  Object boardUnansweredCntObj = request.getAttribute("boardUnansweredCnt");

  String boardQnaCnt        = (boardQnaCntObj        == null) ? "-" : String.valueOf(boardQnaCntObj);
  String boardReviewCnt     = (boardReviewCntObj     == null) ? "-" : String.valueOf(boardReviewCntObj);
  String boardUnansweredCnt = (boardUnansweredCntObj == null) ? "-" : String.valueOf(boardUnansweredCntObj);

  String todaySales     = (todaySalesObj     == null) ? "-" : String.valueOf(todaySalesObj);
  String newMembers7d   = (newMembers7dObj   == null) ? "-" : String.valueOf(newMembers7dObj);
  String pendingOrders  = (pendingOrdersObj  == null) ? "-" : String.valueOf(pendingOrdersObj);
  String pendingRefunds = (pendingRefundsObj == null) ? "-" : String.valueOf(pendingRefundsObj);

  String totalMembers    = (totalMembersObj    == null) ? "-" : String.valueOf(totalMembersObj);
  String inactiveMembers = (inactiveMembersObj == null) ? "-" : String.valueOf(inactiveMembersObj);

  String totalProducts   = (totalProductsObj   == null) ? "-" : String.valueOf(totalProductsObj);
  String onSaleProducts  = (onSaleProductsObj  == null) ? "-" : String.valueOf(onSaleProductsObj);
  String hiddenProducts  = (hiddenProductsObj  == null) ? "-" : String.valueOf(hiddenProductsObj);

  String payPendingCnt   = (payPendingCntObj   == null) ? "-" : String.valueOf(payPendingCntObj);
  String payPaidCnt      = (payPaidCntObj      == null) ? "-" : String.valueOf(payPaidCntObj);
  String payRefundCnt    = (payRefundCntObj    == null) ? "-" : String.valueOf(payRefundCntObj);

  String newMembers7dPlus = "-".equals(newMembers7d) ? "-" : "+" + newMembers7d;
  
  Object newDeltaIconObj = request.getAttribute("new_delta_icon");
  Object newDeltaTextObj = request.getAttribute("new_delta_text");
  String newDeltaIcon = (newDeltaIconObj == null) ? "fa-minus" : String.valueOf(newDeltaIconObj);
  String newDeltaText = (newDeltaTextObj == null) ? "-" : String.valueOf(newDeltaTextObj);

  // 최근 결제(표)
  java.util.List<kr.or.ddit.tct.admin.payments.vo.AdminPaymentVO> recentPayList =
      (java.util.List<kr.or.ddit.tct.admin.payments.vo.AdminPaymentVO>) request.getAttribute("recentPayList");
  

  String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>TryCatchTrip - Admin Dashboard</title>

  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

  <link rel="stylesheet" href="<%= ctx %>/css/admin-dashboard.css">
  
  <style>
    /* 기존 CSS 파일 내용을 덮어씌움 */
    .grid-kpi {
      display: grid;
      /* 4칸(repeat(4, 1fr))이던 것을 3칸으로 강제 변경하여 꽉 차게 만듦 */
      grid-template-columns: repeat(3, 1fr) !important; 
      gap: 24px; /* 기존 간격 유지 (필요 시 조정) */
      margin-bottom: 24px;
    }

    /* 모바일 반응형 대응 (화면 작아지면 1줄로) */
    @media (max-width: 992px) {
      .grid-kpi {
        grid-template-columns: 1fr !important;
      }
    }
  </style>
</head>

<body>
  <div class="app">

    <%@ include file="/WEB-INF/views/admin/adminSidebar.jspf" %>

    <main class="main">
    

      <header class="topbar">
        <div class="crumb">전체보기 / <strong>대시보드</strong></div>

        <div class="topbar-right">
          <div class="bell" title="알림">
            <i class="fas fa-bell"></i>
            <span class="badge"></span>
          </div>

          <div class="admin-chip">
            <div class="admin-avatar">A</div>
            <div class="admin-name">관리자님</div>
          </div>
        </div>
      </header>

      <div class="content">
        <div class="container">

          <div class="page-head">
            <div>
              <h2 class="page-title">대시보드</h2>
              <p class="page-sub">현재 운영 현황을 요약으로 표시합니다. (상세는 각 관리 메뉴에서 확인)</p>
            </div>

            <div class="updated">
              Last updated:
              <span><%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(new java.util.Date()) %></span>
            </div>
          </div>

          <section class="grid-kpi">
            <div class="card card-pad">
              <div class="kpi-top">
                <div>
                  <div class="kpi-label">신규 회원(7일)</div>
                  <div class="kpi-value"><%= newMembers7d %></div>
                </div>
                <div class="icon-pill pill-blue"><i class="fas fa-user-plus"></i></div>
              </div>
              <div class="kpi-foot" style="color: var(--blue);">
 			 <i class="fas <%= newDeltaIcon %>" style="margin-right:6px;"></i>
 			 전일 대비 <%= newDeltaText %>
				</div>

            </div>

            <div class="card card-pad">
              <div class="kpi-top">
                <div>
                  <div class="kpi-label">오늘 매출</div>
                  <div class="kpi-value"><%= todaySales %></div>
                </div>
                <div class="icon-pill pill-green"><i class="fas fa-won-sign"></i></div>
              </div>
              <div class="kpi-foot" style="color: var(--green);">
                <i class="fas fa-caret-up" style="margin-right:6px;"></i> 전일 대비
              </div>
            </div>

            <div class="card card-pad">
              <div class="kpi-top">
                <div>
                  <div class="kpi-label">결제 실패</div>
                  <div class="kpi-value"><%= pendingOrders %></div>
                </div>
                <div class="icon-pill pill-amber"><i class="fas fa-clock"></i></div>
              </div>
              <div class="kpi-foot" style="color: var(--amber);">
               	결제 진행중 완료되지 않음
              </div>
            </div>
            
            </section>

          <section class="grid-3">

            <section class="card">
              <div class="panel-head">
                <div class="panel-titlebox">
                  <div class="icon-pill pill-indigo"><i class="fas fa-users"></i></div>
                  <div>
                    <h3 class="panel-title">회원관리</h3>
                    <p class="panel-desc">회원 현황 요약</p>
                  </div>
                </div>
                <div class="panel-meta">대시보드 요약</div>
              </div>

              <div class="panel-body">
                <div class="mini-grid">
                  <div class="mini">
                    <div class="mini-k">TOTAL</div>
                    <div class="mini-v"><%= totalMembers %></div>
                  </div>
                  <div class="mini">
                    <div class="mini-k">NEW</div>
                    <div class="mini-v v-indigo"><%= newMembers7dPlus %></div>
                  </div>
                  <div class="mini">
                    <div class="mini-k">INACTIVE</div>
                    <div class="mini-v v-slate"><%= inactiveMembers %></div>
                  </div>
                </div>

                <div style="margin-top: 12px; display:flex; gap:10px;">
                  <a href="<%= ctx %>/admin/members.do" class="btn btn-indigo" style="flex:1;">
                    회원관리로 이동
                  </a>
                </div>
              </div>
            </section>

            <section class="card">
              <div class="panel-head">
                <div class="panel-titlebox">
                  <div class="icon-pill pill-blue"><i class="fas fa-box"></i></div>
                  <div>
                    <h3 class="panel-title">상품관리</h3>
                    <p class="panel-desc">상품 상태 요약</p>
                  </div>
                </div>
                <div class="panel-meta">대시보드 요약</div>
              </div>

              <div class="panel-body">
                <div class="mini-grid">
                  <div class="mini">
                    <div class="mini-k">PRODUCTS</div>
                    <div class="mini-v"><%= totalProducts %></div>
                  </div>
                  <div class="mini">
                    <div class="mini-k">ON SALE</div>
                    <div class="mini-v v-green"><%= onSaleProducts %></div>
                  </div>
                  <div class="mini">
                    <div class="mini-k">HIDDEN</div>
                    <div class="mini-v v-red"><%= hiddenProducts %></div>
                  </div>
                </div>

                <div style="margin-top: 12px; display:flex; gap:10px;">
                  <a href="<%= ctx %>/admin/prod/adminProducts.do?tab=list" class="btn btn-dark" style="flex:1;">
                    상품관리로 이동
                  </a>
                </div>
              </div>
            </section>

            <section class="card">
              <div class="panel-head">
                <div class="panel-titlebox">
                  <div class="icon-pill" style="background: var(--amber-weak); color: var(--amber);">
                    <i class="fas fa-clipboard-list"></i>
                  </div>
                  <div>
                    <h3 class="panel-title">게시판관리</h3>
                    <p class="panel-desc">문의/후기/신고 요약</p>
                  </div>
                </div>
                <div class="panel-meta">대시보드 요약</div>
              </div>

              <div class="panel-body">
                <div class="mini-grid">
				  <div class="mini">
				    <div class="mini-k">QnA</div>
				    <div class="mini-v"><%= boardQnaCnt %></div>
				  </div>
				  <div class="mini">
				    <div class="mini-k">UNANSWERED</div>
				    <div class="mini-v v-red"><%= boardUnansweredCnt %></div>
				  </div>
				  <div class="mini">
				    <div class="mini-k">REVIEW</div>
				    <div class="mini-v v-amber"><%= boardReviewCnt %></div>
				  </div>
				</div>


                <div style="margin-top: 12px; display:flex; gap:10px;">
                  <a href="<%= ctx %>/admin/boards.do" class="btn btn-amber" style="flex:1;">
                    게시판관리로 이동
                  </a>
                </div>
              </div>
            </section>

          </section>

          <section class="card" style="margin-bottom: 24px;">
            <div class="panel-head" style="flex-wrap:wrap;">
              <div class="panel-titlebox">
                <div class="icon-pill pill-red"><i class="fas fa-credit-card"></i></div>
                <div>
                  <h3 class="panel-title">결제/취소/환불관리</h3>
                  <p class="panel-desc">결제 상태 요약 + 최근 예약/결제 현황</p>
                </div>
              </div>
              <a href="<%= ctx %>/admin/payments.do" class="btn btn-dark">결제관리로 이동</a>
            </div>

            <div class="panel-body">
              <div class="mini-grid" style="grid-template-columns: repeat(3, 1fr);">
                <div class="mini">
                  <div class="mini-k">FAIL</div>
                  <div class="mini-v v-amber"><%= payPendingCnt %></div>
                  <div class="note" style="margin-top:6px;">결제 실패</div>
                </div>
                <div class="mini">
                  <div class="mini-k">PAID</div>
                  <div class="mini-v v-green"><%= payPaidCnt %></div>
                  <div class="note" style="margin-top:6px;">결제 완료</div>
                </div>
                <div class="mini">
                  <div class="mini-k">REFUND</div>
                  <div class="mini-v v-red"><%= payRefundCnt %></div>
                  <div class="note" style="margin-top:6px;">환불 처리</div>
                </div>
              </div>
            </div>

            <div class="table-wrap">
              <table>
                <thead>
                  <tr>
                    <th>주문번호</th>
                    <th>회원명</th>
                    <th>상품명</th>
                    <th>결제금액</th>
                    <th class="center">상태</th>
                  </tr>
                </thead>
                <tbody>
                  <%
                    if (recentPayList == null || recentPayList.isEmpty()) {
                  %>
                    <tr>
                      <td colspan="5" class="center" style="padding: 18px; color: rgba(15,23,42,.55);">
                        최근 결제 내역이 없습니다.
                      </td>
                    </tr>
                  <%
                    } else {
                      java.text.NumberFormat nf2 = java.text.NumberFormat.getNumberInstance(java.util.Locale.KOREA);
                      for (kr.or.ddit.tct.admin.payments.vo.AdminPaymentVO vo : recentPayList) {
                        String st = (vo.getPayStatus() == null) ? "-" : vo.getPayStatus();
                        String amountText = "₩" + nf2.format(vo.getPayAmount());
                  %>
                    <tr>
                      <td class="td-mono"><%= vo.getOrderNo() %></td>
                      <td style="font-weight:900; color: rgba(15,23,42,.82);"><%= vo.getUserName() %></td>
                      <td><%= vo.getRegTitle() %></td>
                      <td style="font-weight:900; color: rgba(15,23,42,.82);"><%= amountText %></td>
                      <td class="center">
                        <%
                          if ("PAID".equalsIgnoreCase(st)) {
                        %>
                          <span class="chip chip-paid">PAID</span>
                        <%
                          } else if ("PENDING".equalsIgnoreCase(st) || "READY".equalsIgnoreCase(st)) {
                        %>
                          <span class="chip" style="background: rgba(217,119,6,.10); color: var(--amber);">FAIL</span>
                        <%
                          } else if ("REFUND".equalsIgnoreCase(st)) {
                        %>
                          <span class="chip" style="background: rgba(239,68,68,.10); color: var(--red);">REFUND</span>
                        <%
                          } else if ("CANCELED".equalsIgnoreCase(st) || "CANCELLED".equalsIgnoreCase(st)) {
                        %>
                          <span class="chip" style="background: rgba(15,23,42,.06); color: rgba(15,23,42,.60);">CANCELED</span>
                        <%
                          } else {
                        %>
                          <span class="chip" style="background: rgba(15,23,42,.06); color: rgba(15,23,42,.60);"><%= st %></span>
                        <%
                          }
                        %>
                      </td>
                    </tr>
                  <%
                      }
                    }
                  %>
                </tbody>
              </table>
            </div>
          </section>

        </div>
      </div>
    </main>
  </div>
</body>
</html>