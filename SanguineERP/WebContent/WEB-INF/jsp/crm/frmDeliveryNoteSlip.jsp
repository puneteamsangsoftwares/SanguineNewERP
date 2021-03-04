<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>

</head>
<body onload="funOnLoad();">
   <div class="container">
		<label id="formHeading">Delivery Note Slip</label>
	    <s:form name="DeliveryNoteSlip" method="GET"
		action="" >
		<input type="hidden" value="${urlHits}" name="saddr">
		<br>
		     <div class="row">
							<div class="col-md-4">
								<div class="row">		
									<div class="col-md-5"><label>Delivery Note Code</label>
										<s:input path="strDocCode" id="txtJOCode"
											ondblclick="funHelp('')"
											cssClass="searchTextBox" /></div>
									<div class="col-md-7"><label id="lblJobOrderName"
										class="namelabel" style="background-color:#dcdada94; width: 100%; height: 50%; margin-top:14%"></label></div>
							</div></div>
								
				<div class="col-md-1.1"><label>Report Type</label>
				      <s:select id="cmbDocType" path="strDocType">
						<s:option value="PDF">INVOICE</s:option>
						<s:option value="XLS">Challan</s:option>
					  </s:select>
			    </div>
		</div>
        <br>
		<p align="right" style="margin-right:60%">
			<input type="submit" value="Submit"
				onclick="return funCallFormAction('submit',this)" class="btn btn-primary center-block"
				class="form_button" /> &nbsp; 
				<a STYLE="text-decoration: none"
				href="frmDeliveryNoteSlip.html?saddr=${urlHits}"><input
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