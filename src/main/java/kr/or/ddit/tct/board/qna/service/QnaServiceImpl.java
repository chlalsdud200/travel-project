package kr.or.ddit.tct.board.qna.service;

import java.util.List;

import kr.or.ddit.tct.board.qna.dao.IQnaDao;
import kr.or.ddit.tct.board.qna.dao.QnaDaoImpl;
import kr.or.ddit.tct.board.qna.vo.QnaVO;
import kr.or.ddit.tct.board.vo.PageInfo;

public class QnaServiceImpl implements IQnaService {

  private static IQnaService service;
  private final IQnaDao dao = QnaDaoImpl.getDao();

  private QnaServiceImpl() {
  }

  public static IQnaService getInstance() {
    if (service == null) service = new QnaServiceImpl();
    return service;
  }

  @Override
  public List<QnaVO> selectNoticeTop(PageInfo pinfo, int noticeLimit) {
    return dao.selectNoticeTop(pinfo, noticeLimit);
  }

  @Override
  public List<QnaVO> readPaging(PageInfo pinfo) {
    int total = dao.getListCount(pinfo);
    pinfo.setTotalRecord(total);
    return dao.pageByList(pinfo);
  }

  @Override
  public int getListCount(PageInfo pinfo) {
    return dao.getListCount(pinfo);
  }

  @Override
  public int insertQna(QnaVO vo) {
    return dao.insertQna(vo);
  }

  @Override
  public QnaVO viewQna(long qnaNo) {
    // 상세를 "조회"하는 순간에만 hit 증가
    // 존재이유: 목록/수정프리필/답변등록 같은 작업에서는 조회수를 올리지 않기 위해
    dao.updateHit(qnaNo);
    return dao.selectQnaByNo(qnaNo);
  }

  @Override
  public int deleteQna(long qnaNo, String userId) {
    return dao.deleteQna(qnaNo, userId);
  }

  @Override
  public QnaVO getQna(long qnaNo) {
    // hit 증가 없이 1건 조회
    return dao.selectQnaByNo(qnaNo);
  }

  @Override
  public int updateQna(long qnaNo, String userId, String title, String content) {
    return dao.updateQna(qnaNo, userId, title, content);
  }

  @Override
  public QnaVO getPrevQna(long qnaNo) {
    return dao.selectPrevQna(qnaNo);
  }

  @Override
  public QnaVO getNextQna(long qnaNo) {
    return dao.selectNextQna(qnaNo);
  }

  // ===== 관리자 답변 =====

  @Override
  public int answerInsert(long qnaNo, String ansCtt) {
    QnaVO vo = new QnaVO();
    vo.setQnaNo(qnaNo);
    vo.setAnsCtt(ansCtt);
    return dao.answerInsert(vo);
  }

  @Override
  public int answerUpdate(long qnaNo, String ansCtt) {
    QnaVO vo = new QnaVO();
    vo.setQnaNo(qnaNo);
    vo.setAnsCtt(ansCtt);
    return dao.answerUpdate(vo);
  }

  @Override
  public int answerDelete(long qnaNo) {
    return dao.answerDelete(qnaNo);
  }
}
