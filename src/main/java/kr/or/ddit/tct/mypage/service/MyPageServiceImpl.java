package kr.or.ddit.tct.mypage.service;

import java.util.Collections;
import java.util.List;

import kr.or.ddit.tct.mypage.dao.IMyPageDao;
import kr.or.ddit.tct.mypage.dao.MyPageDaoImpl;
import kr.or.ddit.tct.mypage.dto.vo.PayHistoryDtoVO;

public class MyPageServiceImpl implements IMyPageService {

    private static IMyPageService service = new MyPageServiceImpl();
    private final IMyPageDao dao = MyPageDaoImpl.getInstance();

    private MyPageServiceImpl() {}

    public static IMyPageService getInstance() {
        return service;
    }

    @Override
    public List<PayHistoryDtoVO> getPayHistory(String userId) {
        if (userId == null || userId.isBlank()) return Collections.emptyList();
        return dao.selectPayHistoryByUserId(userId);
    }
}
