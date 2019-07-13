<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="it.project.db.DBClass" %>
    <%@ page import="java.io.*" %>
    <%@ page import="java.util.*" %>
    <%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<!DOCTYPE html>

<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">  
<title>Network Settings</title>

    <style type="text/css"><%@include file="../assets/bootstrap/css/bootstrap.min.css"%></style>
    <style type="text/css"><%@include file="../assets/fonts/font-awesome.min.css"%></style>
    <style type="text/css"><%@include file="../assets/fonts/ionicons.min.css"%></style>
    <style type="text/css"><%@include file="../assets/css/styles.css"%></style>
    <style type="text/css"><%@include file="../assets/css/mystyle.css"%></style>
        <!-- per la keyboard virtuale -->
     <style type="text/css"><%@include file="../assets/css/keyboard.css"%></style>
     <style type="text/css"><%@include file="../assets/css/jquery-ui.min.css"%></style>
    
<style type="text/css">
	#load{
	    width:100%;
	    height:100%;
	    position:fixed;
	    z-index:9999;
	    background:url("<%=request.getContextPath() + "/images/wifi loading icon.gif"%>") no-repeat center center rgba(0,0,0,0.25)
	}
	.hide{
		display:none;
	}
</style>


</head>

<body>
	<div id="load" class="hide"></div>
	<%
		Set<String> ssidList = new HashSet<>();
		Process listSsid = new ProcessBuilder("/bin/bash", getServletContext().getRealPath("/bash/list_ssid.sh"))
				.redirectErrorStream(true).start();
		String line;
		BufferedReader input = new BufferedReader(new InputStreamReader(listSsid.getInputStream()));
		while ((line = input.readLine()) != null) {
			String ssidName = line.split(":")[1];
			ssidName = ssidName.replace("\"", "");
			if (!ssidName.equals(""))
				ssidList.add(ssidName);
		}
		input.close(); 
		
		String ipAddress = (String) session.getAttribute("ipAddress");
		if(ipAddress == null){
			Process getIpAddress = new ProcessBuilder("/bin/bash", getServletContext().getRealPath("/bash/getBrokerIpAddress.sh"))
					.redirectErrorStream(true).start();
			input = new BufferedReader(new InputStreamReader(getIpAddress.getInputStream()));
			while ((line = input.readLine()) != null) {
				ipAddress = line;
			}
			input.close();
			session.setAttribute("ipAddress", ipAddress);
		}
		
		
	%>
	<c:set var="ssidListString" value=""/>
    <h1 class="d-lg-flex align-items-lg-center" style="background-color: rgb(44,62,80);height: 70px;">
    	<a class="btn btn-primary text-center d-lg-flex" href="../index.jsp" style="position:absolute; left: 8px; top: 6px; height: 60px; width: 60px;background-color: rgb(44,62,80);" >
   			<img src="../images/ios-arrow-round-back-white.svg" style="position:absolute; left: 0px; top: 0px; height: 60px; width: 60px;">
   		</a>
        <a class="navbar-brand text-left flex-fill" style="margin-left: 80px;padding-top: 5px;height: auto;font-size: 30px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: 206px;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;">
        	<br>NETWORK SETTINGS<br><br></a>
        </h1>
    <div style="width: device-width;position: absolute;bottom:0px;top: 40%;left:25%;right:0px;display: inline-block;vertical-align: middle;flex-direction:column;display:flex;">
        
	        <div class="dropdown" style="width: 70%;margin-bottom: 2%;height: 60px;">
	        	<button id="SsidDropDown" class="btn btn-primary dropdown-toggle d-md-flex justify-content-md-end" data-toggle="dropdown" aria-expanded="false" type="button" style="width: 100%;height: 100%;">Available networks</button>
	            <div class="dropdown-menu" role="menu" style="width: 100%;">
	            	<c:forEach items="<%=ssidList%>" var="ssid">
						<a class="dropdown-item" onclick="changeSsidValue('${ssid}')" role="presentation" href="#">${ssid}</a>
						<c:set var="ssidListString" value="${ssidListString};${ssid}"/>
					</c:forEach>
	           	</div>
	        </div>
	        <input class="keyboard" type="password" id="password" placeholder="Enter Password" style="width: 70%;height: 60px;background-color:white;color:black;">
			<div id="responseText"></div>
			<button class="btn btn-primary" id="submitBtn" onclick="connectWifi()" name="ssid" value="" type="button" style="margin-top: 2%;width:25%;margin-left: 22.5%;">Connect</button>
       
    </div>
    
     <script type="text/javascript">

	function changeSsidValue(ssid){
		var buttonDropDown = document.getElementById("SsidDropDown");
		var buttonSubmit = document.getElementById("submitBtn");
		buttonSubmit.value = ssid
		buttonDropDown.innerText = ssid
	}
	</script>
        
    <script><%@include file="../assets/js/jquery.min.js"%></script> 
    <script><%@include file="../assets/bootstrap/js/bootstrap.min.js"%></script> 
    <script><%@include file="../assets/js/script.min.js"%></script> 
    
<script type="text/javascript">
    
function connectWifi() {
	var ssid = document.getElementById("submitBtn").value
	var password = document.getElementById("password").value
	document.getElementById("load").classList.remove("hide")
	var xmlHttpRequest = getXMLHttpRequest();
	xmlHttpRequest.onreadystatechange = function() {
		if (xmlHttpRequest.readyState == 4) {
			if (xmlHttpRequest.status == 200) {
				document.getElementById("load").className += "hide"
				if(xmlHttpRequest.responseText != "")
					document.getElementById("responseText").innerHTML = "<h6 style='color:green'>Successfully connected to Wifi Network " + xmlHttpRequest.responseText + "</h6>"
				else
					document.getElementById("responseText").innerHTML = "<h6 style='color:red'>An error has occurred: the password is wrong</h6>"
			} else {
				alert("HTTP error " + xmlHttpRequest.status + ": " + xmlHttpRequest.statusText);
			}
		}
	};
	var url = "<%=request.getContextPath()%>" + "/connectWifi?ssid="+ ssid + "&password="+ password
	xmlHttpRequest.open("POST", url, true);
	xmlHttpRequest.setRequestHeader("Content-Type",
			"application/x-www-form-urlencoded");
	xmlHttpRequest.send(null);
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