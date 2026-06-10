package kr.or.ddit.tct.admin.boards.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AdminBoardPostVO {

  private String postType;
  private int postNo;

  private String title;
  private String content;

  private String userId;
  private String writerName;
  private String writerRole;

  private String createdAtStr;
  private int hit;

  // QNA 전용
  private String qnaStatus;   // WAIT / DONE
  private String isNotice;    // Y / N
  private String ansCtt;
  private String ansAtStr;

  // REVIEW 전용
  private Integer reviewRating;
  private String orderNo;

  // 소프트삭제 정보
  private String delYn;
  private String delAtStr;
  private String delBy;
}
