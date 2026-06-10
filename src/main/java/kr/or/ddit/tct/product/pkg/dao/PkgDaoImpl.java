package kr.or.ddit.tct.product.pkg.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.product.pkg.vo.PkgVO;
import kr.or.ddit.tct.util.MyBatisUtil;

public class PkgDaoImpl implements IPkgDao {

	private static IPkgDao dao = new PkgDaoImpl();
	
	static public IPkgDao getInstance() {
		if(dao==null) dao = new PkgDaoImpl();
		return dao;
	}
	
	private PkgDaoImpl() {
		
	}

	@Override
	public List<PkgVO> listAll() {
		List<PkgVO> vo = null;
		
		try(SqlSession sqlSession = MyBatisUtil.getSqlSession()){
			
			 vo = sqlSession.selectList("pkg.listAll");
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		return vo;
	}

}
