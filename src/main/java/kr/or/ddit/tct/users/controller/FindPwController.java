package kr.or.ddit.tct.users.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/findPw.do")
public class FindPwController extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    try {
      req.getRequestDispatcher("/WEB-INF/views/pwFind.jsp").forward(req, resp);
    } catch (Exception e) {
      e.printStackTrace();
      resp.sendError(500);
    }
  }
}
