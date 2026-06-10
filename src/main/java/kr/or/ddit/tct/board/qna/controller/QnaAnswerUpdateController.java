package kr.or.ddit.tct.board.qna.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.board.qna.service.IQnaService;
import kr.or.ddit.tct.board.qna.service.QnaServiceImpl;
import kr.or.ddit.tct.board.qna.vo.QnaVO;
import kr.or.ddit.tct.users.vo.UserVO;

@WebServlet("/board/qnaAnswerUpdate.do") // 답변 수정 버튼이 호출하는 URL
public class QnaAnswerUpdateController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  private final Gson gson = new Gson();
  private final IQnaService service = QnaServiceImpl.getInstance();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

    resp.setCharacterEncoding("UTF-8");
    resp.setContentType("application/json; charset=UTF-8");

    Map<String, Object> out = new HashMap<>();

    // 1) 로그인 확인
    UserVO loginUser = (UserVO) req.getSession().getAttribute("loginUser");
    if (loginUser == null) {
      out.put("flag", "login");
      resp.getWriter().write(gson.toJson(out));
      return;
    }

    // 2) 권한 확인(ADMIN만)
    if (!"ADMIN".equals(loginUser.getRole())) {
      out.put("flag", "forbidden");
      resp.getWriter().write(gson.toJson(out));
      return;
    }

    // 3) 요청 body 파싱
    Map<String, Object> body = gson.fromJson(req.getReader(), Map.class);
    long qnaNo = ((Number) body.get("qnaNo")).longValue();
    String ansCtt = (String) body.get("ansCtt");

    // 4) 답변 수정
    int cnt = service.answerUpdate(qnaNo, ansCtt);

    // 5) 갱신된 상세(답변/상태 포함)
    QnaVO vo = service.getQna(qnaNo);

    out.put("flag", cnt > 0 ? "ok" : "fail");
    out.put("vo", vo);
    resp.getWriter().write(gson.toJson(out));
  }
}
