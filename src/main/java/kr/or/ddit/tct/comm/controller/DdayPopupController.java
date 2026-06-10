package kr.or.ddit.tct.comm.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import com.google.gson.Gson;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.comm.dto.CommonApi;
import kr.or.ddit.tct.comm.vo.DdayPopupVO;
import kr.or.ddit.tct.users.vo.UserVO;
import kr.or.ddit.tct.util.MyBatisUtil;

/**
 * DdayPopupController
 * - 헤더(공통)에서 호출하는 "출발 임박 팝업 전용 API"
 *
 * ✅ 정책
 * 1) 자동 팝업(페이지 들어오면 자동 호출): 출발 0~10일 이내만 대상 (autoDayWindow)
 * 2) 수동 팝업(체크리스트 버튼 클릭): 출발일이 많이 남아도 확인 가능하도록 범위를 크게( manualDayWindow )
 *
 * ※ 수동 호출은 프론트에서 /ddayPopup.do?manual=1 로 호출한다.
 */
@WebServlet("/ddayPopup.do") // : 프론트(tctWidget.jsp)가 어디서든 GET으로 호출할 고정 엔드포인트
public class DdayPopupController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  private final Gson gson = new Gson(); // : VO/Map을 JSON으로 변환(CommonApi와 함께 사용)

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

    resp.setCharacterEncoding("UTF-8");                      // : 한글(상품명/호텔명) 깨짐 방지
    resp.setContentType("application/json; charset=UTF-8");  // : 응답이 JSON임을 브라우저에 명확히 알리기 위함

    // : "누구의 팝업"인지 결정하는 기준(로그인 유저)
    UserVO loginUser = (UserVO) req.getSession().getAttribute("loginUser");

    // : 비로그인은 구매내역 기반 팝업이 의미 없으므로 종료
    if (loginUser == null) {
      CommonApi.writeJson(resp, CommonApi.fail("NOT_LOGIN"), gson);
      return;
    }

    // ✅ manual=1 이면 "체크리스트 버튼(수동 오픈)" 요청
    // : 존재 이유 = 자동팝업은 임박만 보여주고, 버튼 클릭 시에는 출발일이 남아도 체크리스트를 열어주기 위함
    boolean isManual = "1".equals(req.getParameter("manual"));

    // ✅ 자동 팝업 기준(0~10일) : 페이지 방문 시 너무 이른 시점부터 팝업이 뜨는 것을 막기 위한 정책값
    int autoDayWindow = 10;

    // ✅ 수동(버튼 클릭) 기준(0~365일) : 사실상 기간 제한을 풀기 위한 정책값
    int manualDayWindow = 365;

    // : MyBatis로 userId, dayWindow 두 값을 같이 넘기기 위함
    Map<String, Object> p = new HashMap<>();
    p.put("userId", loginUser.getUserId());                         // : 로그인 유저의 주문만 조회
    p.put("dayWindow", isManual ? manualDayWindow : autoDayWindow); // : 자동/수동에 따라 조회 범위 다르게 적용

    try (SqlSession session = MyBatisUtil.getSqlSession()) { // : DB 조회 후 자동 close
      // : 가장 가까운 1건(없으면 null) - SQL에서 rn=1 같은 방식으로 1건만 나오게 되어있음
      DdayPopupVO one = session.selectOne("payment.selectUpcomingTripPopup", p);

      // : 프론트는 ok/data를 보고 data가 있으면 팝업을 띄움
      CommonApi.writeJson(resp, CommonApi.ok(one), gson);
    }
  }
}
