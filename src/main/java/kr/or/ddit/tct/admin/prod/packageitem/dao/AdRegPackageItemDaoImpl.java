package kr.or.ddit.tct.admin.prod.packageitem.dao;

import java.util.Collections;
import java.util.List;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.admin.prod.packageitem.dto.AdRegPackageItemDto;
import kr.or.ddit.tct.util.MyBatisUtil;

public class AdRegPackageItemDaoImpl implements IAdRegPackageItemDao {

  private static IAdRegPackageItemDao dao;

  private AdRegPackageItemDaoImpl() {}

  public static IAdRegPackageItemDao getInstance() {
    if (dao == null) dao = new AdRegPackageItemDaoImpl();
    return dao;
  }

  /**
   * 헤더(패키지/테마/등록상품) 1건 조회
   * mapper id: adprod.selectPackageItemHeader
   */
  @Override
  public AdRegPackageItemDto.Header selectHeader(String regId) {
    if (regId == null || regId.isBlank()) return null;

    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      return session.selectOne("adprod.selectPackageItemHeader", regId.trim());
    }
  }

  /**
   * 아이템 목록 N건 조회
   * mapper id: adprod.selectPackageItemRows
   */
  @Override
  public List<AdRegPackageItemDto.Item> selectItems(String regId) {
    if (regId == null || regId.isBlank()) return Collections.emptyList();

    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      List<AdRegPackageItemDto.Item> list =
          session.selectList("adprod.selectPackageItemRows", regId.trim());
      return (list == null) ? Collections.emptyList() : list;
    }
  }
}
