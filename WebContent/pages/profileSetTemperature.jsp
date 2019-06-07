<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
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
<body>
<h1 class="d-lg-flex align-items-lg-center" style="background-color: rgb(44,62,80);height: 70px;">
    	
        <a class="navbar-brand text-left flex-fill" style="margin-left: 80px;padding-top: 5px;height: auto;font-size: 30px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: 206px;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;">
        	<br>SET TEMPERATURE<br><br></a>
        </h1>
        
        

    
    <div style="margin-right: 10%; margin-left:10%; width: 80%; text-align: center; padding-right:3%;">
    	<div>
    		<span style="width: 100px;display: inline-block;padding-top: 30px;">OUT</span> 
    		<input type="range" class="range" min="16" max="26" value="20" name="out_temperature_out">
    	</div>
	  
	  	<div>
    		<span style="width: 100px;display: inline-block;padding-top: 40px;">HOME</span>
    		<input type="range" class="range" min="16" max="26" value="20" name="out_temperature_home">
    	</div>
    	
    	<div>
    		<span style="width: 100px;display: inline-block;padding-top: 40px;">NIGHT</span>
    		<input type="range" class="range" min="16" max="26" value="20" name="out_temperature_night">
    	</div>
	   
	   
	
    </div>
    
   
    
    <footer class="d-lg-flex align-items-lg-center" style="height: 60px; background-color: #ecf0f1;vertical-align: middle; position: absolute; right: 0px; left: 0px">
     	<a class="btn btn-light text-center text-primary bg-light d-lg-flex justify-content-lg-center align-items-lg-center" style="height: 60px;padding-top: 6px;margin-left: 2px; position: absolute;font-size: 30px;">
     		<img src="ios-arrow-round-back-primary.svg"  style="height: 60px;padding-top: 2px;margin-left: 8px;width: 60px; position: absolute; bottom: 2px; left: 0px">                		
     	</a>
     	<a class="btn btn-light text-center text-primary bg-light d-lg-flex justify-content-lg-center align-items-lg-center" style="height: 60px;padding-top: 6px;margin-right: 2px; position: absolute;right: 8px;font-size: 30px;">
     		<img src="ios-arrow-round-forward-primary.svg"  style="height: 60px;padding-top: 6px;width: 60px;position: absolute; bottom:2px; right: 0px">                     
     	</a>
   	</footer>

    <script>    
    var classname = document.getElementsByClassName("range");
    Array.from(classname).forEach(function(element) {
        element.addEventListener('input', function rangeChange() {
      	  // trigger the CSS to update
      	  this.setAttribute('value', this.value);
      	});
      });
    </script> 
    
    <script><%@include file="../assets/js/jquery.min.js"%></script> 
    <script><%@include file="../assets/bootstrap/js/bootstrap.min.js"%></script> 
    <script><%@include file="../assets/js/script.min.js"%></script> 
    
      
</body>
</html>