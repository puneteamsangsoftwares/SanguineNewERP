<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>
<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/materialdesignicons.min.css"/>" />
	  	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.css"/>" /> 
		<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />  
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 	 
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.js"/>"></script> 
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
	 
<script type="text/javascript">
	var fieldName;

	
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
	
	function funResetFields()
	{
		location.reload(true); 
	}
	
		function funSetData(code){

		switch(fieldName){

		case 'WCFacilityMaster' :
			funSetFacilityData(code);
			break;
		}
	}
 

function funSetFacilityData(code){

	$.ajax({
		type : "GET",
		url : getContextPath()+ "/loadWebClubFacilityMasterData.html?docCode=" + code,
		dataType : "json",
		success : function(response){ 

			if(response.strFacilityCode=='Invalid Code')
        	{
        		alert("Invalid Facility Code");
        		$("#txtFacilityCode").val('');
        	}
        	else
        	{      
	        	$("#txtFacilityCode").val(code);
	        	$("#txtFacilityName").val(response.strFacilityName);
	        
	        	if(response.strOperationalNY=='Y')
	        	{
	        		//$("#chkOperationalNY").attr('checked', true);
	        		$('#chkOperationalNY').prop('checked', true);
	        	}
	        	else
	        	{
	        		//$("#chkOperationalNY").attr('checked', false);
	        		$('#chkOperationalNY').prop('checked', false);
	        	}
				
	        	
	        	
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
		<label id="formHeading">Facility Master</label>
			<s:form name="WebClubFacilityMaster" method="POST" action="saveWebClubFacilityMaster.html">
				<div class="row masterTable">
					<div class="col-md-4">
						<label>Facility Code:</label><br>
						<s:input type="text" id="txtFacilityCode" placeholder="Facility Code" path="strFacilityCode" cssClass="searchTextBox" readonly="true" ondblclick="funHelp('WCFacilityMaster')" />
					</div>
					<div class="col-md-4">
						<label>Facility Name:</label><br>
						<s:input type="text" id="txtFacilityName" placeholder="Enter Facility Name" path="strFacilityName"  required="true" ondblclick="funHelp('WCFacilityMaster')" />
					</div>
					<div class="col-md-4">
						<label>Operational:</label><br>
						<%-- <s:input type="radio" id="chkOperationalNY" path="strOperationalNY" value="Y" checked="true" /> --%>
						<s:checkbox id="chkOperationalNY" path="strOperationalNY" value="Y" checked="true" />
					</div>
				</div>
				<div class="center">
							<a href="#"><button class="btn btn-primary center-block" value="Submit" tabindex="3"
								class="form_button">Submit</button></a>
							<a href="#"><button class="btn btn-primary center-block" type="reset"
								value="Reset" class="form_button" onclick="funResetFields()" >Reset</button></a>
						</div>
			</s:form>
		</div>
</body>
</html>