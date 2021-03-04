<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Purchase Order Slip</title>
     <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

<style> 
 .masterTable td {
    padding-left: 40px;
    font-size:14px;
 }
 input{
 font-size:14px;
 }
 </style>
 
<script type="text/javascript">
/**
 * Ready Function for Initialize textField with default value
 * And Set date in date picker 
 * And Getting session Value
 */
	$(function() 
		{		
			var startDate="${startDate}";
			var startDateOfMonth="${startDateOfMonth}";
			var arr = startDate.split("/");
			Dat=arr[0]+"-"+arr[1]+"-"+arr[2];
			$("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtFromDate" ).datepicker('setDate', startDateOfMonth);
			$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtToDate" ).datepicker('setDate', 'today');
			
			$('#txtSuppCode').blur(function() {
				var code = $('#txtSuppCode').val();
				if(code.trim().length > 0 && code !="?" && code !="/"){
					funSetSupplier(code);
					$('#txtSuppCode').val('');
				}
			});
			funRemRows("tblSupp");
		});
	/**
	 * Reset form
	 */
	function funResetFields()
	{
		location.reload(true);	
	}

	/**
	 * Open Help Form 
	 */
	function funHelp(transactionName)
	{
		fieldName = transactionName;
		if(transactionName=="Topurchaseorder")
		{
//			transactionName="purchaseorder";
		transactionName="purchaseorderslip";
		}
	//	 window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
		 window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
	}

	/**
	 * Set Data after selecting form Help windows
	 */
	function funSetData(code)
	{
		switch(fieldName)
		{
		
		case "purchaseorder":
			
			$("#txtFromPOCode").val(code); 
			funGetDate(code,"dtFromPODate");
			break;
			
		case "Topurchaseorder":
			$("#txtToPOCode").val(code);
			funGetDate(code,"dtToPODate");
			break;
			
	 	case 'suppcode':
	    	funSetSupplier(code);
	        break;
	        
	 	case "purchaseorderslip":
			$("#txtFromPOCode").val(code); 
			funGetDate(code,"dtFromPODate");
			break;
		}
	}
	
	/**Get PO Data
	 */
	function funGetDate(code,filedId)
	{
		var searchUrl="";
		searchUrl=getContextPath()+"/getPODate.html?POCode="+code;
		$.ajax({
	        type: "GET",
	        url: searchUrl,
		    dataType: "text",
		    success: function(response)
		    {
		    	$("#"+filedId).val(response);
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
	
	/**
	 * Set Supplier Data after selecting Help windows
	 */
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
					$("#txtSuppName").text('');
					$("#txtSuppCode").focus();
				} else {
					funfillSupplier(response.strPCode,response.strPName);
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
	
	 /**
	  * Fill Supplier data in grid
	 **/
	 function funfillSupplier(strSuppCode,strSuppName) 
		{
			var table = document.getElementById("tblSupp");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    
		    row.insertCell(0).innerHTML= "<input id=\"cbSuppSel."+(rowCount)+"\" type=\"checkbox\" checked=\"checked\" name=\"suppthemes\" value='"+strSuppCode+"' class=\"suppCheckBoxClass\" />";
		    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"15%\" id=\"strSuppCode."+(rowCount)+"\" value='"+strSuppCode+"' >";
		    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"42%\" id=\"strSuppName."+(rowCount)+"\" value='"+strSuppName+"' >";
		}
	    
		/**
		 * Remove All Row from Grid
		**/
		function funRemRows(tablename) 
		{
			var table = document.getElementById(tablename);
			var rowCount = table.rows.length;
			while(rowCount>0)
			{
				table.deleteRow(0);
				rowCount--;
			}
		}
	 
	    /**
		 * Select All Supplier
		 */
	 	 $(document).ready(function () 
			{
				$("#chkSuppALL").click(function ()
				{
					$(".suppCheckBoxClass").prop('checked', $(this).prop('checked'));
				});
										
			});
	 	
	/**
	 * Checking Validation before submiting the data
	**/
	function funCallFormAction(actionName,object) 
	{	
			if (actionName == 'submit') 
			{
				var spFromDate=$("#txtFromDate").val().split('-');
				var spToDate=$("#txtToDate").val().split('-');
				var FromDate= new Date(spFromDate[2],spFromDate[1]-1,spFromDate[0]);
				var ToDate = new Date(spToDate[2],spToDate[1]-1,spToDate[0]);
				if(!fun_isDate($("#txtFromDate").val())) 
			    {
					 alert('Invalid From Date');
					 $("#txtFromDate").focus();
					 return false;  
			    }
			    if(!fun_isDate($("#txtToDate").val())) 
			    {
					 alert('Invalid To Date');
					 $("#txtToDate").focus();
					 return false;  
			    }
				if(ToDate<FromDate)
				{
				    	alert("To Date Should Not Be Less Than Form Date");
				    	$("#txtToDate").focus();
						return false;		    	
				}
				 var strSuppCode="";
				 $('input[name="suppthemes"]:checked').each(function() {
					 if(strSuppCode.length>0)
						 {
						 	strSuppCode=strSuppCode+","+this.value;
						 }
						 else
						 {
							 strSuppCode=this.value;
						 }
					});
				 /**
				  * set selected supplier code in hiddentext field
				 **/		
				 $("#hidSuppCode").val(strSuppCode);
				 document.forms[0].action = "rptPurchaseOrderSlip.html";
			}
	}
</script>
</head>
<body>
<div class=" container masterTable">
		<label id="formHeading">Purchase Order Slip</label>
       <s:form method="GET" action="rptPurchaseOrderSlip.html" target="_blank">
     
     <div class="row">	
		    <div class="col-md-2"><label id="lblFromDate">From Date</label>
				  <s:input id="txtFromDate" name="fromDate" path="dtFromDate" cssClass="calenderTextBox" style="width:70%;height:50%" required="true" /> 
				     <s:errors path="dtFromDate"></s:errors>
			</div>
			
			<div class="col-md-2"><label id="lblToDate">To Date</label>
				  <s:input id="txtToDate" name="toDate" path="dtToDate" cssClass="calenderTextBox" style="width:70%;height:50%" required="true"/> 
				     <s:errors path="dtToDate"></s:errors>
			</div>
		  <div class="col-md-8"></div>
		  
		<div class="col-md-2"><label>Supplier</label>
				 <input id="txtSuppCode"  ondblclick="funHelp('suppcode')" readonly="true" Class="searchTextBox" style="height:40%"/>
				<label id="txtSuppName"></label>
			</div>
	  <div class="col-md-10"></div>
	  
	 <div class="col-md-12">
		    <div  style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 150px; overflow-x: hidden; overflow-y: scroll;width:55%;">
                  <table id="" class="masterTable"
							style="width: 100%; border-collapse: separate;">
							<tbody>
								<tr bgcolor="#c0c0c0">
									<td width="10%"><input type="checkbox" id="chkSuppALL"
										onclick="funCheckUnchecksupp()" />Select</td>
									<td width="25%">Supplier Code</td>
									<td width="65%">Supplier Name</td>

								</tr>
							</tbody>
				   </table>
				    <table id="tblSupp" class="masterTable"
							style="width: 100%; border-collapse: separate;">
							<tbody>
								<tr bgcolor="#fafbfb">
									<td width="15%"></td>
									<td width="25%"></td>
									<td width="65%"></td>

								</tr>
							</tbody>
					</table>
		    </div>
			</div>
			</div>	
			<br>
		<div class="row">	
			<div class="col-md-2"><label>Purchase Order Code</label>
			       <s:input type ="text" path="strFromDocCode" id="txtFromPOCode" name="strFromPOCode" readonly="true" placeholder="From PO Code"  class="searchTextBox" style="width: 150px;background-position: 127px 5px;" ondblclick="funHelp('purchaseorderslip')"/>
			</div> 
			
			<div class="col-md-2"><br>
			       <input type ="text" id="dtFromPODate" name="dtFromPODate" readonly="readonly"/> 
			</div>
				
			<div class="col-md-2"><br>
			       <s:input type ="text" path="strToDocCode" id="txtToPOCode" name="strToPOCode" readonly="true" placeholder="To PO Code"  class="searchTextBox" style="width: 150px;background-position: 129px 5px;" ondblclick="funHelp('Topurchaseorder')"/> 
			</div>
			
			<div class="col-md-2"><br>
			       <input type ="text" id="dtToPODate" name="dtToPODate" readonly="readonly"/> 
			</div>
		    <div class="col-md-4"></div>
		
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
		<p align="center">
			<input type="submit" value="Submit" onclick="return funCallFormAction('submit',this)"  class="btn btn-primary center-block" class="form_button"/>
			&nbsp; 
			<input type="button" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>
		<s:input type="hidden" id="hidSuppCode" path="strSuppCode"></s:input>
</s:form>
</div>
</body>
</html>