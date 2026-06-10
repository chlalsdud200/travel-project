package kr.or.ddit.tct.admin.prod.packageitem.dto;

import lombok.Data;

@Data
public class PackageItemRowDto {
  private String byDate;   // DB가 VARCHAR2라 String
  private String itemId;
  private String hotelId;  // nullable

  public PackageItemRowDto() {}

  public PackageItemRowDto(String byDate, String itemId, String hotelId) {
    this.byDate = byDate;
    this.itemId = itemId;
    this.hotelId = hotelId;
  }
}
