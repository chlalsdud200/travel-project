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

@WebServlet("/board/qnaUpdate.do") // 수정 저장 버튼이 호출하는 주소
public class QnaUpdateController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  private final Gson gson = new Gson(); // 요청 JSON 읽고 응답 JSON 만들려고 Gson 사용
  private final IQnaService service = QnaServiceImpl.getInstance(); // 서비스 호출로 UPDATE 수행

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

    resp.setCharacterEncoding("UTF-8"); // JSON 한글 깨짐 방지
    resp.setContentType("application/json; charset=UTF-8"); // JSON 응답 선언

    UserVO loginUser = (UserVO) req.getSession().getAttribute("loginUser"); // 로그인 사용자 확인용

    Map<String, Object> out = new HashMap<>(); // {"flag": "..."} 형태로 결과 만들 컨테이너

    if (loginUser == null) { // 로그인 안 했으면 수정 불가
      out.put("flag", "login"); // 프론트가 이 값 보고 로그인으로 보냄
      resp.getWriter().write(gson.toJson(out)); // JSON 응답
      return; // 종료
    }

    Map<String, Object> body = gson.fromJson(req.getReader(), Map.class); // 요청 body(JSON)를 Map으로 파싱

    long qnaNo = ((Number) body.get("qnaNo")).longValue(); // 어떤 글을 수정할지 글번호
    String title = (String) body.get("title"); // 수정된 제목
    String qnaCtt = (String) body.get("qnaCtt"); // 수정된 내용

    int cnt = service.updateQna(qnaNo, loginUser.getUserId(), title, qnaCtt); // 작성자 본인 조건으로 UPDATE 수행

    out.put("flag", cnt > 0 ? "ok" : "fail"); // 수정되면 ok / 아니면 fail(작성자 아니면 여기로 떨어짐)
    resp.getWriter().write(gson.toJson(out)); // 결과 JSON 응답
  }
}
