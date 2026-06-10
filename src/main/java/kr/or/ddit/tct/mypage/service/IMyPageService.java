package kr.or.ddit.tct.mypage.service;

import java.util.List;
import kr.or.ddit.tct.mypage.dto.vo.PayHistoryDtoVO;

public interface IMyPageService {
	
    List<PayHistoryDtoVO> getPayHistory(String userId);
    
}
