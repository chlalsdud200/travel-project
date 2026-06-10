package kr.or.ddit.tct.product.item.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class ItemVO {
	private String itemId;
	private String itemTitle;
	private String locId;
	private String themeId;
	private String imgPath; 
}
