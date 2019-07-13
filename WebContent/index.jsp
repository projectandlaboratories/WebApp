<%@page import="it.project.mqtt.MQTTDbProf"%>
<%@page import="it.project.mqtt.MQTTAppSensori"%>
<%@page import="it.project.utils.*"%>
<%@page import="it.project.enums.*"%>
<%@page import="it.project.db.MQTTDbSync"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.*"%>
<%@page import="it.project.dto.Room"%>
<%@page import="it.project.dto.Program"%>
<%@page import="it.project.dto.Interval"%>

<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="it.project.db.DBClass" %>
    <%@ page import="java.util.Date" %>
    <%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<% //HttpWebService.getAuthenticationToken();
/*System.out.println("1");
System.out.println(HttpWebService.getGroupInfo()+"\n\n");
System.out.println("2");
System.out.println(HttpWebService.getDeviceInfo()+"\n\n");
System.out.println("3");
System.out.println(HttpWebService.getLogs()+"\n\n");*/%>
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
    <style type="text/css"><%@include file="/assets/css/mystyle.css"%></style>
    
      <style type="text/css">
	#load{
	    width:100%;
	    height:100%;
	    position:fixed;
	    z-index:9999;
	    background:url("<%=request.getContextPath() + "/images/loading-icon.gif"%>") no-repeat center center rgba(0,0,0,0.25)
	}
	.hide{
		display:none;
	}
</style>

<style type="text/css">
* {margin: 0; padding: 0;}
#container {height: 100%; width:100%; font-size: 0;}
#left, #middle, #right {display: inline-block; *display: inline; zoom: 1; vertical-align: top; font-size: 12px;}
#left { background: auto; width:50%; text-align:center; padding-top: 12px;}
#middle {background: green;}
#right {background: auto; width:50%;height:100%; text-align:center;padding-top: 12px;border-top-left-radius: 10px; border-left:1px solid #2C3E50; border-top:1px solid #2C3E50; position:absolute; right: 0px; }
</style>

</head>

<% 
	DbIdentifiers user = DbIdentifiers.LOCAL;
	session.setAttribute("user", user.name());
	session.setAttribute("localUser", DbIdentifiers.LOCAL.name());
	session.setAttribute("awsUser", DbIdentifiers.AWS.name());
	
	String logged = "true";
	if(user.equals(DbIdentifiers.AWS)){
		logged = request.getParameter("logged");
		if (logged != null){
			session.setAttribute("logged", "true");
		}
		else{
			logged = (String) session.getAttribute("logged");
			if(logged == null)
				session.setAttribute("logged", "false");
		}
	}
%>
<!--  logged = ${logged}  -->
<c:choose>
	<c:when test="${logged eq false}">
		<jsp:include page="pages/login.jsp"/>
	</c:when>
	<c:otherwise>
			
<%	
	String rootCApath = getServletContext().getRealPath("/Certificates_x509/root-CA.crt");
    String certificatePath = getServletContext().getRealPath("/Certificates_x509/PL-student.cert.pem");
    String privateKeyPath = getServletContext().getRealPath("/Certificates_x509/PL-student.private.key");
    
	//Setup connection e dbSync
	try{
		DBClass.getConnection(user);
		MQTTDbSync.setConnection(user,getServletContext());
		MQTTDbProf.setConnection(user,rootCApath,certificatePath,privateKeyPath);
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
//HttpWebService.updateDeviceInfo(DBClass.getConfigValue("mac"), "PL19-20", "conf");
//System.out.println(HttpWebService.getDeviceInfo());

//HttpWebService.getLogs();
//HttpWebService.updateDeviceInfo("9C-30-5B-D1-16-15", "RP-PL19-20", "conf");

NavigableMap<String,Room> roomMap = (NavigableMap<String,Room>) session.getAttribute("roomMap");

String mainRoomId=DBClass.getMainRoomId();
String currentRoomId = request.getParameter("currentRoom");//(String)session.getAttribute("currentRoomId"); 
if(currentRoomId==null){
	currentRoomId=mainRoomId;
}
session.setAttribute("currentRoomId", currentRoomId);	

String nextKey = roomMap.higherKey(currentRoomId);
if(nextKey==null)
	nextKey=roomMap.firstKey();

String prevKey = roomMap.lowerKey(currentRoomId);
if(prevKey==null)
	prevKey=roomMap.lastKey();

Room currentRoom = roomMap.get(currentRoomId);
Date date =  new Date();

DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
dateFormat.setTimeZone(TimeZone.getTimeZone("Europe/Rome"));

String currentMode=currentRoom.getMode().name();
String targetTemp="0";

String act = SystemType.HOT.toString();
if(ProfileUtil.getCurrentSeason().equals(Season.SUMMER)){
	act = SystemType.COLD.toString();
}

if(currentRoom.getMode().equals(Mode.MANUAL)){
	act = currentRoom.getManualSystem().toString();
	targetTemp=Double.toString(currentRoom.getManualTemp());	
}else{
	targetTemp = ProfileUtil.getCurrentTemperature(currentRoom);	
}

int connectionState = DBClass.getConnectionState(currentRoomId);
String alertDiv = "hidden";
String mainDiv = "visible";
if(connectionState==0){
	alertDiv = "visible";
	mainDiv = "hidden";
}
%>


<body onload=initializeParameters()>
	<div id="load" class="hide"></div>
    <div id="wrapper" class="toggled">
        <div id="sidebar-wrapper" style="background-color: #2C3E50;">
            <ul class="sidebar-nav">
                <li class="sidebar-brand" style="height: 70px;"> </li>
                <li> <a class="text-light" href="index.jsp" style="font-size: 20px;">Home</a></li>
                <li> <a class="text-light" href="pages/profileList.jsp" style="font-size: 20px;">Temperature Profiles</a></li>
                <li> <a class="text-light" href="pages/roomManagement.jsp" style="font-size: 20px;">Room Management</a></li>
                <li> <a class="text-light" href="pages/statistics.jsp?chart=1&room=<%=currentRoomId%>" style="font-size: 20px;">Statistics</a></li>
                <c:if test="${user eq localUser}">
                	 <li> <a class="text-light" href="pages/networkSettings.jsp" style="font-size: 20px;">Network</a></li>
                </c:if>
                <c:if test="${user eq awsUser}">
                	 <li> <a class="text-light" href="<%=request.getContextPath()%>/checkLogin?action=logout" style="font-size: 20px;">Logout</a></li>
                </c:if>          
            </ul>
        </div>
        <div>
            <div class="container-fluid" style="height: 70px;padding-right: 0px;padding-left: 0px;">
                <h1 class="d-lg-flex align-items-lg-center" style="background-color: rgb(44,62,80);height: 70px;vertical-align: middle;">
                	<a role="button" id="menu-toggle" href="#menu-toggle" style="height: 70px;">
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

				<div id="alertdiv" class="d-inline-flex flex-column" style="position:absolute;bottom:0px;top: 100px;left:0px;right:0px;width:100%;visibility:<%=alertDiv%>; ">
					
					
						<span style="text-align:center;">
						<img id="alertIcon" src="./images/ios-alert-red.svg" style="height: 25px; width: 25px; padding-bottom: 4px;">
						This room is not connected<br>
						<form action="<%=request.getContextPath()+"/connectToRoom?from=index&roomId="%>${currentRoomId}" method='POST'>	
						<button onclick="showLoadingIcon()" class="btn btn-primary" style="height: 40px;margin-top:20px;">CONNECT</button>
						</form>
						</span>
					
                </div>
                
				<div id="maindiv" class="d-inline-flex flex-column" style="position:absolute; left: 8px; right:70px;visibility:<%=mainDiv%>; ">
                    <!-- Icons -->
                   <div style="height:100%; display: inline-grid">
                    	<img id="hotIcon" style="margin-left:8px; margin-right:8px; margin-top:3%; margin-bottom:5%; height:30px;" src="images/ios-flame-primary.svg">
                    	<img id="coldIcon" style="margin-left:8px; margin-right:8px; margin-top:4%; margin-bottom:5%; height:30px;" src="images/ios-snow-primary.svg">
                    	<img id="antifreezeIcon" style="margin-left:8px; margin-right:8px; margin-top:4%; margin-bottom:4%; height:30px;" src="images/ios-thermometer-not-selected.svg">
                    </div>
                   
                    <div style="position:absolute; width:100%; height:100%; margin-left: 64px;">
               			
             			<div id="left" style="color: #2C3E50;">
             			
             			<span style="font-size:16px; ">Room Temperature</span>
             			<!-- img id="alertIcon" src="./images/ios-alert-red.svg" style="height: 25px; width: 25px; padding-bottom: 4px;"> -->
             			<br>
             			<span id="currentTemp" style="font-size:900%;"></span><br>             			
             			</div>				    	
				    	 
				    	<div id="right" style="color: #2C3E50;" >
					    	<form action="<%=request.getContextPath()+"/UpdateMode"%>" method="POST">
					    	
					    		<span id="targetTempText" style="font-size:16px;margin-right:20%;"></span><br>
					    		<input type="hidden" id="mode" name="mode" value=<%=currentMode%>>   
					    		<input type="hidden" id="targetTemp" name="targetTemp" value=<%=targetTemp%>>  
					    		<input type="hidden" id="act" name="act" value=<%=act%>>
					    		          
					    		<span id="targetTempShown" style="font-size:600%; color: #2C3E50; margin-right:15%; "></span>
					    	
					    		
		                		<div id="manualSection" style="display:none; background-color: auto; width: 50%; margin-left:15%; margin-right: 35%; position:absolute; bottom: 8px; font-size: 60px; border:1px solid #2C3E50;  border-radius: 10px;">
		    						<div style="height: 65px; ">
			    						<button id=<%=SystemType.HOT%> onclick="onHotSystemClick()" class="btn btn-light btn-lg text-center text-primary border-white" type="button" style="font-size: 50px;width: 65px;height: 65px;background-color: white; vertical-align: top; "><img id="hotImage" src="images/ios-flame-primary.svg"></button>
					              		<button id=<%=SystemType.COLD%> onclick="onColdSystemClick()" class="btn btn-light btn-lg text-center text-primary border-white" type="button" style="font-size: 50px;width: 65px;height: 65px;background-color: white; vertical-align: top;"><img id="coldImage" src="images/ios-snow-primary.svg"></button>	
		    						</div>
		    						<button id="saveButton" class="btn btn-primary" type="submit" name="ACTION" value="changeManualProgrammableMode" style="width: 90%; margin-bottom: 4px; margin-top: 4px;">SAVE</button>
				              		
				               	</div>
				             
				             	<button onclick="disableManualMode()" id="manualButton" type="submit" name="ACTION" value="changeManualProgrammableMode"  class="btn btn-light btn-lg text-center text-primary border-white" type="button" style=" position:absolute; bottom: 8px; right:8px;font-size: 50px;width: 70px;height: 70px;background-color: white;"><img src="images/md-hand-primary.svg" ></button>
		                		<button onclick="enableManualMode()" id="programButton" type="submit" name="ACTION" value="changeManualProgrammableMode" class="btn btn-light btn-lg text-center text-primary border-white" type="button" style=" position:absolute; bottom: 8px; right:8px;font-size: 50px;width: 70px;height: 70px;background-color: white;"><img src="images/md-hand-not-selected.svg" ></button>
		                		
					    		 <div class="btn-group btn-group-vertical" role="group" style="right: 8px;position: absolute;width: 65px; top:32px;"><!-- width: 25%; -->
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
                	<button class="btn btn-light text-center bg-light border-light d-lg-flex" onclick="prevPage()" type="button"  style="height: 60px;padding-top: 6px;margin-left: 8px;width: 60px;background-color: rgb(44,62,80);">
                		<img src="images/ios-arrow-round-back-primary.svg" style="height: 60px;padding-top: 2px;margin-left: 8px;width: 60px; position: absolute; bottom: 2px; left: 0px">
                	</button>
                    <a class="navbar-brand text-center text-primary flex-fill" href="pages/roomManagementItem.jsp?roomId=<%=currentRoomId%>" style="margin-right:64px; padding-top: 5px;font-size: 40px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: auto;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;"><%=currentRoom.getRoomName() %></a>
                    <button class="btn btn-primary text-center bg-light border-light d-lg-flex justify-content-lg-center align-items-lg-center" onclick="nextPage()" type="button" style="height: 60px;padding-top: 6px;margin-left: 8px;width: 60px;background-color: rgb(44,62,80);margin-right: 8px;position: absolute;right: 8px;">
                   		<img src="images/ios-arrow-round-forward-primary.svg" style="height: 60px;padding-top: 6px;width: 60px;position: absolute; bottom:2px; right: 0px">
                   	</button>
               </footer>
            </div>
        </div>
    </div>
    
    <script><%@include file="/assets/js/jquery.min.js"%></script> 
    <script><%@include file="/assets/bootstrap/js/bootstrap.min.js"%></script> 
    <script><%@include file="/assets/js/Sidebar-Menu.js"%></script> 
       
    <script type="text/javascript">
    
	function showLoadingIcon(){
		document.getElementById("load").classList.remove("hide")
	}
	
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
    var saveButton = document.getElementById("saveButton");
    var maindiv = document.getElementById("maindiv");
	var alertdiv = document.getElementById("alertdiv");
    var weekendDate; 
    
	var timerID = setInterval(function() {
		setDate();
		setTemperature();
		getActuatorState();
		getAntifreezeState();
		getConnectionState();
		updateWeekendModeIcon();
		getMode();
		if(mode.value=="<%=Mode.PROGRAMMABLE%>"){
			setProfileTemperature();
		}
		
	}, 20 * 1000); 
    

    	function initializeParameters(){
    		weekendDate = formatDate()
    		mode.value="<%=currentMode%>"
   			
    		act.value="<%=act%>"
    	    updateModeButton();
    		if(mode.value=="<%=Mode.MANUAL%>"){
   				saveButton.disabled = true;
   			}
    		getActuatorState();
    		getAntifreezeState();
    		//getConnectionState();
    		updateWeekendModeIcon();
    		setTemperature();
    		targetTemp.value="<%=targetTemp%>"
    		targetTempShown.innerHTML ="<%=targetTemp%>"+ "°"
    		   		
    		console.log(mode.value+" "+targetTemp.value+" "+ act.value);  	
    		
    		setDate();
    		if(mode.value=="<%=Mode.PROGRAMMABLE%>"){
    			setProfileTemperature();
    		}
    	}
    	
    	
    	function onHotSystemClick(){
    		saveButton.disabled = false;
    		act.value="<%=SystemType.HOT%>"
    		//seleziona hot
    		document.getElementById("hotImage").setAttribute('src','images/ios-flame-primary.svg');
    		//deseleziona cold
    		document.getElementById("coldImage").setAttribute('src','images/ios-snow-not-selected.svg');
    		console.log(mode.value+" "+targetTemp.value+" "+ act.value);  	
    	}
    	
    	function onColdSystemClick(){
    		saveButton.disabled = false;
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
    		}else if(mode.value=="<%=Mode.PROGRAMMABLE%>"){
    			disableManualMode();
    		}
    		
    	}
    	
    	function enableManualMode(){
    		console.log("enable Manual!");
    		document.getElementById("manualButton").style.display = "block";
    		document.getElementById("programButton").style.display = "none";
    		
    		//document.getElementById("manualImage").setAttribute('src','images/md-hand-primary.svg');
    		mode.value="<%=Mode.MANUAL%>"
    		increaseButton.disabled = false;
    		decreaseButton.disabled = false;
    		//saveButton.disabled = true;
    		document.getElementById("manualSection").style.display = "block";
    		updateActButtons();
    		saveButton.disabled = true;//perchè i bottoni me lo abilitano
    		document.getElementById("targetTempText").innerHTML="Manual Temperature";
    		//console.log(mode.value+" "+targetTemp.value+" "+ act.value);  	
    	}
    	
    	

    	function disableManualMode(){
    		console.log("Disable Manual!");
    		document.getElementById("manualButton").style.display = "none";
    		document.getElementById("programButton").style.display = "block";
    		
    		//document.getElementById("manualImage").setAttribute('src','images/md-hand-not-selected.svg');
    		mode.value="<%=Mode.PROGRAMMABLE%>"	
    		increaseButton.disabled = true;
    		decreaseButton.disabled = true;
    		document.getElementById("manualSection").style.display = "none";
    		document.getElementById("targetTempText").innerHTML="Profile Temperature";
    		//saveButton.disabled = false;
    		//console.log(mode.value+" "+targetTemp.value+" "+ act.value);  	
    	}
    	
    	function onIncreaseClick(){
    		var currentTemp = parseFloat(targetTemp.value);
    		if(currentTemp>=30.0)
    			return;
    		targetTemp.value=Number(currentTemp + 0.5).toFixed(1);
        	targetTempShown.innerHTML = targetTemp.value+ "°";
        	saveButton.disabled = false;
    	}
    
    	function onDecreaseClick(){
    		var currentTemp = parseFloat(targetTemp.value);
    		if(currentTemp<=18.0){
    			return;
    		}
    		targetTemp.value=Number(currentTemp - 0.5).toFixed(1);
    		targetTempShown.innerHTML = targetTemp.value+ "°";
    		saveButton.disabled = false;
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
						targetTempShown.innerHTML =targetTemp.value+ "°"
				    		
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
							disableManualMode();
							mode.value="<%=Mode.PROGRAMMABLE%>"
							document.getElementById("programButton").disabled=true;	
						}
						else{
							weekendIcon.src = "images/ios-car-white.svg";
							document.getElementById("programButton").disabled=false;
													
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
						alert("HTTP error getActuatorState" + xmlHttpRequest.status + ": " + xmlHttpRequest.statusText);
					}
				}
			};
			xmlHttpRequest.open("POST", "<%=request.getContextPath()%>/getActuatorState?user=<%=user%>&roomId=<%=currentRoom.getRoom()%>", true);
			xmlHttpRequest.setRequestHeader("Content-Type",
					"application/x-www-form-urlencoded");
			xmlHttpRequest.send(null);
		}
		
		function getAntifreezeState(){
			var antifreezeIcon = document.getElementById("antifreezeIcon");
			var xmlHttpRequest = getXMLHttpRequest();
			xmlHttpRequest.onreadystatechange = function() {
				if (xmlHttpRequest.readyState == 4) {
					if (xmlHttpRequest.status == 200) {
						if(xmlHttpRequest.responseText == 'true'){
							antifreezeIcon.src = "images/ios-thermometer-primary.svg";
						}
						else{
							antifreezeIcon.src = "images/ios-thermometer-not-selected.svg";
						}
											
					} else {
						alert("HTTP error GetAntifreezeState" + xmlHttpRequest.status + ": " + xmlHttpRequest.statusText);
					}
				}
			};
			xmlHttpRequest.open("POST", "<%=request.getContextPath()%>/getAntifreezeState?user=<%=user%>", true);
			xmlHttpRequest.setRequestHeader("Content-Type",
					"application/x-www-form-urlencoded");
			xmlHttpRequest.send(null);
		}
		
		function getConnectionState(){
			
			var xmlHttpRequest = getXMLHttpRequest();
			xmlHttpRequest.onreadystatechange = function() {
				if (xmlHttpRequest.readyState == 4) {
					if (xmlHttpRequest.status == 200) {
						//1 connesso, 0 non connesso
						if(xmlHttpRequest.responseText == '1'){
							maindiv.style.visibility="visible";
							alertdiv.style.visibility="hidden";
						}
						else{
							alertdiv.style.visibility="visible";
							maindiv.style.visibility="hidden";
							//antifreezeIcon.style.visibility="inherit";
						}
											
					} else {
						alert("HTTP error getConnectionState" + xmlHttpRequest.status + ": " + xmlHttpRequest.statusText);
					}
				}
			};
			xmlHttpRequest.open("POST", "<%=request.getContextPath()%>/getConnectionState?user=<%=user%>&roomId=<%=currentRoom.getRoom()%>", true);
			xmlHttpRequest.setRequestHeader("Content-Type",
					"application/x-www-form-urlencoded");
			xmlHttpRequest.send(null);
		}
		
		
		function getMode() {//TODO attenzione qui se aggiungi mode off
			var xmlHttpRequest = getXMLHttpRequest();
			xmlHttpRequest.onreadystatechange = function() {
				if (xmlHttpRequest.readyState == 4) {
					if (xmlHttpRequest.status == 200) {
						var state = xmlHttpRequest.responseText
						var res = state.split("-")
						
						if(res[0]=="<%=Mode.MANUAL%>"){
							
							if(saveButton.disabled==true||mode.value=="<%=Mode.PROGRAMMABLE%>"){//se sei progr il bottone è abilitato, di default
								mode.value = res[0]
								targetTemp.value=res[1]
								targetTempShown.innerHTML =targetTemp.value+ "°"
								act.value=res[2];
								enableManualMode();
							}
							
			    		}else if(mode.value!="<%=Mode.PROGRAMMABLE%>"){//se ti arriva progr e non sei in progr
			    			mode.value = res[0]
			    			targetTemp.value=res[1]
							targetTempShown.innerHTML =targetTemp.value+ "°"
			    			disableManualMode();
			    		}
						
						console.log("getMode: " + mode.value+" "+targetTemp.value+" "+ act.value);  	
						//updateIcons(xmlHttpRequest.responseText)
					} else {
						alert("HTTP error getMode" + xmlHttpRequest.status + ": " + xmlHttpRequest.statusText);
					}
				}
			};
			xmlHttpRequest.open("POST", "<%=request.getContextPath()%>/GetCurrentRoomMode?user=<%=user%>&roomId=<%=currentRoom.getRoom()%>", true);
			xmlHttpRequest.setRequestHeader("Content-Type",
					"application/x-www-form-urlencoded");
			xmlHttpRequest.send(null);
		}
		function formatDate() {
		    var d = new Date();
		    var month = '' + (d.getMonth() + 1),
		        day = '' + d.getDate(),
		        year = d.getFullYear(),
		    	hour=d.getHours(),
		    	min=d.getMinutes();

		    if (month<10) month = '0' + month;
		    if (day<10) day = '0' + day;
		    if (hour<10 ) hour = '0'+ hour;
		    if (min<10 ) min = '0'+ min;
		    //SimpleDateFormat("yyyy-MM-dd'T'HH:mm")

		    return year+"-"+ month +"-" + day+"T"+hour+":"+min 
		}
		function setWeekendModePopupHtml(endTime){
			
			if(endTime != ""){
				var inputDisable = "disabled"
				var submitBtnText = "Stop weekend mode"
				var submitValueText = "removeWeekendMode"
			    var popupText = "YOU ARE IN WEEKEND MODE UNTIL"
			    weekendDate = endTime
			}
			else{
				var inputDisable = ""
				var submitBtnText = "Save changes"
				var submitValueText = "setWeekendMode"
				var popupText = "WHEN WILL YOU COME BACK?"
				//weekendDate = formatDate()
				//"<!--%=dateFormat.format(date)%>"
				if(document.getElementById("exampleModalCenter").style.display!="block"){
					weekendDate = formatDate()
					console.log("nuova Date "+weekendDate)	
				}else{
					console.log("vecchia Date "+weekendDate)	
				}
				
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
							"<input type='datetime-local' name='date'" + inputDisable + " value='" + weekendDate + "' style='width: 70%; margin-bottom: 2%; height: 60px; margin-left: 15%; text-align: center;''></input>" +		
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
		
		function nextPage(){
			window.open("./index.jsp?currentRoom=<%=nextKey%>","_self")
		}

		function prevPage(){
			window.open("./index.jsp?currentRoom=<%=prevKey%>","_self")
		}

    	//clearInterval(timerID); // The setInterval it cleared and doesn't run anymore.
    	
    </script>
    <!-- <script src="assets/js/jquery.min.js"></script>
    <script src="assets/bootstrap/js/bootstrap.min.js"></script>
    <script src="assets/js/Sidebar-Menu.js"></script> -->
</body>

	</c:otherwise>
</c:choose>
</html>