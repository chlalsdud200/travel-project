package kr.or.ddit.tct.users.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.time.Instant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.users.service.IUserService;
import kr.or.ddit.tct.users.service.UserServiceImpl;
import kr.or.ddit.tct.users.vo.UserVO;

@WebServlet("/pwCheck.do")
public class PwCheckController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final IUserService userService = UserServiceImpl.getService();

    // pwCheck 성공 시 유효기간(10분)
    private static final long PW_CHECK_VALID_MILLIS = 10 * 60 * 1000L;

    private boolean isEmbed(HttpServletRequest req) {
        String embed = req.getParameter("embed");
        if ("1".equals(embed)) return true;

        // ✅ fallback: return 파라미터에 embed=1이 있으면 embed 모드로 간주
        String ret = req.getParameter("return");
        return ret != null && ret.contains("embed=1");
    }

    private void setPwCheckedUntil(HttpServletRequest req) {
        long until = Instant.now().toEpochMilli() + PW_CHECK_VALID_MILLIS;
        req.getSession().setAttribute("pwCheckedUntil", until);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        UserVO loginUser = (UserVO) req.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.do");
            return;
        }

        req.setCharacterEncoding("UTF-8");

        // return 파라미터(성공 후 이동 목적지)
        String returnUrl = req.getParameter("return");
        if (returnUrl == null || returnUrl.isBlank()) {
            // 기본은 editProfile (전체 화면)
            returnUrl = req.getContextPath() + "/editProfile.do";
        }
        req.setAttribute("returnUrl", returnUrl);

        // embed 모드면 fragment JSP로, 아니면 전체 JSP로
        String view = isEmbed(req)
                ? "/WEB-INF/views/fragments/pw_check_fragment.jsp"
                : "/WEB-INF/views/pw_check.jsp";

        req.getRequestDispatcher(view).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        UserVO loginUser = (UserVO) req.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.do");
            return;
        }

        req.setCharacterEncoding("UTF-8");

        boolean embed = isEmbed(req);

        String returnUrl = req.getParameter("return");
        if (returnUrl == null || returnUrl.isBlank()) {
            returnUrl = req.getContextPath() + "/editProfile.do";
        }

        String inputPw = req.getParameter("userPass");
        inputPw = (inputPw == null) ? "" : inputPw.trim();


        // DB에서 최신 비밀번호 조회
        UserVO dbUser = userService.selectUserById(loginUser.getUserId());
        if (dbUser == null) {
            req.setAttribute("msg", "사용자 정보를 찾을 수 없습니다.");
            req.setAttribute("returnUrl", returnUrl);

            String view = embed
                    ? "/WEB-INF/views/fragments/pw_check_fragment.jsp"
                    : "/WEB-INF/views/pw_check.jsp";

            req.getRequestDispatcher(view).forward(req, resp);
            return;
        }

        // 비밀번호 검증 (현재는 평문 비교 전제. 해시를 쓰면 여기 로직 변경 필요)
        String dbPw = dbUser.getUserPass();
        dbPw = (dbPw == null) ? "" : dbPw.trim();

        if (!dbPw.equals(inputPw)) {
            req.setAttribute("msg", "비밀번호가 일치하지 않습니다.");
            req.setAttribute("returnUrl", returnUrl);

            String view = embed
                    ? "/WEB-INF/views/fragments/pw_check_fragment.jsp"
                    : "/WEB-INF/views/pw_check.jsp";

            req.getRequestDispatcher(view).forward(req, resp);
            return;
        }

        // 성공: 세션에 pwCheckedUntil 저장
        setPwCheckedUntil(req);

        if (embed) {
            // embed 모드에서는 redirect 대신 edit profile fragment를 바로 반환
            // returnUrl이 editProfile.do?embed=1 형태로 오면, 그 화면을 로드하는 게 자연스럽지만
            // 여기서는 바로 edit_profile_fragment.jsp를 forward해서 반환한다.
            req.setAttribute("user", dbUser);
            req.getRequestDispatcher("/WEB-INF/views/fragments/edit_profile_fragment.jsp")
               .forward(req, resp);
            return;
        }

        // 전체 화면 모드는 원래대로 이동
        resp.sendRedirect(returnUrl);
    }
}
