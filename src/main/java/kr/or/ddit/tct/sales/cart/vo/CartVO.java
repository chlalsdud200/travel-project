package kr.or.ddit.tct.sales.cart.vo;

public class CartVO {

	private String userId; /*  */
	private String regId; /*  */
	private int peopleCnt; /*  */
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getRegId() {
		return regId;
	}
	public void setRegId(String regId) {
		this.regId = regId;
	}
	public int getPeopleCnt() {
		return peopleCnt;
	}
	public void setPeopleCnt(int peopleCnt) {
		this.peopleCnt = peopleCnt;
	}
	
	@Override
	public String toString() {
		return "CartVO [userId=" + userId + ", regId=" + regId + ", peopleCnt=" + peopleCnt + "]";
	}
	
}
