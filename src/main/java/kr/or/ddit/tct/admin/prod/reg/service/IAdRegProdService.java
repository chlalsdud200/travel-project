package kr.or.ddit.tct.admin.prod.reg.service;

import java.util.List;

import kr.or.ddit.tct.admin.prod.dto.AdRegImgDtoVO;
import kr.or.ddit.tct.product.regProd.vo.RegProdVO;

public interface IAdRegProdService {
	
	public List<RegProdVO> adSelectRegProdAll();

	public List<AdRegImgDtoVO> adSelectAdRegImg(String regId);
    
	public String createRegProd(RegProdVO vo);
	
	public int updateRegProd(RegProdVO vo);
}
