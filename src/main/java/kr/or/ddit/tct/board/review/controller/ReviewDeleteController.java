package kr.or.ddit.tct.board.review.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.tct.board.review.service.IReviewService;
import kr.or.ddit.tct.board.review.service.ReviewServiceImpl;
import kr.or.ddit.tct.board.review.vo.ReviewBoardVO;
import kr.or.ddit.tct.users.vo.UserVO;

@WebServlet("/board/reviewDelete.do")
public class ReviewDeleteController extends HttpServlet {
	  private final IReviewService service = ReviewServiceImpl.getInstance();
	  private final Gson gson = new Gson();

	  private String getLoginUserId(HttpServletRequest req) {
		  Object v = req.getSession().getAttribute("loginUser");
		  if (v == null) return null;
		  return ((UserVO)v).getUserId();
		}
	  
	  static class DeleteReq {
		    Integer reviewNo;
	  }
	  
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	  resp.setContentType("application/json; charset=UTF-8");
	  
	    Map<String,Object> result = new HashMap<>();
	    
	    // 1) 로그인 체크
	    String userId = getLoginUserId(req);
	    if (userId == null) {
	      result.put("success", false);
	      result.put("msg", "로그인이 필요합니다.");
	      resp.getWriter().write(gson.toJson(result));
	      return;
	    }

	    // 2) JSON 파싱 (✅ 먼저!)
	    DeleteReq body = gson.fromJson(req.getReader(), DeleteReq.class);
	    if (body == null || body.reviewNo == null) {
	      result.put("success", false);
	      result.put("msg", "reviewNo가 올바르지 않습니다.");
	      resp.getWriter().write(gson.toJson(result));
	      return;
	    }

	    // 3) 삭제(작성자만)
	    int cnt = service.deleteReview(body.reviewNo, userId);

	    result.put("success", cnt > 0);
	    result.put("msg", cnt > 0 ? "삭제 완료" : "삭제 실패(작성자만 가능)");

	    resp.getWriter().write(gson.toJson(result));
  }
  
}
