/* adminMemberStatsEvent.js
 * - 왜 필요한지: 폼/버튼 이벤트를 한 곳에서 관리해 유지보수를 단순화합니다.
 * - 무슨 기능인지: 검색/초기화/기본값 세팅 후 MemberStats.load()를 호출합니다.
 */

var MemberStatsEvent = {};

MemberStatsEvent.qs = function(sel){ return document.querySelector(sel); };

MemberStatsEvent.todayStr = function(){
  var d = new Date();
  var y = d.getFullYear();
  var m = String(d.getMonth() + 1).padStart(2, "0");
  var day = String(d.getDate()).padStart(2, "0");
  return y + "-" + m + "-" + day;
};

MemberStatsEvent.setDefaultDates = function(){
  var yearEl = MemberStatsEvent.qs("#selYear");
  var fromEl = MemberStatsEvent.qs("#dateFrom");
  var toEl   = MemberStatsEvent.qs("#dateTo");
  if(!yearEl || !fromEl || !toEl) return;

  // 종료일 기본값은 오늘
  if(!fromEl.value) fromEl.value = yearEl.value + "-01-01";
  toEl.value = MemberStatsEvent.todayStr();
};

MemberStatsEvent.resetForm = function(){
  var f = MemberStatsEvent.qs("#memberStatsF");
  if(!f) return;

  f.reset();

  // reset 후, 날짜가 빈 값이 될 수 있으니 다시 기본값
  MemberStatsEvent.setDefaultDates();

  // 기본 검색
  MemberStats.load();
};

MemberStatsEvent.bind = function(){
  var f = MemberStatsEvent.qs("#memberStatsF");
  var btnReset = MemberStatsEvent.qs("#btnReset");
  var yearEl = MemberStatsEvent.qs("#selYear");

  MemberStatsEvent.setDefaultDates();

  if(f){
    f.addEventListener("submit", function(e){
      e.preventDefault();
      // 날짜 유효성(최소)
      var from = MemberStatsEvent.qs("#dateFrom") ? MemberStatsEvent.qs("#dateFrom").value : "";
      var to   = MemberStatsEvent.qs("#dateTo") ? MemberStatsEvent.qs("#dateTo").value : "";
      if(from && to && from > to){
        alert("기간 설정이 잘못되었습니다. 시작일이 종료일보다 늦습니다.");
        return;
      }
      MemberStats.load();
    });
  }

  if(btnReset){
    btnReset.addEventListener("click", function(){
      MemberStatsEvent.resetForm();
    });
  }

  // 연도 바꾸면 날짜를 연도 전체로 자동 갱신(날짜를 직접 선택한 상태가 아니면)
  if(yearEl){
    yearEl.addEventListener("change", function(){
      var fromEl = MemberStatsEvent.qs("#dateFrom");
      var toEl = MemberStatsEvent.qs("#dateTo");
      if(fromEl) fromEl.value = yearEl.value + "-01-01";
      if(toEl)   toEl.value   = MemberStatsEvent.todayStr();
    });
  }

  // 첫 로드
  MemberStats.load();
};

// DOMReady
document.addEventListener("DOMContentLoaded", function(){
  MemberStatsEvent.bind();
});
