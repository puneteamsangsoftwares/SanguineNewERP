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
    	
    	var fieldName;
    
    	/**
		 * Reset function  
		 */
    	function funResetFields()
    	{
    		$("#txtMRCode").val('');
    	}
    	
    	/**
		 * Open Help window 
		 */
    	function funHelp(transactionName)
		{
			fieldName=transactionName;
		//	 window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
			 window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;top=500,left=500")
	    }
    	
    	/**
		 * Set data after selecting help window
		 */
		function funSetData(code)
		{
			$("#txtMRCode").val(code);
		}
    
    </script>
  </head>
  
	<body >
	<div class="container masterTable">
		<label id="formHeading">Material Return Detail</label>
	    <s:form name="materialReturn" method="GET" action="rptMaterialReturnDetail.html" target="_blank">
			<div class="row">	
		         <div class="col-md-2"><label>Material Return Code</label>
					<s:input  id="txtMRCode" readonly="true" path="strDocCode" ondblclick="funHelp('MaterialReturnslip')" cssClass="searchTextBox" cssStyle="width:150px;background-position: 136px 4px;"/>
				 </div>
				<div class="col-md-10"></div>
				
		        <div class="col-md-2"><label>Report Type</label>
					  <s:select id="cmbDocType" path="strDocType" style="width:45%">
				    		<s:option value="PDF">PDF</s:option>
				    		<s:option value="XLS">EXCEL</s:option>
				    		<s:option value="HTML">HTML</s:option>
				    		<s:option value="CSV">CSV</s:option>
				      </s:select>
				
					<!-- <td><input type="submit" value="Submit" /></td>
					<td><input type="reset" value="Reset" onclick="funResetFields()"/></td>	 -->				
				</div>
			</div>
			<br>
			<p align="center" style="margin-right:65%">
				<input type="submit" value="Submit"  class="btn btn-primary center-block" class="form_button"/>
				&nbsp;
				<input type="button" value="Reset"  class="btn btn-primary center-block" class="form_button"  onclick="funResetFields()"/>
			</p>
			
		</s:form>
		</div>
	</body>
</html>