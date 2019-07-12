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
        <a class="btn btn-primary text-center d-lg-flex" href="../index.jsp" style="position:absolute; font-size:20px; left: 8px; top: 15px; height: 30px; width: 160px;background-color: rgb(44,62,80);" >
   			<h3 style="font-size:20px">LOGOUT</h3>
   		</a>
        <a class="navbar-brand text-left flex-fill" style="margin-left: 580px;padding-top: 5px;height: auto;font-size: 30px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: 206px;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;">
        	<br>ADMIN PAGE<br><br></a>
        </h1>
    
   <h2 style="margin-top: 10%;margin-left: 30%;">DEPLOY NEW VERSION</h2>
   <form action="<%=request.getContextPath()%>/deployNewVersion">
   		<button class="btn btn-primary" id="submitBtn" type="submit" style="margin-top: 2%;width:25%;margin-left: 35%;">DEPLOY</button>
   </form>
    <script><%@include file="../assets/js/jquery.min.js"%></script> 
    <script><%@include file="../assets/bootstrap/js/bootstrap.min.js"%></script> 
    <script><%@include file="../assets/js/script.min.js"%></script> 
</body>

</html>