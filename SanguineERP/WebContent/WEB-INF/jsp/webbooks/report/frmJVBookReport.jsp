<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>JV Book</title>
        <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	    <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

</head>
<script type="text/javascript">
	$(function() {
		$(document).ajaxStart(function() {
			$("#wait").css("display", "block");
		});
		$(document).ajaxComplete(function() {
			$("#wait").css("display", "none");
		});
		/*$( "#txtFromDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtFromDate" ).datepicker('setDate', 'today');*/
		var startDate="${startDate}";
		var arr = startDate.split("/");
		Dat=arr[0]+"-"+arr[1]+"-"+arr[2];
		$( "#txtFromDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtFromDate" ).datepicker('setDate', Dat);
		$( "#txtToDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtToDate" ).datepicker('setDate', 'today');
		
		

	});
</script>
<body>
   <div class=" container transTable">
		<label id="formHeading">JV Book Report</label>
	
	<s:form name="JVBook" method="GET" action="rptJVBookReport.html" target="_blank">
		<div class="row">
		           <div class="col-md-3">
					   <div class="row">
			    	        <div class="col-md-6"><label>From Date </label>
						          <s:input id="txtFromDate" path="dteFromDate" style="height:50%" required="true" readonly="readonly" cssClass="calenderTextBox"/>
					        </div>
				            <div class="col-md-6"><label>To Date </label>
					               <s:input id="txtToDate" path="dteToDate" style="height:50%" required="true" readonly="readonly" cssClass="calenderTextBox"/>
					        </div>
				  </div></div>
					<div class="col-md-2"><label>JV Type</label>
					        <s:select id="cmbJVType"  items="${JVTypeList}" path="strDocType" cssClass="BoxW124px">
						    </s:select>
					</div>
			
<!-- 				 <tr> -->
				 
<!-- 					<td><label>Currency </label></td> -->
<%-- 					<td><s:select id="cmbCurrency" items="${currencyList}" path="strCurrency" cssClass="BoxW124px"> --%>
<%-- 						</s:select></td> --%>
<!-- 				<td></td> -->
<!-- 				</tr>  -->
		
		</div><br>
		<p align="center" style="margin-right:31%">
				<input type="submit" value="Submit" class="btn btn-primary center-block" class="form_button" />&nbsp
				 <input type="button" value="Reset" class="btn btn-primary center-block" class="form_button"  onclick="funResetFields()"/>
			</p>
	</s:form>
    </div>
</body>
</html>