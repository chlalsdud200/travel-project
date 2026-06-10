package kr.or.ddit.tct.admin.stats.dao;

import java.util.List;
import java.util.Map;

import kr.or.ddit.tct.admin.stats.vo.DistItemVO;
import kr.or.ddit.tct.admin.stats.vo.PeriodNewActiveVO;
import kr.or.ddit.tct.admin.stats.vo.TrendPointVO;

/*
  IMemberStatisticsDao

  역할
  - DB(MyBatis mapper) 호출 규격(메서드 목록)을 정의하는 인터페이스
  - 구현체(MemberStatisticsDaoImpl)가 실제로 MyBatis selectOne/selectList를 수행함

  반환 타입 설계
  - KPI는 int
  - 차트/도넛은 label/value 형태의 VO 리스트
  - 테이블은 period/newMembers/activeMembers 형태의 VO 리스트

  - dao.kpiTotalMembers()
    dao: IMemberStatisticsDao 구현 객체
    kpiTotalMembers: 그 객체의 메서드 호출
*/
public interface IMemberStatisticsDao {

  // KPI
  int kpiAdminMembers();
  int kpiTotalMembers();
  int kpiWithdrawnMembers();
  int kpiNewMembersLast7Days();
  int kpiActiveMembersByRange(Map<String, Object> param);

  // Trend / Table
  List<TrendPointVO> trendJoiners(Map<String, Object> param);
  List<TrendPointVO> trendActive(Map<String, Object> param);
  List<PeriodNewActiveVO> tablePeriodNewActive(Map<String, Object> param);

  // Donut
  List<DistItemVO> distMemberStatus(Map<String, Object> param);
  List<DistItemVO> distAge(Map<String, Object> param);
  List<DistItemVO> distRevenue(Map<String, Object> param);
  
  List<DistItemVO> distMemberStatus3(Map<String, Object> param);

}
