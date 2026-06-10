package kr.or.ddit.tct.sales.wishlist.controller;

import java.io.IOException;
import java.util.*;
import com.google.gson.Gson;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import kr.or.ddit.tct.sales.wishlist.service.IWishService;
import kr.or.ddit.tct.sales.wishlist.service.WishServiceImpl;
import kr.or.ddit.tct.users.vo.UserVO;

@WebServlet("/wish/ids.do")
public class WishIdsController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  private final IWishService service = WishServiceImpl.getInstance();
  private final Gson gson = new Gson();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    resp.setContentType("application/json;charset=UTF-8");

    HttpSession session = req.getSession(false);
    UserVO loginUser = (session == null) ? null : (UserVO) session.getAttribute("loginUser");

    Map<String, Object> out = new HashMap<>();
    if (loginUser == null || loginUser.getUserId() == null || loginUser.getUserId().trim().isEmpty()) {
      out.put("ok", true);
      out.put("loggedIn", false);
      out.put("ids", Collections.emptyList());
      resp.getWriter().write(gson.toJson(out));
      return;
    }

    String userId = loginUser.getUserId().trim();
    List<Map<String, Object>> list = service.getWishList(userId);

    List<String> ids = new ArrayList<>();
    for (Map<String, Object> row : list) {
      Object v = row.get("REG_ID"); // wish.xml 결과 컬럼
      if (v != null) ids.add(String.valueOf(v));
    }

    out.put("ok", true);
    out.put("loggedIn", true);
    out.put("ids", ids);
    resp.getWriter().write(gson.toJson(out));
  }
}
