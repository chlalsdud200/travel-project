package kr.or.ddit.tct.board.qna.vo;

import lombok.Data;

@Data
public class QnaVO {

  // 글번호(QNA_BOARD.QNA_NO)
  private long qnaNo;

  // 작성자ID(QNA_BOARD.USER_ID)
  private String userId;

  // 제목(QNA_BOARD.QNA_TITLE)
  private String qnaTitle;

  // 문의내용(QNA_BOARD.QNA_CTT)
  // 존재이유: DB 컬럼(QNA_CTT)에 들어가는 "실제 문의 내용"을 VO에서 명확하게 표현하기 위해 qnaCtt로 통일한다.
  private String qnaCtt;

  // ====== 표시용(USERS 조인) ======

  // 작성자 이름(USERS.USER_NAME)
  // 존재이유: 목록/상세에서 작성자 표시용(아이디 말고 이름을 보여주기 위한 필드)
  private String writerName;

  // 작성자 권한(USERS.ROLE)
  // 존재이유: ADMIN이면 화면에서 '관리자' 마스킹/색상 처리, 답변 편집 권한 판단에 사용
  private String writerRole;

  // 작성일(TO_CHAR(QNA_CREATED))
  // 존재이유: 화면에서 날짜 문자열(YYYY-MM-DD)로 바로 출력하기 위한 필드
  private String createdAt;

  // 수정일(TO_CHAR(QNA_UPDATE))
  // 존재이유: 수정 화면/상세 화면에서 수정일 표시용
  private String updatedAt;

  // 조회수(QNA_BOARD.QNA_HIT)
  private int hit;


  // ✅ 화면용 번호(공백 없는 순번)
  // - 의미: 게시판/마이페이지 목록에 표시되는 번호
  // - 존재이유: DB qnaNo는 삭제 시 공백이 생길 수 있으므로, 화면에서는 연속 번호를 보여주기 위함
  private int displayNo;

  // 답변상태(QNA_BOARD.QNA_STATUS) - WAIT / DONE
  // 존재이유: 목록의 "답변대기/답변완료" 뱃지 표시용
  private String qnaStatus;

  // 공지여부(QNA_BOARD.IS_NOTICE) - Y / N
  // 존재이유: 공지는 답변 UI를 숨기고, 목록에서 상단 고정 처리하기 위한 구분값
  private String isNotice;

  // ====== 관리자 답변 ======

  // 답변내용(QNA_BOARD.ANS_CTT)
  // 존재이유: 상세 화면에서 누구나 답변을 읽게 하기 위한 필드
  private String ansCtt;

  // 답변일시(TO_CHAR(ANS_AT))
  // 존재이유: 답변이 언제 달렸는지 표시하기 위한 필드
  private String ansAt;
}
