<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>
</head>
<script type="text/javascript">

function funHelp(transactionName)
{
	fieldName=transactionName;
    
  //  window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
    window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;top=500,left=500")
}
function funSetData(code)
{
	$("#txtDNCode").val(code);
}
	
	

</script>
<body>
	<div class="container transTable">
		<label id="formHeading">Delivery Challan Slip Invoice</label>
	<s:form name="frmDeliveryChallanSlipInvoice" method="GET"
		action="rptDeliveryNoteChallanReport.html" >
		<input type="hidden" value="${urlHits}" name="saddr">
		<br>
		
			<div class="row">
				<div class="col-md-2"><label>Delivery Note Code</label>
					<s:input path="strDocCode" id="txtDNCode" ondblclick="funHelp('DNCodeslip')" cssClass="searchTextBox" />
				</div>
				<div class="col-md-10"></div>		
				
				 <div class="col-md-3">
				 <div class="row">		
                <div class="col-md-6"><label>Report Type</label>
					<s:select id="cmbDocType" path="strReportType" cssClass="BoxW124px">
<%-- 						<s:option value="Invoice">Invoice</s:option> --%>
						<s:option value="INVOICE">INVOICE</s:option>
						<s:option value="Challan">Challan</s:option>
					</s:select>
				</div>
				<div class="col-md-6"><label>Export Type</label>
					<s:select id="cmbDocType" path="strExportType" cssClass="BoxW124px">
						<s:option value="PDF">PDF</s:option>
						<s:option value="XLS">XLS</s:option>
					</s:select>
			    </div>
			   </div></div>
		</div>
		
		<br>
		<p align="right" style="margin-right:77%">
			<input type="submit" value="Submit"
				onclick="" class="btn btn-primary center-block"
				class="form_button" /> &nbsp;
			 <a STYLE="text-decoration: none"
				href="frmDeliveryChallanSlipInvoice.html?saddr=${urlHits}"><input
				type="button" id="reset" name="reset" value="Reset" class="btn btn-primary center-block"
				class="form_button" /></a>
		</p>
		<br>
		<div id="wait"
			style="display: none; width: 60px; height: 60px; border: 0px solid black; position: absolute; top: 60%; left: 55%; padding: 2px;">
			<img
				src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif"
				width="60px" height="60px" />
		</div>
	</s:form>
   </div>
</body>
</html>