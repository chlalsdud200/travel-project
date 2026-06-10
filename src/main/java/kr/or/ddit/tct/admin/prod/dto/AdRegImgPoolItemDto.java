package kr.or.ddit.tct.admin.prod.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class AdRegImgPoolItemDto {
  private String fileName;
  private String imgPath;     // web path: /upload_img/reg_img/xxx.jpg
  private boolean registered; // IMG_STORAGE에 존재하면 true
  private Integer imgNo;      // 존재하면 imgNo
}
