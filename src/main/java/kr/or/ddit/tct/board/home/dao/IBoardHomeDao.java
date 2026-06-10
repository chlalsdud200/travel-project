package kr.or.ddit.tct.board.home.dao;

import java.util.List;

import kr.or.ddit.tct.board.home.vo.BoardHomePostVO;
import kr.or.ddit.tct.board.vo.PageInfo;

public interface IBoardHomeDao {

  int getListCount(PageInfo pinfo);

  List<BoardHomePostVO> pageByList(PageInfo pinfo);

  List<BoardHomePostVO> selectNoticeTop(int noticeLimit);
}
