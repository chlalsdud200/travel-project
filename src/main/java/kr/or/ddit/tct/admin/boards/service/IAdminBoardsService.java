package kr.or.ddit.tct.admin.boards.service;

import java.util.List;
import kr.or.ddit.tct.admin.boards.vo.AdminBoardKeyVO;
import kr.or.ddit.tct.admin.boards.vo.AdminBoardPostVO;
import kr.or.ddit.tct.admin.boards.vo.AdminBoardSearchVO;

public interface IAdminBoardsService {
  int count(AdminBoardSearchVO search);
  List<AdminBoardPostVO> selectList(AdminBoardSearchVO search);
  AdminBoardPostVO selectDetail(AdminBoardKeyVO key);

  int softDelete(String postType, int postNo, String adminId);
  int hardDelete(String postType, int postNo);
}
