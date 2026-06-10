package kr.or.ddit.tct.admin.prod.packageitem.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.comm.vo.CountryVO;
import kr.or.ddit.tct.comm.vo.LocVO;
import kr.or.ddit.tct.product.hotels.vo.HotelsVO;
import kr.or.ddit.tct.product.item.vo.ItemVO;
import kr.or.ddit.tct.product.pTheme.vo.PThemeVO;
import kr.or.ddit.tct.util.MyBatisUtil;

public class AdPackageDaoImpl implements IAdPackageDao {

	private static IAdPackageDao dao;

	private AdPackageDaoImpl() {
	}

	public static IAdPackageDao getInstance() {
		if (dao == null)
			dao = new AdPackageDaoImpl();
		return dao;
	}

	private static final String NS = "adPackageMapper.";

	// =========================
	// 기존 기능 (그대로 유지)
	// =========================
	@Override
	public List<LocVO> selectLocationList() {
		try (SqlSession session = MyBatisUtil.getSqlSession()) {
			return session.selectList(NS + "selectLocationList");
		}
	}

	@Override
	public List<PThemeVO> selectPThemeList() {
		try (SqlSession session = MyBatisUtil.getSqlSession()) {
			return session.selectList(NS + "selectPThemeList");
		}
	}

	@Override
	public CountryVO selectCountryByLoc(String locId) {
		if (locId == null || locId.isBlank())
			return null;

		try (SqlSession session = MyBatisUtil.getSqlSession()) {
			return selectCountryByLoc(session, locId); // ✅ 아래 신규 오버로드 재사용
		}
	}

	@Override
	public List<HotelsVO> selectHotelsByLoc(String locId) {
		if (locId == null || locId.isBlank())
			return List.of();

		try (SqlSession session = MyBatisUtil.getSqlSession()) {
			return session.selectList(NS + "selectHotelsByLoc", locId);
		}
	}

	@Override
	public String selectNextPackageNo(String prefix) {
		if (prefix == null || prefix.isBlank())
			return null;

		try (SqlSession session = MyBatisUtil.getSqlSession()) {
			return selectNextPackageNo(session, prefix); // ✅ 아래 신규 오버로드 재사용
		}
	}

	@Override
	public int insertPackage(Map<String, Object> param) {
		if (param == null)
			return 0;

		try (SqlSession session = MyBatisUtil.getSqlSession()) {
			int cnt = insertPackage(session, param); // ✅ 아래 신규 오버로드 재사용
			session.commit(); // (기존 기능 유지)
			return cnt;
		}
	}

	// =========================
	// ✅ 신규 추가: 트랜잭션(session 주입)용 오버로드들
	// - Service에서 autoCommit=false session 하나로 묶을 때 사용
	// =========================

	// (1) 국가 조회 - session 주입 버전
	@Override
	public CountryVO selectCountryByLoc(SqlSession session, String locId) {
		if (session == null)
			throw new IllegalArgumentException("session is null");
		if (locId == null || locId.isBlank())
			return null;

		Map<String, Object> p = new HashMap<>();
		p.put("locId", locId);
		return session.selectOne(NS + "selectCountryByLoc", p);
	}

	// (2) next package no - session 주입 버전
	@Override
	public String selectNextPackageNo(SqlSession session, String prefix) {
		if (session == null)
			throw new IllegalArgumentException("session is null");
		if (prefix == null || prefix.isBlank())
			return null;

		Map<String, Object> p = new HashMap<>();
		p.put("prefix", prefix);
		return session.selectOne(NS + "selectNextPackageNo", p);
	}

	// (3) packages insert - session 주입 버전 (commit은 Service가 함!)
	@Override
	public int insertPackage(SqlSession session, Map<String, Object> param) {
		if (session == null)
			throw new IllegalArgumentException("session is null");
		if (param == null)
			return 0;

		return session.insert(NS + "insertPackage", param);
	}

//(4) ✅ package_item 여러건 insert - A안(단건 insert를 루프)
	@Override
	public int insertPackageItems(SqlSession session, String pkgId, List<Map<String, Object>> items) {
		if (session == null)
			throw new IllegalArgumentException("session is null");
		if (pkgId == null || pkgId.isBlank())
			throw new IllegalArgumentException("pkgId is blank");
		if (items == null || items.isEmpty())
			return 0;

		int cnt = 0;

		for (Map<String, Object> it : items) {
			if (it == null)
				continue;

			// Gson으로 들어오면 숫자는 Double로 오는 경우가 많아서 String.valueOf로 통일
			String itemId = (it.get("itemId") == null) ? "" : String.valueOf(it.get("itemId")).trim();
			String hotelId = (it.get("hotelId") == null) ? null : String.valueOf(it.get("hotelId")).trim();
			if (hotelId != null && hotelId.isBlank())
				hotelId = null;

			String byDate = (it.get("byDate") == null) ? "" : String.valueOf(it.get("byDate")).trim();

			if (itemId.isBlank())
				throw new IllegalArgumentException("itemId is blank");
			if (byDate.isBlank())
				throw new IllegalArgumentException("byDate is blank");

			Map<String, Object> p = new HashMap<>();
			p.put("pkgId", pkgId);
			p.put("itemId", itemId);
			p.put("hotelId", hotelId); // nullable
			p.put("byDate", byDate); // DB가 VARCHAR2라 String로

			// ✅ 여기서 foreach 배치(insertPackageItems) 절대 호출하지 말고,
			// 단건 insertPackageItem만 반복 호출
			cnt += session.insert(NS + "insertPackageItem", p);
		}

		return cnt;
	}

	@Override
	public List<ItemVO> selectItemList(String keyword, int limit) {
		if (limit <= 0)
			limit = 30;

		try (SqlSession session = MyBatisUtil.getSqlSession()) {
			Map<String, Object> p = new HashMap<>();
			p.put("keyword", keyword == null ? "" : keyword.trim());
			p.put("limit", limit);
			return session.selectList(NS + "selectItemList", p);
		}
	}

}
