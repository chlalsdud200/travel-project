package kr.or.ddit.tct.util;

/**
 * 학원 방식 PageUtil.pageList 그대로
 * - prev/next는 id="prev"/"next", name 속성에 이동할 페이지 번호를 넣는 구조
 * - pageno는 class="pageno"를 붙여 이벤트 위임으로 처리
 */
public class PageUtil {

  public static String pageList(int startPage, int endPage, int totalPage, int currentPage) {

    StringBuilder sb = new StringBuilder();
    sb.append("<ul class='pagination justify-content-center'>");

    // 이전(prev)
    if (startPage > 1) {
      sb.append("<li class='page-item'>")
        .append("<a class='page-link' href='#' id='prev' name='")
        .append(startPage - 1)
        .append("'>Previous</a>")
        .append("</li>");
    }

    // 페이지 번호
    for (int i = startPage; i <= endPage; i++) {
      if (i == currentPage) {
        sb.append("<li class='page-item active'>");
      } else {
        sb.append("<li class='page-item'>");
      }
      sb.append("<a class='page-link pageno' href='#'>")
        .append(i)
        .append("</a></li>");
    }

    // 다음(next)
    if (endPage < totalPage) {
      sb.append("<li class='page-item'>")
        .append("<a class='page-link' href='#' id='next' name='")
        .append(endPage + 1)
        .append("'>Next</a>")
        .append("</li>");
    }

    sb.append("</ul>");
    return sb.toString();
  }
}
