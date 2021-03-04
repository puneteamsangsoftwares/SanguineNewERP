<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html.dtd">
<html>
<head>
     <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

<script>

		$(document).ready(function(){
			var startDate="${startDate}";
			var arr = startDate.split("/");
			Date1=arr[2]+"-"+arr[1]+"-"+arr[0];
			var startDateOfMonth="${startDateOfMonth}";
			var arr1 = startDateOfMonth.split("-");
			Date1=arr1[2]+"-"+arr1[1]+"-"+arr1[0];
			
			$("#dtFromDate").datepicker({
				dateFormat : 'dd-mm-yy'
			});
			$("#dtFromDate").datepicker('setDate', startDateOfMonth);	
			
			
			$("#dtToDate").datepicker({
				dateFormat : 'dd-mm-yy'
			});
			$("#dtToDate").datepicker('setDate', 'today');	
			
			
			
				
			
			
			});
		
		
		
		function funSetData(code)
		{
			switch(fieldName)
			{
			
			case 'suppcode':
		    	funSetSupplier(code);
		        break;
			}
		}
		
		//Open Help Form
    	function funHelp(transactionName)
		{
			fieldName=transactionName;
		//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1100px;dialogLeft:200px;")
			window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1100px;dialogLeft:200px;")
	    }
		
		  //Get Supplier data
		function funSetSupplier(code) {
			var searchUrl = "";
			searchUrl = getContextPath()
					+ "/loadSupplierMasterData.html?partyCode=" + code;

			$.ajax({
				type : "GET",
				url : searchUrl,
				dataType : "json",
				success : function(response) {
					if ('Invalid Code' == response.strPCode) {
						alert('Invalid Code');
						$("#txtSuppCode").val('');
						$("#lblSuppName").text('');
						$("#txtSuppCode").focus();
					} else {
											
						$("#txtSuppCode").val(response.strPCode);
						$("#lblSuppName").text(response.strPName);
						
					}
				},
				error : function(jqXHR, exception) {
					if (jqXHR.status === 0) {
						alert('Not connect.n Verify Network.');
					} else if (jqXHR.status == 404) {
						alert('Requested page not found. [404]');
					} else if (jqXHR.status == 500) {
						alert('Internal Server Error [500].');
					} else if (exception === 'parsererror') {
						alert('Requested JSON parse failed.');
					} else if (exception === 'timeout') {
						alert('Time out error.');
					} else if (exception === 'abort') {
						alert('Ajax request aborted.');
					} else {
						alert('Uncaught Error.n' + jqXHR.responseText);
					}
				}
			});
		}
    	
		function funResetFields()
		{
			location.reload(true); 
		}

	 	
		function btnSubmit_Onclick() 
		{	
			 // Change ACtion PerForm  
			    
			 if($("#cmbDocType").val()=="XLS")
		     {
				 if($("#cmbViewType").val()=="Supplier Detail")
		  		 {
					     document.frmPurchaseRegisterReport.action = "rptPurchaseRegisterReportInExcel.html";
					  	 document.frmPurchaseRegisterReport.method = "POST";
						// document.frmPurchaseRegisterReport.submit();
		         }
				 else if($("#cmbViewType").val()=="Supplier Summary")
		  		 {
					     document.frmPurchaseRegisterReport.action = "rptPurchaseRegisterSupplierSummaryReportInExcel.html";
					  	 document.frmPurchaseRegisterReport.method = "POST";
						// document.frmPurchaseRegisterReport.submit();
		         }
				 else
				 {
					 document.frmPurchaseRegisterReport.action = " rptPurchaseRegisterReport.html";
				  	 document.frmPurchaseRegisterReport.method = "POST";
					 //document.frmPurchaseRegisterReport.submit();
				 } 
			 } 
			 else
			 {
				 document.frmPurchaseRegisterReport.action = " rptPurchaseRegisterReport.html";
			  	 document.frmPurchaseRegisterReport.method = "POST";
				 //document.frmPurchaseRegisterReport.submit();
			 }
			
		}
		 
		
		
</script>
<body>
<div class="container transTable">
	  <label  id="formHeading">Purchase Register Report</label>
	  <s:form name="frmPurchaseRegisterReport" method="POST" action="" target="_blank" >
<!-- rptPurchaseRegisterReport -->
	   <div class="row">
			 <div class="col-md-2"><label>From Date</label>
				   <s:input type="text" id="dtFromDate" path="dteFromDate" required="true" class="calenderTextBox" style="width: 70%;"/>
		     </div>
		     
			<div class="col-md-2"><label>To Date</label>
				  <s:input type="text" id="dtToDate" path="dteToDate" required="true" class="calenderTextBox" style="width: 70%;"/>				
			</div>
			<div class="col-md-8"></div>
			
			 <div class="col-md-2"><label>Supplier Code</label>
				      <s:input id="txtSuppCode" path="strDocCode" style="height: 51%;" readonly="true"
						cssClass="searchTextBox" ondblclick="funHelp('suppcode')" />
			 </div>
			 
				<div class="col-md-2"><br><label id="lblSuppName" style="font-size: 12px;background-color:#dcdada94; width: 100%; height: 55%;margin-top:7px"> All Supplier </label></div>	
				
				 <div class="col-md-2"><label>Report Type</label>
					     <s:select id="cmbDocType" path="strDocType" style="width:auto;">
				    		<s:option value="PDF">PDF</s:option>
				    		<s:option value="XLS">EXCEL</s:option>
<%-- 				    		           <s:option value="HTML">HTML</s:option> --%>
<%-- 				    		           <s:option value="CSV">CSV</s:option> --%>
				    	 </s:select>
			     </div>	
			     <div class="col-md-6"></div>
			     	
			     <div class="col-md-2"><label>View Type</label>
				        <s:select id="cmbViewType" path="strReportView" items="${mapViewType}" style="width:auto;"/>				    	
				 </div>	
				
				  <div class="col-md-2"><label>Settlement </label>
					   <s:select id="cmbDocType" path="strSettlementName" style="width:auto;">
				    		<s:option value="ALL">ALL</s:option>
				    		<s:option value="CASH">CASH</s:option>
				    		<s:option value="CREDIT">CREDIT</s:option>
                        </s:select>
                  </div>
                  
                   <div class="col-md-2"><label>Property Name </label>
					 <s:select id="strPropertyCode" path="strPropertyCode" items="${listOfProperty}" required="true"></s:select>	
                   </div>
                  					
			</div>
			
			<br>
			<p align="center" style="margin-right: 31%;">
				<!-- <input type="submit" value="Export"  class="btn btn-primary center-block" class="form_button" onclick="return funCallFormAction('submit',this)" /> -->
				<input type="submit" value="Export"  class="btn btn-primary center-block" class="form_button" onclick="return btnSubmit_Onclick()" />
				&nbsp;
			    <input type="button" value="Reset" class="btn btn-primary center-block" class="form_button"  onclick="funResetFields()"/>
			</p>
		</s:form>
	</div>
</body>
</html>