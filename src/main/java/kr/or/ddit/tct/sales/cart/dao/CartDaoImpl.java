package kr.or.ddit.tct.sales.cart.dao;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.sales.cart.dto.vo.CartDetailDtoVO;
import kr.or.ddit.tct.sales.cart.vo.CartVO;
import kr.or.ddit.tct.util.MyBatisUtil;

public class CartDaoImpl implements ICartDao {

    private static ICartDao dao = new CartDaoImpl();

    private CartDaoImpl() {}

    public static ICartDao getInstance() {
        if (dao == null) dao = new CartDaoImpl();
        return dao;
    }

    @Override
    public CartVO selectCartByUserId(String userId) {
        try (SqlSession session = MyBatisUtil.getSqlSession()) {
            return session.selectOne("cart.selectCartByUserId", userId);
        } catch (PersistenceException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int deleteCartByUserId(String userId) {
        int cnt = 0;
        try (SqlSession session = MyBatisUtil.getSqlSession()) {
            cnt = session.delete("cart.deleteCartByUserId", userId);
            if (cnt > 0) session.commit();
        } catch (PersistenceException e) {
            e.printStackTrace();
        }
        return cnt;
    }

    @Override
    public int insertCart(CartVO vo) {
        int cnt = 0;
        try (SqlSession session = MyBatisUtil.getSqlSession()) {
            cnt = session.insert("cart.insertCart", vo);
            if (cnt > 0) session.commit();
        } catch (PersistenceException e) {
            e.printStackTrace();
        }
        return cnt;
    }

    @Override
    public int updatePeopleCnt(CartVO vo) {
        int cnt = 0;
        try (SqlSession session = MyBatisUtil.getSqlSession()) {
            cnt = session.update("cart.updatePeopleCnt", vo);
            if (cnt > 0) session.commit();
        } catch (PersistenceException e) {
            e.printStackTrace();
        }
        return cnt;
    }

    @Override
    public CartDetailDtoVO selectCartDetailByUserId(String userId) {
        try (SqlSession session = MyBatisUtil.getSqlSession()) {
            return session.selectOne("cart.selectCartDetailByUserId", userId);
        } catch (PersistenceException e) {
            e.printStackTrace();
        }
        return null;
    }
}
