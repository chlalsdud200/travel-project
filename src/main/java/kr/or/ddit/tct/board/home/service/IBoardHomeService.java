package kr.or.ddit.tct.board.home.service;

import java.util.List;

import kr.or.ddit.tct.board.home.vo.BoardHomePostVO;
import kr.or.ddit.tct.board.vo.PageInfo;

/**
 */
public interface IBoardHomeService {

  List<BoardHomePostVO> readPaging(PageInfo pinfo);

  List<BoardHomePostVO> selectNoticeTop(int noticeLimit);
}
