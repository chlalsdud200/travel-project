package kr.or.ddit.tct.admin.stats.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.tct.admin.stats.vo.PackageAutocompleteVO;
import kr.or.ddit.tct.admin.stats.vo.PackageComparisonVO;
import kr.or.ddit.tct.admin.stats.vo.PackageRegItemVO;
import kr.or.ddit.tct.admin.stats.vo.PackageSalesRowVO;
import kr.or.ddit.tct.admin.stats.vo.RegCompareRowVO;

public interface IPackageSalesService {

  List<PackageSalesRowVO> getPackageSalesList(Map<String, Object> param);
  int getPackageSalesCount(Map<String, Object> param);

  List<PackageAutocompleteVO> getPackageAutocomplete(Map<String, Object> param);

  List<PackageComparisonVO> getPackageComparison(Map<String, Object> param);
  List<PackageComparisonVO> getTotalSalesByPeriod(Map<String, Object> param);
  
  // ✅ 추가: packageIds 기반 비교
  List<PackageComparisonVO> getPackageComparisonByIds(Map<String, Object> param);

  List<PackageRegItemVO> getPackageRegList(Map<String, Object> param);
  List<RegCompareRowVO> getPackageRegCompare(Map<String, Object> param);

}