package kr.or.ddit.tct.admin.prod.controller;

import java.io.IOException;

import com.google.gson.Gson;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import kr.or.ddit.tct.admin.prod.packageitem.dto.AdRegPackageItemDto;
import kr.or.ddit.tct.admin.prod.packageitem.service.AdRegPackageItemServiceImpl;
import kr.or.ddit.tct.admin.prod.packageitem.service.IAdRegPackageItemService;
import kr.or.ddit.tct.comm.dto.CommonApi;

@WebServlet("/admin/prod/reg/pkgItems.do")
public class AdRegPackageItemController extends HttpServlet {

  private static final long serialVersionUID = 1L;

  private final Gson gson = new Gson();
  private final IAdRegPackageItemService service = AdRegPackageItemServiceImpl.getInstance();
  
  @Override
  public void init() {
    System.out.println("[AdRegPackageItemController] LOADED /admin/prod/reg/pkgItems.do");
  }

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    resp.setContentType("application/json; charset=UTF-8");

    String regId = req.getParameter("regId");
    if (regId == null || regId.isBlank()) {
      resp.getWriter().write(gson.toJson(CommonApi.fail("regId가 필요합니다.")));
      return;
    }

    try {
      AdRegPackageItemDto data = service.selectByRegId(regId.trim());
      if (data == null || data.getHeader() == null) {
        resp.getWriter().write(gson.toJson(CommonApi.fail("조회 결과가 없습니다.")));
        return;
      }

      resp.getWriter().write(gson.toJson(CommonApi.ok(data)));
    } catch (Exception e) {
      // 서버 콘솔에서 원인 확인 가능하게 로그도 찍자
      e.printStackTrace();
      resp.getWriter().write(gson.toJson(CommonApi.fail("조회 실패: " + e.getMessage())));
    }
  }

}
