package kr.or.ddit.tct.board.review.controller;

import java.io.IOException;                  // : forward 과정에서 IO 예외가 발생할 수 있음

import jakarta.servlet.ServletException;     // : 서블릿 처리 중 예외
import jakarta.servlet.annotation.WebServlet; // : URL 매핑 어노테이션
import jakarta.servlet.http.HttpServlet;     // : HttpServlet 상속
import jakarta.servlet.http.HttpServletRequest;  // : 요청 객체
import jakarta.servlet.http.HttpServletResponse; // : 응답 객체

/**
 * 리뷰 목록 fragment(조각) 화면만 내려주는 컨트롤러
 * 
 * [핵심]
 * - QNA 목록과 동일하게, "fragment JSP(틀)"만 forward 한다.
 * - 실제 목록 데이터/페이징은 JS(boardreview.js)가 /board/reviewData.do(JSON)로 받아서 그린다.
 * 
 * 이유)
 * - 프로젝트에 PageVO, PageUtil.getPageInfo()가 없어서 서버에서 JSP로 페이징을 만들 수 없음
 * - 이미 ReviewDataController가 JSON + pglist(HTML)까지 만들어주는 구조가 있으니 그걸 그대로 쓴다
 */
@WebServlet("/boardReviewFrag.do")
public class BoardReviewFragController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    // : 오른쪽(#content)에 끼워 넣을 fragment JSP로 forward
    req.getRequestDispatcher("/WEB-INF/views/board/board_review_frag.jsp").forward(req, resp);
  }
}
