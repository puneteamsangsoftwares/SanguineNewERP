<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Withholding Tax Report</title>
        
		<script type="text/javascript" src="<spring:url value="/resources/js/pagination.js"/>"></script>

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
		$("#txtFromDate" ).datepicker('setDate', 'today');
		*/
		var startDate="${startDate}";
		var arr = startDate.split("/");
		Dat=arr[0]+"-"+arr[1]+"-"+arr[2];
		$( "#txtFromDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtFromDate" ).datepicker('setDate', Dat);
		$( "#txtToDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtToDate" ).datepicker('setDate', 'today');
		
		

	});
	
	function funHelp(transactionName)
	{
		fieldName=transactionName;
        
      //  window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
      window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;top=500,left=500")
    }
	
	
	function funSetData(code)
	{
		switch (fieldName) 
		{		   
		   case 'custMaster':
			   funSetCustomer(code);
		        break;   
		}
	}
	
	$(function()
	 {
		$('#txtPartyCode').blur(function() {
			var code = $('#txtPartyCode').val();
			if(code.trim().length > 0 && code !="?" && code !="/")
			{
				funSetCustomer(code);
			}
		});
	});

	
	function funSetCustomer(code)
	{
		gurl=getContextPath()+"/loadPartyMasterData.html?partyCode=";
		$.ajax({
	        type: "GET",
	        url: gurl+code,
	        dataType: "json",
	        success: function(response)
	        {		        	
	        		if('Invalid Code' == response.strPCode){
	        			alert("Invalid Customer Code");
	        			$("#txtPartyCode").val('');
	        			$("#txtPartyCode").focus();
	        			$("#txtPartyName").val('');
	        			
	        		}else{
	        			$("#txtPartyCode").val(response.strPCode);
						$("#txtPartyName").val(response.strPName);
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
</script>
<body>
	<div class="container transTable">
		<label id="formHeading">Withholding Tax Report</label>
	   <s:form name="frmWithholdingTaxReport" method="GET" action="rptWithholdingTaxReport.html" target="_blank">
	   <br>
		 <div class="row">
	   		
			   <div class="col-md-2"><label>From Date </label>
					<s:input id="txtFromDate" path="dteFromDate" required="true" readonly="readonly" cssClass="calenderTextBox" style="width:70%"/>
			   </div>
			   
				<div class="col-md-2"><label>To Date </label>
					<s:input id="txtToDate" path="dteToDate" required="true" readonly="readonly" cssClass="calenderTextBox" style="width:70%"/>
				</div>	
				<div class="col-md-8"></div>
				
				<div class="col-md-2"><label>Customer Code </label>
				      <s:input id="txtPartyCode" name="txtPartyCode"  path="strCustCode" ondblclick="funHelp('custMaster')" cssClass="searchTextBox"/>
			     </div>
			     
				 <div class="col-md-2"><label>Customer Name</label>
				     <s:input size="80px" type="text" id="txtPartyName"  name="txtPartyName" path="strCustName" cssStyle="text-transform: uppercase;"/>
				 </div>
			
		</div>
		<br>
		<p align="center" style="margin-right: 48%;">
				<input type="submit" value="Submit"  class="btn btn-primary center-block" class="form_button" />
				&nbsp;
				<input type="button" value="Reset" class="btn btn-primary center-block" class="form_button"  onclick="funResetFields()"/>
			</p>
	</s:form>
    </div>
</body>
</html>