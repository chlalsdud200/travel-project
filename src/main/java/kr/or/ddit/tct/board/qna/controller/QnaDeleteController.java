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
import kr.or.ddit.tct.users.vo.UserVO;

@WebServlet("/board/qnaDelete.do")// /board/qnaDelete.do 로 들어오는 요청을 이 서블릿이 받는다
public class QnaDeleteController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  private final Gson gson = new Gson(); // JSON <-> Java 변환용
  private final IQnaService service = QnaServiceImpl.getInstance(); // QNA 비즈니스 로직(서비스) 사용

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

    resp.setCharacterEncoding("UTF-8"); // 응답 한글 깨짐 방지
    resp.setContentType("application/json; charset=UTF-8"); // 응답을 JSON으로 보내겠다는 선언

    UserVO loginUser = (UserVO) req.getSession().getAttribute("loginUser"); // 현재 로그인한 사용자 꺼내기

    Map<String, Object> out = new HashMap<>(); // {flag: "..."} 형태로 결과를 만들 컨테이너

    if (loginUser == null) { // 로그인 안 했으면 삭제 불가
      out.put("flag", "login"); // 프론트에서 이 값 보고 로그인 페이지로 보냄
      resp.getWriter().write(gson.toJson(out)); // JSON으로 직렬화해서 응답
      return; // 여기서 종료
    }

    Map<String, Object> body = gson.fromJson(req.getReader(), Map.class); // 요청 body(JSON)를 Map으로 받기
    long qnaNo = ((Number) body.get("qnaNo")).longValue(); // qnaNo 값 꺼내서 long으로 변환

    int cnt = service.deleteQna(qnaNo, loginUser.getUserId()); // "작성자 본인" 조건으로 삭제 수행

    out.put("flag", cnt > 0 ? "ok" : "fail"); // 삭제되면 ok, 아니면 fail
    resp.getWriter().write(gson.toJson(out)); // 결과 JSON 응답
  }
}
