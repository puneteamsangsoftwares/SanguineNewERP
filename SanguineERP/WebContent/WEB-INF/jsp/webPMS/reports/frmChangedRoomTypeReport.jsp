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
	    <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	    <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

<script type="text/javascript">
	var fieldName;
    
	
	function funValidateFields()
	{
		var flag=true;
		var fromDate=$("#dteFromDate").val();
		var toDate=$("#dteToDate").val();
		
		var fd=fromDate.split("-")[0];
		var fm=fromDate.split("-")[1];
		var fy=fromDate.split("-")[2];
		
		var td=toDate.split("-")[0];
		var tm=toDate.split("-")[1];
		var ty=toDate.split("-")[2];
		
		
		
		var against=$("#cmbType").val();
		window.open(getContextPath()+"/rptChangedRoomTypeReport.html?fromDate="+fromDate+"&toDate="+toDate+"");
		/*if(against=='Reservation')
		{
			window.open(getContextPath()+"/rptChangedRoomTypeReport.html?fromDate="+fromDate+"&toDate="+toDate+"&against="+against+ "");
		}else{
		window.open(getContextPath()+"/rptChangedRoomTypeReport.html?fromDate="+fromDate+"&toDate="+toDate+"&against="+against+ "");
	    }	
		*/
		
		return flag;
	}
	
	
	/**
	* Success Message After Saving Record
	**/
	 $(document).ready(function()
				{
		var message='';
		<%if (session.getAttribute("success") != null) {
			            if(session.getAttribute("successMessage") != null){%>
			            message='<%=session.getAttribute("successMessage").toString()%>';
			            <%
			            session.removeAttribute("successMessage");
			            }
						boolean test = ((Boolean) session.getAttribute("success")).booleanValue();
						session.removeAttribute("success");
						if (test) {
						%>	
			alert("Data Save successfully\n\n"+message);
		<%
		}}%>
		
		 var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
		  var dte=pmsDate.split("-");
		  $("#txtPMSDate").val(dte[2]+"-"+dte[1]+"-"+dte[0]);

	});
	
	
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
	
	function funSetData(code)
	{
		switch(fieldName)
		{
			case "reservationForBill":
				funSetBillNo(code);
				break;
				
			case "checkInForBill":
				funSetBillNo(code);
				break;
		}
	}

	function funHelp(transactionName)
	{
		fieldName=transactionName;
		var fromDate=$("#dteFromDate").val();
		var toDate=$("#dteToDate").val();
		var fDate=fromDate.split("-");
	    var tDate=toDate.split("-");
	    fromDate=fDate[2]+"-"+fDate[1]+"-"+fDate[0];
	    toDate=tDate[2]+"-"+tDate[1]+"-"+tDate[0];
		var type=$("#cmbType").val();
		if(type=='Reservation')
		{
		window.open("searchform.html?formname="+transactionName+"&fromDate="+fromDate+"&toDate="+toDate+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
		//window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
		}else{
			transactionName="checkInForBill";
		    fieldName=transactionName;
		    window.open("searchform.html?formname="+transactionName+"&fromDate="+fromDate+"&toDate="+toDate+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
		}
		}
</script>

</head>
<body>
  <div class="container masterTable">
	<label id="formHeading">Changed Room Type Report</label>
	<s:form name="ChangedRoomTypeReport" method="GET" action="">
        <div class="row">
				<div class="col-md-2"><label>From Date</label>
						<s:input type="text" id="dteFromDate" path="dteFromDate" required="true" class="calenderTextBox" style="height:55%;width: 70%"/>
				</div>
				<div class="col-md-2"><label>To Date</label>
						<s:input type="text" id="dteToDate" path="dteToDate" required="true" class="calenderTextBox" style="height:55%;width: 70%;margin-left: -50px;"/>
				</div>				
			</div>
		
		<br />
		<p align="center" style="margin-right:67%">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" onclick="return funValidateFields()" />&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>						
	</s:form>
	</div>
</body>
</html>
