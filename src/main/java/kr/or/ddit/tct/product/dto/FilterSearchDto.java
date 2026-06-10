package kr.or.ddit.tct.product.dto;

import java.util.List;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class FilterSearchDto extends MainSearchDto {
	private String destination;
	private String startDate;
	private String endDate;
	
	private List<String> themeIds;
	
	private Integer minPrice; 
	private Integer maxPrice;
	
	private List<String> ctryIds;
	private List<String> locIds;
	
    public Integer getMinPriceWon() {
        return (minPrice == null) ? null : minPrice * 10000;
    }

    public Integer getMaxPriceWon() {
        return (maxPrice == null) ? null : maxPrice * 10000;
    }
}
