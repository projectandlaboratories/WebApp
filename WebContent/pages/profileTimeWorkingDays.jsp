<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="it.project.dto.*"%>
<%@page import="it.project.enums.*"%>
<%@page import="it.project.utils.ProfileUtil"%>
<%@page import="java.util.*"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
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
<jsp:useBean id="currentProfile" class="it.project.dto.Program" scope="session">  </jsp:useBean>



<%
Program myProgram=((Program) session.getAttribute("currentProfile"));//se non esiste la crea
//prendo parametri dalla pagina precedente
if(request.getParameter("caller") != null && request.getParameter("caller").compareTo("profileDays")==0){
	for(DayName dayName:DayName.values()){
		DayType dayType = DayType.HOLIDAY;

		if(request.getParameter(dayName.toString()) == null){
			dayType = DayType.WORKING;
		}
		myProgram.setDay(dayName, dayType);	
	}
}

//Setto i parametri della pagina corrente
String action = request.getParameter("action");

String wakeupTime="07:00";
String bedTime = "23:00";
String leaveTime = "08:00";
String backTime = "18:00";

if(myProgram.getWakeupTimeW()!=null){//vengo dalla pagina precedente
	wakeupTime=myProgram.getWakeupTimeW();
	bedTime=myProgram.getBedTimeW();
	leaveTime=myProgram.getLeaveTime();
	backTime=myProgram.getBackTime();
}else if(myProgram.getIntervals().get(DayType.WORKING)!=null){
	boolean readTemperature=false;
	if(myProgram.getTemperatureMap()==null){
		readTemperature=true;
	}
	Map<DayMoment, Integer> temperature = new HashMap<>();
	List<Interval> workingIntervals = myProgram.getIntervals().get(DayType.WORKING);
	Collections.sort(workingIntervals);
	boolean wakeleave=false;
	boolean afterMidnight=false;
	for(Interval interval:workingIntervals){
		if(readTemperature){
			temperature.put(interval.getDayMoment(), (int) interval.getTemperature());	
		}
		if(interval.getDayMoment()==DayMoment.HOME){
			
			if(interval.getStartHour()==0 && interval.getStartMin()==0){//il primo intervallo è home
				afterMidnight=true;
				bedTime=ProfileUtil.getTimeString(interval.getEndHour(),interval.getEndMin());
			}else if(!wakeleave){
				wakeleave=true;
				wakeupTime=ProfileUtil.getTimeString(interval.getStartHour(),interval.getStartMin());
				leaveTime=ProfileUtil.getTimeString(interval.getEndHour(),interval.getEndMin());
			}else{
				backTime=ProfileUtil.getTimeString(interval.getStartHour(),interval.getStartMin());
				if(!afterMidnight){
					bedTime=ProfileUtil.getTimeString(interval.getEndHour(),interval.getEndMin());
				}
			}
		}
	}
	if(readTemperature){
		myProgram.setTemperatureMap(temperature);
	}
}




%>

<body>
<div id="load" class="hide"></div>
<h1 class="d-lg-flex align-items-lg-center" style="background-color: rgb(44,62,80);height: 70px;">
    	
        <a class="navbar-brand text-left flex-fill" style="margin-left: 80px;padding-top: 5px;height: auto;font-size: 30px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: 206px;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;">
        	<br>SET WORKING DAY TIME<br><br></a>
        </h1>
 <form action="profileTimeHolidays.jsp?action=<%=action%>" method="POST">          
    <div>
	    <div style="position:absolute; width:50%; height:50%; left:0; padding:2%; text-align:center;">
	    What time do you wake up?<br><br>	    
	    <input type="time" name="wakeup_time" value="<%=wakeupTime%>" style="align: center;" required>
	    </div>
	    
	    <div style="position:absolute; width:50%; height:50%; left:0; top:50%; padding:2%; text-align:center;">
	    What time do you go to bed?<br><br>	    
	    <input type="time" name="bed_time" value="<%=bedTime%>" style="align: center;" required>
	    </div>
	    
	    <div style="position:absolute; width:50%; height:50%;  left:50%; padding:2%; text-align:center;" >
		What time do you leave home?<br><br>	    
	    <input type="time" name="leave_time" value="<%=leaveTime%>" style="align: center;" required>
	    </div>
	    
	    <div style="position:absolute; width:50%; height:50%; top:50%; left:50%; padding:2%; text-align:center;">
		What time do you come back home?<br><br>	    
	    <input type="time" name="back_time" value="<%=backTime%>" style="align: center;" required>
	    </div>
    </div>
    
    
    
    <footer class="d-lg-flex align-items-lg-center" style="height: 60px; background-color: #ecf0f1;vertical-align: middle; position: absolute; right: 0px; left: 0px">
     	<a class="btn btn-light text-center text-primary bg-light d-lg-flex justify-content-lg-center align-items-lg-center" onclick="showLoadingIcon()" href="profileDays.jsp?action=<%=action%>" style="height: 60px;padding-top: 6px;margin-left: 2px; position: absolute;font-size: 30px;">
     		<img src="../images/ios-arrow-round-back-primary.svg"  style="height: 60px;padding-top: 2px;margin-left: 8px;width: 60px; position: absolute; bottom: 2px; left: 0px">                		
     	</a>
     	<button type="submit" class="btn btn-light text-center text-primary bg-light d-lg-flex justify-content-lg-center align-items-lg-center"  onclick="showLoadingIcon()" style="height: 60px;padding-top: 6px;margin-right: 2px; position: absolute;right: 8px;font-size: 30px;">
     		<img src="../images/ios-arrow-round-forward-primary.svg"  style="height: 60px;padding-top: 6px;width: 60px;position: absolute; bottom:2px; right: 0px">                     
     	</button>
   	</footer>
</form>
    
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