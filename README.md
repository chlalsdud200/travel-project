# tryCatchTrip

JSP/Servlet, MyBatis, Oracle DB 기반의 여행 상품 예약 웹 프로젝트입니다.  
사용자는 여행 상품을 검색하고 상세 정보를 확인한 뒤 장바구니, 결제, 마이페이지, 후기/문의 게시판 기능을 사용할 수 있습니다. 관리자는 상품, 회원, 결제, 게시판, 매출 통계를 관리할 수 있습니다.

## 주요 기능

- 회원가입, 로그인, 아이디/비밀번호 찾기, 이메일 인증
- 여행 상품 목록 조회, 검색, 상세 조회
- 장바구니 담기, 인원 수 변경, 상품 제거
- 결제 생성, 결제 완료, 결제 취소
- 마이페이지 결제 내역, 찜 목록, 후기, 문의, 회원정보 수정
- 후기 게시판, Q&A 게시판, 댓글/답변 관리
- 관리자 상품 등록/수정, 회원 관리, 결제 관리, 게시판 관리
- 관리자 매출 통계, 회원 통계, 패키지 판매 통계
- D-day 위젯 및 출발 전 체크리스트 팝업

## 담당/강조 기능

### 출발 전 체크리스트 팝업

사용자가 출발 전 놓칠 수 있는 준비물을 확인할 수 있도록 D-day 기반 체크리스트 팝업을 구현했습니다.

- 로그인 사용자의 가장 가까운 출발 예정 여행을 조회
- 상품명, 주문번호, 여행기간, 결제금액, 호텔 정보를 팝업 상단에 표시
- 체크박스 상태를 주문번호 기준 `localStorage`에 저장
- `확인 및 닫기`는 현재 로그인 세션 기준 `sessionStorage`에 저장
- `3일 동안 보지 않기`는 만료 처리가 필요한 값이므로 쿠키 `Max-Age`로 저장
- 출발 D-1, D-DAY에는 3일 숨김 쿠키 상태여도 자동 팝업을 다시 노출
- 사용자가 직접 누르는 체크리스트 버튼은 숨김 상태와 관계없이 수동으로 열림

관련 코드:

- `src/main/webapp/WEB-INF/views/common/tctWidget.jsp`
- `src/main/java/kr/or/ddit/tct/comm/controller/DdayPopupController.java`
- `resources/mapper/payment.xml`

## 기술 스택

- Java
- JSP / Servlet
- MyBatis
- Oracle Database
- HTML / CSS / JavaScript
- JSTL
- Gson
- Apache Tomcat

## 프로젝트 구조

```txt
src/main/java/kr/or/ddit/tct
  admin/       관리자 기능
  board/       게시판, 후기, Q&A, 댓글
  comm/        공통 컨트롤러, DTO, VO, 필터
  mypage/      마이페이지
  product/     상품, 패키지, 지역, 호텔
  sales/       장바구니, 결제, 주문, 찜
  users/       회원, 로그인, 인증
  util/        MyBatis 유틸

src/main/webapp
  WEB-INF/views/   JSP 화면
  assets/js/       관리자/결제 관련 JavaScript
  css/             화면 스타일
  js/              공통 및 페이지별 JavaScript

resources
  config/          MyBatis, DB 설정
  mapper/          MyBatis SQL mapper
```

## 로컬 실행 설정

이 프로젝트는 DB 접속 정보가 필요합니다. 민감정보 보호를 위해 실제 설정 파일은 Git에 올리지 않습니다.

1. `resources/config/db.properties.example` 파일을 복사합니다.
2. 복사한 파일명을 `resources/config/db.properties`로 변경합니다.
3. 본인 Oracle DB 접속 정보로 값을 수정합니다.

```properties
driver=oracle.jdbc.OracleDriver
url=jdbc:oracle:thin:@HOST:1521:xe
username=YOUR_DB_USERNAME
password=YOUR_DB_PASSWORD
```

`resources/config/db.properties`는 `.gitignore`에 등록되어 있어 GitHub에 업로드되지 않습니다.

## GitHub 업로드 제외 항목

다음 파일과 폴더는 용량 또는 민감정보 문제로 Git에 포함하지 않습니다.

- `resources/config/db.properties`
- `.env`
- `build/`
- `logs/`
- `src/main/webapp/WEB-INF/lib/`
- `src/main/webapp/upload_img/`
- `src/main/webapp/assets/images/`
- `*.zip`
- 이미지 파일

## 참고

이 저장소에는 실제 DB 계정, 비밀번호, 업로드 이미지, 라이브러리 jar 파일이 포함되지 않습니다.  
프로젝트 실행 시 필요한 라이브러리와 DB 설정은 로컬 환경에 맞게 별도로 준비해야 합니다.
