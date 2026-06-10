package kr.or.ddit.tct.admin.stats.vo;

public class SalesPointVO {

  // 기간 라벨: "YYYY-MM" 또는 "YYYY-MM-DD"
  private String period;

  // 금액(원)
  private long paidAmt;        // 결제완료(PAID) 총매출
  private long refundReqAmt;   // 환불요청(REQUESTED) 총액
  private long cancelAmt;      // 취소(CANCELED) 취소액(시도금액)

  // 건수(건)
  private int paidCnt;         // 결제완료(PAID) 건수
  private int refundReqCnt;    // 환불요청(REQUESTED) 건수
  private int cancelCnt;       // 취소(CANCELED) 건수

  public String getPeriod() {
    return period;
  }
  public void setPeriod(String period) {
    this.period = period;
  }

  public long getPaidAmt() {
    return paidAmt;
  }
  public void setPaidAmt(long paidAmt) {
    this.paidAmt = paidAmt;
  }

  public long getRefundReqAmt() {
    return refundReqAmt;
  }
  public void setRefundReqAmt(long refundReqAmt) {
    this.refundReqAmt = refundReqAmt;
  }

  public long getCancelAmt() {
    return cancelAmt;
  }
  public void setCancelAmt(long cancelAmt) {
    this.cancelAmt = cancelAmt;
  }

  public int getPaidCnt() {
    return paidCnt;
  }
  public void setPaidCnt(int paidCnt) {
    this.paidCnt = paidCnt;
  }

  public int getRefundReqCnt() {
    return refundReqCnt;
  }
  public void setRefundReqCnt(int refundReqCnt) {
    this.refundReqCnt = refundReqCnt;
  }

  public int getCancelCnt() {
    return cancelCnt;
  }
  public void setCancelCnt(int cancelCnt) {
    this.cancelCnt = cancelCnt;
  }
}
