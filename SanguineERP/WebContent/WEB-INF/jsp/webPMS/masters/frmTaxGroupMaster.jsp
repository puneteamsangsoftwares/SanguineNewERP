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
	
	function funSetTaxGroupData(taxGroupCode)
	{
		var loadTaxGroupUrl=getContextPath()+"/loadTaxGroupMasterData.html?taxGroupCode="+taxGroupCode;
		$.ajax({
			
			url:loadTaxGroupUrl,
			type:"GET",
			dataType:"json",
			 success: function(response)
		        {
		        	if(response.strTaxGroupCode=='Invalid Code')
		        	{
		        		alert("Invalid Tax Group Code");
		        		$("#strTaxGroupCode").val('');
		        	}
		        	else
		        	{					        	    		        		
		        		$("#strTaxGroupCode").val(response.strTaxGroupCode);
		        		$("#strTaxGroupDesc").val(response.strTaxGroupDesc);
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

	function funSetData(code)
	{
		switch(fieldName)
		{
			case "taxGroupCode":
				 funSetTaxGroupData(code);
				 break;
		}
	}
	function funHelp(transactionName)
	{
		fieldName=transactionName;
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
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
	
	
	 $('#baseUrl').click(function() 
				{  
					 if($("#strTaxGroupCode").val().trim()=="")
					{
						alert("Please Select Tax Group Code... ");
						return false;
					} 
						window.open('attachDoc.html?transName=frmTaxGroupMaster.jsp&formName=Member Profile&code='+$('#strTaxGroupCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
				});
	
</script>

</head>
<body>
  <div class="container masterTable">
	<label  id="formHeading">Tax Group Master</label>
	<s:form name="TaxGroupMaster" method="POST" action="saveTaxGroupMaster.html">
      <div class="row">
          
          <div class="col-md-5"><label>Tax Group Code</label>
		   	<div class="row">
			    <div class="col-md-5"><s:input id="strTaxGroupCode" path="strTaxGroupCode"  ondblclick="funHelp('taxGroupCode')" cssClass="searchTextBox" style="height:90%"/></div>			        			        
			    <div class="col-md-7"><s:input id="strTaxGroupDesc" path="strTaxGroupDesc" required="true"/></div>			    		        			   
			</div>
		   </div>
		 </div>
         <br />
		<p align="center" style="margin-right: 31%;">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" />&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>

	</s:form>
	</div>
</body>
</html>
