<%@page import="it.project.mqtt.MQTTAppSensori"%>
<%@page import="it.project.utils.ProfileUtil"%>
<%@page import="it.project.enums.*"%>
<%@page import="it.project.db.MQTTDbSync"%>
<%@page import="it.project.utils.DbIdentifiers"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.*"%>
<%@page import="it.project.dto.Room"%>
<%@page import="it.project.dto.Program"%>
<%@page import="it.project.dto.Interval"%>
    <%@page import="java.util.Date"%>
    <%@page import="java.text.DateFormat"%>
    <%@page import="java.text.SimpleDateFormat"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="it.project.db.DBClass" %>
    <%@ page import="java.util.Date" %>
    <%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title>Home</title>
    
    <style type="text/css"><%@include file="/assets/bootstrap/css/bootstrap.min.css"%></style>
    <style type="text/css"><%@include file="/assets/fonts/font-awesome.min.css"%></style>
    <style type="text/css"><%@include file="/assets/fonts/ionicons.min.css"%></style>
    <style type="text/css"><%@include file="/assets/css/Sidebar-Menu-1.css"%></style>
    <style type="text/css"><%@include file="/assets/css/Sidebar-Menu.css"%></style>
    <style type="text/css"><%@include file="/assets/css/styles.css"%></style>

<style type="text/css">
* {margin: 0; padding: 0;}
#container {height: 100%; width:100%; font-size: 0;}
#left, #middle, #right {display: inline-block; *display: inline; zoom: 1; vertical-align: top; font-size: 12px;}
#left { background: auto; width:50%; text-align:center;}
#middle {background: green;}
#right {background: auto; border-left:1px solid black; border-top:1px solid black; position:absolute; right: 0px;width:50%;height:100%; text-align:center;}
</style>

</head>

<% 
	DbIdentifiers user = DbIdentifiers.LOCAL;
	//Setup connection e dbSync
	try{
		DBClass.getConnection(user);
		MQTTDbSync.setConnection(user);
		MQTTAppSensori.setConnection(user); //TODO decommentare quando testeremo mqtt con AppSensori
	}
	catch(Exception e){
%>
<h5>Exception : <%=e.getMessage()%></h5>
<% 
	}
%>
<c:set var="roomMap" scope="session" value="<%=DBClass.getRooms()%>"/>
<%
Map<String,Room> roomMap = (Map<String,Room>) session.getAttribute("roomMap");
String currentRoomId = "id1";  //TODO prendere da DB
session.setAttribute("currentRoomId", currentRoomId);
Room currentRoom = roomMap.get(currentRoomId);
Date date =  new Date();
Season season;
DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");


String mode=currentRoom.getMode().toString();
String targetTemp="0";
String act;
if(currentRoom.getMode().equals(Mode.MANUAL)){	
	targetTemp=Double.toString(currentRoom.getManualTemp());	
	act = SystemType.HOT.toString();
}else{
	targetTemp = ProfileUtil.getCurrentTemperature(currentRoom);	
	act = SystemType.HOT.toString(); //non è visualizzato
}

%>


<body onload=initializeParameters()>
    <div id="wrapper">
        <div id="sidebar-wrapper" style="background-color: #2C3E50;">
            <ul class="sidebar-nav">
                <li class="sidebar-brand" style="height: 70px;"> </li>
                <li> <a class="text-light" href="index.jsp" style="font-size: 20px;">Home</a></li>
                <li> <a class="text-light" href="pages/profileList.jsp" style="font-size: 20px;">Temperature Profile</a></li>
                <li> <a class="text-light" href="pages/roomManagement.jsp" style="font-size: 20px;">Room Management</a></li>
                <li> <a class="text-light" href="pages/networkSettings.jsp" style="font-size: 20px;">Network</a></li>
            </ul>
        </div>
        <div>
            <div class="container-fluid" style="height: 70px;padding-right: 0px;padding-left: 0px;">
                <h1 class="d-lg-flex align-items-lg-center" style="background-color: rgb(44,62,80);height: 70px;vertical-align: middle;">
                	<a class="btn btn-link d-xl-flex align-items-xl-center" role="button" id="menu-toggle" href="#menu-toggle" style="height: 70px;">
                		<img src="images/md-reorder-white.svg" style="height: 100%;"></a>
                	<a class="navbar-brand text-left flex-fill" id="date" style="margin-left: 16px;padding-top: 5px;height: auto;margin-top: 0px;margin-bottom: 0px;min-width: auto;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;font-size: 30px;"></a>
                    <button class="btn btn-primary text-center d-lg-flex justify-content-lg-center align-items-lg-center" data-toggle="modal" type="button" data-target="#exampleModalCenter" style="height: 70px;margin-left: 8px;width: 60px;background-color: rgb(44,62,80);margin-right: 8px;position: absolute;right: 2px; top: 0px; ">
                        	<img id="weekendIcon" src="images/ios-car-white.svg"  style="width:100%;" ></img>
                     </button> 
                </h1>

        
                <!-- Weekend mode Popup -->
				<div class="modal fade" id="exampleModalCenter" tabindex="-1"
					role="dialog" aria-labelledby="exampleModalCenterTitle"
					aria-hidden="true">
					
				</div>

				<div class="d-inline-flex flex-column" style="position:absolute; left: 8px; right:70px ">
                   
                   <div style="height:100%; display: inline-grid">
                    	<img id="hotIcon" style="margin-left:8px; margin-right:8px; margin-top:12px; margin-bottom:16px; height:30px;" src="images/ios-flame-primary.svg">
                    	<img id="coldIcon" style="margin-left:8px; margin-right:8px; margin-top:12px; margin-bottom:16px; height:30px;" src="images/ios-snow-primary.svg">
                    	<img id="antifreezeIcon" style="margin-left:8px; margin-right:8px; margin-top:12px; margin-bottom:16px; height:30px;" src="images/ios-thermometer-not-selected.svg">
                    	<img id="fanIcon" style="margin-left:8px; margin-right:8px; margin-top:12px; margin-bottom:16px; height:30px;" src="images/ios-flower-not-selected.svg">
                    </div>
                   
                    <div style="position:absolute; width:100%; height:100%; margin-left: 64px;">
               			
             			<div id="left" style="font-size:900%; color: #2C3E50;"><span id="currentTemp"></span></div>				    	
				    	 
				    	<div id="right">
					    	<form action="<%=request.getContextPath()+"/UpdateMode"%>" method="POST">
					    	
					    		
					    		<input type="hidden" id="mode" name="mode" value=<%=mode%>>   
					    		<input type="hidden" id="targetTemp" name="targetTemp" value=<%=targetTemp%>>  
					    		<input type="hidden" id="act" name="act" value=<%=act%>>
					    		          
					    		<span id="targetTempShown" style="font-size:600%; color: #2C3E50; position:absolute; right: 100px; top:25px;"></span>
					    	
						    	<div style="position:absolute; bottom: 0px; right:0px; height: 80px;font-size: 60px;">
				              		<button id=<%=SystemType.HOT%> onclick="onHotSystemClick()" class="btn btn-light btn-lg text-center text-primary border-white" type="button" style="font-size: 50px;width: 65px;height: 65px;background-color: white; "><img id="hotImage" src="images/ios-flame-primary.svg"></button>
				              		<button id=<%=SystemType.COLD%> onclick="onColdSystemClick()" class="btn btn-light btn-lg text-center text-primary border-white" type="button" style="font-size: 50px;width: 65px;height: 65px;background-color: white;"><img id="coldImage" src="images/ios-snow-primary.svg"></button>
				              		<button onclick="onModeClick()" class="btn btn-light btn-lg text-center text-primary border-white" type="button" style="font-size: 50px;width: 65px;height: 65px;background-color: white;"><img id="manualImage" src="images/md-hand-primary.svg" ></button>
		                			<button type="submit" name="ACTION" value="changeManualProgrammableMode" class="btn btn-light btn-lg text-center text-primary border-white" type="button" style="font-size: 50px;width: 65px;height: 65px;background-color: white;"><img src="images/ios-checkmark-primary.svg"></button>
		                		</div>
					    		
					    		 <div class="btn-group btn-group-vertical" role="group" style="right: 8px;position: absolute;width: 65px; top:10px;">
				                    <button id="increase" onclick="onIncreaseClick()" class="btn btn-primary" type="button" style="margin-bottom: 16px;align-self: end;padding-right: 8px;padding-left: 8px;">
				                    	<img src="images/ios-add-white.svg" ></img>
				                    </button>
				                   	<button id="decrease" onclick="onDecreaseClick()" class="btn btn-primary" type="button" style="padding-right: 8px;padding-left: 8px;">
				                   		<img src="images/ios-remove-white.svg" ></img></button>
				                 </div> 
			                 </form>
					    </div>
						   
               		</div>  
                    
                    
                    
                </div>

               <footer class="d-flex d-md-flex d-lg-flex align-items-center align-items-md-center align-items-lg-center" style="height: 60px; background-color: #ecf0f1;vertical-align: middle;">
                	<button class="btn btn-light text-center bg-light border-light d-lg-flex" type="button" style="height: 60px;padding-top: 6px;margin-left: 8px;width: 60px;background-color: rgb(44,62,80);">
                		<!-- i class="icon ion-android-arrow-back d-lg-flex justify-content-lg-center align-items-lg-center" style="font-size: 47px;width: auto;height: auto;font-family: Roboto, sans-serif;color: #2C3E50;"></i> -->
                		<img src="images/ios-arrow-round-back-primary.svg"  style="height: 60px;padding-top: 2px;margin-left: 8px;width: 60px; position: absolute; bottom: 2px; left: 0px">
                		</button>
                    <a
                        class="navbar-brand text-center text-primary flex-fill" href="#" style="margin-right:64px; padding-top: 5px;font-size: 40px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: auto;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;">HALL</a>
                        <button class="btn btn-primary text-center bg-light border-light d-lg-flex justify-content-lg-center align-items-lg-center" type="button" style="height: 60px;padding-top: 6px;margin-left: 8px;width: 60px;background-color: rgb(44,62,80);margin-right: 8px;position: absolute;right: 8px;">
                        <img src="images/ios-arrow-round-forward-primary.svg"  style="height: 60px;padding-top: 6px;width: 60px;position: absolute; bottom:2px; right: 0px">
                        </button></footer>
            </div>
        </div>
    </div>
    
    <script><%@include file="/assets/js/jquery.min.js"%></script> 
    <script><%@include file="/assets/bootstrap/js/bootstrap.min.js"%></script> 
    <script><%@include file="/assets/js/Sidebar-Menu.js"%></script> 
       
    <script type="text/javascript">
    
    var hotSystemButton = document.getElementById("<%=SystemType.HOT%>");
    var coldSystemButton = document.getElementById("<%=SystemType.COLD%>");
    var increaseButton = document.getElementById("increase");
    var decreaseButton = document.getElementById("decrease");
    var targetTempShown = document.getElementById("targetTempShown");
    //inizializzale in qualche modo, in una funzione eseguita al caricamento della pagina
    var mode = document.getElementById("mode");
    var targetTemp = document.getElementById("targetTemp");
    var currentTemp = document.getElementById("currentTemp");
    var act = document.getElementById("act");
	var timerID = setInterval(function() {
		setDate();
		setTemperature();
		getActuatorState();
		updateWeekendModeIcon();
		if(mode.value=="<%=Mode.PROGRAMMABLE%>"){
			setProfileTemperature();
		}
		
	}, 20 * 1000); 
    

    	function initializeParameters(){
    		mode.value="<%=mode%>"
    		act.value="<%=act%>"
    	    updateModeButton();
    		getActuatorState();
    		updateWeekendModeIcon();
    		setTemperature();
    		targetTemp.value="<%=targetTemp%>"
    		targetTempShown.innerHTML ="<%=targetTemp%>"
    		   		
    		console.log(mode.value+" "+targetTemp.value+" "+ act.value);  		
    		
    		setDate();
    		if(mode.value=="<%=Mode.PROGRAMMABLE%>"){
    			setProfileTemperature();
    		}
    	}
    	
    	
    	function onHotSystemClick(){
    		act.value="<%=SystemType.HOT%>"
    		//seleziona hot
    		document.getElementById("hotImage").setAttribute('src','images/ios-flame-primary.svg');
    		//deseleziona cold
    		document.getElementById("coldImage").setAttribute('src','images/ios-snow-not-selected.svg');
    		console.log(mode.value+" "+targetTemp.value+" "+ act.value);  	
    	}
    	
    	function onColdSystemClick(){
    		act.value="<%=SystemType.COLD%>"
    		//seleziona cold
    		document.getElementById("coldImage").setAttribute('src','images/ios-snow-primary.svg');
    		//deseleziona hot
    		document.getElementById("hotImage").setAttribute('src','images/ios-flame-not-selected.svg');
    		console.log(mode.value+" "+targetTemp.value+" "+ act.value);  	
    	}
    	
    	function updateActButtons(){
    		if(act.value=="<%=SystemType.HOT%>"){
    			onHotSystemClick();
    		}else{
    			onColdSystemClick();
    		}
    	}

    	function updateModeButton(){
    		if(mode.value=="<%=Mode.MANUAL%>"){
    			enableManualMode();
    		}else{
    			disableManualMode();
    		}
    	}
    	
    	function enableManualMode(){
    		console.log("enable Manual!");
    		document.getElementById("manualImage").setAttribute('src','images/md-hand-primary.svg');
    		mode.value="<%=Mode.MANUAL%>"
    		increaseButton.disabled = false;
    		decreaseButton.disabled = false;
    		hotSystemButton.style.display = "-webkit-inline-box";
    		coldSystemButton.style.display = "-webkit-inline-box";  
    		updateActButtons();
    		//console.log(mode.value+" "+targetTemp.value+" "+ act.value);  	
    	}
    	
    	

    	function disableManualMode(){
    		console.log("Disable Manual!");
    		document.getElementById("manualImage").setAttribute('src','images/md-hand-not-selected.svg');
    		mode.value="<%=Mode.PROGRAMMABLE%>"	
    		increaseButton.disabled = true;
    		decreaseButton.disabled = true;
    		hotSystemButton.style.display = "none";
    		coldSystemButton.style.display = "none";   		

    		//console.log(mode.value+" "+targetTemp.value+" "+ act.value);  	
    	}
    	
    	function onModeClick(){
    		if(mode.value=="<%=Mode.MANUAL%>"){
    			disableManualMode();
    		}else{
    			enableManualMode();
    		}
    	}
    	
    	function onIncreaseClick(){
    		var currentTemp = parseFloat(targetTemp.value);
    		if(currentTemp>=26.0)
    			return;
    		targetTemp.value=Number(currentTemp + 0.1).toFixed(1);
        	targetTempShown.innerHTML = targetTemp.value;
    	}
    
    	function onDecreaseClick(){
    		var currentTemp = parseFloat(targetTemp.value);
    		if(currentTemp<=16.0){
    			return;
    		}
    		targetTemp.value=Number(currentTemp - 0.1).toFixed(1);
    		targetTempShown.innerHTML = targetTemp.value;
    	}
    	

    	function setDate(){
    		var options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric', hour:'numeric', minute:'numeric'};
    	    var d = new Date();
    	    var n = d.toLocaleDateString("en-US",options);
    	    document.getElementById("date").innerHTML = n;
    	}
    	
		function setProfileTemperature(){
			var xmlHttpRequest = getXMLHttpRequest();
			xmlHttpRequest.onreadystatechange = function() {
				if (xmlHttpRequest.readyState == 4) {
					if (xmlHttpRequest.status == 200) {
						targetTemp.value= xmlHttpRequest.responseText
						console.log("Aggiorno temperatura"+ targetTemp.value);
						targetTempShown.innerHTML =targetTemp.value
				    		
					} else {
						alert("HTTP error " + xmlHttpRequest.status + ": " + xmlHttpRequest.statusText);
					}
				}
			};
			xmlHttpRequest.open("POST", "<%=request.getContextPath()%>/getCurrentProfileTemperature?user=<%=user%>&roomId=<%=currentRoom.getRoom()%>", true);
			xmlHttpRequest.setRequestHeader("Content-Type",
					"application/x-www-form-urlencoded");
			xmlHttpRequest.send(null);
    	}
		
		function setTemperature(){
			var xmlHttpRequest = getXMLHttpRequest();
			xmlHttpRequest.onreadystatechange = function() {
				if (xmlHttpRequest.readyState == 4) {
					if (xmlHttpRequest.status == 200) {
						currentTemp.innerHTML = xmlHttpRequest.responseText + "°"
					} else {
						alert("HTTP error " + xmlHttpRequest.status + ": " + xmlHttpRequest.statusText);
					}
				}
			};
			xmlHttpRequest.open("POST", "<%=request.getContextPath()%>/getCurrentRoomTemperature?user=<%=user%>&roomId=<%=currentRoom.getRoom()%>", true);
			xmlHttpRequest.setRequestHeader("Content-Type",
					"application/x-www-form-urlencoded");
			xmlHttpRequest.send(null);
			
		}
		
		function updateWeekendModeIcon(){
			var xmlHttpRequest = getXMLHttpRequest();
			xmlHttpRequest.onreadystatechange = function() {
				if (xmlHttpRequest.readyState == 4) {
					if (xmlHttpRequest.status == 200) {
						var weekendIcon = document.getElementById("weekendIcon")
						endTime = xmlHttpRequest.responseText
						setWeekendModePopupHtml(endTime)
						if(endTime != ""){
							weekendIcon.src = "images/ios-car-selected.svg";
						}
						else{
							weekendIcon.src = "images/ios-car-white.svg";
						}
					} else {
						alert("HTTP error " + xmlHttpRequest.status + ": " + xmlHttpRequest.statusText);
					}
				}
			};
			xmlHttpRequest.open("POST", "<%=request.getContextPath()%>/isWeekendMode?user=<%=user%>", true);
			xmlHttpRequest.setRequestHeader("Content-Type",
					"application/x-www-form-urlencoded");
			xmlHttpRequest.send(null);
		}
		
		
		function updateIcons(state){
			
			var hotIcon = document.getElementById("hotIcon")
			var coldIcon = document.getElementById("coldIcon")
			var antifreezeIcon = document.getElementById("antifreezeIcon")
			var fanIcon = document.getElementById("fanIcon")
			
			switch(state){
			case "<%=ActuatorState.HOT%>":
				hotIcon.src = "images/ios-flame-primary.svg";
				coldIcon.src = "images/ios-snow-not-selected.svg";
				break;
			case "<%=ActuatorState.COLD%>":
				hotIcon.src = "images/ios-flame-not-selected.svg";
				coldIcon.src = "images/ios-snow-primary.svg";
				break;
			case "<%=ActuatorState.OFF%>":
				hotIcon.src = "images/ios-flame-not-selected.svg";
				coldIcon.src = "images/ios-snow-not-selected.svg";
				break;
			}
					
		}
		
		function getXMLHttpRequest() {
			var xmlHttpReq = false;
			// to create XMLHttpRequest object in non-Microsoft browsers
			if (window.XMLHttpRequest) {
				xmlHttpReq = new XMLHttpRequest();
			} else if (window.ActiveXObject) {
				try {
					// to create XMLHttpRequest object in later versions
					// of Internet Explorer
					xmlHttpReq = new ActiveXObject("Msxml2.XMLHTTP");
				} catch (exp1) {
					try {
						// to create XMLHttpRequest object in older versions
						// of Internet Explorer
						xmlHttpReq = new ActiveXObject("Microsoft.XMLHTTP");
					} catch (exp2) {
						xmlHttpReq = false;
					}
				}
			}
			return xmlHttpReq;
		}
		/*
		 * AJAX call starts with this function
		 */
		function getActuatorState() {
			var xmlHttpRequest = getXMLHttpRequest();
			xmlHttpRequest.onreadystatechange = function() {
				if (xmlHttpRequest.readyState == 4) {
					if (xmlHttpRequest.status == 200) {
						updateIcons(xmlHttpRequest.responseText)
					} else {
						alert("HTTP error " + xmlHttpRequest.status + ": " + xmlHttpRequest.statusText);
					}
				}
			};
			xmlHttpRequest.open("POST", "<%=request.getContextPath()%>/getActuatorState?user=<%=user%>&roomId=<%=currentRoom.getRoom()%>", true);
			xmlHttpRequest.setRequestHeader("Content-Type",
					"application/x-www-form-urlencoded");
			xmlHttpRequest.send(null);
		}
		
		function setWeekendModePopupHtml(endTime){
			
			if(endTime != ""){
				var inputDisable = "disabled"
				var submitBtnText = "Stop weekend mode"
				var submitValueText = "removeWeekendMode"
			    var popupText = "YOU ARE IN WEEKEND MODE UNTIL"
			    var date = endTime
			}
			else{
				var inputDisable = ""
				var submitBtnText = "Save changes"
				var submitValueText = "setWeekendMode"
				var popupText = "WHEN WILL YOU COME BACK?"
				var date = "<%=dateFormat.format(date)%>"
			}
			
			var formUrl = "<%=request.getContextPath() + "/UpdateMode"%>"
			
			
			document.getElementById("exampleModalCenter").innerHTML = 
			"<div class='modal-dialog modal-dialog-centered' role='document'>" +
			"<div class='modal-content'>" +
				"<div class='modal-header'>" +
					"<h5 class='modal-title' id='exampleModalLongTitle'>" +
						popupText +
					"</h5>" +
					"<button type='button' class='close' data-dismiss='modal' aria-label='Close'> <span aria-hidden='true'>&times;</span> </button>" +
				"</div>" +
				"<form action=' " + formUrl + "' method='POST'>" +
					"<div class='modal-body'>" +
							"<input type='datetime-local' name='date'" + inputDisable + " value='" + date + "' style='width: 70%; margin-bottom: 2%; height: 60px; margin-left: 15%; text-align: center;''></input>" +		
					"</div>" +
					"<div class='modal-footer'>" +
						"<button type='button' class='btn btn-secondary'" +
							"data-dismiss='modal'>Close</button>" +
						"<button type='submit' name='ACTION' value=" + submitValueText + " class='btn btn-primary'> " + submitBtnText + "</button>" +
					"</div>" +
				"</form>" +
			"</div>" +
		"</div>";
		}
	
    	//clearInterval(timerID); // The setInterval it cleared and doesn't run anymore.
    	
    </script>
    <!-- <script src="assets/js/jquery.min.js"></script>
    <script src="assets/bootstrap/js/bootstrap.min.js"></script>
    <script src="assets/js/Sidebar-Menu.js"></script> -->
</body>

</html>