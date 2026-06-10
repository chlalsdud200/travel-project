package kr.or.ddit.tct.board.reply.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.board.reply.vo.ReplyVO;
import kr.or.ddit.tct.util.MyBatisUtil;

/**
 * Reply DAO 구현체
 * - 싱글톤 패턴
 */
public class ReplyDaoImpl implements IReplyDao {

	// 싱글톤
	private static IReplyDao dao;

	public static IReplyDao getDao() {
		if (dao == null)
			dao = new ReplyDaoImpl();
		return dao;
	}

	// 생성자 private
	private ReplyDaoImpl() {
	}

	@Override
	public int qnaReplyInsert(ReplyVO vo) {
		SqlSession sql = MyBatisUtil.getSqlSession();
		
		int count = 0;
		
		try {
			count = sql.insert("reply.qnaReplyInsert", vo);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			sql.commit();
			sql.close();
		}
		
		return count;
	}

	@Override
	public List<ReplyVO> qnaReplyList(int qnaNo) {
		SqlSession sql = MyBatisUtil.getSqlSession();
		
		List<ReplyVO> list = null;
		
		try {
			list = sql.selectList("reply.qnaReplyList", qnaNo);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			sql.close();
		}
		
		return list;
	}

	@Override
	public int qnaReplyDelete(int reNum) {
		SqlSession sql = MyBatisUtil.getSqlSession();
		
		int count = 0;
		
		try {
			count = sql.delete("reply.qnaReplyDelete", reNum);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			sql.commit();
			sql.close();
		}
		
		return count;
	}

	@Override
	public int qnaReplyUpdate(ReplyVO vo) {
		SqlSession sql = MyBatisUtil.getSqlSession();
		
		int count = 0;
		
		try {
			count = sql.update("reply.qnaReplyUpdate", vo);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			sql.commit();
			sql.close();
		}
		
		return count;
	}
	
	@Override
	public int qnaReplyAdminDelete(int reNum) {
		SqlSession sql = MyBatisUtil.getSqlSession();
		int count = 0;
		try {
			count = sql.update("reply.qnaReplyAdminDelete", reNum);
		} finally {
			sql.commit();
			sql.close();
		}
		return count;
	}

	@Override
	public int qnaReplyAdminUpdate(ReplyVO vo) {
		SqlSession sql = MyBatisUtil.getSqlSession();
		int count = 0;
		try {
			count = sql.update("reply.qnaReplyAdminUpdate", vo);
		} finally {
			sql.commit();
			sql.close();
		}
		return count;
	}

	@Override
	public int reviewReplyInsert(ReplyVO vo) {
		SqlSession sql = MyBatisUtil.getSqlSession();
		int count = 0;
		try {
			count = sql.insert("reply.reviewReplyInsert", vo);
			sql.commit();
		} finally {
			sql.close();
		}
		return count;
	}

	@Override
	public List<ReplyVO> reviewReplyList(int reviewNo) {
		SqlSession sql = MyBatisUtil.getSqlSession();
		try {
			return sql.selectList("reply.reviewReplyList", reviewNo);
		} finally {
			sql.close();
		}
	}

	@Override
	public int reviewReplyUpdate(ReplyVO vo) {
		SqlSession sql = MyBatisUtil.getSqlSession();
		int count = 0;
		try {
			count = sql.update("reply.reviewReplyUpdate", vo);
		} finally {
			sql.commit();
			sql.close();
		}
		return count;
	}

	@Override
	public int reviewReplyAdminUpdate(ReplyVO vo) {
		SqlSession sql = MyBatisUtil.getSqlSession();
		int count = 0;
		try {
			count = sql.update("reply.reviewReplyAdminUpdate", vo);
		} finally {
			sql.commit();
			sql.close();
		}
		return count;
	}

	@Override
	public int reviewReplyDelete(int reNum) {
		SqlSession sql = MyBatisUtil.getSqlSession();
		int count = 0;
		try {
			count = sql.delete("reply.reviewReplyDelete", reNum);
		} finally {
			sql.commit();
			sql.close();
		}
		return count;
	}

	@Override
	public int reviewReplyAdminDelete(int reNum) {
		SqlSession sql = MyBatisUtil.getSqlSession();
		int count = 0;
		try {
			count = sql.update("reply.reviewReplyAdminDelete", reNum);
		} finally {
			sql.commit();
			sql.close();
		}
		return count;
	}
}