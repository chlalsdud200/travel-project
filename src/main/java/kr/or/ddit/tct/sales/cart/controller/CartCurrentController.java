package kr.or.ddit.tct.sales.cart.controller;

import java.io.IOException;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.sales.cart.service.CartServiceImpl;
import kr.or.ddit.tct.sales.cart.service.ICartService;
import kr.or.ddit.tct.sales.cart.vo.CartVO;
import kr.or.ddit.tct.users.vo.UserVO;

@WebServlet("/cart/current.do")
public class CartCurrentController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ICartService cartService = CartServiceImpl.getInstance();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.setContentType("application/json; charset=UTF-8");

        UserVO loginUser = (UserVO) req.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            resp.getWriter().write(gson.toJson(new Resp(false, null, 0, "NEED_LOGIN", null)));
            return;
        }

        String userId = loginUser.getUserId();
        CartVO cart = cartService.getCurrentCart(userId);

        if (cart == null) {
            resp.getWriter().write(gson.toJson(new Resp(true, null, 0, "OK", null)));
            return;
        }

        resp.getWriter().write(gson.toJson(new Resp(true, cart.getRegId(), cart.getPeopleCnt(), "OK", null)));
    }

    private static class Resp {
        boolean loggedIn;
        String regId;
        int peopleCnt;
        String code;
        String msg;

        Resp(boolean loggedIn, String regId, int peopleCnt, String code, String msg) {
            this.loggedIn = loggedIn;
            this.regId = regId;
            this.peopleCnt = peopleCnt;
            this.code = code;
            this.msg = msg;
        }
    }
}
