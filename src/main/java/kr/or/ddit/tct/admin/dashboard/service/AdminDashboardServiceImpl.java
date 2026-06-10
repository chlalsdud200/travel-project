package kr.or.ddit.tct.admin.dashboard.service;

import java.util.List;

import kr.or.ddit.tct.admin.dashboard.dao.AdminDashboardDaoImpl;
import kr.or.ddit.tct.admin.dashboard.dao.IAdminDashboardDao;
import kr.or.ddit.tct.admin.payments.vo.AdminPaymentVO;

public class AdminDashboardServiceImpl implements IAdminDashboardService {

    private static final IAdminDashboardService instance = new AdminDashboardServiceImpl();
    private final IAdminDashboardDao dao = AdminDashboardDaoImpl.getInstance();

    private AdminDashboardServiceImpl() {}
    public static IAdminDashboardService getInstance() { return instance; }

    @Override public int selectNewMembers7d()   { return dao.selectNewMembers7d(); }
    @Override public int selectTodaySales()     { return dao.selectTodaySales(); }
    @Override public int selectPendingOrders()  { return dao.selectPendingOrders(); }
    @Override public int selectPendingRefunds() { return dao.selectPendingRefunds(); }

    // ✅ 추가
    @Override public int selectTotalMembers()   { return dao.selectTotalMembers(); }
    @Override public int selectInactiveMembers(){ return dao.selectInactiveMembers(); }
    @Override public int selectNewMembersToday() { return dao.selectNewMembersToday(); }
    @Override public int selectNewMembersYesterday() { return dao.selectNewMembersYesterday(); }

    // 상품 요약
    @Override public int selectTotalProducts() { return dao.selectTotalProducts(); }
    @Override public int selectOnSaleProducts() { return dao.selectOnSaleProducts(); }
    @Override public int selectHiddenProducts() { return dao.selectHiddenProducts(); }

    // 결제 요약
    @Override public int selectPayPendingCount() { return dao.selectPayPendingCount(); }
    @Override public int selectPayPaidCount() { return dao.selectPayPaidCount(); }
    @Override public int selectPayRefundCount() { return dao.selectPayRefundCount(); }

    @Override public List<AdminPaymentVO> selectRecentPayments(int limit) { return dao.selectRecentPayments(limit); }
    
    // ===== 게시판관리(대시보드 요약) =====

    @Override public int selectBoardQnaCount() {// 서비스의 존재이유: 컨트롤러는 "화면 로직", 서비스는 "업무 로직/데이터 호출"을 맡아 분리
    		  return dao.selectBoardQnaCount();    }

    @Override public int selectBoardReviewCount() {return dao.selectBoardReviewCount();}
    @Override public int selectBoardUnansweredCount() {return dao.selectBoardUnansweredCount();}


}
