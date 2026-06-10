package kr.or.ddit.tct.sales.wishlist.controller;

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

@WebFilter(urlPatterns = {"/login.do"})
public class LoginRedirectFilter implements Filter {

  // 로그인 성공 후 되돌아갈 주소를 세션에 저장할 때 쓰는 키
  private static final String KEY_RETURN_URL = "RETURN_URL";

  @Override
  public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
      throws IOException, ServletException {

    // 서블릿 요청/응답 객체로 캐스팅(HTTP 기능 사용 목적)
    HttpServletRequest req = (HttpServletRequest) request;
    HttpServletResponse resp = (HttpServletResponse) response;

    // 로그인 화면 요청(GET)일 때만 "복귀 URL 저장" 로직을 태우기 위한 조건
    if ("GET".equalsIgnoreCase(req.getMethod())) {

      // 컨텍스트 경로(/tryCatchTrip) - 내부 경로 검증에 사용 목적
      String ctx = req.getContextPath();

      // 1) 우선순위: 쿼리스트링으로 넘어온 복귀/목적지 파라미터를 먼저 잡기 위한 처리
      //    - JS에서 /login.do?returnUrl=... 로 보내는 케이스 지원 목적
      //    - header에서 /login.do?target=... 로 보내는 케이스 지원 목적
      String urlFromParam = firstNotBlank(
          req.getParameter("returnUrl"),
          req.getParameter("return"),
          req.getParameter("target")
      );

      // 2) 파라미터가 없으면 Referer(직전 페이지)로 복귀 주소를 잡기 위한 처리
      String urlFromReferer = req.getHeader("Referer");

      // 3) 둘 중 하나를 골라서 내부경로로 정규화(외부 URL 차단 + ctx 붙이기 목적)
      String candidate = (urlFromParam != null) ? urlFromParam : urlFromReferer;
      String returnUrl = normalizeInternalUrl(ctx, candidate);

      // 4) 내부 경로로 유효하면 세션에 저장(로그인 성공 후 복귀 목적)
      if (isValidInternalReturnUrl(ctx, returnUrl)) {
        HttpSession session = req.getSession(true);
        session.setAttribute(KEY_RETURN_URL, returnUrl);
      }

      // 5) 이미 로그인 상태인데 /login.do를 다시 요청하면,
      //    - 로그인 화면을 보여줄 이유가 없으니 "복귀 URL 또는 메인"으로 보내기 위한 처리
      HttpSession session = req.getSession(false);
      if (session != null && session.getAttribute("loginUser") != null) {

        String saved = (String) session.getAttribute(KEY_RETURN_URL);

        // 저장된 값이 유효하면 그곳으로, 없거나 이상하면 메인으로 보내기 위한 처리
        if (isValidInternalReturnUrl(ctx, saved)) {
          session.removeAttribute(KEY_RETURN_URL); // 한 번 쓰고 지워서 다음 요청에 영향 없게 하기 위한 처리
          resp.sendRedirect(saved);
          return;
        }

        resp.sendRedirect(ctx + "/mainPage.do");
        return;
      }
    }

    // 나머지는 정상 진행(로그인 화면 렌더링, 로그인 POST 처리 등)
    chain.doFilter(request, response);
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

    // login.do로 다시 가는 값은 저장/복귀할 필요가 없어서 초기에 걸러두기 위한 처리
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
