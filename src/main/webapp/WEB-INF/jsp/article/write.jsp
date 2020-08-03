<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시물 작성</title>
</head>
<body>
	<h1>게시물 작성</h1>
	<form name="form" action="doActionWrite">
		<div class="label">제목
			<input name="title" type="text" placeholder="제목을 입력해주세요."/>
		</div>
		<div class="label">내용
			<input name="body" type="textarea" placeholder="내용을 입력해주세요."/>
		</div>
		<input type="submit" value="등록"/>
	</form>
	
</body>
</html>