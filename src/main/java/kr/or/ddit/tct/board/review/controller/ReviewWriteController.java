package kr.or.ddit.tct.board.review.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/board/reviewWrite.do")
public class ReviewWriteController extends HttpServlet {

  private boolean isLoggedIn(HttpServletRequest req) {
    HttpSession session = req.getSession(false);
    return session != null && session.getAttribute("loginUser") != null;
  }

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    if (!isLoggedIn(req)) {
      HttpSession session = req.getSession(true);
      session.setAttribute("RETURN_URL", req.getContextPath() + "/reviewWrite.do");
      resp.sendRedirect(req.getContextPath() + "/login.do");
      return;
    }

    req.getRequestDispatcher("/WEB-INF/views/board/reviewWrite.jsp")
       .forward(req, resp);
  }
}
