package kr.or.ddit.tct.admin.boards.vo;

public class AdminBoardSearchVO {
  private String kind;   // ALL / QNA / REVIEW
  private String stype;  // all / title / writer / content
  private String role;   // ALL / ADMIN / USER
  private String from;   // YYYY-MM-DD
  private String to;     // YYYY-MM-DD
  private String q;      // keyword

  private int startRow;  // 페이징 시작 rn
  private int endRow;    // 페이징 끝 rn

  public String getKind() { return kind; }
  public void setKind(String kind) { this.kind = kind; }

  public String getStype() { return stype; }
  public void setStype(String stype) { this.stype = stype; }

  public String getRole() { return role; }
  public void setRole(String role) { this.role = role; }

  public String getFrom() { return from; }
  public void setFrom(String from) { this.from = from; }

  public String getTo() { return to; }
  public void setTo(String to) { this.to = to; }

  public String getQ() { return q; }
  public void setQ(String q) { this.q = q; }

  public int getStartRow() { return startRow; }
  public void setStartRow(int startRow) { this.startRow = startRow; }

  public int getEndRow() { return endRow; }
  public void setEndRow(int endRow) { this.endRow = endRow; }
}
