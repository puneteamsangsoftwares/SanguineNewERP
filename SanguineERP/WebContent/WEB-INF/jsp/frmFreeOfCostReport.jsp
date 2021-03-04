<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html.dtd">
<html>
<head>
    <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	
<script>

		$(document).ready(function(){
			var startDate="${startDate}";
			var arr = startDate.split("/");
			Date1=arr[2]+"-"+arr[1]+"-"+arr[0];
			var startDateOfMonth="${startDateOfMonth}";
			var arr1 = startDateOfMonth.split("-");
			Date1=arr1[2]+"-"+arr1[1]+"-"+arr1[0];
			$("#dtFromDate").datepicker({
				dateFormat : 'dd-mm-yy'
			});
			$("#dtFromDate").datepicker('setDate', startDateOfMonth);	
			
			
			$("#dtToDate").datepicker({
				dateFormat : 'dd-mm-yy'
			});
			$("#dtToDate").datepicker('setDate', 'today');	
		});
		
		
		
		function funSetData(code)
		{
			switch(fieldName)
			{
			
			case 'suppcode':
		    	funSetSupplier(code);
		        break;
			}
		}
		
		//Open Help Form
    	function funHelp(transactionName)
		{
			fieldName=transactionName;
		//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1100px;dialogLeft:200px;")
			window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1100px;dialogLeft:200px;")
	    }
		
		  //Get Supplier data
		function funSetSupplier(code) {
			var searchUrl = "";
			searchUrl = getContextPath()
					+ "/loadSupplierMasterData.html?partyCode=" + code;

			$.ajax({
				type : "GET",
				url : searchUrl,
				dataType : "json",
				success : function(response) {
					if ('Invalid Code' == response.strPCode) {
						alert('Invalid Code');
						$("#txtProdCode").val('');
						$("#lblSuppName").text('');
						$("#txtProdCode").focus();
					} else {
											
						$("#txtProdCode").val(response.strPCode);
						$("#lblSuppName").text(response.strPName);
						
					}
				},
				error : function(jqXHR, exception) {
					if (jqXHR.status === 0) {
						alert('Not connect.n Verify Network.');
					} else if (jqXHR.status == 404) {
						alert('Requested page not found. [404]');
					} else if (jqXHR.status == 500) {
						alert('Internal Server Error [500].');
					} else if (exception === 'parsererror') {
						alert('Requested JSON parse failed.');
					} else if (exception === 'timeout') {
						alert('Time out error.');
					} else if (exception === 'abort') {
						alert('Ajax request aborted.');
					} else {
						alert('Uncaught Error.n' + jqXHR.responseText);
					}
				}
			});
		}
    	


</script>
<body>
<div class="container transTable">
		<label id="formHeading">Free Of Cost Report(FOC)</label>
	     <s:form name="frmFreeOfCostReport" method="POST" action="rptFreeOfCostReport.html" target="_blank" >

		<div class="row">
			 <div class="col-md-2"><label>From Date</label>
				    <s:input type="text" id="dtFromDate" path="dteFromDate" required="true" class="calenderTextBox" style="width: 70%;"/>
	         </div>
	         
			 <div class="col-md-2"><label>To Date</label>
				    <s:input type="text" id="dtToDate" path="dteToDate" required="true" class="calenderTextBox" style="width: 70%;" />		
			 </div>
			 <div class="col-md-8"></div>
			 
			 <div class="col-md-2"><label>Report Type</label>
				    <s:select id="cmbViewType" path="strReportView" items="${mapViewType}" style="width:auto;"/>				    	
			 </div>
		</div>
			
		<p align="center" style="margin-right: 57%;">
				<input type="submit" value="Export" class="btn btn-primary center-block" class="form_button" onclick="return funCallFormAction('submit',this)" />
				&nbsp;
			    <input type="button" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
			</p>
		</s:form>
	</div>
</body>
</html>