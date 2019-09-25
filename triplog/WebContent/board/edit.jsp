<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
	request.setCharacterEncoding("utf-8");
	request.setAttribute("newLine", System.getProperty("line.separator"));
	request.setAttribute("br", "<br>");
	request.setAttribute("ll", "\"");
	request.setAttribute("l", "\'");
%>
<!DOCTYPE html>
<html>

<head>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">

<title>Blog Post - Start Bootstrap Template</title>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<c:set var="html" value=" ${dto.content}"/>
<c:set var="html" value="${fn:replace(html,newLine,br) }"/>
<c:set var="html" value="${fn:replace(html,l,ll) }"/>

<c:choose>
	<c:when test="${dto.cate == 'tai'}"><c:set var="catego" value="태국"/></c:when>
	<c:when test="${dto.cate == 'eu'}"><c:set var="catego" value="유럽"/></c:when>
	<c:when test="${dto.cate == 'au'}"><c:set var="catego" value="호주"/></c:when>
	<c:when test="${dto.cate == 'free'}"><c:set var="catego" value="자유게시판"/></c:when>
</c:choose>
<!-- Bootstrap core CSS -->
<link href="${contextPath}/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<!-- Custom styles for this template -->
<link href="${contextPath}/css/blog-post.css" rel="stylesheet">
<!-- Custom styles for nav template -->
<link href="${contextPath}/css/business-frontpage.css" rel="stylesheet">

<script src="https://cdn.tiny.cloud/1/no-api-key/tinymce/5/tinymce.min.js" referrerpolicy="origin"></script>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript">
function cntimg(){
	var sample = tinyMCE.activeEditor.getContent({ format: 'html' });
	$('#go').html($.parseHTML(sample));
	$("#imgPaths").val("");
	for(i=0; i<$('#go img').length;i++){
		var imgPath = $('#go img').eq(i).attr('src').split("/");
		var imgPS = imgPath.slice(imgPath.length-3).join("/");

		$("#imgPaths").val( $("#imgPaths").val()+imgPS+",");
	}
	return $('#go img').length;
}

function uploadimg() {
	var i =cntimg();
// 	alert(i);
	if(i==4){
		alert("이미지는 최대 4장까지 첨부 할 수 있습니다.");
		return false;
	}else{
	$("#go").html("<input type='file' name='dodo' id='"+i+"go' accept='image/*'>");
	$("#"+i+"go").trigger('click');
	$("#"+i+"go").on("change",function(){
		var formData = new FormData();
		formData.set("uploadfile", $("#"+i+"go")[0].files[0]);
	
		$.ajax({
            url: "${contextPath}/allonboard/imgUpload",
            enctype: 'multipart/form-data',
            processData: false,
            contentType: false,
            data: formData,
            type: 'POST',
            dataType: 'text',
            success: function(result){
            	var c = JSON.parse(result);
            	$('#alImgPaths').val($('#alImgPaths').val()+c.url+',');
            	
				var imgtag = '<img src="${contextPath}/'+c.url+'">';
				tinymce.activeEditor.execCommand("mceInsertContent",'false',imgtag);
            	}
		});//end of ajax
	});//end of change
	}
}

	$(function() {
		$("option[value='${dto.cate}']").attr('selected','selected');
		
		$('#content').val('${html}');

		if(${ (empty sessionScope.login) || requestScope.dto.email != sessionScope.login_e}){
			alert("잘못된 접근입니다! 왜그러세요");
			location.href="../index.jpg";
		}
		
		$('#edform').on('submit',function(){
			if($("#title").val()=="" || $("#username").val()==""){
				alert('제목, 내용이 없는 글은 작성 하실 수 없습니다. 다시 확인해주세요');
				return false;
			}else{
				cntimg();
// 				alert($("#imgPaths").val());
			}

		});
	});//end of onload
</script>

</head>

<body>
	<!-- NAV -->
	<jsp:include page="../nav.jsp" />
	
	<!-- Page Content -->
	<div class="container">
		<div class="row">
			<!-- Post Content Column -->
			<div class="col-lg-8">
<!-- 				<h2 class="mt-4">Post it!</h2> -->
				<form id="edform"class="mt-4" action="${contextPath}/allonboard/postUpdate?page=${param.page}&category=${param.category}" method="post">
					<table class="col-lg-12">
						<tr>
							<th><label for="cate">카테고리 :</label></th>
							<c:choose>
							<c:when test="${empty dto.cate}">
							<td><select class="custom-select" id="cate" name="cate">
								<option value="tai">태국
								<option value="au">호주
								<option value="eu">유럽
								<option value="free" selected>자유게시판
							</select></td></c:when>
							<c:otherwise><td><input type="hidden" value="${dto.cate}" name="cate"></td></c:otherwise>
							</c:choose>
						</tr>
						<tr>
							<th><label for="title">제목 :</label></th>
							<td><input type="text" class="form-control" name="title" id="title" value="${dto.title}"></td>
						</tr>
						<tr>
							<th><label for="usernane">작성자 :</label></th>
							<td class="input-group-sm">
								<input type="text" class="form-control-plaintext" name="username" id="username" readonly value="${sessionScope.login}">
							</td>
						</tr>
						<c:if test="${not empty dto.filePaths}">
						<tr id="fspace">
						<td colspan="2"><div class="form-control list-group-item-info">답글 수정시 첨부파일은 수정하실 수 없습니다.</div></td>
						</tr>
						</c:if>
						<tr>
							<td colspan="2" class="pt-2">
							<textarea name="content" id="content" class="form-control" rows="15"></textarea>
								<script>
							 // Prevent jQuery UI dialog from blocking focusin
							    $(document).on('focusin', function(e) {
							        if ($(e.target).closest(".tox-tinymce-aux, .moxman-window, .tam-assetmanager-root").length) {
							    		e.stopImmediatePropagation();
							    	}
							    });

							    tinymce.init({
							    	selector: '#content',
							    	min_height: 500,
// 							    	language: 'ko_KR',
							   		plugins: [
							   			'advlist autolink lists link image charmap print preview hr anchor pagebreak',
							   			'searchreplace wordcount visualblocks visualchars code fullscreen',
							   			'insertdatetime media nonbreaking save table directionality',
							   			'emoticons template paste textpattern imagetools'
							   			],
							    	toolbar: "undo redo | styleselect | forecolor bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | table link media custom_image code | myCustomToolbarButton",
							    	  
							    	setup: (editor) => {
							    	   editor.ui.registry.addButton('myCustomToolbarButton', {
							    	   text: 'image',
							    	   onAction: () => uploadimg()
							    	   });
							    	  }
							    	});
 								</script>
							</td>
						</tr>
						<tr>
							<td colspan="2"><input class="btn btn-primary btn-lg btn-block my-3" type="submit" value="수정하기"></td>
						</tr>
					</table>
					<input type="hidden" value="${dto.num}" name="num">
					<input id="imgPaths" name="imgPaths" type="hidden" value="">
					<input id="alImgPaths" name="alImgPaths" type="hidden" value="">
				</form>
				<div id="go"></div>
			</div>
			
			<!-- Sidebar Widgets Column -->
			<div class="col-md-4">
				<jsp:include page="widget.jsp"/>
			</div>

		</div>
		<!-- /.row -->

	</div>
	<!-- /.container -->

	<!-- Footer -->
	<footer class="py-5 bg-dark">
		<div class="container">
			<p class="m-0 text-center text-white">Copyright &copy; Your Website 2019</p>
		</div>
		<!-- /.container -->
	</footer>

	<!-- Bootstrap core JavaScript -->
	<script src="../vendor/jquery/jquery.min.js"></script>
	<script src="../vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>

</html>
