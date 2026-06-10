package kr.or.ddit.tct.board.review.controller; // 리뷰 게시판의 "데이터 API" 컨트롤러 묶음

import java.io.IOException; // 응답 출력 시 IO 처리 필요
import java.lang.reflect.Type; // Gson 커스텀 직렬화에서 타입 정보가 필요할 수 있음
import java.time.LocalDate; // ReviewBoardVO에 LocalDate가 있어서 JSON 직렬화 대응 필요
import java.util.HashMap; // JSON 응답을 Map으로 구성하기 위해 사용
import java.util.List; // 리뷰 목록(List) 반환 타입
import java.util.Map; // 파라미터/응답을 Map으로 구성하기 위해 사용

import com.google.gson.Gson; // JSON 변환기
import com.google.gson.GsonBuilder; // Gson 설정(커스텀 어댑터 등록)
import com.google.gson.JsonElement; // LocalDate를 Json으로 바꿀 때 필요
import com.google.gson.JsonPrimitive; // LocalDate를 문자열로 내리기 위해 필요
import com.google.gson.JsonSerializationContext; // Gson 직렬화 컨텍스트
import com.google.gson.JsonSerializer; // LocalDate 직렬화 규칙 정의 인터페이스

import jakarta.servlet.ServletException; // 서블릿 표준 예외
import jakarta.servlet.annotation.WebServlet; // URL 매핑을 붙이기 위해 사용
import jakarta.servlet.http.HttpServlet; // 서블릿 기반 컨트롤러
import jakarta.servlet.http.HttpServletRequest; // 요청 파라미터 접근
import jakarta.servlet.http.HttpServletResponse; // JSON 응답 작성

import kr.or.ddit.tct.board.review.service.IReviewService; // 서비스 인터페이스(계층 분리)
import kr.or.ddit.tct.board.review.service.ReviewServiceImpl; // 서비스 구현체(싱글톤)
import kr.or.ddit.tct.board.review.vo.ReviewBoardVO; // 목록에 내려줄 VO
import kr.or.ddit.tct.util.PageUtil; // QNA와 동일한 방식의 페이징 HTML 생성기

@WebServlet("/board/reviewData.do") // 프론트(fetch)가 호출할 리뷰 목록 데이터 API
public class ReviewDataController extends HttpServlet { // Tomcat이 실행할 서블릿 클래스
  private static final long serialVersionUID = 1L; // 서블릿 직렬화 버전(관례)

  private final IReviewService service = ReviewServiceImpl.getInstance(); // 컨트롤러는 DB가 아니라 서비스만 호출한다(역할 분리)

  // LocalDate를 그대로 Gson이 직렬화하면 구조가 깨질 수 있어서 "YYYY-MM-DD 문자열"로 내려주기 위한 설정
  private final Gson gson = new GsonBuilder()
      .registerTypeAdapter(LocalDate.class, new JsonSerializer<LocalDate>() { // LocalDate를 어떻게 JSON으로 바꿀지 규칙 등록
        @Override
        public JsonElement serialize(LocalDate src, Type typeOfSrc, JsonSerializationContext context) { // LocalDate -> JSON 변환 로직
          return (src == null) ? new JsonPrimitive("") : new JsonPrimitive(src.toString()); // null이면 빈문자, 아니면 2026-01-28 같은 문자열
        }
      })
      .create(); // 설정을 반영한 Gson 객체 생성

  @Override // GET으로 목록 조회
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    resp.setContentType("application/json; charset=UTF-8"); // 이 응답이 JSON이고 UTF-8이라는 걸 브라우저에 명확히 알림

    // ===== 1) 파라미터 받기 =====
    String pageStr = req.getParameter("page"); // 현재 페이지 번호
    String q = req.getParameter("q"); // 검색어(없으면 null)
    String period = req.getParameter("period"); // "", "7","30"...
    String stype  = req.getParameter("stype");  // title/content/...

    int page = 1; // 기본 페이지는 1
    try { // page 파라미터가 숫자가 아닐 때를 대비해 안전하게 처리
      if (pageStr != null && !pageStr.isBlank()) page = Integer.parseInt(pageStr);
    } catch (Exception e) {
      page = 1; // 파싱 실패하면 1페이지로 강제
    }

    if (page < 1) page = 1; // 0 이하가 들어오면 의미가 없으니 1로 고정

    // ===== 2) 페이징 계산 =====
    int perList = 10; // 한 페이지에 보여줄 글 수(정책)
    int perPage = 10; // 페이지 버튼 묶음 크기(정책)

    int startRow = (page - 1) * perList + 1; // DB에서 가져올 시작 행 번호(1부터)
    int endRow = page * perList; // DB에서 가져올 끝 행 번호

    // ===== 3) 서비스 호출 파라미터 구성 =====
    Map<String, Object> param = new HashMap<>(); // mapper에 넘길 파라미터 통
    param.put("q", (q == null ? "" : q.trim())); // 검색어는 공백 제거 후 전달(없으면 빈 문자열)
    
    param.put("period", (period == null ? "" : period.trim()));
    param.put("stype",  (stype  == null ? "title" : stype.trim())); // 기본값 title
    
    param.put("startRow", startRow); // mapper에서 BETWEEN/ROWNUM 처리에 사용
    param.put("endRow", endRow); // mapper에서 BETWEEN/ROWNUM 처리에 사용

    // ===== 4) 총 개수 + 목록 조회 =====
    int totalCount = service.selectReviewCount(param); // 조건(q)에 맞는 전체 글 수
    List<ReviewBoardVO> list = service.selectReviewList(param); // 현재 페이지에 해당하는 글 목록

    int totalPage = (int) Math.ceil(totalCount / (double) perList); // 전체 페이지 수(올림)
    if (totalPage < 1) totalPage = 1; // 글이 0개여도 페이징 계산이 깨지지 않게 1로 보정

    int startPage = ((page - 1) / perPage) * perPage + 1; // 현재 페이지가 속한 "페이지 버튼 묶음"의 시작
    int endPage = startPage + perPage - 1; // 페이지 버튼 묶음의 끝
    if (endPage > totalPage) endPage = totalPage; // 실제 totalPage를 넘지 않도록 보정

    String pglist = PageUtil.pageList(startPage, endPage, totalPage, page); // QNA와 동일한 모양의 페이징 HTML 생성

    // ===== 5) JSON 응답 구성 =====
    Map<String, Object> out = new HashMap<>(); // 프론트가 받을 JSON 통
    out.put("ok", true); // 성공 여부
    out.put("page", page); // 현재 페이지
    out.put("totalCount", totalCount); // 총 글 수
    out.put("totalPage", totalPage); // 총 페이지 수
    out.put("list", list); // 목록 데이터
    out.put("pglist", pglist); // 페이징 HTML

    resp.getWriter().write(gson.toJson(out)); // Map -> JSON 문자열로 변환해서 응답 본문에 출력
  }
}
