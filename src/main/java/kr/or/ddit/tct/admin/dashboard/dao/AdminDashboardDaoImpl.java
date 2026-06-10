package kr.or.ddit.tct.admin.dashboard.dao;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;

import java.util.List;

import kr.or.ddit.tct.util.MyBatisUtil;
import kr.or.ddit.tct.admin.payments.vo.AdminPaymentSearchVO;
import kr.or.ddit.tct.admin.payments.vo.AdminPaymentVO;

public class AdminDashboardDaoImpl implements IAdminDashboardDao {

    private static final IAdminDashboardDao instance = new AdminDashboardDaoImpl();
    private AdminDashboardDaoImpl() {}
    public static IAdminDashboardDao getInstance() { return instance; }

    @Override
    public int selectNewMembers7d() {
        try (SqlSession session = MyBatisUtil.getSqlSession()) {
            Integer v = session.selectOne("dashboard.selectNewMembers7d");
            return (v == null) ? 0 : v;
        } catch (PersistenceException e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int selectTodaySales() {
        try (SqlSession session = MyBatisUtil.getSqlSession()) {
            Integer v = session.selectOne("dashboard.selectTodaySales");
            return (v == null) ? 0 : v;
        } catch (PersistenceException e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int selectPendingOrders() {
        try (SqlSession session = MyBatisUtil.getSqlSession()) {
            Integer v = session.selectOne("dashboard.selectPendingOrders");
            return (v == null) ? 0 : v;
        } catch (PersistenceException e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int selectPendingRefunds() {
        try (SqlSession session = MyBatisUtil.getSqlSession()) {
            Integer v = session.selectOne("dashboard.selectPendingRefunds");
            return (v == null) ? 0 : v;
        } catch (PersistenceException e) {
            e.printStackTrace();
            return 0;
        }
    }

    // ✅ 추가
    @Override
    public int selectTotalMembers() {
        try (SqlSession session = MyBatisUtil.getSqlSession()) {
            Integer v = session.selectOne("dashboard.selectTotalMembers");
            return (v == null) ? 0 : v;
        } catch (PersistenceException e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int selectInactiveMembers() {
        try (SqlSession session = MyBatisUtil.getSqlSession()) {
            Integer v = session.selectOne("dashboard.selectInactiveMembers");
            return (v == null) ? 0 : v;
        } catch (PersistenceException e) {
            e.printStackTrace();
            return 0;
        }
    }
    
    //전일대비기능
    @Override
    public int selectNewMembersToday() {
      try (SqlSession session = MyBatisUtil.getSqlSession()) {
        Integer v = session.selectOne("dashboard.selectNewMembersToday");
        return (v == null) ? 0 : v;
      }
    }

    @Override
    public int selectNewMembersYesterday() {
      try (SqlSession session = MyBatisUtil.getSqlSession()) {
        Integer v = session.selectOne("dashboard.selectNewMembersYesterday");
        return (v == null) ? 0 : v;
      }
    }

    // =========================
    // 상품 요약
    // =========================
    @Override
    public int selectTotalProducts() {
        try (SqlSession session = MyBatisUtil.getSqlSession()) {
            Integer v = session.selectOne("dashboard.selectTotalProducts");
            return (v == null) ? 0 : v;
        }
    }

    @Override
    public int selectOnSaleProducts() {
        try (SqlSession session = MyBatisUtil.getSqlSession()) {
            Integer v = session.selectOne("dashboard.selectOnSaleProducts");
            return (v == null) ? 0 : v;
        }
    }

    @Override
    public int selectHiddenProducts() {
        try (SqlSession session = MyBatisUtil.getSqlSession()) {
            Integer v = session.selectOne("dashboard.selectHiddenProducts");
            return (v == null) ? 0 : v;
        }
    }

    // =========================
    // 결제 요약(대시보드)
    // =========================
    @Override
    public int selectPayPendingCount() {
        try (SqlSession session = MyBatisUtil.getSqlSession()) {
            Integer v = session.selectOne("dashboard.selectPayPendingCount");
            return (v == null) ? 0 : v;
        }
    }

    @Override
    public int selectPayPaidCount() {
        try (SqlSession session = MyBatisUtil.getSqlSession()) {
            Integer v = session.selectOne("dashboard.selectPayPaidCount");
            return (v == null) ? 0 : v;
        }
    }

    @Override
    public int selectPayRefundCount() {
        try (SqlSession session = MyBatisUtil.getSqlSession()) {
            Integer v = session.selectOne("dashboard.selectPayRefundCount");
            return (v == null) ? 0 : v;
        }
    }

    @Override
    public List<AdminPaymentVO> selectRecentPayments(int limit) {
        try (SqlSession session = MyBatisUtil.getSqlSession()) {
            AdminPaymentSearchVO search = new AdminPaymentSearchVO("", "", "", 0, limit);
            return session.selectList("payment.selectAdminPaymentList", search);
        } catch (PersistenceException e) {
            e.printStackTrace();
            return java.util.Collections.emptyList();
        }
    }
    
    // ===== 게시판관리(대시보드 요약) =====

    @Override
    public int selectBoardQnaCount() {
        try (SqlSession session = MyBatisUtil.getSqlSession()) {
            // mapper(dashboard.xml)의 selectBoardQnaCount 실행 → int 1개를 받는다
            Integer v = session.selectOne("dashboard.selectBoardQnaCount");
            return (v == null) ? 0 : v; // 화면에서 0건도 정상 표시하려는 목적
        }
    }

    @Override
    public int selectBoardReviewCount() {
        try (SqlSession session = MyBatisUtil.getSqlSession()) {
            Integer v = session.selectOne("dashboard.selectBoardReviewCount");
            return (v == null) ? 0 : v;
        }
    }

    @Override
    public int selectBoardUnansweredCount() {
        try (SqlSession session = MyBatisUtil.getSqlSession()) {
            Integer v = session.selectOne("dashboard.selectBoardUnansweredCount");
            return (v == null) ? 0 : v;
        }
    }

}
