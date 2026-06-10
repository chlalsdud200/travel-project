package kr.or.ddit.tct.comm.dto;

import lombok.Data;

@Data
public class ApiResponse {
	private boolean ok;
	private String message;
	private String merchant_uid;
	
    public static ApiResponse ok(String merchantUid){
        ApiResponse r = new ApiResponse();
        r.ok = true;
        r.merchant_uid = merchantUid;
        return r;
    }

    public static ApiResponse fail(String msg){
        ApiResponse r = new ApiResponse();
        r.ok = false;
        r.message = msg;
        return r;
    }
}
