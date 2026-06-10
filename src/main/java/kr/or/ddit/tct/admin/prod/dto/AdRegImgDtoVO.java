package kr.or.ddit.tct.admin.prod.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class AdRegImgDtoVO {
	private String regId;
	private int mapNo;
	private int imgNo;
	private String imgPath;
	private String originName;
	private int viewSequence;
	private Long fileSize;	// FILE_SIZE가 NULLABLE이기에 래퍼클래스 사용(NULL값 대비) 
}
