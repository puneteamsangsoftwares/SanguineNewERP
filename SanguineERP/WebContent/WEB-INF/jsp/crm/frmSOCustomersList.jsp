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
		<label id="formHeading">Sales Orders Customers List Report</label>
			<s:form name="frmSOCustomersList" method="GET" action="rptSOCustomersList.html" target="_blank">
			
			<div class="row">
					<div class="col-md-2"><label>From Fulfillment Date</label>
						<s:input  id="txtFromDate" path="dteFromDate"   required="required" cssClass="calenderTextBox"  onchange="update_FromFulFillmentDate(this.value);" style="width:70%"/>
					</div>
					
					<div class="col-md-2"><label>From Fulfillment Date</label>
						<s:input  id="txtToDate" path="dteToDate"   required="required" cssClass="calenderTextBox" style="width:70%"/>
					</div>
				
					<div class="col-md-2"><label>Report Type</label>
					
						<s:select id="cmbDocType" path="strDocType" style="width:auto;">
				    		<s:option value="PDF">PDF</s:option>
				    		<s:option value="XLS">EXCEL</s:option>
				    	
				    	</s:select>
					</div>
			</div>
			<br>
			<p align="right" style="margin-right:60%">
				<input type="submit" value="Submit" class="btn btn-primary center-block" class="form_button"/>&nbsp;
				 <input type="button" value="Reset" class="btn btn-primary center-block" class="form_button"  onclick="funResetFields()"/>
			</p>
			
		   </s:form>
		</div>
	</body>
</html>