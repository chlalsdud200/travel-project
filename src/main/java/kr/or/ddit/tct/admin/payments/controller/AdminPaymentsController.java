package kr.or.ddit.tct.admin.payments.controller;

import java.io.IOException;
import java.util.List;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.admin.payments.service.AdminPaymentServiceImpl;
import kr.or.ddit.tct.admin.payments.service.IAdminPaymentService;
import kr.or.ddit.tct.admin.payments.vo.AdminPaymentVO;

@WebServlet("/admin/payments.do")
public class AdminPaymentsController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final IAdminPaymentService service = AdminPaymentServiceImpl.getInstance();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        // 검색/필터 파라미터
        String status = trim(req.getParameter("status")); // 예: PENDING/PAID/FAIL 등 (네 DB값에 맞춰)
        String from   = trim(req.getParameter("from"));   // yyyy-MM-dd
        String to     = trim(req.getParameter("to"));     // yyyy-MM-dd

        int page = parseInt(req.getParameter("page"), 1);
        int size = parseInt(req.getParameter("size"), 10);
        if (page < 1) page = 1;
        if (size < 5) size = 5;

        int offset = (page - 1) * size;

        int total = service.countAdminPaymentList(status, from, to);
        int totalPages = (total == 0) ? 1 : (int) Math.ceil(total / (double) size);
        if (page > totalPages) page = totalPages;

        List<AdminPaymentVO> list = service.selectAdminPaymentList(status, from, to, offset, size);

        // fetch(AJAX) 요청이면 JSON으로 응답
        String format = trim(req.getParameter("format"));
        if ("json".equalsIgnoreCase(format)) {
            resp.setContentType("application/json; charset=UTF-8");

            PaymentListResponse out = new PaymentListResponse();
            out.list = list;
            out.total = total;
            out.page = page;
            out.size = size;
            out.totalPages = totalPages;

            Gson gson = new Gson();
            resp.getWriter().write(gson.toJson(out));
            return;
        }

        // 일반 페이지 렌더링
        req.setAttribute("payList", list);
        req.setAttribute("total", total);
        req.setAttribute("page", page);
        req.setAttribute("size", size);
        req.setAttribute("totalPages", totalPages);

        req.setAttribute("status", status);
        req.setAttribute("from", from);
        req.setAttribute("to", to);

        req.getRequestDispatcher("/WEB-INF/views/admin/payments.jsp").forward(req, resp);
    }

    private String trim(String s) {
        return (s == null) ? "" : s.trim();
    }

    private int parseInt(String s, int def) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }

    // JSON 응답용 객체 (Map 쓰지 말랬으니 DTO로)
    private static class PaymentListResponse {
        List<AdminPaymentVO> list;
        int total;
        int page;
        int size;
        int totalPages;
    }
}
