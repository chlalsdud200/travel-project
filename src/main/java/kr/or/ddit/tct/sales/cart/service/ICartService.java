package kr.or.ddit.tct.sales.cart.service;

import kr.or.ddit.tct.sales.cart.dto.vo.CartDetailDtoVO;
import kr.or.ddit.tct.sales.cart.vo.CartVO;

public interface ICartService {

    CartVO getCurrentCart(String userId);

    CartDetailDtoVO getCartDetail(String userId);

    /**
     * 장바구니 담기(단건 제한)
     * @return 결과 코드
     *   - "OK" : 새로 담기 성공 또는 동일 상품이라 그대로
     *   - "CONFLICT" : 이미 다른 상품이 담겨 있어 교체 확인 필요
     *   - "FAIL" : DB 처리 실패
     */
    String addToCartSingle(String userId, String regId, int peopleCnt, boolean forceReplace);

    int clearCart(String userId);
    int updatePeopleCnt(String userId, int peopleCnt);

}
