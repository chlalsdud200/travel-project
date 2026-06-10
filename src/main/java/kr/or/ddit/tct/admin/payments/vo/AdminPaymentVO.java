package kr.or.ddit.tct.admin.payments.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AdminPaymentVO {

    private String orderNo;
    private String userId;
    private String userName;

    private String regId;
    private String regTitle;

    private int payAmount;
    private String paidAt;       // 화면 표시용(문자열)
    private String payStatus;    // 결제상태
    private String cancelRefund; // "취소"/"환불"/"-"
    

}