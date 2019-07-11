<%@page import="it.project.enums.ActuatorState"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="it.project.db.DBClass" %>
    <%@ page import="java.util.*" %>
    <%@ page import="com.google.gson.*"%>
    <%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<!DOCTYPE html>

<%
//TEMPERATURE CHART
Gson gsonObj = new Gson();
Map<Object,Object> mapTemp = null;
List<Map<Object,Object>> temperatureChartList = new ArrayList<Map<Object,Object>>();
Map<String,Double> temperaturePerDay = DBClass.getLastMonthTemperature(request.getParameter("room"));

for(String key : temperaturePerDay.keySet()){
	mapTemp = new HashMap<Object,Object>(); 
	mapTemp.put("label", key); mapTemp.put("y", temperaturePerDay.get(key));
	temperatureChartList.add(mapTemp);
}

NavigableMap<Integer,String> chartsMap = new TreeMap<Integer,String>();
chartsMap.put(1, gsonObj.toJson(temperatureChartList));
chartsMap.put(2, "actuatorChart");

Integer currentChart = Integer.parseInt(request.getParameter("chart"));
Integer nextKey = chartsMap.higherKey(currentChart);
if(nextKey==null)
	nextKey=chartsMap.firstKey();

Integer prevKey = chartsMap.lowerKey(currentChart);
if(prevKey==null)
	prevKey=chartsMap.lastKey();

%>


<%
//ACTUATOR CHART
Gson gsonObjAct = new Gson();
Map<Object,Object> map = null;
List<Map<Object,Object>> hotList = new ArrayList<Map<Object,Object>>();
List<Map<Object,Object>> coldList = new ArrayList<Map<Object,Object>>();
List<Map<Object,Object>> offList = new ArrayList<Map<Object,Object>>();
int totSecondInDay = 24*60*60;
Map<String,Map<String,Float>> actuatorStatePerDay = DBClass.getLastMonthActuators(request.getParameter("room"));

for(String day : actuatorStatePerDay.keySet()){
	Map<String,Float> actuatorsSecondsMap = actuatorStatePerDay.get(day);
	for(String state : actuatorsSecondsMap.keySet()){
		map = new HashMap<Object,Object>(); 
		map.put("label", day); map.put("y", (actuatorsSecondsMap.get(state)/totSecondInDay)*100); 
		switch(state){
			case "HOT":
				hotList.add(map);
				break;
			case "COLD":
				coldList.add(map);
				break;
			case "OFF":
				offList.add(map);
				break;
		}
	}
}

String hotDataPoints = gsonObj.toJson(hotList);
String coldDataPoints = gsonObj.toJson(coldList);
String offDataPoints = gsonObj.toJson(offList);
%>


<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">  
<title>Statistics</title>

     <style type="text/css"><%@include file="../assets/bootstrap/css/bootstrap.min.css"%></style>
    <style type="text/css"><%@include file="../assets/fonts/font-awesome.min.css"%></style>
    <style type="text/css"><%@include file="../assets/fonts/ionicons.min.css"%></style>
    <style type="text/css"><%@include file="../assets/css/Sidebar-Menu-1.css"%></style>
    <style type="text/css"><%@include file="../assets/css/Sidebar-Menu.css"%></style>
    <style type="text/css"><%@include file="../assets/css/styles.css"%></style>
    <script><%@include file="../assets/js/jquery.min.js"%></script> 
    <script><%@include file="../assets/js/jquery.canvasjs.min.js"%></script> 
    <script><%@include file="../assets/bootstrap/js/bootstrap.min.js"%></script> 
    <script><%@include file="../assets/js/script.min.js"%></script> 

	<script>
	window.onload = function() { 
		
		
		if(<%=currentChart%> == 1){
			 
			var chart = new CanvasJS.Chart("chartContainer", {
				theme: "light2",
				height: 330,
				title: {
					text: "Last Month temperature"
				},
				axisX: {
					title: "Day"
				},
				axisY: {
					title: "Temperature"
				},
				data: [{
					type: "line",
					yValueFormatString: "#,##0°",
					dataPoints : <%=chartsMap.get(currentChart)%>
				}]
			});
		}
		else{
			var chart = new CanvasJS.Chart("chartContainer", {
				animationEnabled: true,  	
				title:{
					text: "Last Month actuator status"
				},
				axisY: {
					suffix: "%"
				},
				toolTip: {
					shared: true,
					reversed: true
				},
				legend: {
					reversed: true,
					horizontalAlign: "right",
					verticalAlign: "center"
				},
				data: [{
					type: "stackedColumn100",
					name: "COLD",
					showInLegend: true,
					yValueFormatString: "#,##0\"%\"",
					dataPoints: <%out.print(coldDataPoints);%>
				},
				{
					type: "stackedColumn100",
					name: "HOT",
					showInLegend: true,
					yValueFormatString: "#,##0\"%\"",
					dataPoints: <%out.print(hotDataPoints);%>
				},
				{
					type: "stackedColumn100",
					name: "OFF",
					showInLegend: true,
					yValueFormatString: "#,##0\"%\"",
					dataPoints: <%out.print(offDataPoints);%>
				}]
			});
		}
		
		
		chart.render();
		 
		}
</script>
</head>
<body>
  <h1 class="d-lg-flex align-items-lg-center" style="background-color: rgb(44,62,80);height: 70px;">
    	<a class="btn btn-primary text-center d-lg-flex" href="../index.jsp" style="position:absolute; left: 8px; top: 6px; height: 60px; width: 60px;background-color: rgb(44,62,80);" >
   			<img src="../images/ios-arrow-round-back-white.svg" style="position:absolute; left: 0px; top: 0px; height: 60px; width: 60px;">
   		</a>
        <a class="navbar-brand text-left flex-fill" style="margin-left: 80px;padding-top: 5px;height: auto;font-size: 30px;margin-top: 0px;margin-bottom: 0px;min-width: auto;width: 206px;line-height: 22px;color: rgb(255,255,255);font-family: Roboto, sans-serif;">
        	<br>STATISTICS<br><br></a>
        	
      </h1>
      
      <!-- TODO PRENDERE COME PARAMETRO IL ROOM -->
      <button onclick = "window.location='<%=request.getContextPath()%>/pages/statistics.jsp?room=${param.room}&chart=<%=prevKey%>'" class="btn btn-light text-center text-primary bg-light d-lg-flex justify-content-lg-center align-items-lg-center" style="height: 60px; width: 60px; top:50%; position: absolute;left: 1%;;font-size: 30px;">
     		<img src="../images/ios-arrow-round-back-primary.svg"  style="height: 60px;padding-top: 6px;width: 60px;position: absolute; bottom:2px; right: 0px">                   
      </button>
      <button onclick = "window.location='<%=request.getContextPath()%>/pages/statistics.jsp?room=${param.room}&chart=<%=nextKey%>'" class="btn btn-light text-center text-primary bg-light d-lg-flex justify-content-lg-center align-items-lg-center" style="height: 60px; width: 60px; top:50%; position: absolute;right: 1%;font-size: 30px;">
     		<img src="../images/ios-arrow-round-forward-primary.svg"  style="height: 60px;padding-top: 6px;width: 60px;position: absolute; bottom:2px; right: 0px">                   
      </button>
     	
     	
      	<div style="display: inline-flex">
		<div class="dropdown d-inline-flex">
			<button class="btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-expanded="false" type="button" style="font-size: 17px;margin-left:25%; margin-top:5%">${roomMap[param.room].roomName}</button>
			<div class="dropdown-menu" role="menu" style="width: 100%">
				<c:forEach items="${roomMap}" var="roomItem">
					<a class="dropdown-item"
						href="<%=request.getContextPath()%>/pages/statistics.jsp?room=${roomItem.key}"
						role="presentation">${roomMap[roomItem.key].roomName}</a>
				</c:forEach>
			</div>
		</div>
      </div>
      <div style="height: 70%;width: 70%; margin: 0px auto;">
      	<div id="chartContainer" ></div>
      </div>  	
      
</body>
</html>