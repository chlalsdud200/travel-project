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
import kr.or.ddit.tct.users.vo.UserVO; // 세션에서 role 확인하려고 추가

@WebServlet("/board/qnaViewData.do")
public class QnaViewDataController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  private final Gson gson = new Gson();
  private final IQnaService service = QnaServiceImpl.getInstance();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    resp.setCharacterEncoding("UTF-8");
    resp.setContentType("application/json; charset=UTF-8");

    long qnaNo = Long.parseLong(req.getParameter("qnaNo"));
 // 지금 상세를 "보고 있는 사람"이 ADMIN인지 판단
 // 존재이유: 비관리자는 ADMIN 작성자 이름을 숨기고, ADMIN은 서로 이름을 확인하기 위해
 UserVO loginUser = (UserVO) req.getSession().getAttribute("loginUser");
 boolean viewerAdmin = (loginUser != null && "ADMIN".equals(loginUser.getRole()));

    QnaVO vo = service.viewQna(qnaNo);     // 조회수 증가 + 상세 1건
    QnaVO prev = service.getPrevQna(qnaNo); // 이전글 1건
    QnaVO next = service.getNextQna(qnaNo); // 다음글 1건

 // 비관리자라면 ADMIN 작성자의 이름을 '관리자'로 숨김
    maskAdminWriter(vo, viewerAdmin);
    maskAdminWriter(prev, viewerAdmin);
    maskAdminWriter(next, viewerAdmin);

    Map<String, Object> out = new HashMap<>();
    out.put("ok", true);
    out.put("vo", vo);
    out.put("prev", prev);
    out.put("next", next);
    
    resp.getWriter().write(gson.toJson(out));
  }
//단건(QnaVO 1개)에 대한 마스킹 처리
//존재이유: 상세/이전글/다음글도 동일한 규칙으로 작성자 표시를 통일하기 위함
private void maskAdminWriter(QnaVO vo, boolean viewerAdmin) {
 if (viewerAdmin) return;                 // 관리자는 마스킹하지 않음
 if (vo == null) return;                  // prev/next가 없을 수 있으니 null은 그냥 통과
 if ("ADMIN".equals(vo.getWriterRole()))  // 작성자가 ADMIN이면
   vo.setWriterName("관리자");             // 비관리자에게는 '관리자'로 숨김
}

}
