<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Invoicing Printing</title>
 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
	 
<script type="text/javascript">


 $(document).ready(function () {
       
	 var startDate="${startDate}";
		var arr = startDate.split("/");
		Dat=arr[2]+"-"+arr[1]+"-"+arr[0];
		$( "#txtInnFromDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtInnFromDate" ).datepicker('setDate', Dat);
	    /*$("#txtInnFromDate").datepicker({ dateFormat: 'yy-mm-dd' });
		  $("#txtInnFromDate" ).datepicker('setDate', 'today');
		*/
		$("#txtInnFromDate").datepicker();
		
		 $("#txtInnToDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtInnToDate" ).datepicker('setDate', 'today');
			$("#txtInnToDate").datepicker();	
}); 
	/**
	* Reset The Group Name TextField
	**/
	function funResetFields()
	{
		
    }
	
	function funForSingleInnvoice()
	{
		var strcmbCat = $("#cmbTFCat").val();
		
		var strcmbDetor = $("#cmbTFDebtor").val();
		
		if(strcmbCat=="T/F")
			{
			$("#cmbTFDebtor").val("T/F");
			}
		
		if(strcmbCat=="Total")
		{
		$("#cmbTFDebtor").val("Total");
		}
		
		
		if(strcmbCat=="T/F" && strcmbDetor =="T/F")
			{
				
				
				$("#txtCatToCode").val("");
				$("#txtCatToCode").attr("disabled", "disabled"); 
				
				$("#txtMemberToCode").val("");
				$("#txtMemberToCode").attr("disabled", "disabled"); 
				
				$("#txtInvoiceToCode").val("");
				$("#txtInvoiceToCode").attr("disabled", "disabled"); 
				
			}
		
		if(strcmbCat=="Total" && strcmbDetor =="Total")
			{
				$("#txtCatToCode").removeAttr("disabled"); 
	    		$("#txtMemberToCode").removeAttr("disabled"); 
	    		$("#txtInvoiceToCode").removeAttr("disabled"); 
			}
		
		
	}
	
	
</script>


</head>

<body onload="funOnLoad();">
	<div class=" container masterTable">
		<label id="formHeading">Invoicing Printing</label>
        <s:form name="frmInvoicingPrinting" method="GET" action="rptInvoicePrinting.html?saddr=${urlHits}">
	
		<div class="row">
				<div class="col-md-2"><label>T/F Category</label>
						<s:select id="cmbTFCat" name="cmbTFCat" path="strTFCat" class="BoxW124px" onchange="funForSingleInnvoice()">
										<option value="Total">Total</option>
										<option value="T/F">T/F</option>
										</s:select></div>
			
			<div class="col-md-2"><label>Category Form Code</label>
								<s:input id="txtCatFormCode" type="text" path="strCatFormCode" class="BoxW116px"  /></div>
			
			<div class="col-md-2"><label>Category To Code</label>
								<s:input id="txtCatToCode" path="strCatToCode" type="text" class="BoxW116px" /></div>
			
				<div class="col-md-2"><label>T/F Debtor</label>
				                <s:select id="cmbTFDebtor" name="cmbTFDebtor"
											path="strTFDebtor" Class="BoxW124px" onchange="funForSingleInnvoice()" >
											<option value="Total">Total</option>
											<option value="T/F">T/F</option></s:select></div>
			
			<div class="col-md-2"><label>Member Form Code</label>
							<s:input id="txtMemberFormCode" type="text" path="strMemberFormCode" class="BoxW116px" /></div>
			
			<div class="col-md-2"><label>Member To Code</label>
									<s:input id="txtMemberToCode" type="text" path="strMemberToCode" class="BoxW116px" /></div>
			
			<div class="col-md-2"><label>Invoice Form Code</label>
									<s:input id="txtInvoiceFormCode" type="text" path="strInvoiceFormCode" class="BoxW116px" /></div>
			
			<div class="col-md-2"><label>Invoice To Code</label>
									<s:input id="txtInvoiceToCode" type="text" path="strInvoiceToCode" class="BoxW116px" /></div>
			
			<div class="col-md-2"><label>Invoice From Date</label>
								<s:input  id="txtInnFromDate"
											 Class="calenderTextBox" path="strInnFromDate" style="width:60%"/></div>
											 
			<div class="col-md-2"><label>Invoice To Date</label>
									<s:input  id="txtInnToDate"
											 Class="calenderTextBox" path="strInnToDate" style="width:60%"/></div>								 
			
				<div class="col-md-2"><label>Account For</label>
				      <s:select id="cmbAccountFor" name="cmbAccountFor" style="width:100%"
											Class="BoxW124px" path="strAccountFor">
											<option value="Opening Balance">Opening Balance</option>
											<option value="Y">Yes</option>
										</s:select></div>
										
				<div class="col-md-2"><label>Report For</label>
				    <s:select id="cmbReportFor" name="cmbReportFor" style="width:100%"
											Class="BoxW124px" path="strReportFor">
											<option value="Debit Account">Debit Account</option>
											<option value="Credit Account">Credit Account</option>
										</s:select></div>
										
				<div class="col-md-1"><label>Operator</label>
				     <s:select id="cmbOperator" name="cmbOperator"
											Class="BoxW124px"  path="strOperator" >
											<option value=">"> > </option>
											<option value="<"> < </option>
											<option value=">="> >= </option>
											<option value="<="> <= </option>
											<option value="="> = </option>
											<option value="Between"> Between </option>
											<option value=""> <> </option>
										</s:select></div>													
			
			<div class="col-md-2"><label>Amount Form</label>
							<s:input id="txtAmountForm" type="text" class="BoxW116px" path="strAmountForm"/></div>
			
			<div class="col-md-2"><label>Amount To</label>
								<s:input id="txtAmountTo" type="text" class="BoxW116px" path="strAmountTo"/></div>
			
			<div class="col-md-2"><label>MemberShip Expired</label>
				   <s:select id="cmbMemExp" name="cmbMemExp"
											Class="BoxW124px" path="strMemExp">
											<option value="Including">Including</option>
											<option value="Excluding">Excluding</option>
											<option value="Only">Only</option>
										</s:select></div>
										
			<div class="col-md-2"><label>Debtor List</label><br>
			       <s:textarea Style="width:140%; height:32%" id="txtDebtorList" path="strDebtorList"></s:textarea></div>							
											
            <div class="col-md-8"><label>Genration</label><br>
			
		  	<s:radiobutton name="Genration" value="Invoice Via E-mail" path="strGenration" />Invoice Via E-mail &nbsp;
				<s:radiobutton name="Genration" value="Invoice Via Hard Copy" path="strGenration" />Invoice Via Hard Copy &nbsp;
				<s:radiobutton name="Genration" value="Hard Copy for all" path="strGenration"/>Hard Copy for all &nbsp;
				<s:radiobutton name="Genration" value="Duplex Printing" path="strGenration"/>Duplex Printing &nbsp;
				<s:radiobutton name="Genration" value="Genrate" path="strGenration"/>Genrate
						 
			</div>
			</div>
		
		<br />
			<p align="right">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button"  onclick="return funCallFormAction('submit',this);" />&nbsp 
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>
	</s:form>
</div>
</body>
</html>