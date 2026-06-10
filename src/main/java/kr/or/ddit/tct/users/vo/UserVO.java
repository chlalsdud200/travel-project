package kr.or.ddit.tct.users.vo;


public class UserVO {

	private String userId;
	private String userPass;
	private String role;
	private String userName;
	private String userBir;
	private String userEmail;
	private String userTel;
	private String userAddr1;
	private String userAddr2;
	private String userZip;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserPass() {
		return userPass;
	}

	public void setUserPass(String userPass) {
		this.userPass = userPass;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}



	public String getUserBir() {
		return userBir;
	}

	public void setUserBir(String userBir) {
		this.userBir = userBir;
	}

	public String getUserEmail() {
		return userEmail;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}

	public String getUserTel() {
		return userTel;
	}

	public void setUserTel(String userTel) {
		this.userTel = userTel;
	}

	public String getUserAddr1() {
		return userAddr1;
	}

	public void setUserAddr1(String userAddr1) {
		this.userAddr1 = userAddr1;
	}

	public String getUserAddr2() {
		return userAddr2;
	}

	public void setUserAddr2(String userAddr2) {
		this.userAddr2 = userAddr2;
	}

	

	public String getUserZip() {
		return userZip;
	}

	public void setUserZip(String userZip) {
		this.userZip = userZip;
	}

	@Override
	public String toString() {
		return "UserVO [userId=" + userId + ", userPass=" + userPass + ", role=" + role + ", userName=" + userName
				+ ", userBir=" + userBir + ", userEmail=" + userEmail + ", userTel=" + userTel + ", userAddr1="
				+ userAddr1 + ", userAddr2=" + userAddr2 + ", userZip=" + userZip + "]";
	}

}
