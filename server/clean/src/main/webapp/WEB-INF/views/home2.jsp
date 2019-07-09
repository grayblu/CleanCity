<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ page session="true"%>

<html>
<head>
<title>Home</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
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

<script>
	$(function() {
		$("#loginBtn").on("click", function() {
			console.log("${contextPath}/user/login")
			location = '${contextPath}/user/login';
		});

		$('#joinBtn').on("click", function() {
			location = '${contextPath}/user/join';
		});
	});
</script>

<body>
	<nav class="navbar navbar-expand-sm bg-dark navbar-dark">
		<a class="navbar-brand" href="/clean"><i class="fas fa-recycle"></i>&nbsp;깨끗한도시</a>
		<button class="navbar-toggler" data-toggle="collapse"
			data-target="#collapsibleNavbar">
			<span class="navbar-toggler-icon"></span>
		</button>

		<div class="collapse navbar-collapse flex-row-reverse"
			id="collapsibleNavbar">
			<c:if test="${empty USER && empty ADMIN}">
				<ul class="nav navbar-nav float-lg-right">
					<li class="nav-item mr-sm-2"><button id="loginBtn"
							type="button" class="btn btn-light m-1">로그인</button></li>
					<li class="nav-item mr-sm-2"><button id="joinBtn"
							type="button" class="btn btn-light m-1">회원가입</button></li>
				</ul>
			</c:if>
			<c:if test="${not empty USER}">
				<ul class="nav navbar-nav float-lg-right">
					<li class="nav-item mr-sm-2"><a class="nav-link"
						href="${contextPath}/user/mypage/${USER.userid}"> <i class="fas fa-user"></i>${USER.userid}</a></li>

					<li class="nav-item mr-sm-2"><a class="nav-link"
						href="${contextPath}/user/logout"> <i
							class="fas fa-sign-out-alt"></i>로그아웃
					</a></li>
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
	<div class="container">
		<!-- Full Page Image Header with Vertically Centered Content -->
		<header class="masthead">
			<div class="container h-100">
				<div class="row h-100 align-items-center">
					<div class="col-12 text-center">
						<h1 class="font-weight-light">클린 시티 프로젝트</h1>
						<p class="lead">자율주행을 활용한 IoT 쓰레기 수거 트럭 개발</p>
					</div>
				</div>
			</div>
		</header>

		<!-- Page Content -->
		<section id="about">
			<div class="container">
				<h2 class="font-weight-light text-center mb-3">About</h2>
				<h4>우리의 프로젝트 목표는 자율주행 기술을 활용하여 도시 전역의 쓰레기를 효과적으로 수거하는 것입니다.</h4>
			</div>
		</section>

		<section id="services">
			<div class="container">
				<div class="row">
					<div class="col-lg-12">
						<h2 class="font-weight-light text-center mb-3">Service</h2>
					</div>
				</div>
				<div class="row text-center">
					<div class="col-4">
						<i class="fas fa-map-marked-alt fa-4x"></i>
						<h2 class="global-positioning">위치 확인</h2>
					</div>
					<div class="col-4">
						<i class="fas fa-users fa-4x"></i>
						<h2 class="remote">원격 주행</h2>
					</div>
					<div class="col-4">
						<i class="fas fa-database fa-4x"></i>
						<h2 class="dashboard">수거 현황</h2>
					</div>
				</div>
			</div>
		</section>
	</div>

</body>
</html>
