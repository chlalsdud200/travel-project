package kr.or.ddit.tct.users.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/pw/verifyCode.do")
public class PwVerifyCodeController extends HttpServlet {
	  private static final long serialVersionUID = 1L;

	  private final Gson gson = new Gson();

	  @Override
	  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
	    resp.setContentType("application/json;charset=UTF-8");

	    String userEmail = trim(req.getParameter("userEmail"));
	    String code = trim(req.getParameter("code"));

	    Map<String, Object> out = new HashMap<>();

	    HttpSession session = req.getSession(false);
	    if (session == null) {
	      out.put("ok", false);
	      out.put("msg", "인증 요청을 다시 시작하세요.");
	      resp.getWriter().write(gson.toJson(out));
	      return;
	    }

	    String sEmail = trim((String) session.getAttribute("PW_EMAIL"));
	    String sCode  = trim((String) session.getAttribute("PW_CODE"));
	    Long exp = (Long) session.getAttribute("PW_EXP");

	    if (exp == null || System.currentTimeMillis() > exp) {
	      out.put("ok", false);
	      out.put("msg", "인증 시간이 만료되었습니다. 다시 발송하세요.");
	      resp.getWriter().write(gson.toJson(out));
	      return;
	    }

	    if (!userEmail.equals(sEmail) || !code.equals(sCode)) {
	      out.put("ok", false);
	      out.put("msg", "인증코드가 일치하지 않습니다.");
	      resp.getWriter().write(gson.toJson(out));
	      return;
	    }

	    session.setAttribute("PW_VERIFIED", true);
	    out.put("ok", true);
	    out.put("msg", "인증 성공");
	    resp.getWriter().write(gson.toJson(out));
	  }

	  private String trim(String s) { return (s == null) ? "" : s.trim(); }
	}