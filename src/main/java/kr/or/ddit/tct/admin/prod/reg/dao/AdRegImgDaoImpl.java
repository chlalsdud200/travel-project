package kr.or.ddit.tct.admin.prod.reg.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import jakarta.websocket.Session;
import kr.or.ddit.tct.img.vo.ImgStorageVO;
import kr.or.ddit.tct.util.MyBatisUtil;

public class AdRegImgDaoImpl implements IAdRegImgDao {

	private static IAdRegImgDao dao;
	
	private AdRegImgDaoImpl() {
	}

	public static IAdRegImgDao getInstance() {
		if (dao == null)
			dao = new AdRegImgDaoImpl();
		return dao;
	}

	@Override
	public Map<String, Integer> selectImgNoByPaths(List<String> imgPaths) {
		if (imgPaths == null || imgPaths.isEmpty())
			return new HashMap<>();

		try (SqlSession session = MyBatisUtil.getSqlSession()) {
			List<Map<String, Object>> rows = session.selectList("adprod.selectImgNoByPaths", imgPaths);

			Map<String, Integer> map = new HashMap<>();
			for (Map<String, Object> r : rows) {
				String path = (String) r.get("IMG_PATH");
				Object noObj = r.get("IMG_NO");
				Integer imgNo = (noObj == null) ? null : ((Number) noObj).intValue();
				if (path != null && imgNo != null)
					map.put(path, imgNo);
			}
			return map;
		}
	}

	@Override
	public List<ImgStorageVO> searchFromImgStorageByPath(String imgPath) {
		try (SqlSession session = MyBatisUtil.getSqlSession()) {
			return session.selectList("adprod.searchFromImgStorageByPath", imgPath);
		}
	}

	@Override
	public int insertStorage(ImgStorageVO vo) {
		try (SqlSession session = MyBatisUtil.getSqlSession()) {
			int cnt = session.insert("adprod.insertStorage", vo);
			session.commit();
			return cnt;
		}
	}

	@Override
	public int countMapping(String regId, int imgNo) {
		Map<String, Object> p = new HashMap<>();
		p.put("regId", regId);
		p.put("imgNo", imgNo);

		try (SqlSession session = MyBatisUtil.getSqlSession()) {
			Integer n = session.selectOne("adprod.countMapping", p);
			return (n == null) ? 0 : n;
		}
	}

	@Override
	public int insertMapping(String regId, int imgNo, int viewSequence) {
		Map<String, Object> p = new HashMap<>();
		p.put("regId", regId);
		p.put("imgNo", imgNo);
		p.put("viewSequence", viewSequence);

		try (SqlSession session = MyBatisUtil.getSqlSession()) {
			int cnt = session.insert("adprod.insertMapping", p);
			session.commit();
			return cnt;
		}
	}

	@Override
	public int deleteRegImgMappingByMapNo(SqlSession session, String regId, List<Integer> mapNoList) {
		Map<String, Object> param = new HashMap<>();
		param.put("regId", regId);
		param.put("mapNoList", mapNoList);
		return session.delete("adprod.deleteRegImgMappingByMapNo", param);
	}

	@Override
	public int updateRegImgViewSequence(SqlSession session, String regId, int mapNo, int viewSequence) {
		 Map<String, Object> p = new HashMap<>();
		  p.put("regId", regId);
		  p.put("mapNo", mapNo);
		  p.put("viewSequence", viewSequence);
		  return session.update("adprod.updateRegImgViewSequence", p);
	}

}