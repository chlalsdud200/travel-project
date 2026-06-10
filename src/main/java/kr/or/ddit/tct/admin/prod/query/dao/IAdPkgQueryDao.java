package kr.or.ddit.tct.admin.prod.query.dao;

import java.util.List;
import kr.or.ddit.tct.product.pkg.vo.PkgVO;

public interface IAdPkgQueryDao {
  List<PkgVO> selectPkgSuggest(String q, int limit);
}
