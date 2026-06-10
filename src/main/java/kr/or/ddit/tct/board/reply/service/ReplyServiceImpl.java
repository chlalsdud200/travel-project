package kr.or.ddit.tct.board.reply.service;

import java.util.List;

import kr.or.ddit.tct.board.reply.vo.ReplyVO;
import kr.or.ddit.tct.board.reply.dao.IReplyDao;
import kr.or.ddit.tct.board.reply.dao.ReplyDaoImpl;

/**
 * Reply Service 구현체
 * - 싱글톤 패턴
 */
public class ReplyServiceImpl implements IReplyService {

	// DAO 변수
	private IReplyDao dao;
	
	// 생성자
	private ReplyServiceImpl() {
		dao = ReplyDaoImpl.getDao();
	}
	
	// 싱글톤
	private static IReplyService service;
	
	public static IReplyService getService() {
		if (service == null)
			service = new ReplyServiceImpl();
		return service;
	}
	
	@Override
	public int qnaReplyInsert(ReplyVO vo) {
		return dao.qnaReplyInsert(vo);
	}

	@Override
	public List<ReplyVO> qnaReplyList(int qnaNo) {
		return dao.qnaReplyList(qnaNo);
	}

	@Override
	public int qnaReplyDelete(int reNum) {
		return dao.qnaReplyDelete(reNum);
	}

	@Override
	public int qnaReplyUpdate(ReplyVO vo) {
		return dao.qnaReplyUpdate(vo);
	}
	
	@Override
	public int qnaReplyAdminDelete(int reNum) {
		return dao.qnaReplyAdminDelete(reNum);
	}

	@Override
	public int qnaReplyAdminUpdate(ReplyVO vo) {
		return dao.qnaReplyAdminUpdate(vo); 
	}
	
	@Override
	public int reviewReplyInsert(ReplyVO vo) {
		return dao.reviewReplyInsert(vo);
	}

	@Override
	public List<ReplyVO> reviewReplyList(int reviewNo) {
		return dao.reviewReplyList(reviewNo);
	}

	@Override
	public int reviewReplyUpdate(ReplyVO vo) {
		return dao.reviewReplyUpdate(vo);
	}

	@Override
	public int reviewReplyAdminUpdate(ReplyVO vo) {
		return dao.reviewReplyAdminUpdate(vo);
	}

	@Override
	public int reviewReplyDelete(int reNum) {
		return dao.reviewReplyDelete(reNum);
	}

	@Override
	public int reviewReplyAdminDelete(int reNum) {
		return dao.reviewReplyAdminDelete(reNum);
	}
}