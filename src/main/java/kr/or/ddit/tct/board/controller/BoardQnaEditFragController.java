package kr.or.ddit.tct.board.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.users.vo.UserVO;


// qna 수정화면
@WebServlet("/boardQnaEditFrag.do") // 수정 fragment를 주입할 때 호출하는 주소
public class BoardQnaEditFragController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    UserVO loginUser = (UserVO) req.getSession().getAttribute("loginUser"); // 세션에서 로그인 사용자 꺼내기
    if (loginUser == null) { // 로그인 안 했으면 수정 화면을 주입하지 않고 로그인으로 보냄
      resp.sendRedirect(req.getContextPath() + "/login.do"); // login.jsp 전체가 fragment에 끼어드는 걸 막기 위한 redirect
      return; // 여기서 종료
    }

    req.getRequestDispatcher("/WEB-INF/views/board/board_qna_edit_frag.jsp") // 수정 조각 화면으로 포워딩
       .forward(req, resp);
  }
}
