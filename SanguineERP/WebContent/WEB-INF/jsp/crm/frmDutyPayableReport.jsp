<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
        
		<script type="text/javascript" src="<spring:url value="/resources/js/pagination.js"/>"></script>
		
</head>
<script>

		$(document).ready(function(){
			var startDate="${startDate}";
			var arr = startDate.split("/");
			Dat=arr[2]+"-"+arr[1]+"-"+arr[0];
			$("#dtFromDate").datepicker({
				dateFormat : 'dd-mm-yy'
			});
			$("#dtFromDate").datepicker('setDate', Dat);	
			
			
			$("#dtToDate").datepicker({
				dateFormat : 'dd-mm-yy'
			});
			$("#dtToDate").datepicker('setDate', 'today');	
		});


</script>
<body>
   <div class="container">
		<label id="formHeading">Duty Payable Report</label>
	    <s:form name="DutyPayableReport" method="GET" action="rptDutyPayableReport.html" target="_blank" >
			<div class="row">
				<div class="col-md-3">
					<div class="row">
					<div class="col-md-6"><label>From Date</label>
							<s:input type="text" id="dtFromDate" path="dtFromDate" required="true" class="calenderTextBox" />
					</div>
					<div class="col-md-6"><label>To Date</label>
							<s:input type="text" id="dtToDate" path="dtToDate" required="true" class="calenderTextBox" />
					</div>				
			  </div></div>
			  </div>
	        <br>
			<p align="center" style="margin-right: 64%;">
				<input type="submit" value="Export" class="btn btn-primary center-block" class="form_button" onclick="return funCallFormAction('submit',this)" />&nbsp
				 <input type="button" value="Reset" class="btn btn-primary center-block" class="form_button"  onclick="funResetFields()"/>
			</p>
		</s:form>
	</div>
</body>
</html>