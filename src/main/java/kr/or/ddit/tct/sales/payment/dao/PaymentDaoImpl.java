package kr.or.ddit.tct.sales.payment.dao;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.sales.payment.vo.CancelableInfoVO;
import kr.or.ddit.tct.util.MyBatisUtil;
import lombok.Data;

@Data
public class PaymentDaoImpl implements IpaymentDao{
	private static IpaymentDao dao = new PaymentDaoImpl();
	private PaymentDaoImpl() {
		
	}
	
	public static IpaymentDao getInstance() {
		if(dao==null) dao = new PaymentDaoImpl(); 
		return dao;
	}

	@Override
	public int updateCancelByOrderNo(String orderNO, String userId, String reason) {
		SqlSession session = MyBatisUtil.getSqlSession();
		
		try {
			Map<String , Object> p = new HashMap<>();
			p.put("orderNO", orderNO);
			p.put("userId", userId);
			p.put("reaseon", reason);
			
			session.commit();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			session.close();
		}
		return 0;
	}

	@Override
	public CancelableInfoVO selectCancelableInfo(SqlSession session, String orderNo, String userId) {
		Map<String, Object> p = new HashMap<>();
	    p.put("orderNo", orderNo);
	    p.put("userId", userId);
	    return session.selectOne("payment.selectCancelableInfo", p);
	}

	@Override
	public int updatePaymentCanceled(SqlSession session, String orderNo, String reason) {
		Map<String, Object> p = new HashMap<>();
	    p.put("orderNo", orderNo);
	    p.put("reason", reason);
	    return session.update("payment.updatePaymentCanceled", p);
	}

	@Override
	public int updateOrderCanceled(SqlSession session, String orderNo) {
	    return session.update("payment.updateOrderCanceled", orderNo);
	}

	@Override
	public int insertRefund(SqlSession session, int payNo, int refundAmount, String reason) {
		Map<String, Object> p = new HashMap<>();
	    p.put("payNo", payNo);
	    p.put("refundAmount", refundAmount);
	    p.put("reason", reason);
	    return session.insert("payment.insertRefund", p);
	}

	

}


