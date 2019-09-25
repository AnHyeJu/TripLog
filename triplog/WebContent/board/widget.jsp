<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<div class="card my-4">
	<h5 class="card-header">Search</h5>
	<div class="card-body">
		<div class="input-group">
			<input type="text" class="form-control" placeholder="Search for...">
			<span class="input-group-btn">
				<button class="btn btn-secondary" type="button">Go!</button>
			</span>
		</div>
	</div>
</div>

<!-- Categories Widget -->
<div class="card my-4">
	<h5 class="card-header">Categories</h5>
	<div class="card-body">
		<div class="row">
			<div class="col-lg-6">
				<ul class="list-unstyled mb-0">
					<li><a href="${contextPath}/allonboard/boardList?page=0&category=tai">태국</a></li>
					<li><a href="${contextPath}/allonboard/boardList?page=0&category=au">호주</a></li>
					<li><a href="${contextPath}/allonboard/boardList?page=0&category=eu">유럽</a></li>
				</ul>
			</div>
			<div class="col-lg-6">
				<ul class="list-unstyled mb-0">
					<li><a href="${contextPath}/allonboard/boardList?page=0&category=free">자유게시판</a></li>
					<li><a href="${contextPath}/allonboard/boardList?page=0&category=all">전체글 보기</a></li>
					
				</ul>
			</div>
		</div>
	</div>
</div>

<!-- Side Widget -->
<div class="card my-4">
	<h5 class="card-header">Side Widget</h5>
	<div class="card-body">You can put anything you want inside
		of these side widgets. They are easy to use, and feature the new
		Bootstrap 4 card containers!</div>
</div>