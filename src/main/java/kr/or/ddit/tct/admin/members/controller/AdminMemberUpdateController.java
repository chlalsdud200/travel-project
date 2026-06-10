package kr.or.ddit.tct.admin.members.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.admin.members.service.AdminMemberServiceImpl;
import kr.or.ddit.tct.admin.members.service.IAdminMemberService;
import kr.or.ddit.tct.users.vo.UserVO;

@WebServlet("/admin/memberUpdate.do")
public class AdminMemberUpdateController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final IAdminMemberService service = AdminMemberServiceImpl.getInstance();

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		req.setCharacterEncoding("UTF-8");

		// 회원 수정 값
		String userId = trim(req.getParameter("userId"));
		String role = trim(req.getParameter("role"));
		String userName = trim(req.getParameter("userName"));
		String userBir = trim(req.getParameter("userBir"));
		String userEmail = trim(req.getParameter("userEmail"));
		String userTel = trim(req.getParameter("userTel"));
		String userAddr1 = trim(req.getParameter("userAddr1"));
		String userAddr2 = trim(req.getParameter("userAddr2"));
		String userZip = trim(req.getParameter("userZip"));

		// 비밀번호: 입력된 경우에만 변경(빈 값이면 SQL에서 제외되도록)
		String userPass = trim(req.getParameter("userPass"));

		UserVO uv = new UserVO();
		uv.setUserId(userId);
		uv.setRole(role);
		uv.setUserName(userName);
		uv.setUserBir(userBir);
		uv.setUserEmail(userEmail);
		uv.setUserTel(userTel);
		uv.setUserAddr1(userAddr1);
		uv.setUserAddr2(userAddr2);
		uv.setUserZip(userZip);
		uv.setUserPass(userPass);

		int cnt = service.updateUserAdmin(uv);
		// [추가] 본인(현재 로그인한 관리자) 정보를 수정한 경우,
		//      DB만 바꾸면 세션 loginUser는 그대로라서 "계속 ADMIN처럼" 보일 수 있음.
		//      그래서 세션 loginUser.role도 같이 동기화해준다.
		jakarta.servlet.http.HttpSession session = req.getSession(false); // 기존 세션을 가져옴(새로 만들지 않음)
		if (cnt > 0 && session != null) { // DB 업데이트가 성공했을 때만 세션을 만진다(성공 기준 일치)
			UserVO loginUser = (UserVO) session.getAttribute("loginUser"); // 필터가 보고 있는 세션 사용자
			if (loginUser != null && userId.equals(loginUser.getUserId())) { // "수정 대상(userId)"이 "내 계정"이면
				loginUser.setRole(role); // ★ 핵심: 세션 role을 최신으로 바꿔서 필터가 즉시 차단/허용 판단하게 함

				// 만약 내가 USER로 강등됐다면, 관리자 화면으로 다시 리다이렉트시키지 말고
				// 바로 일반 화면으로 보내서 "관리자 페이지에 남아있는" 상태를 끊는다.
				if (!"ADMIN".equalsIgnoreCase(role)) { // ADMIN이 아니면 관리자 영역 접근 불가
					resp.sendRedirect(req.getContextPath() + "/mainPage.do?msg=role_changed"); // 일반 메인으로 이동
					return; // 아래의 /admin/members.do redirect를 실행하지 않게 종료
				}
			}
		}

		// 검색 조건 유지
		String qUserId = trim(req.getParameter("qUserId"));
		String qUserName = trim(req.getParameter("qUserName"));
		String qRole = trim(req.getParameter("qRole"));

		String redirectUrl = req.getContextPath() + "/admin/members.do" + "?qUserId=" + enc(qUserId) + "&qUserName="
				+ enc(qUserName) + "&qRole=" + enc(qRole) + "&openUserId=" + enc(userId) + "&msg="
				+ (cnt > 0 ? "ok" : "fail");

		resp.sendRedirect(redirectUrl);
	}

	private String trim(String s) {
		return (s == null) ? "" : s.trim();
	}

	// 단순 URL 인코딩(공백/특수문자 대응 최소)
	private String enc(String s) {
		try {
			return java.net.URLEncoder.encode(s == null ? "" : s, "UTF-8");
		} catch (Exception e) {
			return "";
		}
	}
}
