<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Group Block Master</title>
    <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

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
		case 'groupblockmaster' : 
			funSetExtraBedData(code);
			break;
		
		}
	}
	
	function funSetExtraBedData(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadGroupBlockData.html?docCode=" + code,
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
	        		$("#txtGroupBlockCode").val(response.strGroupBlockCode);
	        	    $("#txtGroupBlockName").val(response.strGroupBlockName);
	        
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
<div class="container masterTable">
	<div >
	<label id="formHeading">Group Block Master</label>
	</div>

<br/>
<br/>

	<s:form name="frmGroupBlockMaster" method="POST" action="savefrmGroupBlockMaster.html">
<div id="multiAccordion">	
			<div class="row">
						<!-- <th align="right" colspan="2"><a id="baseUrl"
							href="#"> Attach Documents</a>&nbsp; &nbsp; &nbsp;
								&nbsp;</th> -->
					<div class="col-md-5">
				   		<div class="row">
							<div class="col-md-5"><label>Group Block Code</label>
								<s:input id="txtGroupBlockCode" path="strGroupBlockCode" cssClass="searchTextBox" ondblclick="funHelp('groupblockmaster')" style="height:45%"/>			
							</div>
							<div class="col-md-7"><label>Group Block Name</label>
								<s:input id="txtGroupBlockName" path="strGroupBlockName"/>			
							</div>
					</div></div>
				</div>

		

		<br />
		<br />
		<p align="center">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button"   />&nbsp;
            <input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
			
		</p>
</div>
	</s:form>
	</div>
</body>
</html>
