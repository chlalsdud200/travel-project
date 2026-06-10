package kr.or.ddit.tct.board.home.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.board.home.service.BoardHomeServiceImpl;
import kr.or.ddit.tct.board.home.service.IBoardHomeService;
import kr.or.ddit.tct.board.home.vo.BoardHomePostVO;
import kr.or.ddit.tct.board.vo.PageInfo;
import kr.or.ddit.tct.board.vo.SearchVO;
import kr.or.ddit.tct.util.PageUtil;
import kr.or.ddit.tct.users.vo.UserVO;

@WebServlet("/board/homeData.do")
public class BoardHomeDataController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  private final Gson gson = new Gson();
  private final IBoardHomeService service = BoardHomeServiceImpl.getInstance();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

	// ===== doGet 안에서 파라미터 받는 부분 교체(또는 이 블록대로 수정) =====

	  resp.setCharacterEncoding("UTF-8");                    // JSON 한글 깨짐 방지
	  resp.setContentType("application/json; charset=UTF-8");// 응답이 JSON임을 명확히 함

	  int page = parseInt(req.getParameter("page"), 1);      // 현재 페이지(없으면 1)

	  // (추가) 검색조건 파라미터 수신
	  String stype = trim(req.getParameter("stype"));        // 검색대상(title|writer|content|""), SearchVO에 넣을 값
	  String sword = trim(req.getParameter("sword"));        // 검색어(없으면 "")

	  // HOME 정책(고정)
	  int perList = 10;                                      // 홈 최신글 10개
	  int perPage = 10;                                      // 페이지 버튼 10개 단위
	  int noticeLimit = 5;                                   // 공지 상단 5개

	  UserVO loginUser = (UserVO) req.getSession().getAttribute("loginUser"); // 로그인 사용자(없으면 null)
	  boolean viewerAdmin = (loginUser != null && "ADMIN".equals(loginUser.getRole())); // 지금 보는 사람이 관리자냐?

	  // 학원 방식: SearchVO + PageInfo 세팅(검색조건 포함)
	  SearchVO svo = new SearchVO(page, stype, sword);        // 페이지+검색대상+검색어를 한 덩어리로 묶음(존재이유: pinfo가 들고 내려감)

	  PageInfo pinfo = new PageInfo(perList, perPage);        // 페이징 계산용 객체(존재이유: start/end/totalPage 계산)
	  pinfo.setSvo(svo);                                      // (핵심) mapper가 #{svo.stype}, #{svo.sword}로 검색조건을 읽게 됨
	  pinfo.setPage(svo.getPage());                           // 현재 페이지 세팅(존재이유: start/end 계산 기준)

	  // 이하 로직(proc 호출/JSON 출력)은 기존 그대로


    Map<String, Object> result;
    try {
      result = proc(pinfo, noticeLimit, viewerAdmin);
    } catch (Exception e) {
      e.printStackTrace();
      result = Map.of("ok", false, "msg", "SERVER_ERROR");
    }

    try (PrintWriter out = resp.getWriter()) {
      out.print(gson.toJson(result));
    }
  }

  /**
   * HOME 데이터 구성
   * - DB에서 가져올 때는 writerName(실제 이름) + writerRole(권한)까지 가져온다
   * - 그리고 여기서 "보는 사람이 관리자냐?"에 따라 writerName을 마스킹한다
   *
   * 1) 비관리자 화면: ADMIN 작성글 writerName = "관리자"
   * 2) 관리자 화면: ADMIN 작성글 writerName = 실제 이름(USERS.USER_NAME)
   */
  private Map<String, Object> proc(PageInfo pinfo, int noticeLimit, boolean viewerAdmin) {

    List<BoardHomePostVO> posts = service.readPaging(pinfo);
    List<BoardHomePostVO> notices = service.selectNoticeTop(noticeLimit);

    // ✅ 마스킹(핵심): 보는 사람이 관리자 아니면 ADMIN 작성자는 "관리자"로 덮는다
    maskAdminWriter(notices, viewerAdmin);
    maskAdminWriter(posts, viewerAdmin);

    String pglist = PageUtil.pageList(
        pinfo.getStartPage(),
        pinfo.getEndPage(),
        pinfo.getTotalPage(),
        pinfo.getPage()
    );

    Map<String, Object> dataMap = new HashMap<>();
    dataMap.put("ok", true);

    dataMap.put("page", pinfo.getPage());
    dataMap.put("pageSize", pinfo.getPerList());
    dataMap.put("totalCount", pinfo.getTotalRecord());
    dataMap.put("totalPage", pinfo.getTotalPage());

    dataMap.put("notices", notices);
    dataMap.put("posts", posts);
    dataMap.put("pglist", pglist);

    return dataMap;
  }

  private void maskAdminWriter(List<BoardHomePostVO> list, boolean viewerAdmin) {
    if (viewerAdmin) return; // 관리자는 마스킹하지 않는다
    for (BoardHomePostVO vo : list) {
      if (vo == null) continue;
      if ("ADMIN".equals(vo.getWriterRole())) {
        vo.setWriterName("관리자");
      }
    }
  }
//존재이유: null이면 ""로 통일해서 MyBatis <if test="... != ''"> 조건이 안정적으로 동작하게 함
private String trim(String s) {
 return (s == null) ? "" : s.trim();
}

  private int parseInt(String s, int def) {
    try {
      if (s == null) return def;
      s = s.trim();
      if (s.isEmpty()) return def;
      return Integer.parseInt(s);
    } catch (Exception e) {
      return def;
    }
  }
}
