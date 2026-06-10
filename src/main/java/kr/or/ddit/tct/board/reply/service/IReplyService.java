package kr.or.ddit.tct.board.reply.service;

import java.util.List;
import kr.or.ddit.tct.board.reply.vo.ReplyVO;

/**
 * Reply Service 인터페이스
 * - QNA/Review 댓글 전용
 */
public interface IReplyService {

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
	
	/**
	 * QNA 댓글 관리자 삭제
	 */
	int qnaReplyAdminDelete(int reNum);
	
	/**
	 * QNA 댓글 관리자 수정
	 */
	int qnaReplyAdminUpdate(ReplyVO vo);
	
	/**
	 * 리뷰 댓글 등록
	 */
	int reviewReplyInsert(ReplyVO vo);
	
	/**
	 * 리뷰 댓글 목록 조회
	 */
	List<ReplyVO> reviewReplyList(int reviewNo);
	
	/**
	 * 리뷰 댓글 수정
	 */
	int reviewReplyUpdate(ReplyVO vo);
	
	/**
	 * 리뷰 댓글 관리자 수정
	 */
	int reviewReplyAdminUpdate(ReplyVO vo);
	
	/**
	 * 리뷰 댓글 삭제
	 */
	int reviewReplyDelete(int reNum);
	
	/**
	 * 리뷰 댓글 관리자 삭제
	 */
	int reviewReplyAdminDelete(int reNum);
}