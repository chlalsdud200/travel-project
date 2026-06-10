package kr.or.ddit.tct.comm.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import com.google.gson.Gson;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.comm.dto.CommonApi;
import kr.or.ddit.tct.comm.vo.DdayTripVO;
import kr.or.ddit.tct.users.vo.UserVO;
import kr.or.ddit.tct.util.MyBatisUtil;

@WebServlet("/ddayWidget.do") // : 헤더(공통)에서 어디 페이지든 호출할 "D-day 위젯 전용 API"
public class DdayWidgetController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  private final Gson gson = new Gson(); // : Map/VO/List를 JSON 문자열로 변환해서 브라우저에 내려주기 위함

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

    resp.setCharacterEncoding("UTF-8");                 // : 한글(상품명) 깨짐 방지
    resp.setContentType("application/json; charset=UTF-8"); // : 응답이 JSON임을 명확히 선언

    UserVO loginUser = (UserVO) req.getSession().getAttribute("loginUser"); // : "누구의 위젯"인지 결정하는 기준

    if (loginUser == null) { // : 비로그인은 위젯을 그릴 데이터가 없음
      CommonApi.writeJson(resp, CommonApi.fail("NOT_LOGIN"), gson);
      return;
    }

    Map<String, Object> p = new HashMap<>(); // : MyBatis에 userId/limit 두 값을 같이 넘기기 위함
    p.put("userId", loginUser.getUserId());  // : 로그인한 사용자 주문만 조회
    p.put("limit", 2);                       // : 위젯 최대 2개 요구사항

    try (SqlSession session = MyBatisUtil.getSqlSession()) { // : DB 조회 후 자동 close
      List<DdayTripVO> list = session.selectList("payment.selectUpcomingTripsWidget", p); // : 가장 가까운 2건 조회
      CommonApi.writeJson(resp, CommonApi.ok(list), gson); // : 프론트는 ok/data만 보고 렌더링
    }
  }
}
