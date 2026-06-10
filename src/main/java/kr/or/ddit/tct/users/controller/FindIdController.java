package kr.or.ddit.tct.users.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.users.service.IUserService;
import kr.or.ddit.tct.users.service.UserServiceImpl;
import oracle.jdbc.proxy.annotation.Post;

@WebServlet("/findId.do")
public class FindIdController extends HttpServlet {
	
	private IUserService service = UserServiceImpl.getService();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
	    // 1) 처음 들어오면 화면만 보여줌
    req.getRequestDispatcher("/WEB-INF/views/login_findId.jsp").forward(req, resp);
  }
  
  
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
   
	   req.setCharacterEncoding("UTF-8");
	  
	// 2) 폼에서 입력값 받기
	   String userName = req.getParameter("userName");
	   String userTel = req.getParameter("userTel");
	  
	  if(userName == null || userName.trim().isEmpty()
	    ||userTel == null || userTel.trim().isEmpty()) {
		  
		  req.setAttribute("msg", "이름과 전화번호를 입력해주세요");
		  req.getRequestDispatcher("/WEB-INF/views/findId.jsp").forward(req, resp);
		  return;
	  }
	  
	  //  여기서 서비스 메소드 호출
	  String foundId = service.findUserIdByNameTel(userName.trim(), userTel.trim());
	  
	  if(foundId == null) {
		  req.setAttribute("msg", "일치하는 회원이 없습니다.");
	  }else {
		  req.setAttribute("foundId", foundId);
	  }
	  
	  req.getRequestDispatcher("/WEB-INF/views/login_findId.jsp").forward(req, resp);
}
}
