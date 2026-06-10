package kr.or.ddit.tct.mypage.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.mypage.service.IMyPageService;
import kr.or.ddit.tct.mypage.service.MyPageServiceImpl;
import kr.or.ddit.tct.users.vo.UserVO;



/*마이페이지 관심상품------------------------*/
import java.util.List;
import org.apache.ibatis.session.SqlSession;
import kr.or.ddit.tct.util.MyBatisUtil;
/**
 * 마이페이지 탭 데이터 API
 * - type: pay | qna | review | wish
 * - 현재: pay만 실제 DB 조회, 나머지는 빈 리스트
 */
@WebServlet("/mypageData.do")
public class MyPageDataController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final Gson gson = new Gson();
    private final IMyPageService myPageService = MyPageServiceImpl.getInstance();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        // 로그인 체크
        UserVO loginUser = (UserVO) req.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);

            Map<String, Object> r = new HashMap<>();
            r.put("ok", false);
            r.put("message", "LOGIN_REQUIRED");
            r.put("type", "");
            r.put("items", Collections.emptyList());

            try (PrintWriter out = resp.getWriter()) {
                out.print(gson.toJson(r));
            }
            return;
        }

        String type = req.getParameter("type"); // pay | qna | review | wish
        if (type == null) type = "";

        Map<String, Object> result = new HashMap<>();
        result.put("ok", true);
        result.put("type", type);

        try {
            Object items = Collections.emptyList(); // ✅ 기본값(어떤 type이 와도 items는 존재)

            switch (type) {

                case "pay":
                    items = myPageService.getPayHistory(loginUser.getUserId());
                    break;

                case "wish":
                    try (SqlSession session = MyBatisUtil.getSqlSession()) {
                        List<Map<String, Object>> list =
                                session.selectList("wish.selectWishList", loginUser.getUserId());
                        items = (list != null) ? list : Collections.emptyList();
                    }
                    break;

                case "qna":
                    try (SqlSession session = MyBatisUtil.getSqlSession()) {
                        items = session.selectList("boardQna.selectMyQnaList", loginUser.getUserId());
                        if (items == null) items = Collections.emptyList();
                    }
                    break;

                case "review":
                    try (SqlSession session = MyBatisUtil.getSqlSession()) {
                        items = session.selectList("boardReview.selectMyReviewList", loginUser.getUserId());
                        if (items == null) items = Collections.emptyList();
                    }
                    break;

                default:
                    // type이 이상하게 오면 빈 리스트 유지
                    break;
            }

            result.put("items", items);

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

            result.put("ok", false);
            result.put("message", "SERVER_ERROR");
            result.put("items", Collections.emptyList());
        }


        try (PrintWriter out = resp.getWriter()) {
            out.print(gson.toJson(result));
        }
    }
}
