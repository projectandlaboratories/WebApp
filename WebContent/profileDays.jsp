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

</head>
<body>
<h1 class="d-lg-flex align-items-lg-center" style="background-color: rgb(44,62,80);height: 70px;">
    	
        <a class="navbar-brand text-left flex-fill" style="margin-left: 80px;padding-top: 5px;height: auto;font-size: 30px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: 206px;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;">
        	<br>WHAT DAYS ARE YOU AT HOME?<br><br></a>
        </h1>
        
           
    <div style="transform: scale(1.2); position: absolute; left: 100px;  top: 100px;" >
	    <div class="btn-group btn-group" data-toggle="buttons" >
		    <label class="btn active"> <input type="checkbox" name='Mon' checked> Mon</label>
		    <label class="btn active"> <input type="checkbox" name='Tue' checked> Tue </label>
		    <label class="btn active"> <input type="checkbox" name='Wed' checked> Wed </label>
		    <label class="btn active"> <input type="checkbox" name='Thu' checked> Thu </label>
		    <label class="btn active"> <input type="checkbox" name='Fri' checked> Fri </label>
		    <label class="btn active"> <input type="checkbox" name='Sat'> Sat </label>
		    <label class="btn active"> <input type="checkbox" name='Sun'> Sun</label>		    
	</div>
    </div>
    
    
    
    <footer class="d-lg-flex align-items-lg-center" style="height: 60px; background-color: #ecf0f1;vertical-align: middle; position: absolute; right: 0px; left: 0px">
     	
     	<a class="btn btn-light text-center text-primary bg-light d-lg-flex justify-content-lg-center align-items-lg-center" style="height: 60px;padding-top: 6px;margin-right: 2px; position: absolute;right: 8px;font-size: 30px;">
     		<img src="ios-arrow-round-forward-primary.svg"  style="height: 60px;padding-top: 6px;width: 60px;position: absolute; bottom:2px; right: 0px">                     
     	</a>
   	</footer>

    
    <script><%@include file="WEB-INF/assets/js/jquery.min.js"%></script> 
    <script><%@include file="WEB-INF/assets/bootstrap/js/bootstrap.min.js"%></script> 
    <script><%@include file="WEB-INF/assets/js/script.min.js"%></script> 
    
      
</body>
</html>