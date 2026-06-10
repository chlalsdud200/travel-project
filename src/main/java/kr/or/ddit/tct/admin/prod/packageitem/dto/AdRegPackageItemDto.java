package kr.or.ddit.tct.admin.prod.packageitem.dto;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;

/**
 * 패키지 아이템 등록을 위한 DTO
 */
@Data
public class AdRegPackageItemDto {

    private Header header;
    private List<Item> items = new ArrayList<>();

    // ===== 패키지 헤더 내부 클래스 =====
    @Data
    public static class Header {
        private String regId;
        private String packageId;
        private String packageTitle;
        private String themeId;
        private String themeTitle;
    }

    // ===== 아이템 Row 내부 클래스 =====
    @Data
    public static class Item {
        private String byDate;
        private String itemId;
        private String itemTitle;
        private String locId;
        private String locName;
        private String ctryId;
        private String ctryName;
    }
}