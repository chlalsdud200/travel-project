<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:set var="CTX" value="${pageContext.request.contextPath}" />

<style>
.headRow {
	display: flex;
	align-items: flex-end;
	justify-content: space-between;
	margin-bottom: 20px;
}

.title {
	margin: 0;
	font-size: 26px;
	font-weight: 900;
	letter-spacing: -0.02em;
	color: #0f172a;
}

.sub {
	margin-top: 6px;
	color: #64748b;
	font-weight: 800;
}

.card-box {
	background: #fff;
	border: 1px solid rgba(15, 23, 42, .10);
	border-radius: 18px;
	padding: 30px;
	box-shadow: 0 12px 30px rgba(15, 23, 42, .08);
}

.form-row {
	display: flex;
	flex-direction: column;
	gap: 8px;
	margin-bottom: 20px;
}

.lbl {
	font-weight: 900;
	font-size: 15px;
	color: #334155;
}

.inp {
	width: 100%;
	padding: 12px 14px;
	border: 1px solid rgba(15, 23, 42, .18);
	border-radius: 12px;
	font-size: 15px;
	font-weight: 500;
}

.ta {
	width: 100%;
	min-height: 250px;
	resize: vertical;
	padding: 14px;
	border: 1px solid rgba(15, 23, 42, .18);
	border-radius: 12px;
	font-size: 15px;
}

.hint {
	color: #64748b;
	font-size: 13px;
	font-weight: 600;
	margin-top: 4px;
}

.btnRow {
	display: flex;
	justify-content: flex-end;
	gap: 10px;
	margin-top: 10px;
}

.btnPrimary {
	padding: 12px 24px;
	border-radius: 12px;
	background: #1b7bff;
	color: #fff;
	border: 0;
	cursor: pointer;
	font-weight: 800;
	font-size: 15px;
}

.btnLine {
	padding: 10px 18px;
	border-radius: 12px;
	border: 1px solid #cbd5e1;
	text-decoration: none;
	color: #475569;
	background: #fff;
	font-weight: 800;
	font-size: 14px;
	display: inline-flex;
	align-items: center;
	cursor: pointer;
}
</style>

<div class="headRow">
	<div>
		<h2 class="title">리뷰게시판</h2>
		<div class="sub">구매하신 상품에 대한 리뷰를 작성해주세요.</div>
	</div>
	<div class="headBtns">
		<a class="btnLine" href="#review"> <i
			class="fa-solid fa-arrow-left me-2"></i>목록으로
		</a>
	</div>
</div>

<div class="card-box">
	<form id="reviewForm">
		<div class="form-row">
			<label class="lbl">주문상품</label> <select class="inp" id="orderNo"
				name="orderNo" required>
				<option value="">주문 선택</option>
			</select>
			<div id="orderHint" class="hint"></div>
		</div>

		<div class="form-row">
			<label class="lbl">별점</label> <select class="inp" name="reviewRating">
				<option value="5" selected>⭐⭐⭐⭐⭐ (5점 - 아주 좋아요)</option>
				<option value="4">⭐⭐⭐⭐ (4점 - 맘에 들어요)</option>
				<option value="3">⭐⭐⭐ (3점 - 보통이에요)</option>
				<option value="2">⭐⭐ (2점 - 그냥 그래요)</option>
				<option value="1">⭐ (1점 - 별로예요)</option>
			</select>
		</div>

		<div class="form-row">
			<label class="lbl">제목</label> <input class="inp" type="text"
				name="reviewTitle" maxlength="180" placeholder="제목을 입력하세요" required />
		</div>

		<div class="form-row">
			<label class="lbl">내용</label>
			<textarea class="ta" name="reviewCtt" maxlength="3000"
				placeholder="리뷰 내용을 입력하세요" required></textarea>
			<div class="hint">최대 3000자</div>
		</div>

		<div class="btnRow">
			<button class="btnPrimary" type="submit" id="btnSubmit">
				<i class="fa-solid fa-check me-1"></i> 리뷰 등록
			</button>
		</div>
	</form>
</div>
