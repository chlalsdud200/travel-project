package kr.or.ddit.tct.sales.wishlist.dao;

import java.util.List;
import java.util.Map;

public interface IWishDao {

  int insertWishIfNotExists(String userId, String regId);

  int deleteWish(String userId, String regId);

  int existsWish(String userId, String regId);

  List<Map<String, Object>> selectWishList(String userId);
}
