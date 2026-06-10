package kr.or.ddit.tct.sales.payment.dao;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.sales.payment.vo.CancelableInfoVO;

public interface IpaymentDao {
	public int updateCancelByOrderNo(String orderNo, String userId, String reason);

	CancelableInfoVO selectCancelableInfo(SqlSession session, String orderNo, String userId);

	int updatePaymentCanceled(SqlSession session, String orderNo, String reason);

	int updateOrderCanceled(SqlSession session, String orderNo);

	int insertRefund(SqlSession session, int payNo, int refundAmount, String reason);
}
