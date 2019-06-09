<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@page import="it.project.dto.*"%>
<%@page import="it.project.enums.*"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title>Profile Time</title>
    
    <style type="text/css"><%@include file="../assets/bootstrap/css/bootstrap.min.css"%></style>
    <style type="text/css"><%@include file="../assets/fonts/font-awesome.min.css"%></style>
    <style type="text/css"><%@include file="../assets/fonts/ionicons.min.css"%></style>
    <style type="text/css"><%@include file="../assets/css/Sidebar-Menu-1.css"%></style>
    <style type="text/css"><%@include file="../assets/css/Sidebar-Menu.css"%></style>
    <style type="text/css"><%@include file="../assets/css/mystyle.css"%></style>

</head>
<jsp:useBean id="program" class="it.project.dto.Program" scope="session">  </jsp:useBean>

	
<% String wakeupTime = request.getParameter("wakeup_time");
String bedTime = request.getParameter("bed_time");
String leaveTime = request.getParameter("leave_time");
String backTime = request.getParameter("back_time");
((Program) session.getAttribute("program")).setWorkingHours(wakeupTime, bedTime, leaveTime, backTime);


//((Program) session.getAttribute("program"));
%>


<body>
<body>
<form action="profileSetTemperature.jsp" target="_blank" method="POST">          
 
<h1 class="d-lg-flex align-items-lg-center" style="background-color: rgb(44,62,80);height: 70px;">
    	
        <a class="navbar-brand text-left flex-fill" style="margin-left: 80px;padding-top: 5px;height: auto;font-size: 30px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: 206px;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;">
        	<br>SET HOLIDAYS DAY TIME<br><br></a>
        </h1>
    
    <div style="margin-left: auto; margin-right: auto; width: 50%;">
	    <div style="position:absolute; width:50%; height:50%; padding:2%; text-align:center;">
	    What time do you wake up?<br><br>	    
	    <input type="time" name="wakeup_time" value="09:00" style="align: center;" required>
	    </div>
	    
	    <div style="position:absolute; width:50%; height:50%; top:50%; padding:2%; text-align:center;">
	    What time do you go to bed?<br><br>	    
	    <input type="time" name="bed_time" value="23:00" style="align: center;" required>
	    </div>
	    
    </div>
    
    
    
    <footer class="d-lg-flex align-items-lg-center" style="height: 60px; background-color: #ecf0f1;vertical-align: middle; position: absolute; right: 0px; left: 0px">
     	<a class="btn btn-light text-center text-primary bg-light d-lg-flex justify-content-lg-center align-items-lg-center" href="profileTimeWorkingDays.jsp" style="height: 60px;padding-top: 6px;margin-left: 2px; position: absolute;font-size: 30px;">
     		<img src="ios-arrow-round-back-primary.svg"  style="height: 60px;padding-top: 2px;margin-left: 8px;width: 60px; position: absolute; bottom: 2px; left: 0px">                		
     	</a>
     	<button type="submit" class="btn btn-light text-center text-primary bg-light d-lg-flex justify-content-lg-center align-items-lg-center"  style="height: 60px;padding-top: 6px;margin-right: 2px; position: absolute;right: 8px;font-size: 30px;">
     		<img src="ios-arrow-round-forward-primary.svg"  style="height: 60px;padding-top: 6px;width: 60px;position: absolute; bottom:2px; right: 0px">                     
     	</button>
   	</footer>
</form>
    
    
    <script><%@include file="../assets/js/jquery.min.js"%></script> 
    <script><%@include file="../assets/bootstrap/js/bootstrap.min.js"%></script> 
    <script><%@include file="../assets/js/script.min.js"%></script> 
    
      
</body>
</html>