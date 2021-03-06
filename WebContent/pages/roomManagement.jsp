<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="it.project.db.DBClass" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
    <%@ page import="it.project.db.DBClass" %>
    <%@ page import="it.project.dto.*" %>
    <%@ page import="java.util.*" %>
    <%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>

<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    
<title>Room Management</title>
 <!-- link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Lato:400,700,400italic">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto">
     -->
    <style type="text/css"><%@include file="../assets/bootstrap/css/bootstrap.min.css"%></style>
    <style type="text/css"><%@include file="../assets/fonts/font-awesome.min.css"%></style>
    <style type="text/css"><%@include file="../assets/fonts/ionicons.min.css"%></style>
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

<c:set var="profileMap" scope="session" value="<%=DBClass.getProfileMap()%>"/>
<c:set var="roomMap" scope="session" value="<%=DBClass.getRooms()%>"/>
<%session.removeAttribute("profileParam"); %>
<%//System.out.println(DBClass.getRoomLastTemp((String) pageContext.findAttribute("roomId"))); %>
<body>
<div id="load" class="hide"></div>
    <h1 class="d-lg-flex align-items-lg-center" style="background-color: rgb(44,62,80);height: 70px;">
    	<a class="btn btn-primary text-center d-lg-flex" onclick="showLoadingIcon()" href="../index.jsp" style="position:absolute; left: 8px; top: 6px; height: 60px; width: 60px;background-color: rgb(44,62,80);" >
   			<img src="../images/ios-arrow-round-back-white.svg" style="position:absolute; left: 0px; top: 0px; height: 60px; width: 60px;">
   		</a>
        <a class="navbar-brand text-left flex-fill" style="margin-left: 80px;padding-top: 5px;height: auto;font-size: 30px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: 206px;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;">
        	<br>ROOM MANAGEMENT<br><br></a>
         <c:if test="${user eq localUser}">
            <a class="btn btn-light text-center text-primary d-lg-flex justify-content-lg-center align-items-lg-center action-button" onclick="showLoadingIcon()" href="addRoom.jsp" style="height: 55px;font-size: 20px;margin-right: 8px;position:absolute; right: 2px; top:8px; font-family: Roboto, sans-serif;">Add room</a>
         </c:if>  
       
        </h1>
	<ul class="list-group">
		<c:forEach items="${roomMap}" var="roomItem">
		<c:set var="roomId" scope="page" value="${roomItem.key}"/>
		<form action="<%=request.getContextPath()+"/connectToRoom?roomId="%>${roomId}" method='POST'>	
			<li class="list-group-item d-lg-flex justify-content-lg-center align-items-lg-center" style="padding-top: 8px; padding-right: 16px; padding-bottom: 8px; padding-left: 16px; margin-top: 0px; height: 64px;">
				<a class="d-inline-flex flex-shrink-0 flex-fill justify-content-lg-start align-items-lg-center" onclick="showLoadingIcon()" href="roomManagementItem.jsp?roomId=${roomId}" style="font-size: 24px;">${roomItem.value.roomName}</a>
				
				<c:if test="${roomItem.value.connState eq true}">
					<c:set var="roomTemp" value="<%=String.format(Locale.US, \"%.1f\", DBClass.getRoomLastTemp((String) pageContext.findAttribute(\"roomId\")))%>"/>
					<c:if test="${roomTemp eq \"-100.0\"}">
						<c:set var="roomTemp" value="N/A"/>
					</c:if>
					<span class="d-inline-flex" style="font-size: 24px; margin-right: 8px; position: absolute; right: 50px">${roomTemp}�</span>
					<img src="../images/ios-checkmark-circle-green.svg" style="height: 40px; width: 40px;position: absolute; right: 8px">
				</c:if>
				
				<!-- connstate = ${roomItem.value.connState} -->
				<c:if test="${roomItem.value.connState eq false}">
					<button type="submit" class="btn btn-primary" onclick="showLoadingIcon()" style="height: 40px; position: absolute; right: 56px">CONNECT</button>			
					<img src="../images/ios-alert-red.svg" style="height: 40px; width: 40px;position: absolute; right: 8px">
				</c:if>
			</li>
		</form>
		</c:forEach>
	</ul>
	<!-- footer class="d-lg-flex align-items-lg-center" style="background-color: #ecf0f1;vertical-align: middle; position: absolute; bottom: 0px; right: 0px; left: 0px">
     	<a class="btn btn-secondary text-center text-primary bg-light border-primary d-lg-flex" style="height: 60px;padding-top: 6px;margin-left: 8px;margin-bottom: 2px;font-size: 30px;">PREV</a>
     	<a class="btn btn-primary text-center text-primary bg-light d-lg-flex justify-content-lg-center align-items-lg-center" style="height: 60px;padding-top: 6px;margin-right: 2px;margin-bottom: 2px;position: absolute;right: 8px;font-size: 30px;">NEXT</a>
   	</footer> -->
    
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