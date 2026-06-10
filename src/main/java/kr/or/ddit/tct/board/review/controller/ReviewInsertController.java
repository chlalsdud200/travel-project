package kr.or.ddit.tct.board.review.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.board.review.service.IReviewService;
import kr.or.ddit.tct.board.review.service.ReviewServiceImpl;
import kr.or.ddit.tct.board.review.vo.ReviewBoardVO;
import kr.or.ddit.tct.users.vo.UserVO;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;

/**
 * Servlet implementation class ReviewWriteController
 */
@WebServlet("/board/reviewInsert.do")
public class ReviewInsertController extends HttpServlet {
	
	 private final IReviewService service = ReviewServiceImpl.getInstance();
	    private final Gson gson = new Gson();

	    private String getLoginUserId(HttpServletRequest req) {
	        Object v = req.getSession().getAttribute("loginUser");
	        if (v == null) return null;
	        return ((kr.or.ddit.tct.users.vo.UserVO) v).getUserId();
	    }
	 
	 // ✅ JSON 요청 바디용 DTO
	    static class InsertReq {
	        String orderNo;
	        Integer reviewRating;
	        String reviewTitle;
	        String reviewCtt;
	    }
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
        resp.setContentType("application/json; charset=UTF-8");
        Map<String, Object> result = new HashMap<>();

        // 1) 로그인 체크
        String userId = getLoginUserId(req);
        if (userId == null) {
            result.put("success", false);
            result.put("msg", "로그인이 필요합니다.");
            resp.getWriter().write(gson.toJson(result));
            return;
        }

        // 2) JSON 파싱
        InsertReq body = gson.fromJson(req.getReader(), InsertReq.class);

        if (body == null || body.orderNo == null || body.orderNo.trim().isEmpty()) {
            result.put("success", false);
            result.put("msg", "주문번호가 올바르지 않습니다.");
            resp.getWriter().write(gson.toJson(result));
            return;
        }

        // 3) 결제완료 주문 + 내 주문 + 리뷰없음 최종 검증
        if (!service.canWriteReview(userId, body.orderNo)) {
            result.put("success", false);
            result.put("msg", "결제완료된 본인 주문만 리뷰 작성이 가능하거나, 이미 리뷰를 작성한 주문입니다.");
            resp.getWriter().write(gson.toJson(result));
            return;
        }

        // 4) VO 생성
        ReviewBoardVO vo = new ReviewBoardVO();
        vo.setUserId(userId);
        vo.setOrderNo(body.orderNo);
        vo.setReviewTitle(body.reviewTitle == null ? "" : body.reviewTitle.trim());
        vo.setReviewCtt(body.reviewCtt == null ? "" : body.reviewCtt.trim());
        vo.setReviewRating(body.reviewRating == null ? 5 : body.reviewRating);

        // 5) 등록
        int cnt = service.insertReview(vo);

        result.put("success", cnt > 0);
        result.put("msg", cnt > 0 ? "등록 완료" : "등록 실패");

        // 서비스에서 reviewNo 채번해 vo에 세팅해두면 같이 내려줄 수 있음
        result.put("reviewNo", vo.getReviewNo());

        resp.getWriter().write(gson.toJson(result));	
	
	}
}
