package kr.or.ddit.tct.sales.payment.dto;

import lombok.Data;

@Data
public class PayCreateReqDto {
	private String regId;
	private int adultCnt;
	private int amount;
}
