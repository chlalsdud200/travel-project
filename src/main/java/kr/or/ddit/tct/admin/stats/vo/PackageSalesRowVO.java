package kr.or.ddit.tct.admin.stats.vo;

/**
 * PackageSalesRowVO
 * - 패키지별 판매 리스트 행
 */
public class PackageSalesRowVO {

  private String packageTitle;  // 패키지명
  private String regTitle;      // 등록상품명 (추가)
  private String startDt;       // 출발일 (YYYY-MM-DD)
  private long regPrice;        // 등록상품 가격
  private long salesQty;        // 판매 건수 (ORDER_QTY 합계) - buyerCnt 대체
  private int orderCnt;         // 주문 건수
  private long soldAmt;         // 총 판매 금액
  private String regId;         // 등록 ID

  public PackageSalesRowVO() {}

  public String getPackageTitle() {
    return packageTitle;
  }
  public void setPackageTitle(String packageTitle) {
    this.packageTitle = packageTitle;
  }

  public String getRegTitle() {
    return regTitle;
  }
  public void setRegTitle(String regTitle) {
    this.regTitle = regTitle;
  }

  public String getStartDt() {
    return startDt;
  }
  public void setStartDt(String startDt) {
    this.startDt = startDt;
  }

  public long getRegPrice() {
    return regPrice;
  }
  public void setRegPrice(long regPrice) {
    this.regPrice = regPrice;
  }

  public long getSalesQty() {
    return salesQty;
  }
  public void setSalesQty(long salesQty) {
    this.salesQty = salesQty;
  }

  public int getOrderCnt() {
    return orderCnt;
  }
  public void setOrderCnt(int orderCnt) {
    this.orderCnt = orderCnt;
  }

  public long getSoldAmt() {
    return soldAmt;
  }
  public void setSoldAmt(long soldAmt) {
    this.soldAmt = soldAmt;
  }

  public String getRegId() {
    return regId;
  }
  public void setRegId(String regId) {
    this.regId = regId;
  }

  @Override
  public String toString() {
    return "PackageSalesRowVO{" +
           "packageTitle='" + packageTitle + "', " +
           "regTitle='" + regTitle + "', " +
           "startDt='" + startDt + "', " +
           "regPrice=" + regPrice + ", " +
           "salesQty=" + salesQty + ", " +
           "orderCnt=" + orderCnt + ", " +
           "soldAmt=" + soldAmt + ", " +
           "regId='" + regId + "'" +
           "}";
  }
}