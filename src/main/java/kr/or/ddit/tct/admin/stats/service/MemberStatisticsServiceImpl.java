package kr.or.ddit.tct.admin.stats.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.or.ddit.tct.admin.stats.dao.IMemberStatisticsDao;
import kr.or.ddit.tct.admin.stats.dao.MemberStatisticsDaoImpl;
import kr.or.ddit.tct.admin.stats.vo.DistItemVO;

/*
  MemberStatisticsServiceImpl

  역할
  - DAO를 여러 번 호출하여 "대시보드용 데이터 묶음"을 구성
  - Controller는 이 서비스를 호출하고, 서비스 결과를 JSON으로 응답함
  - JS는 JSON의 key(예: kpi, trendJoiners 등)를 기준으로 화면을 렌더링함

  - dao.kpiTotalMembers()
    dao: DAO 객체
    kpiTotalMembers: DAO가 제공하는 메서드(= DB 조회)
*/
public class MemberStatisticsServiceImpl implements IMemberStatisticsService {

  /*
    싱글턴 패턴
    - getInstance()로 1개의 서비스 객체를 공유
  */
  private static MemberStatisticsServiceImpl instance;
  public static MemberStatisticsServiceImpl getInstance() {
    if (instance == null) instance = new MemberStatisticsServiceImpl();
    return instance;
  }

  /*
    dao 필드
    - DAO 구현체 싱글턴을 주입(획득)
    - MemberStatisticsDaoImpl.getInstance(): 클래스의 static 메서드 호출
  */
  private final IMemberStatisticsDao dao = MemberStatisticsDaoImpl.getInstance();

  private MemberStatisticsServiceImpl() {}

  @Override
  public Map<String, Object> getMemberStatsDashboard(Map<String, Object> param) {

    /*
      result Map
      - 최종 JSON의 최상위 객체가 됨
      - JS에서 data.kpi, data.trendJoiners 등으로 접근함
    */
    Map<String, Object> result = new HashMap<>();

    // KPI
    Map<String, Object> kpi = new HashMap<>();

    /*
      dao.kpiAdminMembers() 호출 이유
      - KPI 카드에서 관리자 수가 필요할 때 사용 가능
      - 현재 JS에서 쓰지 않아도 응답에 포함 가능
    */
    kpi.put("admin", dao.kpiAdminMembers());

    /* 전체 회원 수 KPI */
    kpi.put("total", dao.kpiTotalMembers());

    /* 탈퇴 회원 수 KPI */
    kpi.put("withdrawn", dao.kpiWithdrawnMembers());

    /* 최근 7일 신규 KPI */
    kpi.put("new7days", dao.kpiNewMembersLast7Days());

    /*
      기간 내 활성 KPI
      - param(startDate/endDate/unit/type)을 SQL에 전달해야 하므로 param을 그대로 넘김
    */
    kpi.put("activeRange", dao.kpiActiveMembersByRange(param));

    result.put("kpi", kpi);

    // Charts / Table
    /*
      trendJoiners 호출 이유
      - 가입 추이 바 차트에 label/value 리스트가 필요
    */
    result.put("trendJoiners", dao.trendJoiners(param));

    /*
      trendActive 호출 이유
      - 활성 추이 차트에 label/value 리스트가 필요
      - 현재 JS에서 직접 사용하지 않더라도 응답에 포함 가능
    */
    result.put("trendActive", dao.trendActive(param));

    /*
      tablePeriodNewActive 호출 이유
      - 표 영역에서 period/newMembers/activeMembers 행 리스트가 필요
      - JS에서 data.tablePeriod로 렌더링
    */
    result.put("tablePeriod", dao.tablePeriodNewActive(param));

    // Donuts
    /*
      distMemberStatus 호출 이유
      - 회원상태 도넛(활성/신규/비활동/탈퇴 등) 렌더링에 필요
    */
    result.put("distMemberStatus", dao.distMemberStatus(param));

    /* 연령대 도넛 */
    result.put("distAge", dao.distAge(param));

    /* 금액대 도넛 */
    result.put("distRevenue", dao.distRevenue(param));

    return result;
  }
  
  
  @Override
  public List<DistItemVO> distMemberStatus3(Map<String, Object> param) {
    return dao.distMemberStatus3(param);
  }

}
