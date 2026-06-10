package kr.or.ddit.tct.mypage.dao;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import kr.or.ddit.tct.mypage.dto.vo.PayHistoryDtoVO;
import kr.or.ddit.tct.util.MyBatisUtil;

public class MyPageDaoImpl implements IMyPageDao {

    private static IMyPageDao dao = new MyPageDaoImpl();
    private MyPageDaoImpl() {}

    public static IMyPageDao getInstance() {
        return dao;
    }

    @Override
    public List<PayHistoryDtoVO> selectPayHistoryByUserId(String userId) {
        // try (...) 안에서 session을 열었으므로, 이 블록이 끝나면(성공하든 에러나든) 자동 close 
        try (SqlSession session = MyBatisUtil.getSqlSession()) {
            return session.selectList("payment.selectPayHistoryByUserId", userId);
        } catch (Exception e) {
            // 에러 발생 시 로그 출력
            e.printStackTrace(); 
            // 에러가 났더라도 메서드 반환 타입(List)을 맞춰줘야 하므로 null을 리턴
            // (필요에 따라 return new ArrayList<>(); 처럼 빈 리스트를 줄 수도 있음
            return null; 
        }
    }
}