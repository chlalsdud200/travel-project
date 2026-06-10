/* salesMonthly.js - 누적 KPI */

var SalesMonthly = {};

SalesMonthly.state = { charts:{ combo:null, donut:null }, lastData:null };
SalesMonthly.qs = function(sel){ return document.querySelector(sel); };

SalesMonthly.nowStr = function(){
  var d=new Date();
  var y=d.getFullYear();
  var m=String(d.getMonth()+1).padStart(2,"0");
  var day=String(d.getDate()).padStart(2,"0");
  return y+"-"+m+"-"+day;
};

SalesMonthly.todayStr = function(){
  return SalesMonthly.nowStr();
};

SalesMonthly.setLastUpdated = function(){
  var el = SalesMonthly.qs("#lastUpdated");
  if(el) el.textContent = SalesMonthly.nowStr();
};

SalesMonthly.num = function(n){ return Number(n||0).toLocaleString("ko-KR"); };
SalesMonthly.won = function(n){ return SalesMonthly.num(n) + "원"; };
SalesMonthly.pct = function(a,b){
  a=Number(a||0); b=Number(b||0);
  if(b<=0) return "0.0%";
  return ((a/b)*100).toFixed(1) + "%";
};

SalesMonthly.getUnitFromBasis = function(basis){
  if(basis==="month") return "MONTH";
  if(basis==="day") return "DAY";
  if(basis==="week") return "DAY";
  return "MONTH";
};

SalesMonthly.buildParams = function(){
  var year  = SalesMonthly.qs("#selYear") ? SalesMonthly.qs("#selYear").value : "";
  var basis = SalesMonthly.qs("#selBasis") ? SalesMonthly.qs("#selBasis").value : "month";

  var from = SalesMonthly.qs("#dateFrom") ? SalesMonthly.qs("#dateFrom").value : "";
  var to   = SalesMonthly.qs("#dateTo") ? SalesMonthly.qs("#dateTo").value : "";

  if(!from || !to){
    from = year + "-01-01";
    to   = SalesMonthly.todayStr();
  }

  return { year:year, basis:basis, unit:SalesMonthly.getUnitFromBasis(basis), startDate:from, endDate:to };
};

SalesMonthly.toQuery = function(p){
  return [
    "year="+encodeURIComponent(p.year),
    "unit="+encodeURIComponent(p.unit),
    "startDate="+encodeURIComponent(p.startDate),
    "endDate="+encodeURIComponent(p.endDate)
  ].join("&");
};

SalesMonthly.fetchData = async function(params){
  if(!window.SALES_STATS_API) {
    throw new Error("SALES_STATS_API가 정의되지 않았습니다.");
  }

  var url = window.SALES_STATS_API + "?" + SalesMonthly.toQuery(params);
  
  console.log("API 호출:", url);
  
  var res = await fetch(url, { 
    method:"GET", 
    headers:{ "Accept":"application/json" }
  });

  if(!res.ok){
    var t = await res.text();
    console.error("API 응답 오류:", res.status, t);
    throw new Error("API 응답 오류: " + res.status + " / " + t.slice(0,120));
  }
  
  var data = await res.json();
  console.log("API 응답 데이터:", data);
  
  return data;
};

SalesMonthly.parseDate = function(s){
  var a = s.split("-");
  return new Date(Number(a[0]), Number(a[1])-1, Number(a[2]) || 1);
};

SalesMonthly.formatDate = function(d){
  var y=d.getFullYear();
  var m=String(d.getMonth()+1).padStart(2,"0");
  var day=String(d.getDate()).padStart(2,"0");
  return y+"-"+m+"-"+day;
};

SalesMonthly.weekLabel = function(d){
  var day=d.getDay();
  var diffToMon = (day===0) ? -6 : (1-day);
  var mon=new Date(d); mon.setDate(d.getDate()+diffToMon);
  var sun=new Date(mon); sun.setDate(mon.getDate()+6);
  return SalesMonthly.formatDate(mon)+"~"+SalesMonthly.formatDate(sun);
};

SalesMonthly.groupTimelineByWeek = function(list){
  var map={};
  for(var i=0;i<list.length;i++){
    var r=list[i];
    var d=SalesMonthly.parseDate(r.period);
    var key=SalesMonthly.weekLabel(d);

    if(!map[key]){
      map[key]={ period:key, paidAmt:0, refundReqAmt:0, cancelAmt:0, paidCnt:0, refundReqCnt:0, cancelCnt:0 };
    }
    map[key].paidAmt += Number(r.paidAmt||0);
    map[key].refundReqAmt += Number(r.refundReqAmt||0);
    map[key].cancelAmt += Number(r.cancelAmt||0);
    map[key].paidCnt += Number(r.paidCnt||0);
    map[key].refundReqCnt += Number(r.refundReqCnt||0);
    map[key].cancelCnt += Number(r.cancelCnt||0);
  }
  var keys=Object.keys(map); keys.sort();
  return keys.map(function(k){ return map[k]; });
};

SalesMonthly.destroyChart = function(ch){ 
  try{ 
    if(ch) ch.destroy(); 
  }catch(e){
    console.warn("차트 destroy 오류:", e);
  } 
};

SalesMonthly.renderKpi = function(data){
  var k = data && data.kpi ? data.kpi : null;
  
  if(!k){
    console.warn("KPI 데이터가 없습니다:", data);
    SalesMonthly.qs("#kpiThisGross").textContent="-";
    SalesMonthly.qs("#kpiTotalOrders").textContent="-";
    SalesMonthly.qs("#kpiRefundRate").textContent="-";
    SalesMonthly.qs("#kpiNetSales").textContent="-";
    return;
  }

  var thisPaid = Number(k.thisPaidAmt||0);
  var thisRefundReq = Number(k.thisRefundReqAmt||0);
  var thisPaidCnt = Number(k.thisPaidCnt||0);

  SalesMonthly.qs("#kpiThisGross").textContent = SalesMonthly.won(thisPaid);
  SalesMonthly.qs("#kpiTotalOrders").textContent = SalesMonthly.num(thisPaidCnt) + "건";
  SalesMonthly.qs("#kpiRefundRate").textContent = SalesMonthly.pct(thisRefundReq, thisPaid);
  
  // ✅ 누적 순매출에 30% 적용
  var netSales = thisPaid - thisRefundReq;
  var netSalesWithMargin = Math.floor(netSales * 0.3);
  SalesMonthly.qs("#kpiNetSales").textContent = SalesMonthly.won(netSalesWithMargin);
};

SalesMonthly.renderCombo = function(labels, paidArr, refundCancelArr){
  var canvas = SalesMonthly.qs("#comboChart");
  if(!canvas) {
    console.warn("콤보 차트 캔버스를 찾을 수 없습니다.");
    return;
  }

  SalesMonthly.destroyChart(SalesMonthly.state.charts.combo);

  SalesMonthly.state.charts.combo = new Chart(canvas.getContext("2d"), {
    type: "bar",
    data: {
      labels: labels,
      datasets: [
        {
          label: "총매출(PAID)",
          data: paidArr,
          backgroundColor: "rgba(59,130,246,0.55)",
          borderColor: "rgba(59,130,246,1)",
          borderWidth: 1,
          order: 1
        },
        {
          label: "환불+취소",
          data: refundCancelArr,
          backgroundColor: "rgba(239,68,68,0.35)",
          borderColor: "rgba(239,68,68,1)",
          borderWidth: 1,
          order: 2
        }
      ]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      layout: {
        padding: {
          top: 50,
          bottom: 20,
          left: 10,
          right: 10
        }
      },
      plugins: {
        datalabels: {
          display: function(context) {
            return context.dataset.data[context.dataIndex] > 0;
          },
          align: 'end',
          anchor: 'end',
          offset: 2,
          clip: false,
          color: function(context) {
            return context.datasetIndex === 0 ? '#1e40af' : '#991b1b';
          },
          font: {
            size: 10,
            weight: 'bold'
          },
          formatter: function(value) {
            if (!value || value === 0) return '';
            if (value >= 100000000) {
              return (value / 100000000).toFixed(1) + '억';
            }
            if (value >= 10000000) {
              return Math.round(value / 10000000) + '천만';
            }
            if (value >= 1000000) {
              return Math.round(value / 10000) + '만';
            }
            return '';
          }
        },
        legend: { position: "bottom" },
        tooltip: {
          callbacks: {
            label: function(ctx){
              return ctx.dataset.label + ": " + SalesMonthly.won(ctx.raw);
            }
          }
        }
      },
      scales: {
        x: { stacked: false },
        y: {
          beginAtZero: true,
          ticks: {
            maxTicksLimit: 6,
            callback: function(value){
              return (Number(value) / 10000).toLocaleString("ko-KR");
            }
          },
          title: { display: true, text: "금액(만원)" }
        }
      }
    },
    plugins: [ChartDataLabels]
  });
};

SalesMonthly.renderDonutCounts = function(totalPaidCnt, totalRefundCancelCnt){
  var canvas = SalesMonthly.qs("#donutChart");
  if(!canvas) {
    console.warn("도넛 차트 캔버스를 찾을 수 없습니다.");
    return;
  }

  SalesMonthly.destroyChart(SalesMonthly.state.charts.donut);

  var paidC = Number(totalPaidCnt || 0);
  var refundCancelC = Number(totalRefundCancelCnt || 0);

  SalesMonthly.state.charts.donut = new Chart(canvas.getContext("2d"), {
    type: "doughnut",
    data: {
      labels: ["결제완료(PAID)", "환불+취소"],
      datasets: [{
        data: [paidC, refundCancelC],
        backgroundColor: [
          "rgba(34,197,94,0.70)",
          "rgba(239,68,68,0.70)"
        ],
        borderColor: "rgba(255,255,255,0.95)",
        borderWidth: 2,
        hoverOffset: 10
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      cutout: "55%",
      rotation: -90,
      plugins: {
        datalabels: {
          display: true,
          color: '#fff',
          font: {
            size: 14,
            weight: 'bold'
          },
          formatter: function(value, context) {
            var total = context.dataset.data.reduce(function(a, b){ return a + b; }, 0);
            if (total === 0) return '';
            var percentage = ((value / total) * 100).toFixed(1);
            return percentage + '%\n(' + SalesMonthly.num(value) + '건)';
          }
        },
        legend: { position: "bottom" },
        tooltip: {
          callbacks: {
            label: function(ctx){
              return ctx.label + ": " + SalesMonthly.num(ctx.raw) + "건";
            }
          }
        }
      }
    },
    plugins: [ChartDataLabels]
  });
};

SalesMonthly.renderTable = function(series){
  var body = SalesMonthly.qs("#tblBody");
  if(!body) {
    console.warn("테이블 body를 찾을 수 없습니다.");
    return;
  }

  if(!series || series.length===0){
    body.innerHTML = '<tr><td colspan="7" class="sales-empty">데이터가 없습니다.</td></tr>';
    return;
  }

  var html="";
  for(var i=0;i<series.length;i++){
    var r=series[i];
    var paid = Number(r.paidAmt||0);
    var refundReq = Number(r.refundReqAmt||0);

    var net = paid - refundReq;
    var rate = (paid<=0) ? "0.0%" : ((refundReq/paid)*100).toFixed(1)+"%";

    html += "<tr>";
    html += "<td class='mono'>"+(r.period||"-")+"</td>";
    html += "<td class='mono'>"+SalesMonthly.won(paid)+"</td>";
    html += "<td class='mono'>"+SalesMonthly.won(refundReq)+"</td>";
    html += "<td class='mono'>"+SalesMonthly.won(net)+"</td>";
    html += "<td class='mono'>"+rate+"</td>";
    html += "<td class='mono'>"+SalesMonthly.num(r.paidCnt||0)+"</td>";
    html += "<td class='mono'>"+SalesMonthly.num(r.refundReqCnt||0)+"</td>";
    html += "</tr>";
  }
  body.innerHTML = html;
};

SalesMonthly.load = async function(){
  var params = SalesMonthly.buildParams();
  SalesMonthly.setLastUpdated();
  
  console.log("매출 통계 로드 시작:", params);

  try{
    var tbody = SalesMonthly.qs("#tblBody");
    if(tbody) tbody.innerHTML = '<tr><td colspan="7" class="sales-empty">데이터를 불러오는 중...</td></tr>';

    var data = await SalesMonthly.fetchData(params);
    SalesMonthly.state.lastData = data;

    var chartMeta = SalesMonthly.qs("#chartMeta");
    if(chartMeta) chartMeta.textContent = params.startDate+" ~ "+params.endDate+" ("+params.basis+")";
    var tableMeta = SalesMonthly.qs("#tableMeta");
    if(tableMeta) tableMeta.textContent = params.startDate+" ~ "+params.endDate+" ("+params.basis+")";

    SalesMonthly.renderKpi(data);

    var list = (data && data.timeline) ? data.timeline : [];
    var series = list.map(function(x){
      return {
        period: x.period,
        paidAmt: Number(x.paidAmt||0),
        refundReqAmt: Number(x.refundReqAmt||0),
        cancelAmt: Number(x.cancelAmt||0),
        paidCnt: Number(x.paidCnt||0),
        refundReqCnt: Number(x.refundReqCnt||0),
        cancelCnt: Number(x.cancelCnt||0)
      };
    });

    if(params.basis==="week"){
      series = SalesMonthly.groupTimelineByWeek(series);
    }

    var labels = series.map(function(r){ return r.period; });
    var paidArr = series.map(function(r){ return r.paidAmt; });
    var refundCancelArr = series.map(function(r){ 
      return Number(r.refundReqAmt||0);
    });

    SalesMonthly.renderCombo(labels, paidArr, refundCancelArr);

    var totalPaidCnt = 0;
    var totalRefundCancelCnt = 0;

    for(var i=0;i<series.length;i++){
      totalPaidCnt += Number(series[i].paidCnt || 0);
      totalRefundCancelCnt += Number(series[i].refundReqCnt || 0);
    }

    SalesMonthly.renderDonutCounts(totalPaidCnt, totalRefundCancelCnt);

    SalesMonthly.renderTable(series);
    
    console.log("매출 통계 로드 완료");

  }catch(err){
    console.error("매출 통계 로드 오류:", err);
    alert("매출 통계를 불러오지 못했습니다.\n" + err.message);
    
    var tbody = SalesMonthly.qs("#tblBody");
    if(tbody) tbody.innerHTML = '<tr><td colspan="7" class="sales-empty" style="color:red;">오류: ' + err.message + '</td></tr>';
  }
};
