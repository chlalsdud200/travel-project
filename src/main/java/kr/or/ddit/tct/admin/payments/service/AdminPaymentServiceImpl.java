package kr.or.ddit.tct.admin.payments.service;

import java.util.List;

import kr.or.ddit.tct.admin.payments.dao.AdminPaymentDaoImpl;
import kr.or.ddit.tct.admin.payments.dao.IAdminPaymentDao;
import kr.or.ddit.tct.admin.payments.vo.AdminPaymentVO;

public class AdminPaymentServiceImpl implements IAdminPaymentService {

    private static final IAdminPaymentService instance = new AdminPaymentServiceImpl();
    private final IAdminPaymentDao dao = AdminPaymentDaoImpl.getInstance();

    private AdminPaymentServiceImpl() {}

    public static IAdminPaymentService getInstance() {
        return instance;
    }

    @Override
    public List<AdminPaymentVO> selectAdminPaymentList(String status, String from, String to, int offset, int limit) {
        return dao.selectAdminPaymentList(status, from, to, offset, limit);
    }

    @Override
    public int countAdminPaymentList(String status, String from, String to) {
        return dao.countAdminPaymentList(status, from, to);
    }
}
