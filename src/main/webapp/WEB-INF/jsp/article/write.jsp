<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="게시물 작성" />
<%@ include file="../part/head.jspf"%>



<!-- form으로 파일 전송하려면 원래 정석으로는 enctype="multipart/form-data" 를 <form ~ 안에 써주어야 한다. -->
<!-- <textarea></textarea> 는 필히 붙여서 써야 placeholder가 나타난다 -->
<form method="POST" class="form1 table-box con" action="doWrite"
	onsubmit="ArticleWriteForm__submit(this); return false;">
	<input type="hidden" name="redirectUri" value="/article/detail?id=#id"> <input type="hidden"
		name="loginedMemberId" value="${loginedMemberId}" /> <input
		type="hidden" name="relTypeCode" value="article" /> <input
		type="hidden" name="relId" value="${param.id}" />
		<input type="hidden" name="fileIdsStr"/>
	<table>
		<colgroup>
			<col width="100"></col>
		</colgroup>
		<tbody>
			<tr>
				<th>제목</th>
				<td>
					<div class="form-control-box">
						<input type="text" placeholder="제목을 입력해주세요." name="title"
							maxlength="100" autofocus />
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
			form.body.focus();
			return;
		}


		var maxSizeMb = 50;
		var maxSize = maxSizeMb * 1024 * 1024 // 50MB

		if ( form.file__article__0__common__attachment__1.value ) {
			if ( form.file__article__0__common__attachment__1.files[0].size > maxSize ) {
				alert(maxSize + "MB 이하의 파일을 업로드 해주세요.");
				return;
			}
		}

		if ( form.file__article__0__common__attachment__2.value ) {
			if ( form.file__article__0__common__attachment__2.files[0].size > maxSize ) {
				alert(maxSize + "MB 이하의 파일을 업로드 해주세요.");
				return;
			}
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


		ArticleWriteForm__submitDone = true;
		startUploadFiles(function(data) {

			var fileIdsStr = '';

			if ( data && data.body && data.body.fileIdsStr ) {
				fileIdsStr = data.body.fileIdsStr;
			}

			form.fileIdsStr.value = fileIdsStr;
			form.file__article__0__common__attachment__1.value = '';
			form.file__article__0__common__attachment__2.value = '';
			

			
			form.submit();
			
		});
	}
	
</script>
<%@ include file="../part/foot.jspf"%>