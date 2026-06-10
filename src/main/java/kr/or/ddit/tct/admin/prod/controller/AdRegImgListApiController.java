package kr.or.ddit.tct.admin.prod.controller;

import java.io.IOException;
import java.util.List;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.admin.prod.dto.AdRegImgDtoVO;
import kr.or.ddit.tct.admin.prod.reg.service.AdRegProdServiceImpl;
import kr.or.ddit.tct.admin.prod.reg.service.IAdRegProdService;
import kr.or.ddit.tct.comm.dto.CommonApi;

@WebServlet("/adRegImgList.do")
public class AdRegImgListApiController extends HttpServlet{

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		resp.setContentType("application/json;charset=UTF-8");
		
		Gson gson = new Gson();
		IAdRegProdService service = AdRegProdServiceImpl.getInstance();
		
		String regId = req.getParameter("regId");
		
		if(regId == null || regId.isBlank()) {
			resp.getWriter().write(gson.toJson(CommonApi.fail("regId값이 없습니다")));
			return;
		}

		try {
			List<AdRegImgDtoVO> imgList = service.adSelectAdRegImg(regId);
			resp.getWriter().write(gson.toJson(CommonApi.ok(imgList)));
			
		} catch (Exception e) {
			e.printStackTrace();
            resp.getWriter().write(gson.toJson(CommonApi.fail("이미지 목록 불러오기 실패")));
		}
	}
}
