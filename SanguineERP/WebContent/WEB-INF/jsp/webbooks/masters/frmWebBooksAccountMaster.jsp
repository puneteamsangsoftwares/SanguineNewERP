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
	 
</head>
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

	//Textfiled On blur geting data
		$(function() {
			
			/* $('#txtAccountCode').blur(function() {
				var code = $('#txtAccountCode').val();
				if(code.trim().length > 0 && code !="?" && code !="/")
				{
					funSetAccountDetails(code);
				}
			}); */
			
			$('#txtSubGroupCode').blur(function() {
				var code = $('#txtSubGroupCode').val();
				if(code.trim().length > 0 && code !="?" && code !="/")
				{
					funSetAccountGroupDetails(code);
				}
			});
			
			$('#txtEmployeeCode').blur(function() {
				var code = $('#txtEmployeeCode').val();
				if(code.trim().length > 0 && code !="?" && code !="/")
				{
					funSetEmployeeMasterData(code);
				}
			});
		});

	
	 document.onkeypress = function(key_dtl) {
		 key_dtl = key_dtl || window.event; 
		 var uni_code = key_dtl.keyCode || key_dtl.which; 
		 var key_name = String.fromCharCode(uni_code); 
		
			var accno=$("#txtAccountCode").val();
 			
 			if(accno.length=='4')
 				{
 					funSetAccountGroupDetails(accno);	
 					$("#txtAccountCode").focus();
 				}
		 }
		 		
		 
	
	function funSetAccountDetails(accountCode)
	{
	    $("#txtAccountCode").val(accountCode);
		var searchurl=getContextPath()+"/loadAccountMasterData.html?accountCode="+accountCode;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strAccountCode=='Invalid Code')
			        	{
			        		alert("Invalid Account Code");
			        		$("#txtAccountCode").val('');
			        	}
			        	else
			        	{
				        	$("#txtAccountName").val(response.strAccountName);
				        	$("#txtAccountName").focus();
				        	$("#cmbEmployee").val(response.strEmployee);
				        	
				        	if(response.strType=="GLCode" || response.strType=="GL Code")
				        	{
				        		$("#cmbAccountType").val("GL Code");
				        	}
				        	else				        		
				        	{
				        		$("#cmbAccountType").val(response.strType);
				        	}
				        	$("#cmbOperational").val(response.strOperational);
				        	$("#cmbDebtor").val(response.strDebtor);
				        	$("#cmbCreditor").val(response.strCreditor);
				        	$("#txtSubGroupCode").val(response.strSubGroupCode);
				        	$("#txtSubGroupName").val(response.strSubGroupName);
				        	$("#txtBranch").val(response.strBranch);
				        	$("#txtOpeningBal").val(response.intOpeningBal);
				        	$("#cmbOpeningBal").val(response.strCreditor);
				        	$("#txtEmployeeCode").val(response.strEmployeeCode);
				        	
				        	$("#txtPrevYearBal").val(response.intPrevYearBal);
				        	$("#cmbPrevDrCr").val(response.strCrDr.split(",")[1]);
				        	 
				        	if(response.strEmployeeName!=null)
			        		{
				        		$("#lblEmployeeName").text(response.strEmployeeName);
			        		}
				        	else
				        	{
				        		$("#lblEmployeeName").text("");
				        	}	
				        	
				        	$("#cmbDrCr").val(response.strCrDr.split(",")[0]);
				        	
				        	
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
	
	function funSetAccountGroupDetails(subGroupCode)
	{
		var searchurl=getContextPath()+"/loadACSubGroupMasterData.html?acSubGroupCode="+subGroupCode;
		 $.ajax({
	        type: "GET",
	        url: searchurl,
	        dataType: "json",
	        success: function(response)
	        {
	        	if(response.strSubGroupCode=='Invalid Code')
	        	{
	        		alert("Invalid Group Code");
	        		$("#txtSubGroupCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtSubGroupCode").val(response.strSubGroupCode);
		        	$("#txtSubGroupName").val(response.strSubGroupName);
		        					        	
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
			case "accountCode": 
			     funSetAccountDetails(code);
				 break;
				 
            case "acSubGroupCode":
                 funSetAccountGroupDetails(code);			    					   
				 break; 
				 
            case "employeeCode":
			     funSetEmployeeMasterData(code);
				 break;
		}
	}

	function funSetEmployeeMasterData(employeeCode)
	{
	    $("#txtEmployeeCode").val();
		var searchurl=getContextPath()+"/loadEmployeeMasterData.html?employeeCode="+employeeCode;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strEmployeeCode=='Invalid Code')
			        	{
			        		alert("Invalid Employee Code");
			        		$("#txtEmployeeCode").val('');
			        	}
			        	else
			        	{
			        		$("#txtEmployeeCode").val(response.strEmployeeCode);
				        	$("#lblEmployeeName").text(response.strEmployeeName);
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
	//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
	
	function funValidation()
	{
		var flg=true;
		
		var groupCode=$("#txtGroupCode").val();
		if(groupCode=='')
		{
			alert('Please select group!!!');
			return false;
		}
		else
		{
		if($('#cmbOperational').val()=='No')
		{
	
			var isOk=confirm("Do you want to delete this enrty??");
			if(isOk)
				{
				flg=funCheckRecordsInTransactions();
				}
		}
		if(!flg)
		{
			location.reload();
		}
		return flg;
		}
	}
	
	function funCheckRecordsInTransactions()
	{
		var accountCode=$('#txtAccountCode').val()
		var result;
		var searchurl=getContextPath()+"/loadRecordsInTransaction.html?type=Account&docCode="+accountCode;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        async:false,
			        success: function(response)
			        {
			        	if(!response)
			        	{
			        		alert("Account Delete Successfully");
			        		result= false;
			        	}else{
			        		alert("There are records present in transaction for this entry, please delete those records First")
			        		$('#cmbOperational').val("Yes");
			        		result= true;
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
	return result;	
	}

	
	/* function funChangeDrYN()
	{
		var dr =$("#cmbDebtor").val();
		
		if(dr=='No')
			{
				$("#cmbCreditor").val('Yes');
			}
		if(dr=='Yes')
			{
			$("#cmbCreditor").val('No');
			}
		
		
	}
	
	function funChangeCrYN()
	{
		var cr =$("#cmbCreditor").val();
		if(cr=='Yes')
			{
				$("#cmbDebtor").val('No');
			}
		if(cr=='No')
			{
			$("#cmbDebtor").val('Yes');
			}
		
	} */
	function funValidateFields()
	{
		var groupCode=$("#txtSubGroupCode").val();
		if(groupCode=='')
		{
			alert('Please select group!!!');
			return false;
		}
		else
			return true;
	}
	
	
</script>

</head>
<body>
	<div class="container">
		<label id="formHeading">Account Master</label>
			<s:form name="WebBooksAccountMaster" method="POST" action="saveWebBooksAccountMaster.html">
				<div class="row masterTable">
					<div class="col-md-5">
						<label>Account Code:</label><br>
							<div class="row">
								<div class="col-md-5">
									<s:input  type="text" placeholder="Account Code" id="txtAccountCode" 
									ondblclick="funHelp('accountCode')" path="strAccountCode"  readonly="true" cssClass="searchTextBox"/>
								</div>
								<div class="col-md-7"><s:input  type="text" placeholder="Account Name" id="txtAccountName" 
									ondblclick="funHelp('accountCode')" path="strAccountName" style="height:92%" required="true"/> <s:errors path=""></s:errors>
								</div>
							</div>
						</div>
					
					    <div class="col-md-2">
							<label>Account Type:</label><br>
								<s:select id="cmbAccountType" path="strType" items="${listAccountType}" cssClass="BoxW124px"/>
						</div>
						
						<div class="col-md-1">
							<label>Operational:</label><br><s:select id="cmbOperational" path="strOperational" items="${listOperational}" cssClass="BoxW124px"/>
						</div>
							
						<div class="col-md-1">
							<label>Debtor:</label><br>
									<s:select id="cmbDebtor" path="strDebtor" items="${listDebtor}" cssClass="BoxW124px" />
						</div>
						
						<div class="col-md-1">
							<label>Creditor:</label><br>
								<s:select id="cmbCreditor" path="strCreditor" items="${listCreditor}" cssClass="BoxW124px" />
						</div>
							
						<div class="col-md-1">
							<label>Employee:</label><br>
								<s:select id="cmbEmployee" path="strEmployee" items="${listEmployee}" cssClass="BoxW124px" />
						</div>
						
						<div class="col-md-5">
						<label>Sub Group Code:</label><br>
							<div class="row">
								<div class="col-md-5">
									<s:input  type="text" placeholder="Sub Group Code" id="txtSubGroupCode" 
									ondblclick="funHelp('acSubGroupCode')" path="strSubGroupCode" readonly="true" cssClass="searchTextBox"/>
								</div>
								<div class="col-md-7"><s:input  type="text" placeholder="Sub Group Name" id="txtSubGroupName" 
									 path="strSubGroupName" required="true"/> <s:errors path=""></s:errors>
								</div>
							</div>		    			        			   
						</div>
						
						<div class="col-md-2">
							<label>Branch:</label><br>
								<s:input id="txtBranch" path="strBranch"/>
						</div>
						
						<div class="col-md-2">
						          <label>Opening Balance:</label>
									<s:input  type="number" placeholder="Opening Balance" id="txtOpeningBal" style="width:80%; text-align:right"
									step="0.0001" path="intOpeningBal" required="true" class="decimal-places numberField"/>
								<%-- <s:input  type="text" placeholder="Opening Balance" id="cmbOpeningBal" 
									 path="strCreditor" items="${listOpeningBalance}" cssClass="BoxW124px" /> --%>
						</div>
							
						<div class="col-md-1">
								<label>Dr/Cr</label>
									<s:select id="cmbDrCr" path="strCrDr" cssClass="BoxW124px" >
									    <option value="Cr">Cr</option>
										<option value="Dr">Dr</option>
									</s:select>
						</div>
						
						<div class="col-md-2"></div>
								
						<div class="col-md-2">
								<label>Employee Code</label>
									<s:input  type="text" id="txtEmployeeCode" step="0.0001" style="height:48%" readonly="true" 
									 path="strEmployeeCode" ondblclick="funHelp('employeeCode')" class="searchTextBox" />
					 </div>
					 
					 <div class="col-md-2">
								<label>Previous Year Balance</label>
									<s:input  type="text" placeholder="Previous Year Balance" id="txtPrevYearBal" step="0.0001" style="width:80%; text-align:right"
									 path="intPrevYearBal" items="${listOpeningBalance}" class="decimal-places numberField" required="true"/>
						</div>
							
						
						<div class="col-md-1">
								<label>Dr/Cr</label>
									<s:select id="cmbPrevDrCr" path="strCrDr" cssClass="BoxW124px" >
									    <option value="Cr">Cr</option>
										<option value="Dr">Dr</option>
									</s:select>
						</div>
							
					</div>
					<div class="center" style="margin-right: 8%;">
						<a href="#"><button class="btn btn-primary center-block" tabindex="3"
							value="Submit" onclick="return funValidation()" class="form_button">Submit</button></a> &nbsp
						 <a href="#"><button class="btn btn-primary center-block"
							type="reset" value="Reset" class="form_button"
							onclick="funResetField()">Reset</button></a>
					</div>
				</s:form>
			</div>
	</body>
</html>

