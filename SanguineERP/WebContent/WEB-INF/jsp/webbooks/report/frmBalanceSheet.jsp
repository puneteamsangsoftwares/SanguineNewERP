<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<title>Insert title here</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

        <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
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
		$("#txtFromDate" ).datepicker('setDate', 'today');
		*/
		var startDate="${startDate}";
		var arr = startDate.split("/");
		Dat=arr[0]+"-"+arr[1]+"-"+arr[2];
		$( "#txtFromDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtFromDate" ).datepicker('setDate', Dat);
		$( "#txtToDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtToDate" ).datepicker('setDate', 'today');
		
		

	});
	
	function funOnSubmitBtn(){
		var clientCode=	'<%=session.getAttribute("clientCode").toString()%>';
		
		if($("#cmbDocType").val()=='PDF'){
			document.frmBalanceSheet.action="rptBalanceSheet1.html";
		}else{
			if(clientCode=='261.001'){
				document.frmBalanceSheet.action="rptBalanceSheet2.html";
//				$("#formTag").attr("action", "rptBalanceSheet2.html");	
			}else{
				document.frmBalanceSheet.action="rptBalanceSheet1.html";
				
				//$("#formTag").attr("action", "rptBalanceSheet.html");
			}
		}
				document.frmBalanceSheet.submit();  

 		/* document.frmVoidStock.action="voidStock.html?stkCode="+ stkCode;
 		document.frmVoidStock.submit(); */
	}
</script>
<body>
<div class=" container transTable">
		<label id="formHeading">Balance Sheet</label>

	<s:form name="frmBalanceSheet" method="GET" action="" target="_blank">
			<div class="row">
			     <div class="col-md-3">
			        <div class="row">
					     <div class="col-md-6"><label>From Date </label>
							<s:input id="txtFromDate" path="dteFromDate" required="true" readonly="readonly" style="height:50%" cssClass="calenderTextBox"/>
					    </div>
					     <div class="col-md-6" width="10%"><label>To Date </label>
							<s:input id="txtToDate" path="dteToDate" required="true" readonly="readonly" style="height:50%" cssClass="calenderTextBox"/>
					      </div>
				  </div></div>	
				  
			     <div class="col-md-3">
			        <div class="row">
					   <div class="col-md-6"><label>Report Type</label>
							<s:select id="cmbDocType" path="strDocType" cssClass="BoxW124px">
				    		<s:option value="PDF">PDF</s:option>
				    		<s:option value="XLS">EXCEL</s:option>
				    		</s:select></div>
				    	<div class="col-md-6"></div>
				  </div></div>
				<%-- <tr>
					<td><label>Currency </label></td>
					<td><s:select id="cmbCurrency" items="${currencyList}" path="strCurrency" cssClass="BoxW124px">
						</s:select></td>
					<td colspan="2"></td>
				</tr> --%>
		</div><br />
		<p align="center" style="margin-right:40%">
				<input type="submit" value="Submit" class="btn btn-primary center-block" class="form_button" onclick="funOnSubmitBtn()"/>&nbsp
				 <input type="button" value="Reset" class="btn btn-primary center-block" class="form_button"  onclick="funResetFields()"/>
			</p>
	</s:form>
</div>
</body>
</html>