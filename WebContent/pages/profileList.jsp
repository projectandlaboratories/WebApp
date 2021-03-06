<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="it.project.db.DBClass" %>
    <%@ page import="it.project.dto.*" %>
    <%@ page import="java.util.List" %>
    <%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<!DOCTYPE html>

<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">  
<title>Profile List</title>

    <style type="text/css"><%@include file="../assets/bootstrap/css/bootstrap.min.css"%></style>
    <style type="text/css"><%@include file="../assets/fonts/font-awesome.min.css"%></style>
    <style type="text/css"><%@include file="../assets/fonts/ionicons.min.css"%></style>
    <style type="text/css"><%@include file="../assets/css/styles.css"%></style>
    
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

<%session.removeAttribute("currentProfile");
session.removeAttribute("profileParam");
session.setAttribute("caller", "profileList.jsp");%>

<c:set var="profileMap" scope="session" value="<%=DBClass.getProfileMap()%>"/>

<body>
	<div id="load" class="hide"></div>
    <h1 class="d-lg-flex align-items-lg-center" style="background-color: rgb(44,62,80);height: 70px;">
    	<a class="btn btn-primary text-center d-lg-flex" onclick="showLoadingIcon()" href="../index.jsp" style="position:absolute; left: 8px; top: 6px; height: 60px; width: 60px;background-color: rgb(44,62,80);" >
   			<img src="../images/ios-arrow-round-back-white.svg" style="position:absolute; left: 0px; top: 0px; height: 60px; width: 60px;">
   		</a>
        <a class="navbar-brand text-left flex-fill" style="margin-left: 80px;padding-top: 5px;height: auto;font-size: 30px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: 206px;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;">
        	<br>PROFILES<br><br></a>
        <a class="btn btn-light text-center text-primary d-lg-flex justify-content-lg-center align-items-lg-center action-button" onclick="showLoadingIcon()" href="profileDays.jsp?action=add" style="height: 55px;font-size: 20px;margin-right: 8px;position:absolute; right: 2px; top:8px; font-family: Roboto, sans-serif;">New Profile</a>
        </h1>
    <ul class="list-group">
    	<c:forEach items="${profileMap}" var="profile">
	    	<li class="list-group-item d-lg-flex justify-content-lg-center align-items-lg-center" style="padding-top: 8px;padding-right: 16px;padding-bottom: 8px;padding-left: 16px;margin-top: 0px;height: 64px;">
	        	<a class="d-inline-flex flex-shrink-0 flex-fill justify-content-lg-start align-items-lg-center" onclick="showLoadingIcon()" href="profileShow.jsp?profile=${profile.key}" style="font-size: 24px;"> ${profile.key} </a>
	        </li>
		</c:forEach>   
     </ul>
        
    <script><%@include file="../assets/js/jquery.min.js"%></script> 
    <script><%@include file="../assets/bootstrap/js/bootstrap.min.js"%></script> 
    <script><%@include file="../assets/js/script.min.js"%></script> 
    
  <script type="text/javascript">
  function showLoadingIcon(){
		document.getElementById("load").classList.remove("hide")
	}
  </script>

</body>
</html>