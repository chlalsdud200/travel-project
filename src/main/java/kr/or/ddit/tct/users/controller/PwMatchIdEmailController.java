package kr.or.ddit.tct.users.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import com.google.gson.Gson;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.util.MyBatisUtil;

@WebServlet("/pw/matchIdEmail.do")
public class PwMatchIdEmailController extends HttpServlet {
  private static final long serialVersionUID = 1L;
  private final Gson gson = new Gson();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    resp.setContentType("application/json;charset=UTF-8");

    String userId = trim(req.getParameter("userId"));
    String userEmail = trim(req.getParameter("userEmail"));

    Map<String, Object> out = new HashMap<>();

    if (userId.isEmpty() || userEmail.isEmpty()) {
      out.put("ok", false);
      out.put("msg", "아이디/이메일을 입력하세요.");
      resp.getWriter().write(gson.toJson(out));
      return;
    }

    int cnt = 0;
    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      Map<String, Object> p = new HashMap<>();
      p.put("userId", userId);
      p.put("userEmail", userEmail);

      Integer n = session.selectOne("users.matchUserIdEmail", p);
      cnt = (n == null) ? 0 : n;
    } catch (Exception e) {
      e.printStackTrace();
    }

    if (cnt > 0) {
      out.put("ok", true);
      out.put("msg", "일치 확인");
    } else {
      out.put("ok", false);
      out.put("msg", "아이디/이메일이 일치하지 않습니다.");
    }

    resp.getWriter().write(gson.toJson(out));
  }

  private String trim(String s) { return (s == null) ? "" : s.trim(); }
}
