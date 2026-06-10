package kr.or.ddit.tct.board.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// 문의글 목록 화면
@WebServlet("/boardQnaFrag.do")
public class BoardQnaFragController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	  req.getRequestDispatcher("/WEB-INF/views/board/board_qna_frag.jsp").forward(req, resp);

  }
}
