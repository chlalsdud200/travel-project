package kr.or.ddit.tct.admin.prod.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.admin.prod.packageitem.service.AdPackageServiceImpl;
import kr.or.ddit.tct.admin.prod.packageitem.service.IAdPackageService;
import kr.or.ddit.tct.comm.dto.CommonApi;

@WebServlet("/admin/prod/api/pkg/createAll.do")
public class AdPkgCreateAllApiController extends HttpServlet {

  private static final long serialVersionUID = 1L;

  private final Gson gson = new Gson();
  private final IAdPackageService service = AdPackageServiceImpl.getInstance();

  private void writeJson(HttpServletResponse resp, Object obj) throws IOException {
    resp.setContentType("application/json;charset=UTF-8");
    resp.getWriter().write(gson.toJson(obj));
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    try {
      // 요청 JSON:
      // { packageTitle, locId, themeId, items:[{byDate,hotelId,itemId}, ...] }
      @SuppressWarnings("unchecked")
      Map<String, Object> body = gson.fromJson(req.getReader(), Map.class);

      String packageTitle = body.get("packageTitle") == null ? "" : String.valueOf(body.get("packageTitle")).trim();
      String locId        = body.get("locId") == null ? "" : String.valueOf(body.get("locId")).trim();
      String themeId      = body.get("themeId") == null ? "" : String.valueOf(body.get("themeId")).trim();

      @SuppressWarnings("unchecked")
      List<Map<String, Object>> items = (List<Map<String, Object>>) body.get("items");

      String pkgId = service.createPackageWithItems(packageTitle, locId, themeId, items);

      writeJson(resp, CommonApi.ok(Map.of("pkgId", pkgId)));

    } catch (Exception e) {
      resp.setStatus(500);
      writeJson(resp, CommonApi.fail("저장 실패: " + (e.getMessage() == null ? "unknown" : e.getMessage())));
    }
  }
}
