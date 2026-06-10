package kr.or.ddit.tct.users.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import kr.or.ddit.tct.users.service.IUserService;
import kr.or.ddit.tct.users.service.UserServiceImpl;
import kr.or.ddit.tct.users.vo.UserVO;

@WebServlet("/login.do")
public class LoginController extends HttpServlet {

  private static final long serialVersionUID = 1L;

  // 로그인 비즈니스 로직(아이디/비번 검증)을 호출하기 위한 서비스 객체
  private IUserService service = UserServiceImpl.getService();

  // 로그인 성공 후 되돌아갈 주소를 세션에서 꺼낼 때 쓰는 키
  private static final String KEY_RETURN_URL = "RETURN_URL";

  // 로그인 화면 보여주기
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    // /WEB-INF 아래 JSP는 직접 접근이 불가하므로, 서블릿이 포워드로 화면을 띄우기 위한 처리
    req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
  }

  // 로그인 처리
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    // POST 파라미터 한글 깨짐 방지 목적
    req.setCharacterEncoding("UTF-8");

    // 로그인 폼에서 입력한 아이디/비밀번호를 받기 위한 처리
    String userId = req.getParameter("userId");
    String userPass = req.getParameter("userPass");

    // 서비스로 로그인 검증(성공 시 UserVO, 실패 시 null)하기 위한 처리
    UserVO uvo = service.login(userId, userPass);

    // 로그인 실패면 다시 로그인 페이지를 보여주고 메시지를 출력하기 위한 처리
    if (uvo == null) {
      req.setAttribute("msg", "아이디 또는 비밀번호가 올바르지 않습니다.");
      req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
      return;
    }

    // 로그인 성공: 세션에 로그인 사용자 정보를 저장해서 "로그인 상태"를 유지하기 위한 처리
    HttpSession session = req.getSession();
    session.setAttribute("loginUser", uvo);

    // 컨텍스트 경로(/tryCatchTrip) - 내부 경로 검증/정규화에 사용 목적
    String ctx = req.getContextPath();

    // 1) (선택) POST에 target/returnUrl이 실려오는 경우를 대비해서 먼저 읽기 위한 처리
    //    - 현재 login.jsp는 hidden이 없어서 보통 null이지만, 나중에 확장 가능한 형태로 둠
    String paramUrl = firstNotBlank(
        req.getParameter("returnUrl"),
        req.getParameter("return"),
        req.getParameter("target")
    );

    // 2) 기본은 세션에 저장해둔 RETURN_URL(필터에서 저장)로 복귀시키기 위한 처리
    String sessionUrl = (String) session.getAttribute(KEY_RETURN_URL);

    // 3) 실제로 사용할 복귀 URL을 결정(파라미터 우선, 없으면 세션)하기 위한 처리
    String returnUrl = (paramUrl != null) ? paramUrl : sessionUrl;

    // 4) 한 번 쓰면 제거해서 다음 로그인 시 엉뚱한 곳으로 가는 사고를 막기 위한 처리
    session.removeAttribute(KEY_RETURN_URL);

    // 5) returnUrl이 절대 URL이어도 내부 경로로 잘라내고(ctx 붙이고) 통일하기 위한 처리
    returnUrl = normalizeInternalUrl(ctx, returnUrl);

    // 6) 내부 경로로 유효하면 그곳으로 보내고, 아니면 메인으로 보내기 위한 처리
    if (isValidInternalReturnUrl(ctx, returnUrl)) {
      resp.sendRedirect(returnUrl);
      return;
    }

    // 복귀 목적지가 없거나 이상하면 기본은 메인으로 이동
    resp.sendRedirect(ctx + "/mainPage.do");
  }

  private String firstNotBlank(String... arr) {
    if (arr == null) return null;
    for (String s : arr) {
      if (s != null && !s.trim().isEmpty()) return s.trim();
    }
    return null;
  }

  // 절대 URL(http://...)이 들어오거나 ctx 없는 경로(/wish/page.do)가 들어와도
  // "/tryCatchTrip/..." 형태의 내부 경로로 통일하기 위한 처리
  private String normalizeInternalUrl(String ctx, String url) {
    if (url == null) return null;

    url = url.trim();
    if (url.isEmpty()) return null;

    // login.do로 다시 가는 값은 복귀 대상으로 쓰면 루프가 될 수 있어 차단 목적
    if (url.contains("/login.do")) return null;

    // 절대 URL인 경우에도 "/tryCatchTrip/..."부터 잘라 내부 경로로 만들기 위한 처리
    int idx = url.indexOf(ctx + "/");
    if (idx >= 0) {
      url = url.substring(idx); // "/tryCatchTrip/...."
    }

    // "/wish/page.do"처럼 ctx 없이 들어오면 ctx를 붙여 내부 경로로 맞추기 위한 처리
    if (url.startsWith("/") && !url.startsWith(ctx + "/")) {
      url = ctx + url; // "/tryCatchTrip/wish/page.do"
    }

    return url;
  }

  // 내부 URL만 허용해서 오픈리다이렉트(외부 사이트로 튀는 문제) 방지 목적
  private boolean isValidInternalReturnUrl(String ctx, String url) {
    if (url == null) return false;
    if (url.trim().isEmpty()) return false;

    // 반드시 "/tryCatchTrip/..."로 시작해야 내부 경로로 인정하기 위한 처리
    if (!url.startsWith(ctx + "/")) return false;

    // login.do로 복귀하면 무한루프가 될 수 있으니 차단 목적
    if (url.contains("/login.do")) return false;

    return true;
  }
}
