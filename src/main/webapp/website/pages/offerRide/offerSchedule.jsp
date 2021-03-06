<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Offer a Ride - Schedule</title>


<jsp:include page="/website/pages/included/importTop.jsp"></jsp:include>
<link rel="stylesheet" type="text/css"
	href="<c:url value="/website/css/topNav.css"/>" />
<link rel="stylesheet" type="text/css"
	href="<c:url value="/website/css/profileSidebar.css"/>" />
	
<link rel="stylesheet" href="http://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<link href="https://fonts.googleapis.com/css?family=Patua+One" rel="stylesheet">
<link rel="stylesheet" href="<c:url value="/website/css/findoffer/offermap.css"/>">


<style>


</style>

</head>
<body class="animsition">
	<jsp:include page="/website/pages/included/sideBarEffectTop.jsp"></jsp:include>
	<c:if test="${!empty sessionScope.memberInfo}">
		<jsp:include page="/website/pages/included/headerLoginOk.jsp"></jsp:include>
	</c:if>
	<c:if test="${empty sessionScope.memberInfo}">
		<jsp:include page="/website/pages/included/headerLoginFail.jsp"></jsp:include>
	</c:if>
	
<div class="container">
	<div class="all-33">
		<div id="header">
			<div id="headertitle">
				Offer a Ride on Your Travels
			</div>
		</div>
		<div id="resulterror">
			<c:choose>
			<c:when test="${not empty errors}">
				${errors.msg}
			</c:when>
			<c:otherwise>
				Schedule your Offer
			</c:otherwise>
			</c:choose>
		</div>
	
		<hr class="major" />
		<form action="<c:url value='/offerRide/offerSchedule.controller' />" method="POST"
			name="OfferRideForm">
		<div id="col1">
			<div class="autocomplete">
				<span class="field">Enter the point of origin</span>
				<input type="text" name="start" id="start" placeholder="Leaving From..."
					autocomplete="off"></input> <select name="pickUpZone" id="pickUpZone">
					<option>district</option>
				</select>
				<div></div>
			</div>
			<br><br><br><br>
			
			<div class="autocomplete">	
				<span class="field">Enter the destination area</span>
				<input type="text" name="dest" id="dest" placeholder="Going to..."
					autocomplete="off"></input> <select name="dropOffZone" id="dropOffZone">
					<option>district</option>
				</select>
				<div></div>
			</div>
			<br><br><br><br>
			
			<div class="autocomplete">
				<span class="field">Enter the departure time</span><br>
				<input type="text" id="datepicker" name="rideDate" placeholder="Departure date..."
						autocomplete="off"></input>
				<select id="pickHour" name="hour"></select>
				<select id="pickMinute" name="minute"></select>
			</div>
		</div>
			
		<div id="col2">
			<div id="map"></div>
		</div>
			
		<div class="submit">
			<div class="col-lg-2">
				<input type="submit" class="btn" value="Proceed" />
			</div>
		</div>
		</form>

	
	</div>
</div>

<jsp:include page="/website/pages/included/restDiv.jsp"></jsp:include>
	<jsp:include page="/website/pages/included/importBot.jsp"></jsp:include>
	
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<script>
		var map, delayCalc;

		$("input:text").focus(function() { $(this).select(); } );
		
	    function initMap() {
	    	var directionsService = new google.maps.DirectionsService();
	    	var directionsDisplay = new google.maps.DirectionsRenderer();
	    	
	    	var initpos = {lat: 25.032, lng: 121.52};
	    	var map = new google.maps.Map(document.getElementById('map'), {
	    		zoom: 8,
	          	center: initpos,
	          	disableDefaultUI: true
	    	});
	    	directionsDisplay.setMap(map);
	    	delayCalc = function() {
	    		setTimeout(calcHandler, 200);
	    	}
	    	var calcHandler = function() {
	    		calcRoute(directionsService, directionsDisplay);
	        };
	        document.getElementById('start').addEventListener('change', delayCalc);
	        document.getElementById('dest').addEventListener('change', delayCalc);
	        document.getElementById('pickUpZone').addEventListener('change', delayCalc);
	        document.getElementById('dropOffZone').addEventListener('change', delayCalc);
		}
	    
	    function calcRoute(directionsService, directionsDisplay) {
	    	var start = $("#start").val();
	    	var end = $("#dest").val();
	    	var pick = $("#pickUpZone").val();
	    	var drop = $("#dropOffZone").val();
			if (pick != "district") {
	    		start += ", " + pick;
			}
			if (drop != "district") {
	    		end += ", " + drop;
			}
	    	
	    	var request = {
	    		origin: start,
	    		destination: end,
	    		travelMode: 'DRIVING'
	    	};
	    	directionsService.route(request, function(result, status) {
	    		if (status == 'OK') {
	    			directionsDisplay.setDirections(result);
	    		}
	    	});
	    }
		
	    createOptions(24, 1, document.getElementById("pickHour"));
	    createOptions(60, 15, document.getElementById("pickMinute"));
	    function createOptions(max, incr, ele) {
	    	var frag = document.createDocumentFragment();
	    	
	    	for (var i = 0; i < max; i += incr) {
	    		optionEle = document.createElement("option");
	    		optionEle.setAttribute("value", i);
	    		var optionTxt = document.createTextNode(("0" + i).slice(-2));
	    		optionEle.appendChild(optionTxt);
	            
	            frag.appendChild(optionEle);
	    	}
	    	ele.appendChild(frag);
	    }
			
		
	</script>
	<script src="<c:url value="/website/js/autocompletedatev2.js"/>"></script>
	<script>
		var cityArr = [];
		var distArr = [];
		
		$.getJSON("<c:url value="/website/res/LocationData/taiwan_both.json"/>",{},
				function(datas){
			$.each(datas,function(city, districtArr){
				cityArr.push(city);
				distArr.push(districtArr);
			})
		})
	
		autocomplete(document.getElementById("start"), cityArr, distArr);
		autocomplete(document.getElementById("dest"), cityArr, distArr);
	</script>
	
	<script async defer
    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBDeuimzXA3BTt4WxyjtIhXxNIIuVxPHyY&callback=initMap">
    </script>
</body>
</html>