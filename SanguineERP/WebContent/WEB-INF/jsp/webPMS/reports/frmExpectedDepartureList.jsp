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
    <title>GRN Slip</title>
    <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
    
    <script type="text/javascript">
    	
    	var fieldName;
    	
    	//Set date in date picker when form is loading or document is reddy or initialize with default value
    	$(function() 
    			{		
    		
    				var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
    		
    				$("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
    				$("#txtFromDate" ).datepicker('setDate', pmsDate);
    				$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
    				$("#txtToDate" ).datepicker('setDate', pmsDate);
    				
    			
    			});
    	
    	//Reset the filed
    	
    
    </script>
  </head>
<body>
   <div class="container masterTable">
		<label id="formHeading">Expected Departure List</label>
    <s:form name="ExpectedDepartureList" method="POST" action="rptExpectedDepartureList.html" target="_blank">
  
	   <div class="row">
		<div class="col-md-2"><label>Property Code</label>
				         <s:select id="strPropertyCode" path="strPropertyCode" items="${listOfProperty}" required="true"></s:select>
		</div>
		
		<div class="col-md-3">
			 <div class="row">
					<div class="col-md-6"><label id="lblFromDate">From Date</label>
				                <s:input id="txtFromDate" name="fromDate"
						path="dtFromDate" cssClass="calenderTextBox" required="true"/> <s:errors
						path="dtFromDate"></s:errors>
					</div>
					<div class="col-md-6"><label id="lblToDate">To Date</label>
				                 <s:input id="txtToDate" name="toDate" path="dtToDate" cssClass="calenderTextBox" required="true"/> 
				                 <s:errors path="dtToDate"></s:errors>
				     </div>
			</div></div>
	        <div class="col-md-7"></div>
	        <div class="col-md-1"><label style="width: 110%;">Report Type</label>
					<s:select id="cmbDocType" path="strDocType">
				    		<s:option value="PDF">PDF</s:option>
				    		<s:option value="XLS">EXCEL</s:option>
				    		<s:option value="HTML">HTML</s:option>
				    		<s:option value="CSV">CSV</s:option>
				    </s:select>
			</div>
	</div>

		<p align="center" style="margin-right:31%">
			<input type="submit" value="Submit" class="btn btn-primary center-block" class="form_button"/>&nbsp;
			 <input type="button" value="Reset" class="btn btn-primary center-block" class="form_button" />
		</p>
<s:input type="hidden" id="hidSuppCode" path="strSuppCode"></s:input>
</s:form>
</div>
</body>
</html>