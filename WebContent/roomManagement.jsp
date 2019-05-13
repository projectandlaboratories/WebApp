<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="it.project.db.DBClass" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    
<title>Room Management</title>
 <!-- link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Lato:400,700,400italic">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto">
     -->
    <style type="text/css"><%@include file="WEB-INF/assets/bootstrap/css/bootstrap.min.css"%></style>
    <style type="text/css"><%@include file="WEB-INF/assets/fonts/font-awesome.min.css"%></style>
    <style type="text/css"><%@include file="WEB-INF/assets/fonts/ionicons.min.css"%></style>
    <style type="text/css"><%@include file="WEB-INF/assets/css/styles.css"%></style>

</head>
<body>
    <h1 class="d-lg-flex align-items-lg-center" style="background-color: rgb(44,62,80);height: 70px;">
    	<a class="btn btn-primary text-center d-lg-flex" style="height: 60px;padding-top: 6px;margin-left: 8px;width: 60px;background-color: rgb(44,62,80);" >
   			<img src="ios-arrow-round-back-white.svg" style="position:absolute; left: 8px; top: 6px; height: 60px; width: 60px;">
   		</a>
        <a class="navbar-brand text-left flex-fill" style="margin-left: 16px;padding-top: 5px;height: auto;font-size: 40px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: 206px;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;">
        	<br>ROOM MANAGEMENT<br><br></a>
        <a class="btn btn-light text-center text-primary d-lg-flex justify-content-lg-center align-items-lg-center action-button" href="#" style="color: rgb(255,255,255);line-height: 23px;width: 122px;height: 60px;font-size: 20px;margin-right: 8px;font-family: Roboto, sans-serif;">Add room</a></h1>
    <ul class="list-group">
        <li class="list-group-item d-lg-flex justify-content-lg-center align-items-lg-center" style="padding-top: 8px;padding-right: 16px;padding-bottom: 8px;padding-left: 16px;margin-top: 0px;height: 64px;">
        <span class="d-inline-flex flex-shrink-0 flex-fill justify-content-lg-start align-items-lg-center" style="font-size: 24px;">HALL</span>
        <span class="d-inline-flex" style="font-size: 24px;margin-right: 8px;">13°C</span>
        <img src="ios-alert-red.svg" style="height: 40px; width: 40px; visibility: hidden;">
        </li>
        <li class="list-group-item d-lg-flex justify-content-lg-center align-items-lg-center" style="padding-top: 8px;padding-right: 16px;padding-bottom: 8px;padding-left: 16px;margin-top: 0px;height: 64px;"><span class="d-inline-flex flex-shrink-0 flex-fill justify-content-lg-start align-items-lg-center" style="font-size: 24px;">LIVING ROOM</span><span class="d-inline-flex" style="font-size: 24px;margin-right: 8px;">18°C</span>
        	 <img src="ios-alert-red.svg" style="height: 40px; width: 40px; visibility: visible;">
       	 </li>
        <li class="list-group-item d-lg-flex justify-content-lg-center align-items-lg-center" style="padding-top: 8px;padding-right: 16px;padding-bottom: 8px;padding-left: 16px;margin-top: 0px;height: 64px;"><span class="d-inline-flex flex-shrink-0 flex-fill justify-content-lg-start align-items-lg-center" style="font-size: 24px;">BEDROOM</span><span class="d-inline-flex" style="font-size: 24px;margin-right: 8px;">20°C</span>
        	 <img src="ios-alert-red.svg" style="height: 40px; width: 40px; visibility: visible;">
       	 </li>
     </ul>
     <footer class="d-lg-flex align-items-lg-center" style="background-color: #ecf0f1;vertical-align: middle; position: absolute; bottom: 0px; right: 0px; left: 0px">
     	<a class="btn btn-secondary text-center text-primary bg-light border-primary d-lg-flex" style="height: 60px;padding-top: 6px;margin-left: 8px;font-size: 30px;">PREV</a>
     	<a class="btn btn-primary text-center text-primary bg-light d-lg-flex justify-content-lg-center align-items-lg-center" style="height: 60px;padding-top: 6px;margin-right: 2px;position: absolute;right: 8px;font-size: 30px;">NEXT</a>
   	</footer>
    
    <script><%@include file="WEB-INF/assets/js/jquery.min.js"%></script> 
    <script><%@include file="WEB-INF/assets/bootstrap/js/bootstrap.min.js"%></script> 
    <script><%@include file="WEB-INF/assets/js/script.min.js"%></script> 
    
        

</body>
</html>