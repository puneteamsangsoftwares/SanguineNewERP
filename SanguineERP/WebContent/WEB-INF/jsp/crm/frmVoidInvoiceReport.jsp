<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Void Bill Report</title>
      <script type="text/javascript" src="<spring:url value="/resources/js/pagination.js"/>"></script>

</head>

<script>


	function funValidateFields()
	{
		var flag=false;
			flag=true;
			var fromDate=$("#dteFromDate").val();
			var toDate=$("#dteToDate").val();
			var against=$("#cmbType").val();
			window.open(getContextPath()+"/voidInvoiceReportSummary.html?fromDate="+fromDate+"&toDate="+toDate+"");
			
		return flag;
		
	}


//set date
		$(document).ready(function(){
			
			var startDate="${startDate}";
			var arr = startDate.split("/");
			Date1=arr[0]+"-"+arr[1]+"-"+arr[2];
			
			$("#dteFromDate").datepicker({
				dateFormat : 'dd-mm-yy'
			});
			$("#dteFromDate").datepicker('setDate', Date1);	
			$("#dteFromDate").datepicker();
			
			$("#dteToDate").datepicker({
				dateFormat : 'dd-mm-yy'
			});
			$("#dteToDate").datepicker('setDate', 'today');	
			$("#dteToDate").datepicker();
		});
		
		
		
		
</script>
<body>
	<div class="container masterTable">
		<label id="formHeading">Void Invoice Report </label>
	<s:form name="frmVoidInvoiceReport" method="GET" action="" >
		<div class="row">
			<div class="col-md-3">
			 <div class="row">
				<div class="col-md-6"><label>From Date</label>
						<s:input type="text" id="dteFromDate" path="dteFromDate" required="true" class="calenderTextBox" />
				</div>
				<div class="col-md-6"><label>To Date</label>
						<s:input type="text" id="dteToDate" path="dteToDate" required="true" class="calenderTextBox" />
				</div>				
			 </div></div>
				
				<div class="col-md-9"></div>
				<div class="col-md-2"><label>Report Type</label>
					<select id="cmbType" style="width:auto;">
				      <option value="PDF">Pdf</option>
				  </select>
				</div>
		</div>
		<br>
	<p align="center" style="margin-right: 65%">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" onclick="return funValidateFields()" />&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>	
	</s:form>
</div>
</body>
</html>