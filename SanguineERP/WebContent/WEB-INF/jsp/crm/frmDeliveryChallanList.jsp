<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Sales Order</title>

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
					
					 			
		});
		

		
		
		function funHelp(transactionName)
		{
			fieldName = transactionName;
		//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
			 window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
			
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
		
		
		
	  else
		{
			return true;
			
		}
	}
	
	$(function()
			{
				$("#txtPartyCode").blur(function() 
						{
							var code=$('#txtPartyCode').val();
							if(code.trim().length > 0 && code !="?" && code !="/")
							{
								funSetCuster(code);
							}
						});
				
			});
		
</script>

</head>
<body onload="funOnLoad();">
	<div class="container transTable">
		<label id="formHeading">Delivery Challan List</label>
	  <s:form name="DeliveryChallan" method="GET"
		action="rptDeliveryChallanList.html" >
		<input type="hidden" value="${urlHits}" name="saddr">
		<br>
		    <div class="row">
		        <div class="col-md-3">
		           <div class="row">
					<div class="col-md-6"><label>From Date</label>
						<s:input path="dtFromDate" id="txtFromDate" required="required" cssClass="calenderTextBox" />
					</div>
					<div class="col-md-6"><label>To Date</label>
						<s:input path="dtToDate" id="txtToDate" required="required" cssClass="calenderTextBox" /> 
			    	</div>								
				</div></div>
				<div class="col-md-9"></div>
				
			<div class="col-md-2"><label>Customer Code</label>
					<s:input path="strDocCode" id="txtPartyCode" ondblclick="funHelp('custMaster')"	cssClass="searchTextBox" />&nbsp;&nbsp;&nbsp;&nbsp;
					<label id="lblPartyName"></label>	
			</div>
			
			<div class="col-md-1"><label>Type</label>
					<s:select id="cmbType" path="strAgainst" style="width:140%">
						<s:option value="Summary">Summary</s:option>
						<s:option value="Detail">Detail</s:option>
					</s:select>	
			</div>&nbsp; &nbsp;
			
			<div class="col-md-2"><label>Report Format</label>
					<s:select id="cmbDocType" path="strDocType" style="width:53%">
						<s:option value="PDF">PDF</s:option>
						<s:option value="XLS">EXCEL</s:option>
						<s:option value="HTML">HTML</s:option>
						<s:option value="CSV">CSV</s:option>
					</s:select>
			</div>
								
         </div>
		
		<p align="right" style="margin-right: 66%">
			<input type="submit" value="Submit"
				onclick="return funCallFormAction('submit',this)" class="btn btn-primary center-block" 
				class="form_button" /> &nbsp;
				<a STYLE="text-decoration: none"
				href="frmDeliveryChallanList.html?saddr=${urlHits}"><input
				type="button" id="reset" name="reset" value="Reset" class="btn btn-primary center-block" 
				class="form_button" /></a>
		</p>

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