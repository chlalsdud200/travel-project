package kr.or.ddit.tct.sales.wishlist.vo;

public class WishlistVO {

	private String userId; /*  */
	private String regId; /*  */
	
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
	
	@Override
	public String toString() {
		return "WishlistVO [userId=" + userId + ", regId=" + regId + "]";
	}
	
}
