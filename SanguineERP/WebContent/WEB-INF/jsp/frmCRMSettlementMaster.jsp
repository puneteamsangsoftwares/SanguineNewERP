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

<style>
.ui-autocomplete {
    max-height: 200px;
    overflow-y: auto;
    /* prevent horizontal scrollbar */
    overflow-x: hidden;
    /* add padding to account for vertical scrollbar */
    padding-right: 20px;
}
/* IE 6 doesn't support max-height
 * we use height instead, but this forces the menu to always be this tall
 */
* html .ui-autocomplete {
    height: 200px;
}
</style>
<script type="text/javascript">

	var settlemantWiseSeries='No';
	var clickCount =0.0;

	//Textfiled On blur geting data
	$(function() {
		
		$('#txtSettlementCode').blur(function() {
			var code = $('#txtSettlementCode').val();
			if(code.trim().length > 0 && code !="?" && code !="/")
			{
				funSetData(code);
			}
		});
		
		settlemantWiseSeries="${selltemetInv}";
		
		if( "${moduleNo}" == 1)
		{
			
		 	$('#txtInvSeriesChar').css('visibility','hidden');
		    $('#lblsettleMaster').css('visibility','hidden');
		
		}
	});



	/**
	* Reset The Group Name TextField
	**/
	function funResetFields()
	{
		$("#txtFactoryName").focus();
		
    }
	
	
		/**
		* Open Help
		**/
		function funHelp(transactionName)
		{	       
	       // window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	       window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	    }
		
		/**
		* Get and Set data from help file and load data Based on Selection Passing Value(Group Code)
		**/
		function funSetData(code)
		{
			$("#txtSettlementCode").val(code);
			var searchurl=getContextPath()+"/loadSettlementMasterData.html?code="+code;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strSettlementCode=='Invalid Code')
				        	{
				        		alert("Invalid Settlement Code");
				        		$("#txtSettlementCode").val('');
				        	}
				        	else
				        	{
					        	$("#txtSettlementDesc").val(response.strSettlementDesc);
					        	$("#cmbSettlementType").val(response.strSettlementType);
					        	$("#txtInvSeriesChar").val(response.strInvSeriesChar);
					        	
					        	if(response.strApplicable=='true')
				        		{
					        		$("#chkApplicable").prop('checked',true);
				        		}
					        	else
					        		$("#chkApplicable").prop('checked',false);
					        	$("#txtSettlementDesc").focus();
					        	
					        	
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
					%>alert("Data Saved \n\n"+message);<%
				}
			}%>
		});
		
		function funValidateFields()
		{
			if(clickCount==0){
				clickCount=clickCount+1;
			if(settlemantWiseSeries=='Yes')
			{
				
				if($("#txtInvSeriesChar").val().trim()=="")
				{
					alert("Please Fill Settlement Wise Series");
					return false;
				}
			}
			return true;
			}
			else
			{
				
				return false;
				
			}
	    }
</script>


</head>

<body>

	<div class="container">
		<label id="formHeading">Settlement Master</label>
		<s:form name="manufactureForm" method="POST" action="saveCRMSettlementMaster.html?saddr=${urlHits}">
			<div class="row masterTable">
				<div class="col-md-2">
					<label>Settlement Code:</label>
					<s:input id="txtSettlementCode" path="strSettlementCode"
						cssClass="searchTextBox"  ondblclick="funHelp('settlementMaster')" /> <!-- class=" jQKeyboard form-control" -->
				</div>
				<div class="col-md-2">
					<label>Settlement Desc</label>
					<s:input type="text" id="txtSettlementDesc" path="strSettlementDesc" required="true"
						cssStyle="text-transform: uppercase;" /> <!-- class=" jQKeyboard form-control" -->
				</div>
				<div class="col-md-2">
					<label>Settlement Type</label>	
					<s:select id="cmbSettlementType" path="strSettlementType">
				    	<option selected="selected" value="Cash">Cash</option>
				    	<option value="Credit Card">Credit Card</option>
				    	<option value="Credit">Credit</option>
				    	<option value="Online Payment">Online Payment</option>
		         	</s:select>					
				</div>
				<div class="col-md-6"></div>
				<div class="col-md-2">
					<label>Applicable</label><br>
					<input type="checkbox" id="chkApplicable" 
						name="chkApplicable" path="strApplicable" value="true" />
				</div>
				<div class="col-md-2">
					<label id="lblsettleMaster">Settlement Wise Invoice Series </label>
						<s:select id="txtInvSeriesChar" path="strInvSeriesChar" items="${alphabetList}" style="width:60%;">
		         		</s:select>	
				</div>	
			</div>
			<div class="center" style="text-align:right; margin-right:52%;">
				<a href="#"><button class="btn btn-primary center-block"  tabindex="3" value="Submit" onclick="return funValidateFields()"
					class="form_button">Submit</button></a>
				<a href="#"><button class="btn btn-primary center-block" value="Reset" onclick="funResetField()"
					class="form_button">Reset</button></a>
			</div>
	</s:form>
</div>
</body>
</html>
