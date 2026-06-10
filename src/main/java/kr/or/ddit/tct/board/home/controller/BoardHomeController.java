package kr.or.ddit.tct.board.home.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/board.do")
public class BoardHomeController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    // 직독직해: /board.do 는 "게시판 메인(board.jsp)"로 보낸다.
    req.getRequestDispatcher("/WEB-INF/views/board/board.jsp").forward(req, resp);
  }
}
