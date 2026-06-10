package kr.or.ddit.tct.users.service;

import kr.or.ddit.tct.users.dao.IUsersDao;
import kr.or.ddit.tct.users.dao.UserDaoImpl;
import kr.or.ddit.tct.users.vo.UserVO;

public class UserServiceImpl implements IUserService{
	
	private static IUserService userService = new UserServiceImpl();
	private IUsersDao userDao;
	
	
	private UserServiceImpl() {
		userDao = UserDaoImpl.getDao();
	}
	
	public static IUserService getService() {
		return userService;
	}

	
	
	@Override
	public int existsUserId(String userId) {
		return userDao.existsUserId(userId);
	}

	@Override
	public int insertUser(UserVO uv) {
		return userDao.insertUser(uv);
	}

	@Override
	public UserVO selectUserById(String userId) {
		return userDao.selectUserById(userId);
	}
	
	
	
	@Override
	public UserVO login(String userId, String userPass) {
	     
		userId = (userId == null)? "" : userId.trim();
		userPass = (userPass == null)? "" : userPass.trim();
		
		if(userId.isEmpty() || userPass.isEmpty()){
			return null;
		}
		
		UserVO uvo = userDao.selectUserById(userId);
		if( uvo == null) {
			return null;
		}

		

		// 탈퇴 계정 로그인 차단
		if (uvo.getRole() != null && "WITHDRAWN".equalsIgnoreCase(uvo.getRole())) {
			return null;
		}
		if(!userPass.equals(uvo.getUserPass())) {
			return null;
		}
		
		return uvo;
	}

	@Override
	public String findUserIdByNameTel(String userName, String userTel) {
		return userDao.findUserIdByNameTel(userName, userTel);
	}
	

	@Override
	public int updateUser(UserVO uv) {
		return userDao.updateUser(uv);
	}
	
	 @Override
	  public int countUserByEmail(String email) {
	    return userDao.countUserByEmail(email);
	  }
	 
	 @Override
	  public int updateUserPwByEmail(String userEmail, String newPw) {
	    return userDao.updateUserPwByEmail(userEmail, newPw);
	  }



	@Override
	public int withdrawUser(String userId, String userPass) {
		userId = (userId == null) ? "" : userId.trim();
		userPass = (userPass == null) ? "" : userPass.trim();

		if (userId.isEmpty() || userPass.isEmpty()) {
			return 0;
		}
		return userDao.withdrawUser(userId, userPass);
	}

}
