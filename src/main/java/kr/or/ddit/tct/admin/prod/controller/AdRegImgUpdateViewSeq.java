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
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/adRegImgUpdateViewSeq.do")
public class AdRegImgUpdateViewSeq extends HttpServlet {

	private final Gson gson = new Gson();
	private final IAdRegImgService service = AdRegImgServiceImpl.getInstance();

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		resp.setContentType("application/json; charset=UTF-8");

		try {
			// 1) body 읽기
			String body = req.getReader().lines().collect(Collectors.joining());
			if (body == null || body.isBlank()) {
				write(resp, CommonApi.fail("요청 바디가 비었습니다."));
				return;
			}

			// 2) JSON 파싱: { regId, mapNo, viewSequence }
			Type type = new TypeToken<Map<String, Object>>() {
			}.getType();
			Map<String, Object> param = gson.fromJson(body, type);
			if (param == null) {
				write(resp, CommonApi.fail("요청 JSON 파싱 실패"));
				return;
			}

			String regId = param.get("regId") == null ? null : String.valueOf(param.get("regId")).trim();
			Object mapNoObj = param.get("mapNo");
			Object seqObj = param.get("viewSequence");

			if (regId == null || regId.isBlank()) {
				write(resp, CommonApi.fail("regId 누락"));
				return;
			}
			if (mapNoObj == null) {
				write(resp, CommonApi.fail("mapNo 누락"));
				return;
			}
			if (seqObj == null) {
				write(resp, CommonApi.fail("viewSequence 누락"));
				return;
			}

			// 3) 숫자 안전 변환 
			int mapNo = toInt(mapNoObj, -1);
			int viewSequence = toInt(seqObj, -1);

			if (mapNo <= 0) {
				write(resp, CommonApi.fail("mapNo 값이 올바르지 않습니다."));
				return;
			}
			if (viewSequence <= 0) {
				write(resp, CommonApi.fail("viewSequence는 1 이상의 정수여야 합니다."));
				return;
			}

			// 4) update
			int updated = service.updateRegImgViewSequence(regId, mapNo, viewSequence);

			// updated=0이면 대상 없음(이미 삭제됐거나 regId 불일치)
			if (updated == 0) {
				write(resp, CommonApi.fail("수정 대상이 없습니다."));
				return;
			}

			write(resp, CommonApi.ok(updated));

		} catch (Exception e) {
			e.printStackTrace();
			write(resp, CommonApi.fail("순서 업데이트 중 오류: " + e.getClass().getSimpleName() + " - " + e.getMessage()));
		}
	}

	private int toInt(Object o, int def) {
		try {
			if (o instanceof Number)
				return ((Number) o).intValue();
			return Integer.parseInt(String.valueOf(o).trim());
		} catch (Exception e) {
			return def;
		}
	}

	private void write(HttpServletResponse resp, CommonApi<?> api) throws IOException {
		resp.getWriter().write(gson.toJson(api));
	}
}