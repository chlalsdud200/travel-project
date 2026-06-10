package kr.or.ddit.tct.admin.prod.controller;

import java.io.IOException;
import java.util.HashMap;
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
import kr.or.ddit.tct.comm.vo.CountryVO;
import kr.or.ddit.tct.product.hotels.vo.HotelsVO;

// 서비스 경로는 네 프로젝트에 맞게 수정

@WebServlet("/admin/prod/api/pkg/*")
public class AdProductsApiController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  private final Gson gson = new Gson();
  private final IAdPackageService service = AdPackageServiceImpl.getInstance();

  private static String s(Object v) { return v == null ? "" : String.valueOf(v).trim(); }

  private void writeJson(HttpServletResponse resp, Object obj) throws IOException {
    resp.setContentType("application/json;charset=UTF-8");
    resp.getWriter().write(gson.toJson(obj));
  }

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    String path = req.getPathInfo();
    if (path == null) path = "";

    try {
      switch (path) {

        // ✅ 지역 -> 국가 자동 지정
        case "/countryByLoc.do": {
          String locId = s(req.getParameter("locId"));
          if (locId.isBlank()) {
            writeJson(resp, CommonApi.fail("locId가 필요합니다."));
            return;
          }

          CountryVO c = service.getCountryByLoc(locId);
          if (c == null) {
            writeJson(resp, CommonApi.fail("해당 지역의 국가 정보를 찾을 수 없습니다."));
            return;
          }

          Map<String, Object> data = new HashMap<>();
          data.put("ctryId", c.getCtryId());
          data.put("ctryName", c.getCtryName());

          writeJson(resp, CommonApi.ok(data));
          return;
        }

        // ✅ 지역 -> 호텔 목록
        case "/hotelsByLoc.do": {
          String locId = s(req.getParameter("locId"));
          if (locId.isBlank()) {
            writeJson(resp, CommonApi.fail("locId가 필요합니다."));
            return;
          }

          List<HotelsVO> list = service.getHotelsByLoc(locId);
          writeJson(resp, CommonApi.ok(list));
          return;
        }

        // ✅ PACKAGE_ID 미리 생성
        case "/nextPkgId.do": {
          String locId = s(req.getParameter("locId"));
          String themeId = s(req.getParameter("themeId"));

          if (locId.isBlank() || themeId.isBlank()) {
            writeJson(resp, CommonApi.fail("locId/themeId가 필요합니다."));
            return;
          }

          String pkgId = service.getNextPkgId(locId, themeId);
          if (pkgId == null || pkgId.isBlank()) {
            writeJson(resp, CommonApi.fail("pkgId 생성 실패"));
            return;
          }

          writeJson(resp, CommonApi.ok(Map.of("pkgId", pkgId)));
          return;
        }

        default:
          resp.setStatus(404);
          writeJson(resp, CommonApi.fail("Unknown API: " + path));
      }
    } catch (Exception e) {
      resp.setStatus(500);
      writeJson(resp, CommonApi.fail("서버 오류: " + e.getMessage()));
    }
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    String path = req.getPathInfo();
    if (path == null) path = "";

    try {
      switch (path) {

        // ✅ PACKAGES 생성
        case "/create.do": {
          @SuppressWarnings("unchecked")
          Map<String, Object> body = gson.fromJson(req.getReader(), Map.class);

          String packageTitle = s(body.get("packageTitle"));
          String locId = s(body.get("locId"));
          String themeId = s(body.get("themeId"));

          if (packageTitle.isBlank()) {
            writeJson(resp, CommonApi.fail("packageTitle이 필요합니다."));
            return;
          }
          if (locId.isBlank() || themeId.isBlank()) {
            writeJson(resp, CommonApi.fail("locId/themeId가 필요합니다."));
            return;
          }

          String createdPkgId = service.createPackage(packageTitle, locId, themeId);
          if (createdPkgId == null || createdPkgId.isBlank()) {
            writeJson(resp, CommonApi.fail("패키지 생성 실패"));
            return;
          }

          writeJson(resp, CommonApi.ok(Map.of("pkgId", createdPkgId)));
          return;
        }

        default:
          resp.setStatus(404);
          writeJson(resp, CommonApi.fail("Unknown API: " + path));
      }

    } catch (Exception e) {
      resp.setStatus(500);
      writeJson(resp, CommonApi.fail("서버 오류: " + e.getMessage()));
    }
  }
}
