<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html.dtd">
<html>
<head>
     <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

<script>

		$(document).ready(function(){
			var startDateOfMonth="${startDateOfMonth}";
			var arr1 = startDateOfMonth.split("-");
			Dat1=arr1[2]+"-"+arr1[1]+"-"+arr1[0];
			var startDate="${startDate}";
			var arr = startDate.split("/");
			Dat=arr[2]+"-"+arr[1]+"-"+arr[0];
			$("#dtFromDate").datepicker({
				dateFormat : 'dd-mm-yy'
			});
			$("#dtFromDate").datepicker('setDate', startDateOfMonth);	
			
			
			$("#dtToDate").datepicker({
				dateFormat : 'dd-mm-yy'
			});
			$("#dtToDate").datepicker('setDate', 'today');	
			
			var code='<%=session.getAttribute("locationCode").toString()%>';
			funSetLocation(code);			
			
		});
		
		function funSetLocation(code)
		{
			$.ajax({
			        type: "GET",
			        url: getContextPath()+"/loadLocationMasterData.html?locCode="+code,
			        dataType: "json",
			        success: function(response)
			        {
				       	if(response.strLocCode=='Invalid Code')
				       	{
				       		alert("Invalid Location Code");
				       		$("#txtLocCode").val('');
				       	}
				       	else
				       	{
				       		$("#txtLocCode").val(response.strLocCode);
					       	$("#lblLocName").text(response.strLocName);
					       
				       	}
				    },
				    error: function(jqXHR, exception) {
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
			fieldName=transactionName;
			
			//window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
			window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
		}
		
		


</script>
<body>
<div class="container transTable">
	<label id="formHeading">FORM R.G.-23-A-Part I</label>
	   <s:form name="frmRG-23A-Part-I" method="GET" action="rptRG-23A-Part-I.html" target="_blank" >
            <div class="row">	
		         <div class="col-md-2"><label>From Date</label>
				     <input type="text" id="dtFromDate" name="dtFromDate" required="true" class="calenderTextBox" style="width:70%" />
				 </div>
				 
				<div class="col-md-2"><label>To Date</label>
				     <input type="text" id="dtToDate" name="dtToDate" required="true" class="calenderTextBox" style="width:70%"/>
				</div>				
			    <div class="col-md-8"></div>
			    
			    <div class="col-md-2"><label>Location Code</label>
				  <s:input id="txtLocCode" name="txtLocCode" readonly="true" path="strLocationCode" ondblclick="funHelp('locationmaster')"  cssClass="searchTextBox"/>
			    </div>
			
			    <div class="col-md-2"><label id="lblLocName" style="background-color:#dcdada94; width: 100%; height: 42%; margin: 27px 0px;"></label>
			     </div>
		     </div>
		    <br>
			<p align="center" style="margin-right:48%">
				<input type="submit" value="Export" class="btn btn-primary center-block" class="form_button" onclick="return funCallFormAction('submit',this)" />
				 &nbsp;
				 <input type="button" value="Reset" class="btn btn-primary center-block" class="form_button"  onclick="funResetFields()"/>
			</p>
		</s:form>
		</div>
</body>
</html>