package kr.or.ddit.tct.sales.cart.dao;

import kr.or.ddit.tct.sales.cart.dto.vo.CartDetailDtoVO;
import kr.or.ddit.tct.sales.cart.vo.CartVO;

public interface ICartDao {

    CartVO selectCartByUserId(String userId);

    int deleteCartByUserId(String userId);

    int insertCart(CartVO vo);

    int updatePeopleCnt(CartVO vo);

    CartDetailDtoVO selectCartDetailByUserId(String userId);
}
