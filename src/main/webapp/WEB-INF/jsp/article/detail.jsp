<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시물 상세보기</title>
</head>
<body>
	<h1>게시물 상세보기</h1>
	<div class="detail-box">
		<div class="title">제목 : ${article.title}</div>
		<div class="regDate">날짜 : ${article.regDate}</div>
		<div class="body">내용 : ${article.body}</div>
	</div>
	
</body>
</html>