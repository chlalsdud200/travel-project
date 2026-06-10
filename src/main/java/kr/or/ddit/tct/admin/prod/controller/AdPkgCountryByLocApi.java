package kr.or.ddit.tct.admin.prod.controller;

import java.io.IOException;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import kr.or.ddit.tct.admin.prod.packageitem.service.AdPackageServiceImpl;
import kr.or.ddit.tct.admin.prod.packageitem.service.IAdPackageService;
import kr.or.ddit.tct.comm.dto.CommonApi;
import kr.or.ddit.tct.comm.vo.CountryVO;

@WebServlet("/admin/prod/api/pkg/countryByLoc.do")
public class AdPkgCountryByLocApi extends HttpServlet {

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
      if (locId == null || locId.isBlank()) {
        writeJson(resp, CommonApi.fail("locId가 필요합니다."));
        return;
      }

      CountryVO c = service.getCountryByLoc(locId);
      if (c == null) {
        writeJson(resp, CommonApi.fail("국가 정보를 찾을 수 없습니다."));
        return;
      }

      // CountryVO 그대로 보내도 되지만, 필요한 것만 내려주는게 안전
      writeJson(resp, CommonApi.ok(c));
    } catch (Exception e) {
      resp.setStatus(500);
      writeJson(resp, CommonApi.fail("서버 오류: " + e.getMessage()));
    }
  }
}
