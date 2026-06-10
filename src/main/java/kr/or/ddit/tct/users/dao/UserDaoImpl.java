package kr.or.ddit.tct.users.dao;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.users.vo.UserVO;
import kr.or.ddit.tct.util.MyBatisUtil;

public class UserDaoImpl implements IUsersDao {

	private static IUsersDao userDao = new UserDaoImpl();

	private UserDaoImpl() {
	}

	public static IUsersDao getDao() {
		return userDao;
	}

	@Override
	public int existsUserId(String userId) {
		int cnt = 0;
		try (SqlSession session = MyBatisUtil.getSqlSession()) {
			cnt = session.selectOne("users.existsUserId", userId);
		} catch (PersistenceException e) {
			e.printStackTrace();
		}
		return cnt;
	}

	@Override
	public int insertUser(UserVO vo) {
		int cnt = 0;
		try (SqlSession session = MyBatisUtil.getSqlSession()) {
			cnt = session.insert("users.insertUser", vo);
			if (cnt > 0) session.commit();
		} catch (PersistenceException e) {
			e.printStackTrace();
		}
		return cnt;
	}

	@Override
	public UserVO selectUserById(String userId) {
		UserVO uv = null;
		try (SqlSession session = MyBatisUtil.getSqlSession()) {
			uv = session.selectOne("users.selectUserById", userId);
		} catch (PersistenceException e) {
			e.printStackTrace();
		}
		return uv;
	}

	@Override
	public UserVO selectUserForLogin(String userId, String userPass) {
		try (SqlSession session = MyBatisUtil.getSqlSession()) {
			Map<String, Object> parm = new HashMap<>();
			parm.put("userId", userId);
			parm.put("userPass", userPass);
			return session.selectOne("users.selectUserForLogin", parm);
		} catch (PersistenceException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public String findUserIdByNameTel(String userName, String userTel) {
		try (SqlSession session = MyBatisUtil.getSqlSession()) {
			Map<String, Object> parm2 = new HashMap<>();
			parm2.put("userName", userName);
			parm2.put("userTel", userTel);
			return session.selectOne("users.findUserIdByNameTel", parm2);
		} catch (PersistenceException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public int updateUser(UserVO uv) {
		int cnt = 0;
		try (SqlSession session = MyBatisUtil.getSqlSession()) {
			cnt = session.update("users.updateUser", uv);
			if (cnt > 0) session.commit();
		} catch (PersistenceException e) {
			e.printStackTrace();
		}
		return cnt;
	}

	@Override
	public int matchUserIdEmail(UserVO uv) {
		int result = 0;
		try (SqlSession session = MyBatisUtil.getSqlSession()) {
			// DB에서 COUNT(*) 결과를 가져옴 (Integer로 받음)
			Integer n = session.selectOne("users.matchUserIdEmail", uv);
			if (n != null) result = n;
		} catch (PersistenceException e) {
			e.printStackTrace();
		}
		return result;
	}

	@Override
	public int updateUserPassword(UserVO uv) {
		int result = 0;
		try (SqlSession session = MyBatisUtil.getSqlSession()) {
			// uv 안에 userId, newPass를 담아서 넘기는 형태라면
			// mapper parameterType을 uv로 맞추고 #{newPass}를 uv에 필드로 두거나,
			// map으로 넘기도록 DAO/Service에서 정리해야 함.
			result = session.update("users.updateUserPassword", uv);
			if (result > 0) session.commit();
		} catch (PersistenceException e) {
			e.printStackTrace();
		}
		return result;
	}

	@Override
	public int withdrawUser(String userId, String userPass) {
		int cnt = 0;
		try (SqlSession session = MyBatisUtil.getSqlSession(false)) {
			Map<String, Object> params = new HashMap<>();
			params.put("userId", userId);
			params.put("userPass", userPass);

			cnt = session.update("users.withdrawUser", params);

			if (cnt > 0) session.commit();
			else session.rollback();
		} catch (PersistenceException e) {
			e.printStackTrace();
		}
		return cnt;
	}
	

	  // 1) 이메일 존재 여부(가입된 이메일인지)
	  @Override
	  public int countUserByEmail(String email) {
	    int cnt = 0;

	    try (SqlSession session = MyBatisUtil.getSqlSession()) {
	      Integer n = session.selectOne("users.countUserByEmail", email); // #{value}
	      cnt = (n == null) ? 0 : n;
	    } catch (Exception e) {
	      e.printStackTrace();
	    }

	    return cnt;
	  }

	
	  // 2) 이메일로 비밀번호 업데이트
	  @Override
	  public int updateUserPwByEmail(String userEmail, String newPw) {
	    int cnt = 0;

	    try (SqlSession session = MyBatisUtil.getSqlSession()) {

	      Map<String, Object> param = new HashMap<>();
	      param.put("userEmail", userEmail); // #{userEmail}
	      param.put("newPw", newPw);         // #{newPw}

	      cnt = session.update("users.updateUserPwByEmail", param);

	      if (cnt > 0) session.commit(); // 성공한 경우만 커밋

	    } catch (Exception e) {
	      e.printStackTrace();
	    }

	    return cnt;
	  }
}
