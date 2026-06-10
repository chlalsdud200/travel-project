package kr.or.ddit.tct.sales.wishlist.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.or.ddit.tct.users.vo.UserVO;
import kr.or.ddit.tct.sales.wishlist.service.IWishService;
import kr.or.ddit.tct.sales.wishlist.service.WishServiceImpl;

@WebServlet("/wish/remove.do")
public class WishRemoveController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  private final Gson gson = new Gson();
  private final IWishService service = WishServiceImpl.getInstance();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    resp.setContentType("application/json;charset=UTF-8");

    HttpSession session = req.getSession();
    UserVO loginUser = (UserVO) session.getAttribute("loginUser");

    String regId = trim(req.getParameter("regId"));

    Map<String, Object> out = new HashMap<>();

    // 로그인 체크
    if (loginUser == null) {
      out.put("ok", false);
      out.put("code", "LOGIN");
      out.put("msg", "로그인이 필요합니다.");
      resp.getWriter().write(gson.toJson(out));
      return;
    }

    if (regId.isEmpty()) {
      out.put("ok", false);
      out.put("msg", "regId가 없습니다.");
      resp.getWriter().write(gson.toJson(out));
      return;
    }

    String userId = loginUser.getUserId(); // getter 이름만 본인 프로젝트에 맞추세요
    int cnt = service.deleteWish(userId, regId);

    out.put("ok", cnt > 0);
    out.put("cnt", cnt);
    out.put("msg", (cnt > 0) ? "삭제되었습니다." : "삭제할 항목이 없습니다.");

    resp.getWriter().write(gson.toJson(out));
  }

  private String trim(String s) {
    return (s == null) ? "" : s.trim();
  }
}
