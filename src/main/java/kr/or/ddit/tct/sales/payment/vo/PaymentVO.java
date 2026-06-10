package kr.or.ddit.tct.sales.payment.vo;

import java.util.Date;

public class PaymentVO {

	private int payNo; /*  */
	private String orderNo; /*  */
	private String merchantUid; /*  */
	private String impUid; /*  */
	private String payMethod; /*  */
	private int payAmount; /*  */
	private String payStatus; /*  */
	private Date requestAt; /*  */
	private Date paidAt; /*  */
	private String failReason; /*  */
	
	public int getPayNo() {
		return payNo;
	}
	public void setPayNo(int payNo) {
		this.payNo = payNo;
	}
	public String getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}
	public String getMerchantUid() {
		return merchantUid;
	}
	public void setMerchantUid(String merchantUid) {
		this.merchantUid = merchantUid;
	}
	public String getImpUid() {
		return impUid;
	}
	public void setImpUid(String impUid) {
		this.impUid = impUid;
	}
	public String getPayMethod() {
		return payMethod;
	}
	public void setPayMethod(String payMethod) {
		this.payMethod = payMethod;
	}
	public int getPayAmount() {
		return payAmount;
	}
	public void setPayAmount(int payAmount) {
		this.payAmount = payAmount;
	}
	public String getPayStatus() {
		return payStatus;
	}
	public void setPayStatus(String payStatus) {
		this.payStatus = payStatus;
	}
	public Date getRequestAt() {
		return requestAt;
	}
	public void setRequestAt(Date requestAt) {
		this.requestAt = requestAt;
	}
	public Date getPaidAt() {
		return paidAt;
	}
	public void setPaidAt(Date paidAt) {
		this.paidAt = paidAt;
	}
	public String getFailReason() {
		return failReason;
	}
	public void setFailReason(String failReason) {
		this.failReason = failReason;
	}
	
	@Override
	public String toString() {
		return "PaymentVO [payNo=" + payNo + ", orderNo=" + orderNo + ", merchantUid=" + merchantUid + ", impUid="
				+ impUid + ", payMethod=" + payMethod + ", payAmount=" + payAmount + ", payStatus=" + payStatus
				+ ", requestAt=" + requestAt + ", paidAt=" + paidAt + ", failReason=" + failReason + "]";
	}
	
	
}
