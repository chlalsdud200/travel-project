package kr.or.ddit.tct.sales.payment.service;

// *의도적인 DAO계층 생략
// 1. 트랜잭션 제어 - 복합키에 인서트해야하기 때문에 복합키 각각의 요소 인서트 간격이 길어지면 트랜잭션에 리스크
// 2. 작업이 너무 간단,단순해서 DAO의 의미 퇴색
// 3. 가독성 효율
public interface IPaymentService {
	    String createPendingOrder(String userId, String regId, int qty, int clientAmount);
	    boolean cancelPayment(String orderNo, String userId, String reason);
}
