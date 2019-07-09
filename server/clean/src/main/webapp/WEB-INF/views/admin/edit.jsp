<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<html>
<head>
<title>Home</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
a:link { color: black; text-decoration: none;}

a:visited { color: black; text-decoration: none;}

a:hover { color: #ffc107; text-decoration: underline;}
</style>
</head>
<link rel="stylesheet"
	href="https://use.fontawesome.com/releases/v5.7.2/css/all.css"
	integrity="sha384-fnmOCqbTlWIlj8LyTjo7mOUStjsKC4pOpQbqyi7RrhN7udi9RwhKkMHpvLbHG9Sr"
	crossorigin="anonymous">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.2.1/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.6/umd/popper.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/4.2.1/js/bootstrap.min.js"></script>

<!-- Page font -->
<link href="https://fonts.googleapis.com/css?family=Noto+Sans+KR&display=swap" rel="stylesheet">

<style>
body{
		font-family: 'Noto Sans KR', sans-serif;
}
footer {
	  position: fixed;
	  left: 0;
	  bottom: 0;
	  width: 100%;
	}
a:link { color: black; text-decoration: none;}

a:visited { color: black; text-decoration: none;}
</style>
<body>
	<nav class="navbar navbar-expand-sm bg-dark navbar-dark">
		<a class="navbar-brand" href="/clean"><i class="fas fa-recycle"></i>
			깨끗한도시</a>
		<button class="navbar-toggler" data-toggle="collapse"
			data-target="#collapsibleNavbar">
			<span class="navbar-toggler-icon"></span>
		</button>

		<div class="collapse navbar-collapse flex-row-reverse"
			id="collapsibleNavbar">
			<c:if test="${empty ADMIN}">
				<ul class="nav navbar-nav float-lg-right">
					<li class="nav-item mr-sm-2"><button id="loginBtn"
							type="button" class="btn btn-light m-1">로그인</button></li>
					<li class="nav-item mr-sm-2"><button id="joinBtn"
							type="button" class="btn btn-light m-1">회원가입</button></li>
				</ul>
			</c:if>
			<c:if test="${not empty ADMIN}">
				<ul class="nav navbar-nav float-lg-right">
					<li class="nav-item mr-sm-2"><a class="nav-link"
						href="${contextPath}/admin/"> <i class="fas fa-user"></i>${ADMIN.userid}</a></li>

					<li class="nav-item mr-sm-2"><a class="nav-link"
						href="${contextPath}/user/logout"> <i
							class="fas fa-sign-out-alt"></i>로그아웃
					</a></li>
				</ul>
			</c:if>
		</div>
	</nav>

	<div class="container mt-5">
		<ul class="nav nav-tabs nav-justified">
			<li class="nav-item"><a class="nav-link active"
				href="${contextPath}/admin/list"><i class="fas fa-user-friends"></i>
					사용자 목록</a></li>
			<li class="nav-item"><a class="nav-link"
				href="${contextPath}/admin/monitor"><i class="fas fa-location-arrow"></i> 관제</a></li>
			<li class="nav-item"><a class="nav-link" href="#"><i
					class="fas fa-history"></i> 이용현황</a></li>
		</ul>

		<div class="jumbotron mt-5 mx-auto">
			<h3 class="m-3">
				<i class="fas fa-sign-in-alt"></i> 회원정보 수정
			</h3>
			<form:form modelAttribute="user">
				<form:hidden path="userid" class="form-contorl" />
				<form:hidden path="passwd" class="form-contorl" />
				<form:hidden path="condition" class="form-contorl" />
				<div class="form-group m-4">
					<h4>
						<i class="fas fa-user"></i> ${user.userid}
					</h4>
				</div>
				<div class="form-group m-4">
					<label for="bin"><i class="fas fa-trash"></i> 쓰레기통 설치
						여부&nbsp;</label>
					<form:radiobutton path="bin" value="0" label="미설치" />
					<form:radiobutton path="bin" value="1" label="설치" />
				</div>
				<div class="form-group m-4">
					<label for="email"><i class="fas fa-envelope"></i> 이메일</label>
					<form:input tpye="email" path="email" class="form-control" />
					<form:errors path="email" element="div" cssClass="error" />
				</div>
				<div class="form-group m-4">
					<label for="address"><i class="fas fa-map-marker-alt"></i>
						주소</label>
					<form:input type="text" path="address" class="form-control" />
					<form:errors path="address" element="div" cssClass="error" />
				</div>
				<div class="form-group m-4">
					<label for="phone"><i class="fas fa-phone"></i> 전화번호</label>
					<form:input type="phone" path="phone" class="form-control" />
					<form:errors path="phone" element="div" cssClass="error" />
				</div>
				<div class="form-group m-4">
					<label for="lat"><i class="fas fa-map-marked-alt"></i> 위도</label>
					<form:input type="text" path="lat" class="form-control" />
				</div>
				<div class="form-group m-4">
					<label for="lon"><i class="fas fa-map-marked-alt"></i> 경도</label>
					<form:input type="text" path="lon" class="form-control" />
				</div>
				<div class="form-group m-4">
					<label for="cap">용량</label>
					<form:input type="text" path="cap" class="form-control" />
				</div>
				<div class="container text-center mt-4">
					<button id="submitBtn" type="submit" class="btn btn-secondary">수정</button>
					<button id="cancleBtn" type="button" class="btn btn-danger">다시작성</button>
				</div>
			</form:form>
		</div>
	</div>
	
	<!-- footer -->
	<footer class="mt-5 p-3 bg-dark text-white">
		<div class="container-fluid">
			<div class="row">
				<div class="col-sm-6">
					깨끗한 도시 &copy; 2019.05.23
				</div>
				<div class="col-sm-6 text-right">
					자율주행을 활용한 IoT 개발 전문가
				</div>
			</div>
		</div>
	</footer>
</body>
</html>