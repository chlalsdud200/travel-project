/* packageAutocomplete.js */

var PackageAutocomplete = {};
PackageAutocomplete.state = { timer: null, selected: null, currentInput: null };

PackageAutocomplete.init = function(){
  console.log("PackageAutocomplete 초기화");

  PackageAutocomplete.attachTo("#pkgName", "#pkgAutocomplete");
  PackageAutocomplete.attachTo("#cmpPkg1", "#cmpAutocomplete1");
  PackageAutocomplete.attachTo("#cmpPkg2", "#cmpAutocomplete2");
  PackageAutocomplete.attachTo("#cmpPkg3", "#cmpAutocomplete3");

  // ✅ 등록별 비교 입력도 자동완성 연결
  PackageAutocomplete.attachTo("#regPkgName", "#regPkgAutocomplete");
};

PackageAutocomplete.attachTo = function(inputSel, dropdownSel){
  var input = document.querySelector(inputSel);
  var dropdown = document.querySelector(dropdownSel);

  if(!input || !dropdown) return;

  // ✅ 클릭 안 먹는 케이스 방지(레이어링)
  dropdown.style.zIndex = "99999";
  dropdown.style.pointerEvents = "auto";

  input.addEventListener("input", function(e){
    var keyword = (e.target.value || "").trim();

    if(PackageAutocomplete.state.timer) clearTimeout(PackageAutocomplete.state.timer);

    // 타이핑이 시작되면 선택값 무효화
    input.dataset.packageId = "";

    // ✅ 수정: 입력이 없거나 짧아도 검색 (최신 패키지 표시)
    PackageAutocomplete.state.timer = setTimeout(function(){
      PackageAutocomplete.state.currentInput = inputSel;
      PackageAutocomplete.search(keyword, dropdownSel);
    }, 250);
  });

  input.addEventListener("focus", function(){
    // ✅ 수정: focus시 항상 자동완성 표시 (없으면 최신 패키지 로드)
    var keyword = (input.value || "").trim();
    PackageAutocomplete.search(keyword, dropdownSel);
  });

  input.addEventListener("blur", function(){
    setTimeout(function(){ dropdown.style.display = "none"; }, 200);
  });

  // ✅ 엔터 누르면 첫번째 항목 자동 선택(원하신 "엔터도 안됨" 해결)
  input.addEventListener("keydown", function(e){
    if(e.key === "Enter"){
      var first = dropdown.querySelector(".autocomplete-item");
      if(first){
        e.preventDefault();
        PackageAutocomplete.applySelection(inputSel, first);
      }
    }
  });

  // ✅ blur보다 먼저 잡는 mousedown으로 선택 처리(클릭 안 먹는 문제 해결)
  dropdown.addEventListener("mousedown", function(e){
    var row = e.target.closest(".autocomplete-item");
    if(!row) return;
    e.preventDefault();
    PackageAutocomplete.applySelection(inputSel, row);
  });
};

PackageAutocomplete.esc = function(s){
  return String(s ?? "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#39;");
};

PackageAutocomplete.search = async function(keyword, dropdownSel){
  if(!window.PACKAGE_AUTOCOMPLETE_API) return;

  var url = window.PACKAGE_AUTOCOMPLETE_API + "?keyword=" + encodeURIComponent(keyword);
  console.log("자동완성 API 호출:", url);

  try {
    var res = await fetch(url, { method:"GET", headers:{ "Accept":"application/json" } });
    
    // ✅ HTML 응답 감지 (로그인 페이지)
    var contentType = res.headers.get("content-type") || "";
    if(contentType.includes("text/html")){
      console.warn("[packageAutocomplete] 세션 만료 감지");
      alert("세션이 만료되었습니다. 다시 로그인해주세요.");
      window.location.href = window.CTX + "/login.do";
      return;
    }
    
    var text = await res.text();

    if(!res.ok){
      console.warn("[packageAutocomplete] HTTP " + res.status, text.slice(0, 200));
    }

    var list;
    try { list = JSON.parse(text); }
    catch(e){
      console.error("[packageAutocomplete] JSON 파싱 실패:", text.slice(0, 200));
      throw e;
    }

    if(list && !Array.isArray(list) && Array.isArray(list.list)) list = list.list;
    if(!Array.isArray(list)) list = [];

    console.log("자동완성 결과:", list);
    PackageAutocomplete.render(list, dropdownSel);

  } catch(err) {
    console.error("[packageAutocomplete] 자동완성 오류:", err);
    var dd = document.querySelector(dropdownSel);
    if(dd){ dd.style.display="none"; dd.innerHTML=""; }
  }
};

PackageAutocomplete.render = function(list, dropdownSel){
  var dropdown = document.querySelector(dropdownSel);
  if(!dropdown) return;

  if(!list || list.length === 0) {
    dropdown.style.display = "none";
    dropdown.innerHTML = "";
    return;
  }

  var html = "";
  for(var i=0; i<list.length; i++) {
    var item = list[i];
    var title = (typeof item === "string") ? item : (item.packageTitle || item.PACKAGE_TITLE || "");
    var pid   = (typeof item === "string") ? ""   : (item.packageId   || item.PACKAGE_ID   || "");

    var safeTitle = PackageAutocomplete.esc(title);
    var safeId    = PackageAutocomplete.esc(pid);

    html += ""
      + "<div class='autocomplete-item' data-id='" + safeId + "' data-title='" + safeTitle + "'"
      + " style='padding:10px 14px; cursor:pointer; border-bottom:1px solid rgba(15,23,42,.06);'>"
      + "  <div style='font-size:13px; font-weight:900; color:#0f172a; line-height:1.25;'>" + safeTitle + "</div>"
      + (pid ? "  <div style='font-size:12px; font-weight:800; color:rgba(15,23,42,.62); margin-top:2px;'>ID: " + safeId + "</div>" : "")
      + "</div>";
  }

  dropdown.innerHTML = html;
  dropdown.style.display = "block";
};

// ✅ 선택 적용 로직을 한 곳으로(등록별 비교까지 같이 반영)
PackageAutocomplete.applySelection = function(inputSel, rowEl){
  var title = rowEl.getAttribute("data-title") || "";
  var id = rowEl.getAttribute("data-id") || "";

  var input = document.querySelector(inputSel);
  if(input){
    input.value = title;
    input.dataset.packageId = id;
    input.dispatchEvent(new Event("change"));
  }

  // ✅ pkgName에서 선택하면 등록별 비교 입력도 자동 세팅
  if(inputSel === "#pkgName"){
    var regInput = document.querySelector("#regPkgName");
    if(regInput){
      regInput.value = title;
      regInput.dataset.packageId = id;
      regInput.dispatchEvent(new Event("change"));
    }
  }

  // dropdown 숨기기
  var dropdownSel =
    (inputSel === "#pkgName") ? "#pkgAutocomplete" :
    (inputSel === "#cmpPkg1") ? "#cmpAutocomplete1" :
    (inputSel === "#cmpPkg2") ? "#cmpAutocomplete2" :
    (inputSel === "#cmpPkg3") ? "#cmpAutocomplete3" :
    (inputSel === "#regPkgName") ? "#regPkgAutocomplete" : null;

  if(dropdownSel){
    var dd = document.querySelector(dropdownSel);
    if(dd){ dd.style.display="none"; }
  }

  PackageAutocomplete.state.selected = { id:id, title:title };
  console.log("패키지 선택:", title, id);
};

document.addEventListener("DOMContentLoaded", function(){
  PackageAutocomplete.init();
  PackageAutocomplete.bootstrapLatest();
});


// ✅ 최초 로드: 최신 패키지를 reg 비교/판매리스트에 자동 세팅 + 등록비교 자동 실행
PackageAutocomplete.bootstrapLatest = async function(){
  if(!window.PACKAGE_AUTOCOMPLETE_API) return;

  try{
    // keyword 비움 → (XML에서) 최신 등록순 20개
    var url = window.PACKAGE_AUTOCOMPLETE_API + "?keyword=";
    var res = await fetch(url, { headers: { "Accept": "application/json" } });
    if(!res.ok) return;

    var list = await res.json();
    if(!Array.isArray(list) || list.length === 0) return;

    // ✅ 첫 번째(최신)
    var first = list[0] || {};
    var title = first.packageTitle || "";
    var pid = first.packageId || "";
    if(!title || !pid) return;

    // 1) 등록행 비교 패키지 자동 세팅
    var regInput = document.querySelector("#regPkgName");
    if(regInput){
      regInput.value = title;
      regInput.dataset.packageId = pid;
      regInput.dispatchEvent(new Event("change")); // reg list 로드 유도
    }

    // 2) (선택) 패키지 판매 리스트도 자동 세팅 + 로드
    var pkgInput = document.querySelector("#pkgName");
    if(pkgInput){
      pkgInput.value = title;
      pkgInput.dataset.packageId = pid;
    }
    if(typeof PackageSales !== "undefined" && PackageSales.load){
      PackageSales.state.page = 1;
      PackageSales.load().catch(function(){});
    }

    // 3) 등록행 목록 로드 후 Top3 자동선택 + 등록비교 자동 실행
    setTimeout(function(){
      var topBtn = document.querySelector("#btnRegTop3");
      if(topBtn) topBtn.click();

      var compareBtn = document.querySelector("#btnRegCompare");
      if(compareBtn) compareBtn.click();
    }, 600);

  }catch(e){
    console.error("[bootstrapLatest] 실패:", e);
  }
};