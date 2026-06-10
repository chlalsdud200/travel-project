package kr.or.ddit.tct.admin.stats.vo;

public class PackageRegItemVO {
  private String regId;
  private String regTitle;
  private String startDt;

  private long soldAmt;   // ✅ 기간 내 매출(원)
  private long orderCnt;  // ✅ 기간 내 주문건수

  public String getRegId() { return regId; }
  public void setRegId(String regId) { this.regId = regId; }

  public String getRegTitle() { return regTitle; }
  public void setRegTitle(String regTitle) { this.regTitle = regTitle; }

  public String getStartDt() { return startDt; }
  public void setStartDt(String startDt) { this.startDt = startDt; }

  public long getSoldAmt() { return soldAmt; }
  public void setSoldAmt(long soldAmt) { this.soldAmt = soldAmt; }

  public long getOrderCnt() { return orderCnt; }
  public void setOrderCnt(long orderCnt) { this.orderCnt = orderCnt; }
}
