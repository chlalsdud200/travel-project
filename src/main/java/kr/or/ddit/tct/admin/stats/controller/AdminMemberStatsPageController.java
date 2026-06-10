package kr.or.ddit.tct.admin.stats.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/*
  AdminMemberStatsPageController

  역할
  - 화면(JSP)을 열어주는 페이지 컨트롤러 역할 수행
  - DB 조회/JSON 응답 역할이 아니라, JSP forward 역할만 수행

  URL 매핑
  - @WebServlet("/admin/stats/members.do")
  - 브라우저에서 해당 URL로 접근하면 doGet이 실행됨
*/
@WebServlet("/admin/stats/members.do")
public class AdminMemberStatsPageController extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    /*
      req.getRequestDispatcher(...).forward(...)
      - forward는 서버 내부에서 JSP로 요청을 넘기는 동작
      - 브라우저 주소는 그대로 유지됨
    */
    req.getRequestDispatcher("/WEB-INF/views/admin/adminMemberStats.jsp")
       .forward(req, resp);
  }
}
