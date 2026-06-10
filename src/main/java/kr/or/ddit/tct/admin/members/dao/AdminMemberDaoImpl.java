package kr.or.ddit.tct.admin.members.dao;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.users.vo.UserVO;
import kr.or.ddit.tct.util.MyBatisUtil;

public class AdminMemberDaoImpl implements IAdminMemberDao {

    private static final IAdminMemberDao instance = new AdminMemberDaoImpl();

    private AdminMemberDaoImpl() {}

    public static IAdminMemberDao getInstance() {
        return instance;
    }

    @Override
    public List<UserVO> selectAdminUserList(Map<String, Object> params) {
        try (SqlSession session = MyBatisUtil.getSqlSession()) {
            return session.selectList("users.selectAdminUserList", params);
        } catch (PersistenceException e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    @Override
    public int countAdminUsers(Map<String, Object> params) {
        try (SqlSession session = MyBatisUtil.getSqlSession()) {
            Integer cnt = session.selectOne("users.countAdminUsers", params);
            return (cnt == null) ? 0 : cnt.intValue();
        } catch (PersistenceException e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int updateUserAdmin(UserVO uv) {
        try (SqlSession session = MyBatisUtil.getSqlSession(false)) {
            int cnt = session.update("users.updateUserAdmin", uv);

            if (cnt > 0) session.commit();
            else session.rollback();

            return cnt;

        } catch (PersistenceException e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int deleteUserAdmin(String userId) {
        try (SqlSession session = MyBatisUtil.getSqlSession(false)) {
            int cnt = session.delete("users.deleteUserAdmin", userId);

            if (cnt > 0) session.commit();
            else session.rollback();

            return cnt;

        } catch (PersistenceException e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int withdrawUserAdmin(String userId) {
        try (SqlSession session = MyBatisUtil.getSqlSession(false)) {
            int cnt = session.update("users.withdrawUserAdmin", userId);
            if (cnt > 0) session.commit();
            else session.rollback();
            return cnt;
        } catch (PersistenceException e) {
            e.printStackTrace();
            return 0;
        }
    }

}
