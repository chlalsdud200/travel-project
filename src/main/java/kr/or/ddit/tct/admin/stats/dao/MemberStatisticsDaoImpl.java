package kr.or.ddit.tct.admin.stats.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.tct.admin.stats.vo.DistItemVO;
import kr.or.ddit.tct.admin.stats.vo.PeriodNewActiveVO;
import kr.or.ddit.tct.admin.stats.vo.TrendPointVO;
import kr.or.ddit.tct.util.MyBatisUtil;

/*
  MemberStatisticsDaoImpl

  역할
  - MyBatis SqlSession을 열고 mapper XML의 SQL을 실행하는 역할
  - "어떤 SQL을 실행할지"는 statement id로 지정됨

  statement id 규칙
  - NS = "memberStatistics."
  - 예: NS + "trendJoiners"  → "memberStatistics.trendJoiners"
  - mapper XML의 <mapper namespace="memberStatistics"> 와 <select id="trendJoiners">를 합친 식별자

  - ss.selectList(NS + "trendJoiners", param)
    ss: SqlSession 객체
    selectList: SqlSession이 제공하는 메서드
*/
public class MemberStatisticsDaoImpl implements IMemberStatisticsDao {

  private static final String NS = "memberStatistics.";

  /*
    싱글턴 패턴
    - getInstance()로 1개의 객체를 공유
    - 클래스명.getInstance(): static 메서드 호출
  */
  private static MemberStatisticsDaoImpl instance;
  public static MemberStatisticsDaoImpl getInstance() {
    if (instance == null) instance = new MemberStatisticsDaoImpl();
    return instance;
  }

  private MemberStatisticsDaoImpl() {}

  // KPI
  @Override
  public int kpiAdminMembers() {
    /*
      try-with-resources
      - SqlSession을 열고 자동으로 close 처리
      - selectOne은 결과 1개를 기대하는 조회
    */
    try (SqlSession ss = MyBatisUtil.getSqlSession()) {
      return ss.selectOne(NS + "kpiAdminMembers");
    }
  }

  @Override
  public int kpiTotalMembers() {
    try (SqlSession ss = MyBatisUtil.getSqlSession()) {
      return ss.selectOne(NS + "kpiTotalMembers");
    }
  }

  @Override
  public int kpiWithdrawnMembers() {
    try (SqlSession ss = MyBatisUtil.getSqlSession()) {
      return ss.selectOne(NS + "kpiWithdrawnMembers");
    }
  }

  @Override
  public int kpiNewMembersLast7Days() {
    try (SqlSession ss = MyBatisUtil.getSqlSession()) {
      return ss.selectOne(NS + "kpiNewMembersLast7Days");
    }
  }

  @Override
  public int kpiActiveMembersByRange(Map<String, Object> param) {
    /*
      param Map
      - mapper에서 #{startDate}, #{endDate}, #{unit}, #{type}로 사용
      - key 이름 불일치 시 조회 결과가 0 또는 오류가 날 수 있음
    */
    try (SqlSession ss = MyBatisUtil.getSqlSession()) {
      return ss.selectOne(NS + "kpiActiveMembersByRange", param);
    }
  }

  // Trend / Table
  @Override
  public List<TrendPointVO> trendJoiners(Map<String, Object> param) {
    /*
      selectList
      - 결과가 여러 행인 조회
      - resultMap으로 TrendPointVO(label/value) 리스트로 매핑됨
    */
    try (SqlSession ss = MyBatisUtil.getSqlSession()) {
      return ss.selectList(NS + "trendJoiners", param);
    }
  }

  @Override
  public List<TrendPointVO> trendActive(Map<String, Object> param) {
    try (SqlSession ss = MyBatisUtil.getSqlSession()) {
      return ss.selectList(NS + "trendActive", param);
    }
  }

  @Override
  public List<PeriodNewActiveVO> tablePeriodNewActive(Map<String, Object> param) {
    /*
      PeriodNewActiveVO
      - period/newMembers/activeMembers 3개 필드를 받는 테이블용 VO
    */
    try (SqlSession ss = MyBatisUtil.getSqlSession()) {
      return ss.selectList(NS + "tablePeriodNewActive", param);
    }
  }

  // Donut
  @Override
  public List<DistItemVO> distMemberStatus(Map<String, Object> param) {
    try (SqlSession ss = MyBatisUtil.getSqlSession()) {
      return ss.selectList(NS + "distMemberStatus", param);
    }
  }

  @Override
  public List<DistItemVO> distAge(Map<String, Object> param) {
    try (SqlSession ss = MyBatisUtil.getSqlSession()) {
      return ss.selectList(NS + "distAge", param);
    }
  }

  @Override
  public List<DistItemVO> distRevenue(Map<String, Object> param) {
    try (SqlSession ss = MyBatisUtil.getSqlSession()) {
      return ss.selectList(NS + "distRevenue", param);
    }
  }
  
  @Override
  public List<DistItemVO> distMemberStatus3(Map<String, Object> param) {
    SqlSession ss = null;
    try {
      ss = MyBatisUtil.getSqlSession();
      return ss.selectList("memberStatistics.distMemberStatus3", param);
    } finally {
      if (ss != null) ss.close();
    }
  }

}
