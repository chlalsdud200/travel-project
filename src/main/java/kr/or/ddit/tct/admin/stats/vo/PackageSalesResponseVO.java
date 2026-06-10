package kr.or.ddit.tct.admin.stats.vo;

import java.util.ArrayList;
import java.util.List;

/**
 * PackageSalesResponseVO
 * - API 응답 JSON 구조
 */
public class PackageSalesResponseVO {

  private int page;
  private int size;
  private int totalCount;
  private List<PackageSalesRowVO> list = new ArrayList<>();

  public PackageSalesResponseVO() {}

  public int getPage() {
    return page;
  }
  public void setPage(int page) {
    this.page = page;
  }

  public int getSize() {
    return size;
  }
  public void setSize(int size) {
    this.size = size;
  }

  public int getTotalCount() {
    return totalCount;
  }
  public void setTotalCount(int totalCount) {
    this.totalCount = totalCount;
  }

  public List<PackageSalesRowVO> getList() {
    return list;
  }
  public void setList(List<PackageSalesRowVO> list) {
    this.list = list;
  }
}