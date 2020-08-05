<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="게시물 상세내용" />
<%@ include file="../part/head.jspf"%>


<div class="table-box con">
	<table>
		<colgroup>
			<col width="50" />
			<col width="200" />
		</colgroup>
		<tbody>
			<tr>
				<th>번호</th>
				<td>${article.id }</td>
			</tr>
			<tr>
				<th>날짜</th>
				<td>${article.regDate }</td>
			</tr>
			<tr>
				<th>조회수</th>
				<td>${article.hit}</td>
			</tr>
			<tr>
				<th>제목</th>
				<td>${article.title }</td>

			</tr>
			<tr>
				<th>내용</th>
				<td>${article.body }</td>
			</tr>
		</tbody>
	</table>
	<div class="button">
		<div class="back">
			<input type="button" onclick="location.href='../article/list'"
				value="뒤로가기" />
		</div>
		<div class="modifyAndDelete">
			<input type="button"
				onclick="location.href='../article/modify?id=${article.id}'"
				value="수정" /> <input type="button"
				onclick="location.href='../article/delete?id=${article.id}'"
				value="삭제" />
		</div>
		<div class="move-button">
			<c:if test="${beforeId > 0}">
				<input class="before" value="이전글" type="button"
					onclick="location.href='detail?id=${beforeId}'">
			</c:if>
			<c:if test="${afterId != -1}">
				<input class="after" value="다음글" type="button"
					onclick="location.href='detail?id=${afterId}'">
			</c:if>

		</div>
	</div>
</div>
<h2 class="con">댓글 작성</h2>
<form method="POST" class="form1" action="./doWriteReply"
	onsubmit="ArticleReplyWriteForm__submit(this); return false;">
	<input type="hidden" name="redirectUrl" value="/article/detail?id=#id">
	<input type="hidden" name="articleId" value="${article.id}">
	<div class="table-box con">
		<table>
			<tbody>
				<tr>
					<th>내용</th>
					<td>
						<div class="form-control-box">
							<textarea class="height-100px" placeholder="내용을 입력해주세요."
								name="body" maxlength="2000" autofocus></textarea>
						</div>
					</td>
				</tr>
				<tr>
					<th>작성</th>
					<td>
						<button class="btn btn-primary" type="submit">작성</button>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</form>

<h2 class="con">댓글 리스트</h2>
<div class="table-box con">
	<table>
		<colgroup>
			<col width="100" />
			<col width="200" />
			<col width="700" />
			<col width="150" />
		</colgroup>
		<thead>
			<tr>
				<th>번호</th>
				<th>날짜</th>
				<th>내용</th>
				<th>비고</th>

			</tr>
		</thead>
		<tbody>
			<c:forEach items="${articleReplies}" var="articleReply">
				<div class="replyList">
					<tr>
						<td>${articleReply.id}</td>
						<td>${articleReply.regDate}</td>
						<td>${articleReply.body}</td>
						<td><a
							href="./doDeleteReply?id=${articleReply.id}&redirectUrl=/article/detail?id=${article.id}"
							onclick="if ( confirm('삭제하시겠습니까?') == false ) {return false; }">삭제</a>
						</td>
					</tr>
				</div>
			</c:forEach>
		</tbody>
	</table>
</div>


<style>
.table-box {
	
}

.table-box  .button {
	display: flex;
}

.table-box .button .back {
	margin-left: 30px;
}



.table-box  .button .modifyAndDelete {
	margin-right: 0;
	margin-left: auto;
	width: 100px;
	justify-content: space-around;
}

.table-box .replyList tr > td:hover a:first-child {
	color:red;
}
</style>




<%@ include file="../part/foot.jspf"%>