<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
		<div class="container">
			<a class="navbar-brand" href="${contextPath}/index.jsp">Let's get Started!</a>
			<button class="navbar-toggler" type="button" data-toggle="collapse"
				data-target="#navbarResponsive" aria-controls="navbarToggleExternalContent"
				aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarResponsive">
				<ul class="navbar-nav ml-auto">
					<li class="nav-item active">
						<a class="nav-link" id="home" href="${contextPath}/index.jsp">Home <span class="sr-only">(current)</span></a>
					</li>
					<li class="nav-item"><a class="nav-link" href="${contextPath}/index.jsp#about">About</a></li>
					<li class="nav-item"><a class="nav-link" href="${contextPath}/index.jsp#about">Contact</a></li>
					<li class="nav-item"><a class="nav-link" href="${contextPath}/allonboard/boardList?page=0&category=all">Board</a></li>
					<c:choose>
						<c:when test="${empty sessionScope.login}">
							<li class="nav-item">
								<a class="nav-link" href="${contextPath}/member/login.jsp">
									<button type="button" class="btn btn-light" id="login">Login</button>
								</a>
							</li>
						</c:when>
						<c:otherwise>
							<li class="nav-item"><a class="nav-link" href="${contextPath}/checkall/mypage/profile"><c:out value="${sessionScope.login}" />'s page</a></li>
							<li class="nav-item">
								<a class="nav-link" href="${contextPath}/checkall/logout">
									<button type="button" class="btn btn-light">Logout</button>
								</a>
							</li>
						</c:otherwise>
					</c:choose>
				</ul>
			</div>
		</div>
	</nav>