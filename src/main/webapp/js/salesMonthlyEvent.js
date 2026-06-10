/* salesMonthlyEvent.js */

var SalesMonthlyEvent = {};

SalesMonthlyEvent.qs = function(sel){ return document.querySelector(sel); };

SalesMonthlyEvent.todayStr = function(){
  var d = new Date();
  var y = d.getFullYear();
  var m = String(d.getMonth() + 1).padStart(2, "0");
  var day = String(d.getDate()).padStart(2, "0");
  return y + "-" + m + "-" + day;
};

SalesMonthlyEvent.setDefaultDates = function(){
  var yearEl = SalesMonthlyEvent.qs("#selYear");
  var fromEl = SalesMonthlyEvent.qs("#dateFrom");
  var toEl   = SalesMonthlyEvent.qs("#dateTo");
  if(!yearEl || !fromEl || !toEl) return;

  if(!fromEl.value) fromEl.value = yearEl.value + "-01-01";
  // 통계 페이지 공통 정책: 종료일 기본값은 항상 오늘
  toEl.value = SalesMonthlyEvent.todayStr();
};

SalesMonthlyEvent.bind = function(){
  var form = SalesMonthlyEvent.qs("#salesF");
  var btnReset = SalesMonthlyEvent.qs("#btnReset");
  var yearEl = SalesMonthlyEvent.qs("#selYear");

  // 초기 날짜 세팅
  SalesMonthlyEvent.setDefaultDates();

  // 폼 제출 이벤트
  if(form){
    form.addEventListener("submit", function(e){
      e.preventDefault();

      var from = SalesMonthlyEvent.qs("#dateFrom") ? SalesMonthlyEvent.qs("#dateFrom").value : "";
      var to   = SalesMonthlyEvent.qs("#dateTo") ? SalesMonthlyEvent.qs("#dateTo").value : "";

      if(from && to && from > to){
        alert("기간 설정이 잘못되었습니다. 시작일이 종료일보다 늦습니다.");
        return;
      }

      console.log("검색 버튼 클릭 - 데이터 로드");
      SalesMonthly.load();
    });
  }

  // 초기화 버튼
  if(btnReset){
    btnReset.addEventListener("click", function(){
      console.log("초기화 버튼 클릭");
      if(form) form.reset();
      SalesMonthlyEvent.setDefaultDates();
      SalesMonthly.load();
    });
  }

  // 연도 변경 이벤트 (자동 날짜 업데이트 및 로드)
  if(yearEl){
    yearEl.addEventListener("change", function(){
      console.log("연도 변경:", yearEl.value);
      var fromEl = SalesMonthlyEvent.qs("#dateFrom");
      var toEl   = SalesMonthlyEvent.qs("#dateTo");
      if(fromEl) fromEl.value = yearEl.value + "-01-01";
      if(toEl)   toEl.value   = SalesMonthlyEvent.todayStr();
      
      // 연도 변경 시 자동 로드
      SalesMonthly.load();
    });
  }

  // 페이지 로드 시 초기 데이터 로드
  console.log("초기 매출 통계 로드 시작");
  SalesMonthly.load();
};

document.addEventListener("DOMContentLoaded", function(){
  console.log("DOMContentLoaded - SalesMonthlyEvent 초기화");
  SalesMonthlyEvent.bind();
});
