<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<spring:url value="/resources/css/jquery.classyedit.css" var="classyEditCSS" />
<spring:url value="/resources/js/jquery.classyedit.js" var="classyEditJS" />
	
<link href="${classyEditCSS}" rel="stylesheet" />
<script src="${classyEditJS}"></script>    

<title></title>

  <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
	 
<style type="text/css">
	
	#txtLetterName
	{
		editable: false;
		required: true;
		readonly: true;
	}

	#tblOutStandingMonths td
	{
		 padding: 10px 67px 3px 10px;
		 background-color: #fafbfb;
		 
	}	

</style>
<script type="text/javascript">
	var fieldName;	
	

	$(document).ready(function()
	{
		$(".classy-editor").ClassyEdit();
	});
	
	/* generate Letter processing slip and call report */
    function funGenerateLetterProcessingSlip()
	{
		var letterCode='';
		var fromDate='';
		var toDate='';		
		
		<%
			if(session.getAttribute("letterCode")!=null)
			{
				%>letterCode='<%= session.getAttribute("letterCode").toString()%>';
				<%	
				session.removeAttribute("letterCode");
			}
			if(session.getAttribute("fromDate")!=null)
			{
				%>fromDate='<%= session.getAttribute("fromDate").toString()%>';
				<%		
				session.removeAttribute("fromDate");
			}
			if(session.getAttribute("toDate")!=null)
			{
				%>toDate='<%= session.getAttribute("toDate").toString()%>';
				<%				
				session.removeAttribute("toDate");
			}			
		%>			
		
		var isOk=confirm("Do You Want to Generate Slip?");
		if(isOk)
		{
			window.open(getContextPath()+"/rptLetterProcessingSlip.html?letterCode="+letterCode+"&fromDate="+fromDate+"&toDate="+toDate,'_blank');
		}	
	}

	function funValidate()
	{
		
		
		if($("#txtLetterName").val().trim().length<1)
		{
			alert("Please Select Letter.");
			$("#txtLetterName").focus();
			return false;
		}	
		else
		{
			
			var queryCondition="";

			var excludeMembers=$("#txtExcludeMembers").val();
			    
			if(excludeMembers.length==0)
			{
				queryCondition=$("#cmbParameters").val()+" "+$("#cmbOperations").val()+" '"+$("#txtValue").val()+"'";   
			}
			else
			{
				queryCondition=$("#cmbParameters").val()+" "+$("#cmbOperations").val()+" '"+$("#txtValue").val()+"' AND Customer_Code NOT IN ("+excludeMembers+") ";
			}	 
			
			$("#txtCondition").val(queryCondition);
				
			funValidateAndSubmitForm();			
		}	
			
	}
	
	/* To check sql syntax of criteria */
	function funValidateAndSubmitForm()
	{		
		var sqlQuery="";
		
	    var strCriteria=$("#cmbParameters").val()+" "+$("#cmbOperations").val()+" '"+$("#txtValue").val()+"'";	    
	    var excludeMembers=$("#txtExcludeMembers").val();
	    
	    if(excludeMembers.length==0)
	    {
	    	sqlQuery="select Customer_Code,Member_Full_Name from dbwebmms.vwdebtormemberdtl where "+strCriteria;	   
	    }
	    else
	    {
	    	sqlQuery="select Customer_Code,Member_Full_Name from dbwebmms.vwdebtormemberdtl where "+strCriteria+" and Customer_Code not in ("+excludeMembers+")";
	    }	    	    	  	   	    	  
	   	    
		var searchurl=getContextPath()+"/checkSQLQueryWithParameters.html?sqlQuery="+sqlQuery;
				
		$.ajax({
	        type: "GET",
	        url: searchurl,
	        dataType: "json",
	        success: function(response)
	        {          	            
	        	if(response.result=="true")
		        {		         
	        		// alert(response.result);		
		          	 $( "#formLetterProc" ).submit();		          
		        }	   
		        else
		        {
		           alert(response.result);		           
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
	
	/* when Enter key is press on textArea */
	$(document).ready(function()
	{
		$("#txtLetter").keypress(function(event)
		{ 
		    var keyCode = event.keyCode;   
		    if(keyCode==13)
		    {
		    	var strCriteria=$("#txtLetter").val();	
		    	$("#txtLetter").val(strCriteria+"\n");
		    	$(".editor").text(strCriteria+"\n");
		    }	
		});
	});
	
	function onViewORHideDtlsLinkClicked()
	{
		var linkText=$("#linkHideOrShowParamDtls").text();
		if(linkText=="Hide Parameter Details")
		{
			$("#linkHideOrShowParamDtls").text("Show Parameter Details");
			$("#divParamDetails").hide();
		}
		else
		{
			$("#linkHideOrShowParamDtls").text("Hide Parameter Details");
			$("#divParamDetails").show();
		}
	}

	/**
	* Success Message After Saving Record
	**/
	 $(document).ready(function()
	 {
		 
		 $("#txtDrDate").datepicker({
				dateFormat : 'dd-mm-yy'
			});
			$("#txtDrDate").datepicker('setDate', 'today');

			$("#txtCrDate").datepicker({
				dateFormat : 'dd-mm-yy'
			});
			$("#txtCrDate").datepicker('setDate', 'today');
		 
		 
		 
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
			
			funGenerateLetterProcessingSlip();
			
		<%
		}}%>

	}); 
	
	 function funSetDebtorMasterData(debtorCode)
		{
		   
			var searchurl=getContextPath()+"/loadSundryDebtorMasterData.html?debtorCode="+debtorCode;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strDebtorCode=='Invalid Code')
				        	{
				        		alert("Invalid Debtor Code");				        		
				        	}
				        	else
				        	{					        	    			        	    				        	   	
				        		var excludeMembers=$("#txtExcludeMembers").val();
				        		if(excludeMembers.trim().length>0)
				        		{
				        			$("#txtExcludeMembers").val(excludeMembers+",'"+response.strDebtorCode+"' ");
				        		}
				        		else
				        		{
				        			$("#txtExcludeMembers").val("'"+response.strDebtorCode+"'");
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
	
	 /* To Set Letter Data */
		function funSetLetterData(letterCode)
		{		
			var searchurl=getContextPath()+"/loadLetterMasterData.html?letterCode="+letterCode;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strLetterCode=='Invalid Code')
				        	{
				        		alert("Invalid Letter Code");
				        		$("#txtLetterCode").val('');
				        	}
				        	else
				        	{
				        		$("#txtLetterCode").val(response.strLetterCode);
					        	$("#txtLetterName").val(response.strLetterName);
					        	$("#txtLetterName").focus();
					        	$("#txtLetter").val(response.strArea);
					        	$(".editor").text(response.strArea);
					        	
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

	function funSetData(code)
	{
		switch(fieldName)
		{
			case "letterCode":
				funSetLetterData(code);
				break;
			case "debtorCode":
			     funSetDebtorMasterData(code);			    
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
 <div class="container masterTable">
	<label id="formHeading">Letter Processing</label>
	<s:form id="formLetterProc" name="LetterProcessing" method="POST" action="saveLetterProcessing.html">
			<div class="row">
			    <div class="col-md-2"><label>Letter Code</label>			    
			    	<s:input id="txtLetterCode" path="strLetterCode" readonly="true" required="true" style="height:36%" ondblclick="funHelp('letterCode')" cssClass="searchTextBox" type="text" placeholder="Letter Code"/>
			    </div>
			    <div class="col-md-3">		        			        			    
			    	<s:input id="txtLetterName"  path="strLetterName" readonly="true" type="text" placeholder="Letter Name" style="margin-top:27px;"/>
			    </div>
			      <div class="col-md-2"></div>
			     <div class="col-md-5">
			     	<a class="btn btn-primary center-block" id="linkHideOrShowParamDtls" href="#" onclick="onViewORHideDtlsLinkClicked()" style="margin-top:27px;">Hide Parameter Details</a>			  		        			  
				</div>
			   
			     <div class="col-md-3"><label>Letter Subject</label><br>
			           <s:textarea id="txtLetterSubject" path=""  style="resize:none;width:75%; overflow-y:scroll;"/>
			         <s:hidden id="txtCondition" path="strCondition"/>	
			     </div>
			</div>	
		<br />
		<div id="divParamDetails" style="width:82%;">
			<table class="transTablex" style="width: 100%; text-align:center;">
				<tr>
					<th>Parameters</th>
					<th>Operations</th>
					<th>Value</th>
					<th>Condition</th>
				</tr>
				<tr>
					<td><s:select id="cmbParameters" path="" items="${listParameters}"  style="width: 99%"></s:select></td>
					<td>
						<s:select id="cmbOperations" path=""  cssClass="BoxW124px" style="width: 99%">
						<s:option value="<"/>
						<s:option value="<="/>
						<s:option value="="/>
						<s:option value=">"/>
						<s:option value=">="/>
						</s:select>
					</td>
					<td><s:input id="txtValue" path="" required="true" cssClass="BoxW124px" cssStyle="width:98%"/></td>
					<td>
						<s:select id="cmbCondition" path=""  cssClass="BoxW124px" style="width: 99%">
						<s:option value="NONE"/>
						<s:option value="AND"/>
						<s:option value="OR"/>						
						</s:select>
					</td>
				</tr>
			</table>
		</div>
		<br>
		<div class="row">			
			 <div class="col-md-2"><label>Reminder Status Update Log</label>
			   <s:select id="cmbReminderStatusUpdateLog" path="" items="${listReminderStatusUpdateLog}" cssClass="BoxW124px"></s:select>
			 </div>		
			 		
			 <div class="col-md-3"><label>Letter Via Email</label><br>
			   <s:checkbox id="chkLetterViaEmail" path="" value="N"/>			
			</div>
			<br>
			 <div class="col-md-12"><label>Outstanding For The Months</label>
			 </div>	
				<div class="col-md-12">
						<table id="tblOutStandingMonths">
							<tr>
								<td><s:checkbox id="chkJan" label="January" path="" value="N" /></td>
								<td><s:checkbox id="chkFeb" label="February" path="" value="N"/></td>
								<td><s:checkbox id="chkMar" label="March" path="" value="N"/></td>
								<td><s:checkbox id="chkApr" label="April" path="" value="N"/></td>
							</tr>
							<tr>
								<td><s:checkbox id="chkMay" label="May" path="" value="N"/></td>
								<td><s:checkbox id="chkJun" label="June" path="" value="N"/></td>
								<td><s:checkbox id="chkJul" label="July" path="" value="N"/></td>
								<td><s:checkbox id="chkAug" label="August" path="" value="N"/></td>
							</tr>
							<tr>
								<td><s:checkbox id="chkSept" label="September" path="" value="N"/></td>
								<td><s:checkbox id="chkOct" label="October" path="" value="N"/></td>
								<td><s:checkbox id="chkNov" label="November" path="" value="N"/></td>
								<td><s:checkbox id="chkDec" label="December" path="" value="N"/></td>
							</tr>
						</table>
					</div>
					<br><br>
					
				<div class="col-md-12"><label>Exclude Members</label>	<br />
			 				<s:textarea id="txtExcludeMembers" path="" style="width:720px; height:75px; resize:none; overflow-y:scroll; " ondblclick="funHelp('debtorCode')" />
			 	</div>
			
				<div class="col-md-3">
					   <div class="row">
							<div class="col-md-6"><label>Dr Date</label>
			              		<s:input type="text" id="txtDrDate" class="calenderTextBox" style="height:50%" path="dteDrDate"  />
			   				 </div>
			   				 <div class="col-md-6"><label>Cr Date</label>
			        			   <s:input type="text" id="txtCrDate" class="calenderTextBox" style="height:50%" path="dteCrDate" />
							</div>
				</div></div>
		</div>	
		<br>
		<div id="divViewConainer">
			<s:textarea id="txtLetter" path="strLetter" style="width: 75%; height: 300px; background-color:#fafbfb; resize: none;" class="classy-editor" />					    						
		</div>
		<br />
		<p align="right" style="margin-right:130px;">
			<input id="btnSubmit" type="button" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button"  onclick="return funValidate()"/>&nbsp
			<input type="reset" value="Reset" class="btn btn-primary center-block"  class="form_button" onclick="funResetFields()"/>
		</p>
		<br />
		<br />
	</s:form>
	</div>
</body>
</html>
