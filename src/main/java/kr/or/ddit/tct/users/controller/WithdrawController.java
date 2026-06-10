package kr.or.ddit.tct.users.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.tct.users.service.IUserService;
import kr.or.ddit.tct.users.service.UserServiceImpl;
import kr.or.ddit.tct.users.vo.UserVO;

@WebServlet("/withdraw.do")
public class WithdrawController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final IUserService service = UserServiceImpl.getService();

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");

		HttpSession session = req.getSession(false);
		UserVO loginUser = (session == null) ? null : (UserVO) session.getAttribute("loginUser");

		if (loginUser == null) {
			resp.sendRedirect(req.getContextPath() + "/login.do");
			return;
		}

		String userId = loginUser.getUserId();
		String currentPass = trim(req.getParameter("currentPass"));

		if (currentPass.isEmpty()) {
			resp.sendRedirect(req.getContextPath() + "/mypage.do#profile?msg=withdraw_pw_required");
			return;
		}

		int cnt = service.withdrawUser(userId, currentPass);

		if (cnt > 0) {
			// 로그아웃 처리
			session.invalidate();
			resp.sendRedirect(req.getContextPath() + "/mainPage.do?msg=withdraw_ok");
		} else {
			resp.sendRedirect(req.getContextPath() + "/mypage.do#profile?msg=withdraw_fail");
		}
	}

	private String trim(String s) {
		return (s == null) ? "" : s.trim();
	}
}
