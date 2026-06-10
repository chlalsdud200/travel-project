package kr.or.ddit.tct.admin.boards.controller;

import java.io.IOException;
import java.net.URLDecoder;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.admin.boards.service.AdminBoardsServiceImpl;
import kr.or.ddit.tct.admin.boards.service.IAdminBoardsService;
import kr.or.ddit.tct.users.vo.UserVO;

@WebServlet("/admin/boardDelete.do")
public class AdminBoardDeleteController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  // [의미] “글 상태 변경(삭제)”은 DB를 바꾸는 작업이라 POST로만 처리
  // [존재이유] 관리자 UI에서 버튼 누르면 바로 적용되게 하기 위함
  private final IAdminBoardsService service = AdminBoardsServiceImpl.getInstance();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    // [의미] SOFT(비활성) / HARD(영구삭제)
    String mode = req.getParameter("mode");

    // [의미] 어떤 글인지
    String postType = req.getParameter("postType"); // QNA/REVIEW
    int postNo = Integer.parseInt(req.getParameter("postNo"));

    // [의미] 목록 복귀용 back(검색조건 유지)
    String back = req.getParameter("back");
    if (back == null) back = "";

    // [의미] 소프트삭제시 DEL_BY에 “누가 비활성화 했는지” 남기려고 adminId를 쓴다.
    UserVO loginUser = (UserVO)req.getSession().getAttribute("loginUser");
    String adminId = (loginUser == null) ? "" : loginUser.getUserId();

    if ("SOFT".equalsIgnoreCase(mode)) {
      service.softDelete(postType, postNo, adminId);
    } else {
      service.hardDelete(postType, postNo);
    }

    // [의미] 삭제 후에는 “상세”에 남아있기보다 목록으로 보내는 게 관리자 UX가 자연스럽다.
    String listUrl = req.getContextPath() + "/admin/boards.do";
    if (!back.isBlank()) {
      listUrl = listUrl + "?" + URLDecoder.decode(back, "UTF-8");
    }

    resp.sendRedirect(listUrl);
  }
}
