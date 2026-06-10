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

@WebServlet("/cart/add.do")
public class CartAddController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ICartService cartService = CartServiceImpl.getInstance();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.setContentType("application/json; charset=UTF-8");

        UserVO loginUser = (UserVO) req.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            resp.getWriter().write(gson.toJson(new Resp(false, "NEED_LOGIN", "로그인이 필요합니다.", null, null)));
            return;
        }

        String userId = loginUser.getUserId();

        String regId = trim(req.getParameter("regId"));
        int peopleCnt = parseInt(req.getParameter("peopleCnt"), 1);

        String force = trim(req.getParameter("force"));
        boolean forceReplace = "Y".equalsIgnoreCase(force) || "TRUE".equalsIgnoreCase(force);

        if (regId.isBlank()) {
            resp.getWriter().write(gson.toJson(new Resp(false, "FAIL", "regId가 없습니다.", null, null)));
            return;
        }

        // 교체 확인을 위해 현재 cart 정보도 미리 조회
        CartVO before = cartService.getCurrentCart(userId);

        String result = cartService.addToCartSingle(userId, regId, peopleCnt, forceReplace);

        if ("OK".equals(result)) {
            CartVO after = cartService.getCurrentCart(userId);
            String savedRegId = (after != null) ? after.getRegId() : regId;
            resp.getWriter().write(gson.toJson(new Resp(true, "OK", null, savedRegId, null)));
            return;
        }

        if ("CONFLICT".equals(result)) {
            String currentRegId = (before != null) ? before.getRegId() : null;
            resp.getWriter().write(gson.toJson(new Resp(false, "CONFLICT",
                    "장바구니에는 1개 패키지상품만 담을 수 있습니다. 기존 상품을 삭제하고 새 상품으로 교체할까요?",
                    null, currentRegId)));
            return;
        }

        resp.getWriter().write(gson.toJson(new Resp(false, "FAIL", "장바구니 처리에 실패했습니다.", null, null)));
    }

    private String trim(String s) {
        return (s == null) ? "" : s.trim();
    }

    private int parseInt(String s, int def) {
        try {
            return Integer.parseInt((s == null) ? "" : s.trim());
        } catch (Exception e) {
            return def;
        }
    }

    private static class Resp {
        boolean ok;
        String code;
        String msg;
        String regId;         // 저장된 regId
        String currentRegId;  // conflict 시 현재 담긴 regId

        Resp(boolean ok, String code, String msg, String regId, String currentRegId) {
            this.ok = ok;
            this.code = code;
            this.msg = msg;
            this.regId = regId;
            this.currentRegId = currentRegId;
        }
    }
}
