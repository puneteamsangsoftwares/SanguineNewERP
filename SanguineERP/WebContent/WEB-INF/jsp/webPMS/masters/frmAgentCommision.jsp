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
	<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

<script type="text/javascript">
	var fieldName;

	$(function() 
			{
				
				var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
				$("#txtFromDate").datepicker({
					dateFormat : 'dd-mm-yy'
				});
				$("#txtFromDate").datepicker('setDate', pmsDate);

				$("#txtToDate").datepicker({
					dateFormat : 'dd-mm-yy'
				});
				$("#txtToDate").datepicker('setDate', pmsDate);

				$("#txtFromDate").val(pmsDate);
				$("#txtToDate").val(pmsDate);
			});

	function funSetData(code){

		switch(fieldName){

			case 'AgentCommCode' : 
				funSetAgentCommCode(code);
				break;
		}
	}


	function funSetAgentCommCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadAgentCommCode.html?agentCommCode=" + code,
			dataType : "json",
			success: function(response)
	        {
				
	        	if(response.strAgentCommCode=='Invalid Code')
	        	{
	        		alert("Invalid Agent Code");
	        		$("#txtAgentCommCode").val('');
	        	}
	        	else
	        	{					        	    	        		
	        		$("#txtAgentCommCode").val(response.strAgentCommCode);
	        		var fromDate=response.dteFromDate;
	        		var frmDate= fromDate.split(' ');
	        	    var fDate = frmDate[0];
	        	    $("#txtFromDate").val(fDate);
	        	    var toDate1=response.dteToDate;
	        		var toDate= toDate1.split(' ');
	        	    var tDate = toDate[0];
	        		$("#txtToDate").val(tDate);
	        		$("#txtDescription").val(response.strCalculatedOn);
	        		$("#txtCommisionPaid").val(response.strCommisionPaid);
	        		$("#txtCorporateCode").val(response.strCommisionOn);
	        		
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
		//window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
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
					 if($("#txtAgentCommCode").val().trim()=="")
					{
						alert("Please Select Agent Comm Code... ");
						return false;
					} 
						window.open('attachDoc.html?transName=frmAgentCommision.jsp&formName=Member Profile&code='+$('#txtAgentCommCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
				});
	
</script>

</head>
<body>
  <div class="container masterTable">
	<label id="formHeading">Agent Commision</label>
	 <s:form name="AgentCommision" method="POST" action="saveAgentCommision.html">
	 
            <div class="row">
			   <div class="col-md-2"><label>Agent Comm Code</label>
					<s:input type="text" id="txtAgentCommCode" path="strAgentCommCode" style="height: 45%;" cssClass="searchTextBox" ondblclick="funHelp('AgentCommCode');"/>
			    </div>
	
			<div class="col-md-2"><label>From Date</label>
				  <s:input type="text" id="txtFromDate" path="dteFromDate" style="width: 70%;" cssClass="calenderTextBox"/>
			</div>
			
			<div class="col-md-2" style="margin-left: -4%;"><label>To Date</label>
				  <s:input  type="text" id="txtToDate" path="dteToDate" style="width: 70%;" cssClass="calenderTextBox"/>
			</div>
			<div class="col-md-6"></div>
			<div class="col-md-2"><label>Calculated On</label>
				<s:select id="txtCalculatedOn" path="strCalculatedOn" style="width: auto;">
				    <s:option value="Revenue">Revenue</s:option>
				    <s:option value="Revenue">Revenue</s:option>
				    <s:option value="Revenue">Revenue</s:option>
				</s:select>
			 </div>
		
			<div class="col-md-2"><label>Commision Paid</label>
				<s:select id="txtCommisionPaid" path="strCommisionPaid" style="width: auto;">
				    <s:option value="Daily">Daily</s:option>
				 </s:select>
			</div>
			
			<div class="col-md-2" style="margin-left: -4%;"><label>Commision On</label>
				<s:select id="txtCommisionOn" path="strCommisionOn" style="width: auto;">
				     <s:option value="Daily">Room</s:option>
				</s:select>
			  </div>
			  
			</div>
		<br />
		<p align="center" style="margin-right: 32%;">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" />&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block"  class="form_button" onclick="funResetFields()"/>
		</p>
     </s:form>
     </div>
</body>
</html>
