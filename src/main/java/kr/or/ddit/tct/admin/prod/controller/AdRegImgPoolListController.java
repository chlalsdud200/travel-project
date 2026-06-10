package kr.or.ddit.tct.admin.prod.controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import kr.or.ddit.tct.admin.prod.dto.AdRegImgPoolItemDto;
import kr.or.ddit.tct.admin.prod.reg.service.AdRegImgServiceImpl;
import kr.or.ddit.tct.comm.dto.CommonApi;

@WebServlet("/adRegImgPoolList.do")
public class AdRegImgPoolListController extends HttpServlet {

  private final Gson gson = new Gson();
  private final AdRegImgServiceImpl svc = (AdRegImgServiceImpl) AdRegImgServiceImpl.getInstance();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    resp.setCharacterEncoding(StandardCharsets.UTF_8.name());
    resp.setContentType("application/json;charset=UTF-8");

    String folder = req.getParameter("folder");
    if (folder == null) folder = "reg_img";

    // 화이트리스트: reg_img만 허용(폴더 임의 접근 방지)
    if (!"reg_img".equals(folder)) {
      resp.getWriter().write(gson.toJson(CommonApi.fail("허용되지 않은 folder 입니다.")));
      return;
    }

    // web path prefix
    final String webPrefix = "/upload_img/" + folder + "/";

    // 실제 디렉토리 경로 (exploded war 기준)
    String realDir = req.getServletContext().getRealPath(webPrefix);
    if (realDir == null) {
      resp.getWriter().write(gson.toJson(CommonApi.fail("서버 경로를 확인할 수 없습니다(realPath=null).")));
      return;
    }

    File dir = new File(realDir);
    if (!dir.exists() || !dir.isDirectory()) {
      resp.getWriter().write(gson.toJson(CommonApi.fail("이미지 폴더가 존재하지 않습니다: " + webPrefix)));
      return;
    }

    File[] files = dir.listFiles();
    List<AdRegImgPoolItemDto> items = new ArrayList<>();

    if (files != null) {
      for (File f : files) {
        if (!f.isFile()) continue;

        String fileName = f.getName();
        if (!AdRegImgServiceImpl.isImageFile(fileName)) continue;

        AdRegImgPoolItemDto dto = new AdRegImgPoolItemDto();
        dto.setFileName(fileName);
        dto.setImgPath(webPrefix + fileName); // ✅ DB에 저장할 웹 경로 규칙
        items.add(dto);
      }
    }

    // 정렬(파일명)
    items.sort(Comparator.comparing(AdRegImgPoolItemDto::getFileName, String.CASE_INSENSITIVE_ORDER));

    // DB 비교해서 registered/imgNo 마킹
    svc.markRegistered(items);

    resp.getWriter().write(gson.toJson(CommonApi.ok(items)));
  }
}
