package kr.or.ddit.tct.admin.boards.controller;

import java.io.IOException;
import java.net.URLDecoder;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.board.qna.service.IQnaService;
import kr.or.ddit.tct.board.qna.service.QnaServiceImpl;
import kr.or.ddit.tct.board.qna.vo.QnaVO;
import kr.or.ddit.tct.users.vo.UserVO;

@WebServlet("/admin/noticeWrite.do")
public class AdminNoticeWriteController extends HttpServlet {

  // [존재이유] 공지는 결국 QNA_BOARD에 INSERT(IS_NOTICE='Y') 하는 것이므로,
  //          기존 QNA 서비스(INSERT 로직/매퍼)를 그대로 재사용한다.
  private final IQnaService qnaService = QnaServiceImpl.getInstance();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    // [의미] "상세 → 목록"처럼, 작성 화면에서도 목록 복귀 시 검색조건 유지할 수 있게 back을 받아둔다.
    String back = req.getParameter("back");     // 의미: boards.jsp가 넘겨준 검색조건(URLEncoded)
    if (back == null) back = "";                // 방어 최소: null만 빈값 처리

    req.setAttribute("back", back);             // 의미: JSP에서 목록복귀 URL을 만들 때 사용

    req.setAttribute("adminActive", "boards");  // 의미: 사이드바 active 표시

    req.getRequestDispatcher("/WEB-INF/views/admin/notice_write.jsp").forward(req, resp);
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    req.setCharacterEncoding("UTF-8");          // 의미: 한글 깨짐 방지(POST 본문)

    // [의미] AdminAuthFilter(/admin/*)가 이미 ADMIN만 통과시키므로, 여기선 방어코드 최소화한다.
    UserVO loginUser = (UserVO) req.getSession().getAttribute("loginUser");

    // [의미] 폼 입력값
    String title = req.getParameter("title");   // 의미: 공지 제목
    String ctt   = req.getParameter("qnaCtt");  // 의미: 공지 내용(QnaVO 필드명과 맞춤)

    // [존재이유] 공지 또한 QNA_BOARD 레코드이므로 QnaVO로 INSERT 한다.
    QnaVO vo = new QnaVO();
    vo.setUserId(loginUser.getUserId());        // 의미: 작성자(관리자) ID
    vo.setQnaTitle(title);                      // 의미: 제목 컬럼(QNA_TITLE)
    vo.setQnaCtt(ctt);                          // 의미: 내용 컬럼(QNA_CTT)
    vo.setIsNotice("Y");                        // ✅ 핵심: 공지로 등록되게 하는 스위치(IS_NOTICE)

    qnaService.insertQna(vo);                   // 의미: mybatis(boardQna.insertQna)로 INSERT 수행

    // [의미] 작성 후 “원래 보고 있던 목록 조건”으로 복귀
    String back = req.getParameter("back");
    String url = req.getContextPath() + "/admin/boards.do";

    // [존재이유] back은 URLEncoded 문자열이라 decode해서 queryString으로 붙여야 실제 파라미터로 동작한다.
    if (back != null && !back.isBlank()) {
      url = url + "?" + URLDecoder.decode(back, "UTF-8");
    }

    resp.sendRedirect(url);
  }
}
