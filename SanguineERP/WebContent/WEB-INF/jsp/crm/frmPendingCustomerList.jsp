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
					$("#txtFullfillment").datepicker({ dateFormat: 'dd-mm-yy' });
    				$("#txtFullfillment" ).datepicker('setDate', Dat);
    				$("#txtFullfillment").datepicker();
    	 	
    		});
   	</script>
  </head>
  
	<body >
	<div class="container masterTable">
		<label id="formHeading">Pending Customer List</label>
	       <s:form name="frmPendingCustomerList" method="GET" action="rptPendingCustomerList.html" target="_blank">
	
			<div class="row">
					<div class="col-md-2"><label>Fullfillment Date</label>
					      <s:input  id="txtFullfillment" path="dteToFulfillment"   required="required" cssClass="calenderTextBox" style="width:70%"/>
					</div>
					
					<div class="col-md-2"><label>Report Type</label>
							<s:select id="cmbDocType" path="strDocType" style="width:auto">
				    			<s:option value="PDF">PDF</s:option>
				    			<s:option value="XLS">EXCEL</s:option>
				    		</s:select>
					</div>
				
					<!-- <td><input type="submit" value="Submit" /></td>
					<td><input type="reset" value="Reset" onclick="funResetFields()"/></td>	 -->				
			
			    </div>
			<br>
			<p align="right" style="margin-right:77%">
				<input type="submit" value="Submit" class="btn btn-primary center-block" class="form_button"/>&nbsp;
				 <input type="button" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
			</p>
			
		</s:form>
	</div>
	</body>
</html>