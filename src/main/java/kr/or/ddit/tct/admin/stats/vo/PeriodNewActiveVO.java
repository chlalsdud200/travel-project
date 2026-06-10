package kr.or.ddit.tct.admin.stats.vo;

public class PeriodNewActiveVO {

  private String period;
  private int newMembers;
  private int activeMembers;

  public PeriodNewActiveVO() {
  }

  public PeriodNewActiveVO(String period, int newMembers, int activeMembers) {
    this.period = period;
    this.newMembers = newMembers;
    this.activeMembers = activeMembers;
  }

  public String getPeriod() {
    return period;
  }

  public void setPeriod(String period) {
    this.period = period;
  }

  public int getNewMembers() {
    return newMembers;
  }

  public void setNewMembers(int newMembers) {
    this.newMembers = newMembers;
  }

  public int getActiveMembers() {
    return activeMembers;
  }

  public void setActiveMembers(int activeMembers) {
    this.activeMembers = activeMembers;
  }

  @Override
  public String toString() {
    return "PeriodNewActiveVO{period='" + period + "', newMembers=" + newMembers
        + ", activeMembers=" + activeMembers + "}";
  }
}
