<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
  	<link rel="stylesheet" type="text/css" href="default.css" />
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Web Stocks</title>
     <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
    
    <script type="text/javascript">
	    /**
		 * Global variable
		 */
    	var fieldName;
    
    	 /**
    	 * Reset Field
    	 */
    	function funResetFields()
    	{
    		$("#txtSACode").val('');
    	}
    	
    	 /**
    	 * Open help window
    	 */
    	function funHelp(transactionName)
		{
			fieldName=transactionName;
		//	 window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
			 window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
	    }
    	/**
		 * Set Data after selecting form Help windows
		 */
		function funSetData(code)
		{
			$("#txtSACode").val(code);
		}
    	
    	/**
		 * Checking Validation before submiting the data
		 */
		function funCallFormAction(actionName,object) 
		{	
			
		  if($("#txtSACode").val()=="")
			{
				alert("Please Enter Stock Adjustment Code");
				return false;
			}
			else
			{
				if (actionName == 'submit') 
				{
						document.forms[0].action = "rptStockAdjustmentSlip.html";
				}
			}
		}
    
    </script>
  </head>
  
	<body >
	<div class="container masterTable">
	  <label id="formHeading">Stock Adjustment Slip</label>
	    <s:form name="stkAdjSlip" method="GET" action="rptStockAdjustmentSlip.html" target="_blank">
	
	    <div class="row">	
		        <div class="col-md-2"><label>Stock Adjustment Code</label>
					<s:input  id="txtSACode" path="strDocCode" readonly="true" ondblclick="funHelp('stkadjcodeslip')" cssClass="searchTextBox" cssStyle="width:150px;background-position: 136px 4px;"/>
				</div>
				<div class="col-md-10"></div>
				
				<div class="col-md-2"><label>Report Type</label>
					    <s:select id="cmbDocType" path="strDocType" style="width:auto;">
				    		<s:option value="PDF">PDF</s:option>
				    		<s:option value="XLS">EXCEL</s:option>
				    		<s:option value="HTML">HTML</s:option>
				    		<s:option value="Text">40Column</s:option>
				    	</s:select>
				 </div>
		
				<div class="col-md-2"><label>Report Format</label>
					     <s:select id="cmbReportType" path="strReportType" style="width:auto;">
				    		<s:option value="List">List Wise</s:option>
				    		<s:option value="Recipe">Recipe Wise</s:option>
				    		
				    	</s:select>
				 </div>
			 </div>
			
			<br>
			<p align="center" style="margin-right: 59%;">
				<input type="submit" value="Submit" onclick="return funCallFormAction('submit',this)" class="btn btn-primary center-block" class="form_button"/>
				 &nbsp;
				<input type="button" value="Reset" class="btn btn-primary center-block" class="form_button"  onclick="funResetFields()"/>
			</p>
			
		</s:form>
		</div>
	</body>
</html>