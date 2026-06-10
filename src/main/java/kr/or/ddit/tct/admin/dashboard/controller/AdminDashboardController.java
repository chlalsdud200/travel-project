package kr.or.ddit.tct.admin.dashboard.controller;

import java.io.IOException;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.admin.dashboard.service.AdminDashboardServiceImpl;
import kr.or.ddit.tct.admin.dashboard.service.IAdminDashboardService;
import kr.or.ddit.tct.admin.payments.vo.AdminPaymentVO;
import kr.or.ddit.tct.users.vo.UserVO;

@WebServlet("/admin/dashboard.do")
public class AdminDashboardController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // [의미] 컨트롤러는 화면 제어 담당, 실제 데이터 조회는 service가 담당(역할 분리 목적)
    private final IAdminDashboardService service = AdminDashboardServiceImpl.getInstance();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // [의미] 관리자 페이지는 로그인/권한 필수 → 아니면 접근 차단
        UserVO loginUser = (UserVO) req.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.do");
            return;
        }

        // [의미] ADMIN만 대시보드 접근 가능
        if (!"ADMIN".equalsIgnoreCase(loginUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/mainPage.do");
            return;
        }

        // =========================================================
        // [1] 숫자 포맷(천단위 콤마 등) - 화면 표시용
        // =========================================================
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.KOREA);

        // =========================================================
        // [2] KPI(상단 3개) + 회원 관련
        // =========================================================
        int newMembers7d    = service.selectNewMembers7d();     // [의미] 최근 7일 신규 회원 수
        int totalMembers    = service.selectTotalMembers();     // [의미] 전체 회원 수
        int inactiveMembers = service.selectInactiveMembers();  // [의미] 비활성/탈퇴 등 비정상 상태 회원 수

        int todaySales     = service.selectTodaySales();        // [의미] 오늘 매출 합계
        int pendingOrders  = service.selectPendingOrders();     // [의미] 대기 주문/예약 수
        int pendingRefunds = service.selectPendingRefunds();    // [의미] 대기 환불 수(현재 JSP에서 쓰는지 여부와 무관하게 값은 준비)

        // =========================================================
        // [3] 상품 요약
        // =========================================================
        int totalProducts  = service.selectTotalProducts();     // [의미] 전체 상품 수
        int onSaleProducts = service.selectOnSaleProducts();    // [의미] 판매중 상품 수
        int hiddenProducts = service.selectHiddenProducts();    // [의미] 숨김/비노출 상품 수

        // =========================================================
        // [4] 결제 요약(대시보드)
        // =========================================================
        int payPendingCnt = service.selectPayPendingCount();    // [의미] 결제 대기 건수
        int payPaidCnt    = service.selectPayPaidCount();       // [의미] 결제 완료 건수
        int payRefundCnt  = service.selectPayRefundCount();     // [의미] 환불 처리 건수

        // [의미] 대시보드 표에 보여줄 최근 결제 N건
        List<AdminPaymentVO> recentPayList = service.selectRecentPayments(5);

        // =========================================================
        // [5] 신규회원 전일대비(오늘 vs 어제)
        // =========================================================
        int newToday = service.selectNewMembersToday();         // [의미] 오늘 신규 회원 수
        int newYday  = service.selectNewMembersYesterday();     // [의미] 어제 신규 회원 수

        int diff = newToday - newYday;                          // [의미] 증감(오늘-어제)

        String newDeltaIcon;                                    // [의미] 아이콘 클래스(증감 방향 표시)
        if (diff > 0) newDeltaIcon = "fa-caret-up";
        else if (diff < 0) newDeltaIcon = "fa-caret-down";
        else newDeltaIcon = "fa-minus";

        String newDeltaText;                                    // [의미] "전일 대비 +1 (50.0%)" 같은 표시 텍스트
        if (newYday == 0) {
            if (newToday == 0) {
                newDeltaText = "0 (0.0%)";
            } else {
                // [의미] 어제가 0이면 %가 무의미해서 NEW로 처리(존재이유: 0으로 나눗셈 방지 + 의미있는 문구)
                newDeltaText = "+" + nf.format(diff) + " (NEW)";
            }
        } else {
            double rate = ((double) diff / (double) newYday) * 100.0;
            String sign = (diff > 0) ? "+" : ""; // [의미] diff가 음수면 format에 -가 포함되므로 +만 조건부로 붙임
            newDeltaText = sign + nf.format(diff) + " (" + String.format(Locale.KOREA, "%.1f", rate) + "%)";
        }

        // =========================================================
        // [6] ✅ 게시판관리 대시보드 요약(문의글수/리뷰글수/미답변수)
        // =========================================================
        int boardQnaCnt        = service.selectBoardQnaCount();        // [의미] QNA 전체 글 수(삭제 제외)
        int boardReviewCnt     = service.selectBoardReviewCount();     // [의미] REVIEW 전체 글 수(삭제 제외)
        int boardUnansweredCnt = service.selectBoardUnansweredCount(); // [의미] QNA 답변대기 수

        // =========================================================
        // [7] 화면 표시용 문자열 포맷(천단위 콤마, 원화 표시 등)
        // =========================================================
        String todaySalesText      = "₩ " + nf.format(todaySales);     // [의미] "₩ 1,234,567" 형태
        String totalMembersText    = nf.format(totalMembers);
        String newMembers7dText    = nf.format(newMembers7d);
        String inactiveMembersText = nf.format(inactiveMembers);

        String totalProductsText  = nf.format(totalProducts);
        String onSaleProductsText = nf.format(onSaleProducts);
        String hiddenProductsText = nf.format(hiddenProducts);

        String payPendingText = nf.format(payPendingCnt);
        String payPaidText    = nf.format(payPaidCnt);
        String payRefundText  = nf.format(payRefundCnt);

        String boardQnaCntText        = nf.format(boardQnaCnt);
        String boardReviewCntText     = nf.format(boardReviewCnt);
        String boardUnansweredCntText = nf.format(boardUnansweredCnt);

        // =========================================================
        // [8] JSP로 값 전달(setAttribute)
        // =========================================================

        // 신규회원 전일대비 표시용
        req.setAttribute("new_delta_icon", newDeltaIcon);        // [의미] 대시보드 카드 하단 아이콘
        req.setAttribute("new_delta_text", newDeltaText);        // [의미] "전일 대비 ..." 텍스트
        req.setAttribute("new_today", nf.format(newToday));      // [의미] 필요 시 오늘 신규 회원 수 표시용(옵션)

        // 회원 KPI
        req.setAttribute("totalMembers", totalMembersText);
        req.setAttribute("newMembers7d", newMembers7dText);
        req.setAttribute("inactiveMembers", inactiveMembersText);

        // 상단 KPI
        req.setAttribute("todaySales", todaySalesText);
        req.setAttribute("pendingOrders", pendingOrders);
        req.setAttribute("pendingRefunds", pendingRefunds);

        // 상품 요약
        req.setAttribute("totalProducts", totalProductsText);
        req.setAttribute("onSaleProducts", onSaleProductsText);
        req.setAttribute("hiddenProducts", hiddenProductsText);

        // 결제 요약 + 최근 결제표
        req.setAttribute("payPendingCnt", payPendingText);
        req.setAttribute("payPaidCnt", payPaidText);
        req.setAttribute("payRefundCnt", payRefundText);
        req.setAttribute("recentPayList", recentPayList);

        // ✅ 게시판관리 요약(대시보드 카드에서 출력할 값)
        req.setAttribute("boardQnaCnt", boardQnaCntText);
        req.setAttribute("boardReviewCnt", boardReviewCntText);
        req.setAttribute("boardUnansweredCnt", boardUnansweredCntText);

        // [의미] 사이드바에서 메뉴 활성화 표시용
        req.setAttribute("adminActive", "dashboard");

        // [의미] 대시보드 JSP로 forward(리다이렉트가 아니라 내부 이동이라 데이터 유지)
        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }
}
