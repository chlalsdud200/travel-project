package kr.or.ddit.tct.comm.vo;

import lombok.Data;

@Data
public class DdayTripVO {

  private String regId;     // : 클릭/이동(상세페이지 등)할 때 어떤 상품인지 식별자 필요
  private String regTitle;  // : 위젯 카드에 보여줄 "상품명"
  private String startYmd;  // : JS에서 달력을 그릴 때 Date로 파싱하기 쉬운 'YYYY-MM-DD'
  private int dday;         // : 카드 상단에 D-숫자 표시(서버가 계산하면 프론트가 단순해짐)
}
