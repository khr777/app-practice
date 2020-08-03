<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="게시물 리스트" />
<%@ include file="../part/head.jspf"%>


<div class="table-box con">
	<table>
		<colgroup>
			<col width="100" />
			<col width="200" />
		</colgroup>
		<thead>
			<tr>
				<th>번호</th>
				<th>날짜</th>
				<th>제목</th>
				<th>비고</th>

			</tr>
		</thead>
		<tbody>
			<c:forEach items="${articles}" var="article">
				<div>
					<tr>
						<td>${article.id}</td>
						<td>${article.regDate}</td>
						<td><a href="detail?id=${article.id}">${article.title}</a></td>
						<td><input type="button"
							onclick="location.href='../article/modify?id=${article.id}'"
							value="수정" /> <input type="button"
							onclick="location.href='../article/delete?id=${article.id}'"
							value="삭제" /></td>
					</tr>

				</div>
			</c:forEach>
		</tbody>
	</table>
</div>
<%@ include file="../part/foot.jspf"%>