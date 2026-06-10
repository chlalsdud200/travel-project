package kr.or.ddit.tct.users.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.util.MyBatisUtil;

@WebServlet("/email/confirm.do")
public class ConfirmEmailController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    String token = trim(req.getParameter("token"));
    boolean ok = false;

    if (!token.isEmpty()) {
      try (SqlSession session = MyBatisUtil.getSqlSession()) {

        Map<String, Object> row = session.selectOne("emailVerify.selectValidToken", token);

        if (row != null) {
          // ✅ Map 키 대소문자/alias 차이를 흡수
          String email = (String) row.get("email");
          if (email == null) email = (String) row.get("EMAIL");

          email = trim(email);

          // ✅ email이 없으면 여기서 실패 처리(=ok=false)
          if (!email.isEmpty()) {
            // 1) 토큰 사용 처리
            session.update("emailVerify.markTokenUsed", token);

            // 2) EMAIL_VERIFIED upsert 시 TOKEN도 같이 넣기 (해결책 B)
            Map<String, Object> param = new HashMap<>();
            param.put("email", email);
            param.put("token", token);

            session.insert("emailVerify.mergeVerifiedEmail", param);

            session.commit();
            ok = true;
          }
        }
      }
    }

    req.setAttribute("ok", ok);
    req.getRequestDispatcher("/WEB-INF/views/email_confirm.jsp").forward(req, resp);
  }

  private String trim(String s) {
    return (s == null) ? "" : s.trim();
  }
}
