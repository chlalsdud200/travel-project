package kr.or.ddit.tct.board.qna.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.board.qna.service.IQnaService;
import kr.or.ddit.tct.board.qna.service.QnaServiceImpl;
import kr.or.ddit.tct.board.qna.vo.QnaVO;
import kr.or.ddit.tct.board.vo.PageInfo;
import kr.or.ddit.tct.board.vo.SearchVO;
import kr.or.ddit.tct.util.PageUtil;
import kr.or.ddit.tct.users.vo.UserVO; // 세션 loginUser에서 role 확인하려고 추가

@WebServlet("/board/qnaData.do")
public class QnaDataController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  private final Gson gson = new GsonBuilder().serializeNulls().create();
  private final IQnaService service = QnaServiceImpl.getInstance();
// 목록 페이지에 데이터 넣어주는 서블릿
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

    resp.setCharacterEncoding("UTF-8");
    resp.setContentType("application/json; charset=UTF-8");

    int page = parseInt(req.getParameter("page"), 1);
    String stype = trim(req.getParameter("stype"));  // title | writer | ""
    String sword = trim(req.getParameter("sword"));

    int perList = 10;
    int perPage = 10;
	int noticeLimit = 5; // 공지(관리자 글) 상단 고정 노출 개수

    SearchVO svo = new SearchVO(page, stype, sword);

    PageInfo pinfo = new PageInfo(perList, perPage);
    pinfo.setSvo(svo);
    pinfo.setPage(svo.getPage());

    // 지금 이 목록을 "보고 있는 사람"이 관리자(ADMIN)인지 판단한다
    // 존재이유: 같은 글이라도 "비관리자에게는 관리자 작성자를 '관리자'로 숨기고",
    //           "관리자에게는 실제 이름(USER_NAME)을 보여주기 위해"
 UserVO loginUser = (UserVO) req.getSession().getAttribute("loginUser");
 boolean viewerAdmin = (loginUser != null && "ADMIN".equals(loginUser.getRole()));

    
    
    
    Map<String, Object> out = new HashMap<>();
    try {
	  // 1) 일반글(공지 제외) 페이징 목록
	  List<QnaVO> list = service.readPaging(pinfo);

	  // 2) 공지(관리자 글) Top N : 페이징과 별도로 항상 상단에 붙일 목록
	  List<QnaVO> notices = service.selectNoticeTop(pinfo, noticeLimit);

	// 비관리자가 보는 경우에만 ADMIN 작성자의 writerName을 "관리자"로 덮어쓴다
	// 존재이유: mapper는 항상 실제 이름을 내려주고, 보여줄지/숨길지는 서버에서 결정하기 위함
	maskAdminWriter(notices, viewerAdmin);
	maskAdminWriter(list, viewerAdmin);

	  
      String pglist = PageUtil.pageList(
          pinfo.getStartPage(),
          pinfo.getEndPage(),
          pinfo.getTotalPage(),
          pinfo.getPage()
      );

      out.put("ok", true);
      out.put("page", pinfo.getPage());
      out.put("totalCount", pinfo.getTotalRecord());
      out.put("totalPage", pinfo.getTotalPage());
	  out.put("notices", notices);
	  out.put("list", list);
      out.put("pglist", pglist);
    } catch (Exception e) {
      e.printStackTrace();
      out.put("ok", false);
      out.put("msg", "SERVER_ERROR");
    }

    resp.getWriter().write(gson.toJson(out));
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

  private String trim(String s) {
    return (s == null) ? "" : s.trim();
  }
//비관리자 화면에서만 "ADMIN 작성자"의 이름을 "관리자"로 숨긴다
//존재이유: 관리자끼리는 작성자 이름을 서로 알아볼 수 있어야 하므로(ADMIN이면 그대로 둠)
private void maskAdminWriter(List<QnaVO> list, boolean viewerAdmin) {
 if (viewerAdmin) return; // 관리자가 보는 화면이면 마스킹하지 않는다

 for (QnaVO vo : list) {
   if ("ADMIN".equals(vo.getWriterRole())) {  // 이 글의 작성자가 ADMIN이면
     vo.setWriterName("관리자");               // 비관리자에게는 이름 대신 '관리자'로 표시
   }
 }
}

}
