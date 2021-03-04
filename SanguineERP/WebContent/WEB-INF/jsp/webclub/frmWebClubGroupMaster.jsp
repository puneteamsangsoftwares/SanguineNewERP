<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<meta http-equiv="X-UA-Compatible" content="IE=8">
	<%-- <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/materialdesignicons.min.css"/>" />
	  	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.css"/>" /> --%>
		<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 <%-- 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" /> --%>
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 	 
	 	
	 	
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<%-- <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.js"/>"></script> --%>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
	
	<script type="text/javascript">
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
	 
	 function funHelp(transactionName)
		{	       
	     //   window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	        window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	    }
	 
	 function funResetFields()
		{
			location.reload(true); 
		}
	 
	 function funSetData(code)
		{
			$("#txtGroupCode").val(code);
			var searchurl=getContextPath()+"/loadWebClubGroupMasterData.html?groupCode="+code;
			//alert(searchurl);
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strGCode=='Invalid Code')
				        	{
				        		alert("Invalid Group Code");
				        		$("#txtGroupCode").val('');
				        	}
				        	else
				        	{
					        	$("#txtGroupCode").val(code);
					        	$("#txtGroupName").val(response.strGroupName);
					        	$("#txtShortName").val(response.strShortName);
					        	$("#cmbCategory").val(response.strCategory);
					        	$("#cmbDefaultType").val(response.strCrDr);
					        	$("#txtGroupName").focus();
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
		
	 
	 
	 
	 
	 
</script>
</head>
<body >
	<div class="container">
		<label id="formHeading">Group Master</label>
			<s:form name="frmGroupMaster" action="savefrmWebClubGroupMaster.html?saddr=${urlHits}" method="POST">
				<div class="row masterTable">
					<div class="col-md-3">
						<label>Group Code:</label><br>
						<s:input type="text" id="txtGroupCode" placeholder="Group Code" readonly="true" path="strGroupCode"  cssClass="searchTextBox" ondblclick="funHelp('WCgroup')" />
					</div>
					<div class="col-md-3">
						<label>Group Name:</label><br>
						<s:input type="text" id="txtGroupName" 
						name="txtGroupName" path="strGroupName" placeholder="Group Name" required="true"/> <s:errors path=""></s:errors>
					</div>
					<div class="col-md-3">
						<label>Short Name:</label><br>
						<s:input  type="text" id="txtShortName" 
						name="txtChangeDependentCode" path="strShortName" required="true" placeholder="Short Name"
						cssStyle="searchTextBox"/> <s:errors path=""></s:errors>
					</div>
					<div class="col-md-3">
						<label>Category:</label><br>
						<s:select id="cmbCategory" type="text" placeholder="Category" name="cmbCategory" path="strCategory">
					 		<option value="Income">Income</option>
		 				 	<option value="cash Balance">cash Balance</option>
				 		</s:select>
					</div>
					<div class="col-md-3">
						<label>Default Type:</label><br>
						<s:select id="cmbDefaultType" type="text" placeholder="Default Type" name="cmbDefaultType" path="strCrDr">
					 		<option value="Cash">Cash</option>
		 					 <option value="Credit">Credit</option>
						 </s:select>
					</div>
				</div>
					<div class="center">
						<a href="#"><button class="btn btn-primary center-block" value="Submit" onclick=""
							class="form_button">Submit</button></a>
						<a href="#"><button class="btn btn-primary center-block" type="reset"
							value="Reset" class="form_button" onclick="funResetField()" >Reset</button></a>
					</div>
			</s:form>
		</div>
</body>
</html>
<%-- <div id="formHeading">
	<label>Group Master</label>
	</div>
	<div>
	<s:form name="frmGroupMaster" action="savefrmWebClubGroupMaster.html?saddr=${urlHits}" method="POST">
		<br>
		<table class="masterTable">
			<tr>
				<td width="16%">Group Code</td>
				<td width="17%"><s:input id="txtGroupCode"   path="strGroupCode"	cssClass="searchTextBox" ondblclick="funHelp('WCgroup')"/></td>
			
				<td><label>Group Name</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<s:input type="text" id="txtGroupName" 
						name="txtGroupName" path="strGroupName" required="true"
						cssStyle="width:53% ; text-transform: uppercase;" cssClass="longTextBox"  /> <s:errors path=""></s:errors></td>
			</tr>
			
			<tr>
					<td><label>Short Name</label></td>
					<td colspan="2"><s:input  type="text" id="txtShortName" 
						name="txtChangeDependentCode" path="strShortName" required="true"
						cssStyle="searchTextBox; width:16% " cssClass="longTextBox"  /> <s:errors path=""></s:errors></td>
			</tr>
			<tr>
					<td><label>Category</label></td>
					<td colspan="2"><s:select id="cmbCategory" name="cmbCategory" path="strCategory" cssClass="BoxW124px" >
					 <option value="Income">Income</option>
		 				 <option value="cash Balance">cash Balance</option>
				 </s:select></td>
			</tr>
			<tr>
					<td><label>Default Type</label></td>
					<td colspan="2"><s:select id="cmbDefaultType" name="cmbDefaultType" path="strCrDr" cssClass="BoxW124px" >
					 <option value="Cash">Cash</option>
		 				 <option value="Credit">Credit</option>
				 </s:select></td>
			</tr>
		 
		 
		 </table>
		 
		<br>
		<p align="center">
			<input type="submit" value="Submit"
				onclick=""
				class="form_button" /> &nbsp; &nbsp; &nbsp; <input type="reset"
				value="Reset" class="form_button" onclick="funResetField()" />
		</p>
		<br><br>
	
	</s:form>
</div>
 --%>
