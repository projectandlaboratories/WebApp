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
List<String> ssidList = new ArrayList<>();
ssidList.add("ssid1");
ssidList.add("ssid2");
/* Process listSsid = new ProcessBuilder("/home/pi/script/list_ssid.sh").start();
String line;
BufferedReader input = new BufferedReader(new InputStreamReader(listSsid.getInputStream()));  
while ((line = input.readLine()) != null) { 
	String ssid = line.split(":")[1];
    ssidList.add(ssid);  
}  
input.close();   */

%>
<body>
    <h1 class="d-lg-flex align-items-lg-center" style="background-color: rgb(44,62,80);height: 70px;">
    	<a class="btn btn-primary text-center d-lg-flex" href="../index.jsp" style="position:absolute; left: 8px; top: 6px; height: 60px; width: 60px;background-color: rgb(44,62,80);" >
   			<img src="../images/ios-arrow-round-back-white.svg" style="position:absolute; left: 0px; top: 0px; height: 60px; width: 60px;">
   		</a>
        <a class="navbar-brand text-left flex-fill" style="margin-left: 80px;padding-top: 5px;height: auto;font-size: 30px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: 206px;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;">
        	<br>NETWORK SETTINGS<br><br></a>
        </h1>
    <div style="width: device-width;position: absolute;bottom:0px;top: 40%;left:25%;right:0px;display: inline-block;vertical-align: middle;flex-direction:column;display:flex;">
        <form action="<%=request.getContextPath()%>/changeNetworkSettings" method='POST'>
	        <div class="dropdown" style="width: 70%;margin-bottom: 2%;height: 60px;">
	        	<button id="SsidDropDown" class="btn btn-primary dropdown-toggle d-md-flex justify-content-md-end" data-toggle="dropdown" aria-expanded="false" type="button" style="width: 100%;height: 100%;">Available networks</button>
	            <div class="dropdown-menu" role="menu" style="width: 100%;">
	            	<c:forEach items="<%=ssidList%>" var="ssid">
						<a class="dropdown-item" onclick="changeSsidValue('${ssid}')" role="presentation" href="#">${ssid}</a>
					</c:forEach>
	           	</div>
	        </div>
	        <input type="password" name="password" placeholder="enter Password" style="width: 70%;height: 60px;">
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