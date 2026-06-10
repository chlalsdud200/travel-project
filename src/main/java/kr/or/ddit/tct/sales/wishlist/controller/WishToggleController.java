package kr.or.ddit.tct.sales.wishlist.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import kr.or.ddit.tct.sales.wishlist.service.IWishService;
import kr.or.ddit.tct.sales.wishlist.service.WishServiceImpl;
import kr.or.ddit.tct.users.vo.UserVO; 

@WebServlet("/wish/toggle.do")
public class WishToggleController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  private final Gson gson = new Gson();
  private final IWishService service = WishServiceImpl.getInstance();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    resp.setContentType("application/json;charset=UTF-8");

    // 1) 로그인 userId 꺼내기 (유틸 없이)
    HttpSession session = req.getSession(false);
    UserVO loginUser = (session == null) ? null : (UserVO) session.getAttribute("loginUser");
    String userId = (loginUser == null) ? null : loginUser.getUserId(); // ✅ getter명 맞추기

    Map<String, Object> out = new HashMap<>();

    if (userId == null || userId.trim().isEmpty()) {
      out.put("ok", false);
      out.put("loggedIn", false);
      out.put("msg", "로그인이 필요합니다.");
      resp.getWriter().write(gson.toJson(out));
      return;
    }

    // 2) regId 받기
    String regId = req.getParameter("regId");
    if (regId == null || regId.trim().isEmpty()) {
      out.put("ok", false);
      out.put("loggedIn", true);
      out.put("msg", "regId가 비어있습니다.");
      resp.getWriter().write(gson.toJson(out));
      return;
    }

    // 3) 토글 실행
    boolean wished = service.toggleWish(userId.trim(), regId.trim());

    out.put("ok", true);
    out.put("loggedIn", true);
    out.put("wished", wished);
    out.put("msg", wished ? "상품 등록되었습니다." : "관심상품에서 해제되었습니다.");

    resp.getWriter().write(gson.toJson(out));
  }
}
