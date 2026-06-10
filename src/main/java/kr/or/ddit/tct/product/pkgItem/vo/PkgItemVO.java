package kr.or.ddit.tct.product.pkgItem.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class PkgItemVO {
	private int pitemNo;
	private String packageId;
	private String itemId;
	private String hotelId;
	private int	byDate;
}
