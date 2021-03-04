<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
  	<link rel="stylesheet" type="text/css" href="default.css" />
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Web Stocks</title>
    <script type="text/javascript">
    
    /**
	 * Open help window
	 */
	var fieldName="";	
	function funHelp(transactionName)
	{
		fieldName=transactionName;
		 window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;top=500,left=500")
	
	}
	
	
	/**
	 * Set Data after selecting form Help windows
	 */
	function funSetData(code)
	{					
		var searchUrl="";			
		switch (fieldName)
		{
	
			case 'dscode':
				funSetDSCode(code);					
			break;
		
		}
	}
	
	
	/**
	 * Get and set DS Code
	 */
	function funSetDSCode(code)
	{
		var searchUrl="";
		searchUrl=getContextPath()+"/loadDSCode.html?dsCode="+code;			
		$.ajax({
		        type: "GET",
		        url: searchUrl,
			    dataType: "json",
			    success: function(response)
			    {
			    	$("#txtDSCode").val(response.strDSCode);
			    	
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
  </head>
  
	<body >
	<div class="container">
		<label id="formHeading">Delivery Schedule Slip</label>
	    <s:form name="DeliverScheduleSlip" method="GET" action="rptDeliveryScheduleSlip.html" target="_blank">
			<div class="row masterTable">
			
				 <div class="col-md-2"><s:label path="strDSCode">DS Code</s:label>
					    <s:input id="txtDSCode" name="txtDSCode" path="strDSCode"
						ondblclick="funHelp('dscode')" cssClass="searchTextBox" ></s:input>
	             </div>
					
				 <div class="col-md-2"><label>Report Type</label>
						    <s:select id="cmbDocType" path="strDocType" style="width:auto;">
					    		<s:option value="PDF">PDF</s:option>
					    		<s:option value="XLS">EXCEL</s:option>
					    		<s:option value="HTML">HTML</s:option>
					    		<s:option value="CSV">CSV</s:option>
					    	</s:select>
				 </div>
			</div>
			
			<br/>
			<p align="center" style="margin-right:66%;">
				<input type="submit" value="Submit" class="btn btn-primary center-block" class="form_button" />
				&nbsp;
				<input type="button" class="btn btn-primary center-block" value="Reset" class="form_button" />
			</p>
			<br/>
		
		</s:form>
		</div>
	</body>
</html>