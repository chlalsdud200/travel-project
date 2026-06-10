package kr.or.ddit.tct.admin.members.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.admin.members.service.AdminMemberServiceImpl;
import kr.or.ddit.tct.admin.members.service.IAdminMemberService;

@WebServlet("/admin/memberWithdraw.do")
public class AdminMemberWithdrawController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final IAdminMemberService service = AdminMemberServiceImpl.getInstance();

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String userId = trim(req.getParameter("userId"));

		int cnt = service.withdrawUserAdmin(userId);

		// 검색조건 유지
		String qUserId   = trim(req.getParameter("qUserId"));
		String qUserName = trim(req.getParameter("qUserName"));
		String qRole     = trim(req.getParameter("qRole"));

		String redirectUrl = req.getContextPath() + "/admin/members.do"
				+ "?qUserId=" + enc(qUserId)
				+ "&qUserName=" + enc(qUserName)
				+ "&qRole=" + enc(qRole)
				+ "&openUserId=" + enc(userId)
				+ "&msg=" + (cnt > 0 ? "withdraw_ok" : "withdraw_fail");

		resp.sendRedirect(redirectUrl);
	}

	private String trim(String s) {
		return (s == null) ? "" : s.trim();
	}

	private String enc(String s) {
		try {
			return java.net.URLEncoder.encode(s == null ? "" : s, "UTF-8");
		} catch (Exception e) {
			return "";
		}
	}
}
