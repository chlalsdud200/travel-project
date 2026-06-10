package kr.or.ddit.tct.admin.stats.dao;

import java.util.List;
import java.util.Map;

import kr.or.ddit.tct.admin.stats.vo.SalesKpiVO;
import kr.or.ddit.tct.admin.stats.vo.SalesPointVO;

public interface ISalesMonthlyDao {

  // KPI (이번달 매출/전월 매출/이번달 환불요청액/이번달 결제건수)
  SalesKpiVO selectSalesKpi(Map<String, String> param);

  // 타임라인(월/일 unit 기반) - 주별은 JS에서 묶기
  List<SalesPointVO> selectSalesTimeline(Map<String, String> param);
}
