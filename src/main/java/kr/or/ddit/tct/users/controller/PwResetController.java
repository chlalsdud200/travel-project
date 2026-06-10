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

@WebServlet("/pw/resetPw.do")
public class PwResetController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  private final Gson gson = new Gson();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    resp.setContentType("application/json;charset=UTF-8");

    String userId = trim(req.getParameter("userId"));
    String userEmail = trim(req.getParameter("userEmail"));
    String newPw = trim(req.getParameter("newPw"));

    Map<String, Object> out = new HashMap<>();

    if (userId.isEmpty() || userEmail.isEmpty() || newPw.isEmpty()) {
      out.put("ok", false);
      out.put("msg", "아이디/이메일/새 비밀번호를 확인하세요.");
      resp.getWriter().write(gson.toJson(out));
      return;
    }

    int cnt = 0;

    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      Map<String, Object> p = new HashMap<>();
      p.put("userId", userId);
      p.put("userEmail", userEmail);
      p.put("newPw", newPw);

      cnt = session.update("users.updateUserPwByIdEmail", p);
      session.commit();
    } catch (Exception e) {
      e.printStackTrace();
    }

    if (cnt > 0) {
      out.put("ok", true);
      out.put("msg", "비밀번호가 변경되었습니다.");
    } else {
      out.put("ok", false);
      out.put("msg", "비밀번호 변경 실패(아이디/이메일 불일치 가능)");
    }

    resp.getWriter().write(gson.toJson(out));
  }

  private String trim(String s) { return (s == null) ? "" : s.trim(); }
}
