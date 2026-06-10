package kr.or.ddit.tct.board.qna.service;

import java.util.List;

import kr.or.ddit.tct.board.qna.vo.QnaVO;
import kr.or.ddit.tct.board.vo.PageInfo;

public interface IQnaService {
  int getListCount(PageInfo pinfo);

  // 공지(관리자 글) Top N
  List<QnaVO> selectNoticeTop(PageInfo pinfo, int noticeLimit);

  List<QnaVO> readPaging(PageInfo pinfo);

  int insertQna(QnaVO vo);

  QnaVO viewQna(long qnaNo);   // hit+1 후 상세

  int deleteQna(long qnaNo, String userId);

  QnaVO getQna(long qnaNo); // hit 증가 없이 1건 가져오기(수정화면 프리필용)
  int updateQna(long qnaNo, String userId, String title, String content);

  QnaVO getPrevQna(long qnaNo);
  QnaVO getNextQna(long qnaNo);

  // ===== 관리자 답변 =====
  int answerInsert(long qnaNo, String ansCtt);
  int answerUpdate(long qnaNo, String ansCtt);
  int answerDelete(long qnaNo);
}
