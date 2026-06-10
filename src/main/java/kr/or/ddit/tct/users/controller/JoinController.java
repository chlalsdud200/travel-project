package kr.or.ddit.tct.users.controller;

import java.io.IOException;
import java.util.regex.Pattern;
import org.apache.ibatis.session.SqlSession;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.users.service.IUserService;
import kr.or.ddit.tct.users.service.UserServiceImpl;
import kr.or.ddit.tct.users.vo.UserVO;   // 너희 UsersVO 실제 패키지로 맞춰
import kr.or.ddit.tct.util.MyBatisUtil;

@WebServlet("/join.do")
public class JoinController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IUserService userService = UserServiceImpl.getService();
    private static Pattern pw_rule = Pattern.compile("^(?=.*[A-Za-z])(?=.*\\d).{8,}$");
    // 회원가입 화면 보여주기
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // JSP 경로는 너 프로젝트 구조에 맞게 수정
        // 예: /WEB-INF/views/users/join.jsp
        req.getRequestDispatcher("/WEB-INF/views/join.jsp").forward(req, resp);
    }

    // 회원가입 처리
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        // 1) 파라미터 받기
        String userId    = trim(req.getParameter("userId"));
        String userPass  = trim(req.getParameter("userPass"));
        String userName  = trim(req.getParameter("userName"));
        String userBir   = trim(req.getParameter("userBir"));   // 팀 규칙: String
        String userEmail = trim(req.getParameter("userEmail"));
        String userTel   = trim(req.getParameter("userTel"));
        String userAddr1 = trim(req.getParameter("userAddr1"));
        String userAddr2 = trim(req.getParameter("userAddr2"));
        String userZip   = trim(req.getParameter("userZip"));

        // 2) 최소 필수값 검증
        // DB 기준 NOT NULL: USER_ID, USER_PASS, ROLE, USER_NAME, USER_EMAIL, USER_TEL
        if (isEmpty(userId) || isEmpty(userPass) || isEmpty(userName) || isEmpty(userEmail) || isEmpty(userTel)) {
            req.setAttribute("err", "필수 입력값이 누락되었습니다. (아이디/비밀번호/이름/이메일/전화번호)");
            
            
            
            // 입력값 유지(원하면 더 추가 가능)
            req.setAttribute("f_userId", userId);
            req.setAttribute("f_userName", userName);
            req.setAttribute("f_userBir", userBir);
            req.setAttribute("f_userEmail", userEmail);
            req.setAttribute("f_userTel", userTel);
            req.setAttribute("f_userAddr1", userAddr1);
            req.setAttribute("f_userAddr2", userAddr2);
            req.setAttribute("f_userZip", userZip);

            req.getRequestDispatcher("/WEB-INF/views/join.jsp").forward(req, resp);
            return;
        }
     // ★ 추가: 비밀번호 규칙(영문+숫자 포함 8자 이상)
        if (!pw_rule.matcher(userPass).matches()) {
            req.setAttribute("err", "비밀번호는 영문 + 숫자 조합 8자 이상이어야 합니다.");

            // 입력값 유지(비번은 보안상 유지 X)            
            req.setAttribute("f_userId", userId);
            req.setAttribute("f_userName", userName);
            req.setAttribute("f_userBir", userBir);
            req.setAttribute("f_userEmail", userEmail);
            req.setAttribute("f_userTel", userTel);
            req.setAttribute("f_userAddr1", userAddr1);
            req.setAttribute("f_userAddr2", userAddr2);
            req.setAttribute("f_userZip", userZip);

            req.getRequestDispatcher("/WEB-INF/views/join.jsp").forward(req, resp);
            return;
        }

        // 3) 최종 중복체크(서버에서 반드시 한 번 더)
        int existCnt = userService.existsUserId(userId);
        if (existCnt > 0) {
            req.setAttribute("err", "이미 사용 중인 아이디입니다.");

            // 입력값 유지
            req.setAttribute("f_userId", userId);
            req.setAttribute("f_userName", userName);
            req.setAttribute("f_userBir", userBir);
            req.setAttribute("f_userEmail", userEmail);
            req.setAttribute("f_userTel", userTel);
            req.setAttribute("f_userAddr1", userAddr1);
            req.setAttribute("f_userAddr2", userAddr2);
            req.setAttribute("f_userZip", userZip);

            req.getRequestDispatcher("/WEB-INF/views/join.jsp").forward(req, resp);
            return;
        }
        	

        int verified = 0;
        try (SqlSession session = MyBatisUtil.getSqlSession()) {
          Integer n = session.selectOne("emailVerify.isEmailVerified", userEmail);
          verified = (n == null) ? 0 : n;
        }
        if (verified <= 0) {
        	  req.setAttribute("err", "이메일 인증을 완료한 후 회원가입이 가능합니다.");

        	  req.setAttribute("f_userId", userId);
        	  req.setAttribute("f_userName", userName);
        	  req.setAttribute("f_userBir", userBir);
        	  req.setAttribute("f_userEmail", userEmail);
        	  req.setAttribute("f_userTel", userTel);
        	  req.setAttribute("f_userAddr1", userAddr1);
        	  req.setAttribute("f_userAddr2", userAddr2);
        	  req.setAttribute("f_userZip", userZip);

        	  req.getRequestDispatcher("/WEB-INF/views/join.jsp").forward(req, resp);
        	  return;
        	}


        
        // 4) VO에 담기
        UserVO uv = new UserVO();
        uv.setUserId(userId);
        uv.setUserPass(userPass);     // 지금은 평문. 나중에 해시 권장
        uv.setRole("USER");           // 가입자는 USER 고정
        uv.setUserName(userName);
        uv.setUserBir(userBir);
        uv.setUserEmail(userEmail);
        uv.setUserTel(userTel);
        uv.setUserAddr1(userAddr1);
        uv.setUserAddr2(userAddr2);
        uv.setUserZip(userZip);
        
        
        
        // 5) insert
        int cnt = userService.insertUser(uv);

        // 6) 결과 처리
        if (cnt > 0) {
            // 성공 후 redirect(새로고침 중복 제출 방지)
        	resp.sendRedirect(req.getContextPath() + "/login.do?joined=1&returnUrl=/mainPage.do");
        	// 의미: 회원가입 직후 로그인 성공하면, 다시 회원가입 화면으로 되돌아가지 말고 메인으로 보내기 위한 목적
//        	       (LoginRedirectFilter가 Referer(/join.do) 대신 이 파라미터를 우선 저장하게 됨)

        } else {
            req.setAttribute("err", "회원가입 처리 중 오류가 발생했습니다. 다시 시도해 주세요.");
            req.getRequestDispatcher("/WEB-INF/views/join.jsp").forward(req, resp);
        }
    }

    private String trim(String s) {
        return s == null ? "" : s.trim();
    }

    private boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }
}
