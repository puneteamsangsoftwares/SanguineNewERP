<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Invoice Slip</title>
      <script type="text/javascript" src="<spring:url value="/resources/js/pagination.js"/>"></script>

<script type="text/javascript">



$(document).ready(function() 
{
	var startDate="${startDate}";
	var arr = startDate.split("/");
	Dat=arr[2]+"-"+arr[1]+"-"+arr[0];
	$("#txtInvDate").datepicker({ dateFormat: 'dd-mm-yy' });
	$("#txtInvDate" ).datepicker('setDate', Dat);
	$("#txtInvDate").datepicker();
});


function funHelp()
{
	var transactionName='';
	var inv  = $('#cmbPrintFormat').val();
	if(inv=='A4')
		{
//			transactionName='invoice';
		transactionName='invoiceslip';
		}else{
			transactionName='invoiceRetail';
		}
	fieldName = transactionName;
//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;top=500,left=500")
}

 	function funSetData(code)
	{ 
 		$('#txtInvCode').val(code);
	
	}
 	
 	function funCallFormAction() 
	{	
		 var code=$('#txtInvCode').val();
	     var invDate=$('#txtInvDate').val();
	     
	     var prinFormat=$('#cmbPrintFormat').val();
	     
	     var invoiceformat='<%=session.getAttribute("invoieFormat").toString()%>';
	
	if(prinFormat=='A4')
		{
			
		if(invoiceformat=="Format 1")
			{
				window.open(getContextPath()+"/openRptInvoiceSlip.html?rptInvCode="+code,'_blank');
				window.open(getContextPath()+"/openRptInvoiceProductSlip.html?rptInvCode="+code+"&rptInvDate="+invDate,'_blank');
				window.open(getContextPath()+"/rptTradingInvoiceSlip.html?rptInvCode="+code+"&rptInvDate="+invDate,'_blank');
		}
		else
		{
			if(invoiceformat=="Format 2")
			{
				window.open(getContextPath()+"/rptInvoiceSlipFromat2.html?rptInvCode="+code+"&rptInvDate="+invDate,'_blank');
				window.open(getContextPath()+"/rptInvoiceSlipNonExcisableFromat2.html?rptInvCode="+code+"&rptInvDate="+invDate,'_blank');
				window.open(getContextPath()+"/rptDeliveryChallanInvoiceSlip.html?strDocCode="+dccode,'_blank');
			}
			else if(invoiceformat=="Format 5")
			{
				
				window.open(getContextPath()+"/rptInvoiceSlipFormat5Report.html?rptInvCode="+code+"&rptInvDate="+invDate,'_blank');
			}
			else if(invoiceformat=="RetailNonGSTA4")
			{
				window.open(getContextPath()+"/openRptInvoiceRetailNonGSTReport.html?rptInvCode="+code,'_blank');
		    }
			else if(invoiceformat=="Format 6")
			{
				window.open(getContextPath()+"/rptInvoiceSlipFormat6Report.html?rptInvCode="+code+"&rptInvDate="+invDate,'_blank');
			}
			else if(invoiceformat=="Format 7")
			{
				window.open(getContextPath()+"/rptInvoiceSlipFormat7Report.html?rptInvCode="+code+"&rptInvDate="+invDate,'_blank');
			}
			else if(invoiceformat=="Format 8")
			{
				window.open(getContextPath()+"/rptInvoiceSlipFormat8Report.html?rptInvCode="+code+"&rptInvDate="+invDate,'_blank');
			}
			else
		    {
		    	window.open(getContextPath()+"/openRptInvoiceRetailReport.html?rptInvCode="+code,'_blank');
		    }
		}
		
		} 
	if(prinFormat=='40 Col')
	{
 		window.open(getContextPath()+"/opentxtInvoice.html?rptInvCode="+code,'_blank');
 	}
		
		
		
		
		
		
		
		
	else if(invoiceformat == 'Format 4 Inv Ret'){
		
	}
	/* else{
		
		window.open(getContextPath()+"/rptInvoiceSlipFromat2.html?rptInvCode="+code+"&rptInvDate="+invDate,'_blank');
		window.open(getContextPath()+"/rptInvoiceSlipNonExcisableFromat2.html?rptInvCode="+code+"&rptInvDate="+invDate,'_blank');
		
	} */
	}

</script>
<body onload="funOnLoad();">
	<div class="container masterTable">
		<label id="formHeading">Invoice Slip</label>
	    <s:form name="InvoiceSlipForm" method="GET" action="">
	
	       <div class = "row">
					<div class="col-md-2"><label>Invoice Code</label>
						<s:input path="strInvCode" id="txtInvCode" ondblclick="funHelp()"  cssClass="searchTextBox" />
					</div>
											
					<div class="col-md-10"></div>
						
					<div class="col-md-3">
						<div class="row">
						    <div class="col-md-6"><label>Invoice Date</label>
						         <s:input path="dteInvDate" id="txtInvDate" required="required" cssClass="calenderTextBox" />
			                </div>
					        <div class="col-md-6"><label>Print Format</label>
						         <select id="cmbPrintFormat" name="cmbPrintFormat">
								     <option value="A4">Invoice</option>
								     <option value="40 Col">Retail</option>
						         </select>
				           </div>			
					</div></div>
			</div>
			<br>
        <div align="center" style= "margin-right: 66%;">
			<input type="submit" value="Submit"
				onclick="return funCallFormAction()" class="btn btn-primary center-block"
				class="form_button" /> &nbsp; <input type="button"
				id="reset" name="reset" value="Reset" class="btn btn-primary center-block" class="form_button" />
		</div>

</s:form>
</div>
</body>
</html>