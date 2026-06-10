package kr.or.ddit.tct.product.regProd.dao;

import java.util.List;
import java.util.Map;

import kr.or.ddit.tct.product.dto.MainSearchDto;
import kr.or.ddit.tct.product.dto.vo.RegProDtoVO;
import kr.or.ddit.tct.product.item.vo.ItemVO;

public interface IregProdDao {
	
	// 판매중인 등록상품 리스트
	public List<RegProDtoVO> selectAllForSale(MainSearchDto param);
	// 등록상품 상세
	public RegProDtoVO selectDetailByRegId(String regId);
	List<Map<String, Object>> selectItineraryRowsByRegId(String regId);
	
	List<String> findCountryIdsByName(String name);
	List<String> findLocationIdsByName(String name);
	List<RegProDtoVO> selectTop5();
	List<ItemVO> selectItemListByRegId(String regId);
	List<String> selectImgPathListByRegId(String regId);
	int selectReservedQtyByRegId(String regId);

}
