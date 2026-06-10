/* packageSales.js */

var PackageSales = {};

PackageSales.state = { page: 1, size: 8, totalCount: 0, lastParams: null };
PackageSales.qs = function(sel){ return document.querySelector(sel); };

PackageSales.num = function(n){ return Number(n || 0).toLocaleString("ko-KR"); };
PackageSales.won = function(n){ return PackageSales.num(n) + "원"; };
PackageSales.todayStr = function(){
  var d = new Date();
  var y = d.getFullYear();
  var m = String(d.getMonth() + 1).padStart(2, "0");
  var day = String(d.getDate()).padStart(2, "0");
  return y + "-" + m + "-" + day;
};

PackageSales.buildParams = function(){
  var title = PackageSales.qs("#pkgName") ? PackageSales.qs("#pkgName").value.trim() : "";
  var year  = PackageSales.qs("#pkgSelYear") ? PackageSales.qs("#pkgSelYear").value : "";

  var from  = PackageSales.qs("#pkgDateFrom") ? PackageSales.qs("#pkgDateFrom").value : "";
  var to    = PackageSales.qs("#pkgDateTo") ? PackageSales.qs("#pkgDateTo").value : "";

  var sort  = PackageSales.qs("#pkgSort") ? PackageSales.qs("#pkgSort").value : "DATE_DESC";

  if(!from || !to){
    from = (year ? (year + "-01-01") : "");
    to   = PackageSales.todayStr();
  }

  return {
    packageTitle: title,
    startDate: from,
    endDate: to,
    sort: sort,
    page: PackageSales.state.page,
    size: PackageSales.state.size
  };
};

PackageSales.toQuery = function(p){
  return [
    "packageTitle=" + encodeURIComponent(p.packageTitle || ""),
    "startDate=" + encodeURIComponent(p.startDate || ""),
    "endDate=" + encodeURIComponent(p.endDate || ""),
    "sort=" + encodeURIComponent(p.sort || "DATE_DESC"),
    "page=" + encodeURIComponent(p.page || 1),
    "size=" + encodeURIComponent(p.size || 8)
  ].join("&");
};

PackageSales.fetchList = async function(params){
  if(!window.PACKAGE_SALES_API) {
    throw new Error("PACKAGE_SALES_API가 정의되지 않았습니다.");
  }

  var url = window.PACKAGE_SALES_API + "?" + PackageSales.toQuery(params);
  console.log("📡 패키지 판매 API 호출:", url);

  try {
    var res = await fetch(url, { method: "GET", headers: { "Accept":"application/json" } });
    console.log("✅ 응답 받음 - Status:", res.status, "OK:", res.ok);

    if(!res.ok){
      var t = await res.text();
      console.error("❌ API 응답 오류:", res.status, t.slice(0, 500));
      throw new Error("API 응답 오류: " + res.status);
    }

    var ct = res.headers.get("content-type") || "";
    console.log("📄 Content-Type:", ct);
    
    if(ct.indexOf("application/json") === -1){
      var body = await res.text();
      console.error("❌ JSON 응답이 아님:", ct, "\n응답 내용:", body.slice(0, 500));
      throw new Error("JSON 응답이 아닙니다. Content-Type: " + ct);
    }

    var data = await res.json();
    console.log("✅ JSON 파싱 성공. 데이터:", data);
    return data;
    
  } catch(e) {
    console.error("💥 fetchList 에러:", e.message);
    console.error("💥 에러 스택:", e);
    throw e;
  }
};

PackageSales.renderTable = function(list){
  var body = PackageSales.qs("#packageTblBody");
  if(!body) return;

  if(!list || list.length === 0){
    body.innerHTML = '<tr><td colspan="7" class="sales-empty">데이터가 없습니다.</td></tr>';
    return;
  }

  var html = "";
  for(var i=0;i<list.length;i++){
    var r = list[i];

    html += "<tr>";
    html += "<td class='mono'>" + (r.startDt || "-") + "</td>";
    html += "<td>" + (r.regTitle || "-") + "</td>";
    html += "<td class='mono'>" + PackageSales.won(r.regPrice) + "</td>";
    html += "<td class='mono'>" + PackageSales.num(r.salesQty) + "개</td>";
    html += "<td class='mono'>" + PackageSales.num(r.orderCnt) + "건</td>";
    html += "<td class='mono'>" + PackageSales.won(r.soldAmt) + "</td>";
    html += "<td class='small-note'>" + (r.regId || "-") + "</td>";
    html += "</tr>";
  }
  body.innerHTML = html;
};

PackageSales.renderPager = function(page, size, totalCount){
  var pager = PackageSales.qs("#pkgPager");
  if(!pager) return;

  var totalPages = Math.max(1, Math.ceil(Number(totalCount || 0) / Number(size || 8)));
  var cur = Number(page || 1);

  if(totalPages <= 1){
    pager.innerHTML = "";
    return;
  }

  var start = Math.max(1, cur - 3);
  var end   = Math.min(totalPages, start + 6);
  start     = Math.max(1, end - 6);

  var html = "";

  html += "<button class='btn-ghost' data-page='" + (cur - 1) + "' " + (cur <= 1 ? "disabled" : "") +
          " style='width:32px;height:32px;padding:0;display:flex;align-items:center;justify-content:center;border-radius:8px;'>";
  html += "<i class='fas fa-chevron-left' style='font-size:10px;'></i></button>";

  for(var p=start; p<=end; p++){
    if(p === cur){
      html += "<button class='btn-indigo' data-page='" + p + "' " +
              "style='width:32px;height:32px;padding:0;background:#4f46e5;color:#fff;border-radius:8px;font-weight:900;'>" + p + "</button>";
    }else{
      html += "<button class='btn-ghost' data-page='" + p + "' " +
              "style='width:32px;height:32px;padding:0;border-radius:8px;'>" + p + "</button>";
    }
  }

  html += "<button class='btn-ghost' data-page='" + (cur + 1) + "' " + (cur >= totalPages ? "disabled" : "") +
          " style='width:32px;height:32px;padding:0;display:flex;align-items:center;justify-content:center;border-radius:8px;'>";
  html += "<i class='fas fa-chevron-right' style='font-size:10px;'></i></button>";

  pager.innerHTML = html;

  pager.onclick = function(e){
    var btn = e.target.closest("button[data-page]");
    if(!btn || btn.disabled) return;

    var next = Number(btn.getAttribute("data-page") || "1");
    if(next < 1) next = 1;
    if(next > totalPages) next = totalPages;

    PackageSales.state.page = next;
    PackageSales.load().catch(function(err){
      console.error(err);
      alert("패키지 판매 리스트를 불러오지 못했습니다.\n" + err.message);
    });
  };
};

PackageSales.load = async function(){
  console.log("🔍 PackageSales.load() 시작");
  
  var params = PackageSales.buildParams();
  console.log("📋 검색 파라미터:", params);

  if(!params.packageTitle || params.packageTitle.trim() === ""){
    console.log("⚠️ 패키지명이 비어있음");
    var body = PackageSales.qs("#packageTblBody");
    if(body) body.innerHTML = '<tr><td colspan="7" class="sales-empty">패키지명을 입력하고 검색해주세요.</td></tr>';
    var pager = PackageSales.qs("#pkgPager");
    if(pager) pager.innerHTML = "";
    return;
  }

  PackageSales.state.lastParams = params;

  var body = PackageSales.qs("#packageTblBody");
  if(body) body.innerHTML = '<tr><td colspan="8" class="sales-empty">데이터를 불러오는 중...</td></tr>';

  try {
    console.log("📡 API 호출 직전");
    var data = await PackageSales.fetchList(params);
    console.log("📦 API 응답 받음:", data);
    console.log("📊 totalCount:", data.totalCount, "/ list 길이:", (data.list || []).length);

    PackageSales.state.totalCount = Number(data.totalCount || 0);
    PackageSales.renderTable(data.list || []);
    PackageSales.renderPager(Number(data.page || 1), Number(data.size || 8), Number(data.totalCount || 0));
    
    console.log("✅ PackageSales.load() 완료");

  } catch(err) {
    console.error("💥 패키지 판매 로드 오류:", err);
    if(body) body.innerHTML = '<tr><td colspan="7" class="sales-empty" style="color:red;">오류: ' + err.message + '</td></tr>';
  }
};

console.log("📦 PackageSales.js 로드 완료");
