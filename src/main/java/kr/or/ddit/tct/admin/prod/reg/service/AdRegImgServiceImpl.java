package kr.or.ddit.tct.admin.prod.reg.service;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.ibatis.session.SqlSession;

import jakarta.servlet.ServletContext;
import kr.or.ddit.tct.admin.prod.dto.AdRegImgPoolItemDto;
import kr.or.ddit.tct.admin.prod.reg.dao.AdRegImgDaoImpl;
import kr.or.ddit.tct.admin.prod.reg.dao.IAdRegImgDao;
import kr.or.ddit.tct.comm.dto.CommonApi;
import kr.or.ddit.tct.img.vo.ImgStorageVO;
import kr.or.ddit.tct.util.MyBatisUtil;

public class AdRegImgServiceImpl implements IAdRegImgService {

	private static IAdRegImgService instance;
	private final IAdRegImgDao dao = AdRegImgDaoImpl.getInstance();

	private AdRegImgServiceImpl() {
	}

	public static IAdRegImgService getInstance() {
		if (instance == null)
			instance = new AdRegImgServiceImpl();
		return instance;
	}

	// Controller에서 realDir 넘겨주는 방식으로 가도 되는데,
	// 여기선 Controller에서 folder 검증/realPath 구해서 파일목록 만들고 Service는 DB 비교만 해도 OK.
	// (이번엔 Service가 DB 비교/마킹만 담당하도록 Controller에서 파일목록을 만든다)
	@Override
	public List<AdRegImgPoolItemDto> getImgPool(String folder) {
		return new ArrayList<>();
	}

	public void markRegistered(List<AdRegImgPoolItemDto> items) {
		if (items == null || items.isEmpty())
			return;

		List<String> paths = new ArrayList<>();
		for (AdRegImgPoolItemDto it : items) {
			if (it.getImgPath() != null)
				paths.add(it.getImgPath());
		}

		Map<String, Integer> map = dao.selectImgNoByPaths(paths);
		for (AdRegImgPoolItemDto it : items) {
			Integer imgNo = map.get(it.getImgPath());
			if (imgNo != null) {
				it.setRegistered(true);
				it.setImgNo(imgNo);
			} else {
				it.setRegistered(false);
				it.setImgNo(null);
			}
		}
	}

	public static boolean isImageFile(String name) {
		if (name == null)
			return false;
		String lower = name.toLowerCase();
		return lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png") || lower.endsWith(".gif")
				|| lower.endsWith(".webp");
	}

	@Override
	public CommonApi<?> applyRegImg(String regId, String imgPath, Integer viewSequence, String originName,
			ServletContext sctx) {

		// ===== 0) validate =====
		if (regId == null || regId.isBlank()) {
			return CommonApi.fail("regId가 없습니다.");
		}
		if (imgPath == null || imgPath.isBlank()) {
			return CommonApi.fail("imgPath가 없습니다.");
		}

		// imgPath는 DB 규칙상 "/upload_img/..." 웹경로만 저장한다고 했으니 방어
		if (!imgPath.startsWith("/upload_img/")) {
			return CommonApi.fail("허용되지 않은 이미지 경로입니다.");
		}

		int seq = (viewSequence == null || viewSequence <= 0) ? 1 : viewSequence;

		// ===== 1) IMG_STORAGE 존재 확인 (imgPath 기준) =====
		ImgStorageVO st = null;
		List<ImgStorageVO> stList = dao.searchFromImgStorageByPath(imgPath);
		if (stList != null && !stList.isEmpty()) {
			st = stList.get(0);
		}

		boolean storageInserted = false;
		Integer imgNo = null;

		if (st == null) {
			// ===== 2) 없으면 IMG_STORAGE insert =====
			String on = (originName != null && !originName.isBlank()) ? originName : extractFileName(imgPath);

			int fileSize = 0;
			try {
				// web path -> real path
				String real = (sctx != null) ? sctx.getRealPath(imgPath) : null;
				if (real != null) {
					File f = new File(real);
					if (f.exists() && f.isFile())
						fileSize = (int) f.length();
				}
			} catch (Exception ignore) {
			}

			ImgStorageVO vo = new ImgStorageVO();
			vo.setImgPath(imgPath);
			vo.setOriginName(on);
			vo.setFileSize(fileSize);

			int ins = dao.insertStorage(vo);
			if (ins <= 0) {
				// insert 실패
				return CommonApi.fail("IMG_STORAGE 등록 실패");
			}

			// insert 이후 다시 조회해서 imgNo 확보 (selectKey를 썼다면 vo.getImgNo()로도 가능하지만, 확실히 다시 조회)
			List<ImgStorageVO> again = dao.searchFromImgStorageByPath(imgPath);
			if (again == null || again.isEmpty()) {
				return CommonApi.fail("IMG_STORAGE는 등록됐지만 IMG_NO 조회 실패");
			}
			imgNo = again.get(0).getImgNo();
			storageInserted = true;

		} else {
			imgNo = st.getImgNo();
		}

//		if (imgNo == null) {
//			return CommonApi.fail("IMG_NO를 확인할 수 없습니다.");
//		}

		// ===== 3) IMG_MAPPING 중복 방지 =====
		int exists = dao.countMapping(regId, imgNo);
		if (exists > 0) {
			return CommonApi.fail("이미 해당 상품에 매핑된 이미지입니다.");
		}

		// ===== 4) IMG_MAPPING insert =====
		int m = dao.insertMapping(regId, imgNo, seq);
		if (m <= 0) {
			// 여기서 storageInserted=true인 경우 storage만 남는 리스크는 있음(DAO가 세션 분리라서)
			// 근데 기능적으로는 "매핑 실패"를 알려주면 되고, 나중에 트랜잭션 리팩토링하면 완벽해짐.
			return CommonApi.fail("IMG_MAPPING 등록 실패");
		}

		String msg = storageInserted ? "스토리지 등록 후 매핑 완료" : "기존 스토리지 사용, 매핑 완료";

		return CommonApi.ok(msg);
	}

	private static String extractFileName(String path) {
		if (path == null)
			return "";
		String clean = String.valueOf(path).split("\\?")[0]; // query 제거
		int idx = clean.lastIndexOf('/');
		return (idx >= 0) ? clean.substring(idx + 1) : clean;
	}

	@Override
	public int deleteRegImgMappingByMapNo(String regId, List<Integer> mapNoList) {
		SqlSession session = null;
		try {
			session = MyBatisUtil.getSqlSession();
			int cnt = dao.deleteRegImgMappingByMapNo(session, regId, mapNoList);
			session.commit();
			return cnt;
		} catch (Exception e) {
			if (session != null)
				session.rollback();
			throw e;
		} finally {
			if (session != null)
				session.close();
		}
	}

	@Override
	public int updateRegImgViewSequence(String regId, int mapNo, int viewSequence) {
		SqlSession session = null;
		try {
			session = MyBatisUtil.getSqlSession();
			int cnt = dao.updateRegImgViewSequence(session, regId, mapNo, viewSequence);
			session.commit();
			return cnt;
		} catch (Exception e) {
			if (session != null)
				session.rollback();
			throw e;
		} finally {
			if (session != null)
				session.close();
		}
	}
	
}
