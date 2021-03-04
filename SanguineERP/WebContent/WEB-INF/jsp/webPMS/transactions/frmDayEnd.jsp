<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
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

	$(function() 
	{
		var startDay='<%=session.getAttribute("PMSStartDay").toString()%>';
		if(startDay=='N')
		{
			//$("#btnDayEnd").prop("disabled", true);
		}
		
		$("#btnStartDay").click(function()
		{
			funStartPMSDay();
		});
		
		
		var data = '${POSData}';
		var postData = '${POSDayStart}';
		if(data == '')
		{
			
		}
		else
		{
			alert(data);
		}
		if(postData == '')
		{
		
		}
		else
		{
			alert(postData);
		}
	});
		
	
	function funStartPMSDay()
	{
		var searchUrl=getContextPath()+"/startPMSDay.html?PMSDate="+$("#txtPMSDate").val();
		
		$.ajax({
	        type: "GET",
	        url: searchUrl,
	        dataType: "json",
	        success: function(response)
	        {
				if(response==1)
				{
					$("#btnDayEnd").prop("disabled", false);
					$("#btnStartDay").prop("disabled", true);
					alert("Day Started");
				}
			},
			error: function(jqXHR, exception) {
	            if (jqXHR.status === 0) {
	                $.jAlert('Not connect.n Verify Network.');
	            } else if (jqXHR.status == 404) {
	                $.jAlert('Requested page not found. [404]');
	            } else if (jqXHR.status == 500) {
	                $.jAlert('Internal Server Error [500].');
	            } else if (exception === 'parsererror') {
	                $.jAlert('Requested JSON parse failed.');
	            } else if (exception === 'timeout') {
	                $.jAlert('Time out error.');
	            } else if (exception === 'abort') {
	                $.jAlert('Ajax request aborted.');
	            } else {
	                $.jAlert('Uncaught Error.n' + jqXHR.responseText);
	            }		            
	        }
	  	});
	}
	
  function funCheckStartDay()
	{
		var startDay='<%=session.getAttribute("PMSStartDay").toString()%>';
		if(startDay=='N')
		{
			alert('Please Start Day!!!');
			return false;
		}
		else
		{
			return true;
		}
	}

   function funHelp(transactionName)
	{
		fieldName=transactionName;
		window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
</script>

</head>
<body>
  <div class="container masterTable">
    <label  id="formHeading">DayEnd</label>
	  <s:form name="DayEnd" method="POST" action="dayEndProcess.html">
      <div class="row">
           <div class="col-md-3">
                  <label id="lblDate">PMS Date</label>
				   <s:input style="width: 40%;" id="txtPMSDate" path="dtePMSDate" readonly="true" value="${PMSDate}"/>
			</div>
				<!-- <td><s:input type="text" id="txtPMSDate" path="dtePMSDate" required="true" readonly="true" class="calenderTextBox" /></td> -->
		</div>
		<br>
       <p align="center" style="margin-right:61%">
			<input type="submit" value="Day End" id="btnDayEnd" tabindex="3" class="btn btn-primary center-block" class="form_button"/>&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>
	</s:form>
	</div>
</body>
</html>
