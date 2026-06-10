package kr.or.ddit.tct.admin.stats.controller;

import java.io.IOException;
import java.util.*;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import kr.or.ddit.tct.admin.stats.service.IPackageSalesService;
import kr.or.ddit.tct.admin.stats.service.PackageSalesServiceImpl;
import kr.or.ddit.tct.admin.stats.vo.RegCompareRowVO;

@WebServlet("/admin/stats/api/packageRegCompare.do")
public class AdminPackageRegCompareApiController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  private final IPackageSalesService service = PackageSalesServiceImpl.getInstance();
  private final Gson gson = new Gson();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    req.setCharacterEncoding("UTF-8");
    resp.setCharacterEncoding("UTF-8");
    resp.setContentType("application/json; charset=UTF-8");

    String packageId = nvl(req.getParameter("packageId"));
    String unit = nvl(req.getParameter("unit"));
    String startDate = nvl(req.getParameter("startDate"));
    String endDate = nvl(req.getParameter("endDate"));

    String regIdsCsv = nvl(req.getParameter("regIds")); // "20260131_01,20260121_05"
    List<String> regIds = new ArrayList<>();
    if (!regIdsCsv.isEmpty()) {
      for (String x : regIdsCsv.split(",")) {
        String v = x.trim();
        if (!v.isEmpty()) regIds.add(v);
      }
    }

    Map<String, Object> param = new HashMap<>();
    param.put("packageId", packageId);
    param.put("unit", unit); // DAY / WEEK / MONTH
    param.put("startDate", startDate);
    param.put("endDate", endDate);
    param.put("regIds", regIds);

    try {
      List<RegCompareRowVO> rows = service.getPackageRegCompare(param);
      resp.setStatus(HttpServletResponse.SC_OK);
      resp.getWriter().write(gson.toJson(rows));
      return;
    } catch (Exception e) {
      e.printStackTrace();
      resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      resp.getWriter().write("[]");
      return;
    }
  }

  private static String nvl(String s) {
    return (s == null) ? "" : s.trim();
  }
}
