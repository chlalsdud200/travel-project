package kr.or.ddit.tct.admin.stats.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.admin.stats.vo.PackageAutocompleteVO;
import kr.or.ddit.tct.admin.stats.vo.PackageComparisonVO;
import kr.or.ddit.tct.admin.stats.vo.PackageSalesRowVO;
import kr.or.ddit.tct.util.MyBatisUtil;
import kr.or.ddit.tct.admin.stats.vo.PackageRegItemVO;
import kr.or.ddit.tct.admin.stats.vo.RegCompareRowVO;

public class PackageSalesDaoImpl implements IPackageSalesDao {

  private static IPackageSalesDao dao;

  private PackageSalesDaoImpl() {}

  public static IPackageSalesDao getInstance() {
    if (dao == null) dao = new PackageSalesDaoImpl();
    return dao;
  }

  @Override
  public List<PackageSalesRowVO> selectPackageSalesList(Map<String, Object> param) {
    try (SqlSession sql = MyBatisUtil.getSqlSession()) {
      return sql.selectList("salesMonthly.selectPackageSalesList", param);
    }
  }

  @Override
  public int selectPackageSalesCount(Map<String, Object> param) {
    try (SqlSession sql = MyBatisUtil.getSqlSession()) {
      Integer n = sql.selectOne("salesMonthly.selectPackageSalesCount", param);
      return (n == null) ? 0 : n.intValue();
    }
  }

  @Override
  public List<PackageAutocompleteVO> selectPackageAutocomplete(Map<String, Object> param) {
    try (SqlSession sql = MyBatisUtil.getSqlSession()) {
      return sql.selectList("salesMonthly.selectPackageAutocomplete", param);
    }
  }

  @Override
  public List<PackageComparisonVO> selectPackageComparison(Map<String, Object> param) {
    try (SqlSession sql = MyBatisUtil.getSqlSession()) {
      return sql.selectList("salesMonthly.selectPackageComparison", param);
    }
  }

  @Override
  public List<PackageComparisonVO> selectTotalSalesByPeriod(Map<String, Object> param) {
    try (SqlSession sql = MyBatisUtil.getSqlSession()) {
      return sql.selectList("salesMonthly.selectTotalSalesByPeriod", param);
    }
  }
  
  // ✅ 추가: packageIds 기반 비교
  @Override
  public List<PackageComparisonVO> selectPackageComparisonByIds(Map<String, Object> param) {
    try (SqlSession sql = MyBatisUtil.getSqlSession()) {
      return sql.selectList("salesMonthly.selectPackageComparisonByIds", param);
    }
  }
  
  @Override
  public List<PackageRegItemVO> selectPackageRegList(Map<String, Object> param) {
    SqlSession session = null;
    try {
      session = MyBatisUtil.getSqlSession();
      return session.selectList("salesMonthly.selectPackageRegList", param);
    } finally {
      if (session != null) session.close();
    }
  }

  @Override
  public List<RegCompareRowVO> selectPackageRegCompare(Map<String, Object> param) {
    SqlSession session = null;
    try {
      session = MyBatisUtil.getSqlSession();
      return session.selectList("salesMonthly.selectPackageRegCompare", param);
    } finally {
      if (session != null) session.close();
    }
  }

}