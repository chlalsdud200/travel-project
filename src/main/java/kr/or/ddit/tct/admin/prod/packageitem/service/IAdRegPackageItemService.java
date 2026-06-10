package kr.or.ddit.tct.admin.prod.packageitem.service;

import kr.or.ddit.tct.admin.prod.packageitem.dto.AdRegPackageItemDto;

public interface IAdRegPackageItemService {
  AdRegPackageItemDto selectByRegId(String regId);
}
