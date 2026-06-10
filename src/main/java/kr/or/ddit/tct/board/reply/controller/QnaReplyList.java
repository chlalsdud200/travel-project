package kr.or.ddit.tct.board.reply.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.tct.board.reply.vo.ReplyVO;
import kr.or.ddit.tct.board.reply.service.IReplyService;
import kr.or.ddit.tct.board.reply.service.ReplyServiceImpl;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

/**
 * QNA 댓글 목록 조회
 */
@WebServlet("/qnaReplyList.do")
public class QnaReplyList extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
	    response.setContentType("application/json; charset=UTF-8");  
		// 전송 데이터 읽기 - qnaNo
		int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
		
		System.out.println("qna reply list qnaNo == " + qnaNo);
		
		// service 객체 얻기
		IReplyService service = ReplyServiceImpl.getService();
		
		// service 메서드 호출 - 결과값 얻기
		List<ReplyVO> list = service.qnaReplyList(qnaNo);
		
		System.out.println("댓글 목록: " + list);
		System.out.println("댓글 개수: " + (list != null ? list.size() : "null"));
		
		// HashMap에 결과를 저장
		Map<String, Object> replyMap = new HashMap<String, Object>();
		replyMap.put("list", list);
		
		Gson gson = new GsonBuilder().setPrettyPrinting().create();
		
		PrintWriter out = response.getWriter();
		gson.toJson(replyMap, out);
	}
}