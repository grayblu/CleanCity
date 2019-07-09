<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<title>깨끗한 도시</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://use.fontawesome.com/releases/v5.7.2/css/all.css">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.2.1/css/bootstrap.min.css">
<link rel="stylesheet" href="${contextPath}/resources/css/home.css">
<!-- Page font -->
<link href="https://fonts.googleapis.com/css?family=Noto+Sans+KR&display=swap" rel="stylesheet">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js" ></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.6/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.2.1/js/bootstrap.min.js"></script>
<style>
	
	body{
		font-family: 'Noto Sans KR', sans-serif;
	}

</style>

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


</head>
<body>

	<!-- Navigation -->
	<nav class="navbar navbar-expand navbar-dark bg-dark">
		<div class="container-fluid">
			<a class="navbar-brand" href="${contextPath}"><img
				class="img-circle" alt="main_icon" src="resources/img/truck.png"
				width="40" height="40">&nbsp;깨끗한 도시</a>
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
						href="${contextPath}/user/mypage/${USER.userid}"> <i
							class="fas fa-user"></i>${USER.userid}</a></li>

					<li class="nav-item mr-sm-2"><a class="nav-link"
						href="${contextPath}/user/logout"> <i
							class="fas fa-sign-out-alt"></i>로그아웃
					</a></li>
				</ul>
			</c:if>
			<c:if test="${not empty ADMIN}">
				<ul class="nav navbar-nav float-lg-right">
					<li class="nav-item mr-sm-2"><a class="nav-link"
						href="${contextPath}/admin"> <i class="fas fa-user"></i>${ADMIN.userid}</a></li>

					<li class="nav-item mr-sm-2"><a class="nav-link"
						href="${contextPath}/user/logout"> <i
							class="fas fa-sign-out-alt"></i>로그아웃
					</a></li>
				</ul>
			</c:if>


			<button class="navbar-toggler" type="button" data-toggle="collapse"
				data-target="#navbarResponsive" aria-controls="navbarResponsive"
				aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarResponsive">
				<ul class="navbar-nav ml-auto">
					<li class="nav-item active"><a class="nav-link"
						href="${contextPath}">Home <span class="sr-only">(current)</span>
					</a></li>
					<li class="nav-item"><a class="nav-link" href="#about">About</a>
					</li>
					<li class="nav-item"><a class="nav-link" href="#services">Services</a>
					</li>
				</ul>
			</div>
		</div>
	</nav>

	<!-- Full Page Image Header -->
	<header class="masthead">
		<div class="container h-100">
			<div class="row h-100">
				<span class="col-12"></span>
				<div class="col-12 text-center">
					<h1>클린 시티 프로젝트</h1>
					<p class="lead">자율주행을 활용한 쓰레기 수거 서비스</p>
				</div>
				<span class="col-12"></span>
				<span class="col-12"></span>
			</div>
		</div>
	</header>
	<br/>
	<!-- Page Content -->
	<section id="about">
		<div class="container">
			<h2 class="font-weight-light text-center mb-3">About</h2>
			<h4>우리의 프로젝트 목표는 자율주행 기술을 활용하여 도시 전역의 쓰레기를 효과적으로 수거하는 것입니다.</h4>
		</div>
	</section>
	<br/>
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