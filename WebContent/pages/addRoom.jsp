<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="it.project.db.DBClass" %>
     <%@ page import="it.project.dto.Room" %>
    <%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
     <%@ page import="java.util.*" %>
     <%@ page import="java.io.*" %>
<!DOCTYPE html>

<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">  
<title>Add Room</title>

    <style type="text/css"><%@include file="../assets/bootstrap/css/bootstrap.min.css"%></style>
    <style type="text/css"><%@include file="../assets/fonts/font-awesome.min.css"%></style>
    <style type="text/css"><%@include file="../assets/fonts/ionicons.min.css"%></style>
    <style type="text/css"><%@include file="../assets/css/styles.css"%></style>
            <!-- per la keyboard virtuale -->
     <style type="text/css"><%@include file="../assets/css/keyboard.css"%></style>
     <style type="text/css"><%@include file="../assets/css/jquery-ui.min.css"%></style>

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
</head>

<%
		Set<String> ssidList = new HashSet<>();
		Process listSsid = new ProcessBuilder("/bin/bash", getServletContext().getRealPath("/bash/list_ssid.sh"))
				.redirectErrorStream(true).start();
		String line;
		BufferedReader input = new BufferedReader(new InputStreamReader(listSsid.getInputStream()));
		Map<String,Room> rooms = DBClass.getRooms();
		//System.out.println("Add room called!");
		while ((line = input.readLine()) != null) {
			//System.out.println("Line=" + line);
			String[] fields = line.split(":");
			if(fields.length > 1){
				String ssidName = fields[1];
				for(int i=2;i<fields.length; i++){
					ssidName = ssidName + ":" + fields[i];
				}	
				ssidName = ssidName.replace("\"", "");
				//System.out.println("SSID name=" + ssidName);
				if (!ssidName.equals("") && ssidName.startsWith("ESP-")){
					String roomId = ssidName.split("-")[1];
					if(!rooms.containsKey(roomId)){
						//System.out.println("SSID name=" + ssidName + " added to the list");
						ssidList.add(ssidName);
					}
						
				}
			}
			
			System.out.println("");
		}
		input.close(); 
%>
	
<c:set var="errorCode" value="${param.error}"/>	
<c:set var="ssidConnected" value="${param.ssidConnected}"/>	
<c:set var="airCondMap" value="<%=DBClass.getAirCondList()%>"/>

<body>
	<div id="load" class="hide"></div>
    <h1 class="d-lg-flex align-items-lg-center" style="background-color: rgb(44,62,80);height: 70px;">
    	<a class="btn btn-primary text-center d-lg-flex" href="roomManagement.jsp" style="position:absolute; left: 8px; top: 6px; height: 60px; width: 60px;background-color: rgb(44,62,80);" >
   			<img src="../images/ios-arrow-round-back-white.svg" style="position:absolute; left: 0px; top: 0px; height: 60px; width: 60px;">
   		</a>
        <a class="navbar-brand text-left flex-fill" style="margin-left: 80px;padding-top: 5px;height: auto;font-size: 30px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: 206px;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;">
        	<br>ADD ROOM<br><br></a>
        </h1>
    <div style="width: device-width;position: absolute;bottom:0px;top: 25%;left:25%;right:0px;display: inline-block;vertical-align: middle;flex-direction:column;display:flex;">
        <form action="<%=request.getContextPath()+"/AddRoom"%>" method="POST">
	        <input class="keyboard" name="roomName" id="roomName" onkeyup="updateNameFlag()" style="width: 70%;margin-bottom: 2%;height: 50px;background-color:white;color:black;">
	        <input name="airCondModel" id="airCondModel" style="display: none">
	        <input name="apMAC" id="apMAC" style="display: none">
	        
	        <div class="dropdown" style="width: 70%;margin-bottom: 2%;height: 50px;">
	        	<button class="btn btn-primary dropdown-toggle d-md-flex justify-content-md-end" type="button" id="modelDropDown"
										data-toggle="dropdown" aria-expanded="false" style="width: 100%;height: 100%;">Select air-conditioning model</button>
	            <div class="dropdown-menu" role="menu" style="width: 100%;"><%//TODO capire come prenderlo in input %>
	            	<c:forEach items="${airCondMap}" var="airCondItem">
						<a class="dropdown-item" onclick="changeModelValue('${airCondItem.key}','${airCondItem.value}')" role="presentation">${airCondItem.value}</a>
					</c:forEach>				
	           	</div>
	        </div>
	        
	        <div class="dropdown" style="width: 70%;margin-bottom: 2%;height: 50px;">
	        	<button class="btn btn-primary dropdown-toggle d-md-flex justify-content-md-end" type="button" id="apDropDown"
										data-toggle="dropdown" aria-expanded="false" style="width: 100%;height: 100%;">Associate Device</button>
	            <div class="dropdown-menu" role="menu" style="width: 100%;"><%//TODO capire come prenderlo in input %>
	            	<c:forEach items="<%=ssidList%>" var="ssidItem">
						<a class="dropdown-item" onclick="changeAPValue('${ssidItem}')" role="presentation">${ssidItem}</a>
					</c:forEach>				
	           	</div>
	        </div>
	        
	        <button class="btn btn-primary" onclick="showLoadingIcon()" type="submit" id="connectButton" style="margin-top: 2%;width:25%;margin-left: 22.5%;">Connect</button>
	        
	        <c:if test="${errorCode eq 2}">
	        	<h6 style="color:red;margin-top:1%;margin-left:19%;">An error has occurred: room name already exists</h6>
	        </c:if>
	        <c:if test="${errorCode eq 1}">
	        	<h6 style="color:red;margin-top:1%;margin-left:19%;">An error has occurred: room name can't be an empty string</h6>
	        </c:if>	   	        
	   	</form>
    </div>
        
    <script><%@include file="../assets/js/jquery.min.js"%></script> 
    <script><%@include file="../assets/bootstrap/js/bootstrap.min.js"%></script> 
    <script><%@include file="../assets/js/script.min.js"%></script> 
    
    <script type="text/javascript">
	var flagName = true //cosi dovrebbe essere abilitato, ma lascia creare stanze con nome vuoto
	var flagModel = false
	var flagAP = false
	
	function showLoadingIcon(){
		document.getElementById("load").classList.remove("hide")
	}
	
	/*function updateNameFlag(){
		flagName = document.getElementById("roomName").value== "" ? false : true;
		enableConnect();
	}*/
	
	function changeModelValue(id,name){
		var buttonModel = document.getElementById("modelDropDown");
		buttonModel.innerText = name;
		document.getElementById("airCondModel").value=id;
		flagModel=true
		enableConnect()
	}
	
	function changeAPValue(name){
		var buttonAP = document.getElementById("apDropDown");
		buttonAP.innerText = name
		document.getElementById("apMAC").value=name;
		flagAP=true
		enableConnect()
	}
	
	function enableConnect(){
		if(flagName && flagModel && flagAP){
			document.getElementById("connectButton").disabled=false;
		}else{
			document.getElementById("connectButton").disabled=true;
		}
	
	}
	
	
	</script>
	
	   <!-- per la keyboard virtuale -->
    <script><%@include file="../assets/js/jquery.mousewheel.js"%></script> 
    <script><%@include file="../assets/js/jquery.keyboard.js"%></script>
    <script><%@include file="../assets/js/jquery-ui-custom.min.js"%></script>  
    
    <c:if test="${user eq localUser}">
	    <script>
			$(function(){
				$('.keyboard').keyboard();
			});
		</script>
    </c:if>

</body>
</html>