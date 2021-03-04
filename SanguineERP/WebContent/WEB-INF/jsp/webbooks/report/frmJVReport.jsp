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

function funHelp(transactionName)
{
	fieldName = transactionName;
//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	
}

	function funSetData(code)
	{
			$("#txtSOCode").val(code);
	}
	
	function funCallFormAction(actionName,object) 
	{
		if ($("#txtSOCode").val()=="") 
	    {
			 alert('Enter Voucher No');
			 $("#txtSODate").focus();
			 return false;  
	    }
	   	else
		{
			return true;	
		}
	}
	
	$(function()
	{
		$("#txtSOCode").blur(function() 
		{
			var code=$('#txtSOCode').val();
			if(code.trim().length > 0 && code !="?" && code !="/")
			{
				if(code.trim().length>12)
				{
					alert("Invalid Voucher No");
					$('#txtSOCode').val('');
				}	
			}
		});
		
	});
		
</script>

</head>
<body onload="funOnLoad();">
	<div class=" container transTable">
		<label id="formHeading">JV Report</label>
	
	<s:form name="JVReport" method="GET"
		action="rptJVReport.html" target="_blank" >
		<input type="hidden" value="${urlHits}" name="saddr">
		<br>
			<div class="row">
			   <div class="col-md-2"><label>Voucher No</label>
						<s:input path="strDocCode" id="txtSOCode"
								ondblclick="funHelp('JVNoslip')" readOnly="true"
								cssClass="searchTextBox" /></div>
																										
								
<!-- 					<tr> -->
<!-- 						<td><label>Currency </label></td> -->
									
<%-- 						<td><s:select id="cmbCurrency" items="${currencyList}" path="strCurrency" cssClass="BoxW124px"> --%>
<%-- 						</s:select></td> --%>
<!-- 					</tr> -->
								
			   <div class="col-md-1.1"><label>Report Type</label>
									  <s:select id="cmbDocType" path="strDocType"
											cssClass="BoxW124px">
											<s:option value="PDF">PDF</s:option>
											<s:option value="XLS">EXCEL</s:option>
											<s:option value="HTML">HTML</s:option>
											<s:option value="CSV">CSV</s:option>
										</s:select></div>
                                 
			   <div class="col-md-2"><label>Property</label></td>
									<td ><s:select id="cmbDocType" path="strPropertyCode"
											style="width:80%">
											<s:options items="${listProperty}"/>
										</s:select></div>
               </div>
            <br>   
		<p align="center" style="margin-right:41%">
			<input type="submit" value="Submit" class="btn btn-primary center-block"
				onclick="return funCallFormAction('submit',this)"
				class="form_button" />  &nbsp; <a
				STYLE="text-decoration: none"
				href="frmJVReport.html?saddr=${urlHits}"><input
				type="button" id="reset" name="reset" value="Reset" class="btn btn-primary center-block"
				class="form_button" /></a>
		</p>
		<br>
		<div id="wait"
			style="display: none; width: 60px; height: 60px; border: 0px solid black; position: absolute; top: 60%; left: 55%; padding: 2px;">
			<img
				src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif"
				width="60px" height="60px" />
		</div>
	</s:form>
	</div>
	<script type="text/javascript">
		funApplyNumberValidation();
	</script>
</body>
</html>