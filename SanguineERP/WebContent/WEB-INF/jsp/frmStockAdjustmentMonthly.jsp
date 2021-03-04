<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
  	<link rel="stylesheet" type="text/css" href="default.css" />
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Web Stocks</title>
     <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
    
    <script type="text/javascript">
	  
    	var fieldName;
    	
    	$(function() 
    			{ 
			    	$("#txtLocCode").val("${locationCode}");
			    	$("#lblLocName").text("${locationName}");  
			    	var startDateOfMonth="${startDateOfMonth}";
			    	var startDate="${startDate}";
					var arr = startDate.split("/");
					Date1=arr[0]+"-"+arr[1]+"-"+arr[2]; 
			    	$("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
					$("#txtFromDate" ).datepicker('setDate', startDateOfMonth);
					
					$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
					$("#txtToDate" ).datepicker('setDate', 'today');
    			});
    	
    	
    	function funHelp(transactionName)
		{
			fieldName=transactionName;
		//	 window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
			 window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
	    }
    	
		/**
		* Get and set Location Data Passing value(Location Code)
	    **/
		function funSetLocation(code)
		{
			var searchUrl="";
			searchUrl=getContextPath()+"/loadLocationMasterData.html?locCode="+code;			
			$.ajax({
			        type: "GET",
			        url: searchUrl,
				    dataType: "json",
				    success: function(response)
				    {
				    	if(response.strLocCode=='Invalid Code')
				       	{
				       		alert("Invalid Location Code");
				       		$("#txtLocCode").val('');
				       		$("#lblLocName").text("");
				       		$("#txtLocCode").focus();
				       	}
				       	else
				       	{
				    	$("#txtLocCode").val(response.strLocCode);
		        		$("#lblLocName").text(response.strLocName);	
		        		$("#txtProdCode").focus();
				       	}
				    },
				    error: function(jqXHR, exception) {
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
		
		function funSetData(code)
		{
			switch (fieldName) 
			{
			    case 'locationmaster':
			    	funSetLocation(code);
			        break;
			}
		}
		
		function funCallFormAction() 
		{	
			if($("#txtLocCode").val()=='')
				{
					return false;
				}
			
			/* else
					{
					var reportView =$("#cmbReportView").val();
					if(reportView=='Recipe')
						{
							document.stkAdjSlip.action = "rptStockAdjustmentMonthly.html";
							document.stkAdjSlip.submit();
						}else
							{
								document.stkAdjSlip.action = "rptStockAdjustmentMonthlyList.html";
								document.stkAdjSlip.submit();
							}
					} */
			
		}
    
    </script>
  </head>
  
	<body >
	<div class="container masterTable">
		<label id="formHeading">Stock Adjustment Report</label>
	  <s:form name="stkAdjSlip" method="GET" action="rptStockAdjustmentMonthly.html" target="_blank">
	 
	 <div class="row">
			 <div class="col-md-2"><label>From Date</label>
					<s:input  id="txtFromDate" path="dtFromDate"  cssClass="calenderTextBox" style="width: 70%;height:50%"/>
			 </div>
			 
			 <div class="col-md-2"><label>To Date</label>
					<s:input  id="txtToDate" path="dtToDate" cssClass="calenderTextBox" style="width: 70%;height:50%"/>
			 </div>
			<div class="col-md-8"></div>	
				
			 <div class="col-md-2"><label>Location</label>
					<s:input id="txtLocCode" path="strLocationCode" readonly="true" cssClass="searchTextBox" ondblclick="funHelp('locationmaster')" ></s:input>
			 </div>
				
			 <div class="col-md-2"><label id="lblLocName" style="background-color:#dcdada94; width: 100%; height:53%;padding:4px;margin-top:26px;"></label>
			 </div>
			<div class="col-md-8"></div>	
			
			<div class="col-md-2"><label>Stock Adjustment From</label>
					<s:select id="cmbReportType" path="strReportType" style="width:auto;">
				    		<s:option value="POS">POS</s:option>
				    		<s:option value="Physical Stock">Physical Stock</s:option>
				    		<s:option value="Manually">Manually</s:option>
				    </s:select>
			</div>
					
			 <div class="col-md-2"><label>Report view</label>
					<s:select id="cmbReportView" path="strReportView" style="width:auto;">
				    		<s:option value="Recipe">Recipe Wise</s:option>
				    		<s:option value="List">List Wise</s:option>
				    		
				    		
				    	</s:select>
			 </div>	
			<div class="col-md-8"></div>	
				
			<div class="col-md-2"><label>Report Type</label>
					<s:select id="cmbDocType" path="strDocType" style="width:auto;">
				    		<s:option value="PDF">PDF</s:option>
				    		<s:option value="XLS">EXCEL</s:option>
				    </s:select>
			 </div>
		</div>
	
			<p align="center" style="margin-right: 48%;">
				<input type="submit" value="Submit" class="btn btn-primary center-block" class="form_button"/>
				 &nbsp;
				<input type="button" value="Reset" class="btn btn-primary center-block" class="form_button"  onclick="funResetFields()"/>
			</p>
			
		</s:form>
		</div>
	</body>
</html>