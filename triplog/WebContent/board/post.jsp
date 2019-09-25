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

<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">

<title>Blog Post - Start Bootstrap Template</title>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!-- Bootstrap core CSS -->
<link href="${contextPath}/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<!-- Custom styles for this template -->
<link href="${contextPath}/css/blog-post.css" rel="stylesheet">
<!-- Custom styles for nav template -->
<link href="${contextPath}/css/business-frontpage.css" rel="stylesheet">

</head>

<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript">
	$(function() {
		
		$('#cmtSubmit').click(function() {
			var cmt = $('#comment').val();
			var lg = '${login}';
			if(lg =='' || lg == null){
				alert("로그인 하셔야 댓글 쓰기가 가능합니다.");
				$("#login").trigger('click');
				return false;
			}else if(cmt ==null || cmt ==""){
				alert("내용을 입력해 주세요!");
			}else{
			var cmmt = cmt.replace(/(?:\r\n|\r|\n)/g, '<br />');
			
			$.ajax({
				type : 'POST',
				url : "${contextPath}/doComment/comment.do",
				data : {username : '${mdto.username}', comment:cmmt, photo:'${mdto.photo}', postNum:'${dto.num}'},
				dataType: 'text',
				success : function(md) {
					var c = JSON.parse(md);
					
					$('#cmtempty').remove();
					
					$('#cmtdiv').after('<div class="media mb-4">'
							+'<img class="d-flex mr-3 rounded-circle cmtphoto" src="${contextPath}/'+c.photo+'" alt="profile_photo">'
							+'<div class="media-body">'
							+'<h5 class="mt-0">'+c.username+'</h5>'
							+c.comment 
							+'<br><br><b>on '+c.reg_time+'</b>'
							+'</div></div>');
					$('#comment').val("");
				}
			});//end of ajax
			}
		});
		
	});
</script>
<body>

	<!-- NAV -->
	<jsp:include page="../nav.jsp" />
	
	<!-- Page Content -->
	<div class="container">

		<div class="row">
			<!-- Post Content Column -->
			<div class="col-lg-8">
	<c:choose>
		<c:when test="${empty dto}">
			<h1 class="display-4 mt-4">게시글이 삭제되었거나<br> 존재하지 않습니다.</h1>
		</c:when>

		<c:otherwise>

				<!-- Title -->
				<h1 class="mt-4">${dto.title}</h1>

				<!-- Author -->
				<p class="lead row justify-content-between mr-3">
					<span class="ml-3">by <a href="#">${dto.username}</a></span>
					<span>
					<c:url var="delurl" value="/allonboard/postDelete">
						<c:param name="num" value="${dto.num}"/>
						<c:param name="page" value="${param.page}"/>
						<c:param name="category" value="${param.category}"/>
						<c:param name="filePaths" value="${dto.filePaths}"/>
						<c:param name="imgPaths" value="${dto.imgPaths}"/>
					</c:url>
					<c:choose>
					<c:when test="${not empty mdto && requestScope.dto.email == sessionScope.login_e}">
						<a href="${contextPath}/allonboard/postEdit?num=${dto.num}&page=${param.page}&category=${param.category}" class="btn btn-primary mr-2">수정</a>
						<a href="${delurl}" class="btn btn-primary">삭제</a>
					</c:when>
					<c:when test="${mdto.step ==1}">
						<a href="${delurl}" class="btn btn-primary">삭제</a>
					</c:when>
					</c:choose>
						<a href="${contextPath}/board/write.jsp?page=${page}&category=${category}&pnum=${dto.num}&title=${dto.title}&cate=${dto.cate}" class="btn btn-primary ml-2">답글</a>
					</span>
				</p>

				<hr>

				<!-- Date/Time -->
				<div class="row justify-content-between">
				<span class="ml-3">Posted on <fmt:formatDate value="${dto.reg_date}" pattern="MMM d, YYYY a hh:mm"/></span>
				<c:if test="${not empty dto.change_date}">
					Edited on <fmt:formatDate value="${dto.change_date}" pattern="MMM d, YYYY a hh:mm"/>
				</c:if>
				<span class="mr-3">조회수: ${dto.count}</span>
				</div>

<!-- 				<hr> -->

<!-- 				Preview Image -->
<!-- 				<img class="img-fluid rounded" src="http://placehold.it/900x300" alt=""> -->

				<hr>
				<c:if test="${not empty dto.filePaths}">
				<div id='fddiv' class="row justify-content-between d-flex align-items-end flex-column">
				<c:forTokens items="${dto.filePaths}" delims="," var="filePath">
				<c:url value="/allonboard/download" var="url"><c:param name="fileName" value="${filePath}"/> </c:url>
				<div class="list-group-item list-group-item-action w-75 mr-3"><a href="${url}">${filePath} 파일 내려받기</a></div>
				</c:forTokens>
				</div>
				<hr>
				</c:if>
				

				<!-- Post Content -->
				<p>${dto.content}</p>

				<hr>
				
				<!-- Comments Form -->
				<div class="card my-4" id="cmtdiv">
					<h5 class="card-header">Leave a Comment:</h5>
					<div class="card-body">
						<form id="cmform">
							<div class="form-group">
								<textarea class="form-control" rows="3" id="comment" placeholder="내용을 입력하세요."></textarea>
							</div>
							<button type="button" id="cmtSubmit" class="btn btn-primary">Submit</button>
						</form>
					</div>
				</div>

				<!-- Single Comment -->
				<c:choose>
					<c:when test="${empty clist}"><div id="cmtempty" class="media mb-4"><h5>아직 댓글이 없습니다 직접 달아보세요!</h5></div></c:when>
					<c:otherwise>
					<c:forEach var="cdto" items="${clist}">
				<div class="media mb-4">
					<img class="d-flex mr-3 rounded-circle cmtphoto" src="${contextPath}/${cdto.photo}" alt="profile_photo">
					<div class="media-body">
						<h5 class="mt-0">${cdto.username}</h5>
						${cdto.comment}
						<br><br><b>on <fmt:formatDate value="${cdto.reg_time}" pattern="MMM d, a h:mm"/></b>
					</div>
				</div>
					</c:forEach>
					</c:otherwise>
				</c:choose>

				<!-- Comment with nested comments -->
				<div class="media mb-4">
					<!-- <img class="d-flex mr-3 rounded-circle"
						src="http://placehold.it/50x50" alt="">
					<div class="media-body">
						<h5 class="mt-0">Commenter Name</h5>
						Cras sit amet nibh libero, in gravida nulla. Nulla vel metus
						scelerisque ante sollicitudin. Cras purus odio, vestibulum in
						vulputate at, tempus viverra turpis. Fusce condimentum nunc ac
						nisi vulputate fringilla. Donec lacinia congue felis in faucibus.

						<div class="media mt-4">
							<img class="d-flex mr-3 rounded-circle"
								src="http://placehold.it/50x50" alt="">
							<div class="media-body">
								<h5 class="mt-0">Commenter Name</h5>
								Cras sit amet nibh libero, in gravida nulla. Nulla vel metus
								scelerisque ante sollicitudin. Cras purus odio, vestibulum in
								vulputate at, tempus viverra turpis. Fusce condimentum nunc ac
								nisi vulputate fringilla. Donec lacinia congue felis in
								faucibus.
							</div>
						</div>

						<div class="media mt-4">
							<img class="d-flex mr-3 rounded-circle"
								src="http://placehold.it/50x50" alt="">
							<div class="media-body">
								<h5 class="mt-0">Commenter Name</h5>
								Cras sit amet nibh libero, in gravida nulla. Nulla vel metus
								scelerisque ante sollicitudin. Cras purus odio, vestibulum in
								vulputate at, tempus viverra turpis. Fusce condimentum nunc ac
								nisi vulputate fringilla. Donec lacinia congue felis in
								faucibus.
							</div>
						</div>

					</div> -->
				</div>
			</c:otherwise>
		</c:choose>
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
			<p class="m-0 text-center text-white">Copyright &copy; Your
				Website 2019</p>
		</div>
		<!-- /.container -->
	</footer>

	<!-- Bootstrap core JavaScript -->
	<script src="../vendor/jquery/jquery.min.js"></script>
	<script src="../vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

</body>

</html>
