<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>

        <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	    <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

</head>
<script type="text/javascript">
	$(function() {
		$(document).ajaxStart(function() {
			$("#wait").css("display", "block");
		});
		$(document).ajaxComplete(function() {
			$("#wait").css("display", "none");
		});
		$( "#txtFromDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		$( "#txtToDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		
		$("#txtFromDate" ).datepicker('setDate', 'today');
		$("#txtToDate" ).datepicker('setDate', 'today');

	});
</script>
<body>
	<div class="container">
		<label id="formHeading">Chart Of Account Report</label>
	   <s:form name="ChartOfAccountReport" method="GET" action="rptBalanceSheet.html" target="_blank">


<div class="row">
					<div class="col-md-3">
					<div class="row">
					<div class="col-md-6"><label>From Date </label>
						<s:input id="txtFromDate" path="dteFromDate" required="true" readonly="readonly" style="height:50%" cssClass="calenderTextBox"/>
					</div>
					<div class="col-md-6"><label>To Date </label>
						<s:input id="txtToDate" path="dteToDate" required="true" readonly="readonly" style="height:50%" cssClass="calenderTextBox"/>
					</div>
					</div></div>
				
							
					
		</div>
		<br><br>





		<p align="center">
				<input type="submit" value="View Report" class="btn btn-primary center-block" class="form_button" />
				<!--  <input type="button" value="Reset" class="form_button"  onclick="funResetFields()"/> -->
			</p>
	</s:form>
	</div>
</body>
</html>