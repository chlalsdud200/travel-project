/* adminMemberStats.js
 * - 왜 필요한지: API JSON을 KPI/차트/표에 뿌리는 핵심 로직입니다.
 * - 무슨 기능인지: 필터 -> API 호출 -> Chart.js 렌더 -> 테이블 렌더를 수행합니다.
 *
 * ✅ 이번 수정 핵심
 * 1) 도넛 데이터 합계가 0이면 도넛을 "아예 안 보이게" 처리(캔버스 숨김 + 안내문구 표시)
 *    - 왜 필요한지: 데이터가 없는 날엔 빈 도넛이 아니라 "없음" 상태가 발표에서 더 자연스럽습니다.
 *    - 무슨 기능인지: series 합계=0 -> 차트 destroy -> canvas hide -> "데이터가 없습니다" 표시.
 */

var MemberStats = {};

MemberStats.state = {
  charts: {
    monthly: null,
    status: null,   // genderChart 자리를 회원상태 도넛으로 사용
    age: null,
    revenue: null
  },
  lastData: null
};

MemberStats.qs = function(sel){ return document.querySelector(sel); };

MemberStats.nowStr = function(){
  var d = new Date();
  var y = d.getFullYear();
  var m = String(d.getMonth()+1).padStart(2, "0");
  var day = String(d.getDate()).padStart(2, "0");
  return y + "-" + m + "-" + day;
};

MemberStats.todayStr = function(){
  return MemberStats.nowStr();
};

MemberStats.setLastUpdated = function(){
  var el = MemberStats.qs("#lastUpdated");
  if(el) el.textContent = MemberStats.nowStr();
};

/* basis(월/주/일) -> mapper unit(MONTH/DAY) 변환
 * - week는 mapper에 없으니 DAY로 받아오고, JS에서 주별로 묶습니다.
 */
MemberStats.getUnitFromBasis = function(basis){
  if(basis === "month") return "MONTH";
  if(basis === "day") return "DAY";
  if(basis === "week") return "DAY"; // 주별은 JS에서 그룹
  return "MONTH";
};

MemberStats.buildParams = function(){
  var year  = MemberStats.qs("#selYear")  ? MemberStats.qs("#selYear").value  : "";
  var basis = MemberStats.qs("#selBasis") ? MemberStats.qs("#selBasis").value : "month";
  var typeUi= MemberStats.qs("#selType")  ? MemberStats.qs("#selType").value  : "new";

  // UI type: new/active/all/quit
  // mapper type: new/active/all (quit은 DB에 탈퇴일이 없어 기간필터 불가 -> all로 처리)
  var type = (typeUi === "quit") ? "all" : typeUi;

  var from = MemberStats.qs("#dateFrom") ? MemberStats.qs("#dateFrom").value : "";
  var to   = MemberStats.qs("#dateTo")   ? MemberStats.qs("#dateTo").value   : "";

  // 날짜를 안 고르면 연도로 자동 세팅(컨트롤러에서도 처리하지만 JS도 맞춰줌)
  if(!from || !to){
    from = year + "-01-01";
    to   = MemberStats.todayStr();
  }

  var unit = MemberStats.getUnitFromBasis(basis);

  return {
    year: year,
    basis: basis,  // JS용
    unit: unit,    // API로 보냄
    typeUi: typeUi,
    type: type,
    startDate: from,
    endDate: to
  };
};

MemberStats.toQuery = function(p){
  var q = [];
  q.push("year=" + encodeURIComponent(p.year));
  q.push("unit=" + encodeURIComponent(p.unit));
  q.push("type=" + encodeURIComponent(p.type));
  q.push("startDate=" + encodeURIComponent(p.startDate));
  q.push("endDate=" + encodeURIComponent(p.endDate));
  return q.join("&");
};

MemberStats.fetchData = async function(params){
  var url = window.MEMBER_STATS_API + "?" + MemberStats.toQuery(params);
  var res = await fetch(url, { method:"GET", headers:{ "Accept":"application/json" } });
  if(!res.ok){
    throw new Error("API 응답 오류: " + res.status);
  }
  return await res.json();
};

/* ========= 데이터 가공(주별 그룹) ========= */
MemberStats.parseDate = function(yyyy_mm_dd){
  // 'YYYY-MM-DD'
  var a = yyyy_mm_dd.split("-");
  return new Date(Number(a[0]), Number(a[1])-1, Number(a[2]));
};

MemberStats.formatDate = function(d){
  var y = d.getFullYear();
  var m = String(d.getMonth()+1).padStart(2, "0");
  var day = String(d.getDate()).padStart(2, "0");
  return y + "-" + m + "-" + day;
};

// 월요일 시작 주간 범위 라벨: "YYYY-MM-DD~YYYY-MM-DD"
MemberStats.weekLabel = function(d){
  var day = d.getDay(); // 0=Sun, 1=Mon ...
  var diffToMon = (day === 0) ? -6 : (1 - day);
  var mon = new Date(d);
  mon.setDate(d.getDate() + diffToMon);

  var sun = new Date(mon);
  sun.setDate(mon.getDate() + 6);

  return MemberStats.formatDate(mon) + "~" + MemberStats.formatDate(sun);
};

// (차트용) label/value 리스트를 주 단위로 합산
MemberStats.groupByWeek = function(list){
  var map = {};
  for(var i=0; i<list.length; i++){
    var it = list[i];
    var d = MemberStats.parseDate(it.label); // day 단위 라벨 전제
    var key = MemberStats.weekLabel(d);
    if(!map[key]) map[key] = 0;
    map[key] += Number(it.value || 0);
  }
  var keys = Object.keys(map);
  keys.sort(); // YYYY-MM-DD 시작 문자열이면 대체로 날짜순
  var out = [];
  for(var k=0; k<keys.length; k++){
    out.push({ label: keys[k], value: map[keys[k]] });
  }
  return out;
};

// (테이블용) period/newMembers/activeMembers 리스트를 주 단위로 합산
MemberStats.groupTableByWeek = function(list){
  var map = {}; // key: "YYYY-MM-DD~YYYY-MM-DD", value: {period, newMembers, activeMembers}

  for(var i=0; i<list.length; i++){
    var row = list[i];
    var d = MemberStats.parseDate(row.period); // period가 "YYYY-MM-DD" 전제
    var key = MemberStats.weekLabel(d);

    if(!map[key]){
      map[key] = { period: key, newMembers: 0, activeMembers: 0 };
    }
    map[key].newMembers += Number(row.newMembers || 0);
    map[key].activeMembers += Number(row.activeMembers || 0);
  }

  var keys = Object.keys(map);
  keys.sort();

  var out = [];
  for(var k=0; k<keys.length; k++){
    out.push(map[keys[k]]);
  }
  return out;
};

/* ========= 렌더(공통) ========= */
MemberStats.setText = function(id, val){
  var el = MemberStats.qs(id);
  if(el) el.textContent = (val === null || val === undefined) ? "-" : String(val);
};

MemberStats.destroyChart = function(ch){
  try{ if(ch) ch.destroy(); } catch(e){}
};

MemberStats.pct = function(value, total){
  value = Number(value || 0);
  total = Number(total || 0);
  if(total <= 0) return "0%";
  return ((value / total) * 100).toFixed(1) + "%";
};

/* ========= 도넛 "데이터없음" UI =========
 * - 왜 필요한지: 값이 전부 0이면 도넛을 숨기고 안내문구를 띄우기 위해서입니다.
 * - 무슨 기능인지: canvas 부모에 overlay(div.chart-empty)를 만들어 show/hide 합니다.
 */
MemberStats.getEmptyBox = function(canvasEl){
  if(!canvasEl) return null;

  var parent = canvasEl.parentElement;
  if(!parent) return null;

  // 부모가 static이면 overlay가 안 예쁠 수 있어 relative로 보정
  try{
    var pos = window.getComputedStyle(parent).position;
    if(pos === "static") parent.style.position = "relative";
  }catch(e){}

  var box = parent.querySelector(".chart-empty");
  if(!box){
    box = document.createElement("div");
    box.className = "chart-empty";
    box.style.position = "absolute";
    box.style.left = "0";
    box.style.top = "0";
    box.style.right = "0";
    box.style.bottom = "0";
    box.style.display = "none";
    box.style.alignItems = "center";
    box.style.justifyContent = "center";
    box.style.color = "#94a3b8";
    box.style.fontSize = "14px";
    box.style.fontWeight = "600";
    box.style.textAlign = "center";
    box.style.padding = "12px";
    box.style.borderRadius = "10px";
    box.style.pointerEvents = "none";
    parent.appendChild(box);
  }
  return box;
};

MemberStats.toggleDoughnutEmpty = function(canvasEl, showCanvas, msg){
  var box = MemberStats.getEmptyBox(canvasEl);
  if(!canvasEl) return;

  if(showCanvas){
    canvasEl.style.display = "";
    if(box){
      box.style.display = "none";
      box.textContent = "";
    }
  }else{
    canvasEl.style.display = "none";
    if(box){
      box.style.display = "flex";
      box.textContent = msg || "데이터가 없습니다.";
    }
  }
};

/* ========= Chart.js 렌더 ========= */
MemberStats.renderBar = function(canvasId, series, oldChart){
  var el = MemberStats.qs(canvasId);
  if(!el) return null;

  MemberStats.destroyChart(oldChart);

  series = series || [];
  var labels = series.map(function(x){ return x.label; });
  var values = series.map(function(x){ return Number(x.value || 0); });

  return new Chart(el.getContext("2d"), {
    type: "bar",
    data: {
      labels: labels,
      datasets: [{
        label: "회원 수",
        data: values,
        backgroundColor: "rgba(59,130,246,0.55)",
        borderColor: "rgba(59,130,246,1)",
        borderWidth: 1
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: { display: false }
      },
      scales: {
        y: { beginAtZero: true }
      }
    }
  });
};

MemberStats.renderDoughnut = function(canvasId, series, oldChart, labelText){
  var el = MemberStats.qs(canvasId);
  if(!el) return null;

  series = series || [];

  // ✅ (핵심) 합계가 0이면 도넛 자체를 숨김
  var sum = 0;
  for(var i=0; i<series.length; i++){
    sum += Number(series[i].value || 0);
  }
  if(series.length === 0 || sum === 0){
    MemberStats.destroyChart(oldChart);
    MemberStats.toggleDoughnutEmpty(el, false, "데이터가 없습니다.");
    return null;
  }

  // 값이 있으면 다시 canvas 보이기
  MemberStats.toggleDoughnutEmpty(el, true);

  MemberStats.destroyChart(oldChart);

  var labels = series.map(function(x){ return x.label; });
  var values = series.map(function(x){ return Number(x.value || 0); });

  // 0도 조각이 보이게(표시는 0 유지)
  var rawValues = values.slice();
  var drawValues = values.map(function(v){
    v = Number(v || 0);
    return (v === 0) ? 0.0001 : v;
  });

  // 도넛 색 매핑
  var colorMap = {
    "활성": "rgba(245,158,11,0.75)",
    "신규": "rgba(34,197,94,0.75)",
    "탈퇴": "rgba(148,163,184,0.75)",
    "비활동": "rgba(239,68,68,0.75)",

    "20대": "rgba(59,130,246,0.75)",
    "30대": "rgba(34,197,94,0.75)",
    "40대": "rgba(245,158,11,0.75)",
    "50대+": "rgba(239,68,68,0.75)",
    "미입력": "rgba(148,163,184,0.75)",

    "5~100만원": "rgba(59,130,246,0.75)",
    "101~200만원": "rgba(34,197,94,0.75)",
    "201~300만원": "rgba(245,158,11,0.75)",
    "301~500만원": "rgba(239,68,68,0.75)",
    "기타": "rgba(148,163,184,0.75)"
  };

  var bg = labels.map(function(l){
    return colorMap[l] || "rgba(99,102,241,0.75)";
  });

  var pluginsArr = [];
  if(window.ChartDataLabels) pluginsArr.push(ChartDataLabels);

  return new Chart(el.getContext("2d"), {
    type: "doughnut",
    data: {
      labels: labels,
      datasets: [{
        label: labelText || "분포",
        data: drawValues,
        backgroundColor: bg,
        borderColor: "rgba(255,255,255,0.9)",
        borderWidth: 2
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: { position: "bottom" },
        datalabels: {
          color: function(ctx){
            var colors = (ctx.dataset && ctx.dataset.backgroundColor) ? ctx.dataset.backgroundColor : [];
            return colors[ctx.dataIndex] || "#334155";
          },
          font: { size: 11, weight: "bold" },
          textStrokeColor: "rgba(255,255,255,0.9)",
          textStrokeWidth: 3,
          formatter: function(_, ctx){
            var real = Number(rawValues[ctx.dataIndex] || 0);
            if(real <= 0) return "";
            return MemberStats.pct(real, sum);
          }
        },
        tooltip: {
          callbacks: {
            label: function(ctx){
              var real = rawValues[ctx.dataIndex] || 0;
              return ctx.label + ": " + real + " (" + MemberStats.pct(real, sum) + ")";
            }
          }
        }
      }
    },
    plugins: pluginsArr
  });
};

/* ========= KPI 렌더 ========= */
MemberStats.renderKpi = function(data){
  // data.kpi: {total, withdrawn, new7days, activeRange, admin}
  var k = data.kpi || {};
  MemberStats.setText("#kpiTotal", k.total);
  MemberStats.setText("#kpiNew", k.new7days);       // 신규=최근7일
  MemberStats.setText("#kpiActive", k.activeRange); // 활성=기간 내
  MemberStats.setText("#kpiQuit", k.withdrawn);     // 탈퇴=누적
};

/* ========= 테이블 렌더 =========
 * 현재 4~5열은 "전체 대비 비중(%)"으로 사용합니다.
 * - 신규 비중(%) = newMembers / kpi.total * 100
 * - 활성 비중(%) = activeMembers / kpi.total * 100
 *
 * (주의) JSP의 테이블 헤더도 "탈퇴/누적" 대신 "신규 비중/활성 비중"으로 바꾸는 것을 권장합니다.
 */
MemberStats.renderTable = function(params, data){
  var body = MemberStats.qs("#tblBody");
  if(!body) return;

  var list = data.tablePeriod || [];

  if(params.basis === "week"){
    list = MemberStats.groupTableByWeek(list);
  }

  if(!list || list.length === 0){
    body.innerHTML = '<tr><td colspan="5" class="member-empty">데이터가 없습니다.</td></tr>';
    return;
  }

  list = list.slice().sort(function(a,b){
    return String(a.period||"").localeCompare(String(b.period||""));
  });

  var k = data.kpi || {};
  var withdrawn = Number(k.withdrawn || 0);  // 누적 탈퇴 수

  var html = "";
  for(var i=0; i<list.length; i++){
    var row = list[i];
    var period = row.period || "-";
    var newM = Number(row.newMembers || 0);
    var actM = Number(row.activeMembers || 0);

    html += "<tr>";
    html += "<td>" + period + "</td>";
    html += "<td>" + newM + "</td>";        // 신규 회원
    html += "<td>" + actM + "</td>";        // 활성 회원
    html += "<td>" + withdrawn + "</td>";   // ✅ 누적 탈퇴 수 (모든 행에 동일)
    html += "<td>" + (newM + actM) + "</td>"; // ✅ 해당 기간 누적 (신규+활성)
    html += "</tr>";
  }

  body.innerHTML = html;

  var info = MemberStats.qs("#tableInfo");
  if(info){
    info.textContent = params.startDate + " ~ " + params.endDate + " (" + params.basis + ")";
  }
};
/* ========= 차트 렌더 ========= */
MemberStats.renderCharts = function(params, data){
  var basis = params.basis;

  // 1) 월별 가입자(bar)
  var joiners = data.trendJoiners || [];
  if(basis === "week"){
    joiners = MemberStats.groupByWeek(joiners);
  }
  MemberStats.state.charts.monthly =
    MemberStats.renderBar("#monthlyChart", joiners, MemberStats.state.charts.monthly);

  // 2) 회원상태 도넛
  var statusDist = data.distMemberStatus3 || [];
  MemberStats.state.charts.status =
    MemberStats.renderDoughnut("#genderChart", statusDist, MemberStats.state.charts.status, "회원상태");

  // 3) 연령 도넛
  var ageDist = data.distAge || [];
  MemberStats.state.charts.age =
    MemberStats.renderDoughnut("#ageChart", ageDist, MemberStats.state.charts.age, "연령대");

  // 4) 금액 도넛
  var revDist = data.distRevenue || [];
  MemberStats.state.charts.revenue =
    MemberStats.renderDoughnut("#revenueChart", revDist, MemberStats.state.charts.revenue, "결제금액");
};

MemberStats.load = async function(){
  var params = MemberStats.buildParams();
  MemberStats.setLastUpdated();

  try{
    // 로딩 표시
    var tbody = MemberStats.qs("#tblBody");
    if(tbody){
      tbody.innerHTML = '<tr><td colspan="5" class="member-empty">데이터를 불러오는 중...</td></tr>';
    }

    var data = await MemberStats.fetchData(params);
    console.log("[MemberStats] API 응답", data);
    console.log("[MemberStats] 요청", window.MEMBER_STATS_API + "?" + MemberStats.toQuery(params));

	console.log("KPI total:", data.kpi.total);
	console.log("KPI withdrawn:", data.kpi.withdrawn);
	console.log("Table data:", data.tablePeriod);
	
    MemberStats.state.lastData = data;

    MemberStats.renderKpi(data);
    MemberStats.renderCharts(params, data);
    MemberStats.renderTable(params, data);

  }catch(err){
    console.error(err);
    alert("통계 데이터를 불러오지 못했습니다.\n" + err.message);
  }
};
