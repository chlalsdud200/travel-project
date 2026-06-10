package kr.or.ddit.tct.admin.boards.dao;

import java.util.List;
import kr.or.ddit.tct.admin.boards.vo.AdminBoardKeyVO;
import kr.or.ddit.tct.admin.boards.vo.AdminBoardPostVO;
import kr.or.ddit.tct.admin.boards.vo.AdminBoardSearchVO;

public interface IAdminBoardsDao {
  int count(AdminBoardSearchVO search);
  List<AdminBoardPostVO> selectList(AdminBoardSearchVO search);
  AdminBoardPostVO selectDetail(AdminBoardKeyVO key);

  int softDeleteQna(int postNo, String adminId);
  int softDeleteReview(int postNo, String adminId);

  int hardDeleteQna(int postNo);
  int hardDeleteReview(int postNo);
}
