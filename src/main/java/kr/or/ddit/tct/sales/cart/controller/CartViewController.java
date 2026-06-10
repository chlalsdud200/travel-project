package kr.or.ddit.tct.sales.cart.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.sales.cart.dto.vo.CartDetailDtoVO;
import kr.or.ddit.tct.sales.cart.service.CartServiceImpl;
import kr.or.ddit.tct.sales.cart.service.ICartService;
import kr.or.ddit.tct.users.vo.UserVO;

@WebServlet("/cart/view.do")
public class CartViewController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ICartService cartService = CartServiceImpl.getInstance();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        UserVO loginUser = (UserVO) req.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.do");
            return;
        }

        String userId = loginUser.getUserId();
        CartDetailDtoVO cart = cartService.getCartDetail(userId);

        req.setAttribute("cart", cart);
        req.getRequestDispatcher("/WEB-INF/views/cart/cart.jsp").forward(req, resp);
    }
}
