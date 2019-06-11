<%@page import="it.project.utils.ProfileUtil"%>
<%@page import="it.project.enums.*"%>
<%@ page import="it.project.dto.*" %>
<%@ page import="java.util.*" %>
 <%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<%
Program program=(Program)session.getAttribute("currentProfile");

Map<DayName,DayType> days = program.getDays();
List<String> workingDays=new ArrayList<>();
List<String> holidayDays=new ArrayList<>();
for(DayName name:DayName.values()){
	if(days.get(name).equals(DayType.WORKING)){
		workingDays.add(name.toString());	
	}else{
		holidayDays.add(name.toString());
	}
}
String workingDaysString=String.join(", ", workingDays);
String holidayDaysString=String.join(", ", holidayDays);

List<Interval> workingIntervals = program.getIntervals().get(DayType.WORKING);
Collections.sort(workingIntervals);
List<Interval> holidayIntervals=program.getIntervals().get(DayType.HOLIDAY);
Collections.sort(holidayIntervals);

ProfileUtil.getDayMomentColors();

pageContext.setAttribute("workingIntervals", workingIntervals);
pageContext.setAttribute("holidayIntervals", holidayIntervals);
%>



<div class="progress beautiful" style="height: 30px;  margin-top: 10px">    	
    	<c:forEach items="${workingIntervals}" var="interval">
	    	<div class="progress-bar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: ${interval.getPercentageOfDay()}%; background-color: ${interval.getColor()};">
		    	<c:if test = "${interval.getPercentageOfDay() > 20}">
		        	<c:out value = "${interval.getIntTemperature()}"/>
		    	</c:if>    	
	    	</div>
    	</c:forEach>  
</div>
<div><%=workingDaysString %></div>


<div class="progress beautiful" style="height: 30px;  margin-top: 10px">    	
    	<c:forEach items="${holidayIntervals}" var="interval">
	    	<div class="progress-bar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: ${interval.getPercentageOfDay()}%; background-color: ${interval.getColor()};">
		    	<c:if test = "${interval.getPercentageOfDay() > 20}">
		        	<c:out value = "${interval.getIntTemperature()}"/>
		    	</c:if>    	
	    	</div>
    	</c:forEach>  
</div>
<div><%=holidayDaysString %></div>
