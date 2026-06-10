package kr.or.ddit.tct.mypage.dao;

import java.util.List;
import kr.or.ddit.tct.mypage.dto.vo.PayHistoryDtoVO;

public interface IMyPageDao {
	
    List<PayHistoryDtoVO> selectPayHistoryByUserId(String userId);
    
    
}
