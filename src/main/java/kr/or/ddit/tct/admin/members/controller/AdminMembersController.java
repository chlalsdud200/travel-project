package kr.or.ddit.tct.admin.members.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.admin.members.service.AdminMemberServiceImpl;
import kr.or.ddit.tct.admin.members.service.IAdminMemberService;
import kr.or.ddit.tct.users.vo.UserVO;
import kr.or.ddit.tct.admin.dashboard.service.AdminDashboardServiceImpl;
import kr.or.ddit.tct.admin.dashboard.service.IAdminDashboardService;
@WebServlet("/admin/members.do")
public class AdminMembersController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final IAdminMemberService service = AdminMemberServiceImpl.getInstance();
	 private final IAdminDashboardService dashService = AdminDashboardServiceImpl.getInstance(); // 추가
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		// 검색 파라미터
		String qUserId   = trim(req.getParameter("qUserId"));
		String qUserName = trim(req.getParameter("qUserName"));
		String qRole     = trim(req.getParameter("qRole"));

		Map<String, Object> params = new HashMap<>();
		params.put("qUserId", qUserId);
		params.put("qUserName", qUserName);
		params.put("qRole", qRole);

		List<UserVO> list = service.selectAdminUserList(params);
		int totalCount = service.countAdminUsers(params);

		req.setAttribute("userList", list);
		req.setAttribute("totalCount", totalCount);

		int newMembers7d = dashService.selectNewMembers7d(); // 추가
        req.setAttribute("newMembers7d", newMembers7d);      // 추가
		
		// 사이드바 활성화
		req.setAttribute("adminActive", "members");

		req.getRequestDispatcher("/WEB-INF/views/admin/members.jsp").forward(req, resp);
	}

	private String trim(String s) {
		return (s == null) ? "" : s.trim();
	}

}
