package kr.or.ddit.tct.sales.wishlist.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import kr.or.ddit.tct.sales.wishlist.service.IWishService;
import kr.or.ddit.tct.sales.wishlist.service.WishServiceImpl;
import kr.or.ddit.tct.users.vo.UserVO;

@WebServlet("/wish/page.do")
public class WishPageController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  private final IWishService service = WishServiceImpl.getInstance();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    HttpSession session = req.getSession(false);
    UserVO loginUser = (session == null) ? null : (UserVO) session.getAttribute("loginUser");
    String userId = (loginUser == null) ? null : loginUser.getUserId();

    // 비로그인: 로그인 화면으로 이동
    if (userId == null || userId.trim().isEmpty()) {
      resp.sendRedirect(req.getContextPath() + "/login.do");
      return;
    }

    // 로그인: 위시 목록 조회
    List<Map<String, Object>> list = service.getWishList(userId.trim());
    req.setAttribute("wishList", list);

    req.getRequestDispatcher("/WEB-INF/views/wish/wish.jsp").forward(req, resp);
  }
}
