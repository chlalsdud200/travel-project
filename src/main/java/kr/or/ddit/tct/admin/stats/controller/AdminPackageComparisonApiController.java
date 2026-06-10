package kr.or.ddit.tct.admin.stats.controller;

import java.io.IOException;
import java.util.ArrayList;
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
import kr.or.ddit.tct.admin.stats.vo.PackageComparisonVO;

@WebServlet("/admin/stats/api/packageComparison.do")
public class AdminPackageComparisonApiController extends HttpServlet {
  private static final long serialVersionUID = 1L;
  private final IPackageSalesService service = PackageSalesServiceImpl.getInstance();
  private final Gson gson = new Gson();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    req.setCharacterEncoding("UTF-8");
    resp.setCharacterEncoding("UTF-8");
    resp.setContentType("application/json; charset=UTF-8");

    // ✅ packageIds 파라미터 받기 (기존 packageTitles 대신)
    String packageIdsStr = nvl(req.getParameter("packageIds"));
    String unit = nvl(req.getParameter("unit"));
    String startDate = nvl(req.getParameter("startDate"));
    String endDate = nvl(req.getParameter("endDate"));

    if (unit.isEmpty()) unit = "MONTH";
    if (startDate.isEmpty()) startDate = "2026-01-01";
    if (endDate.isEmpty()) endDate = "2026-12-31";

    // ✅ packageIds를 List로 변환
    List<String> packageIds = new ArrayList<>();
    if (!packageIdsStr.isEmpty()) {
      String[] arr = packageIdsStr.split(",");
      for (String s : arr) {
        String trimmed = s.trim();
        if (!trimmed.isEmpty()) {
          packageIds.add(trimmed);
        }
      }
    }

    try {
      List<PackageComparisonVO> result = new ArrayList<>();

      // ✅ 개별 패키지별 매출 먼저 조회 (packageIds 사용)
      if (!packageIds.isEmpty()) {
        Map<String, Object> param = new HashMap<>();
        param.put("packageIds", packageIds);  // ✅ packageIds로 전달
        param.put("unit", unit);
        param.put("startDate", startDate);
        param.put("endDate", endDate);

        // ✅ 서비스 메소드 호출 (packageIds 기반)
        List<PackageComparisonVO> packageSales = service.getPackageComparisonByIds(param);
        result.addAll(packageSales);
      }

      // ✅ 전체 총매출 조회
      Map<String, Object> totalParam = new HashMap<>();
      totalParam.put("unit", unit);
      totalParam.put("startDate", startDate);
      totalParam.put("endDate", endDate);
      List<PackageComparisonVO> totalSales = service.getTotalSalesByPeriod(totalParam);
      result.addAll(totalSales);

      resp.getWriter().write(gson.toJson(result));
    } catch (Exception e) {
      e.printStackTrace();
      resp.getWriter().write("[]");
    }
  }

  private static String nvl(String s) {
    return (s == null) ? "" : s.trim();
  }
}