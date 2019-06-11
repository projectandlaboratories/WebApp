<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="it.project.dto.*"%>
<%@page import="it.project.enums.*"%>
<%@page import="it.project.utils.ProfileUtil"%>
<%@page import="java.util.*"%>
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

</head>
<%Program myProgram=((Program) session.getAttribute("currentProfile"));
Map<DayName,String> checked = ProfileUtil.getDefaultDays();

if(myProgram!=null && myProgram.getDays().size()!=0){
	for(DayName day:DayName.values()){
		if(myProgram.getDays().get(day).equals(DayType.HOLIDAY))
			checked.put(day,"checked");
		else
			checked.put(day,"");
	}
}
%>
<body>

<h1 class="d-lg-flex align-items-lg-center" style="background-color: rgb(44,62,80);height: 70px;">
    	
        <a class="navbar-brand text-left flex-fill" style="margin-left: 80px;padding-top: 5px;height: auto;font-size: 30px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: 206px;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;">
        	<br>WHAT DAYS ARE YOU AT HOME?<br><br></a>
        </h1>
        
<form action="profileTimeWorkingDays.jsp" method="POST">       
    <div style="transform: scale(1.2); position: absolute; left: 100px;  top: 100px;" >
	    <div class="btn-group btn-group" data-toggle="buttons" >
		    <label class="btn active"> <input type="checkbox" name='<%=DayName.MON%>' <%=checked.get(DayName.MON)%>> <%=DayName.MON%></label>
		    <label class="btn active"> <input type="checkbox" name='<%=DayName.TUE%>' <%=checked.get(DayName.TUE)%>> <%=DayName.TUE%> </label>
		    <label class="btn active"> <input type="checkbox" name='<%=DayName.WED%>' <%=checked.get(DayName.WED)%>> <%=DayName.WED%> </label>
		    <label class="btn active"> <input type="checkbox" name='<%=DayName.THU%>' <%=checked.get(DayName.THU)%>> <%=DayName.THU%> </label>
		    <label class="btn active"> <input type="checkbox" name='<%=DayName.FRI%>' <%=checked.get(DayName.FRI)%>> <%=DayName.FRI%> </label>
		    <label class="btn active"> <input type="checkbox" name='<%=DayName.SAT%>' <%=checked.get(DayName.SAT)%>> <%=DayName.SAT%> </label>
		    <label class="btn active"> <input type="checkbox" name='<%=DayName.SUN%>' <%=checked.get(DayName.SUN)%>> <%=DayName.SUN%></label>		    
	</div>
    </div>
    
    
    <footer class="d-lg-flex align-items-lg-center" style="height: 60px; background-color: #ecf0f1;vertical-align: middle; position: absolute; right: 0px; left: 0px">     	
     	<button type="submit" name="caller" value="profileDays" class="btn btn-light text-center text-primary bg-light d-lg-flex justify-content-lg-center align-items-lg-center" style="height: 60px;padding-top: 6px;margin-right: 2px; position: absolute;right: 8px;font-size: 30px;">
     		<img src="../images/ios-arrow-round-forward-primary.svg"  style="height: 60px;padding-top: 6px;width: 60px;position: absolute; bottom:2px; right: 0px"> <!--  href="profileTimeWorkingDays.jsp" -->                     
     	</button>
   	</footer>
</form>

    
    <script><%@include file="../assets/js/jquery.min.js"%></script> 
    <script><%@include file="../assets/bootstrap/js/bootstrap.min.js"%></script> 
    <script><%@include file="../assets/js/script.min.js"%></script> 
    
 
      
</body>
</html>