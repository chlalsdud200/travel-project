package kr.or.ddit.tct.admin.prod.item.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ItemVO {

	private String itemId; /* 아이템코드 */
	private String itemTitle; /* 아이템명 */
	private String locId; /* 지역코드 */
	private String themeId; /* 테마패키지코 */
	
}
