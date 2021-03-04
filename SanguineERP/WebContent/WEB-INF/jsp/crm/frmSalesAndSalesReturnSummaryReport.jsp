<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Customer And Sub GroupWise Sales Report</title>

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
	<div class=" container transTable">
	    <label id="formHeading">Customer And Sub GroupWise Sales Report</label>
		<s:form name="frmSalesAndSalesReturnSummaryReport" method="GET" action="rpSalesAndSalesReturnSummaryReport.html" target="_blank">
		<div class="row">
			<div class="col-md-3">
				<div class="row">
			   		<div class="col-md-6"><label>From Date </label>
							<s:input id="txtFromDate" path="dteFromDate" required="true" readonly="readonly" cssClass="calenderTextBox"/>
					</div>
					<div class="col-md-6"><label>To Date </label>
							<s:input id="txtToDate" path="dteToDate" required="true" readonly="readonly" cssClass="calenderTextBox"/>
					</div>	
				</div></div>
				<div class="col-md-9"></div>
				<div class="col-md-3" style="padding-left:1%;width:auto;"><label>Report Type </label>
						<s:select id="cmbType" path="strType" style="width:auto;">
						<s:option value="Summary" selected="selected">Summary</s:option>
                    	<s:option value="Sub GroupWise Tax Breakup">Sub GroupWise Tax Breakup</s:option>
                    	<s:option value="Customer And SubGroup Wise Breakup">Customer And SubGroup Wise Breakup</s:option> 
                   </s:select>
                </div>
			    </div>
		<br>
		<p align="center" style="margin-right:65%">
				<input type="submit" value="Submit"  class="btn btn-primary center-block"  class="form_button" />&nbsp;
				 <input type="button" value="Reset"  class="btn btn-primary center-block"  class="form_button"  onclick="funResetFields()"/>
		</p>
	</s:form>
</div>
</body>
</html>