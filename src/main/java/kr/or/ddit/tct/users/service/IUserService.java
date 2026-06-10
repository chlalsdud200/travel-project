package kr.or.ddit.tct.users.service;

import kr.or.ddit.tct.users.vo.UserVO;

public interface IUserService {
	
	int existsUserId(String userId);

	int insertUser(UserVO uv);

	UserVO selectUserById(String userId);
	
    UserVO login(String userId, String userPass);
	 
	 String findUserIdByNameTel(String userName, String userTel);

	/**
	 * 마이페이지-회원정보수정
	 * @return 업데이트된 행 수
	 */
	int updateUser(UserVO uv);
	
	 int countUserByEmail(String email);
	 int updateUserPwByEmail(String userEmail, String newPw);
	
	int withdrawUser(String userId, String userPass);
}
