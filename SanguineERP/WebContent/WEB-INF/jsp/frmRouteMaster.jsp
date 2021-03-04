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
	var clickCount =0.0;
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

	function funCallFormAction(actionName,object) 
	{
		
		if ($("#txtRouteName").val()=="") 
		    {
			 alert('Enter Route Name');
			 $("#txtRouteName").focus();
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
	
	function funSetData(code){

		switch(fieldName){

			case 'RouteCode' : 
				funSetRouteCode(code);
				break;
		}
	}


	function funSetRouteCode(code){

		$.ajax({
			type : "POST",
			url : getContextPath()+ "/LoadRouteMaster.html?docCode=" + code,
			dataType : "json",
			success : function(response){ 
				
				if('Invalid Code' == response.strVehCode){
        			alert("Invalid Route Code");
        			$("#txtRouteCode").val('');
        			$("#txtRouteCode").focus();
        		}else{
        			
        			$("#txtRouteCode").val(response.strRouteCode);
        			$("#txtRouteName").val(response.strRouteName);
        			$("#txtDesc").val(response.strDesc);
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
		<label id="formHeading">Route Master</label>
	
		<s:form name="RouteMaster" method="POST" action="saveRouteMaster.html?saddr=${urlHits}">
		<div class="row masterTable">
			<div class="col-md-2">
				<label>Route Code</label>
				<s:input colspan="3" type="text" id="txtRouteCode" path="strRouteCode" cssClass="searchTextBox" ondblclick="funHelp('RouteCode');" readOnly="true"/>
			</div>
			<div class="col-md-2">
				<label>Route Name</label>
				<s:input colspan="3" type="text" id="txtRouteName" path="strRouteName" cssClass="BoxW124px" />
			</div>
			<div class="col-md-2">
				<label>Description</label>
				<s:input colspan="3" type="text" id="txtDesc" path="strDesc" cssClass="BoxW124px" />
			</div>
		</div>

		<div class="center" style="margin-right: 51%;">
			<a href="#"><button class="btn btn-primary center-block" tabindex="3" value="Submit" onclick="return funCallFormAction('submit',this);"
			>Submit</button></a>
			<a href="#"><button class="btn btn-primary center-block"  value="reset" onclick="funResetFields()"
			>Reset</button></a>
		</div>
		
	</s:form>
	</div>
</body>
</html>
