<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
     <%@page import="it.project.dto.*"%>
<%@page import="it.project.enums.*"%>
<%@page import="java.util.*"%>
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
	    background:url("<%=request.getContextPath() + "/images/loading-icon.gif"%>") no-repeat center center rgba(0,0,0,0.25)
	}
	.hide{
		display:none;
	}
</style>

</head>
<jsp:useBean id="currentProfile" class="it.project.dto.Program" scope="session">  </jsp:useBean>

<% 
String alertCode=request.getParameter("alert");
Program myProgram=(Program) session.getAttribute("currentProfile");

//prendo parametri dalla pagina precedente
if(request.getParameter("out_temperature")!=null){
	int outTemperature = Integer.parseInt(request.getParameter("out_temperature"));
	int homeTemperature = Integer.parseInt(request.getParameter("home_temperature"));
	int nightTemperature = Integer.parseInt(request.getParameter("night_temperature"));
	Map<DayMoment, Integer> temperature = new HashMap<>();
	temperature.put(DayMoment.NIGHT,nightTemperature);
	temperature.put(DayMoment.HOME,homeTemperature);
	temperature.put(DayMoment.OUT,outTemperature);
	myProgram.setTemperatureMap(temperature);
	myProgram.generateIntervalMap(outTemperature, homeTemperature, nightTemperature);	
}
//Setto i parametri della pagina corrente
String name="";
String action="ADD";
if(myProgram.getName()!=null){
	name=myProgram.getName();
	session.setAttribute("previousName", name);
	action="UPDATE";
}
%>
<script type="text/javascript">

alertCode="<%=alertCode%>"
if(alertCode=='present'){
	alert("Profile name already present!")
}
else if(alertCode == 'empty'){
	alert("Profile name can't be empty!")
}

function showLoadingIcon(){
	document.getElementById("load").classList.remove("hide")
}

</script>
<body>
<div id="load" class="hide"></div>
<h1 class="d-lg-flex align-items-lg-center" style="background-color: rgb(44,62,80);height: 70px;">
    
        <a class="navbar-brand text-left flex-fill" style="margin-left: 80px;padding-top: 5px;height: auto;font-size: 30px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: 206px;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;">
        	<br>SUMMARY<br><br></a>
        </h1>
<form action="<%=request.getContextPath()+"/newProgramServlet"%>" method="POST">          
        
    <div style="margin-right: 10%; margin-left:10%; width: 80%; text-align: center; margin-top:3%">
    
    	<div style="margin-bottom: 20px"><input class="keyboard" type="text" placeholder="enter profile name" name="profile_name" value="<%=name %>" style="width:100%;background-color:white;color:black;"></div>	
    	<jsp:include page="profileBars.jsp" /> 
	   
	   
   
	    <div style="display: inline-flex; text-align: center; margin-top:2%">
           	<button type='submit' onclick="showLoadingIcon()" name="ACTION" value="<%=action %>" class="btn btn-primary d-lg-flex justify-content-lg-start" type="button" style="font-size: 20px;margin-left: 8px;margin-right: 0px;padding-right: 16px;padding-left: 18px;">SAVE</button>
      	
        </div>
	
    </div>
    
</form>   
    
    <footer class="d-lg-flex align-items-lg-center" style="height: 60px; background-color: #ecf0f1;vertical-align: middle; position: absolute; right: 0px; left: 0px">
     	<a class="btn btn-light text-center text-primary bg-light d-lg-flex justify-content-lg-center align-items-lg-center" href="profileSetTemperature.jsp" style="height: 60px;padding-top: 6px;margin-left: 2px; position: absolute;font-size: 30px;">
     		<img src="../images/ios-arrow-round-back-primary.svg"  style="height: 60px;padding-top: 2px;margin-left: 8px;width: 60px; position: absolute; bottom: 2px; left: 0px">                		
     	</a>
     	
   	</footer>

    
    <script><%@include file="../assets/js/jquery.min.js"%></script> 
    <script><%@include file="../assets/bootstrap/js/bootstrap.min.js"%></script> 
    <script><%@include file="../assets/js/script.min.js"%></script>
    
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