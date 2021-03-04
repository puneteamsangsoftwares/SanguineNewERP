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
        <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	    <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	    <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

</head>

<script>


	function funValidateFields()
	{
		//var flag=false;
			//flag=true;
			
			var fromDate=$("#dteFromDate").val();
			var toDate=$("#dteToDate").val();
			
			var fd=fromDate.split("-")[0];
			var fm=fromDate.split("-")[1];
			var fy=fromDate.split("-")[2];
			
			var td=toDate.split("-")[0];
			var tm=toDate.split("-")[1];
			var ty=toDate.split("-")[2];
			
			/* $("#dteFromDate").val(fy+"-"+fm+"-"+fd);
			$("#dteToDate").val(ty+"-"+tm+"-"+td); */
			
			
			$("#dteFromDate").val(fd+"-"+fm+"-"+fy);
			$("#dteToDate").val(td+"-"+tm+"-"+ty);
			
			 if($("#cmbSelectType").val()=="CheckIn")
		  		 {
				         window.open(getContextPath()+"/rptCheckInList.html?fromDate="+fy+"-"+fm+"-"+fd+"&toDate="+ty+"-"+tm+"-"+td+" ");
				 }
			 else if($("#cmbSelectType").val()=="Occupancy")
				 {
						 document.frmCheckInList.action = "rptOccupancyReportExport.html";
						 document.frmCheckInList.method = "POST";
				 }
				 else 
		  		 {
					     document.frmCheckInList.action = "rptInHouseReportExport.html";
					  	 document.frmCheckInList.method = "POST";
						
		         }
				
			 
			 
			
			
			
		
		//return flag;
	}


//set date
		$(document).ready(function(){
			
			var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
			
			$("#dteFromDate").datepicker({
				dateFormat : 'dd-mm-yy'
			});
			$("#dteFromDate").datepicker('setDate', pmsDate);	
			
			
			$("#dteToDate").datepicker({
				dateFormat : 'dd-mm-yy'
			});
			$("#dteToDate").datepicker('setDate', pmsDate);	
		});
		
		
		
		
</script>
<body onload="funOnLoad();">
  <div class="container masterTable">
		<label id="formHeading">Check-In List Occupancy AND In House Report</label>
	<s:form name="frmCheckInList" method="GET" action="" >
		
	<div class="row">
		<div class="col-md-3">
			<div class="row">
						<div class="col-md-6"><label>From Date</label>
								<s:input type="text" id="dteFromDate" path="dteFromDate" required="true" class="calenderTextBox" />
						</div>
						<div class="col-md-6"><label>To Date</label>
								<s:input type="text" id="dteToDate" path="dteToDate" required="true" class="calenderTextBox" />
						</div>				
		 </div></div>
	 </div>
	 <div class="row">
	  <div class="col-md-3">
	  <label>Select Type </label>
	  <s:select id="cmbSelectType" path="strSelectType" style="width:auto;">
				<s:option value="CheckIn">Check In List</s:option>
				<s:option value="Occupancy">Occupancy Report</s:option>
			    <s:option value="InHouse">In House Report</s:option>
     </s:select>
     </div>
     </div>
	 
		<br>
	<p align="center" style="margin-right:67%">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" onclick="return funValidateFields()" />
			&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>	
	</s:form>
   </div>
</body>
</html>