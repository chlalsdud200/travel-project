package kr.or.ddit.tct.product.regProd.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.product.dto.vo.RegProDtoVO;
import kr.or.ddit.tct.product.regProd.service.IregProdService;
import kr.or.ddit.tct.product.regProd.service.RegProdServiceImpl;

import java.io.IOException;
import java.util.List;

/**
 * Servlet implementation class MainPageController
 */
@WebServlet("/mainPage.do")
public class MainPageController extends HttpServlet {
	
	private final IregProdService service = RegProdServiceImpl.getInstance();
       
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		List<RegProDtoVO> top5List = service.selectTop5();
		
		req.setAttribute("top5List", top5List);
		
		req.getRequestDispatcher("/main.jsp").forward(req, resp);
		
	}

}
