<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.or.ddit.tct.admin.boards.vo.AdminBoardPostVO"%>
<%
  String ctx = request.getContextPath();
  AdminBoardPostVO post = (AdminBoardPostVO)request.getAttribute("post");
  String back = (String)request.getAttribute("back");
  if(back == null) back = "";

  String listUrl = ctx + "/admin/boards.do";
  if(!back.isBlank()){
    listUrl = ctx + "/admin/boards.do?" + java.net.URLDecoder.decode(back, "UTF-8");
  }

  // 게시글 정보 판단
  boolean isQna = (post != null && "QNA".equals(post.getPostType()));
  boolean isNotice = (post != null && "Y".equalsIgnoreCase(post.getIsNotice())); // 공지 여부 체크

  String typeLabel = isQna ? "문의글" : "리뷰글";
  
  // 테마 컬러 설정
  String badgeClass = isQna ? "bg-indigo-100 text-indigo-700" : "bg-amber-100 text-amber-700";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>게시글 상세 - TryCatchTrip</title>

<script src="https://cdn.tailwindcss.com"></script>
<style>
  body{font-family: Inter, sans-serif;}
  .btnA{display:inline-flex;align-items:center;justify-content:center;border-radius:12px;font-weight:900;border:1px solid transparent;cursor:pointer;transition:.15s;white-space:nowrap}
  .btnA:hover{opacity:.93}
</style>
</head>

<body class="bg-gray-50">
<div class="flex h-screen overflow-hidden">

  <%@ include file="/WEB-INF/views/admin/adminSidebar.jspf"%>

  <main class="flex-1 flex flex-col bg-slate-50 overflow-y-auto">
    <header class="h-16 bg-white border-b border-gray-200 flex items-center justify-between px-8 sticky top-0 z-10">
      <div class="text-indigo-600 font-bold">게시글 상세</div>

      <div class="flex items-center gap-2">
        <%-- [기능] 관리자 삭제 폼 유지 --%>
        <% if(post != null){ %>
          <form id="softDelF" method="post" action="<%= ctx %>/admin/boardDelete.do">
            <input type="hidden" name="mode" value="SOFT"/>
            <input type="hidden" name="postType" value="<%= post.getPostType() %>"/>
            <input type="hidden" name="postNo" value="<%= post.getPostNo() %>"/>
            <input type="hidden" name="back" value="<%= back %>"/>
          </form>

          <form id="hardDelF" method="post" action="<%= ctx %>/admin/boardDelete.do">
            <input type="hidden" name="mode" value="HARD"/>
            <input type="hidden" name="postType" value="<%= post.getPostType() %>"/>
            <input type="hidden" name="postNo" value="<%= post.getPostNo() %>"/>
            <input type="hidden" name="back" value="<%= back %>"/>
          </form>

          <button type="button"
                  class="btnA h-10 px-4 bg-slate-100 text-slate-700 hover:bg-slate-200 text-xs"
                  onclick="if(confirm('비활성화(숨김) 처리할까요?\\n(목록/일반게시판에서 안 보이게 됩니다)')) document.querySelector('#softDelF').submit();">
            비활성화
          </button>

          <button type="button"
                  class="btnA h-10 px-4 bg-rose-600 text-white hover:bg-rose-700 text-xs"
                  onclick="if(confirm('영구삭제할까요?\\n(DB에서 완전히 삭제됩니다)')) document.querySelector('#hardDelF').submit();">
            영구삭제
          </button>
        <% } %>

        <a href="<%= listUrl %>"
           class="btnA h-10 px-4 bg-gray-100 hover:bg-gray-200 text-slate-700 text-xs">
          목록으로
        </a>
      </div>
    </header>

    <div class="p-6 lg:p-8">
      <div class="max-w-[1000px] mx-auto">

        <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
          <% if(post == null){ %>
            <div class="text-center text-gray-500 font-semibold py-20">
              <div class="text-4xl mb-2">😢</div>
              해당 글을 찾을 수 없습니다.
            </div>
          <% } else { %>

            <div class="p-6 lg:p-8 border-b border-gray-100 relative">
              <div class="absolute top-0 left-0 w-full h-1 <%= isNotice ? "bg-rose-500" : (isQna ? "bg-indigo-500" : "bg-amber-400") %>"></div>

              <div class="flex flex-col md:flex-row md:items-start md:justify-between gap-4">
                <div class="flex-1">
                  <div class="flex items-center gap-2 mb-3">
                    <span class="px-2.5 py-1 rounded-md text-xs font-black tracking-wide <%= badgeClass %>">
                      <%= typeLabel %>
                    </span>
                    <% if(isNotice) { %>
                      <span class="px-2 py-1 rounded-md text-xs font-black tracking-wide bg-rose-100 text-rose-600">
                        NOTICE
                      </span>
                    <% } %>
                    <span class="text-xs text-gray-400 font-semibold tracking-wide">NO. <%= post.getPostNo() %></span>
                  </div>
                  <h1 class="text-2xl font-extrabold text-slate-900 leading-tight">
                    <%= post.getTitle() %>
                  </h1>
                </div>

                <% if(isQna) { 
                     boolean isDone = "DONE".equalsIgnoreCase(post.getQnaStatus());
                %>
                  <div class="flex-shrink-0">
                    <% if(isNotice) { %>
                      <span class="px-3 py-1.5 rounded-full text-sm font-extrabold border bg-gray-100 text-gray-600 border-gray-200">
                        공지사항
                      </span>
                    <% } else { %>
                      <span class="px-3 py-1.5 rounded-full text-sm font-extrabold border <%= isDone ? "bg-blue-50 text-blue-600 border-blue-100" : "bg-rose-50 text-rose-600 border-rose-100" %>">
                        <%= isDone ? "답변완료" : "답변대기" %>
                      </span>
                    <% } %>
                  </div>
                <% } else { %>
                  <div class="flex-shrink-0 text-center">
                     <div class="text-xs font-bold text-gray-400 mb-1">평점</div>
                     <div class="text-xl font-black text-amber-500">★ <%= post.getReviewRating() %></div>
                  </div>
                <% } %>
              </div>

              <div class="mt-6 grid grid-cols-1 md:grid-cols-3 gap-3">
                <div class="p-3 rounded-xl bg-gray-50 border border-gray-100">
                  <div class="text-[11px] font-extrabold text-gray-400 mb-0.5">WRITER</div>
                  <div class="font-bold text-slate-900 flex items-center gap-2">
                    <span class="<%= "ADMIN".equals(post.getWriterRole()) ? "text-red-600" : "" %>">
                        <%= post.getWriterName() %>
                    </span>
                    <span class="text-xs font-normal text-gray-500">(<%= post.getUserId() %>)</span>
                  </div>
                </div>
                <div class="p-3 rounded-xl bg-gray-50 border border-gray-100">
                  <div class="text-[11px] font-extrabold text-gray-400 mb-0.5">DATE</div>
                  <div class="font-bold text-slate-800"><%= post.getCreatedAtStr() %></div>
                </div>
                <div class="p-3 rounded-xl bg-gray-50 border border-gray-100">
                  <% if(isQna) { %>
                    <div class="text-[11px] font-extrabold text-gray-400 mb-0.5">HITS</div>
                    <div class="font-bold text-slate-800"><%= post.getHit() %></div>
                  <% } else { %>
                    <div class="text-[11px] font-extrabold text-gray-400 mb-0.5">ORDER NO</div>
                    <div class="font-bold text-slate-800 tracking-tight"><%= (post.getOrderNo() == null ? "-" : post.getOrderNo()) %></div>
                  <% } %>
                </div>
              </div>
            </div>

            <div class="p-6 lg:p-8 min-h-[200px]">
              <div class="text-xs font-extrabold text-gray-400 mb-3">CONTENT</div>
              <div class="prose max-w-none text-slate-800 whitespace-pre-wrap leading-relaxed">
                <%= post.getContent() %>
              </div>
            </div>

            <% if(isQna && !isNotice){ 
                 boolean hasAnswer = (post.getAnsCtt() != null && !post.getAnsCtt().isBlank());
                 
                 // [디자인] 1. 답변 유무에 따른 컨테이너 스타일
                 String ansContainerClass = hasAnswer 
                     ? "bg-indigo-50/50 border border-indigo-200 ring-1 ring-indigo-100" // 등록됨: 인디고 테두리 박스
                     : "bg-white border-2 border-dashed border-gray-300";                // 미등록: 점선 박스

                 // [디자인] 2. textarea 배경색 로직 (요청사항 반영)
                 // 등록됨 -> 기본 회색(bg-slate-100) / 포커스 시 흰색(focus:bg-white)
                 // 미등록 -> 기본 흰색(bg-white)
                 String textAreaBgClass = hasAnswer 
                     ? "bg-slate-100 focus:bg-white" 
                     : "bg-white";
            %>
              <div class="bg-slate-50 border-t border-gray-200 p-6 lg:p-8">
                <div class="flex items-center justify-between mb-4">
                  <div class="flex items-center gap-2">
                    <span class="flex items-center justify-center w-6 h-6 rounded-full bg-slate-200 text-xs font-bold text-slate-600">A</span>
                    <span class="font-extrabold text-slate-700">관리자 답변</span>
                  </div>
                  <% if(hasAnswer) { %>
                    <span class="text-xs font-medium text-gray-500">최종수정: <%= post.getAnsAtStr() %></span>
                  <% } %>
                </div>

                <form id="ansF" method="post" action="<%= ctx %>/admin/qnaAnswer.do"
                      class="<%= ansContainerClass %> rounded-2xl p-5 shadow-sm transition-colors duration-200">
                  <input type="hidden" name="qnaNo" value="<%= post.getPostNo() %>"/>
                  <input type="hidden" name="back" value="<%= back %>"/>
                  <input type="hidden" name="mode" id="ansMode" value="<%= hasAnswer ? "update" : "insert" %>"/>

                  <div class="flex justify-between items-center mb-2">
                    <div class="text-[11px] font-extrabold text-gray-500">ANSWER FORM</div>
                    <% if(hasAnswer) { %>
                      <div class="flex items-center gap-1 px-2 py-1 rounded bg-indigo-100 text-indigo-700 text-xs font-bold">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-3 w-3" viewBox="0 0 20 20" fill="currentColor">
                          <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                        </svg>
                        등록 완료
                      </div>
                    <% } else { %>
                      <div class="text-xs font-bold text-gray-400">
                        * 미등록 상태
                      </div>
                    <% } %>
                  </div>

                  <textarea name="ansCtt"
                            class="w-full min-h-[140px] border border-gray-200 rounded-xl p-3 outline-none focus:ring-2 focus:ring-indigo-200 whitespace-pre-wrap placeholder-gray-300 transition-colors duration-200 <%= textAreaBgClass %>"
                            placeholder="고객님의 문의에 대한 답변을 입력해주세요."><%= hasAnswer ? post.getAnsCtt() : "" %></textarea>

                  <div class="flex gap-2 mt-4">
                    <button type="submit"
                            class="btnA h-11 px-5 <%= hasAnswer ? "bg-indigo-600 hover:bg-indigo-700" : "bg-slate-800 hover:bg-slate-900" %> text-white shadow-sm"
                            onclick="document.querySelector('#ansMode').value='<%= hasAnswer ? "update" : "insert" %>';">
                      <%= hasAnswer ? "답변 내용 수정" : "답변 등록 하기" %>
                    </button>

                    <% if(hasAnswer){ %>
                      <button type="button"
                              class="btnA h-11 px-5 bg-white border border-gray-300 text-slate-600 hover:bg-gray-50"
                              onclick="if(!confirm('답변을 삭제할까요?')) return false; document.querySelector('#ansMode').value='delete'; document.querySelector('#ansF').submit();">
                        답변 삭제
                      </button>
                    <% } %>
                  </div>

                  <div class="text-xs text-gray-400 mt-3">
                    * 답변 등록/수정 시 처리상태는 자동으로 <span class="font-bold text-blue-600">답변완료</span>로 변경
                  </div>
                </form>
              </div>
            <% } %>

          <% } %>
        </div>

      </div>
    </div>
  </main>
</div>
</body>
</html>