package kr.or.ddit.tct.sales.wishlist.service;

import java.util.List;
import java.util.Map;

public interface IWishService {

  // return: true=찜됨, false=찜 해제됨
  boolean toggleWish(String userId, String regId);

  List<Map<String, Object>> getWishList(String userId);

  int existsWish(String userId, String regId);

  int deleteWish(String userId, String regId);
}
