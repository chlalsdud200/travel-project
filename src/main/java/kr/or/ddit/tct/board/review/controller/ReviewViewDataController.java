package kr.or.ddit.tct.board.review.controller; 

import java.io.IOException; 
import java.util.HashMap; // JSON 응답을 Map으로 구성하기 위해 사용
import java.util.Map; // 파라미터/응답을 Map으로 구성하기 위해 사용

import com.google.gson.Gson; // JSON 변환기

import jakarta.servlet.ServletException; // 서블릿 표준 예외
import jakarta.servlet.annotation.WebServlet; // URL 매핑을 붙이기 위해 사용
import jakarta.servlet.http.HttpServlet; // 서블릿 기반 컨트롤러
import jakarta.servlet.http.HttpServletRequest; // 요청 파라미터 접근
import jakarta.servlet.http.HttpServletResponse; // JSON 응답 작성

import kr.or.ddit.tct.board.review.service.IReviewService; // 서비스 인터페이스(계층 분리)
import kr.or.ddit.tct.board.review.service.ReviewServiceImpl; // 서비스 구현체(싱글톤)
import kr.or.ddit.tct.board.review.vo.ReviewBoardVO; // 목록에 내려줄 VO
import kr.or.ddit.tct.users.vo.UserVO;

@WebServlet("/board/reviewViewData.do")
public class ReviewViewDataController extends HttpServlet { 
	  private final IReviewService service = ReviewServiceImpl.getInstance();
	  private final Gson gson = new Gson();
	  
	  private String getLoginUserId(HttpServletRequest req) {
		    Object v = req.getSession().getAttribute("loginUser");
		    if (v == null) return null;
		    if (v instanceof UserVO) return ((UserVO) v).getUserId();
		    return v.toString(); // 혹시 String으로 넣은 케이스 방어
		  }

  @Override 
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    resp.setContentType("application/json; charset=UTF-8"); // 이 응답이 JSON이고 UTF-8이라는 걸 브라우저에 명확히 알림

    Map<String,Object> result = new HashMap<>();
    int reviewNo = 0;
    try {
      reviewNo = Integer.parseInt(req.getParameter("reviewNo"));
    } catch (Exception e) {
      result.put("success", false);
      result.put("msg", "reviewNo 파라미터가 올바르지 않습니다.");
      resp.getWriter().write(gson.toJson(result));
      return;
    }

    // 1) 상세 조회
    ReviewBoardVO vo = service.selectReviewView(reviewNo, true);
    
    if (vo == null) {
      result.put("success", false);
      result.put("msg", "리뷰가 없습니다.");
      resp.getWriter().write(gson.toJson(result));
      return;
    }

    // 2) 로그인 + 작성자 여부 체크
    String loginId = getLoginUserId(req);

    boolean loggedIn = (loginId != null);
    boolean isOwner = loggedIn && vo != null && loginId.equals(vo.getUserId());

    // ✅ 통일된 응답 키
    result.put("success", true);
    result.put("loggedIn", loggedIn);
    result.put("loginId", loginId);
    result.put("isOwner", isOwner);
    result.put("canEdit", isOwner);   // 지금은 작성자만 가능
    result.put("vo", vo);
    
    resp.getWriter().write(gson.toJson(result));
    System.out.println("loginId=" + loginId + ", writer=" + (vo==null?null:vo.getUserId()));
  }
}
