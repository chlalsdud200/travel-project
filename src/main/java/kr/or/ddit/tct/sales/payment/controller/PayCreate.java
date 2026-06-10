package kr.or.ddit.tct.sales.payment.controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import kr.or.ddit.tct.comm.dto.ApiResponse;
import kr.or.ddit.tct.sales.payment.service.IPaymentService;
import kr.or.ddit.tct.sales.payment.service.PaymentServiceImpl;
import kr.or.ddit.tct.users.vo.UserVO;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/payCreate.do")
public class PayCreate extends HttpServlet {

  private final Gson gson = new Gson();
  private final IPaymentService service = PaymentServiceImpl.getInstance();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    req.setCharacterEncoding("UTF-8");
    resp.setContentType("application/json;charset=UTF-8");

    // 1) 로그인 체크
    HttpSession session = req.getSession(false);
    UserVO loginUser = (session == null) ? null : (UserVO) session.getAttribute("loginUser");
    if (loginUser == null) {
      resp.getWriter().write(gson.toJson(ApiResponse.fail("로그인이 필요합니다.")));
      return;
    }

    String regId = null;
    int qty = 0;
    int amount = 0;

    // 2) JSON / Form 둘 다 파싱 (reg_id / regId 둘 다 허용)
    try {
      String ct = String.valueOf(req.getContentType());
      if (ct.contains("application/json")) {
        JsonObject body = JsonParser.parseReader(req.getReader()).getAsJsonObject();

        // reg_id 또는 regId
        if (body.has("reg_id") && !body.get("reg_id").isJsonNull()) {
          regId = body.get("reg_id").getAsString();
        } else if (body.has("regId") && !body.get("regId").isJsonNull()) {
          regId = body.get("regId").getAsString();
        }

        // adult_cnt 또는 adultCnt
        if (body.has("adult_cnt") && !body.get("adult_cnt").isJsonNull()) {
          qty = body.get("adult_cnt").getAsInt();
        } else if (body.has("adultCnt") && !body.get("adultCnt").isJsonNull()) {
          qty = body.get("adultCnt").getAsInt();
        }

        // amount
        if (body.has("amount") && !body.get("amount").isJsonNull()) {
          amount = body.get("amount").getAsInt();
        }

      } else {
        // form-urlencoded
        regId = nv(req.getParameter("reg_id"));
        if (regId == null) regId = nv(req.getParameter("regId"));

        qty = parseIntSafe(req.getParameter("adult_cnt"), 0);
        if (qty == 0) qty = parseIntSafe(req.getParameter("adultCnt"), 0);

        amount = parseIntSafe(req.getParameter("amount"), 0);
      }
    } catch (Exception e) {
      resp.getWriter().write(gson.toJson(ApiResponse.fail("요청 파싱 실패: " + e.getMessage())));
      return;
    }

    if (regId == null || regId.isBlank()) {
      resp.getWriter().write(gson.toJson(ApiResponse.fail("reg_id가 없습니다.")));
      return;
    }

    qty = Math.max(1, qty);
    if (amount <= 0) {
      resp.getWriter().write(gson.toJson(ApiResponse.fail("amount가 올바르지 않습니다.")));
      return;
    }

    // 3) 서버에서 주문 생성(PENDING) + orderNo 발급
    try {
      String orderNo = service.createPendingOrder(
          loginUser.getUserId(),
          regId,
          qty,
          amount
      );

      // ✅ 프론트(tct-pay.js)가 기대하는 키로 “고정”
      Map<String, Object> out = new HashMap<>();
      out.put("ok", true);
      out.put("message", "CREATED");
      out.put("merchant_uid", orderNo);
      out.put("order_no", orderNo);
      out.put("amount", amount);

      resp.getWriter().write(gson.toJson(out));
    } catch (Exception e) {
      e.printStackTrace();
      resp.getWriter().write(gson.toJson(ApiResponse.fail("주문 생성 실패: " + e.getMessage())));
    }
  }

  private String nv(String s) {
    if (s == null) return null;
    String t = s.trim();
    return t.isEmpty() ? null : t;
  }

  private int parseIntSafe(String s, int def) {
    try { return Integer.parseInt(String.valueOf(s).trim()); } catch (Exception e) { return def; }
  }
}
