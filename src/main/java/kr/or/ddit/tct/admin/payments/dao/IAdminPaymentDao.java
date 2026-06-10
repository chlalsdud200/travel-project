package kr.or.ddit.tct.admin.payments.dao;

import java.util.List;
import kr.or.ddit.tct.admin.payments.vo.AdminPaymentVO;

public interface IAdminPaymentDao {
    List<AdminPaymentVO> selectAdminPaymentList(String status, String from, String to, int offset, int limit);
    int countAdminPaymentList(String status, String from, String to);
}
