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
	
	function funSetAccountsSubGroupData(subGroupCode)
	{
	    $("#txtSubGroupCode").val(subGroupCode);
		var searchurl=getContextPath()+"/loadACSubGroupMasterData.html?acSubGroupCode="+subGroupCode;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(fieldName=="acSubGroupCode")
			        	{
			        		
			        		if(response.strGroupCode=='Invalid Code')
				        	{
				        		alert("Invalid Group Code");
				        		$("#txtSubGroupCode").val('');
				        		$("#txtSubGroupName").val('');
				        	}
				        	else
				        	{
					        	$("#txtSubGroupName").val(response.strSubGroupName);
					        	$("#txtSubGroupName").focus();
					        	$("#txtGroupCode").val(response.strGroupCode);
					        	$("#lblGroupName").text(response.strGroupName);
					        	$("#txtUnderSubGroup").val(response.strUnderSubGroup);
				        	}	
			        	}else{
			        		
			        		if(response.strGroupCode=='Invalid Code')
				        	{
				        		alert("Invalid Group Code");
				        		$("#txtUnderSubGroup").val('');
				        	}
				        	else
				        	{
				        		 $("#lblUnderSubGroup").val(response.strSubGroupName);
					        	
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


	function funSetUnderSubGroupData(subGroupCode)
	{
	    $("#txtUnderSubGroup").val(subGroupCode);
		var searchurl=getContextPath()+"/loadUnderSubGroupMasterData.html?acSubGroupCode="+subGroupCode;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "text",
			        success: function(response)
			        {
			        	 $("#lblUnderSubGroup").text(response);
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
			        	}
			        	else
			        	{
				        	$("#lblGroupName").text(response.strGroupName);
				        	
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
			case "acSubGroupCode":
				funSetAccountsSubGroupData(code);
				 break;
				 
			case "underSubGroupCode":
				funSetUnderSubGroupData(code);
				 break;
				 
			
		}
	}
	

	function funHelp(transactionName)
	{
		fieldName=transactionName;
		
		if(transactionName=="underSubGroupCode"){
			var strGroupCode=$("#txtGroupCode").val();
			var strSubGroupCode=$("#txtSubGroupCode").val();
			window.open("searchform.html?formname="+transactionName+"&strGroupCode="+strGroupCode+"&strSubGroupCode="+strSubGroupCode+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
		}else{
			window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");	
		}
	
		
	}
	function funResetFields(){
		
		$("#lblUnderSubGroup").text('');
		$("#lblGroupName").text('');
		
		$("#txtSubGroupCode").val('');
		$("#txtSubGroupName").val('');
		$("#txtGroupCode").val('');
		$("#txtUnderSubGroup").val('');
	}
</script>

</head>
<body>
	<div class="container">
		<label id="formHeading">Sub Group Master</label>
		<s:form name="BankMaster" method="POST" action="saveACSubGroupMaster.html">
				<div class="row masterTable">
					
							<div class="col-md-5"><label>Sub Group Code:</label>
							<div class="row">
							<div class="col-md-5"><s:input id="txtSubGroupCode" ondblclick="funHelp('acSubGroupCode')" cssClass="searchTextBox"
								 placeholder="Sub Group Code" readOnly="true"  type="text" path="strSubGroupCode"></s:input>
							</div>
						
							<div class="col-md-7"><s:input id="txtSubGroupName" path="strSubGroupName" required="true"
								 placeholder="Sub Group Name" type="text"></s:input>
							</div>
						    </div></div>
						    
					<div class="col-md-7"></div>
					
					<div class="col-md-4">
						<div class="row">
							<div class="col-md-6">
							<label>Group Code:</label><s:input id="txtGroupCode" ondblclick="funHelp('acGroupCode')" cssClass="searchTextBox"
								   type="text" path="strGroupCode" readonly="true"  placeholder="Group Code" style="height:48%"></s:input>
							</div>
							<div class="col-md-6">
							<label>Under SubGroup Code:</label><s:input id="txtUnderSubGroup" path="strUnderSubGroup" ondblclick="funHelp('underSubGroupCode')"
								  type="text" cssClass="searchTextBox"  readonly="true" style="height:48%"></s:input>
							</div>
						</div>
					</div>
				</div>
				<div class="center" style="margin-right:60%">
					<a href="#"><button class="btn btn-primary center-block" tabindex="3" onclick=""
						class="form_button">Submit</button></a>&nbsp
					<a href="#"><button class="btn btn-primary center-block" type="reset"
						value="Reset" class="form_button" onclick="funResetField()">Reset</button></a>
				</div> 
		</s:form>
	</div>
</body>
</html>
