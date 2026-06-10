package kr.or.ddit.tct.admin.dashboard.service;

import java.util.List;

import kr.or.ddit.tct.admin.payments.vo.AdminPaymentVO;

public interface IAdminDashboardService {

    int selectNewMembers7d();
    int selectTodaySales();
    int selectPendingOrders();
    int selectPendingRefunds();
    
    int selectTotalMembers();
    int selectInactiveMembers();
    
    //전일대비!!
    int selectNewMembersToday();
    int selectNewMembersYesterday();

    // =========================
    // 상품 요약
    // =========================
    int selectTotalProducts();
    int selectOnSaleProducts();
    int selectHiddenProducts();

    // =========================
    // 결제 요약(대시보드)
    // =========================
    int selectPayPendingCount();
    int selectPayPaidCount();
    int selectPayRefundCount();

    // ===== 게시판관리(대시보드 요약) =====
    int selectBoardQnaCount();
    int selectBoardReviewCount();
    int selectBoardUnansweredCount();

    
    // 최근 결제(대시보드 표)
    List<AdminPaymentVO> selectRecentPayments(int limit);

}
