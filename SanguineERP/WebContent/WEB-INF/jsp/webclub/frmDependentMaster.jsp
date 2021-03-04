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
	
		
		
			<script type="text/javascript">
	var map1 = new Map();
	$(document).ready(function() {	
		
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
			alert(message);
		<%
		}}%>
	});
        
        function funResetFields()
		{
			location.reload(true); 
		}
        
		 function funloadMemberWiseFieldData(code)
			{
				var searchurl=getContextPath()+"/loadWebClubDependentMaster.html?deptCode="+code;
				 $.ajax({
					        type: "GET",
					        url: searchurl,
					        success: function(response)
					        {
					        	if(response.strMemberCode=='Invalid Code')
					        	{
					        		alert("Invalid Member Code");
					        		$("#txtMemberCode").val('');
					        	}
					        	else
					        	{  
					        		funDeleteTableAllRowsField();
					        		map1=response;
						        	for (var i in map1) {	
						        		if(i!='strMemberCode')
						        			{
						        				funAddFieldDataMemberWise(i,map1[i]);						        				
						        			}		        	    
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
				window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
			}
		 
		 
	function funSetData(code){

		switch(fieldName){
		
			case 'WCDepChange' :	
				funSetMemberCategory(code);
				break;
			
			
				
		}
	}
	
	 function funSetMemberCategory(code)
		{
			$("#txtMSCategoryCode").val(code);
			var searchurl=getContextPath()+"/loadWebClubDependentMaster.html?deptCode="+code;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strGCode=='Invalid Code')
				        	{
				        		alert("Invalid Category Code");
				        		$("#txtMSCategoryCode").val('');
				        	}
				        	else
				        	{
					        	$("#txtDependentCode").val(code);
					        	$("#txtDependentName").val(response[0]);
					        	$("#txtCDependentCode").val('');
					        	$("#txtCDependentName").val('');
					        	
					        	
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

	function funValidate()
	{	
		var flag=true;
		if($("#txtCDependentCode").val().trim().length==0&&$("#txtCDependentCode").val().trim().length==0&&$("#txtCDependentName").val().trim().length==0&&$("#txtDependentName").val().trim().length==0)
			{
				alert("\n\n\nPlease Enter Data");
				flag=false;
			}
		
		else if($("#txtCDependentCode").val()==$("#txtDependentCode").val()&&$("#txtCDependentName").val()==$("#txtDependentName").val())
		{
			alert("Please Enter Different Change Dependent Code Or Change Dependent Name");
			flag=false;
		}
	/* 	if($("#txtCDependentName").val()==$("#txtDependentName").val())
		{
			alert("Please Enter Different Change Dependent Name");
			flag=false;
		}		 */		
		return flag;		
	}
	
		 
		 	
</script>
			 
</head>
<body >
	 <div class="container">
		<label id="formHeading">Dependent Master</label>
			<s:form name="frmDependentMaster" action="saveDependentMaster.html?saddr=${urlHits}" method="POST">
				<div class="row masterTable">
					<div class="col-md-3">
						<label>Dependent Code:</label><br>
						<s:input type="text" id="txtDependentCode" class="searchTextBox" placeholder="Dependent Code" path="strDepCode" ondblclick="funHelp('WCDepChange')" required="true" readonly="true"/>
					</div>
					<div class="col-md-3">
						<label>Dependent Name:</label><br>
						<s:input type="text" id="txtDependentName" placeholder="Enter Dependent Name" name="txtDependentName" path="strDepName" required="true" readonly="true"
							/><s:errors path=""></s:errors>
					</div>
					
					<div class="col-md-3">
						<label>Change Dependent Code:</label><br>
						<s:input type="text" id="txtChangeDependentCode"  placeholder="Select Change Dependent Code" path="strCDepCode" ondblclick="" required="true"/>
					</div>
					<div class="col-md-3">
						<label>Change Dependent Name:</label><br>
						<s:input type="text" id="txtCDependentName" placeholder="Change Dependent Name" name="txtCDependentName" path="strCDepName" required="true" 
							/><s:errors path=""></s:errors>
					</div>
					
					
					<%-- <div class="col-md-6">
						<label>Change Dependent Code:</label><br>
							<div class="row">
								<div class="col-md-6">
									<s:input  type="text" placeholder="Change Dependent Code" id="txtDependentName" 
									name="txtChangeDependentCode" path="" required="true"
									cssStyle="searchTextBox"/><s:errors path=""></s:errors>
								
								</div>
								
								<div class="col-md-6"><s:input  type="text" placeholder="Change Dependent Code" id="txtDependentName" 
									name="txtChangeDependentCode" path="" required="true"/> <s:errors path=""></s:errors>
								</div>
							</div>
					</div> --%>
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



