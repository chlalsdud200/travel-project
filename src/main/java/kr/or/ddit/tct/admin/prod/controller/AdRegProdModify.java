package kr.or.ddit.tct.admin.prod.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.time.LocalDate;

import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.product.regProd.vo.RegProdVO;

// ✅ 네가 만든 서비스/impl 패키지에 맞게 import 수정해줘
import kr.or.ddit.tct.admin.prod.reg.service.IAdRegProdService;
import kr.or.ddit.tct.admin.prod.reg.service.AdRegProdServiceImpl;

@WebServlet("/adRegProdModify.do")
public class AdRegProdModify extends HttpServlet {

  private final Gson gson = new Gson();

  // ✅ service 선언/초기화 (싱글톤)
  private final IAdRegProdService service = AdRegProdServiceImpl.getInstance();

  // ---------- helpers ----------
  private String getStr(JsonObject j, String key) {
    if (j == null || !j.has(key) || j.get(key).isJsonNull()) return "";
    try {
      return j.get(key).getAsString().trim();
    } catch (Exception e) {
      // 문자열이 아닌 타입이라도 안전하게 처리
      return String.valueOf(j.get(key)).replace("\"", "").trim();
    }
  }

  private int getInt(JsonObject j, String key) {
    if (j == null || !j.has(key) || j.get(key).isJsonNull()) return 0;

    JsonElement el = j.get(key);
    try {
      // JSON number면 바로
      return el.getAsInt();
    } catch (Exception ignore) {}

    // 문자열/기타 타입이면 숫자만 뽑아 시도
    try {
      String s = el.getAsString();
      if (s == null) return 0;
      s = s.trim();
      if (s.isEmpty()) return 0;
      // "10,000" 같은 케이스 방지
      s = s.replaceAll("[^0-9\\-]", "");
      if (s.isEmpty() || "-".equals(s)) return 0;
      return Integer.parseInt(s);
    } catch (Exception e) {
      return 0;
    }
  }

  private LocalDate parseDate(String s) {
    if (s == null) return null;
    s = s.trim();
    if (s.isEmpty()) return null;
    return LocalDate.parse(s); // "yyyy-MM-dd" 전제
  }
  // ----------------------------

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    resp.setContentType("application/json;charset=UTF-8");
    var out = resp.getWriter();

    // 1) JSON body 읽기
    StringBuilder sb = new StringBuilder();
    try (BufferedReader br = req.getReader()) {
      String line;
      while ((line = br.readLine()) != null) sb.append(line);
    }

    // body가 아예 비었을 때
    if (sb.length() == 0) {
      resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
      out.write("{\"ok\":false,\"message\":\"요청 본문(JSON)이 비어있습니다.\"}");
      return;
    }

    // 2) JSON 파싱
    JsonObject json;
    try {
      json = gson.fromJson(sb.toString(), JsonObject.class);
    } catch (Exception e) {
      resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
      out.write("{\"ok\":false,\"message\":\"JSON 파싱 실패\"}");
      return;
    }

    // 3) 공통 필수값
    String action = getStr(json, "action");
    String regId  = getStr(json, "regId");

    if (action.isBlank()) {
      resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
      out.write("{\"ok\":false,\"message\":\"action 값이 필요합니다.\"}");
      return;
    }
    if (regId.isBlank()) {
      resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
      out.write("{\"ok\":false,\"message\":\"regId 값이 필요합니다.\"}");
      return;
    }

    try {
      // 4) 분기
      if ("update".equalsIgnoreCase(action)) {

        RegProdVO vo = new RegProdVO();
        vo.setRegId(regId);

        vo.setPkgId(getStr(json, "pkgId"));
        vo.setRegTitle(getStr(json, "regTitle"));
        vo.setForSale(getStr(json, "forSale"));

        vo.setRegPrice(getInt(json, "regPrice"));
        vo.setRegQty(getInt(json, "regQty"));

        vo.setStartDt(parseDate(getStr(json, "startDt")));
        vo.setEndDt(parseDate(getStr(json, "endDt")));
        vo.setSaleStartDt(parseDate(getStr(json, "saleStartDt")));
        vo.setSaleEndDt(parseDate(getStr(json, "saleEndDt")));

        vo.setHighlight(getStr(json, "highlight"));
        vo.setDescriptionA(getStr(json, "descriptionA"));
        vo.setDescriptionB(getStr(json, "descriptionB"));

        // 최소 추가 검증(서버에서도 한번)
        if (vo.getPkgId() == null || vo.getPkgId().isBlank()) {
          resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
          out.write("{\"ok\":false,\"message\":\"pkgId 값이 필요합니다.\"}");
          return;
        }
        if (vo.getRegTitle() == null || vo.getRegTitle().isBlank()) {
          resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
          out.write("{\"ok\":false,\"message\":\"regTitle 값이 필요합니다.\"}");
          return;
        }

        int cnt = service.updateRegProd(vo);

        if (cnt > 0) {
          out.write("{\"ok\":true,\"message\":\"수정 완료\"}");
        } else {
          resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
          out.write("{\"ok\":false,\"message\":\"수정 대상이 없습니다(regId 불일치).\"}");
        }
        return;
      }

      if ("delete".equalsIgnoreCase(action)) {
        // TODO: 나중에 실제 삭제 로직 붙이기
        // int cnt = service.deleteRegProd(regId);

        int cnt = 1; // 임시
        if (cnt > 0) out.write("{\"ok\":true,\"message\":\"삭제 완료\"}");
        else {
          resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
          out.write("{\"ok\":false,\"message\":\"삭제 대상이 없습니다(regId 불일치).\"}");
        }
        return;
      }

      resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
      out.write("{\"ok\":false,\"message\":\"지원하지 않는 action 입니다.\"}");

    } catch (Exception e) {
      e.printStackTrace();
      resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      out.write("{\"ok\":false,\"message\":\"서버 오류\"}");
    }
  }
}
