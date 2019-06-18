<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="it.project.db.DBClass" %>
<!DOCTYPE html>

<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">  
<title>Add Room</title>

    <style type="text/css"><%@include file="../assets/bootstrap/css/bootstrap.min.css"%></style>
    <style type="text/css"><%@include file="../assets/fonts/font-awesome.min.css"%></style>
    <style type="text/css"><%@include file="../assets/fonts/ionicons.min.css"%></style>
    <style type="text/css"><%@include file="../assets/css/styles.css"%></style>

</head>
<body>
    <h1 class="d-lg-flex align-items-lg-center" style="background-color: rgb(44,62,80);height: 70px;">
    	<a class="btn btn-primary text-center d-lg-flex" href="roomManagement.jsp" style="position:absolute; left: 8px; top: 6px; height: 60px; width: 60px;background-color: rgb(44,62,80);" >
   			<img src="../images/ios-arrow-round-back-white.svg" style="position:absolute; left: 0px; top: 0px; height: 60px; width: 60px;">
   		</a>
        <a class="navbar-brand text-left flex-fill" style="margin-left: 80px;padding-top: 5px;height: auto;font-size: 30px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: 206px;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;">
        	<br>ADD ROOM<br><br></a>
        </h1>
    <div style="width: device-width;position: absolute;bottom:0px;top: 25%;left:25%;right:0px;display: inline-block;vertical-align: middle;flex-direction:column;display:flex;">
        
        <input name="roomName" style="width: 70%;margin-bottom: 2%;height: 50px;">
        
        <div class="dropdown" style="width: 70%;margin-bottom: 2%;height: 50px;">
        	<button class="btn btn-primary dropdown-toggle d-md-flex justify-content-md-end" data-toggle="dropdown" aria-expanded="false" type="button" style="width: 100%;height: 100%;">Select air-conditioning model</button>
            <div class="dropdown-menu" role="menu" style="width: 100%;">
            	<a class="dropdown-item" role="presentation" href="#">First Item</a>
            	<a class="dropdown-item" role="presentation" href="#">Second Item</a>
            	<a class="dropdown-item" role="presentation" href="#">Third Item</a>
           	</div>
        </div>
        
        <div class="dropdown" style="width: 70%;margin-bottom: 2%;height: 50px;">
        	<button class="btn btn-primary dropdown-toggle d-md-flex justify-content-md-end" data-toggle="dropdown" aria-expanded="false" type="button" style="width: 100%;height: 100%;">Associate device</button>
            <div class="dropdown-menu" role="menu" style="width: 100%;">
            	<a class="dropdown-item" role="presentation" href="#">First Item</a>
            	<a class="dropdown-item" role="presentation" href="#">Second Item</a>
            	<a class="dropdown-item" role="presentation" href="#">Third Item</a>
           	</div>
        </div>
        
        <button class="btn btn-primary" type="button" style="margin-top: 2%;width:25%;margin-left: 22.5%;">Connect</button>
    </div>
        
    <script><%@include file="../assets/js/jquery.min.js"%></script> 
    <script><%@include file="../assets/bootstrap/js/bootstrap.min.js"%></script> 
    <script><%@include file="../assets/js/script.min.js"%></script> 
    
        

</body>
</html>