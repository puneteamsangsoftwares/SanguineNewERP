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

			case 'AgentCode' : 
				funSetAgentCode(code);
				break;
			case 'AgentCommCode' : 
				$("#txtAgentCommCode").val(code);
// 				funSetAgentCommCode(code);
				break;
			case 'CorporateCode' :
				$("#txtCorporateCode").val(code);
// 				funSetCorporateCode(code);
				break;
		}
	}

	
	




	function funSetAgentCode(code){
	 
		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadAgentCode.html?agentCode=" + code,
			dataType : "json",
		
			success: function(response)
	        {
				
	        	if(response.strAgentCode=='Invalid Code')
	        	{
	        		alert("Invalid Agent Code");
	        		$("#txtAgentCode").val('');
	        	}
	        	else
	        	{					        	    	        		
	        		$("#txtAgentCode").val(response.strAgentCode);
	        		var fromDate=response.dteFromDate;
	        		var frmDate= fromDate.split(' ');
	        	    var fDate = frmDate[0];
	        	    $("#txtFromDate").val(fDate);
	        	    var toDate1=response.dteToDate;
	        		var toDate= toDate1.split(' ');
	        	    var tDate = toDate[0];
	        		$("#txtToDate").val(tDate);
	        		$("#txtDescription").val(response.strDescription);
	        		$("#txtAgentCommCode").val(response.strAgentCommCode);
	        		$("#txtCorporateCode").val(response.strCorporateCode);
	        		$("#txtAdvToReceive").val(response.dblAdvToReceive);
	        		$("#txtAddress").val(response.strAddress);
	        		$("#txtCity").val(response.strCity);
	        		$("#txtState").val(response.strState);
	        		$("#txtCountry").val(response.strCountry);
	        		$("#txtTelphoneNo").val(response.lngTelphoneNo);
	        		$("#txtMobileNo").val(response.lngMobileNo);
	        		$("#txtFaxNo").val(response.lngFaxNo);
	        		$("#txtEmailId").val(response.lngMobileNo);
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
	
	 /**
		 *  Check Validation Before Saving Record
	**/
	function funCallFormAction(actionName,object) 
	{
		var flg=true;
		if($('#txtDescription').val()=='')
		{
			alert('Please Enter Description ');
			flg=false;
		}
		if($('#txtMobileNo').val()=='')
		{
			alert('Please Enter Mobile Number ');
			flg=false;
		}
		
		if($('#txtTelphoneNo').val()=='')
		{
			alert('Please Enter Telephone Number ');
			flg=false;
		}
		
		if($('#txtAddress').val()=='')
		{
			alert('Please Enter Address ');
			flg=false;
		}
		if($('#txtFaxNo').val()=='')
		{
			alert('Please Enter Fax ');
			flg=false;
		}
		
		return flg;
	}
	
	 
	function isNumber(evt) {
        var iKeyCode = (evt.which) ? evt.which : evt.keyCode
        if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57))
            return false;

        return true;
    }  
	
	$('#baseUrl').click(function() 
			{  
				 if($("#txtAgentCode").val().trim()=="")
				{
					alert("Please Select Agent Code... ");
					return false;
				} 
					window.open('attachDoc.html?transName=frmAgentMaster.jsp&formName=Member Profile&code='+$('#txtAgentCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
			});
	
</script>

</head>
<body>
  <div class="container masterTable">
	 <label id="formHeading">Agent Master</label>
	    <s:form name="AgentMaster" method="POST" action="saveAgentMaster.html">
	    
        <div class="row">
			<div class="col-md-2"><label>Agent Code</label>
				<s:input type="text" id="txtAgentCode" path="strAgentCode" cssClass="searchTextBox" style="height: 45%;" ondblclick="funHelp('AgentCode');"/>
			</div>
			
			<div class="col-md-2"><label>Agent Comm Code</label>
				 <s:input  type="text" id="txtAgentCommCode" path="strAgentCommCode" cssClass="searchTextBox" style="height: 45%;" ondblclick="funHelp('AgentCommCode');"/>
			</div>
			
			<div class="col-md-2"><label>Corporate Code</label>
				<s:input type="text" id="txtCorporateCode" path="strCorporateCode" cssClass="searchTextBox" style="height: 45%;" ondblclick="funHelp('CorporateCode');"/>
			</div>
			
			<div class="col-md-2"><label>Description</label>
				<s:input type="text" id="txtDescription" path="strDescription"/>
			</div>
			<div class="col-md-4"></div>
			
			<div class="col-md-2"><label>Address</label>
				<s:input type="text" id="txtAddress" path="strAddress"/>
			</div>
			
			<div class="col-md-2"><label>From Date</label>
				 <s:input type="text" id="txtFromDate" path="dteFromDate" style="width: 70%;" cssClass="calenderTextBox" />
			</div>
			
			<div class="col-md-2"><label>To Date</label>
				<s:input type="text" id="txtToDate" path="dteToDate" style="width: 70%;" cssClass="calenderTextBox" />
			</div>
			
			<div class="col-md-2"><label>Adv To Receive</label>
				<s:input type="number" step="0.01" id="txtAdvToReceive" style="width: 55%;height:45%;" path="dblAdvToReceive"/>
			</div>
		     <div class="col-md-4"></div>
			
			<div class="col-md-2"><label>City</label>
				<s:select id="txtCity" path="strCity" items="${cityArrLsit}" style="width:auto;"/>
			</div>
			
			<div class="col-md-2"><label>State</label>
				<s:select id="txtState" path="strState"  items="${stateArrLsit}" style="width:auto;"/>
			</div>
			
			<div class="col-md-2"><label>Country</label>
				<s:select id="txtCountry" path="strCountry" items="${countryArrLsit}" style="width:auto;"/>
			</div>
			
			<div class="col-md-2"><label>TelphoneNo</label>
				<s:input type="text" id="txtTelphoneNo" path="lngTelphoneNo" style="text-align:right;" onkeypress="javascript:return isNumber(event)" />
			</div>
		    <div class="col-md-4"></div>
		    
			<div class="col-md-2"><label>MobileNo</label>
				<s:input type="text" id="txtMobileNo" style="text-align:right;" path="lngMobileNo" onkeypress="javascript:return isNumber(event)" />
			</div>
	         
			<div class="col-md-2"><label>FaxNo</label>
				<s:input type="text" id="txtFaxNo" path="lngFaxNo" onkeypress="javascript:return isNumber(event)"/>
			</div>
			 
			<div class="col-md-2"><label>EmailId</label>
				<s:input type="text" id="txtEmailId" path="strEmailId" />
			</div>
		
		</div>

		<br />
		<p align="center" style="margin-right:-20%;">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" onclick="return funCallFormAction('submit',this);" />&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>

	</s:form>
	</div>
</body>
</html>
