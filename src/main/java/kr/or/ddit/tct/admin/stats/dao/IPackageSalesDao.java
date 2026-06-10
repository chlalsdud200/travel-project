package kr.or.ddit.tct.admin.stats.dao;

import java.util.List;
import java.util.Map;

import kr.or.ddit.tct.admin.stats.vo.PackageAutocompleteVO;
import kr.or.ddit.tct.admin.stats.vo.PackageComparisonVO;
import kr.or.ddit.tct.admin.stats.vo.PackageSalesRowVO;
import kr.or.ddit.tct.admin.stats.vo.PackageRegItemVO;
import kr.or.ddit.tct.admin.stats.vo.RegCompareRowVO;

public interface IPackageSalesDao {

  List<PackageSalesRowVO> selectPackageSalesList(Map<String, Object> param);
  int selectPackageSalesCount(Map<String, Object> param);

  List<PackageAutocompleteVO> selectPackageAutocomplete(Map<String, Object> param);

  List<PackageComparisonVO> selectPackageComparison(Map<String, Object> param);
  List<PackageComparisonVO> selectTotalSalesByPeriod(Map<String, Object> param);
  
  // ✅ 추가: packageIds 기반 비교
  List<PackageComparisonVO> selectPackageComparisonByIds(Map<String, Object> param);

  List<PackageRegItemVO> selectPackageRegList(Map<String, Object> param);
  List<RegCompareRowVO> selectPackageRegCompare(Map<String, Object> param);

}