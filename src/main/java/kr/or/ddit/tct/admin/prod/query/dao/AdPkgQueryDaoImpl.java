package kr.or.ddit.tct.admin.prod.query.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.product.pkg.vo.PkgVO;
import kr.or.ddit.tct.util.MyBatisUtil;

public class AdPkgQueryDaoImpl implements IAdPkgQueryDao {

  private static IAdPkgQueryDao dao;

  private AdPkgQueryDaoImpl() {}

  public static IAdPkgQueryDao getInstance() {
    if (dao == null) dao = new AdPkgQueryDaoImpl();
    return dao;
  }

  @Override
  public List<PkgVO> selectPkgSuggest(String q, int limit) {
    Map<String, Object> param = new HashMap<>();
    param.put("q", q);
    param.put("limit", limit);

    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      return session.selectList("adprod.adSelectPkgSuggest", param);
    }
  }
}
