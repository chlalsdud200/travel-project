package kr.or.ddit.tct.admin.prod.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.admin.prod.item.service.AdItemServiceImpl;
import kr.or.ddit.tct.admin.prod.item.service.IAdItemService;
import kr.or.ddit.tct.admin.prod.item.vo.ItemVO;

import java.io.IOException;

/**
 * Servlet implementation class CreateItem
 */
@WebServlet("/admin/prod/createItem.do")
public class CreateItem extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	  @Override
	  public void init() throws ServletException {
	    System.out.println("[CreateItem] init() LOADED");
	  }
       
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	    System.out.println("[CreateItem] HIT doPost");
	    System.out.println("[CreateItem] URI=" + req.getRequestURI());
		System.out.println("[CreateItem] METHOD=" + req.getMethod());
		System.out.println("[CreateItem] URI=" + req.getRequestURI());
		req.setCharacterEncoding("UTF-8");
		
		
		 // ✅ 어떤 탭에서 submit했는지 구분
	    String tab = req.getParameter("tab");
	    if (tab == null || tab.isBlank()) {
	        tab = "list";
	    }
	
	    // ✅ 아이템 생성 처리
	    if ("create_item".equals(tab)) {
	
	        // 1) 파라미터 받기 (JSP input name과 반드시 동일해야 함)
	        String itemId    = req.getParameter("itemId");     // 아이템코드
	        String itemTitle = req.getParameter("itemTitle");  // 아이템명
	        String locId   = req.getParameter("locId");    // 지역코드
	        String themeId   = req.getParameter("themeId");    // 테마패키지코드
	
	        // 2) 서버 검증 (프론트 검증은 우회 가능)
	        if (isBlank(itemId) || isBlank(itemTitle) || isBlank(locId) || isBlank(themeId)) {
	            // 비어있으면 다시 create_item 탭으로
	            resp.sendRedirect(req.getContextPath()
	                    + "/admin/prod/adminProducts.do?tab=create_item&msg=empty");
	            return;
	        }
	
	        // 3) VO 세팅
	        // ⚠️ ItemVO 패키지 경로는 너 프로젝트에 맞게 import 필요
	        ItemVO vo = new ItemVO();
	        vo.setItemId(itemId.trim());
	        vo.setItemTitle(itemTitle.trim());
	        vo.setLocId(locId.trim());
	        vo.setThemeId(themeId.trim());
	
	        // 4) 서비스 호출 (insert)
	        IAdItemService itemSvc = AdItemServiceImpl.getInstance();
	        int cnt = itemSvc.createItem(vo);
	
	        // 5) 결과에 따라 redirect
	        if (cnt > 0) {
	            resp.sendRedirect(req.getContextPath()
	                    + "/admin/prod/adminProducts.do?tab=create_item&msg=success");
	        } else {
	            resp.sendRedirect(req.getContextPath()
	                    + "/admin/prod/adminProducts.do?tab=create_item&msg=fail");
	        }
	        return;
	    }
	
	    // ✅ 혹시 다른 탭에서 POST가 들어오면 안전하게 다시 GET으로
	    resp.sendRedirect(req.getContextPath() + "/admin/prod/adminProducts.do?tab=" + tab);
	}
	
	/** null/공백 체크 유틸 */
	private boolean isBlank(String s) {
	    return s == null || s.trim().isEmpty();
	}

}
