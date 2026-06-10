package kr.or.ddit.tct.admin.prod.packageitem.dao;

import java.util.List;
import kr.or.ddit.tct.admin.prod.packageitem.dto.AdRegPackageItemDto;

public interface IAdRegPackageItemDao {

  AdRegPackageItemDto.Header selectHeader(String regId);

  List<AdRegPackageItemDto.Item> selectItems(String regId);
}
