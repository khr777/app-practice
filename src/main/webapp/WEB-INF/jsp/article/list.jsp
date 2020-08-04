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
		<div class="search">
			<div class="search-box ">
				<form action="list">
					<input type="hidden" name="page" value="1" />
					<input type="hidden" name="searchKeywordType" value="title" />
					<input type="hidden" name="searchKeywordTypeBody" value="body" />
					<input type="text" name="searchKeyword"	value="${param.searchKeyword}" class="box" />
					<button type="submit" class="search-button">검색</button>
				</form>
			</div>
			<div class="cateItem-content">
				<div class="con total-count">총 게시물 수 : ${totalCount}</div>
			</div>
		</div>
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
	<div class="paging-box">
		<c:forEach var="i" begin="1" end="${totalPage}" step="1">
			<div class="paging-num-box ${i == cPage ? 'current' : ''}">
				<a
					href="?searchKeywordType=${param.searchKeywordType}&searchKeywordTypeBody=${param.searchKeywordTypeBody}&searchKeyword=${param.searchKeyword}&page=${i}">${i}</a>
			</div>
		</c:forEach>
	</div>
</div>




<style>
.table-box .paging-box {
	display: flex;
	padding: 10px;
}

.table-box .paging-box .paging-num-box {
	padding: 10px;
}

.paging-box {
	display: flex;
	font-size: 1.2rem;
	justify-content: center;
}

.paging-box .paging-num-box>a {
	padding: 20px 10px;
	display: block;
	text-decoration: underline;
	color: #787878;
}

.paging-box .paging-num-box:hover>a {
	padding: 20px 10px;
	display: block;
	text-decoration: underline;
	color: black;
}

.paging-box .paging-num-box.current>a {
	color: red;
}
</style>




<%@ include file="../part/foot.jspf"%>