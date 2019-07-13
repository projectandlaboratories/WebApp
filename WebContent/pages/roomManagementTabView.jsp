<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
    <%@page import="java.util.*"%>
   <%@page import="it.project.dto.Program"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>

<c:choose>
	<c:when test="${param.season eq 'WINTER'}">
		<c:set var="currentProfileWinter" scope="session" value="${profileMap[param.profile]}"/>
		<c:set var="profileParam" value="currentProfileWinter"/>
	</c:when>
	<c:otherwise>
		<c:set var="currentProfileSummer" scope="session" value="${profileMap[param.profile]}"/>
		<c:set var="profileParam" value="currentProfileSummer"/>
	</c:otherwise>
</c:choose>

<body>

	<div style="display: inline-flex">
		<div class="dropdown d-inline-flex">
			<button class="btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-expanded="false" type="button" style="font-size: 20px;">${param.profile}</button>
			<div class="dropdown-menu" role="menu" style="width: 100%">
				<c:forEach items="${profileMap}" var="profileItem">
					<a class="dropdown-item" onclick="showLoadingIcon()"
						href="<%=request.getContextPath()%>/assignProgramToRoom?profile=${profileItem.key}&room=${roomId}&season=${param.season}"
						role="presentation">${profileItem.key}</a>
				</c:forEach>
			</div>
		</div>

		<div style="display: inline-flex; position: absolute; right: 16px;">
			<button class="btn btn-primary d-lg-flex justify-content-lg-start"
				onclick="location.href = 'profileDays.jsp?action=update&profileParam=${profileParam}'" type="button"
				style="font-size: 20px; margin-left: 8px; margin-right: 0px; padding-right: 16px; padding-left: 18px;">Edit</button>
			<button class="btn btn-primary d-lg-flex justify-content-lg-start"
				onclick="location.href = 'profileDays.jsp?action=add'" type="button"
				style="font-size: 20px; margin-left: 8px; padding-right: 16px; padding-left: 16px;">New</button>
		</div>
	</div>


	<div
		style="margin-right: 10%; margin-left: 10%; width: 80%; text-align: center; margin-top: 2%">
		<jsp:include page="profileBars.jsp?profileParam=${profileParam}" />
	</div>

</body>
</html>