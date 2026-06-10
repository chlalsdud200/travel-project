package kr.or.ddit.tct.board.review.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data

public class ReviewBoardVO {

	private int reviewHit; /* 조회수 */
	private int reviewNo; /* 리뷰번호 */
	private String userId; /* 사용자ID */
	private String orderNo; /*  */
	private int reviewRating; /* 리뷰별점 */
	private String reviewCtt; /* 리뷰내용 */
	private String reviewCreated; /* 작성날짜 */
	private String reviewUpdate; /* 수정날짜 */
	private String reviewTitle; /* 리뷰제목 */
	
	private String regTitle;        // 상품명
	private String reviewCreatedStr; // 화면용 문자열(yyyy-MM-dd)

	
}
