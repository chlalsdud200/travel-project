package kr.or.ddit.tct.board.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SearchVO {
	  private int page;
	  private String stype;
	  private String sword;
}
