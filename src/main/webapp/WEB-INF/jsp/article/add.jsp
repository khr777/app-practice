<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="게시물 작성" />
<%@ include file="../part/head.jspf"%>
<div class="add-box con">
	<form name="form" action="doAdd" method="POST">
		<div class="label">
			제목 <input name="title" type="text" placeholder="제목을 입력해주세요." />
		</div>
		<div class="label">
			내용 <textarea name="body" placeholder="내용을 입력해주세요."></textarea>
		</div>
		<input type="submit" value="등록" />
		<input type="reset" value="취소" onclick="history.back();">
	</form>
</div>
<%@ include file="../part/foot.jspf"%>