package kr.or.ddit.tct.admin.prod.packageitem.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.tct.comm.vo.CountryVO;
import kr.or.ddit.tct.comm.vo.LocVO;
import kr.or.ddit.tct.product.hotels.vo.HotelsVO;
import kr.or.ddit.tct.product.item.vo.ItemVO;
import kr.or.ddit.tct.product.pTheme.vo.PThemeVO;

public interface IAdPackageService {

  public List<LocVO> getLocationList();

  public List<PThemeVO> getPThemeList();

  public CountryVO getCountryByLoc(String locId);

  public List<HotelsVO> getHotelsByLoc(String locId);

  public String getNextPkgId(String locId, String themeId);

  public String createPackage(String packageTitle, String locId, String themeId);
  
  public String createPackageWithItems(String packageTitle, String locId, String themeId,
          List<Map<String, Object>> items);
  
  public List<ItemVO> getItemList(String keyword, int limit);

}
