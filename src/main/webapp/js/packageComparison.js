/* packageComparison.js */

var PackageComparison = {};
PackageComparison.state = { chart: null };
PackageComparison.colors = ["#2563eb", "#10b981", "#f59e0b"]; // 3개 패키지 색상
PackageComparison.qs = function(s){ return document.querySelector(s); };
PackageComparison.todayStr = function(){
  var d = new Date();
  var y = d.getFullYear();
  var m = String(d.getMonth() + 1).padStart(2, "0");
  var day = String(d.getDate()).padStart(2, "0");
  return y + "-" + m + "-" + day;
};

PackageComparison.num = function(n){
  return Number(n || 0).toLocaleString("ko-KR");
};

PackageComparison.won = function(n){
  return PackageComparison.num(n) + "원";
};

// 금액 표기 규칙:
// - 1억 미만: N만원
// - 1억 이상: X억Y만원 (예: 1억234만원)
PackageComparison.shortMoney = function(n){
  var v = Number(n || 0);
  var sign = (v < 0) ? "-" : "";
  var abs = Math.abs(v);
  var man = Math.round(abs / 10000);

  if(abs >= 100000000){
    var eokPart = Math.floor(man / 10000);
    var manPart = man % 10000;
    return sign + eokPart + "억" + (manPart > 0 ? (PackageComparison.num(manPart) + "만원") : "");
  }
  if(abs >= 10000){
    return sign + PackageComparison.num(man) + "만원";
  }
  return sign + PackageComparison.num(abs) + "원";
};

PackageComparison.unitFromBasis = function(){
  var basis = PackageComparison.qs("#pkgSelBasis") ? PackageComparison.qs("#pkgSelBasis").value : "month";
  if(basis === "day") return "DAY";
  if(basis === "week") return "WEEK";
  return "MONTH";
};

PackageComparison.rangeFromPkg = function(){
  var year = PackageComparison.qs("#pkgSelYear") ? PackageComparison.qs("#pkgSelYear").value : "";
  var from = PackageComparison.qs("#pkgDateFrom") ? PackageComparison.qs("#pkgDateFrom").value : "";
  var to   = PackageComparison.qs("#pkgDateTo") ? PackageComparison.qs("#pkgDateTo").value : "";

  if(!from || !to){
    from = year ? (year + "-01-01") : "";
    to   = PackageComparison.todayStr();
  }
  return { startDate: from, endDate: to };
};

// ✅ 추가: 패키지 비교 전용 기간 선택 (독립적)
PackageComparison.rangeFromComparison = function(){
  var from = PackageComparison.qs("#cmpDateFrom") ? PackageComparison.qs("#cmpDateFrom").value : "";
  var to   = PackageComparison.qs("#cmpDateTo") ? PackageComparison.qs("#cmpDateTo").value : "";
  
  if(!from || !to){
    // 기본값: 올해 1/1 ~ 오늘
    from = from || (new Date().getFullYear() + "-01-01");
    to   = to || PackageComparison.todayStr();
  }
  return { startDate: from, endDate: to };
};

// ===== FETCH DATA =====
PackageComparison.fetchComparisonData = async function(packageIds, unit, startDate, endDate){
  if(!window.PACKAGE_COMPARISON_API) throw new Error("PACKAGE_COMPARISON_API가 없습니다.");
  
  var url = window.PACKAGE_COMPARISON_API
    + "?unit=" + encodeURIComponent(unit)
    + "&startDate=" + encodeURIComponent(startDate)
    + "&endDate=" + encodeURIComponent(endDate)
    + "&packageIds=" + encodeURIComponent(packageIds.join(","));

  var res = await fetch(url, { headers:{ "Accept":"application/json" } });
  
  // ✅ 로그인 페이지로 리다이렉트된 경우 감지
  var contentType = res.headers.get("content-type") || "";
  if(contentType.includes("text/html")){
    // HTML이 왔다 = 로그인 페이지로 리다이렉트됨
    alert("세션이 만료되었습니다. 다시 로그인해주세요.");
    window.location.href = window.CTX + "/login.do";
    throw new Error("Session expired");
  }
  
  if(!res.ok){
    var t = await res.text();
    throw new Error("HTTP " + res.status + " / " + t.slice(0, 160));
  }

  var rows = await res.json();
  if(!Array.isArray(rows)) rows = [];
  
  return rows;
};

// ===== BUILD LABELS =====
PackageComparison.buildLabels = function(unit, startDate, endDate, fallbackPeriods){
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
    var d = new Date(sd);
    var day = d.getDay();
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

  var days = Math.floor((ed - sd) / (1000*60*60*24)) + 1;
  if(days > 120) return fallbackPeriods || [];

  var cur = new Date(sd);
  while(cur <= ed){
    labels.push(cur.toISOString().slice(0,10));
    cur.setDate(cur.getDate() + 1);
  }
  return labels;
};

// ===== RENDER CHART =====
PackageComparison.renderChart = function(rows, unit, startDate, endDate){
  var canvas = PackageComparison.qs("#comparisonChart");
  if(!canvas) return;

  // period set
  var periodsMap = {};
  for(var i=0;i<rows.length;i++) periodsMap[rows[i].period] = true;
  var fallbackPeriods = Object.keys(periodsMap).sort();

  var labels = PackageComparison.buildLabels(unit, startDate, endDate, fallbackPeriods);
  if(!labels || labels.length === 0) labels = fallbackPeriods;

  // ✅ seriesKey별 데이터 분류 (개선)
  var series = {};
  for(var j=0;j<rows.length;j++){
    var r = rows[j];
    var key = r.seriesKey || r.packageId || ""; // ✅ packageId도 fallback으로 사용
    var label = r.seriesLabel || r.packageName || key; // ✅ packageName도 fallback으로 사용
    
    if(!series[key]) {
      series[key] = { 
        label: label, 
        amt:{}, 
        cnt:{},
        isTotal: key === "TOTAL" || label === "전체 총매출" // ✅ TOTAL 판별 개선
      };
    }
    series[key].amt[r.period] = Number(r.soldAmt || 0);
    series[key].cnt[r.period] = Number(r.orderCnt || 0);
  }

  // 패키지들(line) + TOTAL(line)
  var keys = Object.keys(series).filter(function(k){ return !series[k].isTotal; });
  keys.sort();

  var datasets = [];

  // ✅ 개별 패키지 라인들 (먼저 추가 - order 높게)
  for(var p=0; p<keys.length; p++){
    var k = keys[p];
    var s = series[k];
    var data = labels.map(function(period){ return s.amt[period] != null ? s.amt[period] : 0; });
    var cnts = labels.map(function(period){ return s.cnt[period] != null ? s.cnt[period] : 0; });
    var c = PackageComparison.colors[p % PackageComparison.colors.length];

    datasets.push({
      type: "line",
      label: s.label,
      data: data,
      _cnt: cnts,
      _isTotal: false,
      borderColor: c,
      backgroundColor: c,
      borderWidth: 3,
      pointRadius: 3,
      pointBackgroundColor: c,
      pointBorderColor: '#fff',
      pointBorderWidth: 2,
      tension: 0.3,
      fill: false,
      order: 2
    });
  }

  // ✅ TOTAL 라인 (나중에 추가 - order 낮게)
  var totalKey = Object.keys(series).find(function(k){ return series[k].isTotal; });
  if(totalKey){
    var t = series[totalKey];
    var tdata = labels.map(function(period){ return t.amt[period] != null ? t.amt[period] : 0; });
    var tcnt = labels.map(function(period){ return t.cnt[period] != null ? t.cnt[period] : 0; });
    datasets.push({
      type: "line",
      label: "전체 총매출",
      data: tdata,
      _cnt: tcnt,
      _isTotal: true,
      borderColor: "#111",
      backgroundColor: "#111",
      borderWidth: 4,
      borderDash: [20, 10],
      pointRadius: 4,
      pointBackgroundColor: "#111",
      pointBorderColor: "#fff",
      pointBorderWidth: 2,
      tension: 0.3,
      fill: false,
      order: 1
    });
  }

  // ✅ 데이터가 없는 경우 경고
  if(datasets.length === 0){
    alert("표시할 데이터가 없습니다. 패키지를 다시 선택해주세요.");
    return;
  }

  if(PackageComparison.state.chart){
    PackageComparison.state.chart.destroy();
    PackageComparison.state.chart = null;
  }

  PackageComparison.state.chart = new Chart(canvas.getContext("2d"), {
    data: { labels: labels, datasets: datasets },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      interaction: { mode: "index", intersect: false },
      layout: {
        padding: {
          top: 10,
          bottom: 20,
          left: 10,
          right: 10
        }
      },
      plugins: {
        datalabels: {
          display: function(context) {
            var value = Number(context.dataset.data[context.dataIndex] || 0);
            return value > 0;
          },
          align: 'top',
          anchor: 'end',
          offset: function(context){
            // 선마다 라벨 높이를 달리해 겹침 완화
            return 4 + (context.datasetIndex * 7);
          },
          color: function(context){
            return context.dataset.borderColor || "#111";
          },
          backgroundColor: "rgba(255,255,255,0.88)",
          borderColor: function(context){
            return context.dataset.borderColor || "#111";
          },
          borderWidth: 1,
          borderRadius: 6,
          font: { size: 10, weight: 'bold' },
          padding: { top: 2, bottom: 2, left: 5, right: 5 },
          formatter: function(value) {
            if (!value || value === 0) return '';
            return PackageComparison.shortMoney(value);
          }
        },
        title: { 
          display: true, 
          text: "패키지별 매출 비교 (결제일 기준)",
          font: { size: 16, weight: 'bold' },
          padding: { bottom: 10 }
        },
        subtitle: { 
          display: true, 
          text: "점선=전체 총매출 · 실선=개별 패키지",
          font: { size: 12 },
          padding: { bottom: 20 }
        },
        legend: { 
          display: true,
          position: "top",
          align: "end",
          labels: {
            usePointStyle: true,
            padding: 12,
            font: { size: 11, weight: 'normal' },
            boxWidth: 10,
            boxHeight: 10
          }
        },
        tooltip: {
          backgroundColor: 'rgba(0, 0, 0, 0.8)',
          padding: 12,
          titleFont: { size: 13, weight: 'bold' },
          bodyFont: { size: 12 },
          callbacks: {
            title: function(ctx){
              return "기간: " + ctx[0].label;
            },
            label: function(ctx){
              var amount = Number(ctx.parsed.y || 0);
              var cnt = (ctx.dataset && ctx.dataset._cnt) ? (ctx.dataset._cnt[ctx.dataIndex] || 0) : 0;
              return ctx.dataset.label + ": " + PackageComparison.won(amount)
                + " (" + PackageComparison.shortMoney(amount) + ", 주문 " + PackageComparison.num(cnt) + "건)";
            }
          }
        }
      },
      scales: {
        x: { 
          title: { display: true, text: "결제일", font: { size: 12, weight: 'bold' } },
          ticks: { font: { size: 11 }, autoSkip: true, maxRotation: 0, minRotation: 0, maxTicksLimit: 12 }
        },
        y: {
          title: { display: true, text: "매출액", font: { size: 12, weight: 'bold' } },
          ticks: { 
            maxTicksLimit: 6,
            callback: function(v){ return PackageComparison.shortMoney(v); },
            font: { size: 11 }
          },
          beginAtZero: true,
          grid: { color: "rgba(15,23,42,.08)" }
        }
      }
    },
    plugins: [ChartDataLabels]  // ✅ 플러그인 활성화
  });
};

// ===== COMPARE CLICK =====
PackageComparison.onCompareClick = async function(){
  var pkg1 = PackageComparison.qs("#cmpPkg1");
  var pkg2 = PackageComparison.qs("#cmpPkg2");
  var pkg3 = PackageComparison.qs("#cmpPkg3");

  var id1 = pkg1 ? (pkg1.dataset.packageId || "") : "";
  var id2 = pkg2 ? (pkg2.dataset.packageId || "") : "";
  var id3 = pkg3 ? (pkg3.dataset.packageId || "") : "";

  if(!id1 || !id2){
    alert("최소 2개의 패키지를 선택해주세요.");
    return;
  }

  var packageIds = [id1, id2];
  if(id3) packageIds.push(id3);

  var unit = PackageComparison.unitFromBasis();
  var range = PackageComparison.rangeFromComparison(); // ✅ 수정: 독립적인 기간 사용

  try{
    var rows = await PackageComparison.fetchComparisonData(packageIds, unit, range.startDate, range.endDate);
    
    if(!rows || rows.length === 0){
      alert("해당 기간에 매출 데이터가 없습니다.");
      return;
    }
    
    PackageComparison.renderChart(rows, unit, range.startDate, range.endDate);
  }catch(e){
    console.error(e);
    alert("패키지 비교 데이터를 불러오지 못했습니다.\n" + e.message);
  }
};

// ===== INIT =====
PackageComparison.init = function(){
  var btn = PackageComparison.qs("#btnCompare");
  if(btn){
    btn.addEventListener("click", function(e){
      e.preventDefault();
      PackageComparison.onCompareClick();
    });
  }

  // ✅ 추가: 입력 필드가 변경되면 차트 초기화
  var inputs = ["#cmpPkg1", "#cmpPkg2", "#cmpPkg3"];
  inputs.forEach(function(sel){
    var input = PackageComparison.qs(sel);
    if(input){
      input.addEventListener("input", function(){
        // 입력 중이면 packageId 제거
        if(!input.dataset.packageId && PackageComparison.state.chart){
          PackageComparison.state.chart.destroy();
          PackageComparison.state.chart = null;
        }
      });
      
      // ✅ 추가: clear 버튼이나 직접 지우기
      input.addEventListener("keydown", function(e){
        if(e.key === "Escape" || e.key === "Delete"){
          input.value = "";
          input.dataset.packageId = "";
          if(PackageComparison.state.chart){
            PackageComparison.state.chart.destroy();
            PackageComparison.state.chart = null;
          }
        }
      });
    }
  });
};

document.addEventListener("DOMContentLoaded", function(){
  PackageComparison.init();
});
