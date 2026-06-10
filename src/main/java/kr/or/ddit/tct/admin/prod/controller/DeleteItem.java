package kr.or.ddit.tct.admin.prod.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.admin.prod.item.service.AdItemServiceImpl;
import kr.or.ddit.tct.admin.prod.item.service.IAdItemService;

@WebServlet("/admin/prod/deleteItem.do")
public class DeleteItem extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");

		String itemId = req.getParameter("itemId");
		String tab = req.getParameter("tab");
		if (tab == null || tab.isBlank())
			tab = "create_item";

		if (itemId == null || itemId.trim().isEmpty()) {
			resp.sendRedirect(req.getContextPath() + "/admin/prod/adminProducts.do?tab=" + tab + "&msg=del_empty");
			return;
		}

		IAdItemService svc = AdItemServiceImpl.getInstance();
		int cnt = svc.deleteItem(itemId.trim());

		if (cnt > 0) {
			resp.sendRedirect(req.getContextPath() + "/admin/prod/adminProducts.do?tab=" + tab + "&msg=del_success");
		} else {
			resp.sendRedirect(req.getContextPath() + "/admin/prod/adminProducts.do?tab=" + tab + "&msg=del_fail");
		}
	}
}
