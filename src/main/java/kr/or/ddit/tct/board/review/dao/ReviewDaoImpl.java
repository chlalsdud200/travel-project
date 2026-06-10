package kr.or.ddit.tct.board.review.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.board.qna.dao.QnaDaoImpl;
import kr.or.ddit.tct.board.review.vo.ReviewBoardVO;
import kr.or.ddit.tct.util.MyBatisUtil;

public class ReviewDaoImpl implements IReviewDao {
	
	private static IReviewDao dao;
	
	private ReviewDaoImpl() {
		
	}
	
	public static IReviewDao getDao() {
		if (dao == null)
			dao = new ReviewDaoImpl();
		return dao;
	}

	@Override
	public int selectNextReviewNo() {
		int nextNo = 0;
		
		try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
            nextNo = sqlSession.selectOne("boardReview.selectNextReviewNo");
        } catch (Exception e) {
            e.printStackTrace();
        }
		
		return nextNo;
	}

	@Override
	public int selectReviewCount(Map<String, Object> param) {
		int cnt = 0;
		
		try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
            cnt = sqlSession.selectOne("boardReview.selectReviewCount", param);
        } catch (Exception e) {
            e.printStackTrace();
        }
		
		return cnt;
	}

	@Override
	public List<ReviewBoardVO> selectReviewList(Map<String, Object> param) {
		List<ReviewBoardVO> list = null;
		
		try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
            list = sqlSession.selectList("boardReview.selectReviewList", param);
        } catch (Exception e) {
            e.printStackTrace();
        }
		
		return list;
	}

	@Override
	public ReviewBoardVO selectReviewDetail(int reviewNo) {
		ReviewBoardVO vo = null;
		
		try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
            vo = sqlSession.selectOne("boardReview.selectReviewDetail", reviewNo);
        } catch (Exception e) {
            e.printStackTrace();
        }
		
		return vo;
	}

	@Override
	public int increaseReviewHit(int reviewNo) {
		int cnt = 0;
		
		try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
            cnt = sqlSession.update("boardReview.increaseReviewHit", reviewNo);
            sqlSession.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
		
		return cnt;
	}

	@Override
	public int insertReview(ReviewBoardVO vo) {
		int cnt = 0;
		
		try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
	          cnt = sqlSession.insert("boardReview.insertReview", vo);
	          sqlSession.commit();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
		
		return cnt;
	}

	@Override
	public int updateReview(ReviewBoardVO vo) {
		int cnt = 0;
		
		try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
            cnt = sqlSession.update("boardReview.updateReview", vo);
            sqlSession.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
		
		return cnt;
	}

	@Override
	public int deleteReview(Map<String, Object> param) {
		int cnt = 0;
		
		try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
            cnt = sqlSession.delete("boardReview.deleteReview", param);
            sqlSession.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
		
		return cnt;
	}

	@Override
	public List<Map<String, Object>> selectWritableOrderNos(String userId) {
	    try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
	        return sqlSession.selectList("boardReview.selectWritableOrderNos", userId);
	    }
	}

	@Override
	public int countMyPaidOrder(Map<String, Object> param) {
	    int cnt = 0;
	    try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
	        cnt = sqlSession.selectOne("boardReview.countMyPaidOrder", param);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return cnt;
	}

	@Override
	public int countReviewByOrderNo(String orderNo) {
	    int cnt = 0;
	    try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
	        cnt = sqlSession.selectOne("boardReview.countReviewByOrderNo", orderNo);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return cnt;
	}

	@Override
	public ReviewBoardVO selectReviewView(int reviewNo) {
		ReviewBoardVO vo = null;
		try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
            vo = sqlSession.selectOne("boardReview.selectReviewView", reviewNo);
        } catch (Exception e) {
            e.printStackTrace();
        }
		return vo;
	}

	@Override
	public String selectReviewWriter(int reviewNo) {
		String writer = null;
		try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
	        writer = sqlSession.selectOne("boardReview.selectReviewWriter", reviewNo);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
		return null;
	}


    
}
