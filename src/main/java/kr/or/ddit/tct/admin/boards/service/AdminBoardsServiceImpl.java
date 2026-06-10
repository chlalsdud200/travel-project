package kr.or.ddit.tct.admin.boards.service;

import java.util.List;

import kr.or.ddit.tct.admin.boards.dao.AdminBoardsDaoImpl;
import kr.or.ddit.tct.admin.boards.dao.IAdminBoardsDao;
import kr.or.ddit.tct.admin.boards.vo.AdminBoardKeyVO;
import kr.or.ddit.tct.admin.boards.vo.AdminBoardPostVO;
import kr.or.ddit.tct.admin.boards.vo.AdminBoardSearchVO;

public class AdminBoardsServiceImpl implements IAdminBoardsService {

  private static IAdminBoardsService service;
  private final IAdminBoardsDao dao = AdminBoardsDaoImpl.getInstance();

  private AdminBoardsServiceImpl() {}

  public static IAdminBoardsService getInstance() {
    if (service == null) service = new AdminBoardsServiceImpl();
    return service;
  }

  @Override
  public int count(AdminBoardSearchVO search) {
    return dao.count(search);
  }

  @Override
  public List<AdminBoardPostVO> selectList(AdminBoardSearchVO search) {
    return dao.selectList(search);
  }

  @Override
  public AdminBoardPostVO selectDetail(AdminBoardKeyVO key) {
    return dao.selectDetail(key);
  }
  @Override
  public int softDelete(String postType, int postNo, String adminId) {
    // [존재이유] NOTICE도 실제 테이블은 QNA_BOARD라서 QNA 쪽 로직을 타야 한다.
    if ("REVIEW".equals(postType)) return dao.softDeleteReview(postNo, adminId);
    return dao.softDeleteQna(postNo, adminId); // QNA + NOTICE
  }

  @Override
  public int hardDelete(String postType, int postNo) {
    // [존재이유] NOTICE도 실제 테이블은 QNA_BOARD
    if ("REVIEW".equals(postType)) return dao.hardDeleteReview(postNo);
    return dao.hardDeleteQna(postNo); // QNA + NOTICE
  }


}
