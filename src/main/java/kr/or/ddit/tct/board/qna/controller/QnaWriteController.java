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

@WebServlet("/board/qnaWrite.do")
public class QnaWriteController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  private final Gson gson = new Gson();
  private final IQnaService service = QnaServiceImpl.getInstance();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

    resp.setCharacterEncoding("UTF-8");
    resp.setContentType("application/json; charset=UTF-8");

    UserVO loginUser = (UserVO) req.getSession().getAttribute("loginUser");

    Map<String, Object> out = new HashMap<>();

    if (loginUser == null) {
      out.put("flag", "login");
      resp.getWriter().write(gson.toJson(out));
      return;
    }

    // JSON body 읽기
    Map<String, Object> body = gson.fromJson(req.getReader(), Map.class);

    String title = (String) body.get("title");
    String qnaCtt = (String) body.get("qnaCtt");

    QnaVO vo = new QnaVO();
    vo.setUserId(loginUser.getUserId());
    vo.setQnaTitle(title);
    vo.setQnaCtt(qnaCtt);

    // ✅ 관리자(ROLE=ADMIN)가 쓰는 글은 항상 공지로 등록
    // - DB의 IS_NOTICE 컬럼에 'Y'로 들어가면, 목록에서 항상 상단 고정 + 답변상태 숨김 처리
    vo.setIsNotice("ADMIN".equals(loginUser.getRole()) ? "Y" : "N");

    int cnt = service.insertQna(vo);

    out.put("flag", cnt > 0 ? "ok" : "fail");
    resp.getWriter().write(gson.toJson(out));
  }
}
