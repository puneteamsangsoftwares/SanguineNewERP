<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Sub GroupWise Item Sales Report</title>
        <script type="text/javascript" src="<spring:url value="/resources/js/pagination.js"/>"></script>

</head>
<script type="text/javascript">
	$(function() {
		$(document).ajaxStart(function() {
			$("#wait").css("display", "block");
		});
		$(document).ajaxComplete(function() {
			$("#wait").css("display", "none");
		});
		/*$( "#txtFromDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtFromDate" ).datepicker('setDate', 'today');
		*/
		var startDate="${startDate}";
		var arr = startDate.split("/");
		Dat=arr[0]+"-"+arr[1]+"-"+arr[2];
		$( "#txtFromDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtFromDate" ).datepicker('setDate', Dat);
		$( "#txtToDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtToDate" ).datepicker('setDate', 'today');
		
		

	});
</script>
<body>
	<div class="container transTable">
		<label id="formHeading">Sub GroupWise Item Sales Report</label>
	    <s:form name="frmSubGroupWiseItemSalesReport" method="GET" action="rptSubGroupWiseItemSalesReport.html" target="_blank">
		
		     <div class="row">
					<div class="col-md-2"><label>From Date </label>
					        <s:input id="txtFromDate" path="dteFromDate" required="true" readonly="readonly" cssClass="calenderTextBox" style="width:70%;"/>
				    </div>
				    
					<div class="col-md-2"><label>To Date </label>
					        <s:input id="txtToDate" path="dteToDate" required="true" readonly="readonly" cssClass="calenderTextBox" style="width:70%;"/>
					</div>	
			  </div>
<!-- 				<tr> -->
<!-- 					<td><label>Currency </label></td> -->
<%-- 					<td><s:select id="cmbCurrency" items="${currencyList}" path="strCurrency"> --%>
<%-- 						</s:select></td> --%>
<!-- 					<td colspan="2"></td> -->
<!-- 				</tr> -->
		     <br>
		    <p align="center" style="margin-right:57%;">
				<input type="submit" value="Submit"  class="btn btn-primary center-block" class="form_button" />
				 &nbsp;
			    <input type="button" value="Reset" class="btn btn-primary center-block" class="form_button"  onclick="funResetFields()"/>
			</p>
	</s:form>
     </div>
</body>
</html>