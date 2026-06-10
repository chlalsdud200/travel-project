package kr.or.ddit.tct.board.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.users.vo.UserVO;


// 글 작성 화면
@WebServlet("/boardQnaWriteFrag.do")
public class BoardQnaWriteFragController extends HttpServlet {

  private static final long serialVersionUID = 1L;

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    // 로그인한 회원만 글쓰기 가능
    UserVO loginUser = (UserVO) req.getSession().getAttribute("loginUser");
    if (loginUser == null) {
      resp.sendRedirect(req.getContextPath() + "/login.do");
      return;
    }

    req.getRequestDispatcher("/WEB-INF/views/board/board_qna_write_frag.jsp").forward(req, resp);
  }
}
