package kr.or.ddit.tct.admin.prod.packageitem.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.tct.admin.prod.packageitem.dto.HotelSearchDto;

public interface IAdPackageItemService {

  List<HotelSearchDto> searchHotels(String keyword, int limit);
  
  String createPackageWithItems(String packageTitle, String locId, String themeId, List<Map<String, Object>> items);
}
