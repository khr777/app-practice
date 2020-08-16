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
			<c:if test="${article.extra.file__common__attachment['1'] != null }">
				<tr>
					<th>첨부 파일 1</th>
					<td>
						<!-- 					&updateDate를 붙여서 활용하지 않으면 사용자는 백날 streamVideo?id=~의 동일한 자료를 보게된다. 확인완료.. 신기함-->
						<div class="video-box">
							<video controls
								src="/usr/file/streamVideo?id=${article.extra.file__common__attachment['1'].id}&updateDate=${article.extra.file__common__attachment['1'].updateDate}">video
								not supported
							</video>
						</div>
					</td>
				</tr>
			</c:if>
			<c:if test="${article.extra.file__common__attachment['2'] != null  }">
				<tr>
					<th>첨부 파일 2</th>
					<td>
						<div class="video-box">
							<video controls
								src="/usr/file/streamVideo?id=${article.extra.file__common__attachment['2'].id}&updateDate=${article.extra.file__common__attachment['2'].updateDate}">video
								not supported
							</video>
						</div>
					</td>
				</tr>
			</c:if>

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
<div class="btn-box con margin-top-20">
	<c:if test="${article.extra.actorCanModify }">
		<a class="btn btn-info" href="modify?id=${article.id}">수정</a>
	</c:if>
	<c:if test="${article.extra.actorCanDelete }">
		<a class="btn btn-info" href="doDelete?id=${article.id}"
			onclick="if ( confirm('삭제하시겠습니까?') == false) return false;">삭제</a>
	</c:if>
</div>
<c:if test="${isLogined}">
	<h2 class="con">댓글 작성</h2>

	<script>
	var ArticleWriteReplyForm__submitDone = false;
	function ArticleWriteReplyForm__submit(form) {


		
			
		if ( ArticleWriteReplyForm__submitDone ) {
			alert('처리중입니다.');
			return;
		}


		
		form.body.value = form.body.value.trim();
		if ( form.body.value.length == 0 ) {
			alert('댓글을 입력해주세요.');
			form.body.focus();
			return;
		}


		ArticleWriteReplyForm__submitDone = true;

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
				ArticleWriteReplyForm__submitDone = false;
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
							<input type="file" accept="video/*"
								name="file__reply__0__common__attachment__1">
						</div>
					</td>
				</tr>
				<tr>
					<th>첨부2 비디오</th>
					<td>
						<div class="form-control-box">
							<input type="file" accept="video/*"
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

.reply-modify-form-modal .form-control-label {
	width: 120px;
}

.reply-modify-form-modal .form-control-box {
	flex: 1 0 0;
}

.reply-modify-form-modal .video-box {
	width: 100px;
}
</style>

<div class="reply-modify-form-modal flex flex-jc-c flex-ai-c">
	<form action="" class="form1  bg-white padding-10 table-box"
		onsubmit="ReplyList__submitModifyForm(this); return false;">
		<input type="hidden" name="id" />
		<div class="form-row">
			<div class="form-control-label">내용</div>
			<div class="form-control-box">
				<textarea name="body" placeholder="내용을 입력해주세요." autofocus></textarea>
			</div>
		</div>
		<div class="form-row">
			<div class="form-control-label">첨부파일 1</div>
			<div class="form-control-box">
				<input type="file" accept="video/*"
					data-name="file__reply__0__common__attachment__1" />
				<div class="video-box video-box-file-1"></div>
			</div>
		</div>
		<div class="form-row">
			<div class="form-control-label">첨부파일 1 삭제</div>
			<div class="form-control-box">
				<label> <input type="checkbox"
					data-name="deleteFile__reply__0__common__attachment__1" value="Y" />
					삭제
				</label>
			</div>
		</div>
		<div class="form-row">
			<div class="form-control-label">첨부파일 2</div>
			<div class="form-control-box">
				<input type="file" accept="video/*"
					data-name="file__reply__0__common__attachment__2" />
				<div class="video-box video-box-file-2"></div>
			</div>
		</div>
		<div class="form-row">
			<div class="form-control-label">첨부파일 2 삭제</div>
			<div class="form-control-box">
				<label> <input type="checkbox"
					data-name="deleteFile__reply__0__common__attachment__2" value="Y" />
					삭제
				</label>
			</div>
		</div>
		<div class="btn-box margin-top-20">
			<div class="form-row">
				<div class="form-control-label">수정</div>
				<div class="form-control-box">
					<button type="submit" class="btn btn-primary padding-0-20">수정</button>
					<button type="button" class="btn btn-primary padding-0-20"
						onclick="ReplyList__hideModifyFormModal();">취소</button>
				</div>
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
	//alert(reply.id);
		
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
	

	

	var fileInput1 = form['file__reply__' + id + '__common__attachment__1'];
	var fileInput2 = form['file__reply__' + id + '__common__attachment__2'];

	var deleteFileInput1 = form["deleteFile__reply__" + id + "__common__attachment__1"];
	var deleteFileInput2 = form["deleteFile__reply__" + id + "__common__attachment__2"];

	// 삭제 체크가 되어있다면 업로드할 파일에 있는 것은 값을 비워준다..?
	if (deleteFileInput1.checked) {
		fileInput1.value = '';
	}
	if (deleteFileInput2.checked) {
		fileInput2.value = '';
	}

	ReplyList__submitModifyFormDone = true;



	// 파일 업로드 시작  // 얘가 실행된다... 
	var startUploadFiles = function() {
		if (fileInput1.value.length == 0 && fileInput2.value.length == 0) {
			if (deleteFileInput1.checked == false
					&& deleteFileInput2.checked == false) {
				onUploadFilesComplete(); // 파일업로드 할 가치가 없다고 판단되면 파일 업로드 끝났다. 라고 처리
				return;
			}
		}
			
		var fileUploadFormData = new FormData(form); // 파일 업로드할 가치가 있다면 ajax를 통해 실행 후, 파일 업로드 끝났다고 끝낸 함수 실행

		/*    안지워도 된다. 의미 없다.
		fileUploadFormData.delete("relTypeCode");
		fileUploadFormData.delete("relId");
		fileUploadFormData.delete("body");
		*/	
 		$.ajax({
			url : './../file/doUploadAjax',
			data : fileUploadFormData,
			processData : false,
			contentType : false,
			dataType:"json",
			type : 'POST',
			success : onUploadFilesComplete  
		});
	}

	// 파일 업로드 완료시 실행되는 함수 // 한마디로 startUploadFiles 실행 후 onUploadFilesComplete가 실행되는 것!
	var onUploadFilesComplete = function(data) {
		var fileIdsStr = '';
		if ( data && data.body && data.body.fileIdsStr ) {
			fileIdsStr = data.body.fileIdsStr;
		}

		startModifyReply(fileIdsStr);	// if문 작업 후 fileIdsStr을 startModifyReply에 넘겨주는 역할을 한다.
	};
	
	// 댓글 수정 시작  // 파일 업로드가 끝나면 실행되는.   파일 업로드 후 수정 시작하는
	var startModifyReply = function(fileIdsStr) {
		$.post('../reply/doModifyReplyAjax', {
			id: id,
			body: body,
			fileIdsStr: fileIdsStr
		}, onModifyReplyComplete, 'json');  // 그리고 댓글 수정이 끝나면 onModifyReplyComplete가 실행되는 것이다.
	};
	
 	// 댓글 수정이 완료되면 실행되는 함수
 	var onModifyReplyComplete =  function(data){
		if (data.resultCode && data.resultCode.substr(0, 2) == 'S-') {
			var $tr = $('.reply-list-box tbody > tr[data-id="' + id
					+ '"] .reply-body');
			$tr.empty().append(body);

			// 댓글이 수정되면 무조건 video-box를 먼저 비운다.
			var $tr = $('.reply-list-box tbody > tr[data-id="' + id + '"] .video-box').empty();

			if ( data && data.body && data.body.file__common__attachment) {
				for ( var fileNo in data.body.file__common__attachment) {
					var file = data.body.file__common__attachment[fileNo];

					var html = '<video controls src="/usr/file/streamVideo?id=' + file.id + '&updateDate=' + file.updateDate + '">video not supported</video>';
					$('.reply-list-box tbody > tr[data-id="' + id + '"] [data-file-no="' + fileNo + '"].video-box').append(html); 
				}
			}
		}

		if ( data.msg ) {
			alert(data.msg);
		}
		
		ReplyList__hideModifyFormModal();
		ReplyList__submitModifyFormDone = false;
	};
	
	startUploadFiles(); // 맨 처음에 얘가 실행된다... 그 다음에는 얘로 찾아가보자.
	
}

function ReplyList__showModifyFormModal(el) {
	$('html').addClass('reply-modify-form-modal-actived');
	
	var $tr = $(el).closest('tr');
	var originBody = $tr.data('data-originBody');
	
	
	
	
	var id = $tr.attr('data-id');

	var form = $('.reply-modify-form-modal form').get(0);

	//var attachment1 = $tr.data('attachment1');   // 혜련 추가 빼기
	
	
	//var reply = $tr.data('attachment1');  // 뭔가 불러오긴 한다!! 
	
	$(form).find('[data-name]').each(function(index, el){
		var $el = $(el);
		var name = $el.attr('data-name');
		name = name.replace('__0__', '__' + id + '__');
		name = $el.attr('name', name);


		if ( $el.prop('type') == 'file') {
			$el.val('');
		}
		else if ( $el.prop('type') == 'checkbox') {
			$el.prop('checked', false);
		}



		
	});



	for ( fileNo = 1; fileNo <= 2; fileNo++) {
		$('.reply-modify-form-modal .video-box-file-' + fileNo).empty();
		var videoName = 'reply__' + id + '__common__attachment__' + fileNo;

		// .reply-list-box 안에서 data-video-name= ??,   ??이라는 이름을 가진 값을 찾아서 $videoBox 안에 넣는다.
		var $videoBox = $('.reply-list-box [data-video-name="' + videoName + '"]');

		if ( $videoBox.length > 0 ) {
			$('.reply-modify-form-modal .video-box-file-' + fileNo).append($videoBox.html());
		}
				
	}

	
	
		
	
	form.id.value = id;
	form.body.value = originBody;
	//alert(file__reply__common__attachment__1.originFileName); // 불러온다 파일 이름을 !!!
	
/* 	if ( reply != null ) {
		alert(reply.originFileName);
		//form.file__reply__common__attachment__1.value = reply.originFileName;	
	} */
	
	
	//form.file__reply__${reply.id}__common__attachment__1.value = 3;
	//form.file__reply__id__common__attachment__['1'].value = attachment1.originFileName;  // 혜련 추가 빼기
	
	
}


function ReplyList__hideModifyFormModal() {
	$('html').removeClass('reply-modify-form-modal-actived');
	
}

//10초 (자동 로딩????댓글 업로드)
ReplyList__loadMoreInterval = 3 * 1000;



function ReplyList__loadMoreCallback(data) {
	if (data.body.replies && data.body.replies.length > 0) {
		ReplyList__lastLodedId = data.body.replies[data.body.replies.length - 1].id;
		ReplyList__drawReplies(data.body.replies);
	}
	setTimeout(ReplyList__loadMore, ReplyList__loadMoreInterval);
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

	// 있던 없던 일단 그리고 본다.
	for ( var fileNo = 1; fileNo <= 2; fileNo++ ) {
		html += '<div class="video-box" data-video-name="reply__' + reply.id + '__common__attachment__' + fileNo + '" data-file-no="' + fileNo + '">';
		if ( reply.extra.file__common__attachment && reply.extra.file__common__attachment[fileNo] ) {
			var file = reply.extra.file__common__attachment[fileNo];
			html += '<video controls src="/usr/file/streamVideo?id=' + file.id + '&updateDate=' + file.updateDate + '">video not supported</video>';
		}
		else {
			
		}
		html += '</div>';
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
	//$tr.data('attachment1', reply.extra.file__common__attachment['1']); // 얘가 파일 이름을 불러와 ㅠㅠㅠㅠㅠㅠ
	//$tr.data('file__reply__${reply.id}__common__attachment__1', reply.extra.file__common__attachment['1']); // 얘가 파일 이름을 불러와 ㅠㅠㅠㅠㅠㅠ
	
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
