package kr.or.ddit.tct.admin.stats.vo;

public class RegCompareRowVO {
  private String period;
  private String seriesKey;    // REG_ID 또는 TOTAL
  private String seriesLabel;  // REG_TITLE 또는 "패키지 총매출"
  private long soldAmt;
  private long orderCnt;

  public String getPeriod() { return period; }
  public void setPeriod(String period) { this.period = period; }

  public String getSeriesKey() { return seriesKey; }
  public void setSeriesKey(String seriesKey) { this.seriesKey = seriesKey; }

  public String getSeriesLabel() { return seriesLabel; }
  public void setSeriesLabel(String seriesLabel) { this.seriesLabel = seriesLabel; }

  public long getSoldAmt() { return soldAmt; }
  public void setSoldAmt(long soldAmt) { this.soldAmt = soldAmt; }

  public long getOrderCnt() { return orderCnt; }
  public void setOrderCnt(long orderCnt) { this.orderCnt = orderCnt; }
}
