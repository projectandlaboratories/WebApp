<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
     <%@ page import="it.project.enums.*" %>
     <%@ page import="it.project.db.DBClass" %>
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

<c:set var="roomId" scope="session" value="${param.roomId}"/>
<c:set var="currentProfileWinter" scope="page" value="<%=DBClass.getRoomProfile(request.getParameter(\"roomId\"), Season.WINTER)%>"/>
<c:set var="currentProfileSummer" scope="page" value="<%=DBClass.getRoomProfile(request.getParameter(\"roomId\"), Season.SUMMER)%>"/>


<%session.setAttribute("caller", "roomManagementItem.jsp"); //todo aggiungere eventuale parametro ?nome=cucina%>
<body>
<h1 class="d-lg-flex align-items-lg-center" style="background-color: rgb(44,62,80);height: 70px;">
    	<a class="btn btn-primary text-center d-lg-flex" href="roomManagement.jsp" style="position:absolute; left: 8px; top: 6px; height: 60px; width: 60px;background-color: rgb(44,62,80);" >
   			<img src="../images/ios-arrow-round-back-white.svg" style="position:absolute; left: 0px; top: 0px; height: 60px; width: 60px;">
   		</a>
        <a class="navbar-brand text-left flex-fill" style="margin-left: 80px;padding-top: 5px;height: auto;font-size: 30px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: 206px;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;">
        	<br>${param.roomName}<br><br></a>
        </h1>
        
        
	<div>
        <div>
            <ul class="nav nav-tabs">
                <li class="nav-item flex-fill"><a class="nav-link active d-lg-flex flex-fill justify-content-lg-center" role="tab" href="#tab-1" data-toggle="tab" style="font-size: 20px;text-align:center">Winter</a></li>
                <li class="nav-item flex-fill"><a class="nav-link d-lg-flex flex-fill justify-content-lg-center" href="#tab-2" role="tab" data-toggle="tab" style="font-size: 20px;text-align:center">Summer</a></li>
            </ul>
            
            <div class="tab-content">
                <div class="tab-pane active" role="tabpanel" id="tab-1" style="margin: 16px;">            
	                <jsp:include page="roomManagementTabView.jsp">
	                	<jsp:param name="profile" value="${currentProfileWinter}"/>
	                	<jsp:param name="season" value="<%=Season.WINTER%>"/>
	                </jsp:include>			 
               	</div>
               	 
           		<div class="tab-pane" role="tabpanel" id="tab-2" style="margin: 16px;">
                 	<jsp:include page="roomManagementTabView.jsp">
	                	<jsp:param name="profile" value="${currentProfileSummer}"/>
	                	<jsp:param name="season" value="<%=Season.SUMMER%>"/>
	                </jsp:include>	
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