package kr.or.ddit.tct.board.qna.dao;

import java.util.List;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.board.qna.vo.QnaNoticeParam;
import kr.or.ddit.tct.board.qna.vo.QnaVO;
import kr.or.ddit.tct.board.vo.PageInfo;
import kr.or.ddit.tct.util.MyBatisUtil;

public class QnaDaoImpl implements IQnaDao {

  private static IQnaDao dao;

  private QnaDaoImpl() {
  }

  public static IQnaDao getDao() {
    if (dao == null) dao = new QnaDaoImpl();
    return dao;
  }

  @Override
  public int getListCount(PageInfo pinfo) {
    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      return session.selectOne("boardQna.getListCount", pinfo);
    } catch (PersistenceException e) {
      e.printStackTrace();
      return 0;
    }
  }

  @Override
  public List<QnaVO> selectNoticeTop(PageInfo pinfo, int noticeLimit) {
    // Map 대신 파라미터 객체(QnaNoticeParam)로 넘긴다
    // 존재이유: mapper parameterType을 Map으로 두지 않는 정책을 유지하기 위해
    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      QnaNoticeParam param = new QnaNoticeParam(pinfo, noticeLimit);
      return session.selectList("boardQna.selectNoticeTop", param);
    } catch (PersistenceException e) {
      e.printStackTrace();
      return java.util.Collections.emptyList();
    }
  }

  @Override
  public List<QnaVO> pageByList(PageInfo pinfo) {
    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      return session.selectList("boardQna.pageByList", pinfo);
    } catch (PersistenceException e) {
      e.printStackTrace();
      return java.util.Collections.emptyList();
    }
  }

  @Override
  public int insertQna(QnaVO vo) {
    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      int cnt = session.insert("boardQna.insertQna", vo);
      if (cnt > 0) session.commit();
      return cnt;
    }
  }

  @Override
  public int updateHit(long qnaNo) {
    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      int cnt = session.update("boardQna.updateHit", qnaNo);
      if (cnt > 0) session.commit();
      return cnt;
    }
  }

  @Override
  public QnaVO selectQnaByNo(long qnaNo) {
    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      return session.selectOne("boardQna.selectQnaByNo", qnaNo);
    }
  }

  @Override
  public int deleteQna(long qnaNo, String userId) {
    // Map 대신 QnaVO로 넘긴다
    // 존재이유: mapper parameterType을 qnavo로 통일하기 위해
    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      QnaVO vo = new QnaVO();
      vo.setQnaNo(qnaNo);
      vo.setUserId(userId);

      int cnt = session.delete("boardQna.deleteQna", vo);
      if (cnt > 0) session.commit();
      return cnt;
    }
  }

  @Override
  public int updateQna(long qnaNo, String userId, String title, String content) {
    // Map 대신 QnaVO로 넘긴다
    // 존재이유: mapper parameterType을 qnavo로 통일하기 위해
    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      QnaVO vo = new QnaVO();
      vo.setQnaNo(qnaNo);
      vo.setUserId(userId);
      vo.setQnaTitle(title);
      vo.setQnaCtt(content);

      int cnt = session.update("boardQna.updateQna", vo);
      if (cnt > 0) session.commit();
      return cnt;
    }
  }

  @Override
  public QnaVO selectPrevQna(long qnaNo) {
    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      return session.selectOne("boardQna.selectPrevQna", qnaNo);
    }
  }

  @Override
  public QnaVO selectNextQna(long qnaNo) {
    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      return session.selectOne("boardQna.selectNextQna", qnaNo);
    }
  }

  // ===== 관리자 답변 =====

  @Override
  public int answerInsert(QnaVO vo) {
    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      int cnt = session.update("boardQna.answerInsert", vo);
      if (cnt > 0) session.commit();
      return cnt;
    }
  }

  @Override
  public int answerUpdate(QnaVO vo) {
    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      int cnt = session.update("boardQna.answerUpdate", vo);
      if (cnt > 0) session.commit();
      return cnt;
    }
  }

  @Override
  public int answerDelete(long qnaNo) {
    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      QnaVO vo = new QnaVO();
      vo.setQnaNo(qnaNo);

      int cnt = session.update("boardQna.answerDelete", vo);
      if (cnt > 0) session.commit();
      return cnt;
    }
  }
}
