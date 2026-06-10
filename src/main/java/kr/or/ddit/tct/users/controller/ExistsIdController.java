package kr.or.ddit.tct.users.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.users.service.IUserService;
import kr.or.ddit.tct.users.service.UserServiceImpl;

@WebServlet("/existsId.do")
public class ExistsIdController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IUserService userService = UserServiceImpl.getService();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // 1) 파라미터 받기
        String userId = req.getParameter("userId");
        if (userId != null) userId = userId.trim();

        // 2) 기본 검증
        Map<String, Object> result = new HashMap<>();
        if (userId == null || userId.isEmpty()) {
            result.put("success", false);
            result.put("exists", false);
            result.put("message", "userId is required");
        } else {
            // 3) 서비스 호출
            int cnt = userService.existsUserId(userId); // 0 or 1 (보통)
            boolean exists = (cnt > 0);

            result.put("success", true);
            result.put("exists", exists);
            result.put("count", cnt);
        }

        // 4) JSON 응답
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        try (PrintWriter out = resp.getWriter()) {
            out.print(gson.toJson(result));
        }
        /*
         PrintWriter out = resp.getWriter();
		 gson.toJson(result, out);
			라고 쓸수 있지만 try 를 닫는게 실무적으로 권장  
         */
    }
}
