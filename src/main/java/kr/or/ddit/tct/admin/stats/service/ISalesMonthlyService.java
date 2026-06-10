package kr.or.ddit.tct.admin.stats.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.tct.admin.stats.vo.SalesKpiVO;
import kr.or.ddit.tct.admin.stats.vo.SalesPointVO;

public interface ISalesMonthlyService {

  SalesKpiVO getSalesKpi(Map<String, String> param);

  List<SalesPointVO> getSalesTimeline(Map<String, String> param);
}
