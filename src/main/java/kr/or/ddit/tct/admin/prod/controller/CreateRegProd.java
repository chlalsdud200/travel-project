package kr.or.ddit.tct.admin.prod.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.*;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import kr.or.ddit.tct.admin.prod.reg.service.AdRegProdServiceImpl;
import kr.or.ddit.tct.admin.prod.reg.service.IAdRegProdService;
import kr.or.ddit.tct.product.regProd.vo.RegProdVO;

@WebServlet("/admin/prod/createReg.do")
public class CreateRegProd extends HttpServlet {

  private final IAdRegProdService service = AdRegProdServiceImpl.getInstance();

  // ✅ LocalDate 파싱을 위한 Gson 설정
  private final Gson gson = new GsonBuilder()
      .registerTypeAdapter(LocalDate.class,
          (JsonDeserializer<LocalDate>) (json, type, ctx) ->
              (json == null || json.getAsString().isBlank())
                  ? null
                  : LocalDate.parse(json.getAsString()))
      .create();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    req.setCharacterEncoding("UTF-8");
    resp.setCharacterEncoding("UTF-8");
    resp.setContentType("application/json;charset=UTF-8");

    try {
      String bodyJson = readBody(req);
      RegProdVO vo = gson.fromJson(bodyJson, RegProdVO.class);

      // 최소 검증
      if (vo == null || vo.getPkgId() == null || vo.getPkgId().isBlank()) {
        write(resp, false, "pkgId 누락");
        return;
      }
      if (vo.getRegTitle() == null || vo.getRegTitle().isBlank()) {
        write(resp, false, "regTitle 누락");
        return;
      }

      String newRegId = service.createRegProd(vo);

      Map<String, Object> out = new HashMap<>();
      out.put("ok", true);
      out.put("regId", newRegId);

      resp.getWriter().write(gson.toJson(out));

    } catch (Exception e) {
      e.printStackTrace();
      resp.setStatus(500);
      write(resp, false, "등록 실패");
    }
  }

  private String readBody(HttpServletRequest req) throws IOException {
    StringBuilder sb = new StringBuilder();
    try (BufferedReader br = req.getReader()) {
      String line;
      while ((line = br.readLine()) != null) sb.append(line);
    }
    return sb.toString();
  }

  private void write(HttpServletResponse resp, boolean ok, String msg) throws IOException {
    Map<String, Object> out = new HashMap<>();
    out.put("ok", ok);
    out.put("message", msg);
    resp.getWriter().write(new Gson().toJson(out));
  }
}
