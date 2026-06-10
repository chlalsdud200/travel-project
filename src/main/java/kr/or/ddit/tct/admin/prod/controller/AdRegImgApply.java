package kr.or.ddit.tct.admin.prod.controller;

import java.io.IOException;
import java.util.List;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.admin.prod.reg.service.AdRegImgServiceImpl;
import kr.or.ddit.tct.admin.prod.reg.service.IAdRegImgService;
import kr.or.ddit.tct.comm.dto.CommonApi;

@WebServlet("/adRegImgApply.do")
public class AdRegImgApply extends HttpServlet{

	static class Req{
		String regId;
		String imgPath;
		Integer viewSequence;
		String originName;
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		resp.setCharacterEncoding("UTF-8");
		resp.setContentType("application/json;charset=UTF-8");
		
		IAdRegImgService service = AdRegImgServiceImpl.getInstance();
		Gson gson = new Gson();
		
		Req body = gson.fromJson(req.getReader(), Req.class);
		
		if(body == null || body.regId == null || body.regId.isBlank() ||
						body.imgPath == null || body.imgPath.isBlank()) {
			resp.getWriter().write(gson.toJson(CommonApi.fail("필수값이 없습니다")));
			return;
		}
		
		try {
			
			CommonApi<?> result = service.applyRegImg(	// 반환타입 이슈 대비
					body.regId, body.imgPath, body.viewSequence, body.originName, req.getServletContext());
		    
			resp.getWriter().write(gson.toJson(result));
			
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
}
