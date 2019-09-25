<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	request.setCharacterEncoding("utf-8");
%>

<!DOCTYPE html>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">

<title>Business Frontpage - Start Bootstrap Template</title>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!-- Bootstrap core CSS -->
<link href="${contextPath}/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<!-- Custom styles for this template -->
<link href="${contextPath}/css/blog-home.css" rel="stylesheet">
<!-- Custom styles for nav template -->
<link href="${contextPath}/css/business-frontpage.css" rel="stylesheet">

<title>Insert title here</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript">
function uploadimg() {
	var i=1;
	$("#go").html("<input type='file' name='dodo' id='"+i+"go' accept='image/*'>");
	$("#"+i+"go").trigger('click');
	$("#"+i+"go").on("change",function(){
		var formData = new FormData();
		formData.set("uploadfile", $("#"+i+"go")[0].files[0]);
	
		$.ajax({
            url: "${contextPath}/allonboard/imgUpload?profile=photo",
            enctype: 'multipart/form-data',
            processData: false,
            contentType: false,
            data: formData,
            type: 'POST',
            dataType: 'text',
            success: function(result){
            	var c = JSON.parse(result);
            	
				$('#photo').attr('src','${contextPath}/'+c.url);
            	}
		});//end of ajax
	});//end of change
}
</script>

</head>
<body>
	<jsp:include page="../nav.jsp" />
	<div class="container">
		<div class="row">
		<div class="col-md-8">
			<h2 class="my-4">MY PAGE</h2>
			
			<dl class="row">
				<dt class="col-sm-4">Profile Photo <button class="btn btn-primary" onclick="uploadimg();" >프로필 사진 바꾸기</button> </dt>
				<dd class="col-sm-8"><img alt="profile_photo" src="${contextPath}/${dto.photo}" id="photo"></dd>
				
				<dt class="col-sm-4">Email</dt>
				<dd class="col-sm-8">${dto.email }</dd>
				
				<dt class="col-sm-4">Username</dt>
				<dd class="col-sm-8">${dto.username }</dd>
				
				<dt class="col-sm-4">Join Date</dt>
				<dd class="col-sm-8"><fmt:formatDate value="${dto.reg_date}" pattern="MMM d, YYYY a hh:mm"/></dd>
				
				<dt class="col-sm-4">Address</dt>
				<dd class="col-sm-8">(${dto.postcode}) <br>${dto.address }<br>${dto.detailAddress }</dd>
				
				<dt class="col-sm-4">Phone Number</dt>
				<dd class="col-sm-8">${dto.phone}</dd>
				
				<c:if test="${dto.step==1}">
				<dt class="col-sm-12 text-muted">관리자 계정입니다.</dt>
				</c:if>
				<div id="go"></div>
			</dl>
		</div>
		<div class="col-md-4">
			<div class="card my-4">
				<h5 class="card-header">MY PAGE</h5>
				<div class="card-body">
					<div class="row">
						<div class="col-lg-6">
							<ul class="list-unstyled mb-0">
								<li><a href="${contextPath}/checkall/mypage/profile">내 프로필 보기</a></li>
								<li id="modify"><a href="${contextPath}/member/modify.jsp">정보 수정하기</a></li>
								<li><a href="${contextPath}/member/bye.jsp">회원 탈퇴....</a></li>
							</ul>
						</div>
						<div class="col-lg-6">
							<ul class="list-unstyled mb-0">
								<li><a href="#"></a></li>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div></div>
	
	<!-- Bootstrap core JavaScript -->
	<script src="${contextPath}/vendor/jquery/jquery.min.js"></script>
	<script src="${contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
	
</body>
</html>