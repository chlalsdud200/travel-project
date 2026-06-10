package kr.or.ddit.tct.board.reply.vo;

/**
 * QNA 댓글 VO
 * 테이블: REPLY
 */
public class ReplyVO {
   
	private int reNum;           // 댓글번호 (RE_NUM)
	private String userId;       // 사용자ID (USER_ID)
	private int qnaNo;           // 문의번호 (QNA_NO)
	private int reviewNo;        // 리뷰번호 (REVIEW_NO)
	private int parentReNum;     // 대댓글번호 (PARENT_RE_NUM)
	private String reCtt;        // 댓글내용 (RE_CTT)
	private String reCreate;     // 작성날짜 (RE_CREATE)
	private String reUpdate;     // 수정날짜 (RE_UPDATE)
	
	private String writerRole;
	private String writerName;

	
	


	// Getter & Setter
	public String getWriterName() { return writerName; }
	public void setWriterName(String writerName) { this.writerName = writerName; }
	
	public String getWriterRole() { 
		return writerRole; 
	}
	
	public void setWriterRole(String writerRole) { 
		this.writerRole = writerRole; 
	}
	
	public int getReNum() {
		return reNum;
	}
	
	public void setReNum(int reNum) {
		this.reNum = reNum;
	}
	
	public String getUserId() {
		return userId;
	}
	
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	public int getQnaNo() {
		return qnaNo;
	}
	
	public void setQnaNo(int qnaNo) {
		this.qnaNo = qnaNo;
	}
	
	public int getReviewNo() {
		return reviewNo;
	}
	
	public void setReviewNo(int reviewNo) {
		this.reviewNo = reviewNo;
	}
	
	public int getParentReNum() {
		return parentReNum;
	}
	
	public void setParentReNum(int parentReNum) {
		this.parentReNum = parentReNum;
	}
	
	public String getReCtt() {
		return reCtt;
	}
	
	public void setReCtt(String reCtt) {
		this.reCtt = reCtt;
	}
	
	public String getReCreate() {
		return reCreate;
	}
	
	public void setReCreate(String reCreate) {
		this.reCreate = reCreate;
	}
	
	public String getReUpdate() {
		return reUpdate;
	}
	
	public void setReUpdate(String reUpdate) {
		this.reUpdate = reUpdate;
	}
}