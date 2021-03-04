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
	
	
	/**
	* Success Message After Saving Record
	**/
	 $(document).ready(function()
				{
		var message='';
		<%if (session.getAttribute("success") != null) {
			            if(session.getAttribute("successMessage") != null){%>
			            message='<%=session.getAttribute("successMessage").toString()%>';
			            <%
			            session.removeAttribute("successMessage");
			            }
						boolean test = ((Boolean) session.getAttribute("success")).booleanValue();
						session.removeAttribute("success");
						if (test) {
						%>	
			alert("Data Save successfully\n\n"+message);
		<%
		}}%>

	});

		var clickCount =0.0;
		function funCallFormAction(actionName,object) 
			{
				
				if ($("#txtCityName").val()=="") 
				    {
					 alert('Enter City Name');
					 $("#txtCityName").focus();
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

	
	$(function() 
	{
	});

	function funSetData(code){

		switch(fieldName){

			case 'CityCode' : 
				funSetCityCode(code);
				break;
			case 'CountryCode' : 
				funSetCountryCode(code);
				break;
			case 'StateCode' : 
				funSetStateCode(code);
				break;
		}
	}


	function funSetCityCode(code){

		$.ajax({
			type : "POST",
			url : getContextPath()+ "/loadWSCityCode.html?docCode=" + code,
			dataType : "json",
			success : function(response)
			{
	        	if(response.strCityCode=='Invalid Code')
	        	{
	        		alert("Invalid City Code");
	        		$("#txtCityCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtCityCode").val(code);
		        	$("#txtCityName").val(response.strCityName);
		        	funSetStateCode(response.strStateCode);
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


	function funSetCountryCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadWSCountryCode.html?docCode=" + code,
			dataType : "json",
			success : function(response)
			{
	        	if(response.strCountryCode=='Invalid Code')
	        	{
	        		alert("Invalid State Code");
	        		$("#txtCountryCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtCountryCode").val(code);
		        	$("#lblCountryName").text(response.strCountryName);
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


	function funSetStateCode(code){

		$.ajax({
			type : "POST",
			url : getContextPath()+ "/loadWSStateCode.html?docCode=" + code,
			dataType : "json",
			success : function(response)
			{
	        	if(response.strStateCode=='Invalid Code')
	        	{
	        		alert("Invalid State Code");
	        		$("#txtStateCode").val('');
	        	}
	        	else
	        	{
		        	$("#txtStateCode").val(response.strStateCode);
		        	$("#lblStateName").text(response.strStateName);
		        	//$("#txtStateDesc").val(response.strStateDesc);
		        	funSetCountryCode(response.strCountryCode);
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







	function funHelp(transactionName)
	{
		fieldName=transactionName;
	//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	
	}
</script>

</head>
<body>

<div class="container">
	<label id="formHeading">City Master</label>
	<s:form name="frmWSCityMaster" method="POST" action="saveWSCityMaster.html">
		<div class="row masterTable">
			<div class="col-md-2">
				<label>City Code</label>
				<s:input colspan="4" type="text" id="txtCityCode" path="strCityCode" cssClass="searchTextBox" ondblclick="funHelp('CityCode');" readOnly="true;"/>
			</div>
			<div class="col-md-2">
				<label>City Name</label>
				<s:input colspan="4" type="text" id="txtCityName" path="strCityName" />
			</div>
			<div class="col-md-8"></div>
			<div class="col-md-2">
				<label>State Code</label>
				<s:input  type="text" id="txtStateCode" path="strStateCode" cssClass="searchTextBox" ondblclick="funHelp('StateCode');" readOnly="true;"/>
			</div>
			<div class="col-md-2">
				<label id="lblStateName" style="background-color:#dcdada94; width: 100%; height:51%; margin-top: 28px; text-align: center;"></label>
			</div>
			<div class="col-md-8"></div>
			<div class="col-md-2">
				<label>Country Code</label>
				<s:input  type="text" id="txtCountryCode" path="strCountryCode" cssClass="searchTextBox" ondblclick="funHelp('CountryCode');" readOnly="true;"/>
			</div>
			<div class="col-md-2">
				<label id="lblCountryName" style="background-color:#dcdada94; width: 100%; height:51%; margin-top: 28px; text-align: center;"></label>
			</div>
		</div>
		<div class="center" style="text-align:left; margin-left:15%;">
			<a href="#"><button class="btn btn-primary center-block" tabindex="3"  value="Submit" onclick="return funCallFormAction('submit',this);"
				>Submit</button></a>
			<a href="#"><button class="btn btn-primary center-block"  value="Reset" onclick="funResetFields()" >Reset</button></a>
		</div>
		
	</s:form>
</div>
</body>
</html>
