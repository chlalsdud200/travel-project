package kr.or.ddit.tct.users.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import kr.or.ddit.tct.users.service.IUserService;
import kr.or.ddit.tct.users.service.UserServiceImpl;

@WebServlet("/pw/sendCode.do")
public class PwSendCodeController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  private final Gson gson = new Gson();
  private final IUserService service = UserServiceImpl.getService();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    resp.setContentType("application/json;charset=UTF-8");

    String userEmail = trim(req.getParameter("userEmail"));
    String code = trim(req.getParameter("code")); // JS가 만든 6자리 코드

    Map<String, Object> out = new HashMap<>();

    if (userEmail.isEmpty() || code.isEmpty()) {
      out.put("ok", false);
      out.put("msg", "이메일/코드를 확인하세요.");
      resp.getWriter().write(gson.toJson(out));
      return;
    }

    // 가입된 이메일인지
    int cnt = service.countUserByEmail(userEmail);
    if (cnt == 0) {
      out.put("ok", false);
      out.put("msg", "가입된 이메일이 아닙니다.");
      resp.getWriter().write(gson.toJson(out));
      return;
    }

    // 세션 저장 + 3분 만료
    HttpSession session = req.getSession();
    session.setAttribute("PW_EMAIL", userEmail);
    session.setAttribute("PW_CODE", code);
    session.setAttribute("PW_EXP", System.currentTimeMillis() + (3 * 60 * 1000L));
    session.setAttribute("PW_VERIFIED", false);

    out.put("ok", true);
    out.put("msg", "인증코드를 발송했습니다. (3분 제한)");
    resp.getWriter().write(gson.toJson(out));
  }

  private String trim(String s) { return (s == null) ? "" : s.trim(); }
}
