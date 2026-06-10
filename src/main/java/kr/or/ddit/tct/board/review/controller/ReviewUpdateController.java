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

@WebServlet("/board/reviewUpdate.do")
public class ReviewUpdateController extends HttpServlet {
	  private final IReviewService service = ReviewServiceImpl.getInstance();
	  private final Gson gson = new Gson();

	  private String getLoginUserId(HttpServletRequest req) {
	    Object v = req.getSession().getAttribute("loginUser");
	    if (v == null) return null;
	    kr.or.ddit.tct.users.vo.UserVO u = (kr.or.ddit.tct.users.vo.UserVO) v;
	    return u.getUserId();
	  }

	  static class UpdateReq {
	    Integer reviewNo;
	    Integer reviewRating;
	    String reviewTitle;
	    String reviewCtt;
	  }
	  
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	  resp.setContentType("application/json; charset=UTF-8");
	  
	    Map<String,Object> result = new HashMap<>();
	    String userId = getLoginUserId(req);
	    if (userId == null) {
	      result.put("success", false);
	      result.put("msg", "로그인이 필요합니다.");
	      resp.getWriter().write(gson.toJson(result));
	      return;
	    }

	    UpdateReq body = gson.fromJson(req.getReader(), UpdateReq.class);
	    if (body == null || body.reviewNo == null) {
	      result.put("success", false);
	      result.put("msg", "reviewNo가 없습니다.");
	      resp.getWriter().write(gson.toJson(result));
	      return;
	    }

	    ReviewBoardVO vo = new ReviewBoardVO();
	    vo.setReviewNo(body.reviewNo);
	    vo.setUserId(userId); // ✅ 작성자 체크용
	    vo.setReviewRating(body.reviewRating == null ? 5 : body.reviewRating);
	    vo.setReviewTitle(body.reviewTitle == null ? "" : body.reviewTitle.trim());
	    vo.setReviewCtt(body.reviewCtt == null ? "" : body.reviewCtt.trim());

	    int cnt = service.updateReview(vo);

	    result.put("success", cnt > 0);
	    result.put("msg", cnt > 0 ? "수정 완료" : "수정 실패(작성자만 가능)");
	    resp.getWriter().write(gson.toJson(result));
  }
}
