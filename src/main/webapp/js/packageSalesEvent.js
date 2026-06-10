/* packageSalesEvent.js */

document.addEventListener("DOMContentLoaded", function(){
  console.log("DOMContentLoaded - PackageSalesEvent 초기화");

  var todayStr = (function(){
    var d = new Date();
    var y = d.getFullYear();
    var m = String(d.getMonth() + 1).padStart(2, "0");
    var day = String(d.getDate()).padStart(2, "0");
    return y + "-" + m + "-" + day;
  })();

  // PackageSales 객체 확인
  if(typeof PackageSales === "undefined") {
    console.error("PackageSales가 로드되지 않았습니다.");
    return;
  }

  // 등록행(REGISTER_PROD) 0건일 때 안내 렌더
  var renderNoReg = function(msg){
    var body = document.querySelector("#packageTblBody");
    if(body){
      body.innerHTML =
        '<tr><td colspan="6" class="sales-empty">' +
        (msg || "선택한 패키지는 등록된 출발일/회차(REGISTER_PROD)가 없어 판매 내역이 없습니다.") +
        "</td></tr>";
    }
    var pager = document.querySelector("#pkgPager");
    if(pager) pager.innerHTML = "";
  };

  // 등록행 체크(있으면 true, 없으면 false)
  var checkHasRegRows = function(packageId){
    // API가 없으면 체크를 못하니 일단 true로 보고 기존 로직 진행
    if(!window.PACKAGE_REG_LIST_API) return Promise.resolve(true);
    if(!packageId) return Promise.resolve(true);

    var url = window.PACKAGE_REG_LIST_API + "?packageId=" + encodeURIComponent(packageId);
    return fetch(url, { headers: { "Accept": "application/json" } })
      .then(function(res){
        if(!res.ok) return Promise.resolve([]); // 실패하면 그냥 빈 배열 취급
        return res.json();
      })
      .then(function(list){
        return Array.isArray(list) && list.length > 0;
      })
      .catch(function(err){
        console.error("[packageSalesEvent] regList 체크 실패:", err);
        // 체크 실패해도 조회 자체는 진행하게(사용성 우선)
        return true;
      });
  };

  // ====== submit ======
  var f = document.querySelector("#pkgSalesF");
  if(f){
    f.addEventListener("submit", function(e){
      e.preventDefault();
      console.log("패키지 검색 폼 제출");

      var input = document.querySelector("#pkgName");
      var title = input ? (input.value || "").trim() : "";
      var packageId = input ? (input.dataset.packageId || "") : "";

      if(!title){
        renderNoReg("패키지명을 입력하고 검색해주세요.");
        return;
      }

      // 페이징 초기화
      PackageSales.state.page = 1;

      // ✅ 핵심: 등록행 존재 여부 먼저 체크
      checkHasRegRows(packageId).then(function(hasReg){
        if(!hasReg){
          // NOOSLCUL01 같이 등록행 0인 경우 여기로 들어옴
          renderNoReg("선택한 패키지는 등록된 출발일/회차(REGISTER_PROD)가 없어 판매 내역이 없습니다.");
          return;
        }

        // ✅ 등록행이 있으면 정상 조회
        PackageSales.load().catch(function(err){
          console.error(err);
          alert("패키지 판매 리스트를 불러오지 못했습니다.\n" + err.message);
        });
      });
    });
  }

  // ====== reset ======
  var btn = document.querySelector("#pkgBtnReset");
  if(btn){
    btn.addEventListener("click", function(){
      console.log("패키지 초기화 버튼 클릭");

      var y  = document.querySelector("#pkgSelYear");
      var b  = document.querySelector("#pkgSelBasis");
      var s  = document.querySelector("#pkgSort");     // ✅ 정렬 필터 추가된 경우
      var n  = document.querySelector("#pkgName");
      var df = document.querySelector("#pkgDateFrom");
      var dt = document.querySelector("#pkgDateTo");

      if(y)  y.value = "2026";
      if(b)  b.value = "month";
      if(s)  s.value = "DATE_DESC"; // ✅ 정렬 기본값
      if(n){
        n.value = "";
        n.dataset.packageId = "";   // ✅ 선택된 packageId도 같이 초기화
      }
      if(df) df.value = "";
      if(dt) dt.value = todayStr;

      var regDt = document.querySelector("#regDateTo");
      var cmpDt = document.querySelector("#cmpDateTo");
      if(regDt) regDt.value = todayStr;
      if(cmpDt) cmpDt.value = todayStr;

      PackageSales.state.page = 1;

      var body = document.querySelector("#packageTblBody");
      if(body) {
        body.innerHTML = '<tr><td colspan="6" class="sales-empty">패키지명을 검색해 주세요.</td></tr>';
      }

      var pager = document.querySelector("#pkgPager");
      if(pager) {
        pager.innerHTML = "";
      }
    });
  }

  // 통계 페이지 공통 정책: 종료일은 오늘 날짜 자동 세팅
  var pkgDt = document.querySelector("#pkgDateTo");
  var regDt = document.querySelector("#regDateTo");
  var cmpDt = document.querySelector("#cmpDateTo");
  if(pkgDt) pkgDt.value = todayStr;
  if(regDt) regDt.value = todayStr;
  if(cmpDt) cmpDt.value = todayStr;
});
