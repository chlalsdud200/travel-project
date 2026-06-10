package kr.or.ddit.tct.board.reply.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import kr.or.ddit.tct.board.reply.service.IReplyService;
import kr.or.ddit.tct.board.reply.service.ReplyServiceImpl;
import kr.or.ddit.tct.board.reply.vo.ReplyVO;
import kr.or.ddit.tct.users.vo.UserVO;

@WebServlet("/reviewReplyInsert.do")
public class ReviewReplyInsert extends HttpServlet {
  private static final long serialVersionUID = 1L;

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    resp.setContentType("application/json; charset=UTF-8");
    Gson gson = new Gson();

    ReplyVO vo = gson.fromJson(req.getReader(), ReplyVO.class);

    HttpSession session = req.getSession(false);
    UserVO loginUser = (session == null) ? null : (UserVO) session.getAttribute("loginUser");
    String loginId = (loginUser == null) ? null : loginUser.getUserId();

    Map<String, String> result = new HashMap<>();

    if (loginId == null || loginId.trim().isEmpty()) {
      result.put("flag", "login");
      resp.getWriter().write(gson.toJson(result));
      return;
    }

    // ✅ 세션 userId로 강제
    vo.setUserId(loginId);

    IReplyService service = ReplyServiceImpl.getService();
    int res = service.reviewReplyInsert(vo);

    result.put("flag", res > 0 ? "ok" : "no");
    resp.getWriter().write(gson.toJson(result));
  }
}
