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
			
			$('#txtGroupCode').blur(function() {
				var code = $('#txtGroupCode').val();
				if(code.trim().length > 0 && code !="?" && code !="/")
				{
					funSetAccountsGroupData(code);
				}
			});
			
		
		});
	
	function funSetAccountsGroupData(groupCode)
	{
	    $("#txtGroupCode").val(groupCode);
		var searchurl=getContextPath()+"/loadACGroupMasterData.html?acGroupCode="+groupCode;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strGroupCode=='Invalid Code')
			        	{
			        		alert("Invalid Group Code");
			        		$("#txtGroupCode").val('');
			        		$("#txtGroupName").val('');
			        	}
			        	else
			        	{
				        	$("#txtGroupName").val(response.strGroupName);
				        	$("#txtGroupName").focus();
				        	$("#cmbCategory").val(response.strCategory);
				        	$("#cmbDefaultType").val(response.strDefaultType);
				        	$("#txtShortName").val(response.strShortName);
				        	 
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
			case "acGroupCode":
			       funSetAccountsGroupData(code);
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
		<label id="formHeading">Group Master</label>
		<s:form name="BankMaster" method="POST" action="saveACGroupMaster.html">
				<div class="row masterTable">
					<div class="col-md-5">
						<label>Group Code:</label>
						<div class="row">
							<div class="col-md-5"><s:input id="txtGroupCode" ondblclick="funHelp('acGroupCode')" cssClass="searchTextBox"
								 placeholder="Group Code" readOnly="true" style="height:95%" type="text" path="strGroupCode"></s:input>
							</div>
						
							<div class="col-md-7"><s:input id="txtGroupName" path="strGroupName" required="true"
								 placeholder="Group Name" type="text"></s:input>
							</div>
						</div>
					</div>
					<div class="col-md-7"></div>
					<div class="col-md-3">
							<label>Short Name:</label><s:input id="txtShortName" ondblclick="" 
								 placeholder="Short Name" type="text" path="strShortName"></s:input>
					</div>
					<div class="col-md-9"></div>
					
					<div class="col-md-2">
								<label>Category:</label><s:select id="cmbCategory" path="strCategory" items="${listCategory}" cssClass="BoxW124px"/>
					</div>
					
					<div class="col-md-1.8">
								<label>Default Type:</label><s:select id="cmbDefaultType" path="strDefaultType" items="${listDefaultType}" cssClass="BoxW124px"/>
					</div>
						
							
				</div>
				<div class="center" style="margin-right: 60%;">
					<a href="#"><button class="btn btn-primary center-block" tabindex="3" onclick=""
						class="form_button">Submit</button></a>&nbsp
					<a href="#"><button class="btn btn-primary center-block" type="reset"
						value="Reset" class="form_button" onclick="funResetField()">Reset</button></a>
				</div> 
		</s:form>
	</div>
</body>
</html>
