package kr.or.ddit.tct.admin.prod.controller;

import java.io.IOException;
import java.util.Map;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import kr.or.ddit.tct.admin.prod.packageitem.service.AdPackageServiceImpl;
import kr.or.ddit.tct.admin.prod.packageitem.service.IAdPackageService;
import kr.or.ddit.tct.comm.dto.CommonApi;

@WebServlet("/admin/prod/api/pkg/nextPkgId.do")
public class AdPkgNextPkgIdApi extends HttpServlet {

  private static final long serialVersionUID = 1L;

  private final Gson gson = new Gson();
  private final IAdPackageService service = AdPackageServiceImpl.getInstance();

  private void writeJson(HttpServletResponse resp, Object obj) throws IOException {
    resp.setContentType("application/json;charset=UTF-8");
    resp.getWriter().write(gson.toJson(obj));
  }

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    try {
      String locId = req.getParameter("locId");
      String themeId = req.getParameter("themeId");

      if (locId == null || locId.isBlank() || themeId == null || themeId.isBlank()) {
        writeJson(resp, CommonApi.fail("locId/themeId가 필요합니다."));
        return;
      }

      String pkgId = service.getNextPkgId(locId, themeId);
      if (pkgId == null || pkgId.isBlank()) {
        writeJson(resp, CommonApi.fail("pkgId 생성 실패"));
        return;
      }

      writeJson(resp, CommonApi.ok(Map.of("pkgId", pkgId)));
    } catch (Exception e) {
      resp.setStatus(500);
      writeJson(resp, CommonApi.fail("서버 오류: " + e.getMessage()));
    }
  }
}
