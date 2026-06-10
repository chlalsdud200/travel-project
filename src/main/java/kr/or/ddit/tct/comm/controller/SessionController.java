package kr.or.ddit.tct.comm.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.users.vo.UserVO;

/**
 * 헤더/프론트에서 로그인 상태 확인용 API
 */
@WebServlet("/session.do") // 브라우저에서 "/session.do" 주소로 요청을 보내면 이 클래스가 실행됨
public class SessionController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // JSON 변환을 위한 Google Gson 라이브러리 객체 생성
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        // 응답 데이터의 인코딩과 타입을 JSON(UTF-8)으로 설정
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        // 세션에서 "loginUser"라는 이름으로 저장된 객체를 가져옴 (없으면 null)
        UserVO loginUser = (UserVO) req.getSession().getAttribute("loginUser");

        // 클라이언트에 보낼 데이터를 담을 맵(Map) 생성
        Map<String, Object> result = new HashMap<>();
        
        if (loginUser == null) {
            // 로그인 정보가 없는 경우: loggedIn 상태를 false로 전송
            result.put("loggedIn", false);
        } else {
            // 로그인 정보가 있는 경우: 상태 true와 사용자 정보(ID, 이름, 권한)를 담음
            result.put("loggedIn", true);
            result.put("loginId", loginUser.getUserId());
            result.put("userName", loginUser.getUserName());
            result.put("role", loginUser.getRole());
        }

        // 맵(result)을 JSON 문자열로 변환하여 브라우저로 출력(전송)
        try (PrintWriter out = resp.getWriter()) {
            out.print(gson.toJson(result));
        }
    }
}