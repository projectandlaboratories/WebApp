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
    <title>Login</title>
    <style type="text/css"><%@include file="../assets/bootstrap/css/bootstrap.min.css"%></style>
    <style type="text/css"><%@include file="../assets/fonts/font-awesome.min.css"%></style>
    <style type="text/css"><%@include file="../assets/fonts/ionicons.min.css"%></style>
    <style type="text/css"><%@include file="../assets/css/styles.css"%></style>
    <style type="text/css"><%@include file="../assets/css/keyboard.css"%></style>
    <style type="text/css"><%@include file="../assets/css/jquery-ui.min.css"%></style>
    
</head>

<body>
    <h1 class="d-lg-flex align-items-lg-center" style="background-color: rgb(44,62,80);height: 70px;">
        <a class="navbar-brand text-left flex-fill" style="margin-left: 80px;padding-top: 5px;height: auto;font-size: 30px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: 206px;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;">
        	<br>LOGIN<br><br></a>
        </h1>
        
    <c:set var="error" value="${param.error}"/>
    
    <div style="width: device-width;position: absolute;bottom:0px;top: 40%;left:25%;right:0px;display: inline-block;vertical-align: middle;flex-direction:column;display:flex;">
        <form action="<%=request.getContextPath()%>/checkLogin?action=login" method="POST">
	        <input id="username" name="username" placeholder="username" style="padding:2px; width: 70%;height: 50px;margin-bottom: 2%;background-color:white;color:black;">
	        <input type="password" name="password" id="password" placeholder="password" style="padding:2px;width: 70%;height: 50px;margin-bottom: 2%;background-color:white;color:black;">
			<button class="btn btn-primary" id="submitBtn" name="ssid" value="" type="submit" style="margin-top: 2%;width:25%;margin-left: 22.5%;">LOGIN</button>
      	</form>
    </div>
    <c:if test="${error eq true}">
    	<h6 style="color:red;margin-top:1%;margin-left:19%;">Wrong credentials</h6>
    </c:if>
    
    <script><%@include file="../assets/js/jquery.min.js"%></script> 
    <script><%@include file="../assets/bootstrap/js/bootstrap.min.js"%></script> 
    <script><%@include file="../assets/js/script.min.js"%></script> 
</body>

</html>