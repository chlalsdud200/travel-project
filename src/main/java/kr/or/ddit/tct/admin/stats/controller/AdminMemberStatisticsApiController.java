package kr.or.ddit.tct.admin.stats.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.admin.stats.service.IMemberStatisticsService;
import kr.or.ddit.tct.admin.stats.service.MemberStatisticsServiceImpl;
import kr.or.ddit.tct.admin.stats.vo.DistItemVO;

@WebServlet("/admin/stats/api/members.do")
public class AdminMemberStatisticsApiController extends HttpServlet {

  private static final long serialVersionUID = 1L;

  private final IMemberStatisticsService service = MemberStatisticsServiceImpl.getInstance();

  // "2026-01-01" 형태만 허용
  private static final DateTimeFormatter F = DateTimeFormatter.ofPattern("yyyy-MM-dd");

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

    // 1) 파라미터 읽기
    String yearStr = nvl(req.getParameter("year"), String.valueOf(LocalDate.now().getYear()));
    String unit = upper(nvl(req.getParameter("unit"), "MONTH"));
    String type = lower(nvl(req.getParameter("type"), "all"));

    String startDate = req.getParameter("startDate");
    String endDate = req.getParameter("endDate");

    // 2) 날짜 기본값 세팅(없으면 year 기준)
    if (isBlank(startDate) || isBlank(endDate)) {
      int year = parseIntSafe(yearStr, LocalDate.now().getYear());
      startDate = LocalDate.of(year, 1, 1).format(F);
      endDate   = LocalDate.of(year, 12, 31).format(F);
    } else {
      startDate = normalizeDate(startDate);
      endDate   = normalizeDate(endDate);
    }

    // 3) mapper로 넘길 param (key 이름이 mapper #{...}와 정확히 일치해야 함)
    Map<String, Object> param = new HashMap<>();
    param.put("startDate", startDate);
    param.put("endDate", endDate);
    param.put("unit", unit);
    param.put("type", type);

    // 4) 서비스 호출
    Map<String, Object> data = service.getMemberStatsDashboard(param);

    // ✅ 추가: 회원상태 3분류 도넛 결과도 data에 합치기
    List<DistItemVO> distMemberStatus3 = service.distMemberStatus3(param);
    data.put("distMemberStatus3", distMemberStatus3);

    // 5) JSON 응답
    resp.setCharacterEncoding("UTF-8");
    resp.setContentType("application/json; charset=UTF-8");

    try (PrintWriter out = resp.getWriter()) {
      out.print(new Gson().toJson(data));
    }
  }

  // 입력이 '2026-1-1' 같이 들어오면 '2026-01-01'로 정규화
  private static String normalizeDate(String s) {
    LocalDate d = LocalDate.parse(s.trim(), F);
    return d.format(F);
  }

  private static String nvl(String s, String def) { return (s == null) ? def : s; }
  private static boolean isBlank(String s) { return s == null || s.trim().isEmpty(); }
  private static String upper(String s) { return (s == null) ? null : s.toUpperCase(); }
  private static String lower(String s) { return (s == null) ? null : s.toLowerCase(); }

  private static int parseIntSafe(String s, int def) {
    try { return Integer.parseInt(s); } catch (Exception e) { return def; }
  }
}
