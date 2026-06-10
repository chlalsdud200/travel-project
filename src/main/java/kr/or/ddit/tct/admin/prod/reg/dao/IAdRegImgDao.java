package kr.or.ddit.tct.admin.prod.reg.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.img.vo.ImgStorageVO;

public interface IAdRegImgDao {
	// key: IMG_PATH, value: IMG_NO
	public Map<String, Integer> selectImgNoByPaths(List<String> imgPaths);

	public List<ImgStorageVO> searchFromImgStorageByPath(String imgPath);

	public int insertStorage(ImgStorageVO vo);
	
	public int countMapping(String regId, int imgNo);
	
	public int insertMapping(String regId, int imgNo, int viewSequence);
	
	public int deleteRegImgMappingByMapNo(SqlSession session, String regId, List<Integer> mapNoList);
	
	public int updateRegImgViewSequence(SqlSession session, String regId, int mapNo, int viewSequence);
}
