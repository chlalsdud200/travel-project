package kr.or.ddit.tct.admin.stats.controller;

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

import kr.or.ddit.tct.admin.stats.service.IPackageSalesService;
import kr.or.ddit.tct.admin.stats.service.PackageSalesServiceImpl;
import kr.or.ddit.tct.admin.stats.vo.PackageSalesResponseVO;
import kr.or.ddit.tct.admin.stats.vo.PackageSalesRowVO;

@WebServlet("/admin/stats/api/packageSales.do")
public class AdminPackageSalesApiController extends HttpServlet {

  private static final long serialVersionUID = 1L;

  private final IPackageSalesService service = PackageSalesServiceImpl.getInstance();
  private final Gson gson = new Gson();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    req.setCharacterEncoding("UTF-8");
    resp.setCharacterEncoding("UTF-8");
    resp.setContentType("application/json; charset=UTF-8");

    String packageTitle = nvl(req.getParameter("packageTitle"));
    String startDate = nvl(req.getParameter("startDate"));
    String endDate   = nvl(req.getParameter("endDate"));

    int page = parseInt(req.getParameter("page"), 1);
    int size = parseInt(req.getParameter("size"), 8);

    PackageSalesResponseVO out = new PackageSalesResponseVO();
    out.setPage(page);
    out.setSize(size);

    if (packageTitle.isEmpty()) {
      out.setTotalCount(0);
      out.setList(List.of());
      resp.getWriter().write(gson.toJson(out));
      return;
    }

    if (startDate.isEmpty()) startDate = "2020-01-01";
    if (endDate.isEmpty()) endDate = "2099-12-31";

    Map<String, Object> param = new HashMap<>();
    param.put("packageTitle", packageTitle);
    param.put("startDate", startDate);
    param.put("endDate", endDate);
    param.put("page", page);
    param.put("size", size);

    try {
      int totalCount = service.getPackageSalesCount(param);
      List<PackageSalesRowVO> list = service.getPackageSalesList(param);

      out.setTotalCount(totalCount);
      out.setList(list);

      resp.getWriter().write(gson.toJson(out));
      
    } catch (Exception e) {
      e.printStackTrace();
      
      out.setTotalCount(0);
      out.setList(List.of());
      resp.getWriter().write(gson.toJson(out));
    }
  }

  private static String nvl(String s) {
    return (s == null) ? "" : s.trim();
  }

  private static int parseInt(String s, int def) {
    try { return Integer.parseInt(s); }
    catch (Exception e) { return def; }
  }
}