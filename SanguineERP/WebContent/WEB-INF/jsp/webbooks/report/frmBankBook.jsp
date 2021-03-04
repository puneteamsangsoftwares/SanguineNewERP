<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>

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
		$("#txtFromDate" ).datepicker('setDate', 'today');*/
		var startDate="${startDate}";
		var arr = startDate.split("/");
		Dat=arr[0]+"-"+arr[1]+"-"+arr[2];
		$( "#txtFromDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtFromDate" ).datepicker('setDate', Dat);
		$( "#txtToDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtToDate" ).datepicker('setDate', 'today');
		
		$("#txtAccountCode").blur(function() 
				{
					var code=$('#txtAccountCode').val();
					if(code.trim().length > 0 && code !="?" && code !="/")
					{
						funSetAccountDetails(code);
					}
				});

	});
	
	function funSetData(code){

		switch(fieldName)
		{		
			case "accountCodeBank": 
			     funSetAccountDetails(code);
				 break;
			
		}
	}
	
	function funSetAccountDetails(accountCode)
	{
	    $("#txtAccountCode").val(accountCode);
		var searchurl=getContextPath()+"/loadAccountMasterData.html?accountCode="+accountCode;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strAccountCode=='Invalid Code')
			        	{
			        		alert("Invalid Account Code");
			        		$("#txtAccountCode").val('');
			        		$("#txtAccountName").val('');
			        	}
			        	else
			        	{
				        	$("#txtAccountName").val(response.strAccountName);
				        			        	
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
	
	
	
	function funHelp(transactionName)
	{
		fieldName=transactionName;
	//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
	
	function funGetVaildation() 
	 {
			if($("#txtAccountCode").val()=="")
	 		{
	 			alert('Please Select Bank Name!! ');
	 			return false;
	 		}
			
			if($("#txtAccountName").val()=="")
	 		{
	 			alert('Bank Name should not be empty!! ');
	 			return false;
	 		}
	  }
</script>
<body>
      <div class="container transTable">
		<label id="formHeading">Bank Book</label>
	   <s:form name="Bank Book Report" method="GET" action="rptBankBook.html" target="_blank">
		<div class="row">
			<div class="col-md-5"><label>Bank Account </label>
					 <div class="row">
						<div class="col-md-5"><s:input id="txtAccountCode" path="strAccountCode" placeholder="Account Code" ondblclick="funHelp('accountCodeBank')" cssClass="searchTextBox"/></div>			        			        
			    		<div class="col-md-7"><s:input id="txtAccountName" path="strAccountName" placeholder="Account Name" readonly="true" cssClass="longTextBox"/></div>
					 </div>
			    </div>		
			   
			   <div class="col-md-7"></div>
			    
			 <div class="col-md-3">
					   <div class="row">
			              <div class="col-md-6"><label>From Date </label>
					                 <s:input id="txtFromDate" path="dteFromDate" required="true" readonly="readonly" style="height:50%" cssClass="calenderTextBox"/>
				           </div>
				        <div class="col-md-6"><label>To Date </label>
					                <s:input id="txtToDate" path="dteToDate" required="true" readonly="readonly" style="height:50%" cssClass="calenderTextBox"/>
				        </div>	
			     </div></div>
			     
				<div class="col-md-2"><label>Currency </label>
					<s:select id="cmbCurrency" items="${currencyList}" path="strCurrency" cssClass="BoxW124px">
						</s:select>
				</div>	
		</div>
		<br>
		<p align="center" style="margin-right:31%;">
				<input type="submit" value="Submit"  class="btn btn-primary center-block" class="form_button" onclick="return funGetVaildation()" />&nbsp
				 <input type="button" value="Reset"   class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
			</p>
	</s:form>
   </div>
</body>
</html>