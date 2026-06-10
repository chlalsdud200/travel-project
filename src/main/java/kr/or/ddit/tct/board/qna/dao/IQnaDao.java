package kr.or.ddit.tct.board.qna.dao;

import java.util.List;

import kr.or.ddit.tct.board.qna.vo.QnaVO;
import kr.or.ddit.tct.board.vo.PageInfo;

public interface IQnaDao {
  int getListCount(PageInfo pinfo);

  // 공지(관리자 글) Top N - 페이징과 별도로 항상 상단에 붙일 목록
  List<QnaVO> selectNoticeTop(PageInfo pinfo, int noticeLimit);

  List<QnaVO> pageByList(PageInfo pinfo);

  int insertQna(QnaVO vo);

  // 조회수 증가
  int updateHit(long qnaNo);

  // 글 1건 조회(상세/수정프리필 공용, 답변 포함)
  QnaVO selectQnaByNo(long qnaNo);

  // 글 삭제(작성자 본인)
  int deleteQna(long qnaNo, String userId);

  // 글 수정(작성자 본인)
  int updateQna(long qnaNo, String userId, String title, String content);

  // 이전글 / 다음글
  QnaVO selectPrevQna(long qnaNo);
  QnaVO selectNextQna(long qnaNo);

  // ===== 관리자 답변 =====
  int answerInsert(QnaVO vo); // qnaNo + ansCtt
  int answerUpdate(QnaVO vo); // qnaNo + ansCtt
  int answerDelete(long qnaNo); // qnaNo
}
