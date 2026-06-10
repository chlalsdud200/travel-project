package kr.or.ddit.tct.sales.wishlist.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.tct.sales.wishlist.dao.IWishDao;
import kr.or.ddit.tct.sales.wishlist.dao.WishDaoImpl;

public class WishServiceImpl implements IWishService {

  private static IWishService service;
  private final IWishDao dao = WishDaoImpl.getInstance();

  private WishServiceImpl() {}

  public static IWishService getInstance() {
    if (service == null) service = new WishServiceImpl();
    return service;
  }

  @Override
  public boolean toggleWish(String userId, String regId) {
    int exist = dao.existsWish(userId, regId);

    if (exist > 0) {
      dao.deleteWish(userId, regId);
      return false;
    }

    dao.insertWishIfNotExists(userId, regId);

    // insert가 0이어도(이미 존재 등) 현재 상태를 확실히 맞춤
    return dao.existsWish(userId, regId) > 0;
  }

  @Override
  public List<Map<String, Object>> getWishList(String userId) {
    return dao.selectWishList(userId);
  }

  @Override
  public int existsWish(String userId, String regId) {
    return dao.existsWish(userId, regId);
  }

  @Override
  public int deleteWish(String userId, String regId) {
    return dao.deleteWish(userId, regId);
  }
}
