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
    	<a class="btn btn-primary text-center d-lg-flex" style="position:absolute; left: 8px; top: 6px; height: 60px; width: 60px;background-color: rgb(44,62,80);" >
   			<img src="ios-arrow-round-back-white.svg" style="position:absolute; left: 0px; top: 0px; height: 60px; width: 60px;">
   		</a>
        <a class="navbar-brand text-left flex-fill" style="margin-left: 80px;padding-top: 5px;height: auto;font-size: 30px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: 206px;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;">
        	<br>ROOM DETAIL<br><br></a>
        </h1>
        
        
	<div>
        <div>
            <ul class="nav nav-tabs">
                <li class="nav-item flex-fill"><a class="nav-link active d-lg-flex flex-fill justify-content-lg-center" role="tab" data-toggle="tab" href="#tab-1" style="font-size: 20px;text-align:center">Winter</a></li>
                <li class="nav-item flex-fill"><a class="nav-link d-lg-flex flex-fill justify-content-lg-center" role="tab" data-toggle="tab" href="#tab-2" style="font-size: 20px;text-align:center">Summer</a></li>
            </ul>
            
            <div class="tab-content">
                <div class="tab-pane active" role="tabpanel" id="tab-1" style="margin: 16px;">
                  
	                <div style="display: inline-flex">
	                    <div class="dropdown d-inline-flex"><button class="btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-expanded="false" type="button" style="font-size: 20px;">Choose Profile</button>
	                        <div class="dropdown-menu" role="menu" style="width:100%"><a class="dropdown-item" role="presentation" href="#">Profile 1</a><a class="dropdown-item" role="presentation" href="#">Profile 2</a><a class="dropdown-item" role="presentation" href="#">Profile 3</a></div>
	                    </div>
	                    
	                    <div style="display: inline-flex; position: absolute; right: 16px;">
	                       	<button class="btn btn-primary d-lg-flex justify-content-lg-start" type="button" style="font-size: 20px;margin-left: 8px;margin-right: 0px;padding-right: 16px;padding-left: 18px;">Edit</button>
	                    	<button class="btn btn-primary d-lg-flex justify-content-lg-start" type="button" style="font-size: 20px;margin-left: 8px;padding-right: 16px;padding-left: 16px;">New</button>
	                   	</div>
	                </div>
	                
	                
	                <div style="margin-right: 10%; margin-left:10%; width: 80%; text-align: center; margin-top:5%">

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
					   
					
				    </div>
				    
	    
               	 </div>
               	 
               	 <div class="tab-pane" role="tabpanel" id="tab-2" style="margin: 16px;">
                 	<div style="display: inline-flex">
	                    <div class="dropdown d-inline-flex"><button class="btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-expanded="false" type="button" style="font-size: 20px;">Choose Profile</button>
	                        <div class="dropdown-menu" role="menu" style="width:100%"><a class="dropdown-item" role="presentation" href="#">Profile 1</a><a class="dropdown-item" role="presentation" href="#">Profile 2</a><a class="dropdown-item" role="presentation" href="#">Profile 3</a></div>
	                    </div>
	                    
	                    <div style="display: inline-flex; position: absolute; right: 16px;">
	                       	<button class="btn btn-primary d-lg-flex justify-content-lg-start" type="button" style="font-size: 20px;margin-left: 8px;margin-right: 0px;padding-right: 16px;padding-left: 18px;">Edit</button>
	                    	<button class="btn btn-primary d-lg-flex justify-content-lg-start" type="button" style="font-size: 20px;margin-left: 8px;padding-right: 16px;padding-left: 16px;">New</button>
	                   	</div>
	                </div>
	                
	                
	                <div style="margin-right: 10%; margin-left:10%; width: 80%; text-align: center; margin-top:5%">

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
					   
					
				    </div>
               	 </div>
            </div>
        </div>
    </div>
    
    <div style="margin-right: 10%; margin-left:10%; width: 80%; text-align: center; margin-top:5%">
    
    	
	
    </div>
    
   
    
   

    
    <script><%@include file="../assets/js/jquery.min.js"%></script> 
    <script><%@include file="../assets/bootstrap/js/bootstrap.min.js"%></script> 
    <script><%@include file="../assets/js/script.min.js"%></script> 
    
      
</body>
</html>