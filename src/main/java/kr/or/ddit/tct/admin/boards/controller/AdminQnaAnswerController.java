package kr.or.ddit.tct.admin.boards.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.board.qna.service.IQnaService;
import kr.or.ddit.tct.board.qna.service.QnaServiceImpl;

@WebServlet("/admin/qnaAnswer.do")
public class AdminQnaAnswerController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  // [의미] 답변 기능은 기존 QNA 서비스 로직을 재사용한다.
  // [존재이유] “관리자 게시판관리”에서 답변을 달아도,
  //          실제 DB 구조(QNA_BOARD.ANS_CTT/ANS_AT/QNA_STATUS)는 QNA 모듈과 동일하기 때문
  private final IQnaService qnaService = QnaServiceImpl.getInstance();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    // [의미] 어떤 문의글인지
    long qnaNo = Long.parseLong(req.getParameter("qnaNo"));

    // [의미] insert/update/delete 중 무엇을 할지
    String mode = req.getParameter("mode");

    // [의미] 등록/수정일 때 실제 답변 내용
    String ansCtt = req.getParameter("ansCtt");
    if (ansCtt == null) ansCtt = "";

    // [의미] 목록 복귀 유지용(상세에서 계속 back을 들고 다닌다)
    String back = req.getParameter("back");
    if (back == null) back = "";

    if ("delete".equalsIgnoreCase(mode)) {
      qnaService.answerDelete(qnaNo);
    } else if ("update".equalsIgnoreCase(mode)) {
      qnaService.answerUpdate(qnaNo, ansCtt);
    } else {
      qnaService.answerInsert(qnaNo, ansCtt);
    }

    // [의미] 답변 처리 후에는 같은 상세로 다시 돌아와서 결과를 확인하게 한다.
    String viewUrl = req.getContextPath() + "/admin/boardView.do?postType=QNA&postNo=" + qnaNo;
    if (!back.isBlank()) viewUrl += "&back=" + back;

    resp.sendRedirect(viewUrl);
  }
}
