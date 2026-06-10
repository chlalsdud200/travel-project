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
import kr.or.ddit.tct.admin.stats.vo.PackageRegItemVO;

@WebServlet("/admin/stats/api/packageRegList.do")
public class AdminPackageRegListApiController extends HttpServlet {
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

    // ✅ 추가: 기간/정렬
    String startDate = nvl(req.getParameter("startDate"));
    String endDate   = nvl(req.getParameter("endDate"));
    String sort      = nvl(req.getParameter("sort")); // SALES_DESC / SALES_ASC / DATE_DESC

    if (sort.isEmpty()) sort = "SALES_DESC";

    Map<String, Object> param = new HashMap<>();
    param.put("packageId", packageId);
    param.put("startDate", startDate);
    param.put("endDate", endDate);
    param.put("sort", sort);

    try {
      List<PackageRegItemVO> list = service.getPackageRegList(param);
      resp.setStatus(HttpServletResponse.SC_OK);
      resp.getWriter().write(gson.toJson(list));
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
