package kr.or.ddit.tct.board.review.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class PageInfo {
	
	private int currentPage;
    private int pageSize;     // 한 페이지 글 수
    private int totalCount;
    private int totalPage;

    private int startRow;
    private int endRow;

    private int startPage;
    private int endPage;
    private int blockSize = 5; // 페이지 버튼 5개씩

}
