package kr.or.ddit.tct.admin.prod.query.service;

import java.util.List;
import kr.or.ddit.tct.product.pkg.vo.PkgVO;

public interface IAdPkgQueryService {
  List<PkgVO> searchPkgSuggest(String q, int limit);
}
