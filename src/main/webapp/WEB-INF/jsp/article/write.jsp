<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="게시물 작성" />
<%@ include file="../part/head.jspf"%>

<!-- <textarea></textarea> 는 필히 붙여서 써야 placeholder가 나타난다 -->
<form method="POST" class="form1 table-box con" action="doWrite"
	onsubmit="ArticleWriteForm__submit(this); return false;">
	<input type="hidden" name="redirectUrl" value="/usr/article/detail?id=#id">
	<input type="hidden" name="loginedMemberId" value="${loginedMemberId}"/>
	<input type="hidden" name="relTypeCode" value="article" /> 
	<input type="hidden" name="relId" value="${param.id}" />   
	<table>
		<tbody>
			<tr>
				<th>제목</th>
				<td>
					<div class="form-control-box">
						<input type="text" placeholder="제목을 입력해주세요." name="title"
							maxlength="100" />
					</div>
				</td>
			</tr>
			<tr>
				<th>내용</th>
				<td>
					<div class="form-control-box">
						<textarea placeholder="내용을 입력해주세요." name="body" maxlength="2000"></textarea>
					</div>
				</td>
			</tr>
			<tr>
					<th>첨부1 비디오</th>
					<td>
						<div class="form-control-box">
							<input type="file" accept="video/*" capture
								name="file__article__0__common__attachment__1">
						</div>
					</td>
				</tr>
			<tr>
			<tr>
					<th>첨부2 비디오</th>
					<td>
						<div class="form-control-box">
							<input type="file" accept="video/*" capture
								name="file__article__0__common__attachment__2">
						</div>
					</td>
				</tr>
				<th>작성</th>
				<td>
					<button class="btn btn-primary" type="submit">작성</button>
				</td>
			</tr>
		</tbody>
	</table>
</form>




<script>
	var ArticleWriteForm__submitDone = false;
	
	function ArticleWriteForm__submit(form) {

		if ( ArticleWriteForm__submitDone ) {
			alert('처리중입니다.');
			return;
		}
		
		form.title.value = form.title.value.trim();

		if (form.title.value.length == 0) {
			alert('제목을 입력해주세요.');
			form.title.focus();
			return;
		}

		form.body.value = form.body.value.trim();

		if (form.body.value.length == 0) {
			alert('내용을 입력해주세요.');
			return;
		}


		// 실행순서 : 1번 __ 댓글&동영상 파일 업로드 작업에서 제일 먼저 실행되는 JS
		var startUploadFiles = function(onSuccess) {
			
			// 의미 : 파일 첨부를 하지 않았을 때에는 바로 onSuccess();를 해버린다.
			// var fileUploadFormData = new  ~~~ $.ajax({ url ~~ 과정을 스킵하고 바로 onSuccess 작업이 실행되게 하는 코드! 다음 단계로 넘어가버리는!
			if ( form.file__article__0__common__attachment__1.value.length == 0 && form.file__article__0__common__attachment__2.value.length == 0 ) {
				onSuccess();
				return;
			}

			// 갑자기 new FormData(form)이 나온 이유 : Ajax로 파일을 전송하려면 어쩔 수 없이 꼭 객체를 선언해주어야 한다.
			var fileUploadFormData = new FormData(form);
			
			// 파일을 먼저 전송할 때, 필요하지 않은 자료를 지우는 코드 (파일 전송 시, 파일만 있으면 된다.)
			// ArticleWriteReplyForm__submit  form을 보면 파일 전송시 필요없는 것들을 form 전송하고 있는 것을 확인할 수 있다.  
			fileUploadFormData.delete("relTypeCode");
			fileUploadFormData.delete("redirectUrl");
			fileUploadFormData.delete("body");
			fileUploadFormData.delete("loginedMemberId");

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
				url : './../article/doWriteAjax',
				data : {
					fileIdsStr: fileIdsStr,
					body: form.body.value,
					redirectUrl: form.redirectUrl.value,	
					title: form.title.value,
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
				form.file__article__0__common__attachment__1.value = '';
				form.file__article__0__common__attachment__2.value = '';

				if ( data.resultCode.substr(0, 2) == 'S-' ) {
					var id = data.body.substr(0, 26);
					location.replace(id);
				}

			});
		});


		//form.submit();
		
		ArticleWriteForm__submitDone = true;
	
	}
	
</script>
<%@ include file="../part/foot.jspf"%>