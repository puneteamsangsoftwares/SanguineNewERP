<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
  	<link rel="stylesheet" type="text/css" href="default.css" />
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Web Stocks</title>
      <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	  <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
 
    <script type="text/javascript">
    	
    	var fieldName;
    
    	/**
    	 * Reset text field
    	 */
    	function funResetFields()
    	{
    		$("#txtLocCode").val('');
    		$("#lblLocName").text("");
    	}
    	/**
		 * Open help form
		 */
    	function funHelp(transactionName)
		{
			fieldName=transactionName;
		//	 window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:700px;dialogLeft:300px;")
			 window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:700px;dialogLeft:300px;")
	    }
    	/**
		 *  Get Data from help Selection 
		**/
		function funSetData(code)
		{
			switch (fieldName) 
			{
			    case 'locationmaster':
			    	funSetLocation(code);
			        break;
			   
			}
		}
		/**
		* Get and set Location Data Passing value(Location Code)
	    **/
		function funSetLocation(code)
		{
			var searchUrl="";
			searchUrl=getContextPath()+"/loadLocationMasterData.html?locCode="+code;			
			$.ajax({
			        type: "GET",
			        url: searchUrl,
				    dataType: "json",
				    success: function(response)
				    {
				    	if(response.strLocCode=='Invalid Code')
				       	{
				       		alert("Invalid Location Code");
				       		$("#txtLocCode").val('');
				       		$("#lblLocName").text("");
				       		$("#txtLocCode").focus();
				       	}
				       	else
				       	{
				    	$("#txtLocCode").val(response.strLocCode);
		        		$("#lblLocName").text(response.strLocName);	
		        		$("#txtProdCode").focus();
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
	     * Ready function for on blur event in textfield
	    **/
		$(function() 
				{
					$('#txtLocCode').blur(function() {
						var code = $('#txtLocCode').val();
						if(code.trim().length > 0 && code !="?" && code !="/"){
							funSetLocation(code);
						}
					});
				});

		/**
		* Checking Validation when Submitig Data
		**/
		function funCallFormAction(actionName,object) 
		{	
			if($("#txtLocCode").val()=='')
		    {
		    	alert("Please enter Location Code");
		    	return false;
		    } 
		    else
			{
				if (actionName == 'submit') 
				{
						document.forms[0].action = "rptReorderLevelwise.html";
				}
			}
		}
    </script>
  </head>
  
<body >
<div class="container masterTable">
	<label id="formHeading">Location Wise Product ReOrder Level</label>
	  <s:form name="frmReorderLevelwise" method="GET" action="rptReorderLevelwise.html" target="_blank">
		
		<div class="row">
			 <div class="col-md-2"><label>Location Code</label>
					<s:input  id="txtLocCode" path="strDocCode" readonly="true" ondblclick="funHelp('locationmaster')" cssClass="searchTextBox" cssStyle="width:160px;background-position: 140px 4px;"/>
			  </div>
			
			  <div class="col-md-2"><label id="lblLocName" style="background-color:#dcdada94; width: 100%; height:51%;margin-top: 27px;padding:4px;"></label></div>
			  <div class="col-md-8"></div>
			  
			   <div class="col-md-2"><label>Report Type</label>
					<s:select id="cmbDocType" path="strDocType" style="width:auto;">
				    		<s:option value="PDF">PDF</s:option>
				    		<s:option value="XLS">EXCEL</s:option>
				    		<s:option value="HTML">HTML</s:option>
				    		<s:option value="CSV">CSV</s:option>
				    </s:select>
			   </div>
				
					<!-- <td><input type="submit" value="Submit" /></td>
					<td><input type="reset" value="Reset" onclick="funResetFields()"/></td>	 -->				
		</div>
			<br>
			<p align="center" style="margin-right: 49%;">
				<input type="submit" value="Submit" class="btn btn-primary center-block" class="form_button" onclick="return funCallFormAction('submit',this)" />
				&nbsp;
				<input type="button" value="Reset" class="btn btn-primary center-block" class="form_button"  onclick="funResetFields()"/>
			</p>
		</s:form>
		</div>
	</body>
</html>