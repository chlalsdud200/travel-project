package kr.or.ddit.tct.admin.members.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.tct.admin.members.dao.AdminMemberDaoImpl;
import kr.or.ddit.tct.admin.members.dao.IAdminMemberDao;
import kr.or.ddit.tct.users.vo.UserVO;

public class AdminMemberServiceImpl implements IAdminMemberService {

	private static final IAdminMemberService instance = new AdminMemberServiceImpl();
	private final IAdminMemberDao dao = AdminMemberDaoImpl.getInstance();

	private AdminMemberServiceImpl() {}

	public static IAdminMemberService getInstance() {
		return instance;
	}

	@Override
	public List<UserVO> selectAdminUserList(Map<String, Object> params) {
		return dao.selectAdminUserList(params);
	}

	@Override
	public int countAdminUsers(Map<String, Object> params) {
		return dao.countAdminUsers(params);
	}

	@Override
	public int updateUserAdmin(UserVO uv) {
		return dao.updateUserAdmin(uv);
	}

	@Override
	public int deleteUserAdmin(String userId) {
		return dao.deleteUserAdmin(userId);
	}

	@Override
	public int withdrawUserAdmin(String userId) {
		return dao.withdrawUserAdmin(userId);
	}
}
