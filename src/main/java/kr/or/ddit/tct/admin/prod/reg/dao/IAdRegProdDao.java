package kr.or.ddit.tct.admin.prod.reg.dao;

import java.util.List;

import kr.or.ddit.tct.admin.prod.dto.AdRegImgDtoVO;
import kr.or.ddit.tct.product.regProd.vo.RegProdVO;

public interface IAdRegProdDao {

	public List<RegProdVO> adSelectRegProdAll();
	
	public List<AdRegImgDtoVO> adSelectAdRegImg(String regId);
	
	public String insertRegProd(RegProdVO vo);
	
	public int updateRegProd(RegProdVO vo);

}
