package kr.or.ddit.tct.board.review.dao;

import java.util.List;
import java.util.Map;

import kr.or.ddit.tct.board.review.vo.ReviewBoardVO;

public interface IReviewDao {

	int selectNextReviewNo();
    int selectReviewCount(Map<String, Object> param);
    List<ReviewBoardVO> selectReviewList(Map<String, Object> param);

    ReviewBoardVO selectReviewDetail(int reviewNo);
    int increaseReviewHit(int reviewNo);

    int insertReview(ReviewBoardVO vo);
    int updateReview(ReviewBoardVO vo);
    int deleteReview(Map<String, Object> param);
    
    List<Map<String, Object>> selectWritableOrderNos(String userId); // 리뷰작성 가능한 주문번호 조회
    
    
    int countMyPaidOrder(Map<String, Object> param); // 내 주문이 결제완료 상태인지 확인
    int countReviewByOrderNo(String orderNo); // 해당 주문번호로 이미 리뷰가 있는지 확인
    
    ReviewBoardVO selectReviewView(int reviewNo);
    String selectReviewWriter(int reviewNo);
}
