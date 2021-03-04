<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
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
	 * Open Help Form 
	 */
    function funHelp(transactionName)
	{
		// window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
    	 window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")	
	}
    
    /**
	 * Set Data after selecting form Help windows
	 */
    function funSetData(code)
	{
    	$("#txtSTCode").val(code);
	}
    
    /**
	 * Checking Validation before submiting the data
	 */
    function funCallFormAction(actionName,object) 
	{	
		
	  if($("#txtSTCode").val()=="")
		{
			alert("Please Enter Stock Posting Code");
			return false;
		}
		else
		{
			if (actionName == 'submit') 
			{
					document.forms[0].action = "rptPhysicalStockPsostingSlip.html";
			}
		}
	}
	</script>
    
  </head>
  
	<body>
	<div class="container masterTable">
		<label id="formHeading">Physical Stock Posting Slip</label>
	    <s:form name="PhysicalStockPostingSlip" method="GET" action="rptPhysicalStockPsostingSlip.html" target="_blank">
	   	    <div class="row">	
		       <div class="col-md-2"><label >Stock Posting Code</label>
			         <s:input id="txtSTCode" path="strDocCode" readonly="true" ondblclick="funHelp('stkpostcodeslip')" cssClass="searchTextBox" cssStyle="width:150px;background-position: 136px 4px;"/>
			   </div>
			   <div class="col-md-10"></div>
			   	
			   <div class="col-md-2"><label>Report Type</label>
					<s:select id="cmbDocType" path="strDocType"  style="width:auto;">
				    		<s:option value="PDF">PDF</s:option>
				    		<s:option value="XLS">EXCEL</s:option>
				    		<s:option value="HTML">HTML</s:option>
				    		<s:option value="CSV">CSV</s:option>
				     </s:select>
				 </div>
		      </div>
			
			<br>
			<p align="center" style="margin-right: 51%;">
				<input type="submit" value="Submit" class="btn btn-primary center-block" class="form_button" onclick="return funCallFormAction('submit',this)" />
				&nbsp;
			    <input type="button" value="Reset" class="btn btn-primary center-block" class="form_button"  onclick="funResetFields()"/>
			</p>
		</s:form>
		</div>
	</body>
</html>