package kr.or.ddit.tct.sales.cart.service;

import kr.or.ddit.tct.sales.cart.dao.CartDaoImpl;
import kr.or.ddit.tct.sales.cart.dao.ICartDao;
import kr.or.ddit.tct.sales.cart.dto.vo.CartDetailDtoVO;
import kr.or.ddit.tct.sales.cart.vo.CartVO;

public class CartServiceImpl implements ICartService {

    private static ICartService service = new CartServiceImpl();
    private final ICartDao dao = CartDaoImpl.getInstance();

    private CartServiceImpl() {}

    public static ICartService getInstance() {
        if (service == null) service = new CartServiceImpl();
        return service;
    }

    @Override
    public CartVO getCurrentCart(String userId) {
        return dao.selectCartByUserId(userId);
    }

    @Override
    public CartDetailDtoVO getCartDetail(String userId) {
        return dao.selectCartDetailByUserId(userId);
    }

    @Override
    public String addToCartSingle(String userId, String regId, int peopleCnt, boolean forceReplace) {

        if (userId == null || userId.isBlank() || regId == null || regId.isBlank()) {
            return "FAIL";
        }
        if (peopleCnt <= 0) peopleCnt = 1;

        CartVO current = dao.selectCartByUserId(userId);

        // 1) 비어있으면 그대로 insert
        if (current == null) {
            CartVO vo = new CartVO();
            vo.setUserId(userId);
            vo.setRegId(regId);
            vo.setPeopleCnt(peopleCnt);
            return (dao.insertCart(vo) > 0) ? "OK" : "FAIL";
        }

        // 2) 이미 같은 상품이면(단건이므로) peopleCnt만 update(확장용) 또는 OK
        if (regId.equals(current.getRegId())) {
            // 필요하면 인원수 업데이트
            current.setPeopleCnt(peopleCnt);
            dao.updatePeopleCnt(current);
            return "OK";
        }

        // 3) 다른 상품이 담겨있음
        if (!forceReplace) {
            return "CONFLICT";
        }

        // 4) 교체 강제: delete 후 insert
        dao.deleteCartByUserId(userId);
        CartVO vo = new CartVO();
        vo.setUserId(userId);
        vo.setRegId(regId);
        vo.setPeopleCnt(peopleCnt);

        return (dao.insertCart(vo) > 0) ? "OK" : "FAIL";
    }

    @Override
    public int clearCart(String userId) {
        if (userId == null || userId.isBlank()) return 0;
        return dao.deleteCartByUserId(userId);
    }
    
    
    @Override
    public int updatePeopleCnt(String userId, int peopleCnt) {
        CartVO vo = new CartVO();      // ✅ UPDATE에 쓸 값들을 담는 VO
        vo.setUserId(userId);          // ✅ WHERE USER_ID = ?
        vo.setPeopleCnt(peopleCnt);    // ✅ SET PEOPLE_CNT = ?
        return dao.updatePeopleCnt(vo); // ✅ mapper(cart.updatePeopleCnt) 실행
    }

    
    
    
    
    
}
