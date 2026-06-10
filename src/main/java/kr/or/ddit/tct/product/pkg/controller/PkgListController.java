package kr.or.ddit.tct.product.pkg.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.product.pkg.service.IPkgService;
import kr.or.ddit.tct.product.pkg.service.PkgServiceImpl;
import kr.or.ddit.tct.product.pkg.vo.PkgVO;

@WebServlet("/results.do")
public class PkgListController extends HttpServlet{
	
	private final IPkgService service = PkgServiceImpl.getInstance();
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		List<PkgVO> pkgList = service.listAll();
		
		req.setAttribute("list", pkgList);
		req.getRequestDispatcher("/WEB-INF/views/results.jsp").forward(req, resp);
	}
}
