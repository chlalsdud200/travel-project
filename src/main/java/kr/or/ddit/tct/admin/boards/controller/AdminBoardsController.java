package kr.or.ddit.tct.admin.boards.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.admin.boards.service.AdminBoardsServiceImpl;
import kr.or.ddit.tct.admin.boards.service.IAdminBoardsService;
import kr.or.ddit.tct.admin.boards.vo.AdminBoardPostVO;
import kr.or.ddit.tct.admin.boards.vo.AdminBoardSearchVO;

@WebServlet("/admin/boards.do")
public class AdminBoardsController extends HttpServlet {
  private static final long serialVersionUID = 1L;

  // [의미] 컨트롤러는 “요청 파라미터 정리 + 서비스 호출 + JSP 포워드”만 담당
  // [존재이유] 다른 admin 메뉴(회원/결제)와 동일한 구조로 맞추기 위함
  private final IAdminBoardsService service = AdminBoardsServiceImpl.getInstance();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    // [의미] 화면 필터들(기본값 포함)
    String kind  = nvl(req.getParameter("kind"), "ALL");   // QNA/REVIEW/ALL
    String stype = nvl(req.getParameter("stype"), "all");  // title/writer/all
    String role  = nvl(req.getParameter("role"), "ALL");   // ADMIN/USER/ALL
    String from  = nvl(req.getParameter("from"), "");
    String to    = nvl(req.getParameter("to"), "");
    String q     = nvl(req.getParameter("q"), "");

    // [의미] 현재 페이지 번호(목록 페이징)
    int page = parseInt(nvl(req.getParameter("page"), "1"), 1);

    // [의미] 한 페이지에 몇 개 보여줄지(관리자 목록 기준)
    // [존재이유] startRow/endRow 계산이 필요해서 고정값으로 둔다
    final int pageSize = 10;

    // [의미] rn BETWEEN startRow AND endRow 로 페이징하기 위한 값
    int startRow = (page - 1) * pageSize + 1;
    int endRow   = page * pageSize;

    // [의미] 서비스로 넘길 검색 VO 구성(파라미터 뭉치)
    AdminBoardSearchVO s = new AdminBoardSearchVO();
    s.setKind(kind);
    s.setStype(stype);
    s.setRole(role);
    s.setFrom(from);
    s.setTo(to);
    s.setQ(q);
    s.setStartRow(startRow);
    s.setEndRow(endRow);

    // [의미] total → totalPages 계산용
    int total = service.count(s);

    // [의미] 페이지수 계산
    int totalPages = (int)Math.ceil(total / (double)pageSize);
    if (totalPages <= 0) totalPages = 1;

    // [의미] 실제 목록 데이터
    List<AdminBoardPostVO> list = service.selectList(s);

    // [의미] “상세 → 목록으로” 돌아갈 때 현재 검색조건/페이지를 유지하려고 back을 만든다.
    // [존재이유] 관리자는 보통 검색 후 결과를 여러 건 클릭해서 확인하기 때문에,
    //          매번 검색조건이 초기화되면 UX가 나빠진다.
    String rawBack =
        "kind=" + kind +
        "&stype=" + stype +
        "&role=" + role +
        "&from=" + from +
        "&to=" + to +
        "&q=" + URLEncoder.encode(q, "UTF-8") +
        "&page=" + page;

    String back = URLEncoder.encode(rawBack, "UTF-8");

    // JSP에서 사용할 값들
    req.setAttribute("list", list);
    req.setAttribute("total", total);
    req.setAttribute("page", page);
    req.setAttribute("totalPages", totalPages);

    req.setAttribute("kind", kind);
    req.setAttribute("stype", stype);
    req.setAttribute("role", role);
    req.setAttribute("from", from);
    req.setAttribute("to", to);
    req.setAttribute("q", q);
    req.setAttribute("back", back);

    // [의미] 사이드바 활성 메뉴 표시
    req.setAttribute("adminActive", "boards");

    req.getRequestDispatcher("/WEB-INF/views/admin/boards.jsp").forward(req, resp);
  }

  private String nvl(String s, String def) {
    return (s == null || s.isBlank()) ? def : s.trim();
  }

  private int parseInt(String s, int def) {
    try { return Integer.parseInt(s); } catch (Exception e) { return def; }
  }
}
