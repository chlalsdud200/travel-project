package kr.or.ddit.tct.board.vo;

import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * 학원 게시판 방식 PageInfo
 * - perList: 한 페이지에 보여줄 게시글 수
 * - perPage: 페이지 네비게이션(1..10 같은 버튼 덩어리) 크기
 * - totalRecord: 전체 글 수 (Service.readPaging에서 반드시 세팅)
 * - page: 현재 페이지
 * - svo: 검색 조건(구조 동일 유지)
 */
@Data
@AllArgsConstructor
public class PageInfo {

    private int perList;
    private int perPage;

    private int totalRecord;
    private int page;

    private SearchVO svo;

    public PageInfo() {
        // 학원 파일 기본값 유지(필요 시 Controller에서 new PageInfo(10,10)처럼 덮어씀)
        this(3, 2);
    }

    public PageInfo(int perList, int perPage) {
        this.perList = perList;
        this.perPage = perPage;
    }

    // --- Lombok(@Data)이 단순 Getter/Setter는 자동 생성하므로 삭제함 ---

    /** 총 페이지 수 = ceil(totalRecord / perList) */
    public int getTotalPage() {
        return (int)Math.ceil(totalRecord / (double)perList);
    }

    /** 현재 페이지 블록의 시작 페이지 */
    public int getStartPage() {
        return ((page - 1) / perPage * perPage) + 1;
    }

    /** 현재 페이지 블록의 끝 페이지 */
    public int getEndPage() {
        int end = getStartPage() + perPage - 1;
        return Math.min(end, getTotalPage());
    }

    /** rownum 페이징 start (1부터) */
    public int getStart() {
        // page가 totalPage를 넘으면 마지막으로 보정(학원 흐름에서 자주 들어감)
        int totalPage = getTotalPage();
        int p = page;
        if (totalPage >= 1 && p > totalPage) p = totalPage;
        if (p < 1) p = 1;

        return (p - 1) * perList + 1;
    }

    /** rownum 페이징 end */
    public int getEnd() {
        int end = page * perList;
        return Math.min(end, totalRecord);
    }

    // Lombok의 toString은 포맷이 다르므로, 기존 포맷을 완벽히 유지하기 위해 오버라이드 유지
    @Override
    public String toString() {
        return "PageInfo [perList=" + perList + ", perPage=" + perPage + ", totalRecord=" + totalRecord
                + ", page=" + page + ", totalPage=" + getTotalPage() + ", start=" + getStart() + ", end=" + getEnd()
                + ", startPage=" + getStartPage() + ", endPage=" + getEndPage() + "]";
    }
}