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

@WebServlet("/board/reviewEditData.do")
public class ReviewEditDataController extends HttpServlet {

	  private final IReviewService service = ReviewServiceImpl.getInstance();
	  private final Gson gson = new Gson();

	  private String getLoginUserId(HttpServletRequest req) {
	    Object v = req.getSession().getAttribute("loginUser");
	    if (v == null) return null;
	    kr.or.ddit.tct.users.vo.UserVO u = (kr.or.ddit.tct.users.vo.UserVO) v;
	    return u.getUserId();
	  }
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
  resp.setContentType("application/json; charset=UTF-8");

  Map<String,Object> result = new HashMap<>();

  String loginId = getLoginUserId(req);
  if (loginId == null) {
    result.put("success", false);
    result.put("msg", "로그인이 필요합니다.");
    resp.getWriter().write(gson.toJson(result));
    return;
  }

  int reviewNo = Integer.parseInt(req.getParameter("reviewNo"));

  if (!service.canEdit(reviewNo, loginId)) {
    result.put("success", false);
    result.put("msg", "작성자만 수정할 수 있습니다.");
    resp.getWriter().write(gson.toJson(result));
    return;
  }

  // 조회수는 올리면 안됨 → increaseHit=false
  ReviewBoardVO vo = service.selectReviewView(reviewNo, false);

  result.put("success", true);
  result.put("vo", vo);
  resp.getWriter().write(gson.toJson(result));  
  }
}
