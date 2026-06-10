<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  // [의미] 사이드바에서 게시판 메뉴 활성화
  request.setAttribute("adminActive", "boards");

  String ctx = request.getContextPath();

  // [의미] 작성 화면 → 목록으로 돌아갈 때 검색조건 유지용
  String back = (String)request.getAttribute("back");
  if(back == null) back = "";

  // [존재이유] back이 있으면 “그 검색조건 그대로” 목록으로 복귀
  String listUrl = ctx + "/admin/boards.do";
  if(!back.isBlank()){
    listUrl = ctx + "/admin/boards.do?" + java.net.URLDecoder.decode(back, "UTF-8");
  }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>공지사항 작성 - TryCatchTrip</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-50">
<div class="flex h-screen overflow-hidden">

  <%@ include file="/WEB-INF/views/admin/adminSidebar.jspf"%>

  <main class="flex-1 flex flex-col bg-slate-50 overflow-y-auto">
    <header class="h-16 bg-white border-b border-gray-200 flex items-center justify-between px-8 sticky top-0 z-10">
      <div class="text-indigo-600 font-bold">공지사항 작성</div>
      <a href="<%= listUrl %>" class="px-4 py-2 rounded-xl bg-gray-100 hover:bg-gray-200 font-extrabold text-sm">목록으로</a>
    </header>

    <section class="p-8">
      <div class="max-w-3xl bg-white border border-gray-200 rounded-2xl shadow-sm p-6">
        <!-- [존재이유] 공지는 QNA_BOARD에 저장하되 IS_NOTICE='Y'로 등록 -->
        <form method="post" action="<%= ctx %>/admin/noticeWrite.do">
          <!-- [의미] 작성 후 복귀할 목록 검색조건 유지 -->
          <input type="hidden" name="back" value="<%= back %>"/>

          <div class="mb-4">
            <div class="text-xs font-extrabold text-gray-500 mb-1">제목</div>
            <input type="text" name="title"
                   class="w-full rounded-xl border border-gray-200 px-4 py-3 font-semibold outline-none focus:ring-2 focus:ring-indigo-200"
                   placeholder="공지 제목을 입력하세요" />
          </div>

          <div class="mb-6">
            <div class="text-xs font-extrabold text-gray-500 mb-1">내용</div>
            <!-- name을 qnaCtt로 두는 이유: 기존 QNA 모델(QnaVO) 필드명과 동일하게 맞추려는 정책 -->
            <textarea name="qnaCtt" rows="10"
                      class="w-full rounded-xl border border-gray-200 px-4 py-3 font-semibold outline-none focus:ring-2 focus:ring-indigo-200"
                      placeholder="공지 내용을 입력하세요"></textarea>
          </div>

          <div class="flex gap-2">
            <button type="submit"
                    class="px-5 py-3 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white font-extrabold">
              등록
            </button>

            <a href="<%= listUrl %>"
               class="px-5 py-3 rounded-xl bg-gray-100 hover:bg-gray-200 font-extrabold">
              취소
            </a>
          </div>
        </form>
      </div>
    </section>
  </main>
</div>
</body>
</html>
