package kr.or.ddit.tct.users.dao;

import kr.or.ddit.tct.users.vo.UserVO;

public interface IUsersDao {
	int existsUserId(String userId);

	int insertUser(UserVO uv);

	UserVO selectUserById(String userId);
	
	UserVO selectUserForLogin(String userId, String userPass);
	
	String findUserIdByNameTel(String userName, String userTel);
	int updateUser(UserVO uv);
	
	
	
	int matchUserIdEmail(UserVO uv);
	int updateUserPassword(UserVO uv);
	int withdrawUser(String userId, String userPass);
	
	int countUserByEmail(String email);
	int  updateUserPwByEmail(String userEmail, String newPw);
}


