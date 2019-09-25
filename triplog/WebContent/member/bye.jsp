<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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

<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!-- Bootstrap core CSS -->
<link href="${contextPath}/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<!-- Custom styles for this template -->
<link href="${contextPath}/css/blog-home.css" rel="stylesheet">
<!-- Custom styles for nav template -->
<link href="${contextPath}/css/business-frontpage.css" rel="stylesheet">

<title>회원 탈퇴 페이지</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript">
	$(function() {
		$("#recheck").click(function() {
			if(confirm("정말 탈퇴하시겠습니까?")==false){
				location.href="${contextPath}/checkall/mypage/profile";
				return false;
			}	
		});
	});
</script>
<c:if test="${param.recheck == 0}">
<script type="text/javascript">
	$(function() {
		$("#pwd1").addClass("is-invalid");
		$("#pwd1 + div").html(
		"비밀번호를 다시 확인하세요."
		);
	});
</script>
</c:if>
</head>
<body>
<jsp:include page="../nav.jsp" />
<div class="container">
		<div class="row">
		<div class="col-md-8">
	<h2 class="my-4">비밀번호 재인증</h2>
	<p>회원 탈퇴시 비밀번호 확인이 필요합니다.</p>
	<form class="form-inline"
		action="${contextPath}/checkall/mypage/recheck?f=bye" method="post">
		<div class="form-group mb-2">
			<label for="username" class="sr-only">Username</label>
			<input type="text" readonly class="form-control-plaintext" id="username" value="${sessionScope.login}님">
		</div>
		<div class="form-group mx-sm-3 mb-2">
			<label for="pwd1" class="sr-only">Password</label>
			<div>
				<input type="password" class="form-control" id="pwd1" name='pwd' placeholder="Password">
				<div class="invalid-feedback"></div>
			</div>
		</div>
		<button type="submit" id="recheck" class="btn btn-primary mb-2">확인</button>
	</form>
	</div>
	<div class="col-md-4">
			<div class="card my-4">
				<h5 class="card-header">My page</h5>
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
		</div></div></div>
	<!-- Bootstrap core JavaScript -->
	<script src="${contextPath}/vendor/jquery/jquery.min.js"></script>
	<script src="${contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>