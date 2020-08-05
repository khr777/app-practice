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

<script>

	
	function ArticleReply__submitWriteForm(form) {
		form.body.value = form.body.value.trim();
		if ( form.body.value.length == 0 ) {
			alert('댓글을 입력해주세요.');
			form.body.focus();
			return;
		}

		// Ajax화 시작
		$.post(	'./doWriteReplyAjax',   // 기존 form 의 action을 입력해주고 전송할 데이터를 입력해준다.
			{	
				articleId : ${param.id},
				body: form.body.value
			},
			function(data) {
			
			},
			'json' // 필수
		);
		form.body.value = '';
		// body 를 전송하고 원문을 비워준다. 그래야 댓글창으로 돌아왔을 때, 빈칸으로 입력 가능하다!
	}
</script>
<!-- <form method="POST" class="form1" action="./doWriteReply"  Ajax화로 method와 action이 의미없어짐 -->
<!-- Ajax화로 form은 이제 발송용으로 사용되지 않는다. -->
<form class="form1"
	onsubmit="ArticleReply__submitWriteForm(this); return false;">
	<!-- 	<input type="hidden" name="redirectUrl" value="/article/detail?id=#id"> -->
	<%-- 	<input type="hidden" name="articleId" value="${article.id}"> --%>
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

<script>
var ArticleReply__lastLoadedArticleReplyId = 0;

function ArticleReply__loadList() {
	$.get('./getForPrintArticleRepliesRs',{
			id : ${param.id},
			from : ArticleReply__lastLoadedArticleReplyId + 1 
		}, function(data) {
			data.articleReplies = data.articleReplies.reverse();
			for ( var i = 0; i < data.articleReplies.length; i++ ) {
				var articleReply = data.articleReplies[i];
				ArticleReply__drawReply(articleReply);

				ArticleReply__lastLoadedArticleReplyId = articleReply.id;
			}
		},'json' );
}

var ArticleReply__$listTbody;


function ArticleReply__drawReply(articleReply) {
	var html = '';
	html += '<tr data-article-reply-id="' + articleReply.id + '"">';
	html += '<td>' + articleReply.id + '</td>';
	html += '<td>' + articleReply.regDate + '</td>';
	html += '<td>' + articleReply.body+ '</td>';
	html +=  '<td>';
	html += '<a href="#">삭제</a>';
	html += '<a href="#">수정</a>';
	html += '</td>';
	html += '</tr>';
	



	
	ArticleReply__$listTbody.prepend(html);
}
// html ? 밑에까지 다 처리가 된 후 마지막에 실행되게 하는 함수 실행법 
$(function() {

	ArticleReply__$listTbody = $('.article-reply-list-box > table tbody');
	//ArticleReply__loadList();

	setInterval(ArticleReply__loadList, 1000);
});
</script>

<div class="article-reply-list-box table-box con">
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
			<%-- <c:forEach items="${articleReplies}" var="articleReply">
				<div class="replyList">
					<tr>
						<td>${articleReply.id}</td>
						<td>${articleReply.regDate}</td>
						<td>${articleReply.body}</td>
						<td><a href="#">삭제</a>
							<a href="#">수정</a>
						</td>
					</tr>
				</div>
			</c:forEach> --%>
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

a:hover {
	color: red;
}
</style>




<%@ include file="../part/foot.jspf"%>