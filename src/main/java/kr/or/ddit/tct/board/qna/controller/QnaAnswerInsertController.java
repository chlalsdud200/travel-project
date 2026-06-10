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

@WebServlet("/board/qnaAnswerInsert.do") // 답변 등록 버튼이 호출하는 URL
public class QnaAnswerInsertController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  private final Gson gson = new Gson(); // JSON ↔ Java 변환용
  private final IQnaService service = QnaServiceImpl.getInstance(); // 비즈니스 로직(서비스) 호출

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

    resp.setCharacterEncoding("UTF-8"); // JSON 한글 깨짐 방지
    resp.setContentType("application/json; charset=UTF-8"); // JSON 응답 선언

    Map<String, Object> out = new HashMap<>(); // {"flag": "...", "vo": ...} 형태로 응답 만들 컨테이너

    // 1) 로그인 여부 확인
    UserVO loginUser = (UserVO) req.getSession().getAttribute("loginUser"); // 현재 로그인 사용자
    if (loginUser == null) { // 로그인 안 했으면 답변 등록 불가
      out.put("flag", "login"); // 프론트가 이 값 보고 로그인 유도
      resp.getWriter().write(gson.toJson(out));
      return;
    }

    // 2) 관리자 권한 확인
    if (!"ADMIN".equals(loginUser.getRole())) { // ADMIN이 아니면 답변 등록 불가
      out.put("flag", "forbidden"); // 권한 없음
      resp.getWriter().write(gson.toJson(out));
      return;
    }

    // 3) 요청 body(JSON) 파싱
    //    예) { "qnaNo": 123, "ansCtt": "답변 내용" }
    Map<String, Object> body = gson.fromJson(req.getReader(), Map.class); // JSON을 Map으로 변환
    long qnaNo = ((Number) body.get("qnaNo")).longValue(); // 글번호
    String ansCtt = (String) body.get("ansCtt"); // 답변내용

    // 4) DB 업데이트(ANS_CTT/ANS_AT/QNA_STATUS)
    int cnt = service.answerInsert(qnaNo, ansCtt); // 성공하면 1

    // 5) 화면 갱신용으로 최신 상세를 다시 조회(hit 증가 없이)
    QnaVO vo = service.getQna(qnaNo);

    out.put("flag", cnt > 0 ? "ok" : "fail"); // 성공/실패
    out.put("vo", vo); // 최신 VO(답변/상태 포함)
    resp.getWriter().write(gson.toJson(out));
  }
}
