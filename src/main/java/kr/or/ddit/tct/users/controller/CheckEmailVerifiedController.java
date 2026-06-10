package kr.or.ddit.tct.users.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import com.google.gson.Gson;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import kr.or.ddit.tct.util.MyBatisUtil;

@WebServlet("/email/checkVerified.do")
public class CheckEmailVerifiedController extends HttpServlet {
  private static final long serialVersionUID = 1L;
  private final Gson gson = new Gson();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    resp.setContentType("application/json;charset=UTF-8");

    String email = trim(req.getParameter("email"));
    int cnt = 0;

    if (!email.isEmpty()) {
      try (SqlSession session = MyBatisUtil.getSqlSession()) {
        Integer n = session.selectOne("emailVerify.isEmailVerified", email);
        cnt = (n == null) ? 0 : n;
      }
    }

    Map<String, Object> out = new HashMap<>();
    out.put("verified", cnt > 0);
    resp.getWriter().write(gson.toJson(out));
  }

  private String trim(String s) { return (s == null) ? "" : s.trim(); }
}
