package kr.or.ddit.tct.admin.stats.dao;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.admin.stats.vo.SalesKpiVO;
import kr.or.ddit.tct.admin.stats.vo.SalesPointVO;
import kr.or.ddit.tct.util.MyBatisUtil;

public class SalesMonthlyDaoImpl implements ISalesMonthlyDao {

  private static ISalesMonthlyDao instance;

  private SalesMonthlyDaoImpl() {}

  public static ISalesMonthlyDao getInstance() {
    if(instance == null) instance = new SalesMonthlyDaoImpl();
    return instance;
  }

  @Override
  public SalesKpiVO selectSalesKpi(Map<String, String> param) {
    SqlSession ss = null;
    try {
      ss = MyBatisUtil.getSqlSession();
      return ss.selectOne("salesMonthly.selectSalesKpi", param);
    } finally {
      if(ss != null) ss.close();
    }
  }

  @Override
  public List<SalesPointVO> selectSalesTimeline(Map<String, String> param) {
    SqlSession ss = null;
    try {
      ss = MyBatisUtil.getSqlSession();
      List<SalesPointVO> list = ss.selectList("salesMonthly.selectSalesTimeline", param);
      return (list == null) ? Collections.emptyList() : list;
    } finally {
      if(ss != null) ss.close();
    }
  }
}
