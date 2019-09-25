<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
	request.setCharacterEncoding("utf-8");
%>

<!DOCTYPE html>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">

<title>Business Frontpage - Start Bootstrap Template</title>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<fmt:formatDate value="${dto.reg_date}" pattern="MMM d, YYYY a hh:mm" var="fmtreg_date"/>
<c:set var = "splphone" value = "${fn:split(dto.phone, '-')}" />
<!-- Bootstrap core CSS -->
<link href="${contextPath}/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<!-- Custom styles for this template -->
<link href="${contextPath}/css/blog-home.css" rel="stylesheet">
<!-- Custom styles for nav template -->
<link href="${contextPath}/css/business-frontpage.css" rel="stylesheet">

<title>Insert title here</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript">
function invalidation(tagId, massage) {
	var id = "#" + tagId;
	var idv = "#" + tagId + "+div";
	$(id).removeClass("is-valid");
	$(id).addClass("is-invalid");
	$(idv).removeClass("valid-feedback");
	$(idv).addClass("invalid-feedback");
	$(idv).html(massage);
}

function validation(tagId, massage) {
	var id = "#" + tagId;
	var idv = "#" + tagId + "+div";
	$(id).removeClass("is-invalid");
	$(id).addClass("is-valid");
	$(idv).removeClass("invalid-feedback");
	$(idv).addClass("valid-feedback");
	$(idv).html(massage);
}

var isPwdOk = true;
function ck_pwd() {
	var p = $("#pwd").val();
	var pa = $("#pwdCheck").val();
	var getCheck = RegExp(/^[a-zA-Z0-9]{4,12}$/);
	if (!getCheck.test(p)) {
		invalidation("pwd", "4~12자리의 영문 대소문자와 숫자로만 입력");
		isPwdOk = false;
	} else {
		validation("pwd", "사용가능한 비밀번호입니다.");
		isPwdOk = false;
		if (p != pa) {
			invalidation("pwdCheck", "비밀번호와 같지 않습니다.");
		} else {
			validation("pwdCheck", "GOOD!");
			isPwdOk = true;
		}
	}
}//end of ck_pwd

function sample6_execDaumPostcode() {
	new daum.Postcode({
				oncomplete : function(data) {
					// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

					// 각 주소의 노출 규칙에 따라 주소를 조합한다.
					// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
					var addr = ''; // 주소 변수
					var extraAddr = ''; // 참고항목 변수

					//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
					if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
						addr = data.roadAddress;
					} else { // 사용자가 지번 주소를 선택했을 경우(J)
						addr = data.jibunAddress;
					}

					// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
					if (data.userSelectedType === 'R') {
						// 법정동명이 있을 경우 추가한다. (법정리는 제외)
						// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
						if (data.bname !== ''
								&& /[동|로|가]$/g.test(data.bname)) {
							extraAddr += data.bname;
						}
						// 건물명이 있고, 공동주택일 경우 추가한다.
						if (data.buildingName !== ''
								&& data.apartment === 'Y') {
							extraAddr += (extraAddr !== '' ? ', '
									+ data.buildingName : data.buildingName);
						}
						// 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
						if (extraAddr !== '') {
							extraAddr = ' (' + extraAddr + ')';
						}
						// 조합된 참고항목을 해당 필드에 넣는다.
						document.getElementById("sample6_extraAddress").value = extraAddr;

					} else {
						document.getElementById("sample6_extraAddress").value = '';
					}

					// 우편번호와 주소 정보를 해당 필드에 넣는다.
					document.getElementById('sample6_postcode').value = data.zonecode;
					document.getElementById("sample6_address").value = addr;
					// 커서를 상세주소 필드로 이동한다.
					document.getElementById("sample6_detailAddress")
							.focus();
				}}).open();
}//end of function sample6_execDaumPostcode()
var usUnOk = false;

	$(function() {
		$("option[value='${splphone[0]}']").attr('selected','selected');
		
		$("#usernameCheck").on("click", function() {
			var un = $("#username").val();
			var special_pattern = RegExp(/[`~!@#$%^&*|\\\'\";:\/?]/gi);
			if (special_pattern.test(un) || un.search(/\s/) != -1
					|| un.length < 3) {
				invalidation("username", "3 ~ 8자리로 공백, 특수문자는 불가능합니다.");
				isUnOk = false;
			}else if(un == "${dto.username}"){
				validation("username", "");
				isUnOk = true;
			}else {
				$.ajax({
					type : 'POST',
					url : "${contextPath}/checkall/usernameCheck",
					data : {username : un},
					success : function(check) {
						var c = JSON.parse(check);
						// 				alert(c);
						if (c == false) {
							validation("username", "사용가능한 이름입니다.");
							isUnOk = true;
						} else {
							invalidation("username", "중복된 이름입니다.");
							isUnOk = false;
						}
					}
				});//end of ajax
			}
		});//end of usernameCheck
		
		$("#pwd").on("keyup", function() {
			ck_pwd();
		});
		$("#pwdCheck").on("keyup", function() {
			ck_pwd();
		});
		
		$("#upload").submit(function() {
			if($("#username").val() == "${dto.username}") isUnOk = true;
			if(isUnOk==true || isPwdOk==true){
				$("#phone").val( $("#firstNum").val() + "-"
						+ $("#middleNum").val() + "-"
						+ $("#lastNum").val());
				return true;
			}else{
				if(isPwdOk==false) invalidation("pwd", "비밀번호를 다시 확인해주세요.");
				if(isUnOk==false) invalidation("username", "중복확인이 필요합니다.");
				return false;
			}
		});
	});//end of onload
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
		<c:choose>
		<c:when test="${requestScope.check==1}">
			<h2 class="my-4">회원 정보 수정</h2>
			<form action="${contextPath}/checkall/mypage/uploadInfo" method="post" id="upload">
			<dl class="row">
				<dt class="col-sm-3">Email</dt>
				<dd class="col-sm-9">
					<input type="text" readonly class="form-control-plaintext" id="email" name="email" value="${requestScope.dto.email}">
				</dd>
				
				<dt class="col-sm-3">Join Date</dt>
				<dd class="col-sm-9">
					<input type="text" readonly class="form-control-plaintext" 
					value="${fmtreg_date}">
				</dd>
				
				<dt class="col-sm-3">Password</dt>
				<dd class="col-sm-9 form-inline">
				<div>
					<input type="password" class="form-control" id="pwd" name="pwd" value="${dto.pwd}">
					<input type="password" class="form-control" id="pwdCheck" value="${dto.pwd}">
					<div class="invalid-feedback"></div>
				</div>
				</dd>
				
				<dt class="col-sm-3">Username</dt>
				<dd class="col-sm-9 form-inline">
				<div>
					<input type="text" class="form-control col-md-8" id="username" name="username" value="${dto.username}" maxlength="8">
					<div class="invalid-feedback"></div>
				</div>
					<input type="button" class="btn btn-primary ml-3" id="usernameCheck" value="중복 확인">
				</dd>
				
				
				<dt class="col-sm-3">Address</dt>
				<dd class="col-sm-9">
				<div>
					<div class="col-md-12 form-inline">
					<input type="text" id="sample6_postcode" name="postcode" 
					value="${dto.postcode}" class="form-control mr-2" placeholder="우편번호" maxlength="5">
					<input type="button" class="btn btn-primary" onclick="sample6_execDaumPostcode()" value="우편번호 찾기"><br>
					<div class="invalid-feedback">우편번호를 입력해주세요</div>
					</div>
				<input type="text" id="sample6_address" class="form-control mb-1 mt-1" 
				value="${dto.address}" name="address" placeholder="주소"> 
				<input type="text" id="sample6_detailAddress" class="form-control"
				value="${dto.detailAddress}" name="detailAddress" placeholder="상세주소">
				<input type="hidden" id="sample6_extraAddress" placeholder="참고항목">
				<div class="invalid-feedback">상세 주소를 입력해주세요</div>

				<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
				<input type="hidden" name="address" id="address" value="">
			</div>
				</dd>
				
				<dt class="col-sm-3">Phone Number</dt>
				<dd class="col-sm-9">
					<div class="form-row form-inline ml-1">
					<select id="firstNum" class="form-control">
						<option value="010">010</option>
						<option value="011">011</option>
					</select> &nbsp;-&nbsp; 
					<input type="text" size="4" maxlength="4" id="middleNum" 
					 	value="${splphone[1]}" class="form-control"
						onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"> &nbsp;-&nbsp; 
					<input type="text" size="4" maxlength="4" id="lastNum"
						value="${splphone[2]}" class="form-control"
						onKeyup="this.value=this.value.replace(/[^0-9]/g,'');">
					<input type="hidden" name="phone" id="phone" value="">
					</div>
				</dd>
			</dl>
			<input type="submit" value="정보 변경하기" class="btn btn-primary btn-lg btn-block">
			
			</form>
		</c:when>
		<c:otherwise>
			<h2 class="my-4">비밀번호 재인증</h2>
			<p>회원 정보 수정을 위해 비밀번호를 입력해 주세요</p>
			<form class="form-inline" action="${contextPath}/checkall/mypage/recheck?f=mdi" method="post">
				<div class="form-group mb-2">
					<label for="username" class="sr-only">Username</label>
					<input type="text" readonly class="form-control-plaintext"
						id="username" value="${sessionScope.login}님">
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
		</c:otherwise>
		</c:choose>
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
		</div>
	</div></div>
		<!-- Bootstrap core JavaScript -->
	<script src="${contextPath}/vendor/jquery/jquery.min.js"></script>
	<script src="${contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>