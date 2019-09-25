<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	request.setCharacterEncoding("utf-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">

<title>Login</title>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!-- Bootstrap core CSS -->
<link href="${contextPath}/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<!-- Custom fonts for this template-->
<link href="${contextPath}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
<link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i" rel="stylesheet">
<!-- Custom styles for this template-->
<link href="${contextPath}/css/sb-admin-2.css" rel="stylesheet">
<!-- Custom styles for nav template -->
<link href="${contextPath}/css/business-frontpage.css" rel="stylesheet">

<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<c:choose>
	<c:when test="${requestScope.login=='no'}">
		<script type="text/javascript">
			$(function() {
				$("#email").addClass("is-invalid");
				$("#pwd").addClass("is-invalid");
				$("#pwd + div").html(
				"아이디 또는 비밀번호를 다시 확인하세요. 등록되지 않은 아이디이거나, 아이디 또는 비밀번호를 잘못 입력하셨습니다."
				);
				
				$('#referer').val('${re}');
				alert('${re}');
			});
		</script>
	</c:when>
</c:choose>
<script type="text/javascript">
	$(function() {
		$("#login").click(function() {
			var email = $("#email").val();
			var pwd = $("#pwd").val();

			if (email == "" || pwd == "") {
				$("#email").addClass("is-invalid");
				$("#pwd").addClass("is-invalid");

				return false;
			} else {
				$("#email").removeClass("is-invalid");
				$("#pwd").removeClass("is-invalid");

				return true;
			}
		});//end of login
	});
</script>

</head>
<body class="bg-gradient-primary">
	<div class="container">
		<!-- Outer Row -->
		<div class="row justify-content-center">
			<div class="col-xl-10 col-lg-12 col-md-9">
				<div class="card o-hidden border-0 shadow-lg my-5">
					<div class="card-body p-0">
						<!-- Nested Row within Card Body -->
						<div class="row">
							<div class="col-lg-6 d-none d-lg-block bg-login-image"></div>
							<div class="col-lg-6">
								<div class="p-5">
									<div class="text-center">
										<h1 class="h4 text-gray-900 mb-4">Welcome Back!</h1>
									</div>
									<form class="user" id="loginForm" action="${contextPath}/checkall/login" method="post">
										<div class="form-group">
											<input type="email" class="form-control form-control-user"
												name="email" id="email" aria-describedby="emailHelp"
												placeholder="Enter Email Address...">
										</div>
										<div class="form-group">
											<input type="password" class="form-control form-control-user"
												name="pwd" id="pwd" placeholder="Password">
											<div class="invalid-feedback">입력해주세요..</div>
										</div>
										<div class="form-group">
											<div class="custom-control custom-checkbox small">
												<input type="checkbox" class="custom-control-input" id="customCheck">
												<label class="custom-control-label" for="customCheck">Remember Me</label>
											</div>
										</div>
										<input type="submit" class="btn btn-primary btn-user btn-block" id="login" value="login">
										<hr>
										<a href="#" class="btn btn-google btn-user btn-block">
											<i class="fab fa-google fa-fw"></i> Login with Google</a>
										<a href="#" class="btn btn-facebook btn-user btn-block">
											<i class="fab fa-facebook-f fa-fw"></i> Login with Facebook</a>
									<input type="hidden" value="${header.referer}" name="referer" id="referer">
									</form>
									<hr>
									<div class="text-center">
										<a class="small" href="forgot-password.html">Forgot Password?</a>
									</div>
									<div class="text-center">
										<a class="small" href="${contextPath}/member/register.jsp">Create an Account!</a>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Bootstrap core JavaScript-->
	<script src="${contextPath}/vendor/jquery/jquery.min.js"></script>
	<script src="${contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

	<!-- Core plugin JavaScript-->
	<script src="${contextPath}/vendor/jquery-easing/jquery.easing.min.js"></script>

	<!-- Custom scripts for all pages-->
	<script src="${contextPath}/js/sb-admin-2.min.js"></script>
</body>
</html>
