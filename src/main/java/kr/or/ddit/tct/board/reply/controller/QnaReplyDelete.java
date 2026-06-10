package kr.or.ddit.tct.board.reply.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.or.ddit.tct.board.reply.service.IReplyService;
import kr.or.ddit.tct.board.reply.service.ReplyServiceImpl;
import kr.or.ddit.tct.users.vo.UserVO;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;

/**
 * QNA 댓글 삭제
 */
@WebServlet("/qnaReplyDelete.do")
public class QnaReplyDelete extends HttpServlet {
  private static final long serialVersionUID = 1L;

  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    // ✅ JSON 응답 설정
    response.setContentType("application/json; charset=UTF-8");

    // 전송 데이터 읽기 - reNum
    int reNum = Integer.parseInt(request.getParameter("reNum"));
    System.out.println(reNum);

    // service 객체 얻기
    IReplyService service = ReplyServiceImpl.getService();

    // =====================================================
    // ✅ 추가(왜 필요?) 관리자 삭제는 DELETE가 아니라 UPDATE([ADMIN_DELETED])로 남겨야 함
    // ✅ 추가(역할) 로그인 유저 role이 ADMIN이면 adminDelete 호출
    // =====================================================
    HttpSession session = request.getSession(false);
    UserVO loginUser = (session == null) ? null : (UserVO) session.getAttribute("loginUser");
    String force = request.getParameter("force"); // "1"이면 완전삭제

    boolean isAdmin = (loginUser != null) &&
      ("ADMIN".equalsIgnoreCase(loginUser.getRole()) || "A".equalsIgnoreCase(loginUser.getRole()));

    int res;
    if (isAdmin && "1".equals(force)) {
      res = service.qnaReplyDelete(reNum);         // ✅ 물리삭제
    } else if (isAdmin) {
      res = service.qnaReplyAdminDelete(reNum);    // ✅ 소프트삭제([ADMIN_DELETED] 원문)
    } else {
      res = service.qnaReplyDelete(reNum);         // ✅ 유저 물리삭제(기존대로)
    }

    

    // ✅ JSON 직접 응답
    Gson gson = new Gson();
    Map<String, String> result = new HashMap<>();
    result.put("flag", res > 0 ? "ok" : "no");

    response.getWriter().write(gson.toJson(result));
  }
}
