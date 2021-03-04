<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
     <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
    
</head>
<script type="text/javascript">
//set date
$(document).ready(function(){
	
	var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
	
	$("#dteFromDate").datepicker({
		dateFormat : 'dd-mm-yy'
	});
	$("#dteFromDate").datepicker('setDate', pmsDate);
	
	
	$("#dteTodate").datepicker({
		dateFormat : 'dd-mm-yy'
	});
	$("#dteTodate").datepicker('setDate', pmsDate);

});
</script>

<body>
	<div class="container masterTable">
	   <label id="formHeading">Guest List Report </label>
	<s:form name="BillPrinting" method="GET" action="rptGuestListReport.html" target="_blank"> 
	<div class="row">
            <div class="col-md-3">
			    <div class="row">
					<div class="col-md-6"><label>From Date</label>
				           <s:input type="text" id="dteFromDate" path="dteFromDate" required="true" class="calenderTextBox" />
				    </div>
				    <div class="col-md-6"><label>To Date</label>
				           <s:input type="text" id="dteTodate" path="dteTodate" required="true" class="calenderTextBox" />
				    </div>	
			     </div>
		     </div></div>
			
			<br/>
		<p align="center" style="margin-right:66%">
		   	<input type="submit" value="Submit" tabindex="3"  class="btn btn-primary center-block" class="form_button" onclick="return funValidateFields()"/>
			&nbsp;  <input type="button" value="Reset" class="btn btn-primary center-block"
				class="form_button" onclick="funResetFields();" />
		</p>
	    </s:form>
       </div>	

</body>
</html>