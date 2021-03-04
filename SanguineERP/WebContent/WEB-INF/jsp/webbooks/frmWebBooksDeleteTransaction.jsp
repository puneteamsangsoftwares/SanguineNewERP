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
	
	var fieldName,transactionName;

	$(function ()
	{
		funSetTransCodeHelp($("#cmbFormName").val());
				
		$("#DeleteTransaction").submit(function( event )
		{
			if($("#txtTransCode").val()=='')
			{
				alert("Please Select Transaction Code To Delete");
				return false;
			}
			
			if($("#txtReason").val()=='')
			{
				alert("Enter Reason For Delete");
				return false;
			}
		});
		
		$("#btnShow").click(function(event)
		{
			funSetDocCode($("#txtTransCode").val());
		});
		
		$("#cmbFormName").change(function() 
		{
			var value=$("#cmbFormName").val();
			funSetTransCodeHelp(value);
		});
		
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
				alert("Data Deleted successfully\n\n"+message);
				<%
			}else{
				%>	
				alert("Data Not Deleted .Other trasaction entry are present\n\n"+message);
				<%
			}
		}%>
		
		$('#txtTransCode').blur(function() {
			var code = $('#txtTransCode').val();
			if(code.trim().length > 0 && code !="?" && code !="/")
			{
				if(code.trim().length>12)
				{
					alert("Invalid Code");
					$("#txtTransCode").val('');
				}
				else
				{
					$("#txtTransCode").val(code);
				}	
			}
		});
		
		$('#txtReasonCode').blur(function() {
			var code = $('#txtReasonCode').val();
			if(code.trim().length > 0 && code !="?" && code !="/")
			{
				funSetReason(code);
			}
		});
		
	});

		
	
	
	function funSetTransCodeHelp(value)
	{
		switch (value) 
		{
		   case 'frmJV':
			   transactionName='JVNo';
		       break;
		       
		   case 'frmReceipt':
			   transactionName='ReceiptNo';
		       break;
		       
		   case 'frmPayment':
			   transactionName='PaymentNo';
		       break;
		}
	}
	
	
	
	function funSetData(code){

		switch(fieldName){

			case 'reason':
	    		funSetReason(code);
	        	break;
		
			case 'TransCode' : 
				$("#txtTransCode").val(code);
				break;
		}
	}
	

	function funSetReason(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadWebStockReasonMasterData.html?reasonCode=" + code,
			dataType : "json",
			success : function(response){
				if(response.strReasonCode=="Invalid Code")
				{
				alert("Invalid Reason Code");
				$("#txtReasonCode").val('');
				$("#lblReasonDesc").text('');
				}
				else
				{	
				$("#txtReasonCode").val(response.strReasonCode);
				$("#lblReasonDesc").text(response.strReasonName);
				}
			},
			error : function(e){
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

	
// Validations before submitting form values. 
	function funValidateForm() 
	{
		if($("#txtVouchNo").val()=='')
		{
			alert("Select Vouch No!!!");
			return false;
		}
		return true;
	}
		


	function funHelp(transactionName)
	{		
		fieldName=transactionName;
	//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
	
	
	function funTransCodeHelp(transactionName)
	{
		switch ($("#cmbFormName").val()) 
		{
		   case 'frmJV':
			   transactionName='JVNo';
		       break;
		       
		   case 'frmReceipt':
			   transactionName='ReceiptNo';
		       break;
		       
		   case 'frmPayment':
			   transactionName='PaymentNo';
		       break;
		}
		
		fieldName="TransCode";
	//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
	
</script>

</head>
<body>
   <div class="container masterTable">
	<label id="formHeading">Delete Transaction</label>
	<s:form name="DeleteTransaction" method="POST" action="saveWebBooksDeleteTrans.html">
            <div class="row">
			       <div class="col-md-2"><label>Form Name</label>
				             <s:select id="cmbFormName" path="strFormName">
						       <s:options items="${listFormName}"/>
					         </s:select>
				   </div>
				   
				   <div class="col-md-3"><label>Trans Code</label>
				             <s:input  type="text" id="txtTransCode" path="strTransCode" cssClass="searchTextBox" ondblclick="funTransCodeHelp('TransCode');"/>
				   </div>
			 
				   <div class="col-md-1"> <br />
				   			<select id="cmbDeleteYN" >
						        <option value="Yes">Yes</option>
						        <option value="No">No</option>
					         </select>
				   </div>
			       
			       <div class="col-md-3"><label>Reason Code</label>
				             <s:input  id="txtReasonCode" readonly="true" path="strReasonCode" cssClass="searchTextBox" ondblclick="funHelp('reason');"/>
				   </div>
				
					<div class="col-md-3"><label id="lblReasonDesc"></label>
				    </div>
			
					<div class="col-md-2"><label>Narration</label>
				             <s:textarea type="text" id="txtNarration" path="strNarration"  style="width: 150%; height:100px;"/>
					</div>
			</div>
		<p align="right" style="margin-right:26%;">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button"  onclick="return funValidateHeaderFields()"/>
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>

	</s:form>
	</div>
</body>
</html>
