package kr.or.ddit.tct.board.reply.dao;

import java.util.List;
import kr.or.ddit.tct.board.reply.vo.ReplyVO;

/**
 * Reply DAO 인터페이스
 * - QNA/Review 댓글 전용
 */
public interface IReplyDao {

	/**
	 * QNA 댓글 등록
	 */
	public int qnaReplyInsert(ReplyVO vo);
	
	/**
	 * QNA 댓글 목록 조회
	 */
	public List<ReplyVO> qnaReplyList(int qnaNo);
	
	/**
	 * QNA 댓글 삭제
	 */
	public int qnaReplyDelete(int reNum);
	
	/**
	 * QNA 댓글 수정
	 */
	public int qnaReplyUpdate(ReplyVO vo);
	
	
	int qnaReplyAdminDelete(int reNum);
	
	int qnaReplyAdminUpdate(ReplyVO vo);
	
	// 리뷰 댓글
	int reviewReplyInsert(ReplyVO vo);
	List<ReplyVO> reviewReplyList(int reviewNo);
	
	// ✅ 아래 4개 메서드 추가
	int reviewReplyUpdate(ReplyVO vo);
	int reviewReplyAdminUpdate(ReplyVO vo);
	int reviewReplyDelete(int reNum);
	int reviewReplyAdminDelete(int reNum);
}