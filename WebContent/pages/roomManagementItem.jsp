<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
     <%@ page import="it.project.enums.*" %>
     <%@ page import="it.project.db.DBClass" %>
     <%@page import="it.project.dto.Room"%>
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
 	<style type="text/css"><%@include file="../assets/css/mystyle.css"%></style>
 	
 	 <!-- per la keyboard virtuale -->
     <style type="text/css"><%@include file="../assets/css/keyboard.css"%></style>
     <style type="text/css"><%@include file="../assets/css/jquery-ui.min.css"%></style>
 	
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

<c:set var="roomId" scope="session" value="${param.roomId}"/>

<c:set var="currentProfileWinter" scope="page" value="${roomMap[roomId].winterProfile}"/>
<c:set var="currentProfileSummer" scope="page" value="${roomMap[roomId].summerProfile}"/>

<%
String mainRoomId=DBClass.getMainRoomId();
String roomId = (String) session.getAttribute("roomId");
String callerIndex = "roomManagement.jsp";

if((String) request.getParameter("callerIndex")!=null){
	callerIndex="../index.jsp?currentRoom="+roomId;
}
session.setAttribute("caller", "roomManagementItem.jsp?roomId="+roomId);
String deleteDisplay;
String disabled;
String editAirCond;

if(roomId.compareTo(mainRoomId)==0){
	deleteDisplay="none";
	disabled = "disabled";
	editAirCond="none";
}else{
	deleteDisplay="";
	disabled = "";
	editAirCond = "inline-flex";
}

String winterTabClass = "tab-pane active";
String summerTabClass = "tab-pane";
String winterActive="active";
String summerActive="";
String activeTab = (String)session.getAttribute("activeTab");

if(activeTab!=null && activeTab.equals(Season.SUMMER.toString())){
	winterTabClass = "tab-pane";
	summerTabClass = "tab-pane active";
	winterActive="";
	summerActive="active";
}
session.removeAttribute("activeTab");
%>

<body>
<div id="load" class="hide"></div>
<h1 class="d-lg-flex align-items-lg-center" style="background-color: rgb(44,62,80);height: 70px;">
  	<a class="btn btn-primary text-center d-lg-flex" onclick="showLoadingIcon()" href="<%=callerIndex%>" style="position:absolute; left: 8px; top: 6px; height: 60px; width: 60px;background-color: rgb(44,62,80);" >
 			<img src="../images/ios-arrow-round-back-white.svg" style="position:absolute; left: 0px; top: 0px; height: 60px; width: 60px;">
 		</a>
    <a class="navbar-brand text-left flex-fill" style="margin-left: 80px;padding-top: 5px;height: auto;font-size: 30px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: 206px;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;">
      	<br>${roomMap[roomId].roomName}<br><br></a>
    <button <%=disabled%> class="btn btn-primary text-center d-lg-flex justify-content-lg-center align-items-lg-center" data-toggle="modal" type="button" data-target="#deleteRoomPopup"  style="height: 70px;margin-left: 8px;width: 60px;background-color: rgb(44,62,80);margin-right: 8px;position: absolute;right: 62px; top: 0px; ">
		<img id="deleteIcon" src="../images/md-trash-white.svg"  style="display:<%=deleteDisplay%>;width:100%;" ></img>
    </button>
    <button class="btn btn-primary text-center d-lg-flex justify-content-lg-center align-items-lg-center" data-toggle="modal" type="button" data-target="#editRoomPopup" style="height: 70px;margin-left: 8px;width: 60px;background-color: rgb(44,62,80);margin-right: 8px;position: absolute;right: 2px; top: 0px; ">
		<img id="editIcon" src="../images/md-create-white.svg"  style="width:100%;" ></img>
    </button>
</h1>


<!-- Popup edit room-->
	<div class="modal fade" id="editRoomPopup" tabindex="-1"
		role="dialog" aria-labelledby="exampleModalCenterTitle"
		aria-hidden="true">
		<div class='modal-dialog modal-dialog-centered' role='document'>
			<div class='modal-content'>
				<div class='modal-header'>
					<h5 class='modal-title' id='exampleModalLongTitle'>EDIT ROOM</h5>
					<button type='button' class='close' data-dismiss='modal'
						aria-label='Close'>
						<span aria-hidden='true'>&times;</span>
					</button>
				</div>
				
				<c:set var="airCondMap" value="<%=DBClass.getAirCondList()%>"/>
				<form action="<%=request.getContextPath()%>/editRoom?room=${roomId}" method='POST'>
					<div class='modal-body'>
						<input class="keyboard" type="text" name="room_name" value="${roomMap[roomId].roomName}" style="width:100%;background-color:white;color:black;">
						
						<div style="display: <%=editAirCond%>;font-size: 15px;margin-top: 10px;">
							AC model: ${airCondMap[roomMap[roomId].idAirCond]}
						</div>
						<!-- div style="display: <-%=editAirCond%>">
							<div class="dropdown d-inline-flex">
								<button disabled type="button" class="btn btn-primary dropdown-toggle" id="modelDropDown"
									data-toggle="dropdown" aria-expanded="false"
									style="font-size: 15px;margin-top: 10px;">${airCondMap[roomMap[roomId].idAirCond]}</button>
								<div class="dropdown-menu" role="menu" style="width: 100%">
									<c:forEach items="${airCondMap}" var="airCondItem">
										<a class="dropdown-item" onclick="changeModelValue('${airCondItem.key}','${airCondItem.value}')" role="presentation">${airCondItem.value}</a>
									</c:forEach>
									
								</div>
							</div> 
						</div> -->
					</div>
					<div class='modal-footer'>
						<button type='button' class='btn btn-secondary'
							data-dismiss='modal'>Close</button>
						<button type='submit' id="editRoomSubmit" onclick="showLoadingIcon()" name='airCondModel' value="${roomMap[roomId].idAirCond}"
							class='btn btn-primary'>Save</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	
	<!-- Popup delete room-->
	<div class="modal fade" id="deleteRoomPopup" tabindex="-1"
		role="dialog" aria-labelledby="exampleModalCenterTitle"
		aria-hidden="true">
		<div class='modal-dialog modal-dialog-centered' role='document'>
			<div class='modal-content'>
				<div class='modal-header'>
					<h5 class='modal-title' id='exampleModalLongTitle'>DELETE ROOM</h5>
					<button type='button' class='close' data-dismiss='modal'
						aria-label='Close'>
						<span aria-hidden='true'>&times;</span>
					</button>
				</div>
				
				<form action="<%=request.getContextPath()%>/deleteRoom?room=${roomId}" method='POST'>
						<div class='modal-body'>
							ARE YOU SURE YOU WANT TO DELETE THIS ROOM?
						</div>
						<div class='modal-footer'>
						<button type='button' class='btn btn-secondary'
							data-dismiss='modal'>NO</button>
						<button type='submit' id="editRoomSubmit" onclick="showLoadingIcon()"
							class='btn btn-primary'>YES</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<div>
        <div>
            <ul class="nav nav-tabs">
                <li class="nav-item flex-fill"><a class="nav-link <%=winterActive%> d-lg-flex flex-fill justify-content-lg-center" role="tab" href="#tab-1" data-toggle="tab" style="font-size: 20px;text-align:center">Winter</a></li>
                <li class="nav-item flex-fill"><a class="nav-link <%=summerActive%> d-lg-flex flex-fill justify-content-lg-center" href="#tab-2" role="tab" data-toggle="tab" style="font-size: 20px;text-align:center">Summer</a></li>
            </ul>
            
            <div class="tab-content">
                <div class="<%=winterTabClass%>" role="tabpanel" id="tab-1" style="margin: 16px;">            
	                <jsp:include page="roomManagementTabView.jsp">
	                	<jsp:param name="profile" value="${currentProfileWinter.name}"/>
	                	<jsp:param name="season" value="<%=Season.WINTER.name()%>"/>
	                </jsp:include>			 
               	</div>
               	 
           		<div class="<%=summerTabClass %>" role="tabpanel" id="tab-2" style="margin: 16px;">
                 	<jsp:include page="roomManagementTabView.jsp">
	                	<jsp:param name="profile" value="${currentProfileSummer.name}"/>
	                	<jsp:param name="season" value="<%=Season.SUMMER.name()%>"/>
	                </jsp:include>	
               	</div>
            </div>
        </div>
    </div>
    
    <div style="margin-right: 10%; margin-left:10%; width: 80%; text-align: center; margin-top:5%">
    
    	
	
    </div>
    
   
    
   <script type="text/javascript">

	function changeModelValue(id,name){
		var buttonModel = document.getElementById("modelDropDown");
		var buttonSubmit = document.getElementById("editRoomSubmit");
		buttonSubmit.value = id
		buttonModel.innerText = name
	}
	
	  function showLoadingIcon(){
			document.getElementById("load").classList.remove("hide")
		}
	</script>

    <script><%@include file="../assets/js/jquery.min.js"%></script> 
    <script><%@include file="../assets/bootstrap/js/bootstrap.min.js"%></script> 
    <script><%@include file="../assets/js/script.min.js"%></script> 
    
       <!-- per la keyboard virtuale -->
    <script><%@include file="../assets/js/jquery.mousewheel.js"%></script> 
    <script><%@include file="../assets/js/jquery.keyboard.js"%></script>
    <script><%@include file="../assets/js/jquery-ui-custom.min.js"%></script>  
    
    <c:if test="${user eq localUser}">
	    <script>
			$(function(){
				$('.keyboard').keyboard();
			});
		</script>
    </c:if>
      
</body>
</html>