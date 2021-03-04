<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
   <head>
   <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta http-equiv="X-UA-Compatible" content="IE=8">
<title></title>
	 	<%-- <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/materialdesignicons.min.css"/>" />
	  	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.css"/>" /> --%>
		<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<%-- <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" /> --%>
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 	<link rel="stylesheet" href="path/to/font-awesome/css/font-awesome.min.css">
	 	
	 	
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<%-- <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.js"/>"></script> --%>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
	 
		
		
</head>
<body>
<div class="container">
	<label id="formHeading">Member History</label>
		<s:form name="frmMemberHistory" action="saveMemberHistory.html?saddr=${urlHits}" method="POST">
			<div class="row masterTable">
				<div class="col-md-6">
					<label>Member Category Code:</label>
						<div class="row">
							<div class="col-md-6"><s:input id="txtMCCode" path=""
								cssClass="searchTextBox" ondblclick=""
								placeholder="Member Category Code" type="text"></s:input>
							</div>
							<div class="col-md-6"><s:input type="text" id="txtMCName" 
								name="txtMCName" path="" required="true"
								placeholder="Member Category Code"/><s:errors path=""></s:errors>
							</div>
						</div>
				</div>	
				<div class="col-md-6">
					<div class="row">
						<div class="col-md-6">
							<label>From Date:</label>
								<s:input id="txtdtMemberFromDate" name="txtdtMemberFromDate" path="" cssClass="calenderTextBox" type="text"/>
						</div>
						<div class="col-md-6">
							<label>To Date:</label>
								 <s:input id="txtdtMemberToDate" name="txtdtMemberToDate" path=""  cssClass="calenderTextBox" type="text"/>
						</div>
					</div>
				</div>
			</div>
			<div class="center">
				<a href="#"><button class="btn btn-primary center-block" tabindex="3" value="Submit" onclick=""
					class="form_button">Submit</button></a>
				<a href="#"><button class="btn btn-primary center-block" type="reset"
					value="Reset" class="form_button" onclick="funResetField()" >Reset</button></a>
			</div>
		</s:form>
	</div>
</body>
</html>
<%-- <div id="formHeading">
	<label>Member History</label>
	</div>
	<div>
	<s:form name="frmMemberHistory" action="saveMemberHistory.html?saddr=${urlHits}" method="POST">
		<br>
		<table class="masterTable">
		
		<tr>
				<td width="15%">Member Category Code</td>
				<td width="10%"><s:input id="txtMCCode" path=""
						cssClass="searchTextBox" ondblclick="" /></td>
				<td width="50%"><s:input type="text" id="txtMCName" 
						name="txtMCName" path="" required="true"
						cssStyle="text-transform: uppercase;" cssClass="longTextBox"  /> <s:errors path=""></s:errors></td>
			</tr>
			
			 <tr>
				<td><label>From Date</label></td>
			    <td><s:input id="txtdtMemberFromDate" name="txtdtMemberFromDate" path=""  cssClass="calenderTextBox" /></td>
				
				<td><label>To Date</label>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;
			    <s:input id="txtdtMemberToDate" name="txtdtMemberToDate" path=""  cssClass="calenderTextBox" /></td>
		</tr>
		
		 
		</table> 
		<!-- <br>
		<p align="center">
			<input type="submit" value="Submit"
				onclick=""
				class="form_button" /> &nbsp; &nbsp; &nbsp; <input type="reset"
				value="Reset" class="form_button" onclick="funResetField()" />
		</p>
		<br><br> -->
	
	<div class="container"  style="background-color:#f2f2f2;" class="transtable masterTable"">
			<div class="row" font-size: 14px;color: #4a4a4a;" >
  				<div class="col-md-6"><label>Member Category Code</label><s:input id="txtMCCode" path=""
						cssClass="searchTextBox" ondblclick="" />&nbsp&nbsp<s:input type="text" id="txtMCName" 
						name="txtMCName" path="" required="true"
						cssStyle="text-transform: uppercase;" cssClass="longTextBox"  /> <s:errors path=""></s:errors></div>
  				<div class="col-md-3"><label>From Date</label><s:input id="txtdtMemberFromDate" name="txtdtMemberFromDate" path=""  cssClass="calenderTextBox" /></div>
  				<div class="col-md-3"><label>To Date</label> <s:input id="txtdtMemberToDate" name="txtdtMemberToDate" path=""  cssClass="calenderTextBox" /></div><br><br><br></div><br>
  				
  				<div class="col-md-6"></div>
  				<div class="col-md-6"><input type="submit" value="Submit"
				onclick=""
				class="form_button" /> &nbsp; &nbsp; &nbsp; <input type="reset"
				value="Reset" class="form_button" onclick="funResetField()" /></div>
  				
	</s:form>
</div>
 --%>
