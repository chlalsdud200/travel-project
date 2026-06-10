package kr.or.ddit.tct.sales.payment.controller;

import java.io.BufferedReader;
import java.io.IOException;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.tct.sales.payment.service.IPaymentService;
import kr.or.ddit.tct.sales.payment.service.PaymentServiceImpl;
import kr.or.ddit.tct.users.vo.UserVO;

@WebServlet("/paymentCancel.do")
public class PaymentCancel extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private final IPaymentService service = PaymentServiceImpl.getInstance();
	private final Gson gson = new Gson();
	
	static class CancelReq{
		String orderNo;
		String reason;
	}
	
	 static class CancelResp {
		    boolean ok;
		    String message;
		    
		    CancelResp(boolean ok, String message){ 
		    	this.ok=ok; 
		    	this.message=message; 
		    }
		    
		    static CancelResp ok(){ 
		    	return new CancelResp(true, null); 
		    }
		    
		    static CancelResp fail(String msg){
		    	return new CancelResp(false, msg); 
		    }
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		resp.setContentType("application/json;charset=UTF-8");
		
		// 로그인 체크
		HttpSession session = req.getSession(false);
		UserVO loginUser = (session == null)? null : (UserVO) session.getAttribute("loginUser");
		if(loginUser == null) {
			resp.getWriter().write(gson.toJson(CancelResp.fail("로그인이 필요합니다.")));
		return;
		}
		
	    String userId = loginUser.getUserId();
		
		// JSON body 읽기
		StringBuilder sb = new StringBuilder();
		try(BufferedReader br = req.getReader()){
			String line;
			while((line = br.readLine()) != null) sb.append(line);
		}
		
		CancelReq creq = null;
		try {
			creq = gson.fromJson(sb.toString(), CancelReq.class);
		} catch (Exception e) {
		    resp.getWriter().write(gson.toJson(CancelResp.fail("요청 JSON이 올바르지 않습니다.")));
			return;
		}
		
	    String orderNo = (creq == null) ? null : creq.orderNo;
	    String reason  = (creq == null) ? null : creq.reason;
	    
	    if (orderNo == null || orderNo.isBlank()) {
	        resp.getWriter().write(gson.toJson(CancelResp.fail("orderNo가 없습니다")));
	        return;
        }
	    if(reason == null || reason.isBlank()) reason = "사용자 요청";

	    // 트랜잭션 취소 처리
	    try {
	        boolean ok = service.cancelPayment(orderNo, loginUser.getUserId(), reason); // userId getter는 네 VO에 맞게
	        if (ok) {
	          resp.getWriter().write(gson.toJson(CancelResp.ok()));
	        } else {
	          resp.getWriter().write(gson.toJson(CancelResp.fail("취소할 수 없는 상태입니다")));
	        }
	      } catch (Exception e) {
	        e.printStackTrace();
	        resp.getWriter().write(gson.toJson(CancelResp.fail("서버오류")));
	      }
	    
	}
	
}
