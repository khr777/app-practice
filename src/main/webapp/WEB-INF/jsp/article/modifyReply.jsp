<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="게시물 댓글 수정" />
<%@ include file="../part/head.jspf"%>

<script>
	function submitModifyForm(form) {
		form.body.value = form.body.value.trim();
		if (form.body.value.length == 0) {
			alert('내용을 입력해주세요.');
			form.body.focus();
			return false;
		}

		form.submit();
	}
</script>

<form class="con common-form" action="doModifyReply" method="POST"
	onsubmit="submitModifyForm(this); return false;">
	<input type="hidden" name="id" value="${articleReply.id}">
	<input type="hidden" name="redirectUrl" value="${param.redirectUrl}"/>
	<div class="table-box">
		<table>
			<colgroup>
				<col width="180" />
			</colgroup>
			<tbody>
				<tr>
					<th>번호</th>
					<td>${articleReply.id}</td>
				</tr>
				<tr>
					<th>날짜</th>
					<td>${articleReply.regDate}</td>
				</tr>
				<tr>
					<th>내용</th>
					<td><textarea maxlength="300" class="height-100px" name="body" placeholder="내용">${articleReply.body}</textarea></td>
				</tr>
				<tr>
					<th>수정</th>
					<td><input type="submit" value="수정"> <input
						type="reset" value="취소" onclick="history.back();"></td>
				</tr>
			</tbody>
		</table>
	</div>
</form>

<style>
.common-form .table-box textarea {
	width:100%;
}
</style>







<div class="btns con">
	<a href="./list">게시물 리스트</a> <a href="./add">게시물 추가</a> <a
		onclick="if ( confirm('삭제하시겠습니까?') == false ) return false;"
		href="./doDelete?id=${article.id}">게시물 삭제</a>
</div>

<%@ include file="../part/foot.jspf"%>