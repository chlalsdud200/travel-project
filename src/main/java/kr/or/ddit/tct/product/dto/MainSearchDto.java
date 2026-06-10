package kr.or.ddit.tct.product.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class MainSearchDto {
	private String keyword;
	private String sort;
	private String filter;
}
