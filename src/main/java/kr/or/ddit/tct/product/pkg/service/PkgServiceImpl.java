package kr.or.ddit.tct.product.pkg.service;

import java.util.List;

import kr.or.ddit.tct.product.pkg.dao.IPkgDao;
import kr.or.ddit.tct.product.pkg.dao.PkgDaoImpl;
import kr.or.ddit.tct.product.pkg.vo.PkgVO;

public class PkgServiceImpl implements IPkgService {
	
	private static IPkgService service = new PkgServiceImpl();
	private IPkgDao dao = PkgDaoImpl.getInstance();
	
	public static IPkgService getInstance() {
		if(service==null) service = new PkgServiceImpl();
		return service;
	}
	
	private PkgServiceImpl() {
		
	}

	/////////////////////////////////////////////////
	
	@Override
	public List<PkgVO> listAll() {
		return dao.listAll();
	}
}
