<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>
    <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
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

	function funSetData(code){

		switch(fieldName){

		case 'MenuHeadCode' : 
			funSetMenuHeadCode(code);
			break;
		}
	}
	
	function funSetMenuHeadCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadMenuHeadCode.html?docCode=" + code,
			dataType : "json",
			success : function(response){ 
				if(response.strMenuHeadCode=='Invalid Code')
	        	{
	        		alert("Invalid Cost Center Code");
	        		$("#txtMenuHeadCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtMenuHeadName").val(response.strMenuHeadName);
	        		$("#txtMenuHeadCode").val(response.strMenuHeadCode);
	        		document.getElementById("chkOperational").checked = response.strOperational == 'Yes' ? true
							: false;
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
	
	function funValidate(data)
	{
		var flg=true;
		if($("#txtMenuHeadName").val().trim().length==0)
		{
			alert("Please Enter Menu Head Name !!");
			flg=false;
		}
		return flg;
	}

	function funHelp(transactionName)
	{
		fieldName=transactionName;
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
</script>

</head>
<body>

	<div class="container masterTable">
	<label id="formHeading">Menu Head Master</label>
	   <s:form name="frmMenuHeadMaster" method="POST" action="saveMenuHeadMaster.html">

		<div class="row">
          
				<div class="col-md-2"><label>Menu Head Code</label>
				      <s:input type="text" path="strMenuHeadCode" id="txtMenuHeadCode" ondblclick="funHelp('MenuHeadCode')" cssClass="searchTextBox jQKeyboard form-control" style="height: 50%;"/>
				</div>
	
			     <div class="col-md-2"><label>Menu Head Name</label>
				      <s:input type="text" path="strMenuHeadName" id="txtMenuHeadName"/>
				 </div>
		         <div class="col-md-8"></div>
		         
			     <div class="col-md-2"><label>Operational</label><br>
				      <s:checkbox value="true" element="li" path="strOperational" id="chkOperational" checked="true" />
				</div>
		</div>
	
		<p align="center" style="margin-right: 49%;">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" onclick="return funValidate(this)" />
			&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>

	</s:form>
	</div>
</body>
</html>
