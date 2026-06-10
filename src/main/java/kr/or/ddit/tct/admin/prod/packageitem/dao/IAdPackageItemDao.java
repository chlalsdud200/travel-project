package kr.or.ddit.tct.admin.prod.packageitem.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.admin.prod.packageitem.dto.HotelSearchDto;
import kr.or.ddit.tct.admin.prod.packageitem.dto.PackageItemRowDto;

public interface IAdPackageItemDao {

  /**
   * 숙박시설 검색
   * @param keyword 호텔명 / 호텔코드 / 지역명
   * @param limit 최대 조회 수
   */
  List<HotelSearchDto> searchHotels(String keyword, int limit);
  
  /** PACKAGE_ITEM 단건 insert */
  int insertPackageItem(SqlSession session, String pkgId, PackageItemRowDto row);

  /** PACKAGE_ITEM 다건 insert(루프) - pitem_no가 기본키+시퀀스라서 루프로 인서트 */
  int insertPackageItems(SqlSession session, String pkgId, List<PackageItemRowDto> rows);
}
