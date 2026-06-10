package kr.or.ddit.tct.admin.boards.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.admin.boards.service.AdminBoardsServiceImpl;
import kr.or.ddit.tct.admin.boards.service.IAdminBoardsService;
import kr.or.ddit.tct.admin.boards.vo.AdminBoardKeyVO;
import kr.or.ddit.tct.admin.boards.vo.AdminBoardPostVO;

@WebServlet("/admin/boardView.do")
public class AdminBoardViewController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  // [의미] 상세도 “조회 + JSP 포워드”만 한다 (답변/삭제는 별도 POST 컨트롤러)
  // [존재이유] GET은 화면, POST는 변경(관리자 답변/삭제)로 역할 분리
  private final IAdminBoardsService service = AdminBoardsServiceImpl.getInstance();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    // [의미] 어떤 글을 볼지 결정하는 키
    String postType = req.getParameter("postType"); // QNA / REVIEW
    int postNo = Integer.parseInt(req.getParameter("postNo"));

    // [의미] 목록 복귀를 위한 back(검색조건+페이지)
    String back = req.getParameter("back");
    if (back == null) back = "";

    AdminBoardKeyVO key = new AdminBoardKeyVO();
    key.setPostType(postType);
    key.setPostNo(postNo);

    AdminBoardPostVO post = service.selectDetail(key);

    req.setAttribute("post", post);
    req.setAttribute("back", back);

    req.setAttribute("adminActive", "boards");

    req.getRequestDispatcher("/WEB-INF/views/admin/board_view.jsp").forward(req, resp);
  }
}
