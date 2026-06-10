package kr.or.ddit.tct.board.home.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/boardHomeFrag.do")
public class BoardHomeFragController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    // 직독직해: HOME 메뉴 클릭 시, section에 끼워 넣을 fragment만 내려준다.
    req.getRequestDispatcher("/WEB-INF/views/board/board_home_frag.jsp").forward(req, resp);
  }
}
