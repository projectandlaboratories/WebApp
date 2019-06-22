<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="it.project.db.DBClass" %>
    <%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
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

</head>
<c:set var="airCondMap" value="<%=DBClass.getAirCondList()%>"/>

<body>
    <h1 class="d-lg-flex align-items-lg-center" style="background-color: rgb(44,62,80);height: 70px;">
    	<a class="btn btn-primary text-center d-lg-flex" href="roomManagement.jsp" style="position:absolute; left: 8px; top: 6px; height: 60px; width: 60px;background-color: rgb(44,62,80);" >
   			<img src="../images/ios-arrow-round-back-white.svg" style="position:absolute; left: 0px; top: 0px; height: 60px; width: 60px;">
   		</a>
        <a class="navbar-brand text-left flex-fill" style="margin-left: 80px;padding-top: 5px;height: auto;font-size: 30px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: 206px;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;">
        	<br>ADD ROOM<br><br></a>
        </h1>
    <div style="width: device-width;position: absolute;bottom:0px;top: 25%;left:25%;right:0px;display: inline-block;vertical-align: middle;flex-direction:column;display:flex;">
        <form action="<%=request.getContextPath()+"/AddRoom"%>" method="POST">
	        <input name="roomName" id="roomName" onkeyup="updateNameFlag()" style="width: 70%;margin-bottom: 2%;height: 50px;">
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
	            	<c:forEach items="${airCondMap}" var="airCondItem">
						<a class="dropdown-item" onclick="changeAPValue('${airCondItem.key}','${airCondItem.value}')" role="presentation">${airCondItem.value}</a>
					</c:forEach>				
	           	</div>
	        </div>
	        
	        <button disabled class="btn btn-primary" type="submit" id="connectButton" style="margin-top: 2%;width:25%;margin-left: 22.5%;">Connect</button>
	   	</form>
    </div>
        
    <script><%@include file="../assets/js/jquery.min.js"%></script> 
    <script><%@include file="../assets/bootstrap/js/bootstrap.min.js"%></script> 
    <script><%@include file="../assets/js/script.min.js"%></script> 
    
    <script type="text/javascript">
	var flagName = false
	var flagModel = false
	var flagAP = false
	
	function updateNameFlag(){
		flagName = document.getElementById("roomName").value== "" ? false : true;
		enableConnect();
	}
	
	function changeModelValue(id,name){
		var buttonModel = document.getElementById("modelDropDown");
		buttonModel.innerText = name;
		document.getElementById("airCondModel").value=id;
		flagModel=true
		enableConnect()
	}
	
	function changeAPValue(id,name){
		var buttonAP = document.getElementById("apDropDown");
		buttonAP.innerText = name
		document.getElementById("apMAC").value=id;
		flagAP=true
		enableConnect()
	}
	
	function enableConnect(){
		if(flagName&&flagModel && flagAP){
			document.getElementById("connectButton").disabled=false;
		}else{
			document.getElementById("connectButton").disabled=true;
		}
	
	}
	
	
	</script>

</body>
</html>