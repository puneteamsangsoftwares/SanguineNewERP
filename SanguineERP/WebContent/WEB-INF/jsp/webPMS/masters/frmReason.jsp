<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Reason Master</title>
		<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	    <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

<script type="text/javascript">

	/**
	* Open Help
	**/
	function funHelp(transactionName)
	{
	    window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
// 	    window.open("searchform.html?formname=LocationToAllPropertyStore&searchText="+byLocation,"","dialogHeight:600px,dialogWidth:1000px,dialogLeft:200px")		       
	}
		
	
		/**
		*   Attached document Link
		**/
		$(function()
		{
		
			$('a#baseUrl').click(function() 
			{
				if($("#txtReasonCode").val().trim()=="")
				{
					alert("Please Select Reason Code");
					return false;
				}
			   window.open('attachDoc.html?transName=frmReason.jsp&formName=Reason Master&code='+$('#txtReasonCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
			});
			
			
			/**
			* On Blur Event on Reason Code Textfield
			**/
			$('#txtReasonCode').blur(function() 
			{
					var code = $('#txtReasonCode').val();
					if (code.trim().length > 0 && code !="?" && code !="/")
					{				
					 funSetData(code);						
					}
			});
			
			$('#txtReasonDesc').blur(function () {
				 var strReasonDesc=$('#txtReasonDesc').val();
			      var st = strReasonDesc.replace(/\s{2,}/g, ' ');
			      $('#txtReasonDesc').val(st);
				});
			
		});
		

		/**
		* Get and Set data from help file and load data Based on Selection Passing Value(Reason Code)
		**/
		
		function funSetData(code)
		{
			$("#txtReasonCode").val(code);
			var searchurl=getContextPath()+"/loadPMSReasonMasterData.html?reasonCode="+code;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strReasonCode=='Invalid Code')
				        	{
				        		alert("Invalid Reason Code");
				        		$("#txtReasonCode").val('');
				        	}
				        	else
				        	{
					        	$("#txtReasonDesc").val(response.strReasonDesc);
					        	$("#cmbReasonType").val(response.strReasonType);
					        	
					        	
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
	
	
		
		/**
		* Success Message After Saving Record
		**/
		$(document).ready(function()
		{
			var message='';
			<%if (session.getAttribute("success") != null) 
			{
				if(session.getAttribute("successMessage") != null)
				{%>
					message='<%=session.getAttribute("successMessage").toString()%>';
				    <%
				    session.removeAttribute("successMessage");
				}
				boolean test = ((Boolean) session.getAttribute("success")).booleanValue();
				session.removeAttribute("success");
				if (test) 
				{
					%>
					alert("Data Save successfully\n\n"+message);
				<%
				}
			}%>
		});
		

		/**
			 *  Check Validation Before Saving Record
		**/
		function funCallFormAction(actionName,object) 
		{
			var flg=true;
			if($('#txtReasonDesc').val()=='')
			{
				alert('Enter Reason Name ');
				flg=false;
			}
			return flg;
		}
		
		$('#baseUrl').click(function() 
				{  
					 if($("#txtReasonCode").val().trim()=="")
					{
						alert("Please Select Reason Code..  ");
						return false;
					} 
						window.open('attachDoc.html?transName=frmReason.jsp&formName=Member Profile&code='+$('#txtReasonCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
				});
</script>


</head>
<body>
	<div class="container masterTable">
		<label id="formHeading">Reason Master</label>
	    <s:form name="Reason" method="GET" action="saveReasonMaster.html?" >
	    <div class="row">
			<!-- <div class="col-md-12" align="center"><a id="baseUrl" href="#" style="display:none;"> Attach Documents</a>&nbsp; &nbsp; &nbsp; &nbsp;
			</div> -->
			
			<div class="col-md-2"><label>Reason Code</label>
				<s:input id="txtReasonCode" path="strReasonCode" cssClass="searchTextBox" style="height: 48%" ondblclick="funHelp('reasonPMS')" />			
			</div>
			
			<div class="col-md-2"><label>Reason Description</label>
				<s:input id="txtReasonDesc" path="strReasonDesc"/>
			</div>
			<div class="col-md-8"></div>
			<div class="col-md-2"><label>Select Reason Type</label>
				   <s:select id="cmbReasonType" path="strReasonType">
				   		<option selected="selected" value="Management Reason">Management Reason</option>
			         	<option value="Allowance Reason">Allowance Reason</option>
			          	<option value="Cancellation Reason">Cancellation Reason</option>
			          	<option value="Discount Reason">Discount Reason</option>
			          	<option value="Movement Reason">Movement Reason</option>
			          	<option value="Maintainance Reason"> Maintainance Reason </option>
			         	<option value="Undo Check-in Reason">Undo Check-in Reason</option>
		         	</s:select>
			</div>
		</div>
		
		<p align="center" style="margin-right:48%">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button"  onclick="return funCallFormAction('submit',this);" />&nbsp;
            <input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" />   
		</p>
	</s:form>
	</div>
</body>
</html>
