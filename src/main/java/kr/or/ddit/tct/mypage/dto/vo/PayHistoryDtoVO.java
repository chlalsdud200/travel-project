package kr.or.ddit.tct.mypage.dto.vo;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

/**
 * 마이페이지 결제(구매)내역 목록 DTO
 * - ORDERS / ORDER_ITEM / PAYMENT / REGISTER_PROD / PACKAGES / (P_THEME, IMG_*) 조인 결과
 */
@Data               // Getter, Setter, RequiredArgsConstructor, ToString, EqualsAndHashCode 자동 생성
@NoArgsConstructor  // 파라미터가 없는 기본 생성자 생성 (MyBatis 등 프레임워크 리플렉션용)
@AllArgsConstructor // 모든 필드를 파라미터로 받는 생성자 생성
public class PayHistoryDtoVO {

    /* ===== 주문 ===== */
    private String orderNo;
    private String orderStatus;
    private String orderDate; // YYYY-MM-DD

    /* ===== 결제 ===== */
    private int payNo;
    private String payStatus;
    private String payMethod;
    private int payAmount;
    private String paidAt; // YYYY-MM-DD

    /* ===== 상품/옵션 ===== */
    private String regId;
    private String regTitle;
    private String startDt; // YYYY-MM-DD
    private String endDt;   // YYYY-MM-DD
    private int orderQty;   // 인원수(=수량)
    private int unitPrice;
    private int itemTotal;

    /* ===== 패키지/분류 ===== */
    private String pkgId;
    private String packageTitle;
    private String themeTitle;
    private String ctryName;
    private String locName;

    /* ===== 썸네일(있으면) ===== */
    private String imgPath;
    private String originName;
    
}