package kr.or.ddit.tct.admin.prod.packageitem.service;

import java.util.List;

import kr.or.ddit.tct.admin.prod.packageitem.dao.AdRegPackageItemDaoImpl;
import kr.or.ddit.tct.admin.prod.packageitem.dao.IAdRegPackageItemDao;
import kr.or.ddit.tct.admin.prod.packageitem.dto.AdRegPackageItemDto;

public class AdRegPackageItemServiceImpl implements IAdRegPackageItemService {

  private static IAdRegPackageItemService service;
  private final IAdRegPackageItemDao dao = AdRegPackageItemDaoImpl.getInstance();

  private AdRegPackageItemServiceImpl() {}

  public static IAdRegPackageItemService getInstance() {
    if (service == null) service = new AdRegPackageItemServiceImpl();
    return service;
  }

  @Override
  public AdRegPackageItemDto selectByRegId(String regId) {
    if (regId == null || regId.isBlank()) return null;

    AdRegPackageItemDto.Header header = dao.selectHeader(regId);
    List<AdRegPackageItemDto.Item> items = dao.selectItems(regId);

    // regId가 잘못되면 header가 null일 수 있음
    if (header == null || header.getRegId() == null) return null;

    AdRegPackageItemDto res = new AdRegPackageItemDto();
    res.setHeader(header);
    res.setItems(items);
    return res;
  }
}
