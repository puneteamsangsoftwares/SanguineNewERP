<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<meta http-equiv="X-UA-Compatible" content="IE=8">

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

	function funSetData(code){

		switch(fieldName){
		
		case 'houseKeepCode' : 
			funSetHouseKeepData(code);
			break;
			

		}
	}
	
	
	function funSetHouseKeepData(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadHouseKeepData.html?houseKeepCode=" + code,
			dataType : "json",
			success: function(response)
	        {
				
	        	if(response.strBookingTypeCode=='Invalid Code')
	        	{
	        		alert("Invalid Agent Code");
	        		$("#txtBookingTypeCode").val('');
	        	}
	        	else
	        	{					        	    	        		
	        		$("#txtHouseKeepCode").val(response.strHouseKeepCode);
	        	    $("#txtHouseKeepName").val(response.strHouseKeepName);
	        	    $("#txtRemarks").val(response.strRemarks);
	        
	        	}
			},
			error: function(jqXHR, exception) 
			{
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
		window.open("searchform.html?formname="+transactionName+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
	}
</script>

</head>
<body>

	<div class="container">
		<label id="formHeading">Housekeeping Master</label>
		<s:form name="HouseKeepingMaster" method="POST" action="saveHouseKeepingMaster.html">

		<div class="row masterTable">
			<div class="col-md-2">
				<label>Housekeeping Code</label>
				<s:input colspan="3" type="text" id="txtHouseKeepCode" path="strHouseKeepCode" cssClass="searchTextBox" ondblclick="funHelp('houseKeepCode')" />
			</div>
			<div class="col-md-2">
				<label>Housekeeping Name</label>
				<s:input colspan="3" type="text" id="txtHouseKeepName" path="strHouseKeepName"  />
			</div>
			<div class="col-md-2">
				<label>Description</label>
				<s:input colspan="3" type="text" id="txtRemarks" path="strRemarks"  />
			</div>
		</div>
		<div class="center" style="margin-right:52%;">
			<a href="#"><button class="btn btn-primary center-block" value="Submit" 
				class="form_button">Submit</button></a>&nbsp;
			<a href="#"><button class="btn btn-primary center-block" value="Reset" onclick="funResetFields()"
				class="form_button">Reset</button></a>
		</div>
	</s:form>
</div>
</body>
</html>
