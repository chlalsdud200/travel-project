package kr.or.ddit.tct.sales.payment.service;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.sales.payment.dao.IpaymentDao;
import kr.or.ddit.tct.sales.payment.dao.PaymentDaoImpl;
import kr.or.ddit.tct.sales.payment.vo.CancelableInfoVO;
import kr.or.ddit.tct.util.MyBatisUtil;
import lombok.Data;
import lombok.NoArgsConstructor;

//*의도적인 DAO계층 생략
//1. 트랜잭션 제어 - 복합키에 인서트해야하기 때문에 복합키 각각의 요소 인서트 간격이 길어지면 트랜잭션에 리스크
//2. 작업이 너무 간단,단순해서 DAO의 의미 퇴색
//3. 가독성 효율

@NoArgsConstructor
@Data
public class PaymentServiceImpl implements IPaymentService{

    private static IPaymentService service = new PaymentServiceImpl();
    public static IPaymentService getInstance() { return service; }

    private IpaymentDao dao = PaymentDaoImpl.getInstance();
	
	@Override
	public String createPendingOrder(String userId, String regId, int qty, int clientAmount) {
		 // ✅ ORDER_NO = merchant_uid (VARCHAR2(20)로 바꿨다 했으니 이 방식 OK)
        String orderNo = "TCT_" + System.currentTimeMillis(); // 4 + 13 = 17자

        try (SqlSession sql = MyBatisUtil.getSqlSession()) {

            // 1) 서버에서 단가 조회 (조작 방지)
            Integer unitPrice = sql.selectOne("payment.selectUnitPriceByRegId", regId);
            if (unitPrice == null) {
                throw new RuntimeException("상품 가격을 찾을 수 없습니다.");
            }

            int itemTotal = unitPrice * qty;

            // 2) 금액 검증 (프론트 조작 방지)
            if (itemTotal != clientAmount) {
                throw new RuntimeException("결제 금액이 일치하지 않습니다.");
            }

            // 3) ORDERS insert
            Map<String, Object> p1 = new HashMap<>();
            p1.put("orderNo", orderNo);
            p1.put("userId", userId);
            p1.put("totalPrice", itemTotal);
            p1.put("status", "PENDING");

            int a = sql.insert("payment.insertOrders", p1);

            // 4) ORDER_ITEM insert
            Map<String, Object> p2 = new HashMap<>();
            p2.put("orderNo", orderNo);
            p2.put("regId", regId);
            p2.put("qty", qty);
            p2.put("unitPrice", unitPrice);
            p2.put("itemTotal", itemTotal);

            int b = sql.insert("payment.insertOrderItem", p2);

            if (a != 1 || b != 1) {
                throw new RuntimeException("주문 생성에 실패했습니다.");
            }

            sql.commit();
            return orderNo;

        } catch (RuntimeException e) {
            // try-with-resources라 close는 자동. commit 안 했으니 rollback 효과.
            throw e;
        } catch (Exception e) {
            throw new RuntimeException("주문 생성 중 오류가 발생했습니다.", e);
        }
	}


	@Override
	 public boolean cancelPayment(String orderNo, String userId, String reason) {
	    SqlSession session = MyBatisUtil.getSqlSession(false); // ✅ autoCommit=false 로 열기 (util에 맞게)
	    try {
	      // 1) 본인 주문 + 결제상태 PAID인지 검증 (orders 기준 소유자 체크)
	      CancelableInfoVO info = dao.selectCancelableInfo(session, orderNo, userId);
	      if (info == null) return false;

	      // 결제상태/주문상태 정책 (너희 상태값에 맞게)
	      if (!"PAID".equals(info.getPayStatus())) return false;

	      // 2) PAYMENT 취소
	      int p = dao.updatePaymentCanceled(session, orderNo, reason);

	      // 3) ORDERS 상태 취소(너희 컬럼명/상태값 맞추기)
	      int o = dao.updateOrderCanceled(session, orderNo);

	      // 4) REFUND 기록 남기기 (프로젝트 정책: 요청/완료)
	      //    - 금액은 payment.pay_amount 또는 orders.total_price 사용
	      int r = dao.insertRefund(session, info.getPayNO(), info.getPayAmount(), reason);

	      if (p == 1 && o == 1 && r == 1) {
	      session.commit();
	        return true;
	      } else {
	      session.rollback();
	        return false;
	      }
	    } catch (Exception e) {
	    session.rollback();
	      throw e;
	    } finally {
	   	session.close();
	    }
	}

}
