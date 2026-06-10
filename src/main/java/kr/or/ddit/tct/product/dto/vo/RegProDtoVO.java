package kr.or.ddit.tct.product.dto.vo;

import java.time.LocalDate;
import java.util.List;

import kr.or.ddit.tct.comm.vo.CountryVO;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class RegProDtoVO {
	private String regId;
	private String pkgId;
	private String regTitle;
	private LocalDate regDate;
	private int regPrice;
	private int regQty;
	private String forSale;
	private LocalDate startDt;
	private LocalDate endDt;
	private LocalDate saleStartDt;
	private LocalDate saleEndDt;
	private String highlight;
	private String descriptionA;
	private String descriptionB;
	private String ctryName;
	private String locName;
	private String imgPath;
	private String originName;
	private String themeId;
	
	//regProDtdVO : countryVO = 1 : N
	private List<CountryVO> countryVOList;
}
