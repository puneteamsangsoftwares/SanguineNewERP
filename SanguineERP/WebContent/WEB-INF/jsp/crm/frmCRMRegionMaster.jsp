<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<meta http-equiv="X-UA-Compatible" content="IE=8">

<title></title>
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
   /*  height: 200px; */
}
</style>
<script type="text/javascript">

/*On form Load It Reset form :Ritesh 22 Nov 2014*/

   //Textfiled On blur geting data
	$(function() {
		
		$('#txtRegionCode').blur(function() {
			var code = $('#txtRegionCode').val();
			if(code.trim().length > 0 && code !="?" && code !="/")
			{
				funSetData(code);
			}
		});
	});

	/**
	* Reset The category Name TextField
	**/
	function funResetFields()
	{
		$("#txtRegionDesc").val("");
		$("#txtRegionCode").val("");
		
    }
	
	
		/**
		* Open Help
		**/
		function funHelp(transactionName)
		{	       
	       window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	    }
		
		/**
		* Get and Set data from help file and load data Based on Selection Passing Value(category Code)
		**/
		function funSetData(code)
		{
			$("#txtRegionCode").val(code);
			var searchurl=getContextPath()+"/loadCRMRegionMasterData.html?code="+code;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strRegionCode==null)
				        	{
				        		alert("Invalid Region Code");
				        		$("#txtRegionCode").val('');
				        	}
				        	else
				        	{
					        	$("#txtRegionDesc").val(response.strRegionDesc);
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
</script>


</head>

<body >
	<div class="container">
		<label id="formHeading">Region Master</label>
		<s:form name="manufactureForm" method="POST" action="saveCRMRegionMaster.html?saddr=${urlHits}">
		<div class="row transTable">
			<div class="col-md-2">
				<label>Region Code:</label><br>
				<s:input id="txtRegionCode" path="strRegionCode" type="text"
						cssClass="searchTextBox"  ondblclick="funHelp('crmRegionMaster')" />  <!-- cssClass="jQKeyboard form-control"   -->
			</div>
			<div class="col-md-3">
				<label>Region Desc</label><br>
				<s:input colspan="3" type="text" id="txtRegionDesc" path="strRegionDesc" required="true"
						cssStyle="text-transform: uppercase;"/> <!-- cssClass="jQKeyboard form-control"   -->
			</div>
			<div class="col-md-4"></div>
			
			
			
		</div>
		<div class="center" style="text-align:right; margin-right:63%;">
			<a href="#"><button class="btn btn-primary center-block"  tabindex="3" value="Submit" onclick="" 
				class="form_button">Submit</button></a> &nbsp;
			<a href="#"><button class="btn btn-primary center-block" value="Reset" onclick="funResetField()"
				class="form_button">Reset</button></a>
		</div>
		
		</s:form>
	</div>
</body>
</html>
