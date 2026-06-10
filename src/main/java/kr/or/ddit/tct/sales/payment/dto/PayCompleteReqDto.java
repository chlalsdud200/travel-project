package kr.or.ddit.tct.sales.payment.dto;

import com.google.gson.annotations.SerializedName;
import lombok.Data;

@Data
public class PayCompleteReqDto {

  @SerializedName("imp_uid")
  private String impUid;

  @SerializedName("merchant_uid")
  private String merchantUid;

  @SerializedName("amount")
  private int amount;
}
