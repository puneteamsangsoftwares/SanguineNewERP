<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>

<script type="text/javascript" src="<spring:url value="/resources/js/pagination.js"/>"></script>
		
</head>
<script>

		$(document).ready(function(){
			var startDate="${startDate}";
			var arr = startDate.split("/");
			Dat=arr[2]+"-"+arr[1]+"-"+arr[0];
			$("#dtFromDate").datepicker({
				dateFormat : 'dd-mm-yy'
			});
			$("#dtFromDate").datepicker('setDate', Dat);	
			
			
			$("#dtToDate").datepicker({
				dateFormat : 'dd-mm-yy'
			});
			$("#dtToDate").datepicker('setDate', 'today');	
			
			
			var code='<%=session.getAttribute("locationCode").toString()%>';
			funSetLocation(code);
			
		});
		
		function funSetData(code)
		{
			switch (fieldName)
			{
			
			 case 'locationmaster':
			    	funSetLocation(code);
			        break;
			        
			    
			}
		}
		
		function funHelp(transactionName)
		{
			fieldName = transactionName;
			window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")			
	
		}
		
		
		function funSetLocation(code) {
			var searchUrl = "";
			searchUrl = getContextPath()
					+ "/loadLocationMasterData.html?locCode=" + code;

			$.ajax({
				type : "GET",
				url : searchUrl,
				dataType : "json",
				success : function(response) {
					if (response.strLocCode == 'Invalid Code') {
						alert("Invalid Location Code");
						$("#txtLocCode").val('');
						$("#lblLocName").text("");
						$("#txtLocCode").focus();
					} else {
						$("#txtLocCode").val(response.strLocCode);						
						$("#lblLocName").text(response.strLocName);
						$("#txtProdCode").focus();
					}
				},
				error : function(jqXHR, exception) {
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


</script>
<body>
    <div class="container transTable">
		<label  id="formHeading">Daily Production Item Wise Report</label>
	    <s:form name="DailyProductionReportItemWise" method="GET" action="rptDailyProductionReportItemWise.html" target="_blank" >
          <div class="row">
				<div class="col-md-3">
					<div class="row">
						<div class="col-md-6"><label>From Date</label>
							<s:input type="text" id="dtFromDate" path="dtFromDate" required="true" class="calenderTextBox" />
						</div>
						<div class="col-md-6"><label>To Date</label>
							<s:input type="text" id="dtToDate" path="dtToDate" required="true" class="calenderTextBox" />
						</div>					
					</div></div>
			     <div class="col-md-9"></div>
			<div class="col-md-5">
					<div class="row">		
						<div class="col-md-5"><label>Location Code</label>
							<s:input type="text" id="txtLocCode" path="strLocationCode" cssClass="searchTextBox" 
							name="locCode" ondblclick="funHelp('locationmaster');" /></div>
						<div class="col-md-7"><label id="lblLocName" style="background-color:#dcdada94; width: 100%; height: 37%; margin: 27px 0px;"></label></div>
					</div>
				</div>
			</div>
			
			<p align="center" style="margin-right: 31%;">
				<input type="submit" value="Export" class="btn btn-primary center-block" class="form_button" onclick="return funCallFormAction('submit',this)" />&nbsp
				 <input type="button" value="Reset" class="btn btn-primary center-block" class="form_button"  onclick="funResetFields()"/>
			</p>
		</s:form>
	</div>
</body>
</html>