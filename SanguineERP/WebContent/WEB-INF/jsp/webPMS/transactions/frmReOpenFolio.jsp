<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>
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
		var flag=false;
		if($("#strFolioNo").val().trim().length==0)
		{
			alert("Please Select Folio No.");
		}
		else
		{
			flag=true;
			
			var folioNo=$("#strFolioNo").val();
			
			//window.open(getContextPath()+"/rptFolioPrinting.html?fromDate="+fy+"-"+fm+"-"+fd+"&toDate="+ty+"-"+tm+"-"+td+"&folioNo="+folioNo+"");
		}
		
		
		return flag;
	}
	
	function funSetFolioNo(folioNo)
	{
		
		$("#strFolioNo").val(folioNo);
		var searchurl=getContextPath()+ "/loadReopenData.html?folioNo=" + folioNo;
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",
			success : function(response)
			{ 
				$.each(response, function(i,item)
	            {
					
					$("#strGuestName").val(item[2]);
					$("#dteCheckinDate").val(item[0]);
					$("#dteCheckoutDate").val(item[1]);
			    });
	        	
			},
			error : function(jqXHR, exception){
				if (jqXHR.status === 0) {
	                alert('Not connect.n Verify Network.');
	            } else if (jqXHR.status == 404) {
	                alert('Requested page not found. [404]');
	            } else if (jqXHR.status == 500) {
	                alert('Internal Server Error [500].');
	            } else if (exception === 'parsererror') {
	                alert('Requested JSON parse failed.');
	            } else if (exception === 'timeout') {
	                alert('Time out error.');
	            } else if (exception === 'abort') {
	                alert('Ajax request aborted.');
	            } else {
	                alert('Uncaught Error.n' + jqXHR.responseText);
	            }			

			}
		});
	}	
	
	/**
	* Success Message After Saving Record
	**/
	$(document).ready(function()
	{
		var message='';
		<%if (session.getAttribute("success") != null) 
		{
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
			}
		}%>
		
		
		 var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
		  var dte=pmsDate.split("-");
		  $("#txtPMSDate").val(dte[2]+"-"+dte[1]+"-"+dte[0]);
	});
	/**
		* Success Message After Saving Record
	**/
	
	/* set date values */
	function funSetDate(id,responseValue)
	{
		var id=id;
		var value=responseValue;
		var date=responseValue.split(" ")[0];
		
		var y=date.split("-")[0];
		var m=date.split("-")[1];
		var d=date.split("-")[2];
		
		$(id).val(d+"-"+m+"-"+y);
		
	}	
	
	//set date
	$(document).ready(function()
	{
		var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
	});
	
	function funSetData(code)
	{
		switch(fieldName)
		{
		case "folioNoForReOpen":
			funSetFolioNo(code);
			break;
		}
	}

	function funHelp(transactionName)
	{
		fieldName=transactionName;
		window.open("searchform.html?formname="+transactionName+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
		//window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
</script>

</head>
<body>
 <div class="container masterTable">
	<label id="formHeading">ReOpen Folio</label>
	<s:form name="ReOpeningFolio" method="POST" action="saveFolio.html">
       <div class="row">
				<div class="col-md-2"><label>Folio No.</label>
				      <s:input id="strFolioNo" path="strFolioNo" readonly="true" cssClass="searchTextBox" ondblclick="funHelp('folioNoForReOpen')" style="height: 45%"/>													
	            </div>
	            <div class="col-md-2"><label>Guest Name</label>
				      <s:input id="strGuestName" path="" readonly="true" cssClass="longTextBox"  style="height: 45%"/>													
	            </div>
	            <div class="col-md-2"><label>Check-in Date</label>
				      <s:input id="dteCheckinDate" path="" readonly="true" cssClass="longTextBox"  style="height: 45%"/>													
	            </div>
	            <div class="col-md-2"><label>Check-out Date</label>
				      <s:input id="dteCheckoutDate" path="" readonly="true" cssClass="longTextBox"  style="height: 45%"/>													
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
