package kr.or.ddit.tct.admin.payments.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.admin.payments.vo.AdminPaymentSearchVO;
import kr.or.ddit.tct.admin.payments.vo.AdminPaymentVO;
import kr.or.ddit.tct.util.MyBatisUtil;

public class AdminPaymentDaoImpl implements IAdminPaymentDao {

    private static final IAdminPaymentDao instance = new AdminPaymentDaoImpl();

    private AdminPaymentDaoImpl() {}

    public static IAdminPaymentDao getInstance() {
        return instance;
    }

    @Override
    public List<AdminPaymentVO> selectAdminPaymentList(String status, String from, String to, int offset, int limit) {
        AdminPaymentSearchVO s = new AdminPaymentSearchVO(status, from, to, offset, limit);

        try (SqlSession session = MyBatisUtil.getSqlSession()) {
            return session.selectList("payment.selectAdminPaymentList", s);
        }
    }

    @Override
    public int countAdminPaymentList(String status, String from, String to) {
        AdminPaymentSearchVO s = new AdminPaymentSearchVO(status, from, to, 0, 0);

        try (SqlSession session = MyBatisUtil.getSqlSession()) {
            Integer cnt = session.selectOne("payment.countAdminPaymentList", s);
            return (cnt == null) ? 0 : cnt;
        }
    }
}
