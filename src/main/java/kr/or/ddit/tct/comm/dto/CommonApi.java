package kr.or.ddit.tct.comm.dto;

import java.io.IOException;

import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletResponse;
import lombok.Data;

@Data
public class CommonApi<T> {

	private boolean ok;
	private String message;
	private T data;
	
	public static <T> CommonApi<T> ok(T data) {
		CommonApi<T> r = new CommonApi<>();
		r.ok = true;
		r.data = data;
		return r;
	}
	
	public static <T> CommonApi<T> fail(String msg) {
		CommonApi<T> r = new CommonApi<>();
		r.ok = false;
		r.message = msg;
		return r;
	}
	
	public static void writeJson(HttpServletResponse resp, Object obj, Gson gson) throws IOException {
		  resp.setContentType("application/json;charset=UTF-8");
		  resp.getWriter().write(gson.toJson(obj));
		}

}
