package kr.or.ddit.tct.board.review.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.or.ddit.tct.board.qna.dao.IQnaDao;
import kr.or.ddit.tct.board.qna.dao.QnaDaoImpl;
import kr.or.ddit.tct.board.qna.service.QnaServiceImpl;
import kr.or.ddit.tct.board.review.dao.IReviewDao;
import kr.or.ddit.tct.board.review.dao.ReviewDaoImpl;
import kr.or.ddit.tct.board.review.vo.ReviewBoardVO;

public class ReviewServiceImpl implements IReviewService{

	private static IReviewService service;
	private final IReviewDao dao = ReviewDaoImpl.getDao();
	
	private ReviewServiceImpl() {
		
	}
	
	public static IReviewService getInstance() {
		if (service == null)
			service = new ReviewServiceImpl();
		return service;
	}
	
	@Override
	public int selectNextReviewNo() {
		return dao.selectNextReviewNo();
	}

	@Override
	public int selectReviewCount(Map<String, Object> param) {
		return dao.selectReviewCount(param);
	}

	@Override
	public List<ReviewBoardVO> selectReviewList(Map<String, Object> param) {
		return dao.selectReviewList(param);
	}

	@Override
	public ReviewBoardVO selectReviewDetail(int reviewNo) {
		return dao.selectReviewDetail(reviewNo);
	}

	@Override
	public int increaseReviewHit(int reviewNo) {
		return dao.increaseReviewHit(reviewNo);
	}

	@Override
	public int insertReview(ReviewBoardVO vo) {
		// 등록 시 PK 채번을 서비스에서 처리하고 싶으면 여기서 처리 가능
        // (컨트롤러에서 vo.setReviewNo(...) 해도 됨)

        //if (vo.getReviewNo() == 0) {
        //    int nextNo = dao.selectNextReviewNo();
        //    vo.setReviewNo(nextNo);
        //}

        // rating 기본값 방어(선택)
        //if (vo.getReviewRating() < 1) vo.setReviewRating(1);
        //if (vo.getReviewRating() > 5) vo.setReviewRating(5);
        
		return dao.insertReview(vo);
	}

	@Override
	public int updateReview(ReviewBoardVO vo) {
		// rating 방어(선택)
        //if (vo.getReviewRating() < 1) vo.setReviewRating(1);
        //if (vo.getReviewRating() > 5) vo.setReviewRating(5);
        
		return dao.updateReview(vo);
	}

	@Override
	public int deleteReview(int reviewNo, String userId) {
		Map<String, Object> map = new HashMap<>();
        map.put("reviewNo", reviewNo);
        map.put("userId", userId);
        return dao.deleteReview(map);
	}

	@Override
	public List<Map<String, Object>> selectWritableOrderNos(String userId) {
		return dao.selectWritableOrderNos(userId);
	}

	@Override
	public boolean canWriteReview(String userId, String orderNo) {
		
	    if (userId == null || orderNo == null || orderNo.trim().isEmpty()) {
	        return false;
	    }
	    
	    // 1) 내 결제완료 주문인지
	    Map<String, Object> p = new HashMap<>();
	    p.put("userId", userId);
	    p.put("orderNo", orderNo);

	    if (dao.countMyPaidOrder(p) <= 0) {
	        return false;
	    }

	    // 2) 이미 해당 주문번호로 리뷰 작성했는지
	    if (dao.countReviewByOrderNo(orderNo) > 0) {
	        return false;
	    }
	    
		return true;
	}

	@Override
	public ReviewBoardVO selectReviewView(int reviewNo, boolean increaseHit) {
		if (increaseHit) {
		    dao.increaseReviewHit(reviewNo); // update
		  }
		return dao.selectReviewView(reviewNo); //select
	}

	@Override
	public boolean canEdit(int reviewNo, String loginId) {
		if (loginId == null) return false;
	    
		ReviewBoardVO vo = dao.selectReviewView(reviewNo);
		return vo != null && loginId.equals(vo.getUserId());
	}

}
