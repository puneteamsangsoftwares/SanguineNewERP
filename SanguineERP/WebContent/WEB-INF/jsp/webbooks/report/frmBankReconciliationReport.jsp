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
		/*$( "#txtFromDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtFromDate" ).datepicker('setDate', 'today');*/
		var startDate="${startDate}";
		var arr = startDate.split("/");
		Dat=arr[0]+"-"+arr[1]+"-"+arr[2];
		$( "#txtFromDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtFromDate" ).datepicker('setDate', Dat);
		$( "#txtToDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtToDate" ).datepicker('setDate', 'today');
		
		$("#txtBankCode").blur(function() 
				{
					var code=$('#txtBankCode').val();
					if(code.trim().length > 0 && code !="?" && code !="/")
					{
						funSetBankAccountDetails(code);
					}
				});

	});
	
	function funHelp(transactionName)
	{
		fieldName=transactionName;
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
	function funSetData(code)
	{
		switch(fieldName)
		{
		case 'cashBankAccNo' : 
		funSetBankAccountDetails(code);
		break;
		}
	}
	
	// Function to set Bank Account Details
	function funSetBankAccountDetails(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadAccontCodeAndName.html?accountCode=" + code,
			dataType : "json",
			success : function(response){ 
				if(response.strAccountCode=='Invalid Code')
	        	{
	        		alert("Invalid Account Code");
	        		$("#txtBankCode").val('');
	        		$("#lblBankDesc").text('');
	        		$("#txtBankDesc").val('');
	        	}
	        	else
	        	{
	        		$("#txtBankCode").val(response.strAccountCode);
		        	$("#lblBankDesc").text(response.strAccountName);
		        	$("#txtBankDesc").val(response.strAccountName);
		        	
		        	funSetBankBalanceAmt(response.strType);
	        	}
			},
			error : function(e){
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
	
	function funSetBankBalanceAmt(accType){
		var accCode=$("#txtBankCode").val();
		var invDate=$("#txtToDate").val();
		var currencyCode="";
		
			var gurl1=getContextPath()+"/loadBankBalanceAmt.html?accType="+accType+"&accCode="+accCode+"&toDate="+invDate+"&currency="+currencyCode;
			$.ajax({
			    type: "GET",
			    url: gurl1,
			    dataType: "json",
			    success: function(response)
			    {	
			    	var amount = (response).toFixed(maxAmountDecimalPlaceLimit);
			    	if(amount<0)
			    	{
			    		amount="("+amount*-1+")";
			    	}
			    	
			    	$("#txtBalAmt").val(amount);
				},
				error: function(jqXHR, exception) {
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
  <div class=" container transTable">
		<label id="formHeading">Bank Reconciliation Report</label>
	
	<s:form name="frmBankReconciliationReport" method="GET" action="openRptBankReconciliationReport.html" target="_blank">
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
<!-- 					<td><label>Currency </label></td> -->
<%-- 					<td><s:select id="cmbCurrency" items="${currencyList}" path="strCurrency" cssClass="BoxW124px"> --%>
<%-- 						</s:select></td> --%>
				
				<div class="col-md-9"></div>
				<div class="col-md-2"><label>Bank Code</label>
				        <s:input type="text" id="txtBankCode" path="strBankCode" cssClass="searchTextBox" readOnly="true" ondblclick="funHelp('cashBankAccNo');"/>
				</div>
								
				<div class="col-md-3"><label id="lblBankDesc" style="background-color:#dcdada94; width: 100%; height: 42%; margin: 27px 0px;"></label></div>
				<div class="col-md-2"><s:input type="hidden" id="txtBankDesc" path="strBankName"/></div>				
				<div class="col-md-2"><s:input type="hidden" id="txtBalAmt" path="dblBalAmount"/></div>				
					
		</div>
		<br><br>
		<p align="right" style="margin-right:60%;">
				<input type="submit" value="Submit" class="btn btn-primary center-block" class="form_button" />&nbsp
				 <input type="button" value="Reset" class="btn btn-primary center-block" class="form_button"  onclick="funResetFields()"/>
			</p>
	</s:form>
  </div>
</body>
</html>