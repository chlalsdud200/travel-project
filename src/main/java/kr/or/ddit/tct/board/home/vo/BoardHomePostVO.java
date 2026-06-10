package kr.or.ddit.tct.board.home.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * BoardHomePostVO (bhvo)
 * - 홈 화면에서 공지/문의/리뷰를 "같은 모양"으로 뿌리기 위한 통합 VO
 *
 * postType   : 글 종류("NOTICE" | "QNA" | "REVIEW")
 * postNo     : 글 번호(QNA_NO or REVIEW_NO)
 * viewNo     : 화면용 번호(삭제 시 당겨지는 번호)
 * title      : 제목(QNA_TITLE or REVIEW_TITLE)
 * userId     : 작성자 ID
 * writerName : 작성자 이름(USERS.USER_NAME)  -> 서버에서 (비관리자면 ADMIN 작성글은 "관리자"로) 마스킹 처리
 * writerRole : 작성자 권한(USERS.ROLE)       -> 프론트에서 ADMIN 글 표시(빨간색 등) 판단 근거
 * createdAt  : 작성일(문자열)
 * hit        : 조회수
 */

@Data
@AllArgsConstructor
@NoArgsConstructor
public class BoardHomePostVO {

  private String postType;
  private long postNo;
  private int viewNo;

  private String title;

  private String userId;
  private String writerName;

  private String writerRole; // ✅ 추가(ADMIN 글을 마스킹/스타일링하기 위한 근거)

  private String createdAt;

  private int hit;

 
}
