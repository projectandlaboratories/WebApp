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

</head>

<%
	String ssid = request.getParameter("ssid");
	String password = request.getParameter("password");
	String ssidListString = request.getParameter("ssidListString");	
	Set<String> ssidList = new HashSet<>();
	
	if(ssid != null && password != null && ssidListString != null){
		pageContext.setAttribute("connectWifi", true);
		Process connectWifi= new ProcessBuilder("/bin/bash",getServletContext().getRealPath("/bash/connect_wifi.sh"),ssid,password).redirectErrorStream(true).start();
		String[] fields = ssidListString.split(";");
		for(String field : fields){
			if(!field.equals(""))
				ssidList.add(field);
		}
		String line;
		BufferedReader input = new BufferedReader(new InputStreamReader(connectWifi.getInputStream()));
		String connectedSsid = "";
		while ((line = input.readLine()) != null) {
			String[] outputSplitted = line.split(":");
			if(outputSplitted.length > 0){
				connectedSsid = line.split(":")[1];
				connectedSsid = connectedSsid.replace("\"", "");
			}			
			if(connectedSsid.equals(ssid)){
				pageContext.setAttribute("isConnected", true);
			}
			else{
				pageContext.setAttribute("isConnected", false);
			}			
		}
		input.close();
		
		/* Thread.sleep(6000);
		Process checkWifi= new ProcessBuilder("/bin/bash",getServletContext().getRealPath("/bash/check_connection.sh"),ssid,password).redirectErrorStream(true).start();
		String line;
		BufferedReader input = new BufferedReader(new InputStreamReader(checkWifi.getInputStream()));
		while ((line = input.readLine()) != null) {
			String connectedSsid = line.split(":")[1];
			connectedSsid = connectedSsid.replace("\"", "");
			if(connectedSsid.equals(ssid)){
				pageContext.setAttribute("isConnected", true);
			}
			else{
				pageContext.setAttribute("isConnected", false);
			}
				
		}
		input.close(); */
	}
	else{
		pageContext.setAttribute("connectWifi", false);
		Process listSsid = new ProcessBuilder("/bin/bash",getServletContext().getRealPath("/bash/list_ssid.sh")).redirectErrorStream(true).start();
		String line;
		BufferedReader input = new BufferedReader(new InputStreamReader(listSsid.getInputStream()));
		while ((line = input.readLine()) != null) {
			String ssidName = line.split(":")[1];
			ssidName = ssidName.replace("\"", "");
			if(!ssidName.equals(""))
				ssidList.add(ssidName);
		}
		input.close();
	}
	 
%>
<body>
	<c:if test="${connectWifi eq true}">
		<c:choose>
			<c:when test="${isConnected eq true}">
				<h2>CONNECTED</h2>
			</c:when>
			<c:otherwise>
				<h2>NOT CONNECTED</h2>
			</c:otherwise>
		</c:choose>
	
	</c:if>
	<c:set var="ssidListString" value=""/>
    <h1 class="d-lg-flex align-items-lg-center" style="background-color: rgb(44,62,80);height: 70px;">
    	<a class="btn btn-primary text-center d-lg-flex" href="../index.jsp" style="position:absolute; left: 8px; top: 6px; height: 60px; width: 60px;background-color: rgb(44,62,80);" >
   			<img src="../images/ios-arrow-round-back-white.svg" style="position:absolute; left: 0px; top: 0px; height: 60px; width: 60px;">
   		</a>
        <a class="navbar-brand text-left flex-fill" style="margin-left: 80px;padding-top: 5px;height: auto;font-size: 30px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: 206px;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;">
        	<br>NETWORK SETTINGS<br><br></a>
        </h1>
    <div style="width: device-width;position: absolute;bottom:0px;top: 40%;left:25%;right:0px;display: inline-block;vertical-align: middle;flex-direction:column;display:flex;">
        <form action="<%=request.getContextPath()%>/pages/networkSettings.jsp" method='POST'>
	        <div class="dropdown" style="width: 70%;margin-bottom: 2%;height: 60px;">
	        	<button id="SsidDropDown" class="btn btn-primary dropdown-toggle d-md-flex justify-content-md-end" data-toggle="dropdown" aria-expanded="false" type="button" style="width: 100%;height: 100%;">Available networks</button>
	            <div class="dropdown-menu" role="menu" style="width: 100%;">
	            	<c:forEach items="<%=ssidList%>" var="ssid">
						<a class="dropdown-item" onclick="changeSsidValue('${ssid}')" role="presentation" href="#">${ssid}</a>
						<c:set var="ssidListString" value="${ssidListString};${ssid}"/>
					</c:forEach>
	           	</div>
	        </div>
	        <input type="password" name="password" placeholder="enter Password" style="width: 70%;height: 60px;">
	        <input type="hidden" name="ssidListString" value="${ssidListString}"/>
	        <button class="btn btn-primary" id="submitBtn" name="ssid" value="" type="submit" style="margin-top: 2%;width:25%;margin-left: 22.5%;">Connect</button>
        </form>
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
    
        

</body>
</html>