package kr.or.ddit.tct.admin.prod.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.admin.prod.item.service.AdItemServiceImpl;
import kr.or.ddit.tct.admin.prod.item.service.IAdItemService;
import kr.or.ddit.tct.admin.prod.item.vo.ItemVO;
import kr.or.ddit.tct.admin.prod.packageitem.service.AdPackageServiceImpl;
import kr.or.ddit.tct.admin.prod.packageitem.service.IAdPackageService;
import kr.or.ddit.tct.admin.prod.reg.service.AdRegProdServiceImpl;
import kr.or.ddit.tct.admin.prod.reg.service.IAdRegProdService;
import kr.or.ddit.tct.product.regProd.vo.RegProdVO;


// 등록상품 관리, 패키지 관리, 아이템 관리 탭 클릭시 화면을 뿌려주는 컨트롤러 
@WebServlet("/admin/prod/adminProducts.do")
public class AdProducts extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String tab = req.getParameter("tab");
		if (tab == null || tab.isBlank()) {
			tab = "list";
		}

		req.setAttribute("adminActive", "products");
		req.setAttribute("tab", tab);

		if ("list".equals(tab)) {
			IAdRegProdService service = AdRegProdServiceImpl.getInstance();
			List<RegProdVO> regList = service.adSelectRegProdAll();

			req.setAttribute("regList", regList);
			req.setAttribute("totalCount", regList == null ? 0 : regList.size());

		} else if ("create".equals(tab)) {
			// 제구역입니다
			IAdPackageService pkgSvc = AdPackageServiceImpl.getInstance();
			req.setAttribute("locationList", pkgSvc.getLocationList());
			req.setAttribute("pThemeList", pkgSvc.getPThemeList());

		} else if ("create_item".equals(tab)) {
			// 지금은 분기만 만들어두고 JSP에서 tab 값으로 화면만 바뀌게.
			// 아이템 생성 화면에서 지역/테마 드롭다운 필요하면 패키지 서비스 재사용
		    IAdPackageService pkgSvc = AdPackageServiceImpl.getInstance();
		    req.setAttribute("locationList", pkgSvc.getLocationList());
		    req.setAttribute("pThemeList", pkgSvc.getPThemeList());

		    // 아이템 목록 조회 (아이템 관리 탭에서 리스트 보이게)
		    IAdItemService itemSvc = AdItemServiceImpl.getInstance();
		    List<ItemVO> itemList = itemSvc.getItemAll();

		    req.setAttribute("itemList", itemList);
		    req.setAttribute("itemTotalCount", itemList == null ? 0 : itemList.size());
			
		}

		req.getRequestDispatcher("/WEB-INF/views/admin/adminProducts.jsp").forward(req, resp);
	}
}
