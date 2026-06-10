package kr.or.ddit.tct.sales.payment.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class CancelableInfoVO {	//취소 가능 정보 VO
  private String orderNo;
  private String userId;
  private String payStatus;
  private int payNO;
  private int payAmount;
}
