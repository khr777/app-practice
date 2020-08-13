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
				<th>작성자</th>
				<td>${article.extra.writer}</td>
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
				<td>${article.body}</td>
			</tr>
			<tr>
				<th>첨부 영상</th>
				<td>
					<c:if test="${article.extra.file__common__attachment__1 != null }">
						<video controls src="/usr/file/streamVideo?id=${article.extra.file__common__attachment__1.id}"></video>
					</c:if> 
					<c:if test="${article.extra.file__common__attachment__2 != null }">
						<video controls	src="/usr/file/streamVideo?id=${article.extra.file__common__attachment__2.id}"></video>
					</c:if>
				</td>
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
<c:if test="${isLogined}">
	<h2 class="con">댓글 작성</h2>

<script>
	function ArticleWriteReplyForm__submit(form) {
		form.body.value = form.body.value.trim();
		if ( form.body.value.length == 0 ) {
			alert('댓글을 입력해주세요.');
			form.body.focus();
			return;
		}


		// 실행순서 : 1번 __ 댓글&동영상 파일 업로드 작업에서 제일 먼저 실행되는 JS
		var startUploadFiles = function(onSuccess) {
			
			// 의미 : 파일 첨부를 하지 않았을 때에는 바로 onSuccess();를 해버린다.
			// var fileUploadFormData = new  ~~~ $.ajax({ url ~~ 과정을 스킵하고 바로 onSuccess 작업이 실행되게 하는 코드! 다음 단계로 넘어가버리는!
			if ( form.file__reply__0__common__attachment__1.value.length == 0 && form.file__reply__0__common__attachment__2.value.length == 0 ) {
				onSuccess();
				return;
			}

			// 갑자기 new FormData(form)이 나온 이유 : Ajax로 파일을 전송하려면 어쩔 수 없이 꼭 객체를 선언해주어야 한다.
			var fileUploadFormData = new FormData(form);
			
			// 파일을 먼저 전송할 때, 필요하지 않은 자료를 지우는 코드 (파일 전송 시, 파일만 있으면 된다.)
			// ArticleWriteReplyForm__submit  form을 보면 파일 전송시 필요없는 것들을 form 전송하고 있는 것을 확인할 수 있다.  
			fileUploadFormData.delete("relTypeCode");
			fileUploadFormData.delete("relId");
			fileUploadFormData.delete("body");

			// 파일을 보내는 코드( 방식은 정해져있다. 준수해야 한다. 특히 processData, contentType은 꼭 false를 해주어야 한다.)
			// 2 startUploadFiles ajax 호출 시작  1시
			$.ajax({
				url : './../file/doUploadAjax',
				data : fileUploadFormData,
				processData : false,
				contentType : false,
				dataType:"json",
				type : 'POST',
				success : onSuccess // 얘는 실행순서 1번의 function(onSuccesss)를 의미한다. // 1년뒤 
				// 위에서부터 아래로 실행 순서와는 상관없이 success는 실행되고 아주 한참뒤에 실행되는 아이.
			});
			// 파일을 전송하고 얻은 자료를 onSuccess한테 전달하는 역할을 한다. onSuccess가 뭔데?  
			// 3 startUploadFiles ajax 호출 끝   2시
		}

		// 첨부된 파일이 있다면 전달받은 파일 정보들과 댓글을 함께 조합?하여 전송하는 것이다. 
		var startWriteReply = function(fileIdsStr, onSuccess) {

			// 6  startWriteReply ajax 호출
			$.ajax({
				url : './../reply/doWriteReplyAjax',
				data : {
					fileIdsStr: fileIdsStr,
					body: form.body.value,
					relTypeCode: form.relTypeCode.value,
					relId: form.relId.value
				},
				dataType:"json",
				type : 'POST',
				success : onSuccess
			});

			// 7  startWriteReply ajax 호출 완료
		};

		
		// funciont(data) { ~~~~~~ 부터가 onSuccess 이다! }
		// startUploadFiles가 먼저 실행이 다~~되고 일을 끝낸 후에! (function(data) == onSuccess가 실행되는 순서이다! )
		startUploadFiles(function(data) {
			// 4  startUploadFiles ajax 호출 결과 도착
			var idsStr = '';
			if ( data && data.body && data.body.fileIdsStr ) {
				idsStr = data.body.fileIdsStr;
			}

			// startWriteReply가 먼저 다 ~~ 실행되고 완료 된 후에, (function(data){ ~~~가 실행되는 것이다.
			// 5  startWriteReply 함수 호출
			startWriteReply(idsStr, function(data) {
				// 8  startWriteReply ajax 호출결과 도착
				if ( data.msg ) {
					alert(data.msg);
				}
				

				// 이렇게 값들을 비워주기 때문에 댓글&파일 전송을 한 후, 기본값(무)으로 돌아오게 되는 것이다.
				// 이렇게 해주지 않을 경우 댓글&파일을 전송한 후에도 좀 전에 전송한 내용이 그대로 남아있을 것이다.
				form.body.value = '';
				form.file__reply__0__common__attachment__1.value = '';
				form.file__reply__0__common__attachment__2.value = '';
			});	
		});

		
	}
</script>
	<!-- <form method="POST" class="form1" action="./doWriteReply"  Ajax화로 method와 action이 의미없어짐 -->
	<!-- Ajax화로 form은 이제 발송용으로 사용되지 않는다. -->
	<form class="form1 table-box con"
		onsubmit="ArticleWriteReplyForm__submit(this); return false;">
		<input type="hidden" name="relTypeCode" value="article" /> <input
			type="hidden" name="relId" value="${article.id}" />
		<table>
			<tbody>
				<tr>
					<th>내용</th>
					<td>
						<div class="form-control-box">
							<textarea class="height-100px" placeholder="내용을 입력해주세요."
								name="body" maxlength="300" autofocus></textarea>
						</div>
					</td>
				</tr>
				<tr>
					<th>첨부1 비디오</th>
					<td>
						<div class="form-control-box">
							<input type="file" accept="video/*" capture
								name="file__reply__0__common__attachment__1">
						</div>
					</td>
				</tr>
				<tr>
					<th>첨부2 비디오</th>
					<td>
						<div class="form-control-box">
							<input type="file" accept="video/*" capture
								name="file__reply__0__common__attachment__2">
						</div>
					</td>
				</tr>
				<tr>
					<th>작성</th>
					<td><input type="submit" value="작성" /></td>
				</tr>
			</tbody>
		</table>
	</form>
</c:if>

<h2 class="con">댓글 리스트</h2>


<div class="reply-list-box table-box con">
	<table>
		<colgroup>
			<col width="100" />
			<col width="200" />
			<col width="200" />
			<col width="600" />
			<col width="150" />
		</colgroup>
		<thead>
			<tr>
				<th>번호</th>
				<th>날짜</th>
				<th>작성자</th>
				<th>내용</th>
				<th>비고</th>

			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
</div>


<style>
.reply-modify-form-modal {
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background-color: rgba(0, 0, 0, 0.4);
	display: none;
}

.reply-modify-form-modal-actived .reply-modify-form-modal {
	display: flex;
}
</style>

<div class="reply-modify-form-modal flex flex-jc-c flex-ai-c">
	<form action="" class="form1  bg-white padding-10"
		onsubmit="ReplyList__submitModifyForm(this); return false;">
		<input type="hidden" name="id" />
		<div class="form-row">
			<div class="form-control-label">내용</div>
			<div class="form-control-box">
				<textarea name="body" placeholder="내용을 입력해주세요." autofocus></textarea>
			</div>
		</div>
		<div class="form-row">
			<div class="form-control-label">수정</div>
			<div class="form-control-box">
				<button type="submit">수정</button>
				<button type="button" onclick="ReplyList__hideModifyFormModal();">취소</button>
			</div>
		</div>
	</form>
</div>



<script>















/* function replaceAll(str, searchStr, replaceStr) {
	return str.split(searchStr).join(replaceStr);
} */

var ReplyList__$box = $('.reply-list-box');
var ReplyList__$tbody = ReplyList__$box.find('tbody');
var ReplyList__lastLodedId = 0;

var ReplyList__submitModifyFormDone = false;

function ReplyList__submitModifyForm(form) {

		
	if ( ReplyList__submitModifyFormDone ) {
		alert('처리중입니다.');
		return;
	}

	
	form.body.value = form.body.value.trim();

	if ( form.body.value.length == 0 ) {
		alert('내용을 입력해주세요.');
		form.body.focus();

		return;
	}

	var id = form.id.value;
	var body = form.body.value;
	
	

	ReplyList__submitModifyFormDone = true;

	$.post('../reply/doModifyReplyAjax', {
		id: id,
		body: body
	
	}, function(data){
		if (data.resultCode && data.resultCode.substr(0, 2) == 'S-') {
			// 성공시에는 기존에 그려진 내용을 수정해야 한다.!!
			var $tr = $('.reply-list-box tbody > tr[data-id="' + id
					+ '"] .reply-body');
			$tr.empty().append(body);
		}
		ReplyList__hideModifyFormModal();
		ReplyList__submitModifyFormDone = false;
		}, 'json');

	
}

function ReplyList__showModifyFormModal(el) {
	$('html').addClass('reply-modify-form-modal-actived');
	
	var $tr = $(el).closest('tr');
	var originBody = $tr.data('data-originBody');

	
	
	
	var id = $tr.attr('data-id');

	var form = $('.reply-modify-form-modal form').get(0);


	
	form.id.value = id;
	form.body.value = originBody;
	
	
}


function ReplyList__hideModifyFormModal() {
	$('html').removeClass('reply-modify-form-modal-actived');
	
}


function ReplyList__loadMoreCallback(data) {
	if (data.body.replies && data.body.replies.length > 0) {
		ReplyList__lastLodedId = data.body.replies[data.body.replies.length - 1].id;
		ReplyList__drawReplies(data.body.replies);
	}
	setTimeout(ReplyList__loadMore, 2000);
}

function ReplyList__loadMore() {
	$.get('../reply/getForPrintRepliesRs',{   // get : select 하는 것.
			articleId : param.id, //${param.id}, head에 구워?놓았기 때문에 중괄호 없이 사용 가능
			from : ReplyList__lastLodedId + 1 
		}, ReplyList__loadMoreCallback, 'json');  // ReplyList__loadMore() 함수가 다 실행되면 마지막에 실행되는 함수
	}    // 바로 실행되지 않고, 예약을 걸어놓는 개념. 이런 함수를 Callback 함수라고 한다.
	    // 만약 ReplyList__loadMoreCallback() 으로 괄호가 붙는다면 '동시'에 실행됨을 의미한다! 
	    // 기능을 맡겨만 놓고 통신이 끝나면 실행되도록.


function ReplyList__drawReplies(replies) {
	for ( var i = 0; i < replies.length; i++ ) {
		var reply = replies[i];
		ReplyList__drawReply(reply);
	}
}




function ReplyList__drawReply(reply) {

	var html = '';

	// reply.body와 video를 따로 보여준다. 만약 reply.extra.file~ 의 값이 있다면 video를 보여주는 것. 
	// replyService에서 반복문을 통해 reply.extra~변수에 파일을 저장해뒀기 때문에 가능하다.
	html += '<tr data-id="' + reply.id + '">';
	html += '<td>' + reply.id + '</td>';
	html += '<td>' + reply.regDate + '</td>';
	html += '<td>' + reply.extra.writer + '</td>';
	html += '<td>';
	html += '<div class="reply-body">' + reply.body + '</div>';
	if (reply.extra.file__common__attachment__1) {
        var file = reply.extra.file__common__attachment__1;
        html += '<video controls src="/usr/file/streamVideo?id=' + file.id + '">video not supported</video>';
    }

	if (reply.extra.file__common__attachment__2) {
        var file = reply.extra.file__common__attachment__2;
        html += '<video controls src="/usr/file/streamVideo?id=' + file.id + '">video not supported</video>';
	}
    
	html += '</td>';
	html += '<td>';
	if ( reply.extra.actorCanDelete) {
		html += '<span class="loading-delete-inline">삭제중입니다...</span>';
		html += '<button type="button" class="loading-none" onclick="if ( confirm(\'정말 삭제하시겠습니까?\')) Reply__delete(this);">삭제</button>';	
	}
	if ( reply.extra.actorCanModify) {
		html += '<button  type="button" class="loading-none" onclick="ReplyList__showModifyFormModal(this);">수정</button>';	
	}
	html += '</td>';
	html += '</tr>';
				

	var $tr = $(html);
	// data는 엘리먼트에 변수를 추가할 수 있다.
	// data는 엘리먼트에 데이터를 추가할 수 있다.
	// data는 attr보다 더 복잡한 데이터도 저장 가능.
	$tr.data('data-originBody', reply.body);
	
	ReplyList__$tbody.prepend($tr);
	
}	

ReplyList__loadMore();





// (obj) a태그를 조종할 수 있는 리모콘 버튼이다.
function Reply__delete(obj) {
	var $clickedBtn = $(obj);  // obj 버튼을 -> $(obj); 이런식으로 만들어서 var에 담으면? 관리가 편해진다.
	// $clickedBtn : 교장 ( 교장은 학생을 관리한다.)

	//$clickedBtn.remove();  이것을 할게 아니라 예시만 들어주시고 삭제하셨음.
	// $clickedBtn이 관리하고 있는 학생은 a태그(삭제) 이다. 해당 a태그에서 함수 호출하고 this 자신을 넘겼기 때문에.

	// parent 필요량 만큼 붙여주기 귀찮
	//var $tr = $clickedBtn.parent().parent(); // a태그의 부모_td의 부모_tr !!!!
	
	var $tr = $clickedBtn.closest('tr'); // 가장 가까운 조상 중에서 tr 가져와라.
	
	//$tr.remove();

	var replyId = parseInt($tr.attr('data-id'));

	$tr.attr('data-loading', 'Y');
	$tr.attr('data-loading-delete', 'Y');
	
	$.post(
		'./../reply/doDeleteReplyAjax',  //편지 받는 사람
		{
			id: replyId
		},
		function(data) { // 답장을 받았을 때 내가 해야 하는 행동.
			$tr.attr('data-loading', 'N');
			$tr.attr('data-loading-delete', 'N');

			// 아래는 회원 기능이 없기 때문에 삭제할 수 없어서 위에 만들어버림
			if ( data.resultCode.substr(0, 2) == 'S-' ) {
				
				$tr.remove();  // 아작스 실패할 수도 있으니까 $tr.attr 다음에 remove! 성공한다면 !
				 
			}
	 		
			else {
				if ( data.msg ) {
					alert(data.msg);
				}
			}
		}, 'json' );
	
}



</script>



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

textarea {
	width: 100%;
}

.reply-list-box {
	margin-bottom: 50px;
}

.reply-list-box tr .loading-delete-inline {
	display: none;
	font-weight: bold;
	color: red;
}

.reply-list-box tr[data-loading="Y"] .loading-none {
	display: none;
}

/* loading이면서 delete-loading 일 때 */
.reply-list-box tr[data-loading="Y"][data-loading-delete="Y"] .loading-delete-inline
	{
	display: inline;
}

.reply-list-box tr[data-modify-mode="Y"] .modify-mode-none {
	display: none;
}

.reply-list-box tr .modify-mode-inline {
	display: none;
}

.reply-list-box tr[data-modify-mode="Y"] .modify-mode-inline {
	display: inline;
}

.reply-list-box tr .modify-mode-block {
	display: none;
}

.reply-list-box tr[data-modify-mode="Y"] .modify-mode-block {
	display: block;
}
</style>




<%@ include file="../part/foot.jspf"%>
