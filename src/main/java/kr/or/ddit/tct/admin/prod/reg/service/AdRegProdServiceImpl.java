package kr.or.ddit.tct.admin.prod.reg.service;

import java.util.List;

import kr.or.ddit.tct.admin.prod.dto.AdRegImgDtoVO;
import kr.or.ddit.tct.admin.prod.reg.dao.AdRegProdDaoImpl;
import kr.or.ddit.tct.admin.prod.reg.dao.IAdRegProdDao;
import kr.or.ddit.tct.product.regProd.vo.RegProdVO;

public class AdRegProdServiceImpl implements IAdRegProdService{
	private static IAdRegProdDao dao = AdRegProdDaoImpl.getInstance();
	private static IAdRegProdService service = new AdRegProdServiceImpl();
	
	private AdRegProdServiceImpl() {
		
	}
	
	public static IAdRegProdService getInstance() {
		if(service == null) service = new AdRegProdServiceImpl();
		return service;
	}

	@Override
	public List<RegProdVO> adSelectRegProdAll() {
		return dao.adSelectRegProdAll();
	}

	@Override
	public List<AdRegImgDtoVO> adSelectAdRegImg(String regId) {
		return dao.adSelectAdRegImg(regId);
	}
	
	@Override
	public String createRegProd(RegProdVO vo) {
	  return dao.insertRegProd(vo);
	}

	@Override
	public int updateRegProd(RegProdVO vo) {
	    return dao.updateRegProd(vo);
	}

	
}
