package kr.or.ddit.tct.board.review.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.tct.board.review.vo.ReviewBoardVO;

public interface IReviewService {

	int selectNextReviewNo();

    int selectReviewCount(Map<String, Object> param);

    List<ReviewBoardVO> selectReviewList(Map<String, Object> param);

    ReviewBoardVO selectReviewDetail(int reviewNo);

    int increaseReviewHit(int reviewNo);

    int insertReview(ReviewBoardVO vo);

    int updateReview(ReviewBoardVO vo);

    int deleteReview(int reviewNo, String userId);
    
    List<Map<String, Object>> selectWritableOrderNos(String userId);
    
    boolean canWriteReview(String userId, String orderNo);
    
    ReviewBoardVO selectReviewView(int reviewNo, boolean increaseHit);
    
    boolean canEdit(int reviewNo, String loginId);
}
