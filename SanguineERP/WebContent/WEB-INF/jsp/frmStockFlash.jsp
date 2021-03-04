<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
	
	   
	<script type="text/javascript" src="<spring:url value="/resources/js/jQuery.js"/>"></script>
	<script type="text/javascript" src="<spring:url value="/resources/js/jquery-ui.min.js"/>"></script>	
	<script type="text/javascript" src="<spring:url value="/resources/js/validations.js"/>"></script>
	<script type="text/javascript" src="<spring:url value="/resources/js/pagination.js"/>"></script>
        <!-- Load data to paginate -->
	<link rel="stylesheet" href="<spring:url value="/resources/css/pagination.css"/>" />

<style type="text/css">
.transTablex td{
border:1px solid #fff;
}


</style>
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
			 funAddReprtType();
			funAddExportType();
		});	
 		function funChangeLocationCombo()
		{
			var propCode=$("#cmbProperty").val();
			funFillLocationCombo(propCode);
		}
	
 		function funFillCombo(code) {
 			var searchUrl = getContextPath() + "/loadSubGroupCombo.html?code="+ code;
 			$.ajax({
 				type : "GET",
 				url : searchUrl,
 				dataType : "json",
 				success : function(response) {
 					var html = '<option value="ALL">ALL</option>';
 					$.each(response, function(key, value) {
 						html += '<option value="' + key + '">' + value
 								+ '</option>';
 					});
 					html += '</option>';
 					$('#strSGCode').html(html);
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

		function funFillLocationCombo(propCode) 
		{
			var usercode='<%=session.getAttribute("usercode").toString()%>';
			var searchUrl = getContextPath() + "/loadForInventryLocationForProperty.html?propCode="+ propCode;
						
			
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
					$('#cmbLocation').html(html);
				//	$("#cmbLocation").val(loggedInLocation);
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
 
		function funGetTotalValue(dblTotalValue)
		{
			$("#txtTotValue").val(parseFloat(dblTotalValue).toFixed(maxAmountDecimalPlaceLimit));
		}
	 	function showTable()
		{
			var optInit = getOptionsFromForm();
		    $("#Pagination").pagination(StkFlashData.length, optInit);	
		    $("#divValueTotal").show();
		    
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
			var startDate="${startDate}";
			var arr = startDate.split("/");
			 
			var date = new Date(); 
			var month=date.getMonth()+1;
            Dat= 1 +"-"+month+"-"+date.getFullYear();
			
			$("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtFromDate").datepicker('setDate',Dat);
			$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtToDate").datepicker('setDate', 'today');
			$("#cmbLocation").val("${locationCode}");
			
			$("#btnExecute").click(function( event )
			{
				var fromDate=$("#txtFromDate").val();
				var toDate=$("#txtToDate").val();
				if($("#cmbReportType").val()=='Detail')
				{
					document.getElementById("divValueTotal").style.visibility = "visible";
					funCalculateStockFlashForDetail();
				}
				if($("#cmbReportType").val()=='Summary')
				{
					document.getElementById("divValueTotal").style.visibility = "visible";
					funCalculateStockFlashForSummary();
				}
				if($("#cmbReportType").val()=='Mini')
				{
					document.getElementById("divValueTotal").style.visibility = "visible";
					funCalculateMiniStockFlash();
				}
				if($("#cmbReportType").val()=='Total')
				{
					document.getElementById("divValueTotal").style.visibility = "hidden"; 
					funCalculateStockFlashForTotal();
				}
				
				
			});
				
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
			var currValue='<%=session.getAttribute("currValue").toString()%>';
    		if(currValue==null)
    			{
    				currValue=1;
    			}	
		    if($("#cmbReportType").val()=='Detail')
		   	{		    	
			   	newcontent = '<table id="tblStockFlash" class="transTablex" style="width: 100%;font-size:11px;font-weight: bold;"><tr bgcolor="#c0c0c0"><td id="labld1" size="10%">Property Name</td><td id="labld2"> Product Code</td><td id="labld3"> Product Name</td>	<td id="labld4"> Location </td>	<td id="labld5"> Group</td><td id="labld6"> Sub Group</td><td id="labld7"> UOM</td><td id="labld8"> Bin No</td><td id="labld9"> Weighted Avg Price</td><td id="labld10"> Opening Stock</td><td id="labld11"> GRN</td><td id="labld12"> Free Qty</td><td id="labld13"> SCGRN</td><td id="labld14"> Stock Transfer In</td><td id="labld15"> Stock Adj In</td><td id="labld16"> MIS In</td><td id="labld17"> Qty Produced</td><td id="labld18"> Sales Return</td><td id="labld19"> Material Return</td><td id="labld20"> Purchase Return</td><td id="labld21"> Delivery Note</td><td id="labld22"> Stock Trans Out</td><td id="labld23"> Stock Adj Out</td><td id="labld24"> MIS Out</td><td id="labld25"> Qty Consumed</td><td id="labld26"> Sales</td><td id="labld27">Closing Stock</td><td id="labld28">Value</td><td id="labld29">Issue UOM Stock</td><td id="labld30">Issue Conversion</td><td id="labld31">Issue UOM </td><td id="labld32">Part No</td></tr>';
			   	// Iterate through a selection of the content and build an HTML string
			    for(var i=page_index*items_per_page;i<max_elem;i++)
			    {
			        newcontent += '<tr><td>'+StkFlashData[i].strPropertyName+'</td>';
			        //newcontent += '<td>'+StkFlashData[i].strProdCode+'</td>';
			        newcontent += '<td><a id="stkLedgerUrl.'+i+'" href="#" onclick="funClick(this);">'+StkFlashData[i].strProdCode+'</a></td>';
			        newcontent += '<td>'+StkFlashData[i].strProdName+'</td>';
			        newcontent += '<td>'+StkFlashData[i].strLocName+'</td>';
			        newcontent += '<td>'+StkFlashData[i].strGroupName+'</td>';
			        newcontent += '<td>'+StkFlashData[i].strSubGroupName+'</td>';
			        newcontent += '<td>'+StkFlashData[i].strUOM+'</td>';
			        newcontent += '<td>'+StkFlashData[i].strBinNo+'</td>';
			    	        
			        var qtyWithUOM=$("#cmbQtyWithUOM").val();
			         if(qtyWithUOM=='No')
			        {
				        newcontent += '<td align="right">'+(parseFloat(StkFlashData[i].dblCostRM)/currValue).toFixed(maxAmountDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblOpStock).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblGRN).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblFreeQty).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblSCGRN).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				        
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblStkTransIn).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblStkAdjIn).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblMISIn).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblQtyProduced).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblSalesReturn).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblMaterialReturnIn).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblPurchaseReturn).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblDeliveryNote).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblStkTransOut).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblStkAdjOut).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblMISOut).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblQtyConsumed).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				       
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblSales).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblClosingStock).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblValue/currValue).toFixed(maxAmountDecimalPlaceLimit) +'</td>';
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblIssueUOMStock).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblIssueConversion+'</td>';
				        
			        }
			        else
				    {				        
				        newcontent += '<td align="right">'+StkFlashData[i].dblCostRM/currValue+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblOpStock+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblGRN+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblFreeQty+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblSCGRN+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblStkTransIn+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblStkAdjIn+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblMISIn+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblQtyProduced+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblSalesReturn+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblMaterialReturnIn+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblPurchaseReturn+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblDeliveryNote+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblStkTransOut+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblStkAdjOut+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblMISOut+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblQtyConsumed+'</td>';
				       
				        newcontent += '<td align="right">'+StkFlashData[i].dblSales+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblClosingStock+'</td>';
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblValue/currValue).toFixed(maxAmountDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblIssueUOMStock+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblIssueConversion+'</td>';
					}
			        
			        
			        newcontent += '<td>'+StkFlashData[i].strIssueUOM+'</td>';
			        newcontent += '<td>'+StkFlashData[i].strPartNo+'</td></tr>';
			    }			   
		    }
		    if($("#cmbReportType").val()=='Summary') 
		    {
			   	newcontent = '<table id="tblStockFlash" class="transTablex" style="width: 100%;font-size:11px;font-weight: bold;"><tr bgcolor="#c0c0c0"><td id="labls1">Property Name</td><td id="labls2">Product Code</td><td id="labls3">Product Name</td><td id="labls4">Location</td><td id="labls5">Group</td><td id="labls6">Sub Group</td><td id="labls7">UOM</td><td id="labls8">Bin No</td><td id="labls9">Weighted Avg Price</td><td id="labls10">Opening Stock</td><td id="labls11">Receipts</td><td id="labls12">Issue</td><td id="labls13">Closing Stock</td><td id="labls14">Value</td><td id="labls15">Issue UOM Stock</td><td id="labls16">Issue Conversion</td><td id="labls17">Issue UOM</td><td id="labls18">Part No</td></tr>';
					   
			    // Iterate through a selection of the content and build an HTML string
			    for(var i=page_index*items_per_page;i<max_elem;i++)
			    {
			        newcontent += '<tr><td>'+StkFlashData[i].strPropertyName+'</td>';
			        //newcontent += '<td>'+StkFlashData[i].strProdCode+'</td>';
			        newcontent += '<td><a id="stkLedgerUrl.'+i+'" href="#" onclick="funClick(this);">'+StkFlashData[i].strProdCode+'</a></td>';
			        //newcontent += '<td onclick="funClick(this);>'+StkFlashData[i].strProdCode+'</td>';
			        
			        newcontent += '<td>'+StkFlashData[i].strProdName+'</td>';
			        newcontent += '<td>'+StkFlashData[i].strLocName+'</td>';
			        newcontent += '<td>'+StkFlashData[i].strGroupName+'</td>';
			        newcontent += '<td>'+StkFlashData[i].strSubGroupName+'</td>';
			        newcontent += '<td>'+StkFlashData[i].strUOM+'</td>';
			        newcontent += '<td>'+StkFlashData[i].strBinNo+'</td>';
			        
			        var qtyWithUOM=$("#cmbQtyWithUOM").val();
			        if(qtyWithUOM=='No')
			        {
				        newcontent += '<td align="right">'+parseFloat((StkFlashData[i].dblCostRM/currValue)).toFixed(maxAmountDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblOpStock).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblReceipts).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblIssue).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblClosingStock).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblValue/currValue).toFixed(maxAmountDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblIssueUOMStock).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblIssueConversion+'</td>';				        
			        }			        
			        else
					{
				        newcontent += '<td align="right">'+StkFlashData[i].dblCostRM/currValue+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblOpStock+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblReceipts+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblIssue+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblClosingStock+'</td>';
				        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblValue/currValue).toFixed(maxAmountDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblIssueUOMStock+'</td>';
				        newcontent += '<td align="right">'+StkFlashData[i].dblIssueConversion+'</td>';
					}
			        
			        newcontent += '<td>'+StkFlashData[i].strIssueUOM+'</td>';
			        newcontent += '<td>'+StkFlashData[i].strPartNo+'</td><tr>';
			    }
		    }
		    if($("#cmbReportType").val()=='Mini') 
		    {
	        	newcontent = '<table id="tblStockFlash" class="transTablex" style="width: 100%;font-size:11px;font-weight: bold;"><tr bgcolor="#75c0ff"><td id="labls2">Product Code</td><td id="labls3">Product Name</td><td id="labls13">Closing Stock</td><td id="labls14">Value</td><td style="width: 10%;"></td></tr>';
	        	 var qtyWithUOM=$("#cmbQtyWithUOM").val();
			    // Iterate through a selection of the content and build an HTML string
			    for(var i=page_index*items_per_page;i<max_elem;i++)
			    {
			        newcontent += '<td><a id="stkLedgerUrl.'+i+'" href="#" onclick="funClick(this);">'+StkFlashData[i].strProdCode+'</a></td>';
			        newcontent += '<td>'+StkFlashData[i].strProdName+'</td>';
			        if(qtyWithUOM=='No'){
			        	newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblClosingStock).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';	
			        }else{
			        	newcontent += '<td align="right">'+StkFlashData[i].dblClosingStock+'</td>';
			        }
			        
			        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblValue/currValue).toFixed(maxAmountDecimalPlaceLimit)+'</td>';

			        newcontent += '<td></td><tr>';
			    }	
		    }
		    if($("#cmbReportType").val()=='Total') 
		    {
	        	newcontent = '<table id="tblStockFlash" class="transTablex" style="width: 80%;  float:left;font-size:11px;font-weight: bold;"><tr bgcolor="#c0c0c0"><td id="labls3" style="font-size:14px;">Transaction Type</td><td align="right" id="labls14" style="font-size:14px;">Value</td></tr>';
				   
			    // Iterate through a selection of the content and build an HTML string
			    for(var i=page_index*items_per_page;i<max_elem;i++)
			    {
			    	
			        newcontent += '<td>'+StkFlashData[i].strPropertyName+'</td>';
			        newcontent += '<td align="right">'+parseFloat(StkFlashData[i].dblValue/currValue).toFixed(maxAmountDecimalPlaceLimit)+'</td><tr>';
			    }	
		    }
	
		    
		    
		    
		    newcontent += '</table>';
		    // Replace old content with new content
		   
		    $('#Searchresult').html(newcontent);
		   
		    // Prevent click eventpropagation
		    return false;
		}
				
		
		function funCalculateStockFlashForSummary()
		{
			var currValue='<%=session.getAttribute("currValue").toString()%>';
			var reportType=$("#cmbReportType").val();
			var fromDate=$("#txtFromDate").val();
			var toDate=$("#txtToDate").val();
			var locCode=$("#cmbLocation").val();
			var propCode=$("#cmbProperty").val();
			var showZeroItems=$("#cmbShowZeroItems").val();
			var strGCode= $('#strGCode').val();
			var strSGCode= $('#strSGCode').val();
			var strNonStkItems=$("#cmbNonStkItems").val();
			var qtyWithUOM=$("#cmbQtyWithUOM").val();
			var prodType=$("#txtProdType").val();
			var param1=reportType+","+locCode+","+propCode+","+showZeroItems+","+strSGCode+","+strNonStkItems+","+strGCode+","+qtyWithUOM;
			var manufCode=$("#txtManufacturerCode").val();
			var prodClass=$("#cmbProductClass").val();
			var searchUrl=getContextPath()+"/frmStockFlashSummaryReport.html?param1="+param1+"&fDate="+fromDate+"&tDate="+toDate+"&prodType="+prodType+"&ManufCode="+manufCode+"&prodClass="+prodClass;
			
			$.ajax({
			        type: "GET",
			        url: searchUrl,
				    dataType: "json",
				    success: function(response)
				    {				    	
				    	StkFlashData=response[0];
				    	showTable();
				    	funGetTotalValue(response[1]/currValue);
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
		
		
		function funCalculateStockFlashForDetail()
		{			
			var currValue='<%=session.getAttribute("currValue").toString()%>';
			var reportType=$("#cmbReportType").val();
			var fromDate=$("#txtFromDate").val();
			var toDate=$("#txtToDate").val();
			var locCode=$("#cmbLocation").val();
			var propCode=$("#cmbProperty").val();
			var showZeroItems=$("#cmbShowZeroItems").val();
			var strGCode= $('#strGCode').val();
			var strSGCode= $('#strSGCode').val();
			var strNonStkItems=$("#cmbNonStkItems").val();
			var qtyWithUOM=$("#cmbQtyWithUOM").val();
			var prodType=$("#txtProdType").val();
			var prodClass=$("#cmbProductClass").val();
			var ratePickUpFrom = $("#cmbPriceCalculation").val();
			
			var param1=reportType+","+locCode+","+propCode+","+showZeroItems+","+strSGCode+","+strNonStkItems+","+strGCode+","+qtyWithUOM+","+ratePickUpFrom;
			var paramForStkLedger=locCode+","+propCode;		
			var manufCode=$("#txtManufacturerCode").val();
			var searchUrl=getContextPath()+"/frmStockFlashDetailReport.html?param1="+param1+"&fDate="+fromDate+"&tDate="+toDate+"&prodType="+prodType+"&ManufCode="+manufCode+"&prodClass="+prodClass;
			//alert(searchUrl);
			
			$.ajax({
			        type: "GET",
			        url: searchUrl,
				    dataType: "json",
				    success: function(response)
				    {
				    	StkFlashData=response[0];
				    	showTable();
				    	funGetTotalValue(response[1]/currValue);	
				    	
				    	
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
		
		function funCalculateMiniStockFlash()
		{
			var currValue='<%=session.getAttribute("currValue").toString()%>';
			var reportType=$("#cmbReportType").val();
			var fromDate=$("#txtFromDate").val();
			var toDate=$("#txtToDate").val();
			var locCode=$("#cmbLocation").val();
			var propCode=$("#cmbProperty").val();
			var showZeroItems=$("#cmbShowZeroItems").val();
			var strGCode= $('#strGCode').val();
			var strSGCode= $('#strSGCode').val();
			var strNonStkItems=$("#cmbNonStkItems").val();
			var qtyWithUOM=$("#cmbQtyWithUOM").val();
			var prodType=$("#txtProdType").val();
			var param1=reportType+","+locCode+","+propCode+","+showZeroItems+","+strSGCode+","+strNonStkItems+","+strGCode+","+qtyWithUOM;
			var manufCode=$("#txtManufacturerCode").val();
			var prodClass=$("#cmbProductClass").val();
			var searchUrl=getContextPath()+"/frmMiniStockFlashReport.html?param1="+param1+"&fDate="+fromDate+"&tDate="+toDate+"&prodType="+prodType+"&ManufCode="+manufCode+"&prodClass="+prodClass;
			
			$.ajax({
			        type: "GET",
			        url: searchUrl,
				    dataType: "json",
				    success: function(response)
				    {				    	
				    	StkFlashData=response[0];
				    	showTable();
				    	funGetTotalValue(response[1]/currValue);
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
		
		
		function funCalculateStockFlashForTotal()
		{			
			var currValue='<%=session.getAttribute("currValue").toString()%>';
			var reportType=$("#cmbReportType").val();
			var fromDate=$("#txtFromDate").val();
			var toDate=$("#txtToDate").val();
			var locCode=$("#cmbLocation").val();
			var propCode=$("#cmbProperty").val();
			var showZeroItems=$("#cmbShowZeroItems").val();
			var strGCode= $('#strGCode').val();
			var strSGCode= $('#strSGCode').val();
			var strNonStkItems=$("#cmbNonStkItems").val();
			var qtyWithUOM=$("#cmbQtyWithUOM").val();
			var prodType=$("#txtProdType").val();
			var prodClass=$("#cmbProductClass").val();

			var param1=reportType+","+locCode+","+propCode+","+showZeroItems+","+strSGCode+","+strNonStkItems+","+strGCode+","+qtyWithUOM+","+prodClass;
			var paramForStkLedger=locCode+","+propCode;		
			var manufCode=$("#txtManufacturerCode").val();
			var searchUrl=getContextPath()+"/frmStockFlashTotalReport.html?param1="+param1+"&fDate="+fromDate+"&tDate="+toDate+"&prodType="+prodType+"&ManufCode="+manufCode;
			//alert(searchUrl);
			
			$.ajax({
			        type: "GET",
			        url: searchUrl,
				    dataType: "json",
				    success: function(response)
				    {
				    	StkFlashData=response[0];
				    	showTable();		       	
				    //	funGetTotalValue(response[1]/currValue);	
				    	
				    	
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
			$("#btnExport").click(function (e)
			{
				var reportType=$("#cmbReportType").val();
				var fromDate=$("#txtFromDate").val();
				var toDate=$("#txtToDate").val();
				var locCode=$("#cmbLocation").val();
				var propCode=$("#cmbProperty").val();
				var showZeroItems=$("#cmbShowZeroItems").val();
				var strGCode= $('#strGCode').val();
				var strSGCode= $('#strSGCode').val();
				var strNonStkItems=$("#cmbNonStkItems").val();
				var qtyWithUOM=$("#cmbQtyWithUOM").val();
				var strExportType=$("#cmbExportType").val();
				var prodType=$("#txtProdType").val();
				var ratePickUpFrom = $("#cmbPriceCalculation").val();
				var param1=reportType+","+locCode+","+propCode+","+showZeroItems+","+strSGCode+","+strNonStkItems+","+strGCode+","+qtyWithUOM+","+strExportType+","+ratePickUpFrom;
				//var param1=reportType+","+locCode+","+propCode+","+showZeroItems;
				var manufCode=$("#txtManufacturerCode").val();
				if(reportType=='Summary' && strExportType=="PDF" )
					{
					window.location.href=getContextPath()+"/rptStockFlash.html?strExportType="+strExportType+"&prodType="+prodType+"&param1="+param1+"&ManufCode="+manufCode;
					}else if( reportType=='Mini')
						{
						window.location.href=getContextPath()+"/rptStkFlashMiniReport.html?param1="+param1+"&fDate="+fromDate+"&tDate="+toDate+"&prodType="+prodType+"&ManufCode="+manufCode;
						}else 
							{
								window.location.href=getContextPath()+"/downloadExcel.html?param1="+param1+"&fDate="+fromDate+"&tDate="+toDate+"&prodType="+prodType+"&ManufCode="+manufCode;
							}
						});
		});
		function funHelp(transactionName)
		{	       
	       // window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	       window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	    }
		function funSetData(code)
		{
			$("#txtManufacturerCode").val(code);
		}
		
		 		

        function funAddExportType()
		{
        	var cSelect = document.getElementById("cmbExportType"); 
        	 while (cSelect.options.length > 0) 
	       	 { 
	       	  cSelect.remove(0); 
	       	 } 
        	 if($("#cmbReportType").val()=='Detail')
        	 {
        		cSelect.add(new Option('Excel'));
        	 }
        	 else if($("#cmbReportType").val()=='Total')
	       	 {
	       		cSelect.add(new Option('Excel'));
	       	 }
        	 else
        	 {
        		cSelect.add(new Option('Excel'));
        		cSelect.add(new Option('PDF'));
        	 }	 
		} 
       function funAddReprtType()
		{
        	var cSelectReport = document.getElementById("cmbReportType"); 
        	while (cSelectReport.options.length > 0) 
	       	{ 
        		cSelectReport.remove(0); 
	       	} 
        	cSelectReport.add(new Option('Mini'));
        	cSelectReport.add(new Option('Detail'));
        	cSelectReport.add(new Option('Summary'));
        	cSelectReport.add(new Option('Total'));
        	 
		}
         
		 
		 
	</script>
</head>
<body> <!--  onload="funOnLoad();" -->
<div class="container">
		<label id="formHeading">Stock Flash</label>
		<s:form method="GET" name="frmStkFlash">
		<div class="row transTable">
			<div class="col-md-2">
				<label>Property Code</label>
					<s:select id="cmbProperty" name="propCode" path="strPropertyCode" onchange="funChangeLocationCombo();">
			    		<s:options items="${listProperty}"/>
			    	</s:select>
			</div>		
			<div class="col-md-2">			
				<label>Location</label>
				<s:select id="cmbLocation" name="locCode" path="strLocationCode" >
			    		<s:options items="${listLocation}"/>
			    </s:select>
			</div>
			<div class="col-md-2">		
				<label>Group</label>
				<s:select path="strGCode" items="${listGroup}" id="strGCode" onchange="funFillCombo(this.value);"></s:select>
			</div>
			<div class="col-md-2">	
				<label>SubGroup</label>
				<s:select path="strSGCode" items="${listSubGroup}" id="strSGCode"></s:select>
			</div>
			<div class="col-md-4"></div>
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
			     <label>Report Type</label>
				<s:select path="strReportType" id="cmbReportType" cssClass="BoxW124px" onchange="funAddExportType();">
					<option value="Detail">Detail</option>
					<option value="Summary">Summary</option>
					<option value="Mini">Mini</option>
					<option value="Total">Total</option>
				</s:select>
			</div>
			<div class="col-md-2">   							
				<label>Zero Trans ProductsM</label>
				<select id="cmbShowZeroItems" class="BoxW124px" style="width:50%;">
					<option>No</option>
					<option>Yes</option>
				</select>
			</div>
			<div class="col-md-4"></div>
			<div class="col-md-2">   
				<label>Items Type</label>
				<select id="cmbNonStkItems" class="BoxW124px">
					<option selected="selected">Stockable</option>
					<option>Non Stockable</option>
					<option>Both</option>
				</select>
			</div>
			<div class="col-md-2">		
				<label>Quantity With UOM</label>
				<select id="cmbQtyWithUOM" class="BoxW124px" style="width:50%;">
					<option selected="selected">No</option>
					<option>Yes</option>
				</select>
			</div>			
			<div class="col-md-2">			
				<label>Product Type</label>
				<s:select id="txtProdType" name="prodType" path="strProdType" items="${typeList}" cssClass="BoxW124px"/>
			</div>	
			<div class="col-md-2">		
				<label>Manufacturer Code</label>
				<s:input id="txtManufacturerCode" path="strManufacturerCode" type="text"
						cssClass="searchTextBox" readonly="true" ondblclick="funHelp('manufactureMaster')" />
			</div>
			<div class="col-md-4">	</div>
			<div class="col-md-2">				
				<s:select path="strExportType" id="cmbExportType"  cssClass="BoxW124px" style="margin-top: 28px;">
					<option value="Excel">Excel</option>
				</s:select>
			</div>		
			<div class="col-md-2">	
				<label >Product Class</label>
				<s:select id="cmbProductClass" name="class" path="strProductClass" items="${classProductlist}" cssClass="BoxW48px" style="width:50%;" />
			</div>
			<div class="col-md-2">			
				<label>Value Calculation On </label>
				<select id="cmbPriceCalculation" class="BoxW124px" > <!-- onchange="funValueCalculation()" -->
					<option selected="selected">Weighted AVG</option>
					<option>Last Supplier Rate</option>
				</select>
			</div>	
		</div>
		<div class="center" style="text-align:center;">
		 	<button type="button" class="btn btn-primary center-block" id="btnExport" value="Export">Export</button>&nbsp
		 	<!-- <a href="#"><button class="btn btn-primary center-block" id="btnExecute" onclick="return funOnClick()" value="EXECUTE">Execute</button></a> -->
		 	
		 	<button type="button" class="btn btn-primary center-block" id="btnExecute" value="EXECUTE">Execute</button>
		 
		</div>
			
			<dl id="Searchresult" style="width: 105%;height:auto; overflow:auto; border:1px solid #000;"></dl>
			<div id="Pagination" class="pagination" style="width: 80%;margin-left: 26px;">
		
			</div>
		
		<br>
		<br>
		
		
		<div id="divValueTotal" style="background-color: #fbfafa; border: 1px solid #ccc; display: block; height: 40px; margin: auto; overflow-x: hidden; overflow-y: hidden; width: 95%;">
			<table id="tblTotalFlash" class="transTablex" style="width: 100%; font-size: 11px; font-weight: bold;">
				<tr style="margin-left: 28px">
					<td id="labld26" style="width:20%; text-align:right">Total</td>
					<td id="tdTotValue" style="width:10%; align:right">
						<input id="txtTotValue" style="width: 100%; text-align: right;" class="Box"></input>
					</td>
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