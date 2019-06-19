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
<c:set var="currentProfileWinter" scope="page" value="${roomMap[roomId].winterProfile}"/>
<c:set var="currentProfileSummer" scope="page" value="${roomMap[roomId].summerProfile}"/>

<%session.setAttribute("caller", "roomManagementItem.jsp"); //todo aggiungere eventuale parametro ?nome=cucina%>
<body>
<h1 class="d-lg-flex align-items-lg-center" style="background-color: rgb(44,62,80);height: 70px;">
  	<a class="btn btn-primary text-center d-lg-flex" href="roomManagement.jsp" style="position:absolute; left: 8px; top: 6px; height: 60px; width: 60px;background-color: rgb(44,62,80);" >
 			<img src="../images/ios-arrow-round-back-white.svg" style="position:absolute; left: 0px; top: 0px; height: 60px; width: 60px;">
 		</a>
    <a class="navbar-brand text-left flex-fill" style="margin-left: 80px;padding-top: 5px;height: auto;font-size: 30px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: 206px;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;">
      	<br>${roomMap[roomId].roomName}<br><br></a>
    <button class="btn btn-primary text-center d-lg-flex justify-content-lg-center align-items-lg-center" data-toggle="modal" type="button" data-target="#editRoomPopup" style="height: 70px;margin-left: 8px;width: 60px;background-color: rgb(44,62,80);margin-right: 8px;position: absolute;right: 2px; top: 0px; ">
		<img id="editIcon" src="../images/md-create-white.svg"  style="width:100%;" ></img>
    </button>
</h1>


<!-- Popup -->
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
					<input type="text" name="room_name" value="${roomMap[roomId].roomName}" style="width:100%">
						<div style="display: inline-flex">
							<div class="dropdown d-inline-flex">
								<button type="button" class="btn btn-primary dropdown-toggle" id="modelDropDown"
									data-toggle="dropdown" aria-expanded="false"
									style="font-size: 15px;margin-top: 10px;">${airCondMap[roomMap[roomId].idAirCond]}</button>
								<div class="dropdown-menu" role="menu" style="width: 100%">
									<c:forEach items="${airCondMap}" var="airCondItem">
										<a class="dropdown-item" onclick="changeModelValue('${airCondItem.key}','${airCondItem.value}')" role="presentation">${airCondItem.value}</a>
									</c:forEach>
									
								</div>
							</div>
						</div>
						</div>
						<div class='modal-footer'>
						<button type='button' class='btn btn-secondary'
							data-dismiss='modal'>Close</button>
						<button type='submit' id="editRoomSubmit" name='airCondModel' value="${roomMap[roomId].idAirCond}"
							class='btn btn-primary'>Save</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<div>
        <div>
            <ul class="nav nav-tabs">
                <li class="nav-item flex-fill"><a class="nav-link active d-lg-flex flex-fill justify-content-lg-center" role="tab" href="#tab-1" data-toggle="tab" style="font-size: 20px;text-align:center">Winter</a></li>
                <li class="nav-item flex-fill"><a class="nav-link d-lg-flex flex-fill justify-content-lg-center" href="#tab-2" role="tab" data-toggle="tab" style="font-size: 20px;text-align:center">Summer</a></li>
            </ul>
            
            <div class="tab-content">
                <div class="tab-pane active" role="tabpanel" id="tab-1" style="margin: 16px;">            
	                <jsp:include page="roomManagementTabView.jsp">
	                	<jsp:param name="profile" value="${currentProfileWinter.name}"/>
	                	<jsp:param name="season" value="<%=Season.WINTER%>"/>
	                </jsp:include>			 
               	</div>
               	 
           		<div class="tab-pane" role="tabpanel" id="tab-2" style="margin: 16px;">
                 	<jsp:include page="roomManagementTabView.jsp">
	                	<jsp:param name="profile" value="${currentProfileSummer.name}"/>
	                	<jsp:param name="season" value="<%=Season.SUMMER%>"/>
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
	</script>

    
    <script><%@include file="../assets/js/jquery.min.js"%></script> 
    <script><%@include file="../assets/bootstrap/js/bootstrap.min.js"%></script> 
    <script><%@include file="../assets/js/script.min.js"%></script> 
    
      
</body>
</html>