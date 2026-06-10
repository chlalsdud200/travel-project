package kr.or.ddit.tct.board.home.service;

import java.util.List;

import kr.or.ddit.tct.board.home.dao.BoardHomeDaoImpl;
import kr.or.ddit.tct.board.home.dao.IBoardHomeDao;
import kr.or.ddit.tct.board.home.vo.BoardHomePostVO;
import kr.or.ddit.tct.board.vo.PageInfo;

public class BoardHomeServiceImpl implements IBoardHomeService {

  private static IBoardHomeService service;
  private final IBoardHomeDao dao = BoardHomeDaoImpl.getInstance();

  private BoardHomeServiceImpl() {}

  public static IBoardHomeService getInstance() {
    if (service == null) service = new BoardHomeServiceImpl();
    return service;
  }

  // (호환용) 학원 파일 습관대로 getService()로도 접근 가능하게
  public static IBoardHomeService getService() {
    return getInstance();
  }

  /**
   * 학원 방식 그대로:
   * 1) totalRecord를 구한다
   * 2) pinfo.setTotalRecord(totalRecord)
   * 3) pinfo.getStart()/getEnd() 기반으로 pageByList 조회해서 리턴
   */
  @Override
  public List<BoardHomePostVO> readPaging(PageInfo pinfo) {
    int total = dao.getListCount(pinfo);
    pinfo.setTotalRecord(total);
    return dao.pageByList(pinfo);
  }

  @Override
  public List<BoardHomePostVO> selectNoticeTop(int noticeLimit) {
    return dao.selectNoticeTop(noticeLimit);
  }
}
