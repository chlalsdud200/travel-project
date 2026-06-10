package kr.or.ddit.tct.admin.stats.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.tct.admin.stats.dao.IPackageSalesDao;
import kr.or.ddit.tct.admin.stats.dao.PackageSalesDaoImpl;
import kr.or.ddit.tct.admin.stats.vo.PackageAutocompleteVO;
import kr.or.ddit.tct.admin.stats.vo.PackageComparisonVO;
import kr.or.ddit.tct.admin.stats.vo.PackageRegItemVO;
import kr.or.ddit.tct.admin.stats.vo.PackageSalesRowVO;
import kr.or.ddit.tct.admin.stats.vo.RegCompareRowVO;

public class PackageSalesServiceImpl implements IPackageSalesService {
  private static IPackageSalesService service;
  private final IPackageSalesDao dao = PackageSalesDaoImpl.getInstance();

  private PackageSalesServiceImpl() {}

  public static IPackageSalesService getInstance() {
    if (service == null) service = new PackageSalesServiceImpl();
    return service;
  }

  @Override
  public List<PackageSalesRowVO> getPackageSalesList(Map<String, Object> param) {
    return dao.selectPackageSalesList(param);
  }

  @Override
  public int getPackageSalesCount(Map<String, Object> param) {
    return dao.selectPackageSalesCount(param);
  }

  @Override
  public List<PackageAutocompleteVO> getPackageAutocomplete(Map<String, Object> param) {
    return dao.selectPackageAutocomplete(param);
  }

  @Override
  public List<PackageComparisonVO> getPackageComparison(Map<String, Object> param) {
    return dao.selectPackageComparison(param);
  }

  @Override
  public List<PackageComparisonVO> getTotalSalesByPeriod(Map<String, Object> param) {
    return dao.selectTotalSalesByPeriod(param);
  }

  @Override
  public List<PackageRegItemVO> getPackageRegList(Map<String, Object> param) {
    return dao.selectPackageRegList(param);
  }

  @Override
  public List<RegCompareRowVO> getPackageRegCompare(Map<String, Object> param) {
    return dao.selectPackageRegCompare(param);
  }
  
  // ✅ mapper가 아니라 dao를 사용
  @Override
  public List<PackageComparisonVO> getPackageComparisonByIds(Map<String, Object> param) {
    return dao.selectPackageComparisonByIds(param);
  }
}