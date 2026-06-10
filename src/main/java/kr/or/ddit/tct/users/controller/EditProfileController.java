package kr.or.ddit.tct.users.controller;

import java.io.IOException;
import java.time.Instant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.users.service.IUserService;
import kr.or.ddit.tct.users.service.UserServiceImpl;
import kr.or.ddit.tct.users.vo.UserVO;

@WebServlet("/editProfile.do")
public class EditProfileController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final IUserService userService = UserServiceImpl.getService();

    private boolean isEmbed(HttpServletRequest req) {
        return "1".equals(req.getParameter("embed"));
    }

    private boolean isPwChecked(HttpServletRequest req) {
        Object untilObj = req.getSession().getAttribute("pwCheckedUntil");
        if (!(untilObj instanceof Long)) return false;
        long until = (Long) untilObj;
        return Instant.now().toEpochMilli() <= until;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        UserVO loginUser = (UserVO) req.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.do");
            return;
        }

        if (!isPwChecked(req)) {
            // embed면 pwCheck도 embed로 유도
            String next = req.getContextPath() + "/editProfile.do" + (isEmbed(req) ? "?embed=1" : "");
            String url = req.getContextPath() + "/pwCheck.do?return=" + java.net.URLEncoder.encode(next, "UTF-8");
            if (isEmbed(req)) url += "&embed=1";
            resp.sendRedirect(url);
            return;
        }

        // 최신 사용자 정보 재조회
        UserVO dbUser = userService.selectUserById(loginUser.getUserId());
        if (dbUser == null) dbUser = loginUser;

        req.setAttribute("user", dbUser);

        String view = isEmbed(req)
                ? "/WEB-INF/views/fragments/edit_profile_fragment.jsp"
                : "/WEB-INF/views/edit_profile.jsp";

        req.getRequestDispatcher(view).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        UserVO loginUser = (UserVO) req.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.do");
            return;
        }

        boolean embed = isEmbed(req);

        if (!isPwChecked(req)) {
            String next = req.getContextPath() + "/editProfile.do" + (embed ? "?embed=1" : "");
            String url = req.getContextPath() + "/pwCheck.do?return=" + java.net.URLEncoder.encode(next, "UTF-8");
            if (embed) url += "&embed=1";
            resp.sendRedirect(url);
            return;
        }

        req.setCharacterEncoding("UTF-8");

     // 비밀번호 파라미터 먼저 읽기
        String userPass  = req.getParameter("userPass");   // 새 비밀번호(선택)
        String userPass2 = req.getParameter("userPass2");  // 새 비밀번호 확인(선택)

        userPass  = (userPass  == null) ? "" : userPass.trim();
        userPass2 = (userPass2 == null) ? "" : userPass2.trim();

        // 새 비밀번호를 입력한 경우에만 검증(형식 + 일치)
        if (!userPass.isEmpty() || !userPass2.isEmpty()) {

            java.util.regex.Pattern pwRule =
                    java.util.regex.Pattern.compile("^(?=.*[A-Za-z])(?=.*\\d).{8,}$");

            // 1) 형식 검증
            if (!pwRule.matcher(userPass).matches()) {
                req.setAttribute("msg", "비밀번호는 영문+숫자 포함 8자 이상만 가능합니다.");
                req.setAttribute("user", userService.selectUserById(loginUser.getUserId()));

                String view = embed
                        ? "/WEB-INF/views/fragments/edit_profile_fragment.jsp"
                        : "/WEB-INF/views/edit_profile.jsp";

                req.getRequestDispatcher(view).forward(req, resp);
                return;
            }

            // 2) 일치 검증
            if (!userPass.equals(userPass2)) {
                req.setAttribute("msg", "새 비밀번호 확인이 일치하지 않습니다.");
                req.setAttribute("user", userService.selectUserById(loginUser.getUserId()));

                String view = embed
                        ? "/WEB-INF/views/fragments/edit_profile_fragment.jsp"
                        : "/WEB-INF/views/edit_profile.jsp";

                req.getRequestDispatcher(view).forward(req, resp);
                return;
            }
        }


        // VO 세팅
        UserVO uv = new UserVO();
        uv.setUserId(loginUser.getUserId());
        uv.setUserName(req.getParameter("userName"));
        uv.setUserEmail(req.getParameter("userEmail"));
        uv.setUserTel(req.getParameter("userTel"));
        uv.setUserAddr1(req.getParameter("userAddr1"));
        uv.setUserAddr2(req.getParameter("userAddr2"));
        uv.setUserZip(req.getParameter("userZip"));

        // 비밀번호는 입력했을 때만 반영 (users.xml에서 <if> 조건부 업데이트 전제)
        if (userPass != null && !userPass.isBlank()) {
            uv.setUserPass(userPass);
        } else {
            uv.setUserPass(null);
        }

        int cnt = userService.updateUser(uv);
        if (cnt <= 0) {
            req.setAttribute("msg", "회원정보 수정에 실패했습니다.");
            req.setAttribute("user", userService.selectUserById(loginUser.getUserId()));

            String view = embed
                    ? "/WEB-INF/views/fragments/edit_profile_fragment.jsp"
                    : "/WEB-INF/views/edit_profile.jsp";

            req.getRequestDispatcher(view).forward(req, resp);
            return;
        }

        // 세션 유저 최신화(A안): DB 재조회 후 세션 갱신
        UserVO refreshed = userService.selectUserById(loginUser.getUserId());
        if (refreshed != null) {
            // role이 조회에 포함되지 않는 경우가 많아 안전하게 유지
            refreshed.setRole(loginUser.getRole());
            req.getSession().setAttribute("loginUser", refreshed);
        }

        if (embed) {
            // embed 모드에서는 redirect 대신 성공 fragment 반환
            resp.setContentType("text/html; charset=UTF-8");
            req.getRequestDispatcher("/WEB-INF/views/fragments/profile_save_ok.jsp")
               .forward(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/mypage.do#pay");
    }
}
