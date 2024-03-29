<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=8"/>
	
	  
<script>

		$(document).ready(function(){
			/* var startDate="${startDate}";
			var arr = startDate.split("/");
			Date1=arr[2]+"-"+arr[1]+"-"+arr[0];
			var startDateOfMonth="${startDateOfMonth}";
 	    	var arr1= startDateOfMonth.split("-");
 			Dat=arr1[2]+"-"+arr1[1]+"-"+arr1[0];
			$("#dtFromDate").datepicker({
				dateFormat : 'dd-mm-yy'
			});
			$("#dtFromDate").datepicker('setDate', Dat); */	
			
			var date = new Date(); 
			var month=date.getMonth()+1;
            Dat= 1 +"-"+month+"-"+date.getFullYear();
			
			$("#dtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#dtFromDate").datepicker('setDate',Dat);
			
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
		

		function funExecuteData()
		{
			var fromDate=document.getElementById("dtFromDate").value;
			var toDate=document.getElementById("dtToDate").value;
			var suppCode=document.getElementById("txtSuppCode").value;
			var typeofBill=document.getElementById("cmbBillType").value;
		
			var searchurl=getContextPath()+"/loadBillPassingFlash.html?fromDate="+fromDate+"&toDate="+toDate+"&suppCode="+suppCode+"&typeofBill="+typeofBill;
			
			$.ajax({
				type : "GET",
				url : searchurl,
				dataType : "json",
				success : function(response) {
					
					funResetFieldTable();
					var table = document.getElementById("tblSupplierBillFlash");
					var rowCount ="";
					var rowCount = table.rows.length;
				    var row = table.insertRow(rowCount);
				/* 	row.insertCell(0).innerHTML= "<label width=\"10%\">Supplier Name </label>";
					row.insertCell(1).innerHTML= "<label width=\"10%\">Bill No</label>";
					row.insertCell(2).innerHTML= "<label  width=\"10%\" >GRN Date</label>";
				    row.insertCell(3).innerHTML= "<label width=\"10%\" >GRN No</label>"; 
					row.insertCell(4).innerHTML= "<label width=\"10%\" >Amount</label>"; */
					var suppName="Supplier Name";
					var billNo="Bill No";
					var grnDate="GRN Date";
					var grnNo="GRN No";
					var settlementType="Settlement Type";
					row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"35%\" id=\"Headerfield1."+(rowCount)+"\" value= '"+suppName+"'/>";
        	    	row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"13%\" id=\"Headerfield2."+(rowCount)+"\" value='"+billNo+"'/>";
        		    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"15%\" id=\"Headerfield2."+(rowCount)+"\" value= '"+grnDate+"' />";
        		    row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"18%\" id=\"Headerfield3."+(rowCount)+"\" \" value= '"+grnNo+"' />";
        		    if(typeofBill=="Passed Bills")
        		    {
             		    row.insertCell(4).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"14%\" id=\"Headerfield4."+(rowCount)+"\"  value= '"+settlementType+"' />"; //text-align: right;
        		    	row.insertCell(5).innerHTML= "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right\" size=\"12%\" id=\"Headerfield4."+(rowCount)+"\"  value= Amount />"; //text-align: right;
        		    }
        		    else
        		    {
        		    	row.insertCell(4).innerHTML= "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right\" size=\"12%\" id=\"Headerfield4."+(rowCount)+"\"  value= Amount />"; //text-align: right;

        		    }
        		   
					
					rowCount=rowCount+1;
					$.each(response, function(i,item)
			 		{
					
	            		var row = table.insertRow(rowCount);
	            	
	            	    	row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"35%\" id=\"field1."+(rowCount)+"\" value='"+response[i].strPName+"'/>";
	            	    	row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"13%\" id=\"field2."+(rowCount)+"\" value='"+response[i].strBillNo+"'/>";
	            		    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"15%\" id=\"field3."+(rowCount)+"\" value='"+response[i].dtGRNDate+"'/>";
	            		    row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"18%\" id=\"field4."+(rowCount)+"\" \" value='"+response[i].strGRNNo+"'/>";
	            		    if(typeofBill=="Passed Bills")
	            		    {
		            		    row.insertCell(4).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"14%\"  id=\"field4."+(rowCount)+"\"  value='"+response[i].strSettlementType +"'/>"; //text-align: right;
		            		    row.insertCell(5).innerHTML= "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right\"  size=\"12%\"  id=\"field4."+(rowCount)+"\"  value='"+response[i].dblAmount +"'/>"; //text-align: right;
	            		    }
	            		    else
	            		    {
		            		    row.insertCell(4).innerHTML= "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right\" size=\"12%\"  id=\"field4."+(rowCount)+"\"  value='"+response[i].dblAmount +"'/>"; //text-align: right;

	            		    	
	            		    }	
	            			rowCount++;
						
					});
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
			
			return false;
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
		  
		  function funResetField() {
			     $("#dtFromDate").val(" ");
		    	 $("#dtToDate").val(" ");
		    	 $("#txtSuppCode").val(" ");
		    	 $("#cmbBillType").val(" ");
			  $("#tblSupplierBillFlash tbody").empty();
			
		}
		  
		  function funResetFieldTable() {
			  $("#tblSupplierBillFlash tbody").empty();
		  }
    	


</script>
<body>
	<div class="container">
		<label id="formHeading">Bill Passing Flash</label>
		<s:form name="frmBillPassingFlash" method="POST" action="rptBillPassingFlash.html" target="_blank" >
	
		<div class="row transTable">
			<div class="col-md-2">
				<label>From Date</label>
				<s:input type="text" id="dtFromDate" path="dteFromDate" required="true" class="calenderTextBox" style="width:80%;"/>
			</div>	
			<div class="col-md-2">
				<label>To Date</label>
				<s:input type="text" id="dtToDate" path="dteToDate" required="true" class="calenderTextBox" style="width:80%;"/>			
			</div>	
			<div class="col-md-2">
				<label>Supplier Code</label>
				<s:input id="txtSuppCode" path="strDocCode"
						cssClass="searchTextBox" ondblclick="funHelp('suppcode')" />
			</div>
			<div class="col-md-2">
				<label style="background-color:#dcdada94; width: 190%; height: 42%; margin: 23px 0px; text-align: center;" id="lblSuppName">All Supplier </label>	
			</div>
			<div class="col-md-4"></div>	
			<div class="col-md-2">	
				<label>Report Type</label>
				<s:select id="cmbDocType" path="strDocType" style="width:80%;">
				    <s:option value="EXCEL">EXCEL</s:option>
<%-- 				<s:option value="HTML">HTML</s:option> --%>
<%-- 				<s:option value="CSV">CSV</s:option> --%>
				 </s:select>
			</div>	
			<div class="col-md-2">
				<label>Type of Bill</label>
				<s:select id="cmbBillType" path="strBillType" cssClass="BoxW124px">
					<s:option value="Pending Bills">Pending Bills</s:option>
					<s:option value="Passed Bills">Passed Bills</s:option>
	<%-- 			<s:option value="HTML">HTML</s:option> --%>
	<%-- 			<s:option value="CSV">CSV</s:option> --%>
				</s:select>
			</div>
		</div>
		<div id="paraSubmit" class="center" style="margin-right: 40%;">
			<a href="#"><button class="btn btn-primary center-block" value="Execute" onclick="return funExecuteData()"
				class="form_button">Execute</button></a>
			<a href="#"><button class="btn btn-primary center-block" value="Export" onclick="return funCallFormAction('submit',this)"
				class="form_button">Export</button></a>
			<a href="#"><button class="btn btn-primary center-block" value="Reset" onclick="funResetField()"
				class="form_button">Reset</button></a>
		</div>
			
			<div id="dvSupplierBillFlash" style="width: 100% ;height: 100% ;display:block;">
				<table id="tblSupplierBillFlash" class="transTablex" style="border:1px solid #000; background:gainsboro;width: 100%;font-size:11px;font-weight: bold; border:#0F0;table-layout:fixed;"></table>			
			</div>
		
			
</s:form>
</div>
</body>
</html>