package kr.or.ddit.tct.mypage.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.users.vo.UserVO;

/**
 * 마이페이지 화면 진입 컨트롤러
 */
@WebServlet("/mypage.do")
public class MyPageController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        UserVO loginUser = (UserVO) req.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.do");
            return;
        }

        req.setAttribute("loginUser", loginUser);
        req.getRequestDispatcher("/WEB-INF/views/mypage.jsp").forward(req, resp);
    }
}
