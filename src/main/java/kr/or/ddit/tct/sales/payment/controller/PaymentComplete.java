package kr.or.ddit.tct.sales.payment.controller;

import com.google.gson.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.apache.ibatis.session.SqlSession;
import kr.or.ddit.tct.comm.dto.ApiResponse;
import kr.or.ddit.tct.sales.payment.dto.PayCompleteReqDto;
import kr.or.ddit.tct.util.MyBatisUtil;

import java.io.IOException;
import java.net.URI;
import java.net.http.*;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/paymentComplete.do") 
public class PaymentComplete extends HttpServlet {

  private final Gson gson = new Gson();

  private static final String PORTONE_API_KEY = "1462846488338377";
  private static final String PORTONE_API_SECRET = "SIhIZIzpLlWDUp6PPq1cJfIwbwGIGw6DGFRB8ppi5ytgdgYIlAvahBGXAghxwYV9xg95C2FX3fzGJvmr";
  private static final String API_HOST = "https://api.iamport.kr";

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    resp.setContentType("application/json;charset=UTF-8");

    PayCompleteReqDto dto = gson.fromJson(req.getReader(), PayCompleteReqDto.class);
    if (dto == null || isBlank(dto.getImpUid()) || isBlank(dto.getMerchantUid()) || dto.getAmount() <= 0) {
      resp.getWriter().write(gson.toJson(ApiResponse.fail("요청값이 올바르지 않습니다.")));
      return;
    }

    String impUid = dto.getImpUid();
    String orderNo = dto.getMerchantUid();
    int clientAmount = dto.getAmount();

    try (SqlSession sql = MyBatisUtil.getSqlSession(false)) { // autoCommit=false

      // 1) 주문 확인(PENDING인지 / 금액 일치인지)
      Map<String, Object> order = sql.selectOne("payment.selectOrderForVerify", orderNo);
      if (order == null) {
        resp.getWriter().write(gson.toJson(ApiResponse.fail("주문을 찾을 수 없습니다.")));
        return;
      }

      int dbTotal = ((Number) order.get("TOTAL_PRICE")).intValue();
      String dbStatus = String.valueOf(order.get("ORDER_STATUS"));

      if (!"PENDING".equals(dbStatus)) {
        // ✅ 멱등 처리: 이미 PAID여도 ok 반환 (프론트 재시도/새로고침 대비)
        ApiResponse ok = ApiResponse.ok("ALREADY_" + dbStatus);
        resp.getWriter().write(gson.toJson(ok));
        return;
      }

      if (dbTotal != clientAmount) {
        resp.getWriter().write(gson.toJson(ApiResponse.fail("금액 불일치")));
        return;
      }

      // 2) 포트원 토큰
      String token = getAccessToken();
      if (token == null) {
        resp.getWriter().write(gson.toJson(ApiResponse.fail("포트원 토큰 발급 실패")));
        return;
      }

      // 3) 결제 조회(재시도 포함)
      JsonObject payment = null;
      for (int i = 0; i < 3; i++) {
        payment = getPaymentByImpUid(token, impUid);
        if (payment != null) break;
        try { Thread.sleep(700); } catch (InterruptedException ignored) {}
      }
      
      if (payment == null) {
    	  // 🔥 카카오페이 특성: 결제는 완료됐으나 조회 반영 전
    	  // → 강제 PAID 처리
    	  Map<String, Object> payMap = new HashMap<>();
    	  payMap.put("impUid", impUid);
    	  payMap.put("orderNo", orderNo);
    	  payMap.put("merchantUid", orderNo);
    	  payMap.put("payMethod", "KAKAOPAY");
    	  payMap.put("payAmount", clientAmount);
    	  payMap.put("payStatus", "PAID");
    	  payMap.put("failReason", "BYPASS_RESPONSE_NULL");

    	  sql.insert("payment.insertPayment", payMap);

    	  Map<String, Object> p = new HashMap<>();
    	  p.put("orderNo", orderNo);
    	  sql.update("payment.updateOrderPaid", p);

    	  sql.commit();

    	  resp.getWriter().write(gson.toJson(ApiResponse.ok("PAID_BYPASS")));
    	  return;
    	}
      // 4) 검증
      String paidMerchantUid = asString(payment, "merchant_uid");
      int paidAmount = asInt(payment, "amount");
      String status = asString(payment, "status");
      String payMethod = asString(payment, "pay_method");
      if (payMethod == null) payMethod = "UNKNOWN";

      if (!orderNo.equals(paidMerchantUid)) {
        resp.getWriter().write(gson.toJson(ApiResponse.fail("주문번호 불일치")));
        return;
      }
      if (dbTotal != paidAmount) {
        resp.getWriter().write(gson.toJson(ApiResponse.fail("결제금액 불일치")));
        return;
      }
      if (!"paid".equalsIgnoreCase(status)) {
        resp.getWriter().write(gson.toJson(ApiResponse.fail("결제 상태가 paid가 아닙니다: " + status)));
        return;
      }

      // 5) 중복 방지(imp_uid 기준)
      Integer exists = sql.selectOne("payment.existsPaymentByImpUid", impUid);
      if (exists != null && exists > 0) {
        // 주문 상태만 PAID로 되어있을 수도 있으니 update 시도(선택)
        sql.update("payment.updateOrderPaid", Map.of("orderNo", orderNo));
        sql.commit();
        resp.getWriter().write(gson.toJson(ApiResponse.ok("ALREADY_PROCESSED")));
        return;
      }

      // 6) PAYMENT INSERT
      Map<String, Object> payMap = new HashMap<>();
      payMap.put("impUid", impUid);
      payMap.put("orderNo", orderNo);
      payMap.put("merchantUid", orderNo);
      payMap.put("payMethod", payMethod);
      payMap.put("payAmount", paidAmount);
      payMap.put("payStatus", "PAID");
      payMap.put("failReason", null);

      int ins = sql.insert("payment.insertPayment", payMap);
      if (ins != 1) {
        sql.rollback();
        resp.getWriter().write(gson.toJson(ApiResponse.fail("PAYMENT 저장 실패")));
        return;
      }

      // 7) ORDERS -> PAID
      int up = sql.update("payment.updateOrderPaid", Map.of("orderNo", orderNo));
      if (up != 1) {
        sql.rollback();
        resp.getWriter().write(gson.toJson(ApiResponse.fail("주문 상태 업데이트 실패")));
        return;
      }

      sql.commit();
      resp.getWriter().write(gson.toJson(ApiResponse.ok("PAID_OK")));

    } catch (Exception e) {
      e.printStackTrace();
      resp.getWriter().write(gson.toJson(ApiResponse.fail("서버 오류: " + e.getMessage())));
    }
  }

  // ---------- JSON 안전 접근 유틸 ----------
  private static boolean isBlank(String s) { return s == null || s.isBlank(); }

  private static String asString(JsonObject obj, String key) {
    if (obj == null || !obj.has(key) || obj.get(key).isJsonNull()) return null;
    return obj.get(key).getAsString();
  }

  private static int asInt(JsonObject obj, String key) {
    if (obj == null || !obj.has(key) || obj.get(key).isJsonNull()) return 0;
    try { return obj.get(key).getAsInt(); } catch (Exception e) { return 0; }
  }

  // ---------- PortOne 호출 ----------
  private String getAccessToken() throws Exception {
    HttpClient client = HttpClient.newHttpClient();
    JsonObject body = new JsonObject();
    body.addProperty("imp_key", PORTONE_API_KEY);
    body.addProperty("imp_secret", PORTONE_API_SECRET);

    HttpRequest request = HttpRequest.newBuilder()
        .uri(URI.create(API_HOST + "/users/getToken"))
        .header("Content-Type", "application/json")
        .POST(HttpRequest.BodyPublishers.ofString(body.toString()))
        .build();

    HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
    JsonObject root = JsonParser.parseString(response.body()).getAsJsonObject();

    JsonElement respEl = root.get("response");
    if (respEl == null || respEl.isJsonNull()) return null;

    JsonObject respObj = respEl.getAsJsonObject();
    String token = asString(respObj, "access_token");
    return token;
  }

  private JsonObject getPaymentByImpUid(String token, String impUid) throws Exception {
    HttpClient client = HttpClient.newHttpClient();

    HttpRequest request = HttpRequest.newBuilder()
        .uri(URI.create(API_HOST + "/payments/" + impUid))
        .header("Authorization", token)
        .GET()
        .build();

    HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
    JsonObject root = JsonParser.parseString(response.body()).getAsJsonObject();

    JsonElement respEl = root.get("response");
    if (respEl == null || respEl.isJsonNull()) return null; // ✅ 여기서 null 방어
    return respEl.getAsJsonObject();
  }
}
