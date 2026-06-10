package kr.or.ddit.tct.comm.filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.tct.users.service.IUserService;
import kr.or.ddit.tct.users.service.UserServiceImpl;
import kr.or.ddit.tct.users.vo.UserVO;

@WebFilter(urlPatterns = { "/admin/*" })
public class AdminAuthFilter implements Filter {

    // DB에서 "최신 role"을 확인하기 위한 서비스(세션 값만 믿지 않기 위함)
    private final IUserService userService = UserServiceImpl.getService();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;   // 서블릿 요청 객체(세션/URI 접근용)
        HttpServletResponse resp = (HttpServletResponse) response; // 리다이렉트 응답 처리용

        HttpSession session = req.getSession(false); // 로그인 세션이 있는지 확인(없으면 null)
        UserVO loginUser = (session == null) ? null : (UserVO) session.getAttribute("loginUser"); // 현재 로그인 사용자

        // 1) 로그인 안했으면 로그인 화면으로 보냄 (관리자 페이지는 로그인 필수)
        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.do");
            return;
        }

        // 2) ★핵심: DB에서 최신 사용자 정보를 다시 조회해서 role을 "진짜 값"으로 판단
        UserVO fresh = userService.selectUserById(loginUser.getUserId()); // DB 최신 상태

        // DB에서 못 가져오거나(=권한판단 불가) ADMIN이 아니면 관리자 접근 차단
        if (fresh == null || !"ADMIN".equalsIgnoreCase(fresh.getRole())) {
            // 세션에도 최신 role 반영(헤더/화면 로직이 세션을 볼 때도 일관성 유지)
            if (fresh != null) loginUser.setRole(fresh.getRole());

            resp.sendRedirect(req.getContextPath() + "/mainPage.do");
            return;
        }

        // 3) DB가 ADMIN이면 통과
        loginUser.setRole(fresh.getRole()); // 세션 role을 최신으로 동기화(계속 일관성 유지)
        chain.doFilter(request, response);
    }
}
