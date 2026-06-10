package kr.or.ddit.tct.admin.prod.packageitem.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.admin.prod.packageitem.dao.AdPackageItemDaoImpl;
import kr.or.ddit.tct.admin.prod.packageitem.dao.IAdPackageItemDao;
import kr.or.ddit.tct.admin.prod.packageitem.dto.HotelSearchDto;
import kr.or.ddit.tct.util.MyBatisUtil;

public class AdPackageItemServiceImpl implements IAdPackageItemService {

  private static IAdPackageItemService service;
  private final IAdPackageItemDao dao = AdPackageItemDaoImpl.getInstance();

  private AdPackageItemServiceImpl() {}

  public static IAdPackageItemService getInstance() {
    if (service == null) service = new AdPackageItemServiceImpl();
    return service;
  }

  @Override
  public List<HotelSearchDto> searchHotels(String keyword, int limit) {

    // 🔒 정책 넣고 싶으면 여기서
    // 예: keyword 1글자 이하면 빈 리스트
    // if(keyword != null && keyword.trim().length() < 2) return List.of();

    return dao.searchHotels(keyword, limit);
  }
  

  @Override
  public String createPackageWithItems(String packageTitle, String locId, String themeId, List<Map<String, Object>> items) {

    if (packageTitle == null || packageTitle.isBlank()) throw new IllegalArgumentException("packageTitle is blank");
    if (locId == null || locId.isBlank()) throw new IllegalArgumentException("locId is blank");
    if (themeId == null || themeId.isBlank()) throw new IllegalArgumentException("themeId is blank");
    if (items == null || items.isEmpty()) throw new IllegalArgumentException("items is empty");

    // ✅ 트랜잭션: packages + package_item
    // MyBatisUtil.getSqlSession(false) 형태가 너 프로젝트에 없다면,
    // MyBatisUtil.getSqlSession()로 열고 session.commit/rollback 가능한지 확인 필요.
    try (SqlSession session = MyBatisUtil.getSqlSession(false)) {

      // 1) locId -> ctryId 조회
      Map<String, Object> p1 = new HashMap<>();
      p1.put("locId", locId);

      // 너 매퍼는 resultType이 CountryVO라서 객체로 나올 수도 있음.
      // 그런데 컨트롤러에서 Map으로 처리하길 원하면, 매퍼를 resultType="map"으로 바꾸는게 가장 편함.
      // 일단은 Map으로 받는 방식으로 통일.
      @SuppressWarnings("unchecked")
      Map<String, Object> country = session.selectOne("adPackageMapper.selectCountryByLoc", p1);

      if (country == null || country.get("ctryId") == null) {
        session.rollback();
        throw new RuntimeException("국가 조회 실패(locId=" + locId + ")");
      }
      String ctryId = String.valueOf(country.get("ctryId")).trim();

      // 2) prefix로 nextNo 구해서 pkgId 생성
      String prefix = (ctryId + locId + themeId).trim();

      Map<String, Object> p2 = new HashMap<>();
      p2.put("prefix", prefix);

      String nextNo = session.selectOne("adPackageMapper.selectNextPackageNo", p2);
      if (nextNo == null || nextNo.isBlank()) {
        session.rollback();
        throw new RuntimeException("패키지 번호 생성 실패(prefix=" + prefix + ")");
      }

      String pkgId = prefix + nextNo;

      // 3) packages insert
      Map<String, Object> p3 = new HashMap<>();
      p3.put("pkgId", pkgId);
      p3.put("packageTitle", packageTitle);
      p3.put("ctryId", ctryId);
      p3.put("themeId", themeId);
      p3.put("locId", locId);

      int pkgIns = session.insert("adPackageMapper.insertPackage", p3);
      if (pkgIns != 1) {
        session.rollback();
        throw new RuntimeException("패키지 저장 실패(pkgId=" + pkgId + ")");
      }

      // 4) package_item N건 insert (A안: 단건 insert를 루프)
      int cnt = 0;
      for (Map<String, Object> it : items) {
        String itemId = it.get("itemId") == null ? "" : String.valueOf(it.get("itemId")).trim();
        String hotelId = it.get("hotelId") == null ? null : String.valueOf(it.get("hotelId")).trim();
        if (hotelId != null && hotelId.isBlank()) hotelId = null;

        // byDate는 VARCHAR2 라서 문자열 저장 권장
        String byDate = it.get("byDate") == null ? "" : String.valueOf(it.get("byDate")).trim();
        if (byDate.isBlank()) {
          session.rollback();
          throw new RuntimeException("byDate is blank");
        }

        if (itemId.isBlank()) {
          session.rollback();
          throw new RuntimeException("itemId is blank");
        }

        Map<String, Object> p = new HashMap<>();
        p.put("pkgId", pkgId);
        p.put("itemId", itemId);
        p.put("hotelId", hotelId); // nullable
        p.put("byDate", byDate);   

        cnt += session.insert("adPackageMapper.insertPackageItem", p);
      }

      if (cnt <= 0) {
        session.rollback();
        throw new RuntimeException("패키지아이템 저장 실패(pkgId=" + pkgId + ")");
      }

      session.commit();
      return pkgId;

    } catch (Exception e) {
      // 바깥 컨트롤러에서 500 처리하도록 메시지 넘김
      throw new RuntimeException(e.getMessage(), e);
    }
  }
}
