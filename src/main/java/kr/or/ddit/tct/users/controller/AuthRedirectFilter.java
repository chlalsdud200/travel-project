package kr.or.ddit.tct.users.controller;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * 로그인 필요한 페이지 접근 시:
 * 1) RETURN_URL 세션 저장
 * 2) 로그인 페이지로 redirect
 */
@WebFilter("/*")
public class AuthRedirectFilter implements Filter {

  // ✅ 로그인 페이지 매핑
  private static final String LOGIN_PATH = "/login.do";

  // ✅ 세션 로그인 사용자 키(프로젝트에서 쓰는 키와 동일해야 함)
  private static final String LOGIN_USER_KEY = "loginUser";

  // ✅ 돌아갈 주소 저장 키
  private static final String RETURN_URL_KEY = "RETURN_URL";

  @Override
  public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
      throws IOException, ServletException {

    HttpServletRequest req = (HttpServletRequest) request;
    HttpServletResponse resp = (HttpServletResponse) response;

    String ctx = req.getContextPath();
    String uri = req.getRequestURI();                 // ex) /tryCatchTrip/cart/view.do
    String path = uri.substring(ctx.length());        // ex) /cart/view.do

    // 0) 제외 경로(무한루프/정적자원 방지)
    if (isExcluded(path)) {
      chain.doFilter(request, response);
      return;
    }

    // 1) 로그인 필요한 페이지인지 판단
    if (!isProtected(path)) {
      chain.doFilter(request, response);
      return;
    }

    // 2) 로그인 여부 확인
    HttpSession session = req.getSession(false);
    boolean loggedIn = (session != null && session.getAttribute(LOGIN_USER_KEY) != null);

    if (loggedIn) {
      chain.doFilter(request, response);
      return;
    }

    // 3) RETURN_URL 저장 (원래 가려던 페이지)
    String qs = req.getQueryString();
    String returnUrl = uri + (qs != null ? "?" + qs : "");

    // 세션 없으면 생성해서 저장
    req.getSession(true).setAttribute(RETURN_URL_KEY, returnUrl);

    // 4) 로그인 페이지로 이동
    resp.sendRedirect(ctx + LOGIN_PATH);
  }

  /** 로그인/정적 리소스 등 필터 제외 */
  private boolean isExcluded(String path) {
    if (path == null) return true;

    // 로그인 자체는 제외(로그인 페이지로 갔다가 다시 필터 걸리면 무한루프)
    if (path.equals(LOGIN_PATH) || path.startsWith("/login")) return true;

    // 정적 자원 제외
    if (path.startsWith("/assets")) return true;
    if (path.startsWith("/css")) return true;
    if (path.startsWith("/js")) return true;
    if (path.startsWith("/images")) return true;
    if (path.startsWith("/favicon")) return true;

    return false;
  }

  /** 로그인 필요한 페이지 Prefix들 (프로젝트에 맞게 필요시 추가/수정) */
  private boolean isProtected(String path) {
    if (path == null) return false;

    // ✅ 여기서 “로그인 필요” 영역만
    return path.startsWith("/cart/view.do")
        || path.startsWith("/wish/page.do")
        || path.startsWith("/mypage.do")
        || path.startsWith("/payment")
        || path.startsWith("/order");
  }
}
