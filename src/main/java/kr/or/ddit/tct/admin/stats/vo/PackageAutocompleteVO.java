package kr.or.ddit.tct.admin.stats.vo;

/**
 * PackageAutocompleteVO
 * - 패키지명 자동완성용
 */
public class PackageAutocompleteVO {

  private String packageId;
  private String packageTitle;

  public PackageAutocompleteVO() {}

  public String getPackageId() {
    return packageId;
  }
  public void setPackageId(String packageId) {
    this.packageId = packageId;
  }

  public String getPackageTitle() {
    return packageTitle;
  }
  public void setPackageTitle(String packageTitle) {
    this.packageTitle = packageTitle;
  }
}