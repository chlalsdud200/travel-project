package kr.or.ddit.tct.admin.prod.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.comm.dto.CommonApi;
import kr.or.ddit.tct.util.MyBatisUtil;

@WebServlet("/admin/prod/api/pkg/hotels.do")
public class AdPkgHotelsApiController extends HttpServlet {

  private static final long serialVersionUID = 1L;
  private final Gson gson = new Gson();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    req.setCharacterEncoding("UTF-8");
    resp.setContentType("application/json;charset=UTF-8");

    String keyword = req.getParameter("keyword");
    String limitStr = req.getParameter("limit");

    int limit = 30;
    try {
      if (limitStr != null && !limitStr.isBlank()) limit = Integer.parseInt(limitStr);
    } catch (Exception ignore) {}

    // limit 방어
    if (limit < 1) limit = 1;
    if (limit > 100) limit = 100;

    Map<String, Object> param = new HashMap<>();
    param.put("keyword", (keyword == null) ? "" : keyword.trim());
    param.put("limit", limit);

    try (SqlSession session = MyBatisUtil.getSqlSession()) {

      // ✅ adPackageMapper에 등록한 id 사용
      // namespace는 네 mapper의 namespace로 맞춰줘
      // 예) "adPackage.adSearchHotels" / "adPackageMapper.adSearchHotels" 등
      List<Map<String, Object>> list =
          session.selectList("adPackageMapper.adSearchHotels", param);

      CommonApi ok = CommonApi.ok(list);
      resp.getWriter().write(gson.toJson(ok));

    } catch (Exception e) {
      e.printStackTrace();
      resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      resp.getWriter().write(gson.toJson(CommonApi.fail("호텔 목록 조회 실패")));
    }
  }
}
