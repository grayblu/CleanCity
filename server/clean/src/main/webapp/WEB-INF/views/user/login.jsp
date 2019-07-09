<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

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
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.6/umd/popper.min.js">
</script>
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
</style>

<script>
	$.fn.cancle = function() {
		var self = this;

		self.click(function() {
			var form = self.closest('form')
			form.find('input').val('');
		});
	}
	$(function() {
		$('#cancleBtn').cancle();

		$('#joinBtn').on("click", function() {
			location = '${contextPath}/user/join';
		});
		$("#loginBtn").on("click", function() {
			location = '${contextPath}/user/login';
		});
	});
</script>

<body>
	<!-- header -->
	<header>
		<nav class="navbar navbar-expand navbar-dark bg-dark">
		  <div class="container-fluid">
		    <a class="navbar-brand" href="${contextPath}">
		    	<img class="img-circle" alt="main_icon" src="${contextPath}/resources/img/truck.png" width="40" height="40">
		    	깨끗한 도시
			</a>
		  </div>
		</nav>
	</header>
	<!-- <nav class="navbar navbar-expand-sm bg-dark navbar-dark">
		<a class="navbar-brand" href="/clean"><i class="fas fa-recycle"></i>&nbsp;깨끗한도시</a>
		<button class="navbar-toggler" data-toggle="collapse"
			data-target="#collapsibleNavbar">
			<span class="navbar-toggler-icon"></span>
		</button>

		<div class="collapse navbar-collapse flex-row-reverse"
			id="collapsibleNavbar">
			<ul class="nav navbar-nav float-lg-right">
				<li class="nav-item mr-sm-2"><button id="loginBtn"
						type="button" class="btn btn-light m-1">로그인</button></li>
				<li class="nav-item mr-sm-2"><button id="joinBtn" type="button"
						class="btn btn-light m-1">회원가입</button></li>
			</ul>
		</div>
	</nav>
 -->	<br/>
	<div class="container">
		<div class="jumbotron">
			<h3 class="m-3">
				<i class="fas fa-sign-in-alt"></i> 로그인
			</h3>
			
			<c:if test="${not empty loginInfo.target}">
				<div class="alert alert-warning">
					<strong>${loginInfo.reason}</strong>
				</div>
			</c:if>
			
			<form:form modelAttribute="loginInfo">
				<form:hidden path="target"/>
				<div class="form-group m-4">
					<label for="userid"><i class="fas fa-user"></i> 아이디</label>
					<form:input path="userid" class="form-control" />
					<form:errors path="userid" element="div" cssClass="error" />
				</div>
				<div class="form-group m-4">
					<label for="passwd"><i class="fas fa-lock"></i> 비밀번호</label>
					<form:input path="passwd" type="password" class="form-control" />
					<form:errors path="passwd" element="div" cssClass="error" />
				</div>
				<div class="container text-center mt-4">
					<form:errors element="div" cssClass="error mb-4" />
					<button id="submitBtn" type="submit" class="btn btn-secondary">로그인</button>
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