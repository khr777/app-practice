<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="게시물 수정" />
<%@ include file="../part/head.jspf"%>

<script>
	var submitModifyFormDone = false;

	
	function submitModifyForm(form) {

		if ( submitModifyFormDone ) {
			alert('처리중입니다.');
			return;
		}

		
		form.title.value = form.title.value.trim();
		if (form.title.value.length == 0) {
			alert('제목을 입력해주세요.');
			form.title.focus();
			return false;
		}
		form.body.value = form.body.value.trim();
		if (form.body.value.length == 0) {
			alert('내용을 입력해주세요.');
			form.body.focus();
			return false;
		}
		
		form.submit();
		submitModifyFormDone = true;
	}
</script>

<form class="form1 table-box con" action="doModify" method="POST"
	onsubmit="submitModifyForm(this); return false;">
	<input type="hidden" name="id" value="${article.id}">
	<table>
		<tbody>
			<tr>
				<th>제목</th>
				<td>
					<div class="form-control-box">
						<input type="text" autofocus="autofocus" value="${article.title}" name="title"
							maxlength="100" />
					</div>
				</td>
			</tr>
			<tr>
				<th>내용</th>
				<td>
					<div class="form-control-box">
						<textarea placeholder="내용을 입력해주세요." name="body" maxlength="2000">${article.body}</textarea>
					</div>
				</td>
			</tr>
			<tr>
				<th>작성</th>
				<td>
					<button class="btn btn-primary" type="submit">수정</button>
					<input type="reset" value="취소" onclick="history.back();">
				</td>
			</tr>
		</tbody>
	</table>
</form>

<%@ include file="../part/foot.jspf"%>