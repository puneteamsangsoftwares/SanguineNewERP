<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta http-equiv="X-UA-Compatible" content="IE=8">
<title></title>
		<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 	
	 	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
<script type="text/javascript">
	
	var fieldName;
	var debtorName='';
	
	$(function() 
	{
		var startDate="${startDate}";
		var arr = startDate.split("/");
		Dat=arr[0]+"-"+arr[1]+"-"+arr[2];
		$( "#txtFromDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtFromDate" ).datepicker('setDate', Dat);
		$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtToDate").datepicker('setDate', 'today');
		var glCode = $("#txtGLCode").val();
		if(glCode!='')
		{
			funSetGLCode(glCode);
		}
		
		$('#txtGLCode').blur(function() {
			var code = $('#txtGLCode').val();
			if(code.trim().length > 0 && code !="?" && code !="/")
			{
				funSetGLCode(code);
			}
		});

		$('#txtFromEmployeeCode').blur(function() {
			var code = $('#txtFromEmployeeCode').val();
			if(code.trim().length > 0 && code !="?" && code !="/")
			{
				funSetEmployeeCode(code);
			}
		});
		
		
		$("#btnExecute").click(function( event )
				{
			 		var propCode='<%=session.getAttribute("propertyCode").toString()%>';
					if($("#txtGLCode").val()=='')
					{
						alert("Enter GL Code!");
						return false;
					}
					if($("#txtFromEmployeeCode").val()=='')
					{
						alert("Enter Employee Code!");
						return false;
					}
					
					var fromDate=$("#txtFromDate").val();
					var toDate=$("#txtToDate").val();
					var table = document.getElementById("tblEmployeeLedgerBill");
					var rowCount = table.rows.length;
					while(rowCount>0)
					{
						table.deleteRow(0);
						rowCount--;
					}
					
					var table1 = document.getElementById("tblEmployeeLedgerBillTot");
					var rowCount1 = table1.rows.length;
					while(rowCount1>0)
					{
						table1.deleteRow(0);
						rowCount1--;
					}
					var glCode = $("#txtGLCode").val();
					var employeeCode =$("#txtFromEmployeeCode").val()
					funGetEmployeeLedger(fromDate,toDate,glCode,employeeCode,propCode);
					return false;
				});

		
		$("#btnExport").click(
				function() {
					var currency=$("#cmbCurrency").val();
					var fromDate = $("#txtFromDate").val();
					var toDate = $("#txtToDate").val();
					var glCode = $("#txtGLCode").val();
					var employeeCode = $("#txtFromEmployeeCode").val();
					if($("#txtFromEmployeeCode").val()=='')
					{
						alert("Enter Employee Code!");
						return false;
					}
					var param1=glCode+","+employeeCode;
					var reportType = $("#cmbReportType").val();
					var ledgerName = "employeeLedger";
					var glName = $("#lblGLCode").text();
					var employeeName = $("#lblFromEmployeeName").text();
					var strShowNarration=document.getElementById("chkShowNarration").checked;
					if(reportType=="EXCEL")
					{
						var propCode='<%=session.getAttribute("propertyCode").toString()%>';
						funGetEmployeeLedgerDataBeforeExport(fromDate,toDate,glCode,employeeCode,propCode);
					    window.location.href = getContextPath()
							+ "/frmExportLedger.html?param1="
							+ param1 + "&fDate=" + fromDate
							+ "&tDate=" + toDate+"&currency="+currency+"&strShowNarration="+strShowNarration;
					}
					else
					{
						window.open(getContextPath()+"/rptEmployeeReport.html?employeeCode="+employeeCode+"&fromDate="+fromDate+"&toDate="+toDate+"&ledgerName="+ledgerName+"&glCode="+glCode+"&glName="+glName+"&employeeName="+employeeName+"&currency="+currency,'_blank');
					}	
					return false;
				});
		
	});
	
	
	function funGetEmployeeLedger(fromDate,toDate,glCode,employeeCode,propCode)
	{
		var currency=$("#cmbCurrency").val();
	
// 		var currValue=funGetCurrencyCode(currency);
		var currValue=1;
		var param1=glCode+","+employeeCode+","+propCode;
		var searchUrl=getContextPath()+"/getEmployeeLedger.html?param1="+param1+"&fDate="+fromDate+"&tDate="+toDate+"&currency="+currency;
		$.ajax({
		        type: "GET",
		        url: searchUrl,
			    dataType: "json",
			    async:false,
			    success: function(response)
			    {
			    	funShowEmployeeLedger(response,currValue);
			    },
				error: function(e)
			    {
			       	alert('Error:=' + e);
			    }
		      });
	}
	
	function funShowEmployeeLedger(response,currValue)
	{
		var strShowNarration=document.getElementById("chkShowNarration").checked;
		var table = document.getElementById("tblEmployeeLedgerBill");
		var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
	    
		row.insertCell(0).innerHTML= "<label>Transaction Date</label>";
		row.insertCell(1).innerHTML= "<label>Transaction Type</label>";
		row.insertCell(2).innerHTML= "<label>Ref No</label>";
		if(strShowNarration){
			row.insertCell(3).innerHTML= "<label>Narration</label>";
			row.insertCell(4).innerHTML= "<label>Chq/BillNo</label>";
			row.insertCell(5).innerHTML= "<label>BillDate</label>";
			row.insertCell(6).innerHTML= "<label>Dr</label>";
			row.insertCell(7).innerHTML= "<label>Cr</label>";
			row.insertCell(8).innerHTML= "<label>Bal</label>";
				
		}else{
			row.insertCell(3).innerHTML= "<label>Chq/BillNo</label>";
			row.insertCell(4).innerHTML= "<label>BillDate</label>";
			row.insertCell(5).innerHTML= "<label>Dr</label>";
			row.insertCell(6).innerHTML= "<label>Cr</label>";
			row.insertCell(7).innerHTML= "<label>Bal</label>";
			
		}
		
		rowCount=rowCount+1;
		//var records = [];
		var bal=0.00;
		var cr=0.00;
		var dr=0.00;
		var opBal=0.00;
		$.each(response, function(i,item)
		{
			var row1 = table.insertRow(rowCount);
			if(item[2]!='')
			{
				var vochDate=item.dteVochDate.split("-");
				vochDate=vochDate[2].split(" ")[0]+"-"+vochDate[1]+"-"+vochDate[0];
				
				var dteBillDate=item.dteBillDate.split("-");
				dteBillDate=dteBillDate[2].split(" ")[0]+"-"+dteBillDate[1]+"-"+dteBillDate[0];
				if(item.strTransType=='Opening')
				{
					dteBillDate='';
					opBal=(parseFloat(item.dblDebitAmt)/currValue)-(parseFloat(item.dblCreditAmt)/currValue);
				}else{
					cr=cr+(parseFloat(item.dblCreditAmt)/currValue);
					dr=dr+(parseFloat(item.dblDebitAmt)/currValue);
					
					
				}
				bal=bal+(parseFloat(item.dblDebitAmt)/currValue)-(parseFloat(item.dblCreditAmt)/currValue);
				var transType="";
				row1.insertCell(0).innerHTML= "<label>"+vochDate+"</label>";
				row1.insertCell(1).innerHTML= "<label>"+item.strTransType+"</label>";
				row1.insertCell(2).innerHTML= "<a id=\"urlDocCode\" href=\"openSlipLedger.html?docCode="+item.strVoucherNo+","+item.strTransType+"\" target=\"_blank\" >"+item.strVoucherNo+"</a>";
				if(strShowNarration){
					row1.insertCell(3).innerHTML= "<label>"+item.strNarration+"</label>";
					row1.insertCell(4).innerHTML= "<label>"+item.strChequeBillNo+"</label>";
					row1.insertCell(5).innerHTML= "<label>"+dteBillDate+"</label>";

					if(item.dblDebitAmt<0){
					row1.insertCell(6).innerHTML= "<label>("+(item.dblDebitAmt/currValue).toFixed(maxQuantityDecimalPlaceLimit)*(-1)+")</label>";
					}else{
						row1.insertCell(6).innerHTML= "<label>"+(item.dblDebitAmt/currValue).toFixed(maxQuantityDecimalPlaceLimit)+"</label>";
					}
					if(item.dblCreditAmt<0){
						row1.insertCell(7).innerHTML= "<label>("+(item.dblCreditAmt/currValue).toFixed(maxQuantityDecimalPlaceLimit)*(-1)+")</label>";
					}else{
						row1.insertCell(7).innerHTML= "<label>"+(item.dblCreditAmt/currValue).toFixed(maxQuantityDecimalPlaceLimit)+"</label>";
					}
					if(bal<0){
					row1.insertCell(8).innerHTML= "<label>("+bal.toFixed(maxQuantityDecimalPlaceLimit)*(-1)+")</label>";
					}else{
						row1.insertCell(8).innerHTML= "<label>"+bal.toFixed(maxQuantityDecimalPlaceLimit)+"</label>";
					}
	
				}else{
					row1.insertCell(3).innerHTML= "<label>"+item.strChequeBillNo+"</label>";
					row1.insertCell(4).innerHTML= "<label>"+dteBillDate+"</label>";

					if(item.dblDebitAmt<0){
					row1.insertCell(5).innerHTML= "<label>("+(item.dblDebitAmt/currValue).toFixed(maxQuantityDecimalPlaceLimit)*(-1)+")</label>";
					}else{
						row1.insertCell(5).innerHTML= "<label>"+(item.dblDebitAmt/currValue).toFixed(maxQuantityDecimalPlaceLimit)+"</label>";
					}
					if(item.dblCreditAmt<0){
						row1.insertCell(6).innerHTML= "<label>("+(item.dblCreditAmt/currValue).toFixed(maxQuantityDecimalPlaceLimit)*(-1)+")</label>";
					}else{
						row1.insertCell(6).innerHTML= "<label>"+(item.dblCreditAmt/currValue).toFixed(maxQuantityDecimalPlaceLimit)+"</label>";
					}
					if(bal<0){
					row1.insertCell(7).innerHTML= "<label>("+bal.toFixed(maxQuantityDecimalPlaceLimit)*(-1)+")</label>";
					}else{
						row1.insertCell(7).innerHTML= "<label>"+bal.toFixed(maxQuantityDecimalPlaceLimit)+"</label>";
					}
				}
				rowCount=rowCount+1;
				
			}	
		});
		
		var table = document.getElementById("tblEmployeeLedgerBillTot");
		var rowCount = table.rows.length;
		var row = table.insertRow(rowCount);
		row.insertCell(0).innerHTML = "<label>Transaction Type</label>";
		row.insertCell(1).innerHTML = "<label>Amount</label>";
		rowCount = rowCount + 1;
	
	    var row1 = table.insertRow(rowCount);
		
		
		row1.insertCell(0).innerHTML = "<label>Opening Balance</label>";
		if(opBal<0)
		{
		row1.insertCell(1).innerHTML = "<label>("+ parseFloat(opBal).toFixed(maxQuantityDecimalPlaceLimit)*(-1) + ")</label>";
		
		}else{
			row1.insertCell(1).innerHTML = "<label>"+ parseFloat(opBal).toFixed(maxQuantityDecimalPlaceLimit) + "</label>";
		}
	

		rowCount = rowCount + 1;
		
		row1 = table.insertRow(rowCount);
		row1.insertCell(0).innerHTML = "<label>Total Debit</label>";
		row1.insertCell(1).innerHTML = "<label>"+ parseFloat(dr).toFixed(maxQuantityDecimalPlaceLimit) + "</label>";
		

		rowCount = rowCount + 1;
		row1 = table.insertRow(rowCount);
		row1.insertCell(0).innerHTML = "<label>Total Credit</label>";
		row1.insertCell(1).innerHTML = "<label>"+ parseFloat(cr).toFixed(maxQuantityDecimalPlaceLimit)+ "</label>";

		rowCount = rowCount + 1;
		row1 = table.insertRow(rowCount);
		row1.insertCell(0).innerHTML = "<label>Closing Balance</label>";
		if(bal<0){
		row1.insertCell(1).innerHTML = "<label>("+ parseFloat(bal).toFixed(maxQuantityDecimalPlaceLimit)*(-1) + ")</label>";
	    }else{
		row1.insertCell(1).innerHTML = "<label>"+ parseFloat(bal).toFixed(maxQuantityDecimalPlaceLimit) + "</label>";
	    }
		
		closingAmt=bal;

	}
	
	function funHelp(transactionName)
	{
		fieldName=transactionName;
	//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
	
	function funSetData(code){

		switch(fieldName){

			case 'EmployeeAccountCode' : 
				funSetGLCode(code);
				break;
				
			case 'employeeCode' : 
				funSetEmployeeCode(code);
				break;
				
			
		}
	}
	
	function funSetGLCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadAccontCodeAndName.html?accountCode=" + code,
			dataType : "json",
			success : function(response){ 
				if(response.strAccountCode!="Invalid Code")
		    	{
					$("#txtGLCode").val(response.strAccountCode);
					$("#lblGLCode").text(response.strAccountName);
					$("#txtFromEmployeeCode").focus();					
		    	}
		    	else
			    {
			    	alert("Invalid Account No");
			    	$("#txtGLCode").val("");
			    	$("#txtGLCode").focus();
			    	$("#lblGLCode").text("");
			    	return false;
			    }
			},
			error : function(e){
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
	
	function funSetEmployeeCode(employeeCode)
	{
	   
		var searchurl=getContextPath()+"/loadEmployeeMasterData.html?employeeCode="+employeeCode;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strEmployeeCode=='Invalid Code')
			        	{
			        		alert("Invalid Employee Code");
			        		$("#txtFromEmployeeCode").val('');
			        		$("#lblFromEmployeeName").text('');
			        	}
			        	else
			        	{					        	    			        	    
			        	   
			        	    $("#txtFromEmployeeCode").val(employeeCode);
			        	    $("#lblFromEmployeeName").text(response.strEmployeeName);
			        	
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

	
	function funGetCurrencyCode(code){

		var amt=1;
		$.ajax({
			type : "POST",
			url : getContextPath()+ "/loadCurrencyCode.html?docCode=" + code,
			dataType : "json",
			async:false,
			success : function(response){ 
				if(response.strCurrencyCode=='Invalid Code')
	        	{
	        		
	        	}
	        	else
	        	{        
	        		amt=response.dblConvToBaseCurr;
		        	
		        	
		        
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
		return amt;
	}
	
	
	function funGetEmployeeLedgerDataBeforeExport(fromDate,toDate,glCode,employeeCode,propCode)
	{
		var currency=$("#cmbCurrency").val();
		var currValue=1;
		var param1=glCode+","+employeeCode+","+propCode;
		var searchUrl=getContextPath()+"/getEmployeeLedger.html?param1="+param1+"&fDate="+fromDate+"&tDate="+toDate+"&currency="+currency;
		$.ajax({
		        type: "GET",
		        url: searchUrl,
			    dataType: "json",
			    async:false,
			    success: function(response)
			    {	
			    },
				error: function(e)
			    {
			       	alert('Error:=' + e);
			    }
		      });
	}
	
</script>

</head>
<body>
	<div class="container">
		<label id="formHeading">Employee Ledger</label>
			<s:form name="EmployeeLedger" method="POST" action="">				
				<div class="row masterTable">
					<div class="col-md-5">
						<label>GL Code</label>
						<div class="row">
							<div class="col-md-5">
								<s:input  type="text" id="txtGLCode" readonly="true" cssClass="searchTextBox" style="height:95%"
									 	path="strGLCode" ondblclick="funHelp('EmployeeAccountCode');"/>
							</div>
							<div class="col-md-7">
								<label id="lblGLCode" style="background-color:#dcdada94; width: 100%; height: 85%;padding-left: 7px;padding-bottom: 3px;padding-top: 3px;"></label>
							</div>
						</div> 
					</div>
					<div class="col-md-7"></div>
					
					<div class="col-md-5">
						<label>Employee Code</label>
						<div class="row">
							<div class="col-md-5">
								<s:input  type="text" id="txtFromEmployeeCode" readonly="true" cssClass="searchTextBox" style="height:95%"
									 	path="strFromEmployeeCode" ondblclick="funHelp('employeeCode');"/>
							</div>
							<div class="col-md-7">
								<label id="lblFromEmployeeName" style="background-color:#dcdada94; width: 100%; height:85%;padding-left: 7px;padding-bottom: 3px;padding-top: 3px;"></label>
							</div>
						</div> 
					</div>
					<div class="col-md-7"></div>
					
					<div class="col-md-3">
						<div class="row">
							<div class="col-md-6">
								<label>From Date</label>
								<s:input  type="text" id="txtFromDate" cssClass="calenderTextBox" style="height:50%" path="dteFromDate"/>
							</div>
							<div class="col-md-6">
								<label>To Date</label>
								<s:input  type="text" id="txtToDate" cssClass="calenderTextBox" style="height:50%" path="dteToDate"/>
							</div>
						</div> 
					</div>
					
					<div class="col-md-4">
						<div class="row">
							<div class="col-md-6">
							<label> Show Narration</label><br>
								<input type="checkbox" id="chkShowNarration" />
							</div>
							<div class="col-md-6"></div>
						</div> 
					</div>
				    <div class="col-md-5"></div> 
					
					<div class="col-md-3">
						<div class="row">
							<div class="col-md-6">
								<label>Currency</label>
								<s:select id="cmbCurrency" path="currency" items="${currencyList}" cssClass="BoxW124px"></s:select>
							</div>
							<div class="col-md-6">
								<label>Report Type</label>
								<s:select id="cmbReportType" path="strReportType" class="BoxW124px" >
									<option value="EXCEL">EXCEL</option>
									<option value="PDF">PDF</option>
								</s:select>
							</div>
						</div> 
					</div>
					
				</div>
					   				
				<div id="paraSubmit" class="center" style="margin-right:60%;">
					<a href="#"><button class="btn btn-primary center-block" id="btnExecute"   value="Execute" 
						class="form_button">Execute</button></a>&nbsp
					<a href="#"><button class="btn btn-primary center-block" value="Export" id="btnExport" 
						class="form_button">Export</button></a>
				</div>
				<div id="dvEmployeeLedgerBill" style="width: 100% ;height: 100% ;">
					<table id="tblCreditorLedgerBill"  class="transTable col2-right col3-right"></table>					
					<table id="tblEmployeeLedgerBill"  class="transTable col5-right col6-right col7-right col8-right col9-right"></table>
				</div>
					<br> <br>
				<div id="dvEmployeeLedgerBillTot" style="width: 30% ;height: 100% ;">
					<table id="tblEmployeeLedgerBillTot" class="transTable col2-right"></table>
				</div>
					
			</s:form> 
	</div>
	 
</body>
</html>
