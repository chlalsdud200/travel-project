package kr.or.ddit.tct.admin.prod.query.service;

import java.util.List;

import kr.or.ddit.tct.admin.prod.query.dao.AdPkgQueryDaoImpl;
import kr.or.ddit.tct.admin.prod.query.dao.IAdPkgQueryDao;
import kr.or.ddit.tct.product.pkg.vo.PkgVO;

public class AdPkgQueryServiceImpl implements IAdPkgQueryService {

  private static IAdPkgQueryService service;
  private final IAdPkgQueryDao dao = AdPkgQueryDaoImpl.getInstance();

  private AdPkgQueryServiceImpl() {}

  public static IAdPkgQueryService getInstance() {
    if (service == null) service = new AdPkgQueryServiceImpl();
    return service;
  }

  @Override
  public List<PkgVO> searchPkgSuggest(String q, int limit) {
    if (limit <= 0) limit = 20;
    return dao.selectPkgSuggest(q, limit);
  }
}
