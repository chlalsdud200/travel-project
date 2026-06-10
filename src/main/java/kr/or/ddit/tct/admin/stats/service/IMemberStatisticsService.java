package kr.or.ddit.tct.admin.stats.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.tct.admin.stats.vo.DistItemVO;

/*
  IMemberStatisticsService

  역할
  - Controller가 호출할 서비스 규격 정의
  - 구현체(MemberStatisticsServiceImpl)에서 DAO 호출 결과를 한 번에 묶어 반환함
*/
public interface IMemberStatisticsService {

  /*
    getMemberStatsDashboard
    - 입력: 조회 조건(param)
    - 출력: 화면이 한 번에 필요한 데이터 묶음(Map)
  */
  Map<String, Object> getMemberStatsDashboard(Map<String, Object> param);
  
  List<DistItemVO> distMemberStatus3(Map<String, Object> param);

}
