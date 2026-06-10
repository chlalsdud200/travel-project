<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="adminActive" value="payments" scope="request" />

<c:set var="status" value="${empty requestScope.status ? '' : requestScope.status}" />
<c:set var="from" value="${empty requestScope.from ? '' : requestScope.from}" />
<c:set var="to" value="${empty requestScope.to ? '' : requestScope.to}" />

<c:set var="pageNo" value="${empty requestScope.page ? 1 : requestScope.page}" />
<c:set var="size" value="${empty requestScope.size ? 10 : requestScope.size}" />
<c:set var="total" value="${empty requestScope.total ? 0 : requestScope.total}" />
<c:set var="totalPages" value="${empty requestScope.totalPages ? 1 : requestScope.totalPages}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>결제관리 - TryCatchTrip</title>

  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

  <style>
    .chip {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      height: 	px;
      padding: 0 10px;
      border-radius: 999px;
      font-size: 12px;
      font-weight: 800;
      border: 1px solid rgba(15, 23, 42, .10);
      white-space: nowrap;
    }
  </style>
</head>

<body class="bg-gray-50">
  <div class="flex h-screen overflow-hidden">

    <%@ include file="/WEB-INF/views/admin/adminSidebar.jspf" %>

    <main class="flex-1 flex flex-col bg-slate-50 overflow-y-auto">

      <header class="h-16 bg-white border-b border-gray-200 flex items-center justify-between px-8 sticky top-0 z-10">
        <div class="flex items-center">
          <span class="text-sm font-medium text-slate-500">
            
            <span class="text-indigo-600 font-bold">결제관리</span>
          </span>
        </div>

        <div class="flex items-center space-x-6">
          <div class="relative">
            <i class="fa-regular fa-bell text-gray-400 cursor-pointer hover:text-indigo-600"></i>
            <span class="absolute -top-1 -right-1 bg-red-500 text-white text-[10px] rounded-full w-4 h-4 flex items-center justify-center"></span>
          </div>

          <div class="flex items-center space-x-2 border-l pl-6 border-gray-200">
            <div class="w-8 h-8 rounded-full bg-indigo-100 flex items-center justify-center text-indigo-700 font-bold text-xs">A</div>
            <span class="text-sm font-semibold text-gray-700">관리자님</span>
          </div>
        </div>
      </header>

      <div class="p-6 lg:p-8">
        <div class="max-w-[1400px] 2xl:max-w-[1600px] mx-auto">

          <div class="flex flex-col md:flex-row md:items-end md:justify-between gap-4 mb-6">
            <div>
              <h2 class="text-2xl font-extrabold text-slate-900">결제관리</h2>
              <p class="text-sm text-slate-500 mt-1">결제 내역을 기간/상태로 조회하고 확인합니다.</p>
            </div>

            <div class="bg-white border border-gray-100 rounded-2xl px-5 py-3 shadow-sm">
              <div class="text-xs text-slate-500 font-bold">총 조회 건수</div>
              <div class="text-xl font-extrabold text-slate-900 mt-1">
                <fmt:formatNumber value="${total}" type="number" />건
              </div>
            </div>
          </div>

          <form class="bg-white p-5 rounded-2xl shadow-sm border border-gray-100 mb-6"
                method="get" action="${ctx}/admin/payments.do">
            <input type="hidden" name="page" value="1" />
            <input type="hidden" name="size" value="${size}" />

            <div class="grid grid-cols-1 md:grid-cols-4 gap-4 items-end">
              <div>
                <label class="text-xs font-extrabold text-slate-500">결제상태</label>
                <select name="status" class="mt-2 w-full h-11 rounded-xl border border-gray-200 px-3 bg-white text-sm">
                  <option value="" <c:if test="${empty status}">selected</c:if>>전체</option>
                  <option value="PENDING" <c:if test="${status eq 'PENDING'}">selected</c:if>>결제대기</option>
                  <option value="PAID"    <c:if test="${status eq 'PAID'}">selected</c:if>>결제완료</option>
                  <option value="FAIL"    <c:if test="${status eq 'FAIL'}">selected</c:if>>실패</option>
                  <option value="CANCEL"  <c:if test="${status eq 'CANCEL' or status eq 'CANCELED' or status eq 'CANCELLED'}">selected</c:if>>취소</option>
                  <option value="REFUND"  <c:if test="${status eq 'REFUND'}">selected</c:if>>환불</option>
                </select>
              </div>

              <div>
                <label class="text-xs font-extrabold text-slate-500">기간(From)</label>
                <input type="date" name="from" value="${from}"
                       class="mt-2 w-full h-11 rounded-xl border border-gray-200 px-3 bg-white text-sm" />
              </div>

              <div>
                <label class="text-xs font-extrabold text-slate-500">기간(To)</label>
                <input type="date" name="to" value="${to}"
                       class="mt-2 w-full h-11 rounded-xl border border-gray-200 px-3 bg-white text-sm" />
              </div>

              <div class="flex gap-2">
                <button type="submit"
                        class="h-11 px-5 rounded-xl bg-indigo-600 text-white font-extrabold text-sm hover:opacity-95">
                  검색
                </button>
                <a href="${ctx}/admin/payments.do"
                   class="h-11 px-5 rounded-xl bg-gray-100 text-slate-700 font-extrabold text-sm hover:bg-gray-200 inline-flex items-center justify-center">
                  초기화
                </a>
              </div>
            </div>
          </form>

          <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
              <table class="min-w-full text-sm">
                <thead class="bg-gray-50 border-b border-gray-100">
                  <tr class="text-slate-500 text-xs font-extrabold">
                    <th class="text-left px-4 py-3">주문번호</th>
                    <th class="text-left px-4 py-3">회원아이디</th>
                    <th class="text-left px-4 py-3">이름</th>
                    <th class="text-left px-4 py-3">등록ID</th>
                    <th class="text-left px-4 py-3">등록Title</th>
                    <th class="text-right px-4 py-3">결제금액</th>
                    <th class="text-left px-4 py-3">결제일</th>
                    <th class="text-left px-4 py-3">상태</th>
                  </tr>
                </thead>

                <tbody class="divide-y divide-gray-100">
                  <c:choose>
                    <c:when test="${empty payList}">
                      <tr>
                        <td class="px-4 py-10 text-center text-slate-400 font-bold" colspan="8">
                          조회된 결제 내역이 없습니다.
                        </td>
                      </tr>
                    </c:when>

                    <c:otherwise>
                      <c:forEach var="vo" items="${payList}">
                        <tr class="hover:bg-slate-50">
                          <td class="px-4 py-3 font-extrabold text-slate-700">${vo.orderNo}</td>
                          <td class="px-4 py-3 text-slate-700">${vo.userId}</td>
                          <td class="px-4 py-3 text-slate-700">${vo.userName}</td>
                          <td class="px-4 py-3 text-slate-700">${vo.regId}</td>
                          <td class="px-4 py-3">
                            <c:url var="detailUrl" value="/regProdDetail.do">
                              <c:param name="regId" value="${vo.regId}" />
                            </c:url>
                            <a class="text-indigo-600 font-extrabold hover:underline" href="${detailUrl}">
                              ${vo.regTitle}
                            </a>
                          </td>
                          <td class="px-4 py-3 text-right font-extrabold text-slate-900">
                            <fmt:formatNumber value="${vo.payAmount}" type="number" />
                          </td>
                          <td class="px-4 py-3 text-slate-700">${vo.paidAt}</td>

                          <%-- ✅ 상태 표시: AdminPaymentVO에 실제로 존재하는 필드(payStatus, cancelRefund)만 사용 --%>
                          <td class="px-4 py-3">
                            <c:set var="st" value="${vo.payStatus}" />

                            <c:choose>
                              <%-- 환불은 payStatus가 아니라 cancelRefund로 판단 (현재 SQL이 그렇게 만들어져 있음) --%>
                              <c:when test="${vo.cancelRefund eq '환불'}">
                                <span class="chip bg-amber-50 text-amber-700">환불</span>
                              </c:when>

                              <c:when test="${st eq 'CANCEL' or st eq 'CANCELED' or st eq 'CANCELLED' or st eq '취소'}">
                                <span class="chip bg-red-50 text-red-600">취소</span>
                              </c:when>

                              <c:when test="${st eq 'PAID' or st eq '결제완료'}">
                                <span class="chip bg-emerald-50 text-emerald-700">결제완료</span>
                              </c:when>

                              <c:when test="${st eq 'PENDING' or st eq '결제대기'}">
                                <span class="chip bg-gray-50 text-slate-600">결제실패</span>
                              </c:when>

                              <c:when test="${st eq 'FAIL' or st eq '실패'}">
                                <span class="chip bg-rose-50 text-rose-700">실패</span>
                              </c:when>

                              <c:otherwise>
                                <span class="chip bg-gray-50 text-slate-500">${empty st ? '-' : st}</span>
                              </c:otherwise>
                            </c:choose>
                          </td>
                        </tr>
                      </c:forEach>
                    </c:otherwise>
                  </c:choose>
                </tbody>
              </table>
            </div>

            <div class="flex flex-wrap gap-2 p-4 border-t border-gray-100 bg-white">
              <c:forEach var="p" begin="1" end="${totalPages}">
                <c:url var="pageUrl" value="/admin/payments.do">
                  <c:param name="page" value="${p}" />
                  <c:param name="size" value="${size}" />
                  <c:if test="${not empty status}">
                    <c:param name="status" value="${status}" />
                  </c:if>
                  <c:if test="${not empty from}">
                    <c:param name="from" value="${from}" />
                  </c:if>
                  <c:if test="${not empty to}">
                    <c:param name="to" value="${to}" />
                  </c:if>
                </c:url>

                <a href="${pageUrl}"
                   class="h-9 min-w-[38px] px-3 rounded-xl border text-sm font-extrabold inline-flex items-center justify-center ${p eq pageNo ? 'bg-indigo-600 text-white border-indigo-600' : 'bg-white text-slate-700 border-gray-200 hover:bg-slate-50'}">
                  ${p}
                </a>
              </c:forEach>
            </div>
          </div>

        </div>
      </div>
    </main>
  </div>
</body>
</html>
