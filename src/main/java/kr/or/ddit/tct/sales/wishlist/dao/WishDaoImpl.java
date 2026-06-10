package kr.or.ddit.tct.sales.wishlist.dao;

import java.util.*;
import org.apache.ibatis.session.SqlSession;
import kr.or.ddit.tct.util.MyBatisUtil;

public class WishDaoImpl implements IWishDao {
  private static IWishDao dao;
  private WishDaoImpl() {}
  public static IWishDao getInstance() {
    if (dao == null) dao = new WishDaoImpl();
    return dao;
  }

  private Map<String,Object> param(String userId, String regId){
    Map<String,Object> m = new HashMap<>();
    m.put("userId", userId);
    m.put("regId", regId);
    return m;
  }

  @Override
  public int insertWishIfNotExists(String userId, String regId) {
    int r = 0;
    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      r = session.insert("wish.insertWishIfNotExists", param(userId, regId));
      session.commit();
    } catch (Exception e) { e.printStackTrace(); }
    return r;
  }

  @Override
  public int deleteWish(String userId, String regId) {
    int r = 0;
    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      r = session.delete("wish.deleteWish", param(userId, regId));
      session.commit();
    } catch (Exception e) { e.printStackTrace(); }
    return r;
  }

  @Override
  public int existsWish(String userId, String regId) {
    int r = 0;
    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      Integer n = session.selectOne("wish.existsWish", param(userId, regId));
      r = (n == null) ? 0 : n;
    } catch (Exception e) { e.printStackTrace(); }
    return r;
  }

  @Override
  public List<Map<String, Object>> selectWishList(String userId) {
    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      return session.selectList("wish.selectWishList", userId); // #{value}
    } catch (Exception e) { e.printStackTrace(); }
    return Collections.emptyList();
  }
}
