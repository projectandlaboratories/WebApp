<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<%@page import="it.project.dto.Program"%>
<%@page import="it.project.db.DBClass"%>
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

</head>
<%String alertCode=request.getParameter("alert");
%>

<script type="text/javascript">
var alertCode="<%=alertCode%>"
if(alertCode==='assigned'){
	alert("Current profile is assigned to at least one room!")
}

</script>


<c:set var="currentProfile" scope="session" value="${profileMap[param.profile]}"/> 

<%Program p = (Program)session.getAttribute("currentProfile");
String deleteDisplay;
String defaultProfile = DBClass.getConfigValue("defaultProfile");
if(p.getName().compareTo(defaultProfile)==0){
	deleteDisplay="none";
}else deleteDisplay="block";
%>

<body>
<h1 class="d-lg-flex align-items-lg-center" style="background-color: rgb(44,62,80);height: 70px;">
    	<a class="btn btn-primary text-center d-lg-flex" href="profileList.jsp" style="position:absolute; left: 8px; top: 6px; height: 60px; width: 60px;background-color: rgb(44,62,80);" >
   			<img src="../images/ios-arrow-round-back-white.svg" style="position:absolute; left: 0px; top: 0px; height: 60px; width: 60px;">
   		</a>
        <a class="navbar-brand text-left flex-fill" style="margin-left: 80px;padding-top: 5px;height: auto;font-size: 30px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: 206px;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;">
        	<br><c:out value = "${currentProfile.name}"/><br><br></a>
        </h1>  
	
    
    <div style="margin-right: 10%; margin-left:10%; width: 80%; text-align: center; margin-top:3%">

    	
    	<jsp:include page="profileBars.jsp" />
    		   
  
	    <div style="display: inline-flex; text-align: center; margin-top:50px">
	     <form action="<%=request.getContextPath()+"/newProgramServlet"%>" method="POST">  
           	<button type='submit' name="ACTION" value="DELETE" class="btn btn-primary d-lg-flex justify-content-lg-start" onclick="location.href = 'profileDays.jsp'" type="button" style="font-size: 20px;margin-left: 16px;margin-right: 16px;padding-right: 16px;padding-left: 18px; display: <%=deleteDisplay%>;">DELETE</button>
       	</form> 
        	<button class="btn btn-primary d-lg-flex justify-content-lg-start" onclick="location.href = 'profileDays.jsp'" type="button" style="font-size: 20px;margin-left: 16px;padding-right: 16px;padding-left: 16px;">EDIT</button>
        </div>
	  
    </div>


    
    <script><%@include file="../assets/js/jquery.min.js"%></script> 
    <script><%@include file="../assets/bootstrap/js/bootstrap.min.js"%></script> 
    <script><%@include file="../assets/js/script.min.js"%></script> 
    
      
</body>
</html>