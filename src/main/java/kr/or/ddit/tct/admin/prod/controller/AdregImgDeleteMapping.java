package kr.or.ddit.tct.admin.prod.controller;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.comm.dto.CommonApi;
import kr.or.ddit.tct.admin.prod.reg.service.AdRegImgServiceImpl;
import kr.or.ddit.tct.admin.prod.reg.service.IAdRegImgService;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/adRegImgDeleteMapping.do")
public class AdregImgDeleteMapping extends HttpServlet {

  private final Gson gson = new Gson();
  private final IAdRegImgService service = AdRegImgServiceImpl.getInstance();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    resp.setContentType("application/json; charset=UTF-8");

    try {
      // 0) 바디 안정적으로 읽기
      String body = req.getReader().lines().collect(Collectors.joining());
      if (body == null || body.isBlank()) {
        write(resp, CommonApi.fail("요청 바디가 비었습니다."));
        return;
      }

      // 1) JSON 파싱
      Type type = new TypeToken<Map<String, Object>>() {}.getType();
      Map<String, Object> param = gson.fromJson(body, type);
      if (param == null) {
        write(resp, CommonApi.fail("요청 JSON 파싱 실패"));
        return;
      }

      String regId = param.get("regId") == null ? null : String.valueOf(param.get("regId")).trim();
      Object listObj = param.get("mapNoList");

      if (regId == null || regId.isBlank()) {
        write(resp, CommonApi.fail("regId 누락"));
        return;
      }
      if (!(listObj instanceof List)) {
        write(resp, CommonApi.fail("mapNoList 누락/형식오류"));
        return;
      }

      List<?> rawList = (List<?>) listObj;
      if (rawList.isEmpty()) {
        write(resp, CommonApi.fail("삭제할 항목이 없습니다."));
        return;
      }

      // 2) List<Integer> 정제 (Gson이 Double로 줄 수도 있어서 안전변환)
      List<Integer> mapNoList = new ArrayList<>();
      for (Object o : rawList) {
        if (o == null) continue;
        if (o instanceof Number) {
          mapNoList.add(((Number) o).intValue());
          continue;
        }
        String s = String.valueOf(o).trim();
        if (s.isEmpty()) continue;
        try { mapNoList.add(Integer.parseInt(s)); } catch (NumberFormatException ignore) {}
      }

      if (mapNoList.isEmpty()) {
        write(resp, CommonApi.fail("mapNoList 값이 올바르지 않습니다."));
        return;
      }

      // 3) 서비스 호출
      int deletedCnt = service.deleteRegImgMappingByMapNo(regId, mapNoList);

      // 4) 응답
      write(resp, CommonApi.ok(deletedCnt));

    } catch (Exception e) {
      e.printStackTrace();
      // ✅ 원인 바로 보이게 메시지 내려줌(개발 중)
      write(resp, CommonApi.fail("매핑 삭제 중 오류: " + e.getClass().getSimpleName() + " - " + e.getMessage()));
    }
  }

  private void write(HttpServletResponse resp, CommonApi<?> api) throws IOException {
    resp.getWriter().write(gson.toJson(api));
  }
}
