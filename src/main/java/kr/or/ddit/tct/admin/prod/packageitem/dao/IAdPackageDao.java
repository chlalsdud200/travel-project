package kr.or.ddit.tct.admin.prod.packageitem.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.comm.vo.CountryVO;
import kr.or.ddit.tct.comm.vo.LocVO;
import kr.or.ddit.tct.product.hotels.vo.HotelsVO;
import kr.or.ddit.tct.product.item.vo.ItemVO;
import kr.or.ddit.tct.product.pTheme.vo.PThemeVO;

public interface IAdPackageDao {

	List<LocVO> selectLocationList();

	List<PThemeVO> selectPThemeList();

	CountryVO selectCountryByLoc(String locId);

	List<HotelsVO> selectHotelsByLoc(String locId);

	String selectNextPackageNo(String prefix);

	int insertPackage(Map<String, Object> param);

	CountryVO selectCountryByLoc(SqlSession session, String locId);

	String selectNextPackageNo(SqlSession session, String prefix);

	int insertPackage(SqlSession session, Map<String, Object> param);

	int insertPackageItems(SqlSession session, String pkgId, List<Map<String, Object>> items);
	
	List<ItemVO> selectItemList(String keyword, int limit);
}
