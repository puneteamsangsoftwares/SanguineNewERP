<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Sales Order</title>
 
<script type="text/javascript" src="<spring:url value="/resources/js/pagination.js"/>"></script>

<script type="text/javascript">
		
$(document).ready(function() 
	{		
		$(".tab_content").hide();
		$(".tab_content:first").show();

		$("ul.tabs li").click(function() {
			$("ul.tabs li").removeClass("active");
			$(this).addClass("active");
			$(".tab_content").hide();
			var activeTab = $(this).attr("data-state");
			$("#" + activeTab).fadeIn();
		});
		
			var startDate="${startDate}";
			var arr = startDate.split("/");
			Dat=arr[2]+"-"+arr[1]+"-"+arr[0];
		    $("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtFromDate" ).datepicker('setDate', Dat);
			$("#txtFromDate").datepicker();	
			
			$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtToDate" ).datepicker('setDate', 'today');
			$("#txtToDate").datepicker();	
				
			$("#txtFromFulfillment").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtFromFulfillment" ).datepicker('setDate', Dat);
			$("#txtFromFulfillment").datepicker();	
					
					
			$("#txtToFulfillment").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtToFulfillment" ).datepicker('setDate', 'today');
			$("#txtToFulfillment").datepicker();	
						
	});
		

		
		
	function funHelp(transactionName)
	{
		fieldName = transactionName;
	//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;top=500,left=500")
		
	}

 	function funSetData(code)
	{
		switch (fieldName)
		{
			    	
		    case 'custMaster' :
		    	funSetCuster(code);
		    	break;
		        
		}
	}
 	
 	$(function()
	 {
		$('#txtPartyCode').blur(function() {
			var code = $('#txtPartyCode').val();
			if(code.trim().length > 0 && code !="?" && code !="/")
			{
				funSetCuster(code);
			}
		});
    });
	
		 	
 	function funSetCuster(code)
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
        			$("#lblPartyName").text('');
        			
        		}else{			   
        			$("#txtPartyCode").val(response.strPCode);
					$("#lblPartyName").text(response.strPName);
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

	
	
	
	function funCallFormAction(actionName,object) 
	{
			
		if ($("#txtPartyCode").val()=="") 
		    {
			 alert('Invalid Date');
			 $("#txtPartyCode").focus();
			 return false;  
		   }
		
		if ($("#txtFromDate").val()=="") 
	    {
		 alert('Invalid Date');
		 $("#txtFromDate").focus();
		 return false;  
	   }
		
		if ($("#txtToDate").val()=="") 
	    {
		 alert('Invalid Date');
		 $("#txtToDate").focus();
		 return false;  
	   }	
		
		if ($("#txtFromFulfillment").val()=="") 
	    {
		 alert('Invalid Date');
		 $("#txtFromFulfillment").focus();
		 return false;  
	   }	
		
		if ($("#txtToFulfillment").val()=="") 
	    {
		 alert('Invalid Date');
		 $("#txtToFulfillment").focus();
		 return false;  
	   }	
		
		
		
	  else
		{
			return true;
			
		}
	}
	
	
		
</script>

</head>
<body onload="funOnLoad();">
	<div class="container transTable">
		<label id="formHeading">Sales Order List</label>
	<s:form name="SalesOrderList" method="GET"
		action="rptSalesOrderList.html" >
		<input type="hidden" value="${urlHits}" name="saddr">
		<br>
		<div class="row">
					<div class="col-md-3">
						<div class="row">
							<div class="col-md-6"><label>From Date</label>
									<s:input path="dtFromDate" id="txtFromDate"
											 required="required"
											cssClass="calenderTextBox" /></div>
							<div class="col-md-6"><label>To Date</label>
									<s:input path="dtToDate" id="txtToDate"
											 required="required"
											cssClass="calenderTextBox" /></div>
						</div></div>
						
						<div class="col-md-4">
							<div class="row">
								<div class="col-md-5"><label>Customer Code</label>
									<s:input path="strDocCode" id="txtPartyCode"
										ondblclick="funHelp('custMaster')" cssClass="searchTextBox" /></div>
									<div class="col-md-7"><label id="lblPartyName" style="background-color:#dcdada94; width: 100%; height: 42%; margin: 27px 0px;"></label></div>
						</div></div>				
						<div class="col-md-5"></div>			
					<div class="col-md-3">
							<div class="row">
								<div class="col-md-6"><label>Fulfillment Date From</label>
									  <s:input path="dteFromFulfillment" id="txtFromFulfillment"
										required="required" cssClass="calenderTextBox"/>
								</div>
								<div class="col-md-6"><label>Fulfillment Date To</label>
									   <s:input path="dteToFulfillment" id="txtToFulfillment"
										required="required" cssClass="calenderTextBox" />
								</div>
					</div></div>
					
					<div class="col-md-3">
						<div class="row">
							<div class="col-md-6"><br><label>Report Format</label>
								<s:select id="cmbDocType" path="strDocType" style="width:auto;">
										<s:option value="PDF">PDF</s:option>
										<s:option value="XLS">EXCEL</s:option>
										<s:option value="HTML">HTML</s:option>
										<s:option value="CSV">CSV</s:option>
									</s:select></div>
						    <div class="col-md-6"><br><label>Type</label>
								    <s:select id="cmbType" path="strReportType" style="width:auto;">
										<s:option value="Summary">Summary</s:option>
										<s:option value="Detail">Detail</s:option>
									</s:select></div>	
						   </div></div>
		</div>
		<br>
		<p align="center">
			<input type="submit" value="Submit" onclick="return funCallFormAction('submit',this)" class="btn btn-primary center-block"
				class="form_button" /> &nbsp
			<a STYLE="text-decoration: none" href="frmSalesOrderList.html?saddr=${urlHits}">
			<input type="button" id="reset" name="reset" value="Reset" class="btn btn-primary center-block" class="form_button" /></a>
		</p>
		<br>
		<div id="wait"
			style="display: none; width: 60px; height: 60px; border: 0px solid black; position: absolute; top: 60%; left: 55%; padding: 2px;">
			<img
				src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif"
				width="60px" height="60px" />
		</div>
	</s:form>
	</div>
	<script type="text/javascript">
		
	</script>
</body>
</html>