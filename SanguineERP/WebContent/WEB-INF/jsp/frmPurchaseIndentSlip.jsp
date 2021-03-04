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
    <title>Purchase Indent Slip</title>
    
     <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
    
    <script type="text/javascript">
    	
    	var fieldName;
    	/**
    	 * Ready Function for Initialize textField with default value
    	 * And Set date in date picker 
    	 **/
    	$(function() 
    			{	
		    		var startDate="${startDate}";
		    		var startDateOfMonth="${startDateOfMonth}";
					var arr = startDate.split("/");
					Dat=arr[0]+"-"+arr[1]+"-"+arr[2];
    				$("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
    				$("#txtFromDate" ).datepicker('setDate', startDateOfMonth);
    				$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
    				$("#txtToDate" ).datepicker('setDate', 'today');
    			});
    	
    	/**
    	 * Rest textfield value
    	 **/
    	function funResetFields()
    	{
    		$("#txtFromPICode").val("");
    		$("#txtToPICode").val("");
    	}
    	
    	/**
    	 * Open Help form
    	 **/
    	function funHelp(transactionName)
		{
			fieldName=transactionName;
			if(transactionName=="ToPICode")
			{
// 				transactionName="PICode";
				transactionName="PICodeslip";
			}
		//	 window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
			 window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
	    }
		
    	/**
    	 *  Get Data from help Selection 
    	**/
		function funSetData(code)
		{
			if(fieldName=="PICode")
			{
//	 			if(fieldName=="PICode")
				if(fieldName=="PICodeslip")	
				 {
					
				 }	
				
			}
			if(fieldName=="ToPICode")
			{
				$("#txtToPICode").val(code);
			}
			
		}
    	
		/**
		* Checking Validation when user Click On Submit Button
		**/
		function funCallFormAction(actionName,object) 
		{	
			var spFromDate=$("#txtFromDate").val().split('-');
			var spToDate=$("#txtToDate").val().split('-');
			var FromDate= new Date(spFromDate[2],spFromDate[1]-1,spFromDate[0]);
			var ToDate = new Date(spToDate[2],spToDate[1]-1,spToDate[0]);
			if(!fun_isDate($("#txtFromDate").val())) 
		    {
				 alert('Invalid From Date');
				 $("#txtFromDate").focus();
				 return false;  
		    }
		    if(!fun_isDate($("#txtToDate").val())) 
		    {
				 alert('Invalid To Date');
				 $("#txtToDate").focus();
				 return false;  
		    }
			if(ToDate<FromDate)
			{
				 alert("To Date Should Not Be Less Than Form Date");
			     $("#txtToDate").focus();
				 return false;		    	
			}
			if (actionName == 'submit') 
			{
					document.forms[0].action = "rptPISlip.html";
			}
		}
    
    </script>
  </head>
<body>
  <div class="container masterTable">
	 <label id="formHeading">Purchase Indent Slip</label>
	  <s:form name="PISlip" method="GET" action="rptPISlip.html" target="_blank">

	  <div class="row">	
		    <div class="col-md-2"><label id="lblFromDate">From Date</label>
				  <s:input id="txtFromDate" name="fromDate" path="dtFromDate" cssClass="calenderTextBox" style="width:70%;" required="true"/> <s:errors
						   path="dtFromDate"></s:errors>
		     </div>
			
			<div class="col-md-2"><label id="lblToDate">To Date</label>
				<s:input id="txtToDate" name="toDate" path="dtToDate" cssClass="calenderTextBox" style="width:70%;" required="true"/>
			    <s:errors path="dtToDate"></s:errors>
			</div>
		   <div class="col-md-8"></div>
		   
		  <div class="col-md-2"><label>PI Code</label>
		         <s:input type ="text" path="strFromDocCode" id="txtFromPICode" name="strFromPICode" readonly="true" placeholder="From PI Code"  class="searchTextBox" style="width: 118px;background-position: 104px 2px;" ondblclick="funHelp('PICodeslip')"/> 
		  </div>
		   
		  <div class="col-md-2"><br>
		         <s:input type ="text" path="strToDocCode" id="txtToPICode" name="strToPICode" readonly="true" placeholder="To PI Code"  class="searchTextBox" style="width: 118px;background-position: 104px 2px;" ondblclick="funHelp('ToPICode')"/> 
		  </div>
	      <div class="col-md-8"></div>
	      
	      <div class="col-md-2"><label>Report Type</label>
				<s:select id="cmbDocType" path="strDocType" style="width:auto;">
				    		<s:option value="PDF">PDF</s:option>
				    		<s:option value="XLS">EXCEL</s:option>
				    		<s:option value="HTML">HTML</s:option>
				    		<s:option value="CSV">CSV</s:option>
				</s:select>
	     </div>
      </div>
<br>
		<p align="center" style="margin-left:-57%">
			<input type="submit" value="Submit" onclick="return funCallFormAction('submit',this)"  class="btn btn-primary center-block" class="form_button"/>
			&nbsp;
		   <input type="button" value="Reset"  class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>

</s:form>
</div>
</body>
</html>