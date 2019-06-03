<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title>Profile Time</title>
    
    <style type="text/css"><%@include file="WEB-INF/assets/bootstrap/css/bootstrap.min.css"%></style>
    <style type="text/css"><%@include file="WEB-INF/assets/fonts/font-awesome.min.css"%></style>
    <style type="text/css"><%@include file="WEB-INF/assets/fonts/ionicons.min.css"%></style>
    <style type="text/css"><%@include file="WEB-INF/assets/css/Sidebar-Menu-1.css"%></style>
    <style type="text/css"><%@include file="WEB-INF/assets/css/Sidebar-Menu.css"%></style>
    <style type="text/css"><%@include file="WEB-INF/assets/css/styles.css"%></style>
     <style type="text/css"><%@include file="WEB-INF/assets/css/mystyle.css"%></style>

</head>
<body>
<h1 class="d-lg-flex align-items-lg-center" style="background-color: rgb(44,62,80);height: 70px;">
    	<a class="btn btn-primary text-center d-lg-flex" style="position:absolute; left: 8px; top: 6px; height: 60px; width: 60px;background-color: rgb(44,62,80);" >
   			<img src="ios-arrow-round-back-white.svg" style="position:absolute; left: 0px; top: 0px; height: 60px; width: 60px;">
   		</a>
        <a class="navbar-brand text-left flex-fill" style="margin-left: 80px;padding-top: 5px;height: auto;font-size: 30px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: 206px;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;">
        	<br>SUMMARY<br><br></a>
        </h1>
        
        
	
    
    <div style="margin-right: 10%; margin-left:10%; width: 80%; text-align: center; margin-top:3%">
    
    	<div style="margin-bottom: 20px"><input type="text" name="profile_name" style="width:100%"></div>
    	
    	<div class="progress beautiful" style="height: 30px;  margin-top: 10px">
		    <div class="progress-bar progress-bar-night" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 30%;"><span id="working_day_night_temp">23</span></div>
		    <div class="progress-bar progress-bar-home" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 5%;"></div>
		    <div class="progress-bar progress-bar-out" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 40%;"><span id="working_day_out_temp">18</span></div>
		    <div class="progress-bar progress-bar-home" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 20%;"><span id="working_day_home_temp">21</span></div>
		    <div class="progress-bar progress-bar-night" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 5%;"></div>
		</div>
		<div>Mon-Tue-Wed-Thu-Fri</div>
		
		<div class="progress beautiful" style="height: 30px; margin-top: 10px">
		    <div class="progress-bar progress-bar-night" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 30%;"><span id="holiday_night_temp">23</span></div>
		    <div class="progress-bar progress-bar-home" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 65%;"><span id="holiday_home_temp">21</span></div>
		    <div class="progress-bar progress-bar-night" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 5%;"></div>
		</div>
		<div>Sat-Sun</div>
	   
	   
   
	    <div style="display: inline-flex; text-align: center; margin-top:2%">
           	<button class="btn btn-primary d-lg-flex justify-content-lg-start" type="button" style="font-size: 20px;margin-left: 8px;margin-right: 0px;padding-right: 16px;padding-left: 18px;">DELETE</button>
        	<button class="btn btn-primary d-lg-flex justify-content-lg-start" type="button" style="font-size: 20px;margin-left: 8px;padding-right: 16px;padding-left: 16px;">SAVE</button>
        </div>
	
    </div>
    
   
    
    <footer class="d-lg-flex align-items-lg-center" style="height: 60px; background-color: #ecf0f1;vertical-align: middle; position: absolute; right: 0px; left: 0px">
     	<a class="btn btn-light text-center text-primary bg-light d-lg-flex justify-content-lg-center align-items-lg-center" style="height: 60px;padding-top: 6px;margin-left: 2px; position: absolute;font-size: 30px;">
     		<img src="ios-arrow-round-back-primary.svg"  style="height: 60px;padding-top: 2px;margin-left: 8px;width: 60px; position: absolute; bottom: 2px; left: 0px">                		
     	</a>
     	
   	</footer>

    
    <script><%@include file="WEB-INF/assets/js/jquery.min.js"%></script> 
    <script><%@include file="WEB-INF/assets/bootstrap/js/bootstrap.min.js"%></script> 
    <script><%@include file="WEB-INF/assets/js/script.min.js"%></script> 
    
      
</body>
</html>