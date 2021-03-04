<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
	
	    <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />

		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
	
<title></title>
<script type="text/javascript">
	var fieldName;

	$(function() 
	{
	});
	var clickCount =0.0;
	function funSetData(code){

		switch(fieldName){

			case 'CurrencyCode' : 
				funSetCurrencyCode(code);
				break;
		}
	}

	function funCallFormAction(actionName,object) 
	{
		
		if ($("#txtCurrencyName").val()=="") 
		    {
			 alert('Enter Name');
			 $("#txtSODate").focus();
			 return false;  
		   
		}
	if(clickCount==0){
		clickCount=clickCount+1;
	}
		else
		{
			return false;
		}
		return true; 
	}

	function funSetCurrencyCode(code){

		$.ajax({
			type : "POST",
			url : getContextPath()+ "/loadCurrencyCode.html?docCode=" + code,
			dataType : "json",
			success : function(response){ 
				if(response.strCurrencyCode=='Invalid Code')
	        	{
	        		alert("Invalid Code");
	        		$("#txtCurrencyCode").val('');
	        	}
	        	else
	        	{        
		        	$("#txtCurrencyCode").val(response.strCurrencyCode);
		        	$("#txtCurrencyName").val(response.strCurrencyName);
		        	$("#txtShortName").val(response.strShortName);
		        	$("#txtBankName").val(response.strBankName);
		        	$("#txtSwiftCode").val(response.strSwiftCode);
		        	$("#txtIbanNo").val(response.strIbanNo);
		        	$("#txtRouting").val(response.strRouting);
		        	$("#txtAccountNo").val(response.strAccountNo);
		        	$("#txtConvToBaseCurr").val(response.dblConvToBaseCurr);
		        	$("#txtSubUnit").val(response.strSubUnit);
		        
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


	
	/**
	* Success Message After Saving Record
	**/
	$(document).ready(function()
	{
		var message='';
		<%if (session.getAttribute("success") != null) 
		{
			if(session.getAttribute("successMessage") != null)
			{%>
				message='<%=session.getAttribute("successMessage").toString()%>';
			    <%
			    session.removeAttribute("successMessage");
			}
			boolean test = ((Boolean) session.getAttribute("success")).booleanValue();
			session.removeAttribute("success");
			if (test) 
			{
				%>alert("Data Saved \n\n"+message);<%
			}
		}%>
	});













	function funHelp(transactionName)
	{
		fieldName=transactionName;
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
</script>

</head>
<body>
	<div class="container">
		<label id="formHeading">Currency Master</label>
		<s:form name="CurrencyMaster" method="POST" action="saveCurrencyMaster.html">

		<div class="row masterTable">
			<div class="col-md-2">
				<label>Currency Code</label>
				<s:input type="text" id="txtCurrencyCode" path="strCurrencyCode" cssClass="searchTextBox" ondblclick="funHelp('CurrencyCode');" readOnly="true"/>
			</div>	
			<div class="col-md-2">
				<label>Currency Name</label>
				<s:input type="text" id="txtCurrencyName" path="strCurrencyName" />
			</div>
			<div class="col-md-2">
				<label>Short Name</label>
				<s:input type="text" id="txtShortName" path="strShortName" />
			</div>
			<div class="col-md-6"></div>
			<div class="col-md-2">
				<label>Bank Name</label>
				<s:input type="text" id="txtBankName" path="strBankName" />
			</div>
			<div class="col-md-2">
				<label>Swift Code</label>
				<s:input type="text" id="txtSwiftCode" path="strSwiftCode" />
			</div>
			<div class="col-md-2">
				<label>Iban No</label>
				<s:input type="text" id="txtIbanNo" path="strIbanNo" />
			</div>
			<div class="col-md-6"></div>	
			<div class="col-md-2">
				<label>Routing</label>
				<s:input type="text" id="txtRouting" path="strRouting" />
			</div>	
			<div class="col-md-2">
				<label>Account No</label>
				<s:input type="text" id="txtAccountNo" path="strAccountNo" />
			</div>
			<div class="col-md-2">
				<label>Conversion To Base</label>
				<s:input type="text" id="txtConvToBaseCurr" path="dblConvToBaseCurr" style="text-align:right;" />
			</div>
			<div class="col-md-6"></div>
			<div class="col-md-2">
				<label>Sub Unit</label>
				<s:input type="text" id="txtSubUnit" path="strSubUnit" />
			</div>
		</div>
		<div class="center" style="margin-right: 52%;">
				<a href="#"><button class="btn btn-primary center-block"  value="Submit" onclick="return funCallFormAction('submit',this);" 
				>Submit</button></a>
				<a href="#"><button class="btn btn-primary center-block"  value="reset" onclick="funResetFields()"
				>Reset</button></a>
		</div>
	</s:form>
</div>
</body>
</html>
