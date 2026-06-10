package kr.or.ddit.tct.comm.vo;

import lombok.Data;

/**
 * DdayPopupVO
 * - 출발 임박 팝업(출발 0~5일)에서 상단에 보여줄 "여행 요약 정보" 1건을 담는 VO
 * - 존재이유: 프론트(tctWidget.jsp)가 필요한 필드만 간단히 받도록, SQL 결과를 한 객체로 묶기 위함
 */
@Data
public class DdayPopupVO {

  private String orderNo;      // : 어떤 주문의 여행인지(주문번호) 표시 + 체크리스트를 "주문별"로 저장할 키로 쓰기 위함
  private String regId;        // : 등록상품번호(상품 식별자) 표시 + 상세페이지 이동 등 확장 여지 확보
  private String regTitle;     // : 유저가 알아보기 쉬운 "상품명" 표시를 위함
  private String packageTitle; // : 패키지 타이틀(패키지 재사용성/기간별 등록상품 변형 구조 설명 포인트)
  private String startYmd;     // : 출발일(YYYY-MM-DD) - 프론트에서 그대로 출력하기 위함
  private String endYmd;       // : 도착일(YYYY-MM-DD) - 기간 표시를 위함
  private int totalPrice;      // : 결제 총가격(원) - 팝업에서 핵심 요약 정보로 보여주기 위함
  private int dday;            // : 출발일까지 남은 일수(D-day) - 서버에서 계산해 프론트 단순화 목적
  private String hotelName;    // : 대표 호텔명 - 호텔이 여러 개면 "대표 + 외 N곳" 형태 요약의 기준이 됨
  private String hotelTel;     // : 대표 호텔 전화번호 - 호텔 문의/정보 확인용으로 노출하기 위함
  private int hotelCnt;        // : 호텔 개수 - 대표호텔 외 몇 곳인지 요약 표시에 필요
  private String userId; // 숨김키를 회원별로 만들기 위해 프론트에 내려주는 값

  
}
