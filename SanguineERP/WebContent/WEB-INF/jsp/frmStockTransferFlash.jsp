<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
	
	<script type="text/javascript" src="<spring:url value="/resources/js/jQuery.js"/>"></script>
	<script type="text/javascript" src="<spring:url value="/resources/js/jquery-ui.min.js"/>"></script>	
	<script type="text/javascript" src="<spring:url value="/resources/js/validations.js"/>"></script>
	<script type="text/javascript" src="<spring:url value="/resources/js/pagination.js"/>"></script>
        <!-- Load data to paginate -->
	<link rel="stylesheet" href="<spring:url value="/resources/css/pagination.css"/>" />

	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<script type="text/javascript">

 		var StkFlashData;
 		var loggedInProperty="";
 		var loggedInLocation="";
 		$(document).ready(function() 
 				{
		  	loggedInProperty="${LoggedInProp}";
			loggedInLocation="${LoggedInLoc}";
			$("#cmbProperty").val(loggedInProperty);
			//alert(loggedInProperty);
			var propCode=$("#cmbProperty").val();
			//funFillLocationCombo(propCode);
			$("#divValueTotal").hide();
		});	
 	
	
 		

 		function funFillFromLocationCombo(loggedInProperty) 
		{
			var searchUrl = getContextPath() + "/loadLocationForProperty.html?propCode="+ propCode;
			$.ajax({
				type : "GET",
				url : searchUrl,
				dataType : "json",
				success : function(response) {
					var html = '';
					$.each(response, function(key, value) {
						html += '<option value="' + value[1] + '">'+value[0]
								+ '</option>';
					});
					html += '</option>';
					$('#cmbFromLocation').html(html);
					$("#cmbFromLocation").val(loggedInLocation);
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
 
		
		function funFillToLocationCombo(loggedInProperty) 
		{
			var searchUrl = getContextPath() + "/loadLocationForProperty.html?propCode="+ propCode;
			$.ajax({
				type : "GET",
				url : searchUrl,
				dataType : "json",
				success : function(response) {
					var html = '';
					$.each(response, function(key, value) {
						html += '<option value="' + value[1] + '">'+value[0]
								+ '</option>';
					});
					html += '</option>';
					$('#cmbToLocation').html(html);
					$("#cmbToLocation").val(loggedInLocation);
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
// 		function funGetTotalValue(dblTotalValue)
// 		{
// 			$("#txtTotValue").val(parseFloat(dblTotalValue).toFixed(maxAmountDecimalPlaceLimit));
// 		}
	 	function showTable()
		{
			var optInit = getOptionsFromForm();
		    $("#Pagination").pagination(StkFlashData.length, optInit);	
		   // $("#divValueTotal").show();
		    
		}
	
		var items_per_page = 10;
		function getOptionsFromForm()
		{
		    var opt = {callback: pageselectCallback};
			opt['items_per_page'] = items_per_page;
			opt['num_display_entries'] = 10;
			opt['num_edge_entries'] = 3;
			opt['prev_text'] = "Prev";
			opt['next_text'] = "Next";
		    return opt;
		}
		
		$(document).ready(function() 
		{
			var startDateOfMonth="${startDateOfMonth}";

			$("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtFromDate").datepicker('setDate','startDateOfMonth');
			$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtToDate").datepicker('setDate', 'today');
			
			$("#cmbLocation").val("${locationCode}");
			
				
			$(document).ajaxStart(function()
			{
			    $("#wait").css("display","block");
			});
			$(document).ajaxComplete(function()
			{
				$("#wait").css("display","none");
			});
		});
		
		
		
		function funClick(obj)
		{
			var prodCode=document.getElementById(""+obj.id+"").innerHTML;
			var locCode=$("#cmbLocation").val();
			var propCode=$("#cmbProperty").val();
			var fromDate=$("#txtFromDate").val();
			var toDate=$("#txtToDate").val();
			var param1=prodCode+","+locCode+","+propCode;
			window.open(getContextPath()+"/frmStockLedgerFromStockFlash.html?param1="+param1+"&fDate="+fromDate+"&tDate="+toDate);
		}
		
		function pageselectCallback(page_index, jq)
		{
		    // Get number of elements per pagionation page from form
		    var max_elem = Math.min((page_index+1) * items_per_page, StkFlashData.length);
		    var newcontent="";
			    	
			   	newcontent = '<table id="tblStockFlash" class="transTablex" style="width: 100%;font-size:11px;font-weight: bold;"><tr style="background:#c0c0c0;"><td id="labld2"> Product Code</td><td id="labld3"> Product Name</td>	<td id="labld4"> Transfer Qty </td>	</tr>';
			   	// Iterate through a selection of the content and build an HTML string
			    for(var i=page_index*items_per_page;i<max_elem;i++)
			    {
			        
// 			        newcontent += '<td><a id="stkLedgerUrl.'+i+'" href="#" onclick="funClick(this);">'+StkFlashData[i].strProdCode+'</a></td>';
			        
			        newcontent += '<td>'+StkFlashData[i].strProdCode+'</a></td>';
			        newcontent += '<td>'+StkFlashData[i].strProdName+'</td>';
			        newcontent += '<td align="right">'+StkFlashData[i].dblIssue+'</td>';
			        newcontent += '<td></td><tr>';
			    } 			        
			       
		  
		    newcontent += '</table>';
		    // Replace old content with new content
		   
		    $('#Searchresult').html(newcontent);
		   
		    // Prevent click eventpropagation
		    return false;
		}
				
		
	
		
		
		function funCalculateStockTransferFlash()
		{			
			var reportType=$("#cmbExportType").val();
			var fromDate=$("#txtFromDate").val();
			var toDate=$("#txtToDate").val();
			var fromLocCode=$("#cmbFromLocation").val();
			var toLocCode=$("#cmbToLocation").val();
			
			
			var param1=reportType+","+fromLocCode+","+toLocCode;
				
			var searchUrl=getContextPath()+"/frmStockTransferFlashDetailReport.html?param1="+param1+"&fDate="+fromDate+"&tDate="+toDate;
			//alert(searchUrl);
			
			$.ajax({
			        type: "GET",
			        url: searchUrl,
				    dataType: "json",
				    success: function(response)
				    {
				    	StkFlashData=response[0];
				    	showTable();
// 				    	funGetTotalValue(response[1]);
				    	
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

		
		
		$(document).ready(function () 
		{			 

		});
		  
		
		function funOnExecute()
		{
			{
				var fromDate=$("#txtFromDate").val();
				var toDate=$("#txtToDate").val();
				
					funCalculateStockTransferFlash();
			}
			return false;
		}
		
		function funOnExport()
		{
			var reportType=$("#cmbExportType").val();
			var fromDate=$("#txtFromDate").val();
			var toDate=$("#txtToDate").val();
			var fromLocCode=$("#cmbFromLocation").val();
			var toLocCode=$("#cmbToLocation").val();
			var param1=reportType+","+fromLocCode+","+toLocCode;
			if(reportType=='Excel')
				{
						window.location.href=getContextPath()+"/downloadStockTransferExcel.html?param1="+param1+"&fDate="+fromDate+"&tDate="+toDate;
				}else
					{
						window.location.href=getContextPath()+"/rptStkTransferFlashReport.html?param1="+param1+"&fDate="+fromDate+"&tDate="+toDate;
					}
			
			return false
		}
		 
		 
	</script>
</head>
<body onload="funOnLoad();">
	<div class="container">
		<label id="formHeading">Stock Transfer Flash</label>
		<s:form action="frmStockTransferFlashReport.html" method="GET" name="frmStockTransferFlash" target="_blank">
			<div class="row transTable">
				<div class="col-md-2">
					<label>From Location</label>
					<s:select id="cmbFromLocation" name="fromLocCode" path="strFromLocCode"  >
			    		<s:options items="${listFromLocation}"/>
			    	</s:select>
				</div>
				<div class="col-md-2">		
					<label>To Location</label>
					<s:select id="cmbToLocation" name="toLocCode" path="strToLocCode" style="width:auto;">
			    		<s:options items="${listToLocation}"/>
			    	</s:select>
				</div>	
				<div class="col-md-8"></div>
				<div class="col-md-2">	
					<label id="lblFromDate">From Date</label>
			     	<s:input id="txtFromDate" name="fromDate" path="dteFromDate" cssClass="calenderTextBox" style="width:80%;"/>
			        	<s:errors path="dteFromDate"></s:errors>
			     </div>
				 <div class="col-md-2">     
			        <label id="lblToDate">To Date</label>
			      	<s:input id="txtToDate" name="toDate" path="dteToDate" cssClass="calenderTextBox" style="width:80%;"/>
			        	<s:errors path="dteToDate"></s:errors>
			     </div> 
 				 <div class="col-md-2">    
					<s:select path="strExportType" id="cmbExportType" style="margin-top: 26px;">
						<option value="Excel">Excel</option>
						<option value="PDF">PDF</option>
					</s:select>
				 </div>
			</div>
			
			<div class="center" style="margin-right: 55%;">
				<a href="#"><button class="btn btn-primary center-block" id="btnExecute" onclick="return funOnExecute()" value="Execute" 
					>Execute</button></a>
				<a href="#"><button class="btn btn-primary center-block" id="btnExport" onclick="return funOnExport()" value="Export" 
					>Export</button></a>
			</div>
		
			<dl id="Searchresult" style="width: 95%; margin-left: 26px; overflow:auto;"></dl>
			<div id="Pagination" class="pagination" style="width: 80%;margin-left: 26px;">
		
			</div>
			<br>
			<br>
			<div id="divValueTotal">
				<table id="tblTotalFlash" class="transTablex" style="width: 95%;font-size:11px;font-weight: bold;">
					<tr style="margin-left: 28px">
						<td id="labld26" width="80%" align="right">Total Value</td>
						<td id="tdTotValue" width="10%" align="right">
					<input id="txtTotValue" style="width: 100%;text-align: right;" class="Box"></input></td>
				<td width="10%" align="right"></td>
			</tr>
		</table>
		</div>
		<div id="wait" style="display:none;width:60px;height:60px;border:0px solid black;position:absolute;top:60%;left:55%;padding:2px;">
				<img src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif" width="60px" height="60px" />
			</div>
	</s:form>
</div>	
</body>
</html>