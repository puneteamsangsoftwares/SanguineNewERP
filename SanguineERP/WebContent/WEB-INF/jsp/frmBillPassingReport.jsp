<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<html>
  <head>
  	<link rel="stylesheet" type="text/css" href="default.css" />
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Web Stocks</title>
    <script type="text/javascript">
    	
    	var fieldName;
    
    	//Reset Field After Clicking Reset Button
    	function funResetFields()
    	{
    		$("#txtBPCode").val('');
    	}
    	
    	// Open Help
    	function funHelp(transactionName)
		{
			fieldName=transactionName;
			// window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	    	window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
		}
		// Set Bill Passing data 
		function funSetData(code)
		{
			$("#txtBPCode").val(code);
		}
		
		
    
    </script>
  </head>
  
  <body>
	<div class="container">
		<label id="formHeading">Bill Passing</label>
	    <s:form name="frmBillPassingReport" method="GET" action="rptBillPassingReport.html" target="_blank">
			 <div class="row masterTable">
						<div class="col-md-2"><label>Bill passing Code</label>
					        <s:input  id="txtBPCode" path="strDocCode" ondblclick="funHelp('BillPassing')" cssClass="searchTextBox" cssStyle="width:150px;background-position: 136px 4px;"/>
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
			<br>
			<p align="center" style="margin-right:66%;">
				<input type="submit" value="Submit" class="btn btn-primary center-block" class="form_button"/>
				&nbsp;
			    <input type="button" value="Reset" class="btn btn-primary center-block" class="form_button"  onclick="funResetFields()"/>
			</p>
			
		</s:form>
	</div>
	</body>
</html>