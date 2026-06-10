package kr.or.ddit.tct.admin.prod.controller;

import java.io.IOException;

import com.google.gson.Gson;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.admin.prod.item.service.AdItemServiceImpl;
import kr.or.ddit.tct.admin.prod.item.service.IAdItemService;
import kr.or.ddit.tct.admin.prod.packageitem.dto.AdRegPackageItemDto;
import kr.or.ddit.tct.admin.prod.packageitem.service.AdRegPackageItemServiceImpl;
import kr.or.ddit.tct.admin.prod.packageitem.service.IAdRegPackageItemService;
import kr.or.ddit.tct.comm.dto.CommonApi;

@WebServlet("/admin/prod/reg/item.do")
public class AdItemController extends HttpServlet {

  private static final long serialVersionUID = 1L;

  private final IAdItemService service = AdItemServiceImpl.getInstance();
  private final Gson gson = new Gson();

  


  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    resp.setContentType("application/json; charset=UTF-8");


  }

}
