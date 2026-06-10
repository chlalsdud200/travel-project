package kr.or.ddit.tct.board.reply.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import kr.or.ddit.tct.board.reply.service.IReplyService;
import kr.or.ddit.tct.board.reply.service.ReplyServiceImpl;
import kr.or.ddit.tct.board.reply.vo.ReplyVO;

@WebServlet("/reviewReplyList.do")
public class ReviewReplyList extends HttpServlet {
  private static final long serialVersionUID = 1L;

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    resp.setContentType("application/json; charset=UTF-8");

    String p = req.getParameter("reviewNo");
    if (p == null || p.trim().isEmpty()) p = req.getParameter("review_no");

    Map<String, Object> result = new HashMap<>();
    Gson gson = new Gson();

    int reviewNo = 0;
    try {
      reviewNo = Integer.parseInt(p);
    } catch (Exception e) {
      result.put("list", List.of());
      result.put("error", "reviewNo 파라미터가 없거나 숫자가 아닙니다.");
      resp.getWriter().write(gson.toJson(result));
      return;
    }

    IReplyService service = ReplyServiceImpl.getService();
    List<ReplyVO> list = service.reviewReplyList(reviewNo);

    result.put("list", list);
    resp.getWriter().write(gson.toJson(result));
  }
}
