package kr.or.ddit.tct.admin.prod.query.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import kr.or.ddit.tct.admin.prod.query.service.AdPkgQueryServiceImpl;
import kr.or.ddit.tct.admin.prod.query.service.IAdPkgQueryService;
import kr.or.ddit.tct.product.pkg.vo.PkgVO;

@WebServlet("/admin/prod/api/packages.do")
public class AdPkgSuggestApi extends HttpServlet {

  private final Gson gson = new Gson();
  private final IAdPkgQueryService service = AdPkgQueryServiceImpl.getInstance();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    req.setCharacterEncoding("UTF-8");
    resp.setCharacterEncoding("UTF-8");
    resp.setContentType("application/json;charset=UTF-8");

    String q = req.getParameter("q");
    if (q != null) q = q.trim();

    int limit = 20;
    try {
      String sLimit = req.getParameter("limit");
      if (sLimit != null && !sLimit.isBlank()) limit = Math.min(50, Math.max(1, Integer.parseInt(sLimit)));
    } catch (Exception ignore) {}

    try {
      List<PkgVO> list = service.searchPkgSuggest(q, limit);

      Map<String, Object> out = new HashMap<>();
      out.put("ok", true);
      out.put("data", list);

      resp.getWriter().write(gson.toJson(out));
    } catch (Exception e) {
      e.printStackTrace();

      Map<String, Object> out = new HashMap<>();
      out.put("ok", false);
      out.put("message", "패키지 목록 조회 실패");

      resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      resp.getWriter().write(gson.toJson(out));
    }
  }
}
