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

@WebServlet("/cart/updatePeopleCnt.do") // ✅ 장바구니 인원수 저장용 엔드포인트
public class CartUpdatePeopleCntController extends HttpServlet {

    private final ICartService cartService = CartServiceImpl.getInstance(); // ✅ 서비스(DAO 호출 담당)
    private final Gson gson = new Gson(); // ✅ JSON 응답 만들기

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // ✅ 이 요청은 "수량 저장"이 목적이므로 JSON으로 돌려준다
        resp.setContentType("application/json; charset=UTF-8");

        // ✅ 로그인 사용자(세션)에 연결된 장바구니만 수정해야 하니까 세션에서 꺼낸다
        UserVO loginUser = (UserVO) req.getSession().getAttribute("loginUser");

        // ✅ 로그인 안 했으면 수정할 주체가 없으니 401로 종료
        if (loginUser == null) {
            resp.setStatus(401);
            resp.getWriter().write(gson.toJson(new Resp(false, "LOGIN", "로그인이 필요합니다.", 0)));
            return;
        }

        // ✅ 누구의 장바구니를 수정할지(키)
        String userId = loginUser.getUserId();

        // ✅ 화면에서 넘어온 peopleCnt(없거나 이상하면 1)
        int peopleCnt = parseInt(req.getParameter("peopleCnt"), 1);

        // ✅ 1 미만은 의미 없으니 최소 1로 고정
        if (peopleCnt < 1) peopleCnt = 1;

        // ✅ DB의 CART.PEOPLE_CNT 업데이트(단건 장바구니 구조라 USER_ID 기준으로 업데이트)
        int cnt = cartService.updatePeopleCnt(userId, peopleCnt);

        // ✅ 업데이트 성공 여부를 JSON으로 반환
        boolean ok = (cnt > 0);
        resp.getWriter().write(gson.toJson(new Resp(ok, ok ? "OK" : "FAIL", ok ? "수량 저장 완료" : "수량 저장 실패", peopleCnt)));
    }

    // ✅ 문자열을 int로 바꾸는 유틸(없거나 숫자 아니면 기본값)
    private int parseInt(String s, int def) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }

    // ✅ 프론트가 보기 쉬운 응답 형태
    static class Resp {
        boolean ok;
        String code;
        String msg;
        int peopleCnt;

        Resp(boolean ok, String code, String msg, int peopleCnt) {
            this.ok = ok;
            this.code = code;
            this.msg = msg;
            this.peopleCnt = peopleCnt;
        }
    }
}
