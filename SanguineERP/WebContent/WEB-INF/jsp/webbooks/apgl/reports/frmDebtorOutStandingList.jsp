<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@	taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
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
		var glCode = $("#txtGLCode").val();
		if(glCode!='')
		{
			funSetGLCode(glCode);
		}

	});
</script>
<body>
	<div class="container">
		<label id="formHeading">Debtor OutStanding  List</label>
		<s:form name="FLR3AReport" method="GET" action="rptDebtorOutStandingList.html" target="_blank">
		
			<div class="row transTable">
			   <div class="col-md-2">
			    	<label>From Date </label>
					<s:input id="txtFromDate" path="dteFromDate" required="true" readonly="readonly" cssClass="calenderTextBox" style="width:80%;"/>
				</div>
				<div class="col-md-2">
					<label>To Date </label>
					<s:input id="txtToDate" path="dteToDate" required="true" readonly="readonly" cssClass="calenderTextBox" style="width:80%;"/>
				</div>
				<div class="col-md-2">
					<label>Currency </label>
					<s:select id="cmbCurrency" items="${currencyList}" path="strCurrency" style="width:80%;" >
					</s:select>
				</div>
			</div>
		
		<p align="center" style="margin-right: 22%; margin-top: 15px;">
			<input type="submit" value="Submit" class="btn btn-primary center-block" class="form_button" />
			<input type="button" value="Reset" class="btn btn-primary center-block" class="form_button"  onclick="funResetFields()"/>
		</p>
	</s:form>
</div>
</body>
</html>