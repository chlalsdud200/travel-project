package kr.or.ddit.tct.admin.boards.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.admin.boards.vo.AdminBoardKeyVO;
import kr.or.ddit.tct.admin.boards.vo.AdminBoardPostVO;
import kr.or.ddit.tct.admin.boards.vo.AdminBoardSearchVO;
import kr.or.ddit.tct.util.MyBatisUtil;

public class AdminBoardsDaoImpl implements IAdminBoardsDao {

  private static IAdminBoardsDao dao;

  private AdminBoardsDaoImpl() {}

  public static IAdminBoardsDao getInstance() {
    if (dao == null) dao = new AdminBoardsDaoImpl();
    return dao;
  }

  @Override
  public int count(AdminBoardSearchVO search) {
    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      Integer cnt = session.selectOne("adminBoards.countAdminBoards", search);
      return (cnt == null) ? 0 : cnt;
    }
  }

  @Override
  public List<AdminBoardPostVO> selectList(AdminBoardSearchVO search) {
    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      return session.selectList("adminBoards.selectAdminBoards", search);
    }
  }

  @Override
  public AdminBoardPostVO selectDetail(AdminBoardKeyVO key) {
    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      return session.selectOne("adminBoards.selectAdminBoardDetail", key);
    }
  }

  @Override
  public int softDeleteQna(int postNo, String adminId) {
    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      Map<String, Object> p = new HashMap<>();
      p.put("postNo", postNo);
      p.put("adminId", adminId);

      int cnt = session.update("adminBoards.softDeleteQna", p);
      if (cnt > 0) session.commit();
      return cnt;
    }
  }

  @Override
  public int softDeleteReview(int postNo, String adminId) {
    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      Map<String, Object> p = new HashMap<>();
      p.put("postNo", postNo);
      p.put("adminId", adminId);

      int cnt = session.update("adminBoards.softDeleteReview", p);
      if (cnt > 0) session.commit();
      return cnt;
    }
  }

  @Override
  public int hardDeleteQna(int postNo) {
    try (SqlSession session = MyBatisUtil.getSqlSession()) {

      // [존재이유] REPLY(FK_REPLY_QNA)가 QNA_BOARD를 참조하므로
      //           부모글(QNA/NOTICE)을 지우기 전에 자식(댓글)부터 지워야 한다.
      session.delete("adminBoards.hardDeleteQnaReplies", postNo);

      // [의미] 댓글이 정리된 뒤, 글 레코드를 영구 삭제
      int cnt = session.delete("adminBoards.hardDeleteQna", postNo);

      // [의미] 위 2개 삭제를 한 트랜잭션으로 확정(영구삭제는 결과 0이어도 커밋해도 무방)
      session.commit();
      return cnt;
    }
  }

  @Override
  public int hardDeleteReview(int postNo) {
    try (SqlSession session = MyBatisUtil.getSqlSession()) {

      // [존재이유] REPLY(FK_REPLY_REVIEW)가 REVIEW_BOARD를 참조하므로
      //           부모글(리뷰)을 지우기 전에 자식(댓글)부터 지워야 한다.
      session.delete("adminBoards.hardDeleteReviewReplies", postNo);

      // [의미] 댓글이 정리된 뒤, 리뷰 글 레코드를 영구 삭제
      int cnt = session.delete("adminBoards.hardDeleteReview", postNo);

      // [의미] 위 2개 삭제를 확정
      session.commit();
      return cnt;
    }
  }



}
