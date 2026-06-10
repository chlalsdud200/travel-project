<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="kr.or.ddit.tct.users.vo.UserVO"%>
<%
// 좌측 메뉴 활성화
request.setAttribute("adminActive", "members");

@SuppressWarnings("unchecked")
List<UserVO> userList = (List<UserVO>) request.getAttribute("userList");
if (userList == null) userList = new ArrayList<>();

Integer totalCountObj = (Integer) request.getAttribute("totalCount");
int totalCount = (totalCountObj == null) ? userList.size() : totalCountObj.intValue();

Integer newMembers7dObj = (Integer) request.getAttribute("newMembers7d");
String newMembers7dText = (newMembers7dObj == null) ? "-" : (newMembers7dObj + "명");



// 검색 조건(유지)
String qUserId   = request.getParameter("qUserId")   == null ? "" : request.getParameter("qUserId").trim();
String qUserName = request.getParameter("qUserName") == null ? "" : request.getParameter("qUserName").trim();
String qRole     = request.getParameter("qRole")     == null ? "" : request.getParameter("qRole").trim();

String msg = request.getParameter("msg");
String openUserId = request.getParameter("openUserId"); // 업데이트 후 자동 펼침용
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>회원관리 - TryCatchTrip</title>

<!-- (대시보드.html과 동일 스택) -->
<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<style>
@import
	url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap')
	;

body {
	font-family: 'Inter', sans-serif;
}

.btn {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	border-radius: 12px;
	font-weight: 800;
	border: 1px solid transparent;
	cursor: pointer;
	user-select: none;
	transition: background-color .15s ease, opacity .15s ease, border-color
		.15s ease;
	white-space: nowrap;
}

.btn-sm {
	height: 36px;
	padding: 0 12px;
	font-size: 12px;
}

.btn-md {
	height: 44px;
	padding: 0 16px;
	font-size: 14px;
}

.btn-primary {
	background: #4f46e5;
	color: #fff;
}

.btn-primary:hover {
	opacity: .92;
}

.btn-dark {
	background: #0f172a;
	color: #fff;
}

.btn-dark:hover {
	opacity: .92;
}

.btn-gray {
	background: #f3f4f6;
	color: #374151;
}

.btn-gray:hover {
	background: #e5e7eb;
}

.btn-danger {
	background: #fef2f2;
	color: #dc2626;
}

.btn-danger:hover {
	background: #fee2e2;
}

.detail-wrap label {
	font-size: 11px;
	font-weight: 800;
	color: #6b7280;
}

.detail-wrap input, .detail-wrap select {
	height: 42px;
	width: 100%;
	border: 1px solid #e5e7eb;
	border-radius: 12px;
	padding: 0 12px;
	outline: none;
	background: #fff;
}

.detail-wrap input:focus, .detail-wrap select:focus {
	box-shadow: 0 0 0 3px rgba(79, 70, 229, .15);
	border-color: rgba(79, 70, 229, .35);
}

.toast {
	position: fixed;
	right: 18px;
	top: 18px;
	z-index: 9999;
	background: #0f172a;
	color: #fff;
	padding: 10px 14px;
	border-radius: 12px;
	font-size: 13px;
	font-weight: 700;
	opacity: 0;
	transform: translateY(-6px);
	transition: opacity .18s ease, transform .18s ease;
	pointer-events: none;
}

.toast.show {
	opacity: 1;
	transform: translateY(0);
}
</style>
</head>

<body class="bg-gray-50">
	<div class="flex h-screen overflow-hidden">

		<!-- LEFT SIDEBAR -->
		<%@ include file="/WEB-INF/views/admin/adminSidebar.jspf"%>

		<!-- MAIN -->
		<main class="flex-1 flex flex-col bg-slate-50 overflow-y-auto">

			<!-- TOP HEADER -->
			<header
				class="h-16 bg-white border-b border-gray-200 flex items-center justify-between px-8 sticky top-0 z-10">
				<div class="flex items-center">
					 <span
						class="text-indigo-600 font-bold">회원관리</span>
					</span>
				</div>

				<div class="flex items-center space-x-6">
					<div class="relative">
						<i
							class="fas fa-bell text-gray-400 cursor-pointer hover:text-indigo-600"></i>
						<span
								class="absolute -top-1 -right-1 bg-red-500 text-white text-[10px] rounded-full w-4 h-4 flex items-center justify-center"></span>
					</div>

					<div
						class="flex items-center space-x-2 border-l pl-6 border-gray-200">
						<div
							class="w-8 h-8 rounded-full bg-indigo-100 flex items-center justify-center text-indigo-700 font-bold text-xs">A</div>
						<span class="text-sm font-semibold text-gray-700">관리자님</span>
					</div>
				</div>
			</header>

			<!-- CONTENT -->
			<div class="p-6 lg:p-8">
				<div class="max-w-[1400px] 2xl:max-w-[1600px] mx-auto">

					<!-- Toast -->
					<div id="toast" class="toast">처리되었습니다.</div>

					<!-- 상단 요약 -->
					<div
						class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-6 mb-8">
						<div
							class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 xl:col-span-2">
							<div class="flex justify-between items-start">
								<div>
									<p class="text-sm text-gray-500 font-medium">총 회원수</p>
									<h3 class="text-2xl font-bold mt-1"><%=totalCount%>명
									</h3>
								</div>
								<div class="p-2 bg-indigo-50 text-indigo-600 rounded-lg">
									<i class="fas fa-users"></i>
								</div>
							</div>
							<p class="text-xs text-gray-400 mt-4 font-medium">※ 신규회원(최근
								7일) 기능은 가입일 컬럼이 있어야 정확히 계산됩니다.</p>
						</div>

						<div
							class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 xl:col-span-2">
							<div class="flex justify-between items-start">
								<div>
									<p class="text-sm text-gray-500 font-medium">신규 회원(최근 7일)</p>
								<h3 class="text-2xl font-bold mt-1 text-indigo-600"><%= newMembers7dText %></h3>

								</div>
								<div class="p-2 bg-blue-50 text-blue-600 rounded-lg">
									<i class="fas fa-user-plus"></i>
								</div>
							</div>
							<p class="text-xs text-gray-400 mt-4 font-medium">※ USERS에
								가입일(예: CREATED_AT) 추가 시 반영</p>
						</div>
					</div>

					<!-- 검색/필터 -->
					<div
						class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden mb-6">
						<div
							class="p-6 border-b border-gray-50 flex items-center justify-between">
							<div class="flex items-center gap-3">
								<div
									class="w-10 h-10 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center">
									<i class="fas fa-search"></i>
								</div>
								<div>
									<h3 class="font-bold text-gray-800">회원 검색</h3>
									<p class="text-xs text-gray-400 mt-1">USER_ID / USER_NAME /
										ROLE 기준</p>
								</div>
							</div>
						</div>

						<form method="get"
							action="<%=request.getContextPath()%>/admin/members.do"
							class="p-6">
							<div class="grid grid-cols-1 md:grid-cols-3 gap-4">
								<div>
									<label class="text-xs font-bold text-gray-500">USER_ID</label>
									<input name="qUserId" value="<%=qUserId%>" type="text"
										placeholder="예: minsu01"
										class="mt-2 w-full h-11 px-4 rounded-xl border border-gray-200 bg-white outline-none focus:ring-2 focus:ring-indigo-200" />
								</div>

								<div>
									<label class="text-xs font-bold text-gray-500">USER_NAME</label>
									<input name="qUserName" value="<%=qUserName%>" type="text"
										placeholder="예: 김민수"
										class="mt-2 w-full h-11 px-4 rounded-xl border border-gray-200 bg-white outline-none focus:ring-2 focus:ring-indigo-200" />
								</div>

								<div>
									<label class="text-xs font-bold text-gray-500">ROLE</label> 
									<select		name="qRole"	class="mt-2 w-full h-11 px-4 rounded-xl border border-gray-200 bg-white outline-none focus:ring-2 focus:ring-indigo-200">
										
										<option value="" <%=qRole.isEmpty() ? "selected" : ""%>>전체</option>
										<option value="USER"
											<%="USER".equalsIgnoreCase(qRole) ? "selected" : ""%>>USER</option>
										<option value="ADMIN"
											<%="ADMIN".equalsIgnoreCase(qRole) ? "selected" : ""%>>ADMIN</option>
										<option value="WITHDRAWN"  <%="WITHDRAWN".equalsIgnoreCase(qRole) ? "selected" : ""%>>WITHDRAWN</option>
									</select>
								</div>
							</div>

							<div class="mt-4 flex flex-col sm:flex-row gap-2 sm:justify-end">
								<a href="<%=request.getContextPath()%>/admin/members.do"
									class="btn btn-gray btn-md">초기화</a>
								<button type="submit" class="btn btn-primary btn-md">검색</button>
							</div>
						</form>
					</div>

					<!-- 결과 테이블 -->
					<div
						class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
						<div
							class="p-6 border-b border-gray-50 flex items-center justify-between gap-4">
							<h3 class="font-bold text-gray-800">회원 목록</h3>
							<p class="text-sm text-gray-400 font-semibold"><%=userList.size()%>건
							</p>
						</div>

						<div class="overflow-x-auto">
							<table class="w-full text-left">
								<thead
									class="bg-gray-50 text-gray-400 text-[11px] uppercase tracking-widest font-bold">
									<tr>
										<th class="px-6 py-4">USER_ID</th>
										<th class="px-6 py-4">ROLE</th>
										<th class="px-6 py-4">USER_NAME</th>
										<th class="px-6 py-4">USER_TEL</th>
										<th class="px-6 py-4">USER_EMAIL</th>
										<th class="px-6 py-4 text-center">관리</th>
									</tr>
								</thead>

								<tbody class="text-sm text-gray-700 divide-y divide-gray-50">
									<%
									if (userList.isEmpty()) {
									%>
									<tr>
										<td class="px-6 py-10 text-center text-gray-400" colspan="6">회원
											데이터가 없습니다.</td>
									</tr>
									<%
									} else {
									for (UserVO u : userList) {
										String uid   = (u.getUserId()    == null) ? "" : u.getUserId();
										String role  = (u.getRole()      == null) ? "" : u.getRole();
										String nm    = (u.getUserName()  == null) ? "" : u.getUserName();
										String tel   = (u.getUserTel()   == null) ? "" : u.getUserTel();
										String email = (u.getUserEmail() == null) ? "" : u.getUserEmail();
										String bir   = (u.getUserBir()   == null) ? "" : u.getUserBir();
										String addr1 = (u.getUserAddr1() == null) ? "" : u.getUserAddr1();
										String addr2 = (u.getUserAddr2() == null) ? "" : u.getUserAddr2();
										String zip   = (u.getUserZip()   == null) ? "" : u.getUserZip();
									%>

									<!-- 메인 행 -->
									<tr class="hover:bg-slate-50 transition">
										<td class="px-6 py-4 font-mono text-gray-600"><%=uid%></td>
										<td class="px-6 py-4"><span
											class="inline-flex items-center rounded-full px-2.5 py-1 text-xs font-bold
                        <%="ADMIN".equalsIgnoreCase(role)
		? "bg-indigo-50 text-indigo-700 border border-indigo-100"
		: "bg-gray-50 text-gray-600 border border-gray-100"%>">
												<%=role.isEmpty() ? "-" : role%>
										</span></td>
										<td class="px-6 py-4 font-semibold"><%=nm%></td>
										<td class="px-6 py-4"><%=tel%></td>
										<td class="px-6 py-4"><%=email%></td>
										<td class="px-6 py-4">
											<div class="flex items-center justify-center gap-2">
												<button type="button" class="btn btn-dark btn-sm btn-toggle"
													data-userid="<%=uid%>">상세/수정</button>
											</div>
										</td>
									</tr>

									<!-- 아코디언 상세/수정 행 -->
									<tr id="detail-<%=uid%>" class="detail-row hidden bg-slate-50">
										<td colspan="6" class="px-6 py-6">
											<div
												class="detail-wrap bg-white border border-gray-100 rounded-2xl shadow-sm p-6">
												<div class="flex items-start justify-between gap-6">
													<div>
														<h4 class="text-base font-extrabold text-slate-800">회원
															상세 / 수정</h4>
														<p class="text-xs text-gray-400 mt-1">USER_ID는 PK이므로
															변경하지 않습니다. 비밀번호는 입력 시에만 변경됩니다.</p>
													</div>
													<button type="button" class="btn btn-gray btn-sm btn-close"
														data-userid="<%=uid%>">접기</button>
												</div>

												<!-- 1) 업데이트 FORM -->
												<form id="upd-<%=uid%>" method="post"
													action="<%=request.getContextPath()%>/admin/memberUpdate.do"
													class="mt-6">
													<!-- 검색조건 유지 -->
													<input type="hidden" name="qUserId" value="<%=qUserId%>">
													<input type="hidden" name="qUserName" value="<%=qUserName%>">
													<input type="hidden" name="qRole" value="<%=qRole%>">

													<div class="grid grid-cols-1 md:grid-cols-3 gap-4">
														<div>
															<label>USER_ID</label>
															<input type="text" value="<%=uid%>" disabled />
															<input type="hidden" name="userId" value="<%=uid%>" />
														</div>

														<div>
															<label>ROLE</label>
															<select name="role">
															
															
																<option value="USER"
																	<%="USER".equalsIgnoreCase(role) ? "selected" : ""%>>USER</option>
																<option value="ADMIN"
																	<%="ADMIN".equalsIgnoreCase(role) ? "selected" : ""%>>ADMIN</option>
															<option value="WITHDRAWN"  <%="WITHDRAWN".equalsIgnoreCase(role) ? "selected" : ""%>>WITHDRAWN</option>
															</select>
														</div>

														<div>
															<label>USER_NAME</label>
															<input type="text" name="userName" value="<%=nm%>" />
														</div>

														<div>
															<label>USER_BIR</label>
															<input type="date" name="userBir" value="<%=bir%>" />
														</div>

														<div>
															<label>USER_EMAIL</label>
															<input type="email" name="userEmail" value="<%=email%>" />
														</div>

														<div>
															<label>USER_TEL</label>
															<input type="text" name="userTel" value="<%=tel%>" />
														</div>

														<div class="md:col-span-2">
															<label>USER_ADDR1</label>
															<input type="text" name="userAddr1" value="<%=addr1%>" />
														</div>

														<div>
															<label>USER_ZIP</label>
															<input type="text" name="userZip" value="<%=zip%>" />
														</div>

														<div class="md:col-span-3">
															<label>USER_ADDR2</label>
															<input type="text" name="userAddr2" value="<%=addr2%>" />
														</div>

														<div class="md:col-span-3">
															<label>USER_PASS</label>
															<input type="password" name="userPass" value="" placeholder="변경 시에만 입력" />
														</div>
													</div>
												</form>

												<!-- 2-1) 탈퇴(soft delete) FORM -->
												<form id="wd-<%=uid%>" method="post"
												  action="<%=request.getContextPath()%>/admin/memberWithdraw.do">
												  <input type="hidden" name="userId" value="<%=uid%>">
												  <!-- 검색조건 유지 -->
												  <input type="hidden" name="qUserId" value="<%=qUserId%>">
												  <input type="hidden" name="qUserName" value="<%=qUserName%>">
												  <input type="hidden" name="qRole" value="<%=qRole%>">
												</form>
																								
												<!-- 2) 삭제 FORM: 업데이트 폼과 완전히 분리 (중요) -->
												<form id="del-<%=uid%>" method="post"
													action="<%=request.getContextPath()%>/admin/memberDelete.do">
													<input type="hidden" name="userId" value="<%=uid%>">
													<!-- 검색조건 유지 -->
													<input type="hidden" name="qUserId" value="<%=qUserId%>">
													<input type="hidden" name="qUserName" value="<%=qUserName%>">
													<input type="hidden" name="qRole" value="<%=qRole%>">
												</form>
												

												<!-- 3) 버튼영역: form 속성으로 제출 대상 지정 -->
												<div class="mt-6 flex flex-col sm:flex-row gap-2 sm:justify-end">
													<button type="button" class="btn btn-gray btn-md btn-cancel"
														data-userid="<%=uid%>">취소</button>
													
													 <!-- 탈퇴 처리(WITHDRAWN) -->
												  <button type="submit" class="btn btn-gray btn-md"
												    form="wd-<%=uid%>"
												    onclick="return confirm('정말 탈퇴 처리(WITHDRAWN)할까요?\n탈퇴 처리 후에는 로그인할 수 없습니다.');">
												    탈퇴처리(WITHDRAWN)
												  </button>
										
										
													<button type="submit" class="btn btn-danger btn-md"
														form="del-<%=uid%>"
														onclick="return confirm('정말 회원탈퇴(삭제) 처리할까요? 삭제 후 복구가 어렵습니다.');">
														회원정보완전삭제
													</button>

													<button type="submit" class="btn btn-primary btn-md" form="upd-<%=uid%>">적용	</button>
													
												</div>

											</div>
										</td>
									</tr>

									<%
									} // end for
									} // end else
									%>
								</tbody>
							</table>
						</div>

					</div>
				</div>
			</div>
		</main>
	</div>

	<script>
    // 아코디언 열기/닫기
    const openDetail = (userId) => {
      // 다른 행 닫기
      document.querySelectorAll(".detail-row").forEach(r => r.classList.add("hidden"));
      const row = document.getElementById("detail-" + userId);
      if (!row) return;
      row.classList.remove("hidden");
      row.scrollIntoView({ behavior: "smooth", block: "center" });
    };

    const closeDetail = (userId) => {
      const row = document.getElementById("detail-" + userId);
      if (!row) return;
      row.classList.add("hidden");
    };

    document.querySelectorAll(".btn-toggle").forEach(btn => {
      btn.addEventListener("click", () => {
        const userId = btn.dataset.userid;
        const row = document.getElementById("detail-" + userId);
        if (!row) return;
        const isHidden = row.classList.contains("hidden");
        if (isHidden) openDetail(userId);
        else closeDetail(userId);
      });
    });

    document.querySelectorAll(".btn-close").forEach(btn => {
      btn.addEventListener("click", () => closeDetail(btn.dataset.userid));
    });

    document.querySelectorAll(".btn-cancel").forEach(btn => {
      btn.addEventListener("click", () => closeDetail(btn.dataset.userid));
    });

    // 업데이트 완료 후 자동 펼침
    const openUserId = "<%=(openUserId == null) ? "" : openUserId%>";
    if (openUserId) {
      window.addEventListener("load", () => openDetail(openUserId));
    }

    // 토스트: msg 매핑
    const msg = "<%=(msg == null) ? "" : msg%>";
    if (msg) {
      const toast = document.getElementById("toast");
      const map = {
    		  ok: "회원정보가 적용되었습니다.",
    		  fail: "회원정보 적용에 실패했습니다.",
    		  delete_ok: "회원이 삭제되었습니다.",
    		  delete_fail: "회원 삭제에 실패했습니다. (연관 데이터/제약조건 확인 필요)",
    		  withdraw_ok: "회원이 탈퇴 처리(WITHDRAWN)되었습니다.",
    		  withdraw_fail: "탈퇴 처리에 실패했습니다. (이미 탈퇴/ADMIN 여부 확인)"
    		};

      toast.textContent = map[msg] || msg;
      toast.classList.add("show");
      setTimeout(() => toast.classList.remove("show"), 2000);
    }
  </script>
</body>
</html>
