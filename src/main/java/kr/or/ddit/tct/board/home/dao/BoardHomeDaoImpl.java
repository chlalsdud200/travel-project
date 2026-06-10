package kr.or.ddit.tct.board.home.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.board.home.vo.BoardHomePostVO;
import kr.or.ddit.tct.board.vo.PageInfo;
import kr.or.ddit.tct.util.MyBatisUtil;

public class BoardHomeDaoImpl implements IBoardHomeDao {

  private static IBoardHomeDao dao;

  private BoardHomeDaoImpl() {}

  public static IBoardHomeDao getInstance() {
    if (dao == null) dao = new BoardHomeDaoImpl();
    return dao;
  }

  @Override
  public int getListCount(PageInfo pinfo) {
    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      return session.selectOne("boardHome.getListCount", pinfo);
    }
  }

  @Override
  public List<BoardHomePostVO> pageByList(PageInfo pinfo) {
    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      return session.selectList("boardHome.pageByList", pinfo);
    }
  }

  @Override
  public List<BoardHomePostVO> selectNoticeTop(int noticeLimit) {
    try (SqlSession session = MyBatisUtil.getSqlSession()) {
      return session.selectList("boardHome.selectNoticeTop", noticeLimit);
    }
  }
}
