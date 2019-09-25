<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

<title>Business Frontpage - Start Bootstrap Template</title>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!-- Bootstrap core CSS -->
<link href="${contextPath}/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<!-- Custom styles for this template -->
<link href="${contextPath}/css/form-validation.css" rel="stylesheet">
<!-- Custom styles for nav template -->
<link href="${contextPath}/css/business-frontpage.css" rel="stylesheet">

<title>Insert title here</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
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

	var isPwdOk = false;
	var isUnOk = false;
	var isEmailOk = false;
	var code = "";

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

	$(function() {
		$("#pwd").on("keyup", function() {
			ck_pwd();
		});
		$("#pwdCheck").on("keyup", function() {
			ck_pwd();
		});

		
		$("#usernameCheck").on("click", function() {
			var un = $("#username").val();
			var special_pattern = RegExp(/[`~!@#$%^&*|\\\'\";:\/?]/gi);
			if (special_pattern.test(un) || un.search(/\s/) != -1
					|| un.length < 3) {
				invalidation("username", "3 ~ 8자리로 공백, 특수문자는 불가능합니다.");
				isUnOk = false;
			} else {
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

		$("#emailCheck").on("click", function() {
			var getMail = RegExp(/^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/);
			var em = $("#email").val();

			if (!getMail.test(em)) {
				invalidation("email", "유효한 메일주소를 입력해 주세요.");
			} else {
				validation("email", '메일 보내는중..'
						  +'<div class="spinner-border spinner-border-sm" role="status">'
						  +'<span class="sr-only">Loading...</span>'
						  +'</div>');
				$.ajax({
					type : 'POST',
					url : "${contextPath}/checkall/sendEmail",
					data : {email : em},
					success : function(check) {
						code = $.trim(check);
						if (code == "x") {
							alert("메일 발송이 불가능합니다! 다른 메일을 써주세요");
						} else if (code == "중복") {
							invalidation("email", "이미 가입된 이메일입니다.");
						} else {
							validation("email", "");
							$("#emailCode").removeClass("dsp");
						}
					}
				});
			}
		});//end of emailCheck

		$("#codeCheck").on("click", function() {
			var tmp = $("#code").val();
			if (tmp == code) {
				isEmailOk = true;
				validation("code", "메일 인증이 완료되었습니다.");
			} else {
				isEmailOk = false;
				invalidation("code", "인증번호 불일치");
			}
		});//end of emailCheck_1

		$("#join").submit( function(event) {
			if (!isPwdOk || !isUnOk || !isEmailOk || $("#save-info:checked").val() == null || $("#save-address:checked").val() == null) {
				if (!isPwdOk) invalidation("pwd", "비밀번호가 필요합니다.");
				if (!isUnOk) invalidation("username", "중복확인이 필요합니다.");
				if (!isEmailOk) invalidation("email", "메일 인증 필요합니다.");
				if ($("#save-info:checked").val() == null) invalidation("save-info", "체크해주세요");
				if ($("#save-address:checked").val() == null) invalidation("save-address", "체크해주세요");

				return false;
			} else {
				$("#phone").val( $("#firstNum").val() + "-"
								+ $("#middleNum").val() + "-"
								+ $("#lastNum").val());
			}
		});

		$("#save-address").click(function() {
			validation("save-address", "");
		});

		$("#save-info").click(function() {
			validation("save-info", "");
		});
	});//end of onload
</script>

</head>
<body>
	<div id="wrap" class="container">
		<h2 class="mb-3">WELCOME!</h2>

		<form class="needs-validation" novalidate method="POST" id="join" action="${contextPath}/checkall/addMembers">
			<div class="mb-3" id="emailDiv">
				<label for="email">Email</label>
				<div class="input-group col-md-12 form-inline mb-3">
					<div>
						<input type="email" class="form-control" id="email" name="email" placeholder="you@example.com" required>
						<div class="invalid-feedback">Please enter a valid email address.</div>
					</div>
					<div>
						<input type="button" class="btn btn-outline-dark ml-3" id="emailCheck" value="이메일 인증">
					</div>
				</div>

				<div class="input-group col-md-12 form-inline mb-3 dsp" id="emailCode">
					<div>
						<input type="text" class="form-control" id="code" placeholder="이메일 인증 코드를 입력해주세요" required>
						<div class="invalid-feedback">이메일 인증 코드를 입력해주세요</div>
					</div>
					<div>
						<input type="button" class="btn btn-outline-dark ml-3" id="codeCheck" value="코드 입력">
					</div>
				</div>
			</div>

			<div class="row mb-3 ml-1">
				<div class="col-md-5 mr-3">
					<label for="pwd">Password</label>
					<input type="password" class="form-control" id="pwd" name="pwd" placeholder="Please Enter a password" required>
					<div class="invalid-feedback">비밀번호를 입력해 주세요.</div>
				</div>
				<div class="col-md-5">
					<label for="lastName">확인</label>
					<input type="password" class="form-control" id="pwdCheck" placeholder="Pleas Enter again" required>
					<div class="invalid-feedback">비밀번호 양식을 맞춰주세요.</div>
				</div>
			</div>

			<div class="mb-3">
				<label for="username">Username</label>
				<div class="input-group col-md-12 form-inline">
					<div>
						<input type="text" class="form-control" id="username" name="username" placeholder="Please Enter a Username" maxlength="8" required>
						<div class="invalid-feedback">Your username is required.</div>
					</div>
					<div>
						<input type="button" class="btn btn-outline-dark ml-3" id="usernameCheck" value="중복 확인">
					</div>
				</div>
			</div>

			<div>
				<label for="phone">Phone number</label><span class="text-muted"> (Optional)</span>
				<div class="mb-3 form-row form-inline ml-1">
					<select id="firstNum" class="form-control">
						<option selected="selected" value="010">010</option>
						<option value="011">011</option>
					</select> &nbsp;-&nbsp; 
					<input type="text" size="4" maxlength="4" id="middleNum" class="form-control"
						onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"> &nbsp;-&nbsp; 
					<input type="text" size="4" maxlength="4" id="lastNum" class="form-control"
						onKeyup="this.value=this.value.replace(/[^0-9]/g,'');">
					<input type="hidden" name="phone" id="phone" value="">
				</div>
			</div>

			<div class="mb-3">
				<label for="address">Address</label><span class="text-muted"> (Optional)</span><Br>
				<div class="col-md-12 form-inline">
					<input type="text" id="sample6_postcode" name="postcode" class="form-control mr-2" placeholder="우편번호" maxlength="5">
					<input type="button" class="btn btn-outline-dark" onclick="sample6_execDaumPostcode()" value="우편번호 찾기"><br>
					<div class="invalid-feedback">우편번호를 입력해주세요</div>
				</div>
				<input type="text" id="sample6_address" class="form-control mb-1 mt-1" name="address" placeholder="주소"> 
				<input type="text" id="sample6_detailAddress" class="form-control mb-1" name="detailAddress" placeholder="상세주소">
				<input type="hidden" id="sample6_extraAddress" placeholder="참고항목">
				<div class="invalid-feedback">상세 주소를 입력해주세요</div>

				<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
			</div>

			<hr class="mb-3">
			<div class="custom-control custom-checkbox">
				<input type="checkbox" class="custom-control-input" id="save-address" required> 
				<label class="custom-control-label" for="save-address">회원가입 약관에 동의합니다.</label>
				<div class="invalid-feedback">동의하셔야 가입이 가능합니다.</div>
			</div>
			<div class="custom-control custom-checkbox">
				<input type="checkbox" class="custom-control-input" id="save-info" required>
				<label class="custom-control-label" for="save-info">개인정보 약관에 동의합니다.</label>
				<div class="invalid-feedback">동의하셔야 가입이 가능합니다.</div>
			</div>
			<hr class="mb-4">
			<input type="submit" class="btn btn-dark col-md-12" value="가입하기">
		</form>
	</div>
</body>
</html>