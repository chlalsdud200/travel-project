package kr.or.ddit.tct.sales.cart.dto.vo;

/**
 * 장바구니 화면용 DTO
 * - CART(단건) + REGISTER_PROD/패키지/지역/이미지 조인 결과를 담는다.
 */
public class CartDetailDtoVO {

    // REGISTER_PROD의 DATE 컬럼은 LocalDate로 받는 편이 안전합니다(프로젝트 내 기존 DTO와 맞춤).
    private java.time.LocalDate startDt;
    private java.time.LocalDate endDt;

    private String userId;
    private String regId;
    private int peopleCnt;

    private String regTitle;
    private int regPrice;

    private String ctryName;
    private String locName;

    private String imgPath;
    private String originName;

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getRegId() {
        return regId;
    }

    public void setRegId(String regId) {
        this.regId = regId;
    }

    public int getPeopleCnt() {
        return peopleCnt;
    }

    public void setPeopleCnt(int peopleCnt) {
        this.peopleCnt = peopleCnt;
    }

    public String getRegTitle() {
        return regTitle;
    }

    public void setRegTitle(String regTitle) {
        this.regTitle = regTitle;
    }

    public int getRegPrice() {
        return regPrice;
    }

    public void setRegPrice(int regPrice) {
        this.regPrice = regPrice;
    }

    public java.time.LocalDate getStartDt() {
        return startDt;
    }

    public void setStartDt(java.time.LocalDate startDt) {
        this.startDt = startDt;
    }

    public java.time.LocalDate getEndDt() {
        return endDt;
    }

    public void setEndDt(java.time.LocalDate endDt) {
        this.endDt = endDt;
    }

    public String getCtryName() {
        return ctryName;
    }

    public void setCtryName(String ctryName) {
        this.ctryName = ctryName;
    }

    public String getLocName() {
        return locName;
    }

    public void setLocName(String locName) {
        this.locName = locName;
    }

    public String getImgPath() {
        return imgPath;
    }

    public void setImgPath(String imgPath) {
        this.imgPath = imgPath;
    }

    public String getOriginName() {
        return originName;
    }

    public void setOriginName(String originName) {
        this.originName = originName;
    }

    @Override
    public String toString() {
        return "CartDetailDtoVO [userId=" + userId + ", regId=" + regId + ", peopleCnt=" + peopleCnt
                + ", regTitle=" + regTitle + ", regPrice=" + regPrice + ", startDt=" + startDt + ", endDt=" + endDt
                + ", ctryName=" + ctryName + ", locName=" + locName + ", imgPath=" + imgPath + ", originName="
                + originName + "]";
    }
}
