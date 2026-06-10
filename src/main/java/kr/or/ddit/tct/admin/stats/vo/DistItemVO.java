package kr.or.ddit.tct.admin.stats.vo;

public class DistItemVO {

  private String label;
  private int value;

  public DistItemVO() {
  }

  public DistItemVO(String label, int value) {
    this.label = label;
    this.value = value;
  }

  public String getLabel() {
    return label;
  }

  public void setLabel(String label) {
    this.label = label;
  }

  public int getValue() {
    return value;
  }

  public void setValue(int value) {
    this.value = value;
  }

  @Override
  public String toString() {
    return "DistItemVO{label='" + label + "', value=" + value + "}";
  }
}
