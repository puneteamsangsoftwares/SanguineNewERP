<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
     <%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 
	 	 
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
	
	 	<link rel="stylesheet"  href="<spring:url value="/resources/css/pagination.css"/>" />
	 	<link href="https://fonts.googleapis.com/css?family=Roboto&display=swap" rel="stylesheet">
	 	<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 

	  	
	  	
	  
<title>Search Form</title>
</head>
<body>
<%-- <table  style="border: 1px solid black ;border-spacing:0px;min-height:100%;width: 100%;height: 100%; border-collapse: collapse; cellspecing:0px; cellspadding:0px;">
<tr>
<td height="100%" style="border: 1px;background-color: #D8EDFF;min-height:100%;position:inherit;">
<tiles:insertAttribute name="body"></tiles:insertAttribute>
</td>
</tr>
</table> --%>

<div style="position: fixed; top: 0; left: 0; bottom: 0; right: 0; background-color:#f2f2f2; font-family: 'Roboto', sans-serif;">
    <tiles:insertAttribute name="body"></tiles:insertAttribute>
    </div>
</body>
</html>