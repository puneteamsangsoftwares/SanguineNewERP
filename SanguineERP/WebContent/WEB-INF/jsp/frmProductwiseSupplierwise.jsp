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
    
    /**
	 * Ready Function for Initialize textField with default value
	 * And Set date in date picker 
	**/
    $(function() 
			{	
		    	var startDate="${startDate}";
		    	var startDateOfMonth="${startDateOfMonth}";
				var arr = startDate.split("/");
				Date1=arr[0]+"-"+arr[1]+"-"+arr[2];
				$("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
				$("#txtFromDate" ).datepicker('setDate', startDateOfMonth);
				$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
				$("#txtToDate" ).datepicker('setDate', 'today');
			});
    	var fieldName;
    
    	/**
    	 * Reset field
    	 */
    	function funResetFields()
    	{
    		$("#txtSuppCode").val('');
    		$("#txtSuppName").text('');
    	}
    	
    	/**
    	 * Get project path
    	 */
    	function getContextPath() 
    	{
    		return window.location.pathname.substring(0, window.location.pathname.indexOf("/",2));
    	}
    	
    	/**
    	 * Open help
    	 */
    	function funHelp(transactionName)
		{
			fieldName=transactionName;
		//	 window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:700px;dialogLeft:300px;")
			 window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:700px;dialogLeft:300px;")
	    }
    	
    	/**
    	 * Set data from help windows
    	 */
		function funSetData(code)
		{
			$("#txtSuppCode").val(code);
			funSetSupplier(code);
		
		}
    	
		/**
    	 * Set supplier data passing value pary code(supplier code)
    	 */
		function funSetSupplier(code)
		{
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
						$("#txtSuppCode").val(response.strPCode);
						$("#txtSuppName").text(response.strPName);
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
    	 * Textfield on blur event
    	 */
		$(function() 
		{
			$('#txtSuppCode').blur(function() {
				var code = $('#txtSuppCode').val();
				if(code.trim().length > 0 && code !="?" && code !="/"){
					funSetSupplier(code);
				}
			});
		});
		//Check Validation when User Submit the Data
		function formSubmit()
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
			    	alert("To Date is not < Form Date");
			    	$("#txtToDate").focus();
					return false;		    	
			}
		    else
		    {
		    		document.forms["frmProductwiseSupplierwise"].submit();
		    }
	    } 
    </script>
  </head>
  
	<body >
	<div class="container masterTable">
		<label id="formHeading">Productwise Supplierwise</label>
	    <s:form name="frmProductwiseSupplierwise" method="GET" action="rptProductwiseSupplierwise.html" target="_blank">
		
		<div class="row">
			 <div class="col-md-2"><label id="lblFromDate">From Date</label>
				<s:input id="txtFromDate" name="fromDate" path="dtFromDate" cssClass="calenderTextBox" style="width: 70%;" required="true"/> 
				<s:errors path="dtFromDate"></s:errors>
			 </div>
			
			 <div class="col-md-2"><label id="lblToDate">To Date</label>
				 <s:input id="txtToDate" name="toDate" path="dtToDate" cssClass="calenderTextBox" style="width: 70%;" required="true"/> 
				 <s:errors path="dtToDate"></s:errors>
			 </div>
			<div class="col-md-8"></div>
						
			<div class="col-md-2"><label>Supplier Code</label>
					<s:input  id="txtSuppCode" path="strDocCode" readonly="true" ondblclick="funHelp('suppcode')" cssClass="searchTextBox" cssStyle="width:150px;background-position: 136px 4px;"/>
			</div>
			
			<div class="col-md-2" style="font-size: 12px;background-color:#dcdada94; width: 100%; height: 42%; margin-top: 27px;"><span id="txtSuppName"></span></div>
			<div class="col-md-8"></div>
				
			<div class="col-md-2"><label>Report Type</label>
					<s:select id="cmbDocType" path="strDocType" style="width:auto;">
				    		<s:option value="PDF">PDF</s:option>
				    		<s:option value="XLS">EXCEL</s:option>
				    		<s:option value="HTML">HTML</s:option>
				    		<s:option value="CSV">CSV</s:option>
				    </s:select>
			</div>
			
					<!-- <td><input type="submit" value="Submit" /></td>
					<td><input type="reset" value="Reset" onclick="funResetFields()"/></td>	 -->				
		</div>
			
			<br>
			<p align="center" style="margin-right: 46%;">
				<input type="submit" value="Submit" class="btn btn-primary center-block" class="form_button" onclick="return formSubmit();"/>
				 &nbsp;
				<input type="button" value="Reset" class="btn btn-primary center-block" class="form_button"  onclick="funResetFields()"/>
			</p>
			
		</s:form>
		</div>
	</body>
</html>