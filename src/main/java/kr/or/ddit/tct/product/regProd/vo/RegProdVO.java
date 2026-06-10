package kr.or.ddit.tct.product.regProd.vo;

import java.time.LocalDate;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class RegProdVO {
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
}
