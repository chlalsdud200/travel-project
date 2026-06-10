package kr.or.ddit.tct.admin.stats.vo;

/**
 * PackageComparisonVO
 * - 패키지 비교 분석용
 */
public class PackageComparisonVO {

  private String period;
  private String packageTitle;
  
  // ✅ 추가: 패키지별 구분을 위한 필드
  private String seriesKey;        // 패키지 ID 또는 "TOTAL"
  private String seriesLabel;      // 패키지명 또는 "전체 총매출"
  
  private long soldAmt;
  private int orderCnt;

  public PackageComparisonVO() {}

  public String getPeriod() {
    return period;
  }
  public void setPeriod(String period) {
    this.period = period;
  }

  public String getPackageTitle() {
    return packageTitle;
  }
  public void setPackageTitle(String packageTitle) {
    this.packageTitle = packageTitle;
  }

  // ✅ 추가 Getter & Setter
  public String getSeriesKey() {
    return seriesKey;
  }
  public void setSeriesKey(String seriesKey) {
    this.seriesKey = seriesKey;
  }

  public String getSeriesLabel() {
    return seriesLabel;
  }
  public void setSeriesLabel(String seriesLabel) {
    this.seriesLabel = seriesLabel;
  }

  public long getSoldAmt() {
    return soldAmt;
  }
  public void setSoldAmt(long soldAmt) {
    this.soldAmt = soldAmt;
  }

  public int getOrderCnt() {
    return orderCnt;
  }
  public void setOrderCnt(int orderCnt) {
    this.orderCnt = orderCnt;
  }
}