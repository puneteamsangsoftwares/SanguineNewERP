<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
  	<link rel="stylesheet" type="text/css" href="default.css" />
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Web Stocks</title>
    
    <script type="text/javascript">
    $(document).ready(function() 
    		{
		    	var startDate="${startDate}";
				var arr = startDate.split("/");
				Dat=arr[2]+"-"+arr[1]+"-"+arr[0];
    			$("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
				$("#txtFromDate" ).datepicker('setDate', Dat);
				$("#txtFromDate").datepicker();
		
		 		$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
				$("#txtToDate" ).datepicker('setDate', 'today');
				$("#txtToDate").datepicker();	
		
		
    		});
    
    function update_FromFulFillmentDate(selecteDate){
		var date = $('#txtFromDate').val();
		$('#txtToDate').val(selecteDate);
	}
    
    </script>
  </head>
  
<body >
  <div class="container masterTable">
		<label id="formHeading">Consolidate CustomerWise Avg SO Report</label>
	    <s:form name="frmConsolidateCustomerWiseAvgSalesOrder" method="GET"  action="consolidateCustomerAvgSOExcel.html" target="_blank"> 
			  <div class="row">
					
					<div class="col-md-2"><label>From Fullfill Date</label>
						 <s:input path="dteFromDate" id="txtFromDate"
							cssClass="calenderTextBox" onchange="update_FromFulFillmentDate(this.value);" style="width:70%"/>
					</div>
											
					<div class="col-md-2"><label>To Fullfill Date</label>
						 <s:input path="dteToDate" id="txtToDate" cssClass="calenderTextBox" style="width:70%"/>
					</div>						
					<div class="col-md-8"></div>
											
					<div class="col-md-2"><label>Report Type</label>
					     <s:select id="cmbDocType" path="strDocType" style="width:auto;">
<%-- 				    		<s:option value="PDF">PDF</s:option> --%>
				    		<s:option value="XLS">EXCEL</s:option>
				    	
				    	</s:select>
					</div>
					
			   <div class="col-md-2"><label>Week Day</label>
		                 <s:select id="cmbDay" path="strWeekDay" style="width:auto;">
<%-- 				    		<s:option value="PDF">PDF</s:option> --%>
				    		<s:option value="2">Monday</s:option> 
				    		<s:option value="3">Tuesday</s:option> 
				    		<s:option value="4">Wednesday</s:option> 
				    		<s:option value="5">Thursday</s:option> 
				    		<s:option value="6">Friday</s:option> 
				    		<s:option value="7">Saturday</s:option> 
				    		<s:option value="1">Sunday</s:option> 	
				    		</s:select>			
			     </div>
			</div>
			<br>
			
			<p align="center" style="margin-right:57%">
				<input type="submit" value="Submit" class="btn btn-primary center-block"  class="form_button"/>
				 &nbsp;
				<input type="button" value="Reset" class="btn btn-primary center-block"  class="form_button"  onclick="funResetFields()"/>
			</p>
		 </s:form>
		 </div>
	</body>
</html>