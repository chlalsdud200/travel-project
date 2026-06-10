package kr.or.ddit.tct.admin.prod.packageitem.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.admin.prod.packageitem.dto.HotelSearchDto;
import kr.or.ddit.tct.admin.prod.packageitem.dto.PackageItemRowDto;
import kr.or.ddit.tct.util.MyBatisUtil;

public class AdPackageItemDaoImpl implements IAdPackageItemDao {

  private static IAdPackageItemDao dao;

  private AdPackageItemDaoImpl() {}

  public static IAdPackageItemDao getInstance() {
    if (dao == null) dao = new AdPackageItemDaoImpl();
    return dao;
  }

  @Override
  public List<HotelSearchDto> searchHotels(String keyword, int limit) {

    String kw = (keyword == null) ? "" : keyword.trim();
    int lim = limit;

    if (lim < 1) lim = 1;
    if (lim > 100) lim = 100;

    Map<String, Object> param = new HashMap<>();
    param.put("keyword", kw);
    param.put("limit", lim);

    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      // adPackageMapper에 등록한 SQL
      return session.selectList(
        "adPackageMapper.adSearchHotels",
        param
      );
    }
  }
  
  
  @Override
  public int insertPackageItem(SqlSession session, String pkgId, PackageItemRowDto row) {
    if (session == null) throw new IllegalArgumentException("SqlSession is null");
    if (pkgId == null || pkgId.isBlank()) throw new IllegalArgumentException("pkgId is blank");
    if (row == null) throw new IllegalArgumentException("row is null");
    if (row.getItemId() == null || row.getItemId().isBlank())
      throw new IllegalArgumentException("itemId is blank");

    Map<String, Object> p = new HashMap<>();
    p.put("pkgId", pkgId);
    p.put("itemId", row.getItemId());
    p.put("hotelId", (row.getHotelId() == null || row.getHotelId().isBlank()) ? null : row.getHotelId());
    p.put("byDate", row.getByDate()); // VARCHAR2라 String 그대로

    return session.insert("adPackageMapper.insertPackageItem", p);
  }
  
  @Override
  public int insertPackageItems(SqlSession session, String pkgId, List<PackageItemRowDto> rows) {
    if (rows == null || rows.isEmpty()) return 0;

    int cnt = 0;
    for (PackageItemRowDto row : rows) {
      cnt += insertPackageItem(session, pkgId, row);
    }
    return cnt;
  }
}
