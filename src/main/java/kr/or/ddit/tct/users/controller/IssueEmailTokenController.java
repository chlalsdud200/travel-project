package kr.or.ddit.tct.users.controller;

import java.io.IOException;
import java.util.*;

import org.apache.ibatis.session.SqlSession;

import com.google.gson.Gson;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import kr.or.ddit.tct.util.MyBatisUtil;

@WebServlet("/email/issueToken.do")
public class IssueEmailTokenController extends HttpServlet {
  private static final long serialVersionUID = 1L;
  private final Gson gson = new Gson();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    resp.setContentType("application/json;charset=UTF-8");

    String email = trim(req.getParameter("email"));
    Map<String, Object> out = new HashMap<>();

    if (email.isEmpty() || !email.contains("@")) {
      out.put("success", false);
      out.put("message", "이메일을 올바르게 입력하세요.");
      resp.getWriter().write(gson.toJson(out));
      return;
    }

    String token = UUID.randomUUID().toString().replace("-", "");
    Date expiresAt = new Date(System.currentTimeMillis() + 30L * 60 * 1000); // 30분

    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      Map<String, Object> param = new HashMap<>();
      param.put("token", token);
      param.put("email", email);
      param.put("expiresAt", expiresAt);

      session.insert("emailVerify.insertToken", param);
      session.commit();
    }

    String baseUrl = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + req.getContextPath();
    String verifyLink = baseUrl + "/email/confirm.do?token=" + token;

    out.put("success", true);
    out.put("verifyLink", verifyLink);
    out.put("expiresMinutes", 30);

    resp.getWriter().write(gson.toJson(out));
  }

  private String trim(String s) { return (s == null) ? "" : s.trim(); }
}
