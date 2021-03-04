<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Supplier Tax Wise GRN Report</title>
     <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

</head>

<script type="text/javascript">

function funResetFields()
{
	$("#txtSuppCode").focus();
}
$(document).ready(function() 
		{		
		
			var startDate="${startDate}";
			var startDateOfMonth="${startDateOfMonth}";
			var arr = startDate.split("/");
			Date1=arr[0]+"-"+arr[1]+"-"+arr[2];
			$("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtFromDate" ).datepicker('setDate', startDateOfMonth);
			$("#txtFromDate").datepicker();	
			
			 $("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
				$("#txtToDate" ).datepicker('setDate', 'today');
				$("#txtToDate").datepicker();	
				
			
				
		});
		
function formSubmit()
{
    var spFromDate=$("#txtFromDate").val().split('-');
	var spToDate=$("#txtToDate").val().split('-');
	var FromDate= new Date(spFromDate[2],spFromDate[1]-1,spFromDate[0]);
	var ToDate = new Date(spToDate[2],spToDate[1]-1,spToDate[0]);
	
	if($("#txtSuppCode").val()=='')
	{
		 alert("Select Supplier Code");
		 return false;  
	}
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
    else
    {
    	document.forms["frmSupplierTaxWiseGRNReport"].submit();
    }
} 

function funHelp(transactionName)
{
	fieldName = transactionName;
//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	
}


function funSetData(code)
    {
	$.ajax({
		type : "GET",
		url : getContextPath()+ "/loadSupplierMasterData.html?partyCode=" + code,
		dataType : "json",
		success : function(response){ 
			if(response.strDeptCode=='Invalid Code')
        	{
        		alert("Invalid Supplier Code");
        		$("#txtSuppCode").val('');
        	}
        	else
        	{
        		$("#txtSuppCode").val(response.strPCode);
        		$("#lblSuppCode").text(response.strPName);
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
</script>

<body>
<div class="container transTable">
		<label id="formHeading">Supplier Tax Wise GRN Report</label>
       <s:form name="frmSupplierTaxWiseGRNReport" method="POST" action="rptfrmSupplierTaxWiseGRNReport.html" >
			<input type="hidden" value="${urlHits}" name="saddr">
            <br />
	   	<div class="row">
	   		
			 <div class="col-md-2"><label>From Date :</label>
					<s:input id="txtFromDate" path="dtFromDate" required="true" readonly="readonly" cssClass="calenderTextBox" style="width:70%"/>
			</div>
			
			 <div class="col-md-2"><label>To Date :</label>
					<s:input id="txtToDate" path="dtToDate" required="true" readonly="readonly" cssClass="calenderTextBox" style="width:70%"/>
			</div>	
			<div class="col-md-8"></div>
			
			<div class="col-md-2"><label >Supplier</label>
				   <s:input id="txtSuppCode"  path="strSuppCode" style="background-color: #fff;" readonly="true" ondblclick="funHelp('suppcodeActive')" cssClass="searchTextBox jQKeyboard form-control"/>
			</div>
			
			<div class="col-md-2">
			       <label id="lblSuppCode" style="font-size: 12px;background-color:#dcdada94; width:115%; height:51%;margin-top: 27px;padding:4px;"></label> 
			</div>
			<div class="col-md-8"></div>
				
			<div class="col-md-2"><label>Report Type :</label>
				<s:select id="cmbDocType" path="strDocType" style="width:auto;">
				    	
				    		<s:option value="XLS">EXCEL</s:option>
				    		<%-- <s:option value="HTML">HTML</s:option> --%>
				    		<%-- <s:option value="CSV">CSV</s:option> --%>
				</s:select>
			</div>
		</div>
		 
			<br>
			<p align="center" style="margin-right: 45%;">
				 <input type="button" value="Submit" onclick="return formSubmit();" class="btn btn-primary center-block" class="form_button" />
				 &nbsp;
				 <input type="button" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>			     
			</p>
		</s:form>
		</div>
</body>
</html>