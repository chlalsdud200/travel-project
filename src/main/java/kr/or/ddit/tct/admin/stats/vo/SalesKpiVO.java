package kr.or.ddit.tct.admin.stats.vo;

public class SalesKpiVO {

  private long thisPaidAmt;       // 이번달 총매출(PAID)
  private long prevPaidAmt;       // 전월 총매출(PAID)
  private long thisRefundReqAmt;  // 이번달 환불요청액(REQUESTED)
  private int  thisPaidCnt;       // 이번달 결제건수(PAID)

  public long getThisPaidAmt() {
    return thisPaidAmt;
  }
  public void setThisPaidAmt(long thisPaidAmt) {
    this.thisPaidAmt = thisPaidAmt;
  }

  public long getPrevPaidAmt() {
    return prevPaidAmt;
  }
  public void setPrevPaidAmt(long prevPaidAmt) {
    this.prevPaidAmt = prevPaidAmt;
  }

  public long getThisRefundReqAmt() {
    return thisRefundReqAmt;
  }
  public void setThisRefundReqAmt(long thisRefundReqAmt) {
    this.thisRefundReqAmt = thisRefundReqAmt;
  }

  public int getThisPaidCnt() {
    return thisPaidCnt;
  }
  public void setThisPaidCnt(int thisPaidCnt) {
    this.thisPaidCnt = thisPaidCnt;
  }
}
