package kr.or.ddit.tct.admin.payments.service;

import java.util.List;
import kr.or.ddit.tct.admin.payments.vo.AdminPaymentVO;

public interface IAdminPaymentService {
    List<AdminPaymentVO> selectAdminPaymentList(String status, String from, String to, int offset, int limit);
    int countAdminPaymentList(String status, String from, String to);
}
