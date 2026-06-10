package kr.or.ddit.tct.admin.stats.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.tct.admin.stats.dao.ISalesMonthlyDao;
import kr.or.ddit.tct.admin.stats.dao.SalesMonthlyDaoImpl;
import kr.or.ddit.tct.admin.stats.vo.SalesKpiVO;
import kr.or.ddit.tct.admin.stats.vo.SalesPointVO;

public class SalesMonthlyServiceImpl implements ISalesMonthlyService {

  private static ISalesMonthlyService instance;
  private final ISalesMonthlyDao dao = SalesMonthlyDaoImpl.getInstance();

  private SalesMonthlyServiceImpl() {}

  public static ISalesMonthlyService getInstance() {
    if(instance == null) instance = new SalesMonthlyServiceImpl();
    return instance;
  }

  @Override
  public SalesKpiVO getSalesKpi(Map<String, String> param) {
    return dao.selectSalesKpi(param);
  }

  @Override
  public List<SalesPointVO> getSalesTimeline(Map<String, String> param) {
    return dao.selectSalesTimeline(param);
  }
}
