package kr.or.ddit.tct.admin.members.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.tct.users.vo.UserVO;

public interface IAdminMemberService {

	List<UserVO> selectAdminUserList(Map<String, Object> params);

	int countAdminUsers(Map<String, Object> params);

	int updateUserAdmin(UserVO uv);

	int deleteUserAdmin(String userId);
	
	int withdrawUserAdmin(String userId);

}
