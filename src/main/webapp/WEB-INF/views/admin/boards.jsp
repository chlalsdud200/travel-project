<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="kr.or.ddit.tct.admin.boards.vo.AdminBoardPostVO"%>
<%
  // [의미] 사이드바에서 메뉴 활성화 표시를 하기 위한 값 (adminSidebar.jspf에서 사용)
  request.setAttribute("adminActive", "boards");

  String ctx = request.getContextPath();

  @SuppressWarnings("unchecked")
  List<AdminBoardPostVO> list = (List<AdminBoardPostVO>)request.getAttribute("list");
  if(list == null) list = new ArrayList<>();

  // [의미] 컨트롤러에서 내려준 값(없으면 기본값)
  int total = (request.getAttribute("total") == null) ? 0 : (int)request.getAttribute("total");
  int curPage = (request.getAttribute("page") == null) ? 1 : (int)request.getAttribute("page");
  int totalPages = (request.getAttribute("totalPages") == null) ? 1 : (int)request.getAttribute("totalPages");

  String kind = (String)request.getAttribute("kind");   if(kind == null) kind = "ALL";     // ALL/NOTICE/QNA/REVIEW
  String stype = (String)request.getAttribute("stype"); if(stype == null) stype = "all";  // all/title/writer/content
  String role = (String)request.getAttribute("role");   if(role == null) role = "ALL";    // ALL/ADMIN/USER
  String from = (String)request.getAttribute("from");   if(from == null) from = "";
  String to = (String)request.getAttribute("to");       if(to == null) to = "";
  String q = (String)request.getAttribute("q");         if(q == null) q = "";

  // [의미] 상세에서 "목록으로" 돌아갈 때 검색조건 유지용(컨트롤러가 만들어서 내려줄 수 있음)
  String back = (String)request.getAttribute("back");   if(back == null) back = "";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>게시판관리 - TryCatchTrip</title>

<script src="https://cdn.tailwindcss.com"></script>

<style>
  body{font-family: Inter, sans-serif;}
  .btn{display:inline-flex;align-items:center;justify-content:center;border-radius:12px;font-weight:800;border:1px solid transparent;cursor:pointer;transition:.15s;white-space:nowrap}
  .btn-md{height:44px;padding:0 16px;font-size:14px}
  .btn-sm{height:36px;padding:0 12px;font-size:12px}
  .btn-primary{background:#4f46e5;color:#fff}
  .btn-primary:hover{opacity:.92}
  .btn-gray{background:#f3f4f6;color:#374151}
  .btn-gray:hover{background:#e5e7eb}
  .field{height:42px;border:1px solid #e5e7eb;border-radius:12px;padding:0 12px;background:#fff;outline:none}
  .field:focus{box-shadow:0 0 0 3px rgba(79,70,229,.15);border-color:rgba(79,70,229,.35)}

  /* [의미] 배경색이 있는 행에서도 hover 효과가 보이도록 살짝 어둡게 */
  .rowHover:hover{filter: brightness(0.97);}
</style>
</head>

<body class="bg-gray-50">
<div class="flex h-screen overflow-hidden">

  <%@ include file="/WEB-INF/views/admin/adminSidebar.jspf"%>

  <main class="flex-1 flex flex-col bg-slate-50 overflow-y-auto">

    <header class="h-16 bg-white border-b border-gray-200 flex items-center justify-between px-8 sticky top-0 z-10">
      <div class="text-indigo-600 font-bold">게시판관리</div>
      <div class="text-sm font-semibold text-gray-600">총 <span class="text-slate-900"><%= total %></span>건</div>
    </header>

    <div class="p-6 lg:p-8">
      <div class="max-w-[1400px] mx-auto">

        <!-- 검색/필터 폼 -->
        <form id="searchF" method="get" action="<%= ctx %>/admin/boards.do"
              class="bg-white rounded-2xl border border-gray-200 p-5 shadow-sm">

          <!-- [의미] 페이징 이동 시에도 같은 조건 유지하기 위해 page를 숨김값으로 보관 -->
          <input type="hidden" name="page" id="page" value="<%= curPage %>"/>

          <div class="grid grid-cols-1 lg:grid-cols-12 gap-3">
            <!-- 게시판 종류 -->
            <div class="lg:col-span-2">
              <div class="text-[11px] font-extrabold text-gray-500 mb-1">게시판</div>
              <select name="kind" id="kind" class="field w-full">
                <option value="ALL"    <%= "ALL".equals(kind) ? "selected" : "" %>>전체</option>
                <option value="NOTICE" <%= "NOTICE".equals(kind) ? "selected" : "" %>>공지사항</option>
                <option value="QNA"    <%= "QNA".equals(kind) ? "selected" : "" %>>문의글</option>
                <option value="REVIEW" <%= "REVIEW".equals(kind) ? "selected" : "" %>>리뷰글</option>
              </select>
            </div>

            <!-- 검색 기준 -->
            <div class="lg:col-span-2">
              <div class="text-[11px] font-extrabold text-gray-500 mb-1">검색기준</div>
              <select name="stype" id="stype" class="field w-full">
                <option value="all"    <%= "all".equals(stype) ? "selected" : "" %>>전체(제목+내용+작성자)</option>
                <option value="title"  <%= "title".equals(stype) ? "selected" : "" %>>제목</option>
                <option value="writer" <%= "writer".equals(stype) ? "selected" : "" %>>작성자</option>
                <option value="content"<%= "content".equals(stype) ? "selected" : "" %>>내용</option>
              </select>
            </div>

            <!-- 작성자 권한 -->
            <div class="lg:col-span-2">
              <div class="text-[11px] font-extrabold text-gray-500 mb-1">작성자</div>
              <select name="role" id="role" class="field w-full">
                <option value="ALL"   <%= "ALL".equals(role) ? "selected" : "" %>>전체</option>
                <option value="ADMIN" <%= "ADMIN".equalsIgnoreCase(role) ? "selected" : "" %>>관리자</option>
                <option value="USER"  <%= "USER".equalsIgnoreCase(role) ? "selected" : "" %>>USER</option>
              </select>
            </div>

            <!-- 기간 -->
            <div class="lg:col-span-2">
              <div class="text-[11px] font-extrabold text-gray-500 mb-1">시작일</div>
              <input type="date" name="from" id="from" value="<%= from %>" class="field w-full"/>
            </div>
            <div class="lg:col-span-2">
              <div class="text-[11px] font-extrabold text-gray-500 mb-1">종료일</div>
              <input type="date" name="to" id="to" value="<%= to %>" class="field w-full"/>
            </div>

            <!-- 검색어 -->
            <div class="lg:col-span-4">
              <div class="text-[11px] font-extrabold text-gray-500 mb-1">검색어</div>
              <input type="text" name="q" id="q" value="<%= q %>" class="field w-full" placeholder="예) 안녕하세요"/>
            </div>
          </div>

          <div class="flex gap-2 mt-4">
            <button type="submit" class="btn btn-md btn-primary">검색</button>
            <a href="<%= ctx %>/admin/boards.do" class="btn btn-md btn-gray">초기화</a>
          </div>
        </form>

        <!-- 결과 테이블 -->
        <div class="mt-5 bg-white rounded-2xl border border-gray-200 overflow-hidden shadow-sm">
          <!-- 작업 위치: /src/main/webapp/WEB-INF/views/admin/boards.jsp  (검색 결과 헤더 영역) -->

<!-- 작업 위치: /src/main/webapp/WEB-INF/views/admin/boards.jsp (검색 결과 헤더 영역) -->

<div class="px-5 py-4 border-b border-gray-200 flex items-center justify-between">
  <div class="font-extrabold text-slate-900">검색 결과</div>

  <div class="flex items-center gap-2">
    <!-- [존재이유] 관리자 화면에서 바로 공지 등록으로 진입해서 운영 UX를 줄이기 -->
    <a href="<%= ctx %>/admin/noticeWrite.do?back=<%= back %>" class="btn btn-md btn-primary">
      공지사항 작성
    </a>

    <!-- [존재이유] 관리자도 사용자 화면의 문의게시판(QNA)로 즉시 이동해 확인/답변 흐름을 빠르게 하기 -->
    <a href="<%= ctx %>/board.do#qna" class="btn btn-md btn-gray">
      문의게시판 바로가기
    </a>

    <!-- 기존 "행 클릭 → 상세" 문구는 요청대로 삭제 -->
  </div>
</div>



          <div class="overflow-x-auto">
            <table class="min-w-full text-sm">
              <thead class="bg-slate-50 text-gray-600">
                <tr>
                  <th class="px-4 py-3 text-left font-extrabold">유형</th>
                  <th class="px-4 py-3 text-left font-extrabold">글번호</th>
                  <th class="px-4 py-3 text-left font-extrabold">제목</th>
                  <th class="px-4 py-3 text-left font-extrabold">작성자</th>
                  <th class="px-4 py-3 text-left font-extrabold">작성일</th>
                  <th class="px-4 py-3 text-left font-extrabold">조회</th>
                  <th class="px-4 py-3 text-left font-extrabold">상태/별점</th>
                </tr>
              </thead>

              <tbody class="divide-y divide-gray-100">
              <%
                for(AdminBoardPostVO it : list){
                  // [의미] 이제 "관리자 글"로 공지를 판단하지 않고, postType으로 명확히 판단한다.
                  boolean isNotice = "NOTICE".equals(it.getPostType());
                  boolean isQna    = "QNA".equals(it.getPostType());
                  boolean isReview = "REVIEW".equals(it.getPostType());

                  String typeLabel = isNotice ? "공지" : (isQna ? "문의" : "리뷰");

                  boolean isAdminWriter = (it.getWriterRole() != null && "ADMIN".equalsIgnoreCase(it.getWriterRole()));

                  // [스타일] 행 배경색(공지/문의/리뷰) + 관리자 작성자면 글자색만 강조
                  String trBgClass =   isNotice ? "bg-red-50"    : isQna    ? "bg-sky-50"  :     "bg-yellow-50";

                  // [스타일] 상태/별점 텍스트
                  String stat = "";
                  String statColorClass = "text-slate-700";

                  if(isNotice){
                    stat = "공지사항";
                    statColorClass = "text-gray-600 font-bold";
                  } else if(isQna){
                    boolean isDone = "DONE".equalsIgnoreCase(it.getQnaStatus());
                    stat = isDone ? "답변완료" : "답변대기";
                    statColorClass = isDone ? "text-blue-600" : "text-rose-500";
                  } else {
                    stat = (it.getReviewRating() == null) ? "-" : ("★ " + it.getReviewRating());
                    statColorClass = "text-amber-600";
                  }

                  // [스타일] 유형 배지 색
                  String badgeCls =
                      isNotice ? "bg-amber-100 text-amber-800"
                    : isQna    ? "bg-indigo-100 text-indigo-700"
                    :            "bg-emerald-100 text-emerald-700";
              %>
                <tr class="rowHover cursor-pointer <%= trBgClass %>"
                    onclick="location.href='<%= ctx %>/admin/boardView.do?postType=<%= it.getPostType() %>&postNo=<%= it.getPostNo() %>&back=<%= back %>'">
                  <td class="px-4 py-3">
                    <span class="px-2 py-1 rounded-lg text-xs font-extrabold <%= badgeCls %>">
                      <%= typeLabel %>
                    </span>
                  </td>

                  <td class="px-4 py-3 font-semibold text-slate-700"><%= it.getPostNo() %></td>

                  <td class="px-4 py-3">
                    <div class="font-extrabold text-slate-900"><%= it.getTitle() %></div>
                    <div class="text-xs text-gray-500"><%= it.getUserId() %></div>
                  </td>

                  <td class="px-4 py-3">
                    <div class="font-bold <%= isAdminWriter ? "text-red-600" : "text-slate-800" %>"><%= it.getWriterName() %></div>
                    <div class="text-xs text-gray-500"><%= it.getWriterRole() %></div>
                  </td>

                  <td class="px-4 py-3 text-slate-700"><%= it.getCreatedAtStr() %></td>
                  <td class="px-4 py-3 text-slate-700"><%= it.getHit() %></td>
                  <td class="px-4 py-3 font-extrabold <%= statColorClass %>"><%= stat %></td>
                </tr>
              <%
                }
                if(list.isEmpty()){
              %>
                <tr class="bg-white">
                  <td colspan="7" class="px-4 py-10 text-center text-gray-500 font-semibold">
                    검색 결과가 없습니다.
                  </td>
                </tr>
              <%
                }
              %>
              </tbody>
            </table>
          </div>

          <!-- 페이징 -->
          <div class="px-5 py-4 border-t border-gray-200 flex items-center justify-between bg-white">
            <div class="text-xs text-gray-500">Page <%= curPage %> / <%= totalPages %></div>
            <div class="flex gap-2">
              <%
                String base = ctx + "/admin/boards.do?kind=" + kind + "&stype=" + stype + "&role=" + role
                             + "&from=" + from + "&to=" + to + "&q=" + java.net.URLEncoder.encode(q, "UTF-8");
              %>
              <a class="btn btn-sm btn-gray <%= (curPage<=1) ? "pointer-events-none opacity-50" : "" %>"
                 href="<%= base %>&page=<%= curPage-1 %>">이전</a>
              <a class="btn btn-sm btn-gray <%= (curPage>=totalPages) ? "pointer-events-none opacity-50" : "" %>"
                 href="<%= base %>&page=<%= curPage+1 %>">다음</a>
            </div>
          </div>
        </div>

      </div>
    </div>
  </main>
</div>
<!-- 작업 위치: /src/main/webapp/WEB-INF/views/admin/boards.jsp  (맨 아래 <script> 안) -->

<script>
  // [의미] 검색 필터만 바꿀 때 "다른 조건은 그대로" 유지하고 즉시 재조회하기 위함
  //        (페이지는 1로 되돌리는 게 자연스러움)
  const f = document.querySelector("#searchF");
  const pageInp = document.querySelector("#page");
  const kindEl = document.querySelector("#kind");
  const roleEl = document.querySelector("#role");

  function submitResetPage(){
    pageInp.value = "1";       // [의미] 필터 바꾸면 보통 1페이지부터 다시 보는 UX
    f.submit();                // [의미] 서버렌더링 방식이라 form submit으로 재조회
  }

  // ✅ 여기부터 교체
  kindEl.addEventListener("change", ()=>{
    const k = kindEl.value;

    // [존재이유] "문의글/리뷰글"은 기본적으로 회원 글을 보는 경우가 대부분이라 UI 혼란을 줄이려는 자동 보정
    if (k === "QNA" || k === "REVIEW") {
      roleEl.value = "USER";   // [의미] 회원글만 보도록 작성자 필터 자동 세팅
    }
    // [존재이유] "공지사항"은 관리자 글만 존재해야 정상이라 자동 보정
    else if (k === "NOTICE") {
      roleEl.value = "ADMIN";  // [의미] 관리자만 보도록 작성자 필터 자동 세팅
    }
    // ✅ 핵심: 전체(ALL)로 돌아오면 role도 반드시 ALL로 원복해야 공지가 다시 보인다
    else {
      roleEl.value = "ALL";    // [의미] 전체 목록에서는 작성자 조건을 풀어서 공지 포함 전부 조회
    }

    submitResetPage();
  });
  // ✅ 여기까지 교체

  ["stype","role","from","to"].forEach(id=>{
    const el = document.querySelector("#" + id);
    el.addEventListener("change", submitResetPage);
  });
</script>

</body>
</html>
