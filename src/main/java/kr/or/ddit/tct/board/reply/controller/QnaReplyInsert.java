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
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;

/**
 * QNA 댓글 등록
 */
@WebServlet("/qnaReplyInsert.do")
public class QnaReplyInsert extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		// JSON 응답 설정
		response.setContentType("application/json; charset=UTF-8");
		
		// JSON 바로 변환
		Gson gson = new Gson();
		ReplyVO vo = gson.fromJson(request.getReader(), ReplyVO.class);
		
		System.out.println("vo = " + vo);
		
		// service 객체 얻기
		IReplyService service = ReplyServiceImpl.getService();
		 
		// service 메서드 호출 - 결과값
		int res = service.qnaReplyInsert(vo);
		
		// JSON 직접 응답
		Map<String, String> result = new HashMap<>();
		result.put("flag", res > 0 ? "ok" : "no");
		
		response.getWriter().write(gson.toJson(result));
	}
}