package kr.or.ddit.tct.board.qna.vo;

import kr.or.ddit.tct.board.vo.PageInfo;
import lombok.Data;

/**
 * 공지 Top N 조회용 파라미터 객체
 * - 존재이유: MyBatis mapper에서 parameterType을 Map으로 두지 않고, "객체"로 통일하기 위해서
 * - 구성: (1) 검색조건/페이징 정보(PageInfo) + (2) 공지 노출 개수(noticeLimit)
 */
@Data
public class QnaNoticeParam {

  // 공지에도 검색조건을 같이 적용하려고 PageInfo를 같이 넘긴다
  private PageInfo pinfo;

  // Top N 개수
  private int noticeLimit;

  public QnaNoticeParam(PageInfo pinfo, int noticeLimit) {
    this.pinfo = pinfo;
    this.noticeLimit = noticeLimit;
  }
}
