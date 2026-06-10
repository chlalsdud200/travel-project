package kr.or.ddit.tct.product.regProd.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.product.dto.FilterSearchDto;
import kr.or.ddit.tct.product.dto.vo.RegProDtoVO;
import kr.or.ddit.tct.product.regProd.service.IregProdService;
import kr.or.ddit.tct.product.regProd.service.RegProdServiceImpl;

@WebServlet("/regProdResults.do")
public class RegProdListController extends HttpServlet{
	
	private final IregProdService service =
				RegProdServiceImpl.getInstance();
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		String keyword = req.getParameter("keyword");
		String sort = req.getParameter("sort");
		String filter = req.getParameter("filter");
		String destination = req.getParameter("destination");
		String startDate = req.getParameter("startDate");
		String endDate = req.getParameter("endDate");
		String minStr = req.getParameter("minPrice");
		String maxStr = req.getParameter("maxPrice");
		String[] themeArr = req.getParameterValues("themeIds");

		FilterSearchDto param = new FilterSearchDto();
        param.setKeyword(keyword);
        System.out.println("### keyword=[" + keyword + "] len=" + (keyword==null ? "null" : keyword.length()));

        if(sort==null || sort.isBlank()) {
        	sort = "startDtAsc";
        } 
        
        param.setSort(sort);
        System.out.println("### sort=[" + sort + "] len=" + (sort==null ? "null" : sort.length()));
        
        param.setFilter(filter);
        System.out.println("### filter=[" + filter + "] len=" + (filter==null ? "null" : filter.length()));
        
        param.setDestination(destination);
        param.setStartDate(startDate);
        param.setEndDate(endDate);
        
		if (minStr != null && !minStr.isBlank()) {
		    param.setMinPrice(Integer.parseInt(minStr));
		}
		if (maxStr != null && !maxStr.isBlank()) {
		    param.setMaxPrice(Integer.parseInt(maxStr));
		}
        
        if (destination != null && !destination.isBlank()) {
            destination = destination.trim();
            param.setCtryIds(service.findCountryIdsByName(destination));
            param.setLocIds(service.findLocationIdsByName(destination));
          }
        
        if (themeArr != null) {
        	List<String> themeList = new ArrayList<>();
        	for(String t : themeArr) {
        		if(t != null && !t.isBlank()) themeList.add(t.trim());
        	}
        	param.setThemeIds(themeList);
        }
        
		List<RegProDtoVO> regList = service.selectAllForSale(param);
		
//		for(RegProDtoVO v : regList) {
//		System.out.println("****************************pkgId = "+ v.getPkgId());
//		System.out.println("****************************startDt = "+ v.getStartDt());
//		System.out.println("****************************price = "+ v.getRegPrice());
//		}
		
		System.out.println("**************************** themeIds = " + (param.getThemeIds()==null ? "null" : param.getThemeIds()));

		
		req.setAttribute("regList", regList);
		req.setAttribute("search", param);
		req.setAttribute("selectedThemes", param.getThemeIds());
		req.getRequestDispatcher("/WEB-INF/views/prod_view/regProdResults.jsp").forward(req, resp);
		
	}
} 
