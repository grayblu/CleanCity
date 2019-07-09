<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<html>
<head>
<title>깨끗한도시</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
a:link {
	color: black;
}

a:visited {
	color: black;
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

<!-- Naver Maps API 키 값 필요 -->
<script type="text/javascript"
	src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=ncpClientId">
</script>


<!-- Toggle Switch -->
<link href="https://gitcdn.github.io/bootstrap-toggle/2.2.2/css/bootstrap-toggle.min.css" rel="stylesheet">
<script src="https://gitcdn.github.io/bootstrap-toggle/2.2.2/js/bootstrap-toggle.min.js"></script>

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
	var socket = new WebSocket("ws://70.12.109.151:8080/clean/admin/monitor/data");
	var infoWindow;
	var lastUser;
	
	function getCollectingData(type, userid) {
		var jsonMsg = new Object();
		jsonMsg.type = type;
		jsonMsg.userid = userid;
		
		return JSON.stringify(jsonMsg);
	}
	
	function getDriveData(type, direction) {
		var jsonMsg = new Object();
		jsonMsg.type = type;
		jsonMsg.direction = direction;
				
		return JSON.stringify(jsonMsg);
	}
	
	function getContentString(users, userid) {
		var contentString = ['<div class="card">',
			'<div class="card-body text-center">',
				'<h4 class="card-title">'+users[userid].userid+'</h4>',
				'<p class="card-text">'+users[userid].address+'</p>',
				'<p class="card-text">용량 : '+ users[userid].cap+'L</p>',
				'<p class="card-text">상태 : ' + users[userid].condition + '</p>',
				'<button id="info-plus-btn" class="btn btn-dark m-1">수거</button>',
				'<button id="info-cancle-btn" class="btn btn-danger m-1">취소</button>',
			'</div>',								
		'</div>'].join('');
		
		return contentString;
	}
	
	function makeMarker(map, user) {
		if(user.cap >= 75) {
			contentColor = '<i class="fas fa-trash-alt fa-lg" style="color:#FD2876;"></i>';
		} else if(user.cap >= 40) {
			contentColor = '<i class="fas fa-trash-alt fa-lg" style="color:#F6C501;"></i>';
		} else {
			contentColor = '<i class="fas fa-trash-alt fa-lg" style="color:#00FF00;"></i>';
		}
		
		// marker 생성
		var marker = new naver.maps.Marker({
			position : new naver.maps.LatLng(user.lat, user.lon),				
			map : map,
			icon : {
				content : contentColor,
				size : new naver.maps.Size(22, 35),
				anchor : new naver.maps.Point(11,35)
			}
		});
		
		return marker;
	}
	
	$.fn.getUsers = function(map) {
		console.log('사용자 목록 불러오기');
		
		var userArray = JSON.parse('${userList}');		
		var users = new Array();
				
		userArray.forEach(user=> {			
			var contentColor;
			var userid = user.userid;
			users[userid] = user;
			
 			var contentString = getContentString(users, userid);			
			infoWindow = new naver.maps.InfoWindow({
				content : contentString 
			});			
			
			users[userid].marker = makeMarker(map, user);
			users[userid].infoWindow = infoWindow;
			
			lastUser = userid;			
			makeInfoWindow(map, infoWindow, users, user);
		});
		
		return users;
	}
	
	$.fn.loadMap = function() {
		var mapOptions = {
				center : new naver.maps.LatLng(37.4999, 127.03739),
				zoom : 10,
				zoomControl : true,
				zoomControlOptions : {
					style : naver.maps.ZoomControlStyle.SMALL
				}
			};
		var map = new naver.maps.Map('map', mapOptions);
		
		return map;
	}
	
	$.fn.updateInfoWindow = function(map, infoWindow, users, user) {
		var userid = user.userid;
		
		infoWindow = new naver.maps.InfoWindow({
			content : getContentString(users, userid)
		});
		
		users[userid].marker = makeMarker(map, user);
		makeInfoWindow(map, infoWindow, users, user);		
		users[userid].infoWindow = infoWindow;
		
		lastUser = userid;
	}
	
	function makeInfoWindow(map, infoWindow, users, user) {
		var userid = user.userid;
		users[lastUser].infoWindow.close();
		
		// 기존 마커 리스너를 삭제하고 새로운 마커 리스너를 생성 후 InfoWindow 객체를 등록
		naver.maps.Event.clearInstanceListeners(users[userid].marker);
		naver.maps.Event.addListener(users[userid].marker, 'click', function(e) {			
			var infoWindowElement;
			
			// 맵에 마커의 윈도우창이 열려있으면
			if(infoWindow.getMap()) {
				infoWindowElement = infoWindow.getElement();
				$(infoWindowElement).off('click', '#info-plus-btn');
				$(infoWindowElement).off('click', '#info-cancle-btn');
				infoWindow.close();
			} else {
				infoWindow.open(map, users[userid].marker);					
				infoWindowElement = infoWindow.getElement();
				$(infoWindowElement).off('click', '#info-plus-btn');
				$(infoWindowElement).off('click', '#info-cancle-btn');
				$(infoWindowElement).on('click', '#info-plus-btn', function() {
					$('#condition-table').updateCollectingList(map, infoWindow, users, user, 'collecting');
					$('#map').updateInfoWindow(map, infoWindow, users, user);
					infoWindow.close();
				});
				
				$(infoWindowElement).on('click', '#info-cancle-btn', function() {
					$('#condition-table').updateCollectingList(map, infoWindow, users, user, 'waiting');
					$('#map').updateInfoWindow(map, infoWindow, users, user);
					infoWindow.close();
				});
			}
		});
	}
	
	$.fn.getConditionList = function() {
		console.log('---------상태 리스트 출력-----------');
		
		var userList;
						
		// 수집중인 쓰레기 리스트 가져오기
		$.ajax({
			type : "GET",
			url : '${contextPath}/admin/collectingList',
			contentType : "application/json",
			charset : "utf-8",
			dataType : "text",
			success : function(response) {
				response = JSON.parse(response);
				var list = JSON.parse(response.message);
				
				if(response.result == 'ok') {
					$('#collectSize').text(list.length);
					
					$.each(list, function(index, user) {
						socket.send(getCollectingData('collectingList', user.userid));

						var rowItem = "<tr>";
						rowItem += "<td>" + user.userid + "</td>";
						rowItem += "<td>" + user.address + "</td>";
						rowItem += "<td>" + user.lat + "</td>";
						rowItem += "<td>" + user.lon + "</td>";
						rowItem += "<td>" + user.cap + "</td>";
						rowItem += "<td>" + user.condition + "</td>";
						rowItem += "</tr>";						
						$('#condition-table > tbody:last').append(rowItem);
					});
				}
			}
		});
		console.log('------------------------------');
	}
	
	$.fn.updateCollectingList = function(map, infoWindow, users, user, condition) {		
		var data = new Object();
		var userid = user.userid;
		data.userid = userid;
		data.condition = condition;
		console.log(data);
		data = JSON.stringify(data);
		
		$.ajax({
			type : "POST",
			url : '${contextPath}/admin/updateCollectingList',
			contentType : "application/json",
			charset : "utf-8",
			dataType : "text",
			data : data,
			success : function(response) {
				response = JSON.parse(response);
				var list = JSON.parse(response.message);
				
				if(response.result == 'ok') {
					$('#collectSize').text(list.length);					
					$('#condition-table > tbody > tr').remove();
					users[userid].condition = condition;
					$('#condition-table').getConditionList();
					$('#map').updateInfoWindow(map, infoWindow, users, user);
				}
			}
		});
	}
	
	$(function() {
	    $('#toggle-event').change(function() {
	    	console.log($(this).prop('checked'));
	    	
	    	if($(this).prop('checked')) { // 자동모드
	    		console.log('자율주행모드로 전환');
	    		socket.send('{"type":"state", "mode":"auto"}');
	    	} else {
	    		console.log('수동모드로 전환');
	    		socket.send('{"type":"state", "mode":"passive"}');
	    	}
	    })
	 });
	  
	$(function() {
		var map = $('#map').loadMap();
		var users = $('#map').getUsers(map);
		
		$('#condition-table').getConditionList();
		
		if(!window.WebSocket) {
			alert('웹 소켓을 지원하지 않는 브라우저 입니다.');
			return;
		}

		socket.onopen = function() {
			console.log('웹소켓 접속 성공');
			socket.send('{"type":"browser"}');
		}
		
		socket.onclose = function() {
			console.log('웹소켓 접속 해제');
			socket.send('{"type":"termination"}');
		}
		
		// 웹소켓 메시지 수신시
		socket.onmessage = function(msg) {
			console.log(msg);
			console.log('데이터 수신 : ', msg.data);
						
			var contentString;
			var jsonMsg = JSON.parse(msg.data);
			var type = jsonMsg.type;
			
			console.log('type >> ' + type);
			
			if(type == 'binData' || 'collectedData') {
				var userid = jsonMsg.userid;
				var user = users[userid];
				var marker = users[userid].marker;			
				users[userid].cap = jsonMsg.cap;
				
				var updateUserCap = {
						userid : userid,
						cap : jsonMsg.cap,
						type : jsonMsg.type,
						address : jsonMsg.address
				};
				
				// 쓰레기통 용량 업데이트
				$.ajax({
					type : "POST",
					url : '${contextPath}/admin/capUpdate',
					contentType : "application/json",
					charset : "utf-8",
					dataType : "text",
					data : JSON.stringify(updateUserCap),
					success : function(response) {
						var res = JSON.parse(response);
						console.log(res);
						if(res.result == 'ok') {
							//alert('갱신하였습니다');
						} else {
							alert('갱신에 실패하였습니다');
						}
					}
				});
				
				users[lastUser].infoWindow.close();
				
				if(type == 'collectedData') {
					users[userid].cap = 0;
					users[userid].condition = "waiting";
					$('#condition-table').updateCollectingList(map, users[userid].infoWindow, users, users[userid], 'waiting');
				} else {
					users[userid].cap = jsonMsg.cap;
					$('#condition-table').updateCollectingList(map, users[userid].infoWindow, users, users[userid], users[userid].condition);
				}
				
				$('#map').updateInfoWindow(map, infoWindow, users, user);
			}
		}
				
		$('#forward-btn').click(function() {
			console.log('△');
			console.log(getDriveData('driving', 'forward'));
			socket.send(getDriveData('driving', 'forward'));
		});
		$('#left-btn').click(function() {
			console.log('◁');
			console.log(getDriveData('driving', 'turnrleft'));
			socket.send(getDriveData('driving', 'turnrleft'));
		});
		$('#back-btn').click(function() {
			console.log('▽');
			console.log(getDriveData('driving', 'back'));
			socket.send(getDriveData('driving', 'back'));
		});
		$('#right-btn').click(function() {
			console.log('▷');
			console.log(getDriveData('driving', 'turnright'));
			socket.send(getDriveData('driving', 'turnright'));
		});
		$('#stop-btn').click(function() {
			console.log('STOP');
			console.log(getDriveData('driving', 'stop'));
			socket.send(getDriveData('driving', 'stop'));
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
			<li class="nav-item"><a
				style="background-color: #ffc107; color: black;"
				class="nav-link active" href="${contextPath}/admin/monitor"><i
					class="fas fa-location-arrow"></i> 관제</a></li>
			<li class="nav-item"><a style="color: black;" class="nav-link"
				href="${contextPath}/admin/collection-list"><i
					class="fas fa-history"></i> 이용현황</a></li>
		</ul>

		<div class="jumbotron mt-5 text-center">
			<div id="map" style="width: 100%; height: 400px;"></div>
			<br />
			<div>
				<button type="button" class="btn btn-warning">
					수거 리스트&nbsp;<span id="collectSize" class="badge badge-light">0</span>
				</button>
			</div>
			<br />
			<table id='condition-table'
				class="table table-dark table-striped text-center">
				<thead class="thead-dark">
					<tr>
						<th><i class="fas fa-user-friends"></i> 사용자</th>
						<th><i class="fas fa-map-marker-alt"></i> 주소</th>
						<th><i class="fas fa-map-marked-alt"></i> 위도</th>
						<th><i class="fas fa-map-marked-alt"></i> 경도</th>
						<th><i class="fas fa-battery-full"></i> 용량</th>
						<th><i class="fas fa-flag-usa"></i> 상태</th>
					</tr>
				</thead>

				<tbody>
				</tbody>
			</table>

			<br />

			<div class="row mt-5">
				<div class="col-md-8 my-auto">
					<div>
						<button class="btn btn-warning mb-3">차량 카메라</button>
					</div>
					<img src="${contextPath}/camera/1" class="mx-auto d-block"
						style="width: 100%; height: 400px;" />
				</div>
				<div class="col-md-4 my-auto">
					<div>
						<h5>자율주행 모드</h5>
						<input id="toggle-event" type="checkbox" data-toggle="toggle" data-onstyle="warning">						
					</div>
										
					<button id="forward-btn" type="button" class="btn btn-dark btn-lg mt-3">
						<i class="fas fa-arrow-up"></i>
					</button>
					
					<div>
					<button id="left-btn" type="button" class="btn btn-dark btn-lg mt-1">
						<i class="fas fa-arrow-left"></i>
					</button>
					<button id="back-btn" type="button" class="btn btn-dark btn-lg mt-1">
						<i class="fas fa-redo"></i>
					</button>
					<button id="right-btn" type="button" class="btn btn-dark btn-lg mt-1">
						<i class="fas fa-arrow-right"></i>
					</button>
					</div>				
					
					<div>
						<button id="stop-btn" type="button" class="btn btn-danger btn-lg mt-1">
							<i class="far fa-stop-circle"></i>
						</button>
					</div>
					
				</div>
			</div>
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