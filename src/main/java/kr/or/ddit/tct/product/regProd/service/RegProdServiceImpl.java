package kr.or.ddit.tct.product.regProd.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.tct.product.dto.FilterSearchDto;
import kr.or.ddit.tct.product.dto.vo.RegProDtoVO;
import kr.or.ddit.tct.product.item.vo.ItemVO;
import kr.or.ddit.tct.product.regProd.dao.IregProdDao;
import kr.or.ddit.tct.product.regProd.dao.RegProdDaoImpl;

public class RegProdServiceImpl implements IregProdService{
	
	private static IregProdService service = new RegProdServiceImpl();
	private IregProdDao dao = RegProdDaoImpl.getInstance();
	
	public static IregProdService getInstance() {
		if(service==null) service = new RegProdServiceImpl();
		return service;
	}
	
	private RegProdServiceImpl() {
		
	}
	
	@Override
	public List<RegProDtoVO> selectAllForSale(FilterSearchDto param) {
		return dao.selectAllForSale(param);
	}

	@Override
	public RegProDtoVO selectDetailByRegId(String regId) {
		return dao.selectDetailByRegId(regId);
	}

	@Override
	public List<String> findCountryIdsByName(String name) {
		return dao.findCountryIdsByName(name);
	}

	@Override
	public List<String> findLocationIdsByName(String name) {
		return dao.findLocationIdsByName(name);
	}

	@Override
	public List<RegProDtoVO> selectTop5() {
		return dao.selectTop5();
	}

	@Override
	public List<ItemVO> getItemListByRegId(String regId) {
		return dao.selectItemListByRegId(regId);
	}

	@Override
	public List<String> getImgPathListByRegId(String regId) {
		return dao.selectImgPathListByRegId(regId);
	}

	@Override
	public List<Map<String, Object>> getItineraryRowsByRegId(String regId) {
	    return dao.selectItineraryRowsByRegId(regId);
	}

	@Override
	public int getReservedQtyByRegId(String regId) {
		return dao.selectReservedQtyByRegId(regId);
	}
	
}
