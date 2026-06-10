package kr.or.ddit.tct.sales.refund.vo;

import java.util.Date;

public class RefundVO {

	private int refundNo; /*  */
	private int payNo; /*  */
	private int refundAmount; /*  */
	private String refundStatus; /*  */
	private Date refundDate; /*  */
	private String reason; /*  */
	
	public int getRefundNo() {
		return refundNo;
	}
	public void setRefundNo(int refundNo) {
		this.refundNo = refundNo;
	}
	public int getPayNo() {
		return payNo;
	}
	public void setPayNo(int payNo) {
		this.payNo = payNo;
	}
	public int getRefundAmount() {
		return refundAmount;
	}
	public void setRefundAmount(int refundAmount) {
		this.refundAmount = refundAmount;
	}
	public String getRefundStatus() {
		return refundStatus;
	}
	public void setRefundStatus(String refundStatus) {
		this.refundStatus = refundStatus;
	}
	public Date getRefundDate() {
		return refundDate;
	}
	public void setRefundDate(Date refundDate) {
		this.refundDate = refundDate;
	}
	public String getReason() {
		return reason;
	}
	public void setReason(String reason) {
		this.reason = reason;
	}
	
	@Override
	public String toString() {
		return "RefundVO [refundNo=" + refundNo + ", payNo=" + payNo + ", refundAmount=" + refundAmount
				+ ", refundStatus=" + refundStatus + ", refundDate=" + refundDate + ", reason=" + reason + "]";
	}
	
	
}
