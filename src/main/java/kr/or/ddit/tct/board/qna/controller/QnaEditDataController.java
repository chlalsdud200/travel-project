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

@WebServlet("/board/qnaEditData.do") // 수정 화면에서 제목/내용을 채우려고 호출하는 데이터 API
public class QnaEditDataController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  private final Gson gson = new Gson(); // JSON 응답 만들려고 Gson 사용
  private final IQnaService service = QnaServiceImpl.getInstance(); // 서비스(비즈니스 로직) 사용

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

    resp.setCharacterEncoding("UTF-8"); // JSON 한글 깨짐 방지
    resp.setContentType("application/json; charset=UTF-8"); // JSON으로 응답하겠다는 선언

    long qnaNo = Long.parseLong(req.getParameter("qnaNo")); // 어떤 글을 가져올지 qnaNo로 식별
    QnaVO vo = service.getQna(qnaNo); // 조회수 증가 없이 글 1건 가져오기(수정 프리필용)

    Map<String, Object> out = new HashMap<>(); // {"vo": ...} 형태로 JSON 만들 컨테이너
    out.put("vo", vo); // 프론트에서 data.vo로 사용

    resp.getWriter().write(gson.toJson(out)); // Map을 JSON 문자열로 직렬화해서 응답
  }
}
