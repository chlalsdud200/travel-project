package kr.or.ddit.tct.admin.stats.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.admin.stats.service.ISalesMonthlyService;
import kr.or.ddit.tct.admin.stats.service.SalesMonthlyServiceImpl;
import kr.or.ddit.tct.admin.stats.vo.SalesKpiVO;
import kr.or.ddit.tct.admin.stats.vo.SalesPointVO;

@WebServlet("/admin/stats/api/sales.do")
public class AdminSalesMonthlyApiController extends HttpServlet {

  private final ISalesMonthlyService service = SalesMonthlyServiceImpl.getInstance();
  private final Gson gson = new Gson();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

    resp.setContentType("application/json; charset=UTF-8");
    resp.setCharacterEncoding("UTF-8");

    try {
      Map<String, String> param = buildParam(req);

      // 1) KPI (검색 기간 기준)
      SalesKpiVO kpi = service.getSalesKpi(param);

      // 2) Timeline (기간+unit 기준)
      List<SalesPointVO> timeline = service.getSalesTimeline(param);

      // 3) 응답 구성
      Map<String, Object> response = new HashMap<>();
      
      // meta 정보
      Map<String, String> meta = new HashMap<>();
      meta.put("year", param.get("year"));
      meta.put("unit", param.get("unit"));
      meta.put("startDate", param.get("startDate"));
      meta.put("endDate", param.get("endDate"));
      response.put("meta", meta);
      
      // kpi 데이터
      response.put("kpi", kpi);
      
      // timeline 데이터
      response.put("timeline", timeline);

      // JSON 응답
      String json = gson.toJson(response);
      
      resp.setStatus(200);
      resp.getWriter().write(json);

    } catch (Exception e) {
      e.printStackTrace();
      resp.setStatus(500);
      
      Map<String, String> error = new HashMap<>();
      error.put("error", "API_ERROR");
      error.put("message", e.getMessage() != null ? e.getMessage() : "Unknown error");
      
      resp.getWriter().write(gson.toJson(error));
    }
  }

  // 파라미터 기본값 세팅
  private Map<String, String> buildParam(HttpServletRequest req) {
    Map<String, String> p = new HashMap<>();

    String year = nvl(req.getParameter("year"), String.valueOf(LocalDate.now().getYear()));
    String unit = nvl(req.getParameter("unit"), "MONTH"); // MONTH/DAY

    String startDate = req.getParameter("startDate");
    String endDate = req.getParameter("endDate");

    // 날짜가 없으면 연도 기준으로 자동 세팅
    if (isBlank(startDate) || isBlank(endDate)) {
      startDate = year + "-01-01";
      endDate   = year + "-12-31";
    }

    p.put("year", year);
    p.put("unit", unit);
    p.put("startDate", startDate);
    p.put("endDate", endDate);

    return p;
  }

  private boolean isBlank(String s) {
    return s == null || s.trim().isEmpty();
  }

  private String nvl(String s, String def) {
    return (s == null || s.trim().isEmpty()) ? def : s.trim();
  }
}