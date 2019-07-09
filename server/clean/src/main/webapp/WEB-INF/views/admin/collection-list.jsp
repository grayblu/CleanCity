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
.page-item.active .page-link {
	background-color: #495057;
}
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
<script>
	$(function() {
		//$('#select-btn').attr('value', $(this).attr(''));
		console.log('${pi.list}');
		var type = '${type}';
		console.log(type);
		
		if(type == 'userid') {
			$('#select-btn').html('사용자ID');
		} else if(type == 'region') {
			$('#select-btn').html('지역');
		} else if(type == 'date') {
			$('#select-btn').html('날짜');
		} else {
			$('#select-btn').html('선택');
		}
		
		$('#select-btn').attr('value', $(this).attr('${type}'));		
		$('#searchType li').on('click', function() {
			console.log('드롭다운 메뉴 클릭');
			var button = $('#select-btn');
			$('#select-btn').html($(this).html());
			$('#select-btn').attr('value', $(this).attr('value'));
			console.log(button.attr('value'));
			$('#type').attr('value', $(this).attr('value'));
			console.log($('#type').attr('value'));
		});
	});
</script>
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
						href="${contextPath}/admin/"> <i class="fas fa-user"></i>&nbsp;${ADMIN.userid}
					</a></li>

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
			<li class="nav-item"><a style="color: black;" class="nav-link"
				href="${contextPath}/admin/list"><i class="fas fa-user-friends"></i>
					사용자 목록</a></li>
			<li class="nav-item"><a style="color: black;" class="nav-link"
				href="${contextPath}/admin/monitor"><i
					class="fas fa-location-arrow"></i> 관제</a></li>
			<li class="nav-item"><a
				style="background-color: #ffc107; color: black;"
				class="nav-link active" href="${contextPath}/admin/collection-list"><i
					class="fas fa-history"></i> 이용현황</a></li>
		</ul>

		<div class="jumbotron mt-5 content-center">
			<table class="table table-dark table-striped text-center">
				<thead class="thead-dark">
					<tr>
						<th><i class="fas fa-list-ol"></i> 번호</th>
						<th><i class="fas fa-user-friends"></i> 사용자</th>
						<th><i class="fas fa-battery-full"></i> 용량</th>
						<th><i class="fas fa-map-marker-alt"></i> 지역</th>
						<th><i class="fas fa-calendar-check"></i> 수집일</th>
					</tr>
				</thead>
				<c:forEach var="garbageCollection" items="${pi.list}"
					varStatus="status">
					<tr>
						<td>${garbageCollection.collectionNo}</td>
						<td>${garbageCollection.userid}</td>
						<td>${garbageCollection.cap}</td>
						<td>${garbageCollection.address}</td>
						<td><fmt:formatDate value="${garbageCollection.emptyDate}"
								pattern="yyyy-MM-dd hh:mm:ss" /></td>
					</tr>
				</c:forEach>
			</table>

			<ul class="pagination pagination-md justify-content-center mt-4">
				<c:forEach var="idx" begin="1" end="${pi.totalPage }">
					<c:choose>
						<c:when test="${pi.page == idx}">
							<li class="page-item active"><a class="page-link"
								style="background-color: #495057; border-color: #f8f9fa;"
								href="?page=${idx }">${idx }</a></li>
						</c:when>
						<c:otherwise>
							<li class="page-item"><a class="page-link"
								href="?page=${idx }">${idx }</a></li>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</ul>
			
			<form:form modelAttribute="search">
				<form:hidden id="type" path="type" class="form-contorl" />
				<form:errors path="type"  cssClass="alert">
					<div class="alert alert-warning">
						<strong>${fail}</strong>
					</div>
				</form:errors>
				<div class="input-group mt-4">
					<div class="input-group-prepend">
						<button id="select-btn" type="button"
							class="btn btn-outline-secondary dropdown-toggle"
							data-toggle="dropdown" value="">선택</button>
						<ul id="searchType" class="dropdown-menu">
							<li class="dropdown-item" value="userid">사용자ID</li>
							<li class="dropdown-item" value="region">지역</li>
							<li class="dropdown-item" value="date">날짜</li>
						</ul>
					</div>
	
					<form:input path="content" type="text" class="form-control" placeholder="검색어를 입력하세요."/>
					<span class="input-group-btn">
						<button class="btn btn-warning" type="submit">SEARCH</button>
					</span>
				</div>
			</form:form>​​​​​​​
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