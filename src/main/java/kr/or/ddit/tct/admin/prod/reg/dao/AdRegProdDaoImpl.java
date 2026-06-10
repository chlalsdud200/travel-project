package kr.or.ddit.tct.admin.prod.reg.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.admin.prod.dto.AdRegImgDtoVO;
import kr.or.ddit.tct.product.regProd.vo.RegProdVO;
import kr.or.ddit.tct.util.MyBatisUtil;

public class AdRegProdDaoImpl implements IAdRegProdDao {
	private static IAdRegProdDao dao = new AdRegProdDaoImpl();

	private AdRegProdDaoImpl() {

	}

	public static IAdRegProdDao getInstance() {
		if (dao == null)
			dao = new AdRegProdDaoImpl();
		return dao;
	}

	@Override
	public List<RegProdVO> adSelectRegProdAll() {
		List<RegProdVO> list = null;

		try (SqlSession session = MyBatisUtil.getSqlSession()) {

			list = session.selectList("adprod.adSelectRegProdAll");

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	@Override
	public List<AdRegImgDtoVO> adSelectAdRegImg(String regId) {
		List<AdRegImgDtoVO> imgList = null;

		try (SqlSession session = MyBatisUtil.getSqlSession()) {

			imgList = session.selectList("adprod.adSelectAdRegImg", regId);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return imgList;
	}

	@Override
	public String insertRegProd(RegProdVO vo) {
		try (SqlSession session = MyBatisUtil.getSqlSession()) {
			session.insert("adprod.adInsertRegProd", vo);
			session.commit();
			return vo.getRegId(); // selectKey로 채워짐
		}
	}

	@Override
	public int updateRegProd(RegProdVO vo) {
		try (SqlSession session = MyBatisUtil.getSqlSession()) {
		      int cnt = session.update("adprod.adUpdateRegProd", vo);
		      if (cnt > 0) session.commit();
		      return cnt;
		}
	}
	
}
