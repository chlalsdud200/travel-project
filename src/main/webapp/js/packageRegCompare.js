/* packageRegCompare.js
 * - 왜 필요한지: 등록행(REG) 목록/비교 API 호출 시 날짜 미입력, 키 매핑 차이로 인한 화면 미표시를 막습니다.
 * - 무슨 기능인지: (1) 날짜 기본값 보정 (2) 서버 키(snake/UPPER)도 읽기 (3) 등록행 목록 미로드 시 알림 문구 개선
 */

var PackageRegCompare = {};
PackageRegCompare.state = { chart:null, lastPackageId:"" };
PackageRegCompare.colors = ["#2563eb", "#ef4444", "#10b981"]; // bar 3개
PackageRegCompare.qs = function(s){ return document.querySelector(s); };

// ===== util =====
PackageRegCompare.pick = function(obj, keys, def){
  obj = obj || {};
  for(var i=0;i<keys.length;i++){
    var k = keys[i];
    if(obj[k] !== undefined && obj[k] !== null && obj[k] !== "") return obj[k];
  }
  return def;
};

PackageRegCompare.num = function(n){
  return Number(n || 0).toLocaleString("ko-KR");
};

PackageRegCompare.won = function(n){
  return PackageRegCompare.num(n) + "원";
};

// 금액 표기 규칙:
// - 1억 미만: N만원
// - 1억 이상: X억Y만원 (예: 1억234만원)
PackageRegCompare.shortMoney = function(n){
  var v = Number(n || 0);
  var sign = (v < 0) ? "-" : "";
  var abs = Math.abs(v);
  var man = Math.round(abs / 10000);

  if(abs >= 100000000){
    var eokPart = Math.floor(man / 10000);
    var manPart = man % 10000;
    return sign + eokPart + "억" + (manPart > 0 ? (PackageRegCompare.num(manPart) + "만원") : "");
  }
  if(abs >= 10000){
    return sign + PackageRegCompare.num(man) + "만원";
  }
  return sign + PackageRegCompare.num(abs) + "원";
};

PackageRegCompare.todayYear = function(){
  try { return String(new Date().getFullYear()); } catch(e){ return ""; }
};
PackageRegCompare.todayStr = function(){
  var d = new Date();
  var y = d.getFullYear();
  var m = String(d.getMonth() + 1).padStart(2, "0");
  var day = String(d.getDate()).padStart(2, "0");
  return y + "-" + m + "-" + day;
};

PackageRegCompare.normalizeRange = function(r){
  r = r || {};
  var from = String(r.startDate || "");
  var to   = String(r.endDate || "");

  // 둘 다 없으면: 올해 1/1~오늘
  if(!from && !to){
    var y = PackageRegCompare.todayYear();
    from = y ? (y + "-01-01") : "";
    to   = PackageRegCompare.todayStr();
  }else if(from && !to){
    to = PackageRegCompare.todayStr();
  }else if(!from && to){
    from = to;
  }

  // 역전 방지 (from > to)
  if(from && to && from > to){
    var tmp = from; from = to; to = tmp;
  }

  return { startDate: from, endDate: to };
};

PackageRegCompare.unitFromBasis = function(){
  var basis = PackageRegCompare.qs("#pkgSelBasis") ? PackageRegCompare.qs("#pkgSelBasis").value : "month";
  if(basis === "day") return "DAY";
  if(basis === "week") return "WEEK";
  return "MONTH";
};
PackageRegCompare.xTitleByUnit = function(unit){
  if(unit === "DAY") return "결제일(일)";
  if(unit === "WEEK") return "결제일(주)";
  return "결제일(월)";
};

PackageRegCompare.rangeFromPkg = function(){
  // ✅ year 셀렉터가 없을 수도 있어 fallback(=selYear 또는 올해)
  var yearEl = PackageRegCompare.qs("#pkgSelYear") || PackageRegCompare.qs("#selYear");
  var year = yearEl ? String(yearEl.value || "") : "";

  var from = PackageRegCompare.qs("#pkgDateFrom") ? PackageRegCompare.qs("#pkgDateFrom").value : "";
  var to   = PackageRegCompare.qs("#pkgDateTo") ? PackageRegCompare.qs("#pkgDateTo").value : "";

  // 기존 로직 유지 + 보강: 날짜가 비면 year 또는 올해로 기본 범위 적용
  if(!from || !to){
    var y = year || PackageRegCompare.todayYear();
    from = from || (y ? (y + "-01-01") : "");
    to   = to   || PackageRegCompare.todayStr();
  }

  return PackageRegCompare.normalizeRange({ startDate: from, endDate: to });
};

// ✅ 등록행 비교 전용 날짜 범위 함수
PackageRegCompare.rangeFromReg = function(){
  var from = PackageRegCompare.qs("#regDateFrom") ? PackageRegCompare.qs("#regDateFrom").value : "";
  var to   = PackageRegCompare.qs("#regDateTo") ? PackageRegCompare.qs("#regDateTo").value : "";
  
  if(!from || !to){
    var y = PackageRegCompare.todayYear();
    from = from || (y ? (y + "-01-01") : "");
    to   = to   || PackageRegCompare.todayStr();
  }
  
  return PackageRegCompare.normalizeRange({ startDate: from, endDate: to });
};

PackageRegCompare.getRegSort = function(){
  var s = PackageRegCompare.qs("#regSort");
  return s ? (s.value || "SALES_DESC") : "SALES_DESC";
};

// ===== REG LIST =====
PackageRegCompare.loadRegList = async function(packageId){
  if(!window.PACKAGE_REG_LIST_API) return;
  if(!packageId) return;

  PackageRegCompare.state.lastPackageId = packageId;

  var box = PackageRegCompare.qs("#regChoices");
  if(box) box.innerHTML = "<div style='font-weight:900;color:rgba(15,23,42,.62);'>등록행 불러오는 중...</div>";

  var range = PackageRegCompare.rangeFromReg();   // ✅ 날짜 미입력에도 안전
  var sort = PackageRegCompare.getRegSort();

  var url = window.PACKAGE_REG_LIST_API
    + "?packageId=" + encodeURIComponent(packageId)
    + "&startDate=" + encodeURIComponent(range.startDate)
    + "&endDate=" + encodeURIComponent(range.endDate)
    + "&sort=" + encodeURIComponent(sort);

  var res = await fetch(url, { headers:{ "Accept":"application/json" } });
  if(!res.ok){
    var t = await res.text();
    console.error("[regList] HTTP " + res.status, t.slice(0, 200));
    if(box) box.innerHTML = "<div style='font-weight:900;color:red;'>등록행을 불러오지 못했습니다.</div>";
    return;
  }

  var list = await res.json();
  if(!Array.isArray(list) || list.length === 0){
    if(box) box.innerHTML = "<div style='font-weight:900;color:rgba(15,23,42,.62);'>등록행이 없습니다.</div>";
    return;
  }

  // ✅ 서버에서 snake_case/UPPER_CASE로 내려와도 화면이 나오도록 키 fallback 처리
  var html = "";
  for(var i=0;i<list.length;i++){
    var r = list[i] || {};

    var regId = String(PackageRegCompare.pick(r,
      ["regId","REG_ID","reg_id","regid","REGID","regNo","REG_NO"], ""));

    var title = String(PackageRegCompare.pick(r,
      ["regTitle","REG_TITLE","reg_title","title","TITLE","productName","PRODUCT_NAME","prodName","PROD_NAME","itemName","ITEM_NAME"], ""));

    var startDt = String(PackageRegCompare.pick(r,
      ["startDt","START_DT","start_dt","startDate","START_DATE","departDt","DEPART_DT"], ""));

    html += ""
      + "<label class='reg-chip'>"
      + "  <input type='checkbox' class='regChk' value='" + regId + "'>"
      + "  <div>"
      + "    <div class='t1'>" + (title || "(상품명 없음)") + "</div>"
      + "    <div class='t2'>출발: " + (startDt || "-") + " · " + regId + "</div>"
      + "  </div>"
      + "</label>";
  }
  if(box) box.innerHTML = html;

  // 최대 3개 제한
  box.querySelectorAll(".regChk").forEach(function(chk){
    chk.addEventListener("change", function(){
      var checked = box.querySelectorAll(".regChk:checked").length;
      if(checked > 3){
        chk.checked = false;
        alert("등록행은 최대 3개까지만 선택할 수 있습니다.");
      }
    });
  });
};

// ===== COMPARE DATA =====
PackageRegCompare.fetchCompare = async function(packageId, regIds, unit, startDate, endDate){
  if(!window.PACKAGE_REG_COMPARE_API) throw new Error("PACKAGE_REG_COMPARE_API가 없습니다.");

  var range = PackageRegCompare.normalizeRange({ startDate: startDate, endDate: endDate });

  var url = window.PACKAGE_REG_COMPARE_API
    + "?packageId=" + encodeURIComponent(packageId)
    + "&unit=" + encodeURIComponent(unit)
    + "&startDate=" + encodeURIComponent(range.startDate)
    + "&endDate=" + encodeURIComponent(range.endDate)
    + "&regIds=" + encodeURIComponent(regIds.join(","));

  var res = await fetch(url, { headers:{ "Accept":"application/json" } });
  if(!res.ok){
    var t = await res.text();
    throw new Error("HTTP " + res.status + " / " + t.slice(0, 160));
  }

  var rows = await res.json();
  if(!Array.isArray(rows)) rows = [];
  return rows;
};

// labels 생성(결제일 기준): MONTH/WEEK는 생성, DAY는 과도할 수 있어 제한
PackageRegCompare.buildLabels = function(unit, startDate, endDate, fallbackPeriods){
  var sd = new Date(startDate + "T00:00:00");
  var ed = new Date(endDate + "T00:00:00");
  if(isNaN(sd.getTime()) || isNaN(ed.getTime())) return fallbackPeriods || [];

  var labels = [];

  if(unit === "MONTH"){
    var y = sd.getFullYear(), m = sd.getMonth();
    var endY = ed.getFullYear(), endM = ed.getMonth();
    while(y < endY || (y === endY && m <= endM)){
      labels.push(y + "-" + String(m+1).padStart(2,"0"));
      m++;
      if(m >= 12){ m = 0; y++; }
    }
    return labels;
  }

  if(unit === "WEEK"){
    // sd를 월요일로 맞추기
    var d = new Date(sd);
    var day = d.getDay(); // 0=일
    var diff = (day === 0 ? -6 : 1 - day);
    d.setDate(d.getDate() + diff);

    while(d <= ed){
      var s1 = d.toISOString().slice(0,10);
      var d2 = new Date(d); d2.setDate(d2.getDate() + 6);
      var s2 = d2.toISOString().slice(0,10);
      labels.push(s1 + " ~ " + s2);
      d.setDate(d.getDate() + 7);
    }
    return labels;
  }

  // DAY: 범위가 크면 fallback 사용
  var days = Math.floor((ed - sd) / (1000*60*60*24)) + 1;
  if(days > 120) return fallbackPeriods || [];

  var cur = new Date(sd);
  while(cur <= ed){
    labels.push(cur.toISOString().slice(0,10));
    cur.setDate(cur.getDate() + 1);
  }
  return labels;
};

// ===== RENDER (bar + line) =====
PackageRegCompare.renderChart = function(rows, unit, startDate, endDate){
  var canvas = PackageRegCompare.qs("#regComparisonChart");
  if(!canvas) return;

  var range = PackageRegCompare.normalizeRange({ startDate: startDate, endDate: endDate });

  // period set (키 보강)
  var periodsMap = {};
  for(var i=0;i<rows.length;i++){
    var p = String(PackageRegCompare.pick(rows[i], ["period","PERIOD","payPeriod","PAY_PERIOD"], ""));
    if(p) periodsMap[p] = true;
  }
  var fallbackPeriods = Object.keys(periodsMap).sort();

  var labels = PackageRegCompare.buildLabels(unit, range.startDate, range.endDate, fallbackPeriods);
  if(!labels || labels.length === 0) labels = fallbackPeriods;

  // seriesKey별 (amt/cnt)
  var series = {};
  for(var j=0;j<rows.length;j++){
    var r = rows[j] || {};

    var period = String(PackageRegCompare.pick(r, ["period","PERIOD","payPeriod","PAY_PERIOD"], ""));
    if(!period) continue;

    var key = String(PackageRegCompare.pick(r, ["seriesKey","SERIES_KEY","series_key","key","KEY"], ""));
    var label = String(PackageRegCompare.pick(r, ["seriesLabel","SERIES_LABEL","series_label","label","LABEL"], key));

    if(!series[key]) series[key] = { label: label, amt:{}, cnt:{} };

    var soldAmt = Number(PackageRegCompare.pick(r, ["soldAmt","SOLD_AMT","sold_amt","amt","AMT"], 0));
    var orderCnt = Number(PackageRegCompare.pick(r, ["orderCnt","ORDER_CNT","order_cnt","cnt","CNT"], 0));

    series[key].amt[period] = soldAmt;
    series[key].cnt[period] = orderCnt;
  }

  var keys = Object.keys(series).filter(function(k){ return k !== "TOTAL"; });
  keys.sort(); // 안정적으로

  var datasets = [];

  // bars for regs
  for(var b=0; b<keys.length; b++){
    var k = keys[b];
    var s = series[k];
    var data = labels.map(function(p){ return s.amt[p] != null ? s.amt[p] : 0; });
    var cnts = labels.map(function(p){ return s.cnt[p] != null ? s.cnt[p] : 0; });
    var c = PackageRegCompare.colors[b % PackageRegCompare.colors.length];

    datasets.push({
      type: "bar",
      label: s.label,
      data: data,
      _cnt: cnts,
      backgroundColor: c,
      borderColor: c,
      borderWidth: 1,
      order: 2
    });
  }

  // TOTAL(패키지 총매출) 라인은 중복 정보로 제외

  if(PackageRegCompare.state.chart){
    PackageRegCompare.state.chart.destroy();
    PackageRegCompare.state.chart = null;
  }

  // ChartDataLabels가 없으면(로딩 실패 등) 차트는 그려지게 처리
  var pluginsArr = [];
  if(window.ChartDataLabels) pluginsArr.push(ChartDataLabels);

  PackageRegCompare.state.chart = new Chart(canvas.getContext("2d"), {
    data: { labels: labels, datasets: datasets },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      interaction: { mode: "index", intersect: false },
      plugins: {
        datalabels: {
          display: function(context) {
            var value = Number(context.dataset.data[context.dataIndex] || 0);
            return value > 0;
          },
          align: 'top',
          anchor: 'end',
          offset: 4,
          backgroundColor: function() { return 'rgba(17, 17, 17, 0.85)'; },
          borderRadius: 4,
          color: '#fff',
          font: { size: 10, weight: 'bold' },
          padding: { top: 2, bottom: 2, left: 4, right: 4 },
          formatter: function(value) {
            if (!value || value === 0) return "";
            return PackageRegCompare.shortMoney(value);
          }
        },
        title: { display: true, text: "등록행(REG) 매출 비교 (결제일 기준)" },
        subtitle: { display: true, text: "막대=선택한 등록행 매출 비교" },
        legend: { position: "top", labels: { usePointStyle: true, boxWidth: 10, font: { size: 11 } } },
        tooltip: {
          callbacks: {
            label: function(ctx){
              var amount = Number(ctx.parsed.y || 0);
              var cnt = (ctx.dataset && ctx.dataset._cnt) ? (ctx.dataset._cnt[ctx.dataIndex] || 0) : 0;
              return ctx.dataset.label + ": " + PackageRegCompare.won(amount)
                + " (" + PackageRegCompare.shortMoney(amount) + ", 주문 " + PackageRegCompare.num(cnt) + "건)";
            }
          }
        }
      },
      scales: {
        x: {
          title: { display: true, text: PackageRegCompare.xTitleByUnit(unit) },
          ticks: { autoSkip: true, maxRotation: 0, minRotation: 0, maxTicksLimit: 12 }
        },
        y: {
          title: { display: true, text: "매출액" },
          ticks: {
            maxTicksLimit: 6,
            callback: function(v){ return PackageRegCompare.shortMoney(v); }
          },
          grid: { color: "rgba(15,23,42,.08)" }
        }
      }
    },
    plugins: pluginsArr
  });
};

PackageRegCompare.onCompareClick = async function(){
  var pkgInput = PackageRegCompare.qs("#regPkgName");
  var packageId = pkgInput ? (pkgInput.dataset.packageId || "") : "";
  if(!packageId){
    console.log("[PackageRegCompare] 패키지가 선택되지 않았습니다.");
    return;
  }

  var box = PackageRegCompare.qs("#regChoices");
  var all = box ? box.querySelectorAll(".regChk") : [];
  if(!all || all.length === 0){
    // ✅ 목록이 아직 로드되지 않았는데도 '선택하세요' 알림이 떠서 혼란스러운 부분 보완
    console.log("[PackageRegCompare] 등록행 목록이 없습니다.");
    return;
  }

  var checked = box ? box.querySelectorAll(".regChk:checked") : [];
  if(!checked || checked.length === 0){
    console.log("[PackageRegCompare] 선택된 등록행이 없습니다.");
    return;
  }
  if(checked.length > 3){
    alert("등록행은 최대 3개까지 선택할 수 있습니다.");
    return;
  }

  var regIds = Array.prototype.map.call(checked, function(x){ return x.value; });

  var unit = PackageRegCompare.unitFromBasis();
  var range = PackageRegCompare.rangeFromReg();

  try{
    var rows = await PackageRegCompare.fetchCompare(packageId, regIds, unit, range.startDate, range.endDate);
    PackageRegCompare.renderChart(rows, unit, range.startDate, range.endDate);
  }catch(e){
    console.error(e);
    alert("등록 비교 데이터를 불러오지 못했습니다.\n" + e.message);
  }
};

PackageRegCompare.bindPackageObserver = function(){
  var pkgInput = PackageRegCompare.qs("#regPkgName");
  if(!pkgInput) return;

  // 1) 기존 change 이벤트(유지)
  pkgInput.addEventListener("change", function(){
    var pid = pkgInput.dataset.packageId || "";
    if(pid) PackageRegCompare.loadRegList(pid);
  });

  // 2) ✅ 자동완성에서 dataset만 바뀌는 케이스 대응: data-package-id 변경 감지
  if(window.MutationObserver){
    var mo = new MutationObserver(function(muts){
      var pid = pkgInput.dataset.packageId || "";
      if(pid && pid !== PackageRegCompare.state.lastPackageId){
        PackageRegCompare.loadRegList(pid);
      }
    });
    mo.observe(pkgInput, { attributes: true, attributeFilter: ["data-package-id"] });
  }

  // 3) ✅ 기간 변경 시 목록 재로드(선택 UI가 DB 범위를 따라가게)
  var fromEl = PackageRegCompare.qs("#pkgDateFrom");
  var toEl   = PackageRegCompare.qs("#pkgDateTo");
  [fromEl, toEl].forEach(function(el){
    if(!el) return;
    el.addEventListener("change", function(){
      var pid = pkgInput.dataset.packageId || "";
      if(pid) PackageRegCompare.loadRegList(pid);
    });
  });
};

PackageRegCompare.init = function(){
  // ChartDataLabels가 v3에서 미등록일 수 있어 안전 등록
  try{
    if(window.Chart && window.ChartDataLabels && typeof Chart.register === "function"){
      Chart.register(ChartDataLabels);
    }
  }catch(e){}

  PackageRegCompare.bindPackageObserver();

  // 정렬 변경 시 목록 다시 로드
  var sortSel = PackageRegCompare.qs("#regSort");
  if(sortSel){
    sortSel.addEventListener("change", function(){
      var pid = (PackageRegCompare.qs("#regPkgName") || {}).dataset ? (PackageRegCompare.qs("#regPkgName").dataset.packageId || "") : "";
      if(pid) PackageRegCompare.loadRegList(pid);
    });
  }

  var btn = PackageRegCompare.qs("#btnRegCompare");
  if(btn){
    btn.addEventListener("click", function(e){
      e.preventDefault();
      PackageRegCompare.onCompareClick();
    });
  }

  // Top3 자동 선택(있으면)
  var topBtn = PackageRegCompare.qs("#btnRegTop3");
  if(topBtn){
    topBtn.addEventListener("click", function(e){
      e.preventDefault();
      var box = PackageRegCompare.qs("#regChoices");
      if(!box) return;
      var chks = box.querySelectorAll(".regChk");
      for(var i=0;i<chks.length;i++){
        chks[i].checked = (i < 3);
      }
    });
  }
};

document.addEventListener("DOMContentLoaded", function(){
  PackageRegCompare.init();
});
