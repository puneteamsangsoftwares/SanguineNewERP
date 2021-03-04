<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>

<script type="text/javascript">
	var listRow = 0;
	var remainingQty=0;

	$(document).ready(function() {
		
		$(document).ajaxStart(function() {
			$("#wait").css("display", "block");
		});
		
		$(document).ajaxComplete(function() {
			$("#wait").css("display", "none");
		});
		
		var startDate="${startDate}";
		var arr = startDate.split("/");
		Dat=arr[0]+"-"+arr[1]+"-"+arr[2];
		$( "#txtFromDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
		$( "#txtFromDate" ).datepicker('setDate',Dat);
		
		$( "#txtToDate" ).datepicker({ dateFormat: 'dd-mm-yy' });		
		$( "#txtToDate" ).datepicker('setDate','today');

	});
	
	
	function funResetFields()
	{
		location.reload(true); 	
    }

	function funHelp(transactionName) 
	{
		fieldName = transactionName;
	//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;;dialogTop:400px;");
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;;dialogTop:400px;");
	}

function funHelpDN(transactionName)
	{
		fieldName=transactionName;
		if(transactionName === "SCDNCode"){
			var subconCode = $("#txtSCCode").val();
			if(subconCode.length>0)
				{
				 //	window.showModalDialog("searchform.html?formname="+transactionName+"&strSubConCode="+subconCode+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
				window.open("searchform.html?formname="+transactionName+"&strSubConCode="+subconCode+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
				
				}			
			else{
				transactionName='DNCode'
				//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
					window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
				
				}
		}
	}


	function funSetData(code) {

		switch (fieldName) {
		
		case 'AllJobOrder':
			funSetJOData(code);
			break;
		case 'JACode':
			funSetJAData(code);
			break;
		case 'subContractor':
			funSetSubContractorData(code);
			break;
		case 'SCDNCode' :
			funSetDNData(code)
			
			$('#txtDNCode').val(code);
			break;
			
		}
	}
	
	$(function()
			 {
				$('#txtSCCode').blur(function() {
					var code = $('#txtSCCode').val();
					if(code.trim().length > 0 && code !="?" && code !="/")
					{
						funSetSubContractorData(code);
					}
				});
				
				
				
			});

	
	function funSetDNData(code)
	{
		$('#txtDNCode').val(code);
		searchUrl = getContextPath() + "/loadDNData.html?DNCode=" +code;
		$.ajax({
			type : "GET",
			url : searchUrl,
			dataType : "json",
			success : function(response) {
				if (response.strDNCode == 'Invalid Code') {
						alert("Invalid Delivary Note Code");
						$("#txtDNCode").val("");
						$("#txtDNCode").focus(response.str);
					} else {
						
						$('#txtSCCode').val();
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
	
	
	function funSetSubContractorData(code)
	{
		
		gurl=getContextPath()+"/loadSubContractorMasterData.html?partyCode=";
		$.ajax({
	        type: "GET",
	        url: gurl+code,
	        dataType: "json",
	        success: function(response)
	        {
	        	
	        		if('Invalid Code' == response.strPCode){
	        			alert("Invalid Sub Contractor Code");
	        			$("#txtSCCode").val('');
	        			$("#txtSCCode").focus();
	        			$("#txtSCName").text("All Sub Contractors");
	        			
	        		}else{
	        			
	        			$("#txtSCCode").val(response.strPCode);
						$("#txtSCName").text(response.strPName);
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
	

	function funApplyNumberValidation() {
		$(".numeric").numeric();
		$(".integer").numeric(false, function() {
			alert("Integers only");
			this.value = "";
			this.focus();
		});
		$(".positive").numeric({
			negative : false
		}, function() {
			alert("No negative values");
			this.value = "";
			this.focus();
		});
		$(".positive-integer").numeric({
			decimal : false,
			negative : false
		}, function() {
			alert("Positive integers only");
			this.value = "";
			this.focus();
		});
		$(".decimal-places").numeric({
			decimalPlaces : maxQuantityDecimalPlaceLimit,
			negative : false
		});
	}
</script>

</head>
<body>
   <div class="container masterTable">
		<label id="formHeading"> Ageing Report </label>
	<s:form name="ageingReport" method="GET"
		action="rptAgeingReport.html?saddr=${urlHits}">
		<br>
		<div class="row">
		
				<div class="col-md-3">
				 <div class="row">
				 <div class="col-md-6"><label>From Date</label>
					<s:input type="text" id="txtFromDate"
						class="calenderTextBox" path="dteFromDate" required="required" />
				</div>
				<div class="col-md-6"><label>To Date</label>
				    <s:input type="text" id="txtToDate" class="calenderTextBox"
						path="dteToDate" required="required" />
				</div>
				</div></div>
				
				<div class="col-md-9"></div>
				
				<div class="col-md-5">
					<div class="row">
					    <div class="col-md-5"><label>SC Code</label><s:input type="text" id="txtSCCode" path="strSCCode" style="height:38%"
						cssClass="searchTextBox" ondblclick="funHelp('subContractor');" /></div>
						<div class="col-md-7"><label id="txtSCName" style="background-color:#dcdada94; width: 100%; height: 50%; margin-top: 11%;">All Sub
						Contractors </label></div>
				</div></div>
				
				<div class="col-md-3"><label>Sub Contractor Permission Type</label>
					<s:select id="txtPermissionType" path="strPermissionType"
						items="${permissionType}" style="width:40%"/>
				</div>
				
				<div class="col-md-4"></div>
				
				<div class="col-md-5">
				<div class="row">
					<div class="col-md-5"><label>DN Code</label><s:input type="text" id="txtDNCode" path="strDNCode" style="height: 43%"
						cssClass="searchTextBox" ondblclick="funHelpDN('SCDNCode');" /></div>
					<div class="col-md-7"><label id="txtDNName" style="background-color:#dcdada94; width: 100%; height: 50%; margin-top:11%;"> </label></div>
			    </div></div>
		
				<div class="col-md-2"><label> Delivery Note Type</label>
					<s:select id="txtDNType" path="strDNType" items="${dnType}" style="width:40%"/>
				</div>
				<div class="col-md-5"></div>
				
				<div class="col-md-3">
				 <div class="row">
			              <div class="col-md-6"><label>Order By</label>
						          <s:select id="txtOrderBy" path="strOrderBy"
						         items="${orderBy}"/>
			                </div>

				            <div class="col-md-6"><label>Export Type</label>
					            <s:select id="txtExportType" path="strExportType">
						             <s:option value="PDF" />
						              <s:option value="EXCEL" />
					            </s:select></div>
              </div></div>
		</div>
		
		<p align="right" style="margin-right: 39%">
			<input type="submit" value="Display" class="btn btn-primary center-block" class="form_button" />&nbsp;
			 <input
				type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()" />
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
		funApplyNumberValidation();
	</script>
</body>
</html>