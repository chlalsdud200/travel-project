package kr.or.ddit.tct.admin.stats.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/stats/sales.do")
public class SalesMonthlyController extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    // JSP 경로는 지현님 프로젝트에 맞게 조정하세요.
    req.getRequestDispatcher("/WEB-INF/views/admin/adminSalesStats.jsp")
       .forward(req, resp);
  }
}
