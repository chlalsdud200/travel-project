package kr.or.ddit.tct.board.reply.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.or.ddit.tct.board.reply.vo.ReplyVO;
import kr.or.ddit.tct.board.reply.service.IReplyService;
import kr.or.ddit.tct.board.reply.service.ReplyServiceImpl;
import kr.or.ddit.tct.users.vo.UserVO;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;

/**
 * QNA 댓글 수정
 */
@WebServlet("/qnaReplyUpdate.do")
public class QnaReplyUpdate extends HttpServlet {
  private static final long serialVersionUID = 1L;

  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    // ✅ JSON 응답 설정
    response.setContentType("application/json; charset=UTF-8");

    // JSON 바로 변환
    Gson gson = new Gson();
    ReplyVO vo = gson.fromJson(request.getReader(), ReplyVO.class);

    System.out.println("vo = " + vo);

    // service 객체 얻기
    IReplyService service = ReplyServiceImpl.getService();

    // =====================================================
    // ✅ 추가(왜 필요?) 관리자 수정은 [ADMIN_EDITED] 마커를 남겨야 함
    // ✅ 추가(역할) 로그인 유저 role이 ADMIN이면 adminUpdate 호출
    // =====================================================
    HttpSession session = request.getSession(false);
    UserVO loginUser = (session == null) ? null : (UserVO) session.getAttribute("loginUser");
    boolean isAdmin = (loginUser != null) && "ADMIN".equalsIgnoreCase(loginUser.getRole());

    int res;
    if (isAdmin) {
      res = service.qnaReplyAdminUpdate(vo); // ✅ UPDATE: '[ADMIN_EDITED] ' || reCtt
    } else {
      res = service.qnaReplyUpdate(vo);      // ✅ 일반 UPDATE
    }

    // ✅ JSON 직접 응답
    Map<String, String> result = new HashMap<>();
    result.put("flag", res > 0 ? "ok" : "no");

    response.getWriter().write(gson.toJson(result));
  }
}
