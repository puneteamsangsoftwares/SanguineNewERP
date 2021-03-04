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
<%-- 	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/all.min.css"/>" /> --%>
	  	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.css"/>" /> 
		<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />  
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 	<!--  <link rel="stylesheet" href="path/to/font-awesome/css/font-awesome.min.css"> -->
	 	 
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	<%-- 	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/all.min.js"/>"></script> --%>
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
	
	
	
	
	function funValidate()
	{	
		var flag=true;
		if($('#txtPersonName').val().trim().length<1)
		{
			alert("Please Enter Value");
			flag = false;
		}
		return flag;
	}
	
	function funResetFields()
	{
		location.reload(true); 
	}
	
		function funSetData(code){

		switch(fieldName){

		case 'WCPersonMaster' :
			funSetPersonData(code);
			break;
		}
	}
 

function funSetPersonData(code){

	$.ajax({
		type : "GET",
		url : getContextPath()+ "/loadWebClubPersonMasterData.html?docCode=" + code,
		dataType : "json",
		success : function(response){ 

			if(response.strPCode=='Invalid Code')
        	{
        		alert("Invalid Person Code");
        		$("#txtPersonCode").val('');
        	}
        	else
        	{      
	        	$("#txtPersonCode").val(code);
	        	$("#txtPersonName").val(response.strPName);
	        	$("#txtEmail").val(response.strEmail);
	        	$("#txtMobileNo").val(response.strMobileNo);	
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
		<label  id="formHeading">Person Master</label>
		<s:form name="WebClubPersonMaster" method="POST" action="saveWebClubPersonMaster.html">
			<div class="row masterTable">
				<div class="col-md-6">
					<div class="row">
						<div class="col-md-6">
							<label>Person Code:</label><br>
								<s:input id="txtPersonCode" type="text" placeholder="Person Code" path="strPCode" required=""
				                   cssClass="searchTextBox" ondblclick="funHelp('WCPersonMaster')" readonly="true"></s:input>
						</div>
						<div class="col-md-6">
							<label>Person Name:</label><br>
								<s:input id="txtPersonName" path="strPName" type="text" placeholder="Person Name" required="true"></s:input>
						</div>
					</div>
				</div>
				<div class="col-md-6">
					<div class="row">
						<div class="col-md-6">
							<label>Email ID:</label><br>
								<s:input id="txtEmail" type="text" placeholder="Email ID" path="strEmail" required="true"></s:input>
						</div>
						<div class="col-md-6">
							<label>Mobile:</label><br>
								<s:input id="txtMobileNo" path="strMobileNo" type="text" placeholder="Mobile" required="true"></s:input>
						</div>
					</div>
				</div>
				    	
			</div>
			<div class="center">
						<a href="#"><button class="btn btn-primary center-block" tabindex="3" value="Submit" onclick=""
							class="form_button">Submit</button></a>
						<a href="#"><button class="btn btn-primary center-block" type="reset"
						 value="Reset" class="form_button" onclick="funResetField()" >Reset</button></a>
					</div>
		</s:form>
	</div>
	
</body>
</html>
