<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript">
$(document).ready(function() 
		{
				var startDate="${startDate}";
				var arr = startDate.split("/");
				Dat=arr[2]+"-"+arr[1]+"-"+arr[0];
			    $("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
				$("#txtFromDate" ).datepicker('setDate', Dat);
				$("#txtFromDate").datepicker();
				
				$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
				$("#txtToDate" ).datepicker('setDate', 'today');
				$("#txtToDate").datepicker();
       });



			function funHelp(transactionName)
			{
				fieldName=transactionName;
			    
			  //  window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
			   window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
			}
			
			
			
			
			function funSetData(code)
			{
				switch (fieldName) 
				{		   
				   case 'subContractor':
					   $("#txtJOCode").val(code);
				        break;
				   
				}
			}
			
			
		
			
</script>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>

        <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	    <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
    
</head>
<body onload="funOnLoad();">
	<div class="container transTable">
		<label id="formHeading">Delivery Note List</label>
       <s:form name="DeliveryNoteList" method="GET"
		action="rptDeliveryNoteList.html" >
		<input type="hidden" value="${urlHits}" name="saddr">
		<br>
		    <div class="row">
		    	<div class="col-md-3">
					<div class="row">
		             	<div class="col-md-6"><label>From Date</label>
								<s:input path="dtFromDate" id="txtFromDate"
											required="required" cssClass="calenderTextBox" />
					  	</div>
					  	<div class="col-md-6"><label>To Date</label>
								<s:input path="dtToDate" id="txtToDate"
											 required="required"
											cssClass="calenderTextBox  " />
						</div>
				</div></div>
				<div class="col-md-9"></div>
<!-- 								<tr> -->
								

<!-- 							<td><label>Sub Contractor Permission Type</label></td> -->
<%-- 							<td ><s:select id="cmbDocType" path="strDocType" --%>
<%-- 									cssClass="BoxW124px"> --%>
<%-- 									<s:option value="PDF">All</s:option> --%>
<%-- 									<s:option value="XLS">Permitted</s:option> --%>
<%-- 									<s:option value="HTML">General</s:option> --%>
						
<%-- 					                </s:select></td> --%>



					
<!-- 							 	</tr> -->
								<div class="col-md-2"><label>Sub-Contractor</label>
									   <s:input path="strDocCode" id="txtJOCode"
											ondblclick="funHelp('subContractor')" style="height: 48%;"/>
								</div>
														
								<div class="col-md-1.1"><label>Export Type</label>
								       <s:select id="cmbType" path="strDocType">
										<s:option value="PDF">PDF</s:option>
										<s:option value="EXCEL">EXCEL</s:option>
									   </s:select>
							     </div>
								
		</div>
		<br>
		<p align="right" style="margin-right: 77%">
			<input type="submit" value="Submit"
				onclick="return funCallFormAction('submit',this)" class="btn btn-primary center-block"
				class="form_button" /> &nbsp;
			 <a STYLE="text-decoration: none"
				href="frmDeliveryNoteList.html?saddr=${urlHits}"><input
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
</body>
</html>