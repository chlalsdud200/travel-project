package kr.or.ddit.tct.admin.prod.controller;

import java.io.IOException;
import java.util.List;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.admin.prod.packageitem.service.AdPackageServiceImpl;
import kr.or.ddit.tct.admin.prod.packageitem.service.IAdPackageService;
import kr.or.ddit.tct.comm.dto.CommonApi;
import kr.or.ddit.tct.product.item.vo.ItemVO;

@WebServlet("/admin/prod/api/pkg/items.do")
public class AdPackageApiItemsController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  private final Gson gson = new Gson();
  private final IAdPackageService service = AdPackageServiceImpl.getInstance();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    resp.setContentType("application/json; charset=UTF-8");

    String keyword = req.getParameter("keyword"); // 없으면 전체(상위 N개)
    int limit = 30;
    try {
      String sLimit = req.getParameter("limit");
      if (sLimit != null && !sLimit.isBlank()) limit = Integer.parseInt(sLimit);
    } catch (Exception e) {
      limit = 30;
    }

    try {
      List<ItemVO> list = service.getItemList(keyword, limit);
      resp.getWriter().write(gson.toJson(CommonApi.ok(list)));
    } catch (Exception e) {
      resp.setStatus(500);
      resp.getWriter().write(gson.toJson(CommonApi.fail("아이템 목록 조회 실패: " + e.getMessage())));
    }
  }
}
