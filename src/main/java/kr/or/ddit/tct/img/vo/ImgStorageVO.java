package kr.or.ddit.tct.img.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class ImgStorageVO {
	private int imgNo       ;
	private String imgPath     ;
	private String originName  ;
	private int fileSize    ;
}
