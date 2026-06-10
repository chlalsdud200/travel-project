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
import kr.or.ddit.tct.users.vo.UserVO;

@WebServlet("/cart/remove.do")
public class CartRemoveController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ICartService cartService = CartServiceImpl.getInstance();
    private final Gson gson = new Gson(); // JSON 응답을 만들기 위해 사용

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // ✅ ajax=Y면 페이지 리다이렉트가 아니라 JSON으로 결과를 돌려주기 위함
        String ajax = req.getParameter("ajax");
        boolean isAjax = "Y".equalsIgnoreCase(ajax);

        UserVO loginUser = (UserVO) req.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            if (isAjax) {
                // ✅ 결과목록 화면(fetch)에서 "로그인 필요"를 JSON으로 판단하기 위함
                resp.setContentType("application/json; charset=UTF-8");
                resp.getWriter().write(gson.toJson(new Resp(false, "NEED_LOGIN", "로그인이 필요합니다.")));
            } else {
                // ✅ 기존 동작 유지: 일반 요청이면 로그인 화면으로 이동
                resp.sendRedirect(req.getContextPath() + "/login.do");
            }
            return;
        }

        String userId = loginUser.getUserId();

        // ✅ 현재 프로젝트는 "장바구니에 패키지 1개만" 정책이라,
        //    제거 = 장바구니 비우기(clearCart)로 충분함
        cartService.clearCart(userId);

        if (isAjax) {
            // ✅ fetch에서 성공/실패를 깔끔하게 처리하기 위한 JSON 응답
            resp.setContentType("application/json; charset=UTF-8");
            resp.getWriter().write(gson.toJson(new Resp(true, "OK", null)));
        } else {
            // ✅ 기존 동작 유지: 장바구니 페이지로 이동
            resp.sendRedirect(req.getContextPath() + "/cart/view.do");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // ✅ 편의: GET으로 호출해도 동일하게 동작시키기 위함
        doPost(req, resp);
    }

    // ✅ 프론트가 ok/code/msg만 알면 충분하므로 최소 필드만 둠
    private static class Resp {
        boolean ok;
        String code;
        String msg;

        Resp(boolean ok, String code, String msg) {
            this.ok = ok;
            this.code = code;
            this.msg = msg;
        }
    }
}
