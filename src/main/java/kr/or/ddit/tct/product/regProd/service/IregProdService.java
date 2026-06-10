package kr.or.ddit.tct.product.regProd.service;

import java.util.List;
import java.util.Map;
import java.util.Map;

import kr.or.ddit.tct.product.dto.FilterSearchDto;
import kr.or.ddit.tct.product.dto.vo.RegProDtoVO;
import kr.or.ddit.tct.product.item.vo.ItemVO;

public interface IregProdService {
	
	public List<RegProDtoVO> selectAllForSale(FilterSearchDto param);
	public RegProDtoVO selectDetailByRegId(String regId);
	List<Map<String, Object>> getItineraryRowsByRegId(String regId);
	
	List<String> findCountryIdsByName(String name);
	List<String> findLocationIdsByName(String name);
	List<RegProDtoVO> selectTop5();
	List<ItemVO> getItemListByRegId(String regId);
	List<String> getImgPathListByRegId(String regId);
	
	int getReservedQtyByRegId(String regId);

}
