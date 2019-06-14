<%@page import="it.project.enums.Mode"%>
<%@page import="it.project.enums.SystemType"%>
<%@page import="it.project.db.MQTTDbSync"%>
<%@page import="it.project.utils.DbIdentifiers"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="it.project.db.DBClass" %>
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
#right {background: auto; position:absolute; right: 0px;width:50%;height:100%; text-align:center;}
</style>

</head>

<% 
	//Setup connection e dbSync
	try{
		DBClass.getConnection(DbIdentifiers.LOCAL);
		MQTTDbSync.setConnection(DbIdentifiers.LOCAL);
	}
	catch(Exception e){
%>
<h5>Exception : <%=e.getMessage()%></h5>
<% 
	}
%>
<%
String mode=Mode.MANUAL.toString();
String targetTemp="17.5";
String act = SystemType.HOT.toString();

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
                	<a class="navbar-brand text-left flex-fill" href="#" style="margin-left: 16px;padding-top: 5px;height: auto;margin-top: 0px;margin-bottom: 0px;min-width: auto;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;font-size: 30px;">Tue March 24, 2019, 22.36</a>
                    <button class="btn btn-primary text-center d-lg-flex justify-content-lg-center align-items-lg-center" type="button" style="height: 70px;margin-left: 8px;width: 60px;background-color: rgb(44,62,80);margin-right: 8px;position: absolute;right: 2px; top: 0px; ">
                        	<img src="images/ios-car-white.svg"  style="width:100%;" ></img>
                     </button> 
                </h1>
                
                <div class="d-inline-flex flex-column" style="position:absolute; left: 8px; right:70px ">
                    <div style="height:100%; display: inline-grid">
                    	<img style="margin-left:8px; margin-right:8px; margin-top:12px; margin-bottom:16px; height:30px;" src="images/ios-flame-primary.svg">
                    	<img style="margin-left:8px; margin-right:8px; margin-top:12px; margin-bottom:16px; height:30px;" src="images/ios-snow-primary.svg">
                    	<img style="margin-left:8px; margin-right:8px; margin-top:12px; margin-bottom:16px; height:30px;" src="images/ios-thermometer-primary.svg">
                    	<img style="margin-left:8px; margin-right:8px; margin-top:12px; margin-bottom:16px; height:30px;" src="images/ios-flower-primary.svg">
                    </div>
                    <!-- div id="container">
					    <div id="left">Left Side Menu</div>
					    <div id="middle">Random Content</div>
					    <div id="right">Right Side Menu</div>
					</div>  -->
                    <div style="position:absolute; width:100%; height:100%; margin-left: 64px;">
               			<div id="left" style="font-size:900%; color: #2C3E50;">21.5</div>
               			<!--  div id="middle">Random Content</div>-->
				    	
				    	 
				    	<div id="right">
					    	<form action="<%=request.getContextPath()+"/newProgramServlet"%>" method="POST">
					    	
					    		
					    		<input type="hidden" name="mode" value=<%=mode%>>   
					    		<input type="hidden" name="targetTemp" value=<%=targetTemp%>>  
					    		<input type="hidden" name="act" value=<%=act%>>
					    		          
					    		<span id="targetTempShown" style="font-size:600%; color: #2C3E50; position:absolute; right: 100px; top:25px;"></span>
					    	
						    	<div style="position:absolute; bottom: 0px; right:0px; height: 80px;font-size: 60px;">
				              		<button disabled id=<%=SystemType.HOT%> onclick="onHotSystemClick()" class="btn btn-light btn-lg text-center text-primary border-white" type="button" style="font-size: 50px;width: 65px;height: 65px;background-color: white;"><img id="hotImage" src="images/ios-flame-primary.svg"></button>
				              		<button id=<%=SystemType.COLD%> onclick="onColdSystemClick()" class="btn btn-light btn-lg text-center text-primary border-white" type="button" style="font-size: 50px;width: 65px;height: 65px;background-color: white;"><img id="coldImage" src="images/ios-snow-primary.svg"></button>
				              		<button onclick="onModeClick()" class="btn btn-light btn-lg text-center text-primary border-white" type="button" style="font-size: 50px;width: 65px;height: 65px;background-color: white;"><img id="manualImage" src="images/md-hand-primary.svg" ></button>
		                			<button type="submit" name="action" value="changeManualProgrammableMode" class="btn btn-light btn-lg text-center text-primary border-white" type="button" style="font-size: 50px;width: 65px;height: 65px;background-color: white;"><img src="images/ios-checkmark-primary.svg"></button>
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
    var mode = document.getElementsByName("mode");
    var targetTemp = document.getElementsByName("targetTemp");
    var act = document.getElementsByName("act");
    
    	//ok
    	function initializeParameters(){
    		mode.value="<%=mode%>"
    		updateModeButton();
    		
    		targetTemp.value="<%=targetTemp%>"
    		targetTempShown.innerHTML ="<%=targetTemp%>"
    		
    		act.value="<%=act%>"
    		updateActButtons();
    		
    		console.log(mode.value+" "+targetTemp.value+" "+ act.value);  		
    		
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
    		//cambia colore alla manina
    		increaseButton.disabled = false;
    		decreaseButton.disabled = false;
    		hotSystemButton.removeAttribute("disabled");
    		coldSystemButton.removeAttribute("disabled");
    		updateActButtons();
    		console.log(mode.value+" "+targetTemp.value+" "+ act.value);  	
    	}
    	
    	

    	function disableManualMode(){
    		console.log("Disable Manual!");
    		document.getElementById("manualImage").setAttribute('src','images/md-hand-not-selected.svg');
    		mode.value="<%=Mode.PROGRAMMABLE%>"
    		//cambia colore alla manina		
    		increaseButton.disabled = true;
    		decreaseButton.disabled = true;
    		hotSystemButton.setAttribute("disabled","disabled");
    		coldSystemButton.setAttribute("disabled","disabled");
    		console.log(mode.value+" "+targetTemp.value+" "+ act.value);  	
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
    </script>
    <!-- <script src="assets/js/jquery.min.js"></script>
    <script src="assets/bootstrap/js/bootstrap.min.js"></script>
    <script src="assets/js/Sidebar-Menu.js"></script> -->
</body>

</html>