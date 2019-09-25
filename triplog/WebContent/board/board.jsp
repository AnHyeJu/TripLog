<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	request.setCharacterEncoding("utf-8");
%>
<!DOCTYPE html>
<html>

<head>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">

<title>Blog Home - Start Bootstrap Template</title>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!-- Bootstrap core CSS -->
<link href="${contextPath}/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<!-- Custom styles for this template -->
<link href="${contextPath}/css/blog-home.css" rel="stylesheet">
<!-- Custom styles for nav template -->
<link href="${contextPath}/css/business-frontpage.css" rel="stylesheet">

<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript">
	
	$(function() {
	
	if(${requestScope.page<2}) $(".plusone").addClass("disabled");
	
	if(${page>(totalPage-2)}) $(".subone").addClass("disabled");
	
	
	var ps = $(".pagination>li>a").get();
	for(var i=0; i<ps.length; i++){	
		if(ps[i].innerHTML==${page+1})
			$(".pagination>li:nth-child("+(i+1)+")").addClass("active");
	}
	});
</script>
<c:choose>
	<c:when test="${category eq 'eu'}"><c:set var="tt" value="유럽"/></c:when>
	<c:when test="${category eq 'tai'}"><c:set var="tt" value="태국"/></c:when>
	<c:when test="${category eq 'au'}"><c:set var="tt" value="호주"/></c:when>
	<c:when test="${category eq 'free'}"><c:set var="tt" value="자유게시판"/></c:when>
	<c:otherwise><c:set var="tt" value="전체글 보기"/> </c:otherwise>
</c:choose>
</head>

<body>
	<!-- NAV -->
	<jsp:include page="../nav.jsp" />

	<!-- Page Content -->
	<div class="container">

		<div class="row">

			<!-- Blog Entries Column -->
			<div class="col-md-8" id="bec">
				<h1 class="my-4">
					${tt} <small>| ${totalPage}페이지 중  ${page+1}번째 페이지</small>
				</h1>
				<c:if test="${empty list}"><h1>조건에 맞는 게시글이 없습니다.</h1></c:if>
				<c:forEach var="dto" items="${requestScope.list}" varStatus="caro">
				<!-- Blog Post -->
				<div class="card mb-4">
				<c:choose>
					<c:when test="${dto.depth != 0}">
					<img alt="" src="" class="dep">
					</c:when>
					<c:when test="${empty dto.imgPaths or dto.imgPaths == null}">
					<img class="card-img-top" src="../img/basic.png" alt="Card image cap">
					</c:when>
					<c:otherwise>
			<div id="carouselExampleIndicators${caro.index}" class="carousel slide" data-ride="carousel">
			  <ol class="carousel-indicators">
			  <c:forTokens items="${dto.imgPaths}" delims="," var="imgPath" varStatus="status">
			 	<c:if test="${status.first}"><li data-target="#carouselExampleIndicators${caro.index}" data-slide-to="${status.index}" class="active"></li></c:if>
			  	<c:if test="${not status.first}"><li data-target="#carouselExampleIndicators${caro.index}" data-slide-to="${status.index}"></li></c:if>
			  </c:forTokens>
			  </ol>
			  <div class="carousel-inner">
					<c:forTokens items="${dto.imgPaths}" delims="," var="imgPath" varStatus="status">
			    <c:if test="${status.first}">
			    	<div class="carousel-item active"><img src="../${imgPath}" class="d-block w-100" alt="../${imgPath}"></div>
			    </c:if>
			    <c:if test="${not status.first}">
			    	<div class="carousel-item"><img src="../${imgPath}" class="d-block w-100" alt="../${imgPath}"></div>
			    </c:if>
					</c:forTokens>
			  </div>
			  <a class="carousel-control-prev" href="#carouselExampleIndicators${caro.index}" role="button" data-slide="prev">
			    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
			    <span class="sr-only">Previous</span>
			  </a>
			  <a class="carousel-control-next" href="#carouselExampleIndicators${caro.index}" role="button" data-slide="next">
			    <span class="carousel-control-next-icon" aria-hidden="true"></span>
			    <span class="sr-only">Next</span>
			  </a>
			</div>
					</c:otherwise>
				</c:choose>
					<div class="card-body">
						<h2 class="card-title">${dto.title}</h2>
<%-- 						<p class="card-text">${dto.sample}...</p> --%>
						<a href="${contextPath}/allonboard/showPost?num=${dto.num}&page=${page}&category=${category}" class="btn btn-primary">Read More &rarr;</a>
					</div>
					<div class="card-footer text-muted">
						<div class="row justify-content-around">
						<span>Posted on <fmt:formatDate value="${dto.reg_date}" pattern="MMM d, YYYY a hh:mm"/>
						 by <a href="#">${dto.username}</a></span>
						<span>조회수: ${dto.count}</span>
						</div>
					</div>
				</div>
				</c:forEach>

				<!-- Pagination -->
				<ul class="pagination justify-content-center mb-4">
				
					<li class="page-item"><a class="page-link" href="${contextPath}/allonboard/boardList?page=0&category=${category}">1페이지</a></li>
					<li class="page-item plusone"><a class="page-link" href="${contextPath}/allonboard/boardList?page=${page-1}&category=${category}">&larr; Older</a></li>
					<c:choose>
						<c:when test="${totalPage<3}">
							<c:forEach var="i" begin="1" end="${totalPage}" step="1">
							<li class="page-item"><a class="page-link" href="${contextPath}/allonboard/boardList?page=${i-1}&category=${category}">${i}</a></li>
							</c:forEach>
						</c:when>
						<c:when test="${page==0}">
							<c:forEach var="i" begin="0" end="2" step="1">
							<li class="page-item"><a class="page-link" href="${contextPath}/allonboard/boardList?page=${page+i}&category=${category}">${i+1}</a></li>
							</c:forEach>
						</c:when>
						<c:when test="${page>=totalPage-1}">
							<c:forEach var="i" begin="0" end="2" step="1">
							<li class="page-item"><a class="page-link" href="${contextPath}/allonboard/boardList?page=${page-2+i}&category=${category}">${page+i-1}</a></li>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<c:forEach var="i" begin="0" end="2" step="1">
							<li class="page-item"><a class="page-link" href="${contextPath}/allonboard/boardList?page=${page+i-1}&category=${category}">${page+i}</a></li>
							</c:forEach>
						</c:otherwise>
					</c:choose>
					<li class="page-item subone"><a class="page-link" href="${contextPath}/allonboard/boardList?page=${page+1}&category=${category}">Newer &rarr;</a></li>
					<li class="page-item"><a class="page-link" href="${contextPath}/allonboard/boardList?page=${totalPage-1}&category=${category}">마지막 페이지</a></li>
				</ul>

			</div>

			<!-- Sidebar Widgets Column -->
			<div class="col-md-4">

				<!-- Search Widget -->
				<div class="my-4">
					<A href="${contextPath}/board/write.jsp?page=${page}&category=${category}">
						<input type="button" class="btn btn-primary btn-lg btn-block" value="글쓰기" id="write">
					</A>
				</div>
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
