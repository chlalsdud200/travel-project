package kr.or.ddit.tct.admin.prod.packageitem.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.admin.prod.packageitem.dao.AdPackageDaoImpl;
import kr.or.ddit.tct.admin.prod.packageitem.dao.IAdPackageDao;
import kr.or.ddit.tct.comm.vo.CountryVO;
import kr.or.ddit.tct.comm.vo.LocVO;
import kr.or.ddit.tct.product.hotels.vo.HotelsVO;
import kr.or.ddit.tct.product.item.vo.ItemVO;
import kr.or.ddit.tct.product.pTheme.vo.PThemeVO;
import kr.or.ddit.tct.util.MyBatisUtil;

public class AdPackageServiceImpl implements IAdPackageService {

  private static IAdPackageService service;
  private final IAdPackageDao dao = AdPackageDaoImpl.getInstance();

  private AdPackageServiceImpl() {}

  public static IAdPackageService getInstance() {
    if (service == null) service = new AdPackageServiceImpl();
    return service;
  }

  @Override
  public List<LocVO> getLocationList() {
    return dao.selectLocationList();
  }

  @Override
  public List<PThemeVO> getPThemeList() {
    return dao.selectPThemeList();
  }

  @Override
  public CountryVO getCountryByLoc(String locId) {
    return dao.selectCountryByLoc(locId);
  }

  @Override
  public List<HotelsVO> getHotelsByLoc(String locId) {
    return dao.selectHotelsByLoc(locId);
  }

  @Override
  public String getNextPkgId(String locId, String themeId) {
    if (locId == null || locId.isBlank() || themeId == null || themeId.isBlank()) return null;

    CountryVO c = dao.selectCountryByLoc(locId);
    if (c == null || c.getCtryId() == null || c.getCtryId().isBlank()) return null;

    String prefix = c.getCtryId() + locId + themeId;

    String nextNo = dao.selectNextPackageNo(prefix);
    if (nextNo == null || nextNo.isBlank()) nextNo = "01";

    return prefix + nextNo;
  }

  @Override
  public String createPackage(String packageTitle, String locId, String themeId) {
    if (packageTitle == null || packageTitle.isBlank()) return null;

    CountryVO c = dao.selectCountryByLoc(locId);
    if (c == null || c.getCtryId() == null || c.getCtryId().isBlank()) return null;

    String pkgId = getNextPkgId(locId, themeId);
    if (pkgId == null || pkgId.isBlank()) return null;

    Map<String, Object> param = new HashMap<>();
    param.put("pkgId", pkgId);
    param.put("packageTitle", packageTitle);
    param.put("ctryId", c.getCtryId());
    param.put("themeId", themeId);
    param.put("locId", locId);

    int cnt = dao.insertPackage(param);
    return cnt > 0 ? pkgId : null;
  }

  // ==========================================================
  // ✅ 신규 추가: PACKAGES + PACKAGE_ITEM "한 번에 저장" (트랜잭션)
  // - 기존 기능은 건들지 않음
  // - UI에서는 앞으로 이 메서드만 호출하면 됨
  // ==========================================================
  @Override
  public String createPackageWithItems(String packageTitle, String locId, String themeId,
                                      List<Map<String, Object>> items) {

    if (packageTitle == null || packageTitle.isBlank()) {
      throw new IllegalArgumentException("패키지명을 입력해주세요.");
    }
    if (locId == null || locId.isBlank()) {
      throw new IllegalArgumentException("지역을 선택해주세요.");
    }
    if (themeId == null || themeId.isBlank()) {
      throw new IllegalArgumentException("메인 테마를 선택해주세요.");
    }
    if (items == null || items.isEmpty()) {
      throw new IllegalArgumentException("패키지 구성(아이템)을 1개 이상 입력해주세요.");
    }

    SqlSession session = null;
    try {
      // ✅ 한 트랜잭션으로 묶기 위해 autoCommit=false
      session = MyBatisUtil.getSqlSession(false);

      // 1) locId로 국가 조회 (같은 session 사용)
      CountryVO c = dao.selectCountryByLoc(session, locId);
      if (c == null || c.getCtryId() == null || c.getCtryId().isBlank()) {
        throw new IllegalStateException("국가 조회 실패");
      }

      // 2) pkgId 생성 (같은 session 사용)
      String prefix = c.getCtryId() + locId + themeId;
      String nextNo = dao.selectNextPackageNo(session, prefix);
      if (nextNo == null || nextNo.isBlank()) nextNo = "01";
      String pkgId = prefix + nextNo;

      // 3) PACKAGES insert (commit은 여기서 안 함)
      Map<String, Object> p = new HashMap<>();
      p.put("pkgId", pkgId);
      p.put("packageTitle", packageTitle);
      p.put("ctryId", c.getCtryId());
      p.put("themeId", themeId);
      p.put("locId", locId);

      dao.insertPackage(session, p);

      // 4) PACKAGE_ITEM insert (여러 건)
      // items 원소는 반드시 {"byDate":1, "hotelId":"..", "itemId":".."} 키를 가져야 함
      // byDate는 number(여정순서)
      dao.insertPackageItems(session, pkgId, items);

      // 5) 전부 성공하면 commit
      session.commit();
      return pkgId;

    } catch (Exception e) {
      if (session != null) session.rollback();
      throw new RuntimeException(e);
    } finally {
      if (session != null) session.close();
    }
  }
  
  @Override
  public List<ItemVO> getItemList(String keyword, int limit) {
    return dao.selectItemList(keyword, limit);
  }

}
