<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.or.ddit.tct.users.vo.UserVO" %>

<%
  UserVO loginUser = (UserVO) session.getAttribute("loginUser");
%>

<div class="d-flex justify-content-between align-items-end mb-3">
  <div>
    <div class="fw-bold fs-4" style="letter-spacing: -0.02em;">Q&amp;A</div>
    <div class="text-muted small fw-bold">문의 수정</div>
  </div>

  <div class="d-flex align-items-center gap-2">
    <button type="button" class="btn btn-light btn-sm fw-bold border" id="btnQnaEditCancel"
            style="height: 38px; border-radius: 8px; color: #666;">
      취소하기
    </button>
  </div>
</div>

<div class="card" style="border-radius: 14px;">
  <div class="card-body" style="padding: 18px;">
    <form id="qnaEditF">

      <!-- 어떤 글을 수정하는지 식별하려고 qnaNo를 숨겨둔다 -->
      <input type="hidden" id="qnaEditNo" name="qnaNo" value="">

      <!-- 화면 표시용: 로그인 사용자(작성자) -->
      <div class="mb-3">
        <label class="form-label fw-bold">작성자</label>
        <input type="text" class="form-control" id="qnaEditWriter"
               value="<%= loginUser.getUserName() %>" readonly>
      </div>

      <div class="mb-3">
        <label class="form-label fw-bold">제목</label>
        <input type="text" class="form-control" id="qnaEditTitle" name="title" placeholder="제목을 입력하세요">
      </div>

      <div class="mb-3">
        <label class="form-label fw-bold">내용</label>
        <textarea class="form-control" id="qnaEditContent" name="qnaCtt" rows="5" placeholder="내용을 입력하세요"></textarea>
      </div>

      <div class="d-flex justify-content-end gap-2 mt-4">
        <button type="button" id="btnQnaEditSubmit"
                class="btn btn-primary px-4 fw-bold"
                style="border-radius: 8px; background-color: #007bff; border: none; box-shadow: 0 4px 6px rgba(0, 123, 255, 0.2);">
          수정 저장
        </button>
      </div>

    </form>
  </div>
</div>
