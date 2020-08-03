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
	<input type="button"
			onclick="location.href='../article/modify?id=${article.id}'"
			value="수정" />
		<input type="button"
			onclick="location.href='../article/delete?id=${article.id}'"
			value="삭제" />
</div>

<div class="btns con">
	<a href="./list">게시물 리스트</a> 
	<a href="./add">게시물 추가</a> 
	<a onclick="if ( confirm('삭제하시겠습니까?') == false ) return false;"	href="./doDelete?id=${article.id}">게시물 삭제</a>
</div>	

<%@ include file="../part/foot.jspf"%>