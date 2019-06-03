<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="it.project.db.DBClass" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title>Home</title>
    
    <style type="text/css"><%@include file="WEB-INF/assets/bootstrap/css/bootstrap.min.css"%></style>
    <style type="text/css"><%@include file="WEB-INF/assets/fonts/font-awesome.min.css"%></style>
    <style type="text/css"><%@include file="WEB-INF/assets/fonts/ionicons.min.css"%></style>
    <style type="text/css"><%@include file="WEB-INF/assets/css/Sidebar-Menu-1.css"%></style>
    <style type="text/css"><%@include file="WEB-INF/assets/css/Sidebar-Menu.css"%></style>
    <style type="text/css"><%@include file="WEB-INF/assets/css/styles.css"%></style>

</head>

<body>
    <div id="wrapper">
        <div id="sidebar-wrapper" style="background-color: #2C3E50;">
            <ul class="sidebar-nav">
                <li class="sidebar-brand" style="height: 70px;"> </li>
                <li> <a class="text-light" href="#" style="font-size: 20px;">Home</a></li>
                <li> <a class="text-light" href="#" style="font-size: 20px;">Temperature Profile</a></li>
                <li> <a class="text-light" href="#" style="font-size: 20px;">Room Management</a></li>
                <li> <a class="text-light" href="#" style="font-size: 20px;">Network</a></li>
            </ul>
        </div>
        <div class="page-content-wrapper">
            <div class="container-fluid" style="height: 70px;padding-right: 0px;padding-left: 0px;">
                <h1 class="d-lg-flex align-items-lg-center" style="background-color: rgb(44,62,80);height: 70px;vertical-align: middle;">
                	<a class="btn btn-link d-xl-flex align-items-xl-center" role="button" id="menu-toggle" href="#menu-toggle" style="height: 70px;">
                		<img src="md-reorder-white.svg" style="height: 100%;"></a><a class="navbar-brand text-left flex-fill"
                        href="#" style="margin-left: 16px;padding-top: 5px;height: auto;margin-top: 0px;margin-bottom: 0px;min-width: auto;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;font-size: 30px;">Tue March 24, 2019, 22.36</a>
                    <button
                        class="btn btn-primary text-center d-lg-flex justify-content-lg-center align-items-lg-center" type="button" style="height: 70px;margin-left: 8px;width: 60px;background-color: rgb(44,62,80);margin-right: 8px;position: absolute;right: 2px;">
                        	<img src="ios-settings-white.svg"  style="width:100%;" ></img>
                     	</button>
                     	<!-- style="height: 70px;margin-left: 8px;width: 60px;background-color: rgb(44,62,80);margin-right: 8px;position: absolute;" -->
                </h1>
                <div class="d-inline-flex flex-column">
                    <div><span>17'C</span></div>
                    <div class="btn-group btn-group-vertical" role="group" style="right: 8px;position: absolute;width: 80px; top:20%;">
                    <button class="btn btn-primary" type="button" style="margin-bottom: 16px;align-self: end;padding-right: 8px;padding-left: 8px;">
                    	<img src="ios-add-white.svg" ></img>
                    	</button>
                   	<button class="btn btn-primary" type="button" style="padding-right: 8px;padding-left: 8px;">
                   		<img src="ios-remove-white.svg" ></img></button></div>
                </div>
                <div style="position: absolute;bottom: 100px;height: 70px;font-size: 70px;">
              		<button class="btn btn-light btn-lg text-center text-primary border-white" type="button" style="font-size: 50px;width: 90px;height: 90px;background-color: rgb(255,255,255);"><img src="ios-flame-primary.svg"></button>
              		<button class="btn btn-light btn-lg text-center text-primary border-white" type="button" style="font-size: 50px;width: 90px;height: 90px;background-color: rgb(255,255,255);"><img src="ios-snow-primary.svg"></button>
              		<button class="btn btn-light btn-lg text-center text-primary border-white" type="button" style="font-size: 50px;width: 90px;height: 90px;background-color: rgb(255,255,255);"><img src="ios-thermometer-primary.svg"></button>
                    <button class="btn btn-light btn-lg text-center text-primary border-white" type="button" style="font-size: 50px;width: 90px;height: 90px;background-color: rgb(255,255,255);"><img src="ios-flower-primary.svg"></button>
                    <button class="btn btn-light btn-lg text-center text-primary border-white" type="button" style="font-size: 50px;width: 90px;height: 90px;background-color: rgb(255,255,255);"><img src="md-hand-primary.svg" ></button>
                </div>
                
                               
                <footer class="d-flex d-md-flex d-lg-flex align-items-center align-items-md-center align-items-lg-center" style="height: 60px; background-color: #ecf0f1;vertical-align: middle;">
                	<button class="btn btn-light text-center bg-light border-light d-lg-flex" type="button" style="height: 60px;padding-top: 6px;margin-left: 8px;width: 60px;background-color: rgb(44,62,80);">
                		<!-- i class="icon ion-android-arrow-back d-lg-flex justify-content-lg-center align-items-lg-center" style="font-size: 47px;width: auto;height: auto;font-family: Roboto, sans-serif;color: #2C3E50;"></i> -->
                		<img src="ios-arrow-round-back-primary.svg"  style="height: 60px;padding-top: 2px;margin-left: 8px;width: 60px; position: absolute; bottom: 2px; left: 0px">
                		</button>
                    <a
                        class="navbar-brand text-center text-primary flex-fill" href="#" style="margin-right:64px; padding-top: 5px;font-size: 40px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: auto;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;">HALL</a>
                        <button class="btn btn-primary text-center bg-light border-light d-lg-flex justify-content-lg-center align-items-lg-center" type="button" style="height: 60px;padding-top: 6px;margin-left: 8px;width: 60px;background-color: rgb(44,62,80);margin-right: 8px;position: absolute;right: 8px;">
                        <img src="ios-arrow-round-forward-primary.svg"  style="height: 60px;padding-top: 6px;width: 60px;position: absolute; bottom:2px; right: 0px">
                        </button></footer>
            </div>
        </div>
    </div>
    
    <script><%@include file="WEB-INF/assets/js/jquery.min.js"%></script> 
    <script><%@include file="WEB-INF/assets/bootstrap/js/bootstrap.min.js"%></script> 
    <script><%@include file="WEB-INF/assets/js/Sidebar-Menu.js"%></script> 
    
    <!-- <script src="assets/js/jquery.min.js"></script>
    <script src="assets/bootstrap/js/bootstrap.min.js"></script>
    <script src="assets/js/Sidebar-Menu.js"></script> -->
</body>

</html>