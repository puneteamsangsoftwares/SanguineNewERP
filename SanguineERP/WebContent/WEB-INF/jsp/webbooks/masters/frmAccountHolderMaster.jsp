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
	
	 $(function() {
			
			$('#txtACHolderCode').blur(function() {
				var code = $('#txtACHolderCode').val();
				if(code.trim().length > 0 && code !="?" && code !="/")
				{
					funSetAccountHolderData(code);
				}
			});
			
		
		});
	 
	function funSetAccountHolderData(accountHolderCode)
	{
	    $("#txtACHolderCode").val(accountHolderCode);
		var searchurl=getContextPath()+"/loadACHolderMasterData.html?acHolderCode="+accountHolderCode;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strBankCode=='Invalid Code')
			        	{
			        		alert("Invalid Account Holder Code");
			        		$("#txtACHolderCode").val('');
			        	}
			        	else
			        	{
				        	$("#txtACHolderName").val(response.strACHolderName);
				        	$("#txtACHolderName").focus();	
				        	$("#txtDesignation").val(response.strDesignation);
				        	$("#txtMobileNumber").val(response.intMobileNumber);
				        	$("#txtEmailId").val(response.strEmailId);
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

	function funSetData(code){

		switch(fieldName)
		{		
			case "acHolderCode":
			     funSetAccountHolderData(code);
				 break;
		}
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
		<label id="formHeading">Account Holder Master</label>
		<s:form name="AccountHolderMaster" method="POST" action="saveAccountHolderMaster.html">
			<div class="row masterTable">
				<div class="col-md-5">
					<label>Account Holder Code:</label>
					<div class="row">
						<div class="col-md-5"><s:input id="txtACHolderCode" ondblclick="funHelp('acHolderCode')" cssClass="searchTextBox"
							readonly="true" placeholder="Account Holder Code" type="text" path="strACHolderCode"></s:input>
						</div>
					
						<div class="col-md-7"><s:input id="txtACHolderName" path="strACHolderName" required="true"
							 placeholder="Account Holder Name" type="text"></s:input>
						</div>
					</div><br>
				</div>	
				<div class="col-md-8"></div>
				<div class="col-md-12"><p style="margin-bottom:0px;">Contact Details</p></div>
				
				<div class="col-md-4">
					<div class="row">
						<div class="col-md-6">
							<label>Designation:</label><s:input id="txtDesignation" 
								required="true" type="text" path="strDesignation"></s:input>
						</div>
					
						<div class="col-md-6">
							<label>Mobile No:</label><s:input id="txtMobileNumber" path="intMobileNumber" required="true"
								  type="text"></s:input>
						</div>
					</div>
				</div>
				<div class="col-md-4">
					<div class="row">
						<div class="col-md-6">
							<label>Email Id:</label><s:input id="txtEmailId" 
								required="true"  type="text" path="strEmailId"></s:input>
						</div>
						<div class="col-md-6"></div>
					</div>
				</div>		
			</div>
			<div class="center" style="margin-right:51%">
				<a href="#"><button class="btn btn-primary center-block"
						value="Submit" onclick="" class="form_button">Submit</button></a> &nbsp
				<a href="#"><button class="btn btn-primary center-block"
						type="reset" value="Reset" class="form_button"
						onclick="funResetField()">Reset</button></a>
			</div>
			
		</s:form>
	</div>
	
</body>
</html>
