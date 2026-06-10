package kr.or.ddit.tct.board.review.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.board.review.service.IReviewService;
import kr.or.ddit.tct.board.review.service.ReviewServiceImpl;
import kr.or.ddit.tct.users.vo.UserVO;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;

/**
 * Servlet implementation class WritableOrderNosController
 */
@WebServlet("/board/writableOrderNos.do")
public class WritableOrderNosController extends HttpServlet {

	private final IReviewService service = ReviewServiceImpl.getInstance();
	private final Gson gson = new Gson();
	
	private String getLoginUserId(HttpServletRequest req) {
        Object v = req.getSession().getAttribute("loginUser");
        if (v == null) return null;
        return ((kr.or.ddit.tct.users.vo.UserVO) v).getUserId();
    }

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		String userId = getLoginUserId(req);
		
        Map<String, Object> result = new HashMap<>();
        resp.setContentType("application/json; charset=UTF-8");

        if (userId == null) {
            result.put("success", false);
            result.put("msg", "로그인이 필요합니다.");
            resp.getWriter().write(gson.toJson(result));
            return;
        }

        List<Map<String, Object>> orderList = service.selectWritableOrderNos(userId);        

        result.put("success", true);
        result.put("orderList", orderList);

        resp.getWriter().write(gson.toJson(result));
		
	}

}
