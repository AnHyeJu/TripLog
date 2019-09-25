<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%request.setCharacterEncoding("utf-8");%>
<!DOCTYPE html>
<html>

<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">

<title>안녕하세요?</title>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!-- Bootstrap core CSS -->
<link href="${contextPath}/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<!-- Custom styles for this & nav template -->
<link href="${contextPath}/css/business-frontpage.css" rel="stylesheet">

</head>

<body>
	<!-- NAV -->
	<jsp:include page="nav.jsp" />

	<!-- Header -->
	<header class="bg-primary py-5 mb-5">
		<div class="container h-100">
			<div class="row h-100 align-items-center">
				<div class="col-lg-12">
					<h1 class="display-4 text-white mt-5 mb-2">WELCOME</h1>
					<p class="lead mb-5 text-white-50">Lorem ipsum dolor sit amet,
						consectetur adipisicing elit. Non possimus ab labore provident
						mollitia. Id assumenda voluptate earum corporis facere quibusdam
						quisquam iste ipsa cumque unde nisi, totam quas ipsam.</p>
						<a href="${contextPath}/member/register.jsp">
						<button id="about" class="btn btn-primary btn-lg">JOIN US!</button>
						</a>
				</div>
			</div>
		</div>
	</header>


	<!-- Page Content -->
	<div class="container">

		<div class="row">
			<div class="col-md-8 mb-5">
				<h2>What We Do</h2>
				<hr>
				<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. A
					deserunt neque tempore recusandae animi soluta quasi? Asperiores
					rem dolore eaque vel, porro, soluta unde debitis aliquam
					laboriosam. Repellat explicabo, maiores!</p>
				<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit.
					Omnis optio neque consectetur consequatur magni in nisi, natus
					beatae quidem quam odit commodi ducimus totam eum, alias, adipisci
					nesciunt voluptate. Voluptatum.</p>
				<a class="btn btn-primary btn-lg" href="#">Call to Action &raquo;</a>
			</div>
			<div class="col-md-4 mb-5">
				<h2>Contact ME</h2>
				<hr>
				<address>
					<strong>AN HYEJU</strong> <br>3481 Melrose Place <br>Beverly Hills, CA 90210 <br>
				</address>
				<address>
					<abbr title="Phone">P:</abbr> (123) 456-7890 <br> 
					<abbr title="Email">E:</abbr> <a href="mailto:iwillgo555@naver.com">iwillgo555@naver.com</a>
				</address>
			</div>
		</div>
		<!-- /.row -->

		<div class="row">
			<div class="col-md-4 mb-5">
				<div class="card h-100">
					<img class="card-img-top inp" src="img/indxpic1.jpg" alt="">
					<div class="card-body">
						<h4 class="card-title">몇년만에 다시 온 여행!</h4>
						<p class="card-text">Lorem ipsum dolor sit amet, consectetur
							adipisicing elit
							. Sapiente esse necessitatibus neque sequi
							doloribus.</p>
					</div>
					<div class="card-footer">
						<a href="#" class="btn btn-primary">Find Out More!</a>
					</div>
				</div>
			</div>
			<div class="col-md-4 mb-5">
				<div class="card h-100">
					<img class="card-img-top inp" src="img/indxpic2.jpg" alt="">
					<div class="card-body">
						<h4 class="card-title">여름엔 바다가 최고</h4>
						<p class="card-text">Lorem ipsum dolor sit amet, consectetur
							adipisicing elit. Sapiente esse necessitatibus neque sequi
							doloribus totam ut praesentium aut.</p>
					</div>
					<div class="card-footer">
						<a href="#" class="btn btn-primary">Find Out More!</a>
					</div>
				</div>
			</div>
			<div class="col-md-4 mb-5">
				<div class="card h-100">
					<img class="card-img-top inp" src="img/indxpic3.jpg" alt="">
					<div class="card-body">
						<h4 class="card-title">트래킹 하기 좋은 날씨네요.</h4>
						<p class="card-text">Lorem ipsum dolor sit amet, consectetur
							adipisicing elit. Sapiente esse necessitatibus neque.</p>
					</div>
					<div class="card-footer">
						<a href="#" class="btn btn-primary">Find Out More!</a>
					</div>
				</div>
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
	<script src="${contextPath}/vendor/jquery/jquery.min.js"></script>
	<script src="${contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

</body>

</html>
