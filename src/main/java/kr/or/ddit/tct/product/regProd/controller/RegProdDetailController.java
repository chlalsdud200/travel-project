package kr.or.ddit.tct.product.regProd.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.product.dto.vo.RegProDtoVO;
import kr.or.ddit.tct.product.item.vo.ItemVO;
import kr.or.ddit.tct.product.regProd.service.IregProdService;
import kr.or.ddit.tct.product.regProd.service.RegProdServiceImpl;

@WebServlet("/regProdDetail.do")
public class RegProdDetailController extends HttpServlet {

  private final IregProdService service = RegProdServiceImpl.getInstance();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    String regId = req.getParameter("regId");
    if(regId == null || regId.isBlank()){
      req.getRequestDispatcher("/WEB-INF/views/prod_view/regProdDetail.jsp").forward(req, resp);
      return;
    }

    RegProDtoVO detail = service.selectDetailByRegId(regId);
    List<ItemVO> itemList = service.getItemListByRegId(regId);
    List<String> imgList = service.getImgPathListByRegId(regId);
    
    List<Map<String, Object>> itinRows = service.getItineraryRowsByRegId(regId);
    if(itinRows == null) itinRows = new ArrayList<>();

    // 1) 날짜 기반 dayCount
    int dayCountByDate = 0;

    if (detail != null && detail.getStartDt() != null && detail.getEndDt() != null) {
        LocalDate start = detail.getStartDt();
        LocalDate end   = detail.getEndDt();

        long diff = ChronoUnit.DAYS.between(start, end);
        dayCountByDate = (int) diff + 1;
    }

    // 2) 데이터 기반 dayCount(최대 dayNo)
    int dayCountByRows = 0;
    for (Map<String, Object> r : itinRows) {
        Object v = r.get("dayNo");
        if (v == null) continue;
        int d = Integer.parseInt(String.valueOf(v));
        if (d > dayCountByRows) dayCountByRows = d;
    }

    // 3) 최종 dayCount
    int dayCount = Math.max(dayCountByDate, dayCountByRows);
    if (dayCount <= 0) dayCount = 1;

    // itinMap 생성
    Map<Integer, List<Map<String, Object>>> itinMap = new LinkedHashMap<>();
    for (int d=1; d<=dayCount; d++) itinMap.put(d, new ArrayList<>());

    for (Map<String, Object> r : itinRows) {
        Object v = r.get("dayNo");
        if (v == null) continue;
        int day = Integer.parseInt(String.valueOf(v));
        if (itinMap.containsKey(day)) itinMap.get(day).add(r);
    }
    
 // ✅ 예약/잔여 계산
    int reservedQty = service.getReservedQtyByRegId(regId);

    int totalQty = (detail != null) ? detail.getRegQty() : 0;
    int remainQty = Math.max(0, totalQty - reservedQty);

    req.setAttribute("detail", detail);
    req.setAttribute("itemList", itemList);
    req.setAttribute("imgList", imgList);
    req.setAttribute("itinMap", itinMap);
    req.setAttribute("dayCount", dayCount);
    req.setAttribute("reservedQty", reservedQty);
    req.setAttribute("remainQty", remainQty);
    

    req.getRequestDispatcher("/WEB-INF/views/prod_view/regProdDetail.jsp").forward(req, resp);
  }
}
