package kr.or.ddit.tct.admin.payments.vo;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@NoArgsConstructor  // 기본 생성자 대체 public AdminPaymentSearchVO() {}
@AllArgsConstructor // 모든 필드 생성자 대체 public AdminPaymentSearchVO(status, from, ...)
public class AdminPaymentSearchVO {

    private String status;
    private String from;
    private String to;
    private int offset;
    private int limit;

}