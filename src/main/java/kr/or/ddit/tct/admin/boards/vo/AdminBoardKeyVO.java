package kr.or.ddit.tct.admin.boards.vo;

public class AdminBoardKeyVO {
  private String postType; // QNA / REVIEW
  private int postNo;      // 글번호

  public String getPostType() { return postType; }
  public void setPostType(String postType) { this.postType = postType; }

  public int getPostNo() { return postNo; }
  public void setPostNo(int postNo) { this.postNo = postNo; }
}
