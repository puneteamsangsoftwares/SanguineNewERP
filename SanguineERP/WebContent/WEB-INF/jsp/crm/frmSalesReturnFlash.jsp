<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<meta http-equiv="X-UA-Compatible" content="IE=8">
		
<title></title>

<script type="text/javascript">
		var invoceFlashData,frmDte1="",toDte1="",maxQuantityDecimalPlaceLimit=2;
		
		$(document).ready(function() 
				{		
				
					$("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
					$("#txtFromDate").datepicker('setDate','today');
					$("#txtFromDate").datepicker();
					$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
					$("#txtToDate" ).datepicker('setDate', 'today');
					$("#txtToDate").datepicker();
					
					var oldFrmDate=$('#txtFromDate').val().split('-');
					var oldToDate=$('#txtToDate').val().split('-');
					frmDte1=oldFrmDate[2]+"-"+oldFrmDate[1]+"-"+oldFrmDate[0];
					toDte1=oldToDate[2]+"-"+oldToDate[1]+"-"+oldToDate[0];
					
					
					
					var code='<%=session.getAttribute("locationCode").toString()%>';
					funSetLocation(code);
					funOnClckRegionWiseBtn('divRegionWise');
					
					$(document).ajaxStart(function()
							{
							    $("#wait").css("display","block");
							});
							$(document).ajaxComplete(function()
							{
								$("#wait").css("display","none");
							});
		
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
				
				 case 'locationmaster':
				    	funSetLocation(code);
				        break;
				        
				 case 'custMasterActive' :
			 			funSetCuster(code);
			 			break;
				}		
			}

		 	function funSetCuster(code)
			{
				var gurl=getContextPath()+"/loadPartyMasterData.html?partyCode=";
				$.ajax({
			        type: "GET",
			        url: gurl+code,
			        dataType: "json",
			        success: function(response)
			        {		        	
			        		if('Invalid Code' == response.strPCode){
			        			alert("Invalid Customer Code");
			        			$("#txtCustCode").val('');
			        			$("#txtCustCode").focus();
			        		}else{			   
			        			$("#txtCustCode").val(response.strPCode);
								$("#lblCustomerName").text(response.strPName);
					
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
		 		
			$(document).ready(function() 
			{
				$("#btnExecute").click(function( event )
				{
					
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
		
			
			
			$(document).ready(function () 
					{			 
						/*$("#btnExport").click(function (e)
						{
							var Code=$('#txtCustCode').val();	 
							if(Code=="")
							{
								Code="All";
							}
							var frmDte1=$('#txtFromDate').val();
							var toDte1=$('#txtToDate').val();
							var locCode1=$('#txtLocCode').val();

		
						window.location.href=getContextPath()+"/exportInvoiceExcel.html?custcode="+Code+"&frmDte="+frmDte1+"&toDte="+toDte1+"&locCode="+locCode1;
									
									});
						*/
					});
			
			
			
			
			
			
			
			function funShowTableGUI(divID)
			{
				hidReportName=divID;
				// for hide Table GUI
				document.all["divRegionWise"].style.display = 'none';
 				document.all["divItemWise"].style.display = 'none';
 				document.all["divCustomerWise"].style.display = 'none';
				document.all["divCategoryWise"].style.display = 'none';
				
				// for show Table GUI
				document.all[divID].style.display = 'block';
				
			}
			
			
			
			function funOnClckRegionWiseBtn( divId)
			{
				funShowTableGUI(divId);
				//var settCode=$('#cmbSettlement').val();
				var locCode=$('#txtLocCode').val();
				var custCode=$('#txtCustCode').val();
				//var searchUrl=getContextPath()+"/loadSalesReturnFlashRegionWise.html?settlementcode="+settCode+"&frmDte="+frmDte1+"&toDte="+toDte1+"&locCode="+locCode;
				var searchUrl=getContextPath()+"/loadSalesReturnFlashRegionWise.html?frmDte="+frmDte1+"&toDte="+toDte1+"&locCode="+locCode+"&custCode="+custCode;
				$.ajax({
				        type: "GET",
				        url: searchUrl,
					    dataType: "json",
					    success: function(response)
					    {
					    	funRegionWiseDetail(response[0])
					    	funGetTotalValue(response[1],response[2],response[3]);
					    	
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
			
			function funGetTotalValue(dblTotalValue,dblSubTotalValue,dblTaxTotalValue)
			{
				$("#txtTotValue").val(parseFloat(dblTotalValue).toFixed(maxQuantityDecimalPlaceLimit));
				$("#txtSubTotValue").val(parseFloat(dblSubTotalValue).toFixed(maxQuantityDecimalPlaceLimit));
				$("#txtTaxTotValue").val(parseFloat(dblTaxTotalValue).toFixed(maxQuantityDecimalPlaceLimit));
			}
			
			function funRegionWiseDetail(ProdDtl)
			{
				$('#tblRegionDet tbody').empty();
				for(var i=0;i<ProdDtl.length;i++)
				{
				 var data=ProdDtl[i];
				 
			    var table = document.getElementById("tblRegionDet");
			    var rowCount = table.rows.length;
			    var row = table.insertRow(rowCount);
			   
			    row.insertCell(0).innerHTML= "<input name=\"strPropertyName["+(rowCount)+"]\" readonly=\"readonly\"  class=\"Box\" style=\"width:99%;\" id=\"strPropertyName."+(rowCount)+"\" value='"+data.strPropertyName+"'>";		    
			    row.insertCell(1).innerHTML= "<input name=\"strSRCode["+(rowCount)+"]\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"strSRCode."+(rowCount)+"\" value='"+data.strSRCode+"'>";
			    row.insertCell(2).innerHTML= "<input name=\"dteSRDate["+(rowCount)+"]\" id=\"dteSRDate."+(rowCount)+"\" readonly=\"readonly\" style=\"width:99%;\" class=\"Box\" value="+data.dteSRDate+">";
			    row.insertCell(3).innerHTML= "<input name=\"strDCCode["+(rowCount)+"]\" id=\"strDCCode."+(rowCount)+"\" readonly=\"readonly\" style=\"width:99%;\" class=\"Box\" value="+data.strDCCode+">";
			    row.insertCell(4).innerHTML= "<input name=\"strCustName["+(rowCount)+"]\" readonly=\"readonly\"  class=\"Box\" style=\"width:99%;\" id=\"strCustName."+(rowCount)+"\" value='"+data.strCustName+"'>";
			    row.insertCell(5).innerHTML= "<input name=\"strAgainst["+(rowCount)+"]\" id=\"strAgainst."+(rowCount)+"\" readonly=\"readonly\" style=\"width:99%;\" class=\"Box\" value='"+data.strAgainst+"'>";		    	   
			    row.insertCell(6).innerHTML= "<input name=\"DblSubTotalAmt["+(rowCount)+"]\" id=\"DblSubTotalAmt."+(rowCount)+"\" readonly=\"readonly\" style=\"text-align: right;width:99%;\"  class=\"Box\" value="+data.dblTotalAmt+">";
			    row.insertCell(7).innerHTML= "<input name=\"DblTaxAmt["+(rowCount)+"]\" id=\"DblTaxAmt."+(rowCount)+"\" readonly=\"readonly\" style=\"text-align: right;width:99%;\" class=\"Box\" value="+data.dblTaxAmt+">";
			    row.insertCell(8).innerHTML= "<input name=\"DblTotalAmt["+(rowCount)+"]\" id=\"DblTotalAmt."+(rowCount)+"\" readonly=\"readonly\" style=\"text-align: right;width:99%;\"  class=\"Box\" value="+data.dblGrandTotal+">";
			   
			    
			    funApplyNumberValidation();
				}
			}
			
			function funApplyNumberValidation(){
				$(".numeric").numeric();
				$(".integer").numeric(false, function() { alert("Integers only"); this.value = ""; this.focus(); });
				$(".positive").numeric({ negative: false }, function() { alert("No negative values"); this.value = ""; this.focus(); });
				$(".positive-integer").numeric({ decimal: false, negative: false }, function() { alert("Positive integers only"); this.value = ""; this.focus(); });
			    $(".decimal-places").numeric({ decimalPlaces: maxQuantityDecimalPlaceLimit, negative: false });
			    $(".decimal-places-amt").numeric({ decimalPlaces: maxAmountDecimalPlaceLimit, negative: false });
			}
			
			
			function funOnClckItemWiseBtn( divId)
			{
				funShowTableGUI(divId)
				//var settCode=$('#cmbSettlement').val();
				var locCode=$('#txtLocCode').val();	
				var custCode=$('#txtCustCode').val();
				//var searchUrl=getContextPath()+"/loadItemWiseSaleReturnDtl.html?settlementcode="+settCode+"&frmDte="+frmDte1+"&toDte="+toDte1+"&locCode="+locCode;
				var searchUrl=getContextPath()+"/loadItemWiseSaleReturnDtl.html?frmDte="+frmDte1+"&toDte="+toDte1+"&locCode="+locCode+"&custCode="+custCode;
				$.ajax({
				        type: "GET",
				        url: searchUrl,
					    dataType: "json",
					    success: function(response)
					    {
					    	funItemWiseDetail(response[0]);
					    	$("#txtTotValue").val(parseFloat(response[1]).toFixed(maxQuantityDecimalPlaceLimit));
					    	$("#txtSubTotValue").val("");
					    	$("#txtTaxTotValue").val(parseFloat(response[2]).toFixed(maxQuantityDecimalPlaceLimit));
					    	
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
			
			function funItemWiseDetail(ProdDtl)
			{
				$('#tblItemDet tbody').empty();
				for(var i=0;i<ProdDtl.length;i++)
				{
				 var data=ProdDtl[i];
				 data.dblTotalAmt=parseFloat(data.dblTotalAmt).toFixed(maxQuantityDecimalPlaceLimit);
			     var table = document.getElementById("tblItemDet");
			     var rowCount = table.rows.length;
			     var row = table.insertRow(rowCount);
			    
				    row.insertCell(0).innerHTML= "<input name=\"strSRCode["+(rowCount)+"]\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"strSRCode."+(rowCount)+"\" value='"+data.strSRCode+"'>";	
				    row.insertCell(1).innerHTML= "<input name=\"strProductName["+(rowCount)+"]\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"strProductName."+(rowCount)+"\" value='"+data.strProductName+"'>";
				    row.insertCell(2).innerHTML= "<input name=\"strAgainst["+(rowCount)+"]\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"strAgainst."+(rowCount)+"\" value='"+data.strAgainst+"'>";
				    row.insertCell(3).innerHTML= "<input name=\"dteSRDate["+(rowCount)+"]\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"dteSRDate."+(rowCount)+"\" value='"+data.dteSRDate+"'>";
				    row.insertCell(4).innerHTML= "<input name=\"CustomerName["+(rowCount)+"]\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"CustomerName."+(rowCount)+"\" value='"+data.strCustName+"'>";
				    row.insertCell(5).innerHTML= "<input name=\"strLocName["+(rowCount)+"]\" id=\"strLocName."+(rowCount)+"\" readonly=\"readonly\"  style=\"width:99%;\" class=\"Box\" value='"+data.strLocName+"'>";
				    row.insertCell(6).innerHTML= "<input name=\"dblQty["+(rowCount)+"]\" id=\"dblQty."+(rowCount)+"\" readonly=\"readonly\"   style=\"text-align: right;width:99%;\"  class=\"Box\" value="+data.dblConversion+">";
				    row.insertCell(7).innerHTML= "<input name=\"DblSubTotalAmt["+(rowCount)+"]\" id=\"DblSubTotalAmt."+(rowCount)+"\" readonly=\"readonly\" style=\"text-align: right;width:99%;\"  class=\"Box\" value="+data.dblTotalAmt+">";
				   // row.insertCell(8).innerHTML= "<input name=\"DblTaxAmt["+(rowCount)+"]\" id=\"DblTaxAmt."+(rowCount)+"\" readonly=\"readonly\" style=\"text-align: right;\" size=\"10%\" class=\"Box\" value="+data.dblTaxAmt+">";
				   // row.insertCell(9).innerHTML= "<input name=\"DblTotalAmt["+(rowCount)+"]\" id=\"DblTotalAmt."+(rowCount)+"\" readonly=\"readonly\" style=\"text-align: right;\" size=\"10%\" class=\"Box\" value="+data.dblGrandTotal+">";
				    
				    
				    
				    
			    funApplyNumberValidation();
				}
			}
			
			
		
			
			function funOnClckCuctomerWiseBtn( divId)
			{
				funShowTableGUI(divId)
				//var settCode=$('#cmbSettlement').val();
				var locCode=$('#txtLocCode').val();	
				var custCode=$('#txtCustCode').val();
				//var searchUrl=getContextPath()+"/loadCustomerWiseSaleReturnDtl.html?settlementcode="+settCode+"&frmDte="+frmDte1+"&toDte="+toDte1+"&locCode="+locCode;
				var searchUrl=getContextPath()+"/loadCustomerWiseSaleReturnDtl.html?frmDte="+frmDte1+"&toDte="+toDte1+"&locCode="+locCode+"&custCode="+custCode;
				$.ajax({
				        type: "GET",
				        url: searchUrl,
					    dataType: "json",
					    success: function(response)
					    {
					    	funcustomerWiseProductDetail(response[0]);
					    	$("#txtTotValue").val(parseFloat(response[1]).toFixed(maxQuantityDecimalPlaceLimit));
					    	$("#txtSubTotValue").val("");
							$("#txtTaxTotValue").val("");
					    	
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
			
			function funcustomerWiseProductDetail(ProdDtl)
			{
				var userName="";
				$('#tblCustomerDet tbody').empty();
				var rowCount = "";
			    var row ="";
				var amt='';
				for(var i=0;i<ProdDtl.length;i++)
				{
				 var data=ProdDtl[i];
				
			    var table = document.getElementById("tblCustomerDet");
			    var rowCount = table.rows.length;
			    var row = table.insertRow(rowCount);
			    data.dblTotalAmt=parseFloat(data.dblTotalAmt).toFixed(maxQuantityDecimalPlaceLimit);
			    
			    row.insertCell(0).innerHTML= "<input name=\"customerCode["+(rowCount)+"]\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"customerCode."+(rowCount)+"\" value='"+data.strSRCode+"'>";
			    row.insertCell(1).innerHTML= "<input name=\"CustomerName["+(rowCount)+"]\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"CustomerName."+(rowCount)+"\" value='"+data.strCustName+"'>";	    
			    row.insertCell(2).innerHTML= "<input name=\"strAgainst["+(rowCount)+"]\" id=\"strAgainst."+(rowCount)+"\" readonly=\"readonly\" style=\"width:99%;\" class=\"Box\" value='"+data.strAgainst+"'>";
			    row.insertCell(3).innerHTML= "<input name=\"strLocName["+(rowCount)+"]\" id=\"strLocName."+(rowCount)+"\" readonly=\"readonly\"  style=\"width:99%;\" class=\"Box\" value='"+data.strLocName+"'>";
			    row.insertCell(4).innerHTML= "<input name=\"dteSRDate["+(rowCount)+"]\" id=\"dteSRDate."+(rowCount)+"\" readonly=\"readonly\"  style=\"width:99%;\" class=\"Box\" value="+data.dteSRDate+">";
			    row.insertCell(5).innerHTML= "<input name=\"DblSubTotalAmt["+(rowCount)+"]\" id=\"DblSubTotalAmt."+(rowCount)+"\" readonly=\"readonly\" style=\"text-align: right;width:99%;\"  class=\"Box\" value="+data.dblTotalAmt+">";
			    
				}
				
				  funApplyNumberValidation();
			}
			
			
		
			
		
			function funOnClckGroupSubGroupWiseBtn( divId)
			{
				funShowTableGUI(divId)
				//var settCode=$('#cmbSettlement').val();
				var locCode=$('#txtLocCode').val();
				var custCode=$('#txtCustCode').val();
				//var searchUrl=getContextPath()+"/loadCategoryWiseSaleReturnDtl.html?settlementcode="+settCode+"&frmDte="+frmDte1+"&toDte="+toDte1+"&locCode="+locCode;
				var searchUrl=getContextPath()+"/loadGroupSubGroupWiseSaleReturnDtl.html?frmDte="+frmDte1+"&toDte="+toDte1+"&locCode="+locCode+"&custCode="+custCode;
				$.ajax({
				        type: "GET",
				        url: searchUrl,
					    dataType: "json",
					    success: function(response)
					    {
					    	funGroupSubGroupWiseProductDetail(response[0]);
					    	$("#txtTotValue").val(parseFloat(response[1]).toFixed(maxQuantityDecimalPlaceLimit));
					    	$("#txtSubTotValue").val("");
							$("#txtTaxTotValue").val(parseFloat(response[2]).toFixed(maxQuantityDecimalPlaceLimit));
					    	
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
			
		
			function funGroupSubGroupWiseProductDetail(ProdDtl)
			{
				$('#tblCategoryDet tbody').empty();
				for(var i=0;i<ProdDtl.length;i++)
				{
				 var data=ProdDtl[i];
				 data.dblTotalAmt=parseFloat(data.dblTotalAmt).toFixed(maxQuantityDecimalPlaceLimit);
			     var table = document.getElementById("tblCategoryDet");
			     var rowCount = table.rows.length;
			     var row = table.insertRow(rowCount);
			    
				    row.insertCell(0).innerHTML= "<input name=\"strSRCode["+(rowCount)+"]\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"strSRCode."+(rowCount)+"\" value='"+data.strSRCode+"'>";		    
				    row.insertCell(1).innerHTML= "<input name=\"strProductName["+(rowCount)+"]\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"strProductName."+(rowCount)+"\" value='"+data.strProductName+"'>";
				    row.insertCell(2).innerHTML= "<input name=\"strAgainst["+(rowCount)+"]\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"strAgainst."+(rowCount)+"\" value='"+data.strAgainst+"'>";
				    row.insertCell(3).innerHTML= "<input name=\"dteSRDate["+(rowCount)+"]\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"dteSRDate."+(rowCount)+"\" value='"+data.dteSRDate+"'>";
				    row.insertCell(4).innerHTML= "<input name=\"CustomerName["+(rowCount)+"]\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"CustomerName."+(rowCount)+"\" value='"+data.strCustName+"'>";
				    row.insertCell(5).innerHTML= "<input name=\"strLocName["+(rowCount)+"]\" id=\"strLocName."+(rowCount)+"\" readonly=\"readonly\"  style=\"width:99%;\" class=\"Box\" value='"+data.strLocName+"'>";
				    row.insertCell(6).innerHTML= "<input name=\"dblQty["+(rowCount)+"]\" id=\"dblQty."+(rowCount)+"\" readonly=\"readonly\"   style=\"text-align: right;width:99%;\"  class=\"Box\" value="+data.dblConversion+">";
				    row.insertCell(7).innerHTML= "<input name=\"DblSubTotalAmt["+(rowCount)+"]\" id=\"DblSubTotalAmt."+(rowCount)+"\" readonly=\"readonly\" style=\"text-align: right;width:99%;\"  class=\"Box\" value="+data.dblTotalAmt+">";
				   // row.insertCell(8).innerHTML= "<input name=\"DblTaxAmt["+(rowCount)+"]\" id=\"DblTaxAmt."+(rowCount)+"\" readonly=\"readonly\" style=\"text-align: right;\" size=\"10%\" class=\"Box\" value="+data.dblTaxAmt+">";
				   // row.insertCell(9).innerHTML= "<input name=\"DblTotalAmt["+(rowCount)+"]\" id=\"DblTotalAmt."+(rowCount)+"\" readonly=\"readonly\" style=\"text-align: right;\" size=\"10%\" class=\"Box\" value="+data.dblGrandTotal+">";
				    
				    
				    
				    
			    funApplyNumberValidation();
				}
			}
			
			function funChangeFromDate()
			{
				var oldFrmDate=$('#txtFromDate').val().split('-');
				var oldToDate=$('#txtToDate').val().split('-');
				frmDte1=oldFrmDate[2]+"-"+oldFrmDate[1]+"-"+oldFrmDate[0];
				toDte1=oldToDate[2]+"-"+oldToDate[1]+"-"+oldToDate[0];
			}
			function funChangeToDate()
			{
				var oldFrmDate=$('#txtFromDate').val().split('-');
				var oldToDate=$('#txtToDate').val().split('-');
				frmDte1=oldFrmDate[2]+"-"+oldFrmDate[1]+"-"+oldFrmDate[0];
				toDte1=oldToDate[2]+"-"+oldToDate[1]+"-"+oldToDate[0];
			}
			
			
			
			function funExportReport()
		 	{
		 		var locCode=$('#txtLocCode').val();
		 		var custCode=$('#txtCustCode').val();
				if(locCode=="")
					{
					locCode="All";
					}
				
				 if(hidReportName=='divRegionWise')
				 {
					window.location.href = getContextPath()+"/exportRegionWiseSalesReturnFlash.html?frmDte="+frmDte1+"&toDte="+toDte1+"&locCode="+locCode+"&custCode="+custCode;
				 }
				else if(hidReportName=='divItemWise')
				 {
					window.location.href = getContextPath()+"/exportItemWiseSalesReturnFlash.html?frmDte="+frmDte1+"&toDte="+toDte1+"&locCode="+locCode+"&custCode="+custCode;
				 }
				else if(hidReportName=='divCustomerWise')
				 {
					window.location.href = getContextPath()+"/exportCustomerWiseSalesReturnFlash.html?frmDte="+frmDte1+"&toDte="+toDte1+"&locCode="+locCode+"&custCode="+custCode;
				 }
				else if(hidReportName=='divCategoryWise')
				 {
					window.location.href = getContextPath()+"/exportGroupSubGroupWiseSalesReturnFlash.html?frmDte="+frmDte1+"&toDte="+toDte1+"&locCode="+locCode+"&custCode="+custCode;
				 }
				
				
				
		 	}
			
			
		
			function funPrintReport()
			{
				var locCode=$('#txtLocCode').val();
		 		var custCode=$('#txtCustCode').val();
				window.open(getContextPath()+"/rptProductWiseSalesReturnPDF.html?frmDte="+frmDte1+"&toDte="+toDte1+"&locCode="+locCode+"&custCode="+custCode);
				
			}
			

			
		 	</script>
</head>

<body>
	<div class="container">
		<label id="formHeading">Sales Return Flash</label>
		<s:form name="Form" method="GET" action="">
			<div class="row transTable">
				<div class="col-md-3">
					<div class="row">
						<div class="col-md-6">
							<label id="lblFromDate">From Date</label>
							<s:input id="txtFromDate" required="required" path=""
								name="fromDate" cssClass="calenderTextBox" onchange="funChangeFromDate();" />
						</div>
						<div class="col-md-6">
							<label id="lblToDate">To Date</label>
							<s:input id="txtToDate" name="toDate" path=""
								cssClass="calenderTextBox" onchange="funChangeToDate();" />
						</div>
					</div>
				</div>
				<div class="col-md-2">
					<label>Location Code</label>
						<s:input type="text" id="txtLocCode" path="strLocCode"
							cssClass="searchTextBox" ondblclick="funHelp('locationmaster');" />
				</div>
				<div class="col-md-2">
					<label id="lblLocName" style="background-color:#dcdada94; width: 100%; height: 43%; margin-top:25px; padding:2px;"></label>
				</div>
				<div class="col-md-5"></div>
<!-- 				<td width="100px"><label>Settlement</label> -->
<%-- 				<td><s:select id="cmbSettlement" path="strSettlementCode" --%>
<%-- 						items="${settlementList}" cssClass="BoxW124px" /></td> --%>
            	 
                 	<s:input type="hidden" id="hidReportName" path=""></s:input>
                 <div class="col-md-2">
					<label>Customer Code</label>
						<s:input path="" id="txtCustCode"
							ondblclick="funHelp('custMasterActive')" cssClass="searchTextBox" />
				</div>
				<div class="col-md-2">
					<label id="lblCustomerName" class="namelabel"  style="background-color:#dcdada94; width: 100%; height: 43%; margin-top:25px; padding:2px;"></label>
				</div>
			</div>
			<div class="center" style="text-align:right; margin-right:47%;">
				<a href="#"><button class="btn btn-primary center-block" id="btnExport" value="EXPORT" onclick="funExportReport()" 
						 class="form_button1">EXPORT</button></a>
				<a href="#"><button class="btn btn-primary center-block" id="btnExport" value="PRINT" onclick="funPrintReport()"
						class="form_button1">PRINT</button></a>
			</div>
	
		<div id="divRegionWise" class="dynamicTableContainer"
			style="height: 350px;">
			<table style="width: 100%; border: #0F0; table-layout: fixed;"
				class="transTablex col15-center">
				<tr bgcolor="#c0c0c0">
					<td width="10%">Property Name </td>
					<td width="6.1%">SR Code</td>
					<td width="6.1%">Date</td>
					<td width="5%">DC Code</td>
					<td width="10%">Customer Name</td>
					<td width="4.5%">Against</td>
					<td width="5.1%">SubTotal</td>
					<td width="5%">Tax Amount</td>
					<td width="6%">Grand Total</td>
					
				</tr>
			</table>
			<div
				style="background-color: #fbfafa; border: 1px solid #ccc; display: block; height: 330px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
				<table id="tblRegionDet"
					style="width: 100%; border: #0F0; table-layout: fixed;"
					class="transTablex col15-center">
					<tbody>
					<col style="width: 10%">
					<col style="width: 6%">
					<col style="width: 6%">
					<col style="width: 5%">
					<col style="width: 10%">
					<col style="width: 4.5%">
					<col style="width: 5%">
					<col style="width: 5%">
					<col style="width: 5%">
					</tbody>

				</table>
			</div>
		</div>
		<div id="divItemWise" class="dynamicTableContainer"
			style="height: 400px;">
			<table style="width: 100%; border: #0F0; table-layout: fixed;"
				class="transTablex col15-center">
				<tr bgcolor="#c0c0c0">
					<td width="5.3%">SR Code</td>
					<td width="11.7%">Product Name </td>
					<td width="4.6%">Against</td>
					<td width="4.4%">Date</td>
					<td width="7.6%">Customer Name</td>
					<td width="5.1%">Location</td>
					<td width="3.8%">Quantity</td>
					<td width="5.5%">SubTotal</td>
				</tr>
			</table>
			<div
				style="background-color: #fbfafa; border: 1px solid #ccc; display: block; height: 330px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
				<table id="tblItemDet"
					style="width: 100%; border: #0F0; table-layout: fixed;"
					class="transTablex col15-center">
					<tbody>
					<col style="width: 5.2%">
					<col style="width: 11.4%">
					<col style="width: 4.6%">
					<col style="width: 4.3%">
					<col style="width: 7.5%">
					<col style="width: 5%">
					<col style="width: 3.7%">
					<col style="width: 4.7%">

					</tbody>

				</table>
			</div>
		</div>
	<div id="divCustomerWise" class="dynamicTableContainer"
			style="height: 400px;">
			<table style="width: 100%; border: #0F0; table-layout: fixed;"
				class="transTablex col15-center">
				<tr bgcolor="#c0c0c0">
					<td width="4.6%">Customer Code</td>
					<td width="12%">Customer Name</td>
					<td width="4.8%">Against</td>
					<td width="5%">Location</td>
					<td width="5%">Date</td>
					<td width="5%">SubTotal</td>
				</tr>
			</table>
			<div
				style="background-color: #fbfafa; border: 1px solid #ccc; display: block; height: 330px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
				<table id="tblCustomerDet"
					style="width: 100%; border: #0F0; table-layout: fixed;"
					class="transTablex col15-center">
					<tbody>
					<col style="width: 4.4%">
					<col style="width: 11.6%">
					<col style="width: 4.6%">
					<col style="width: 4.9%">
					<col style="width: 4.7%">
					<col style="width: 4.3%">
				
					</tbody>

				</table>
			</div>
		</div>
		<div id="divCategoryWise" class="dynamicTableContainer"
			style="height: 400px;">
			<table style="width: 100%; border: #0F0; table-layout: fixed;"
				class="transTablex col15-center">
				<tr bgcolor="#c0c0c0">
					<td width="7.4%">Group Name</td>
					<td width="9.3%">SubGroup Name </td>
					<td width="4.5%">Against</td>
					<td width="4.8%">Date</td>
					<td width="7.6%">Customer Name</td>
					<td width="5.1%">Location</td>
					<td width="4.6%">Quantity</td>
					<td width="4.7%">SubTotal</td>
				</tr>
			</table>
			<div
				style="background-color: #fbfafa; border: 1px solid #ccc; display: block; height: 330px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
				<table id="tblCategoryDet"
					style="width: 100%; border: #0F0; table-layout: fixed;"
					class="transTablex col15-center">
					<tbody>
					<col style="width: 7.2%">
					<col style="width: 9.2%">
					<col style="width: 4.5%">
					<col style="width: 4.6%">
					<col style="width: 7.6%">
					<col style="width: 5%">
					<col style="width: 4.5%">
					<col style="width: 3.9%">
					</tbody>
				</table>
			</div>
		</div>
		<div id="divValueTotal"
			style="background-color: c0c0c0; border: 1px solid #ccc; display: block; height: 50px; margin: auto; overflow-x: hidden; overflow-y: hidden; width: 94%;">
			<table id="tblTotalFlash" class="transTablex"
				style="width: 100%; font-size: 11px; font-weight: bold;">
				<tr style="margin-left: 28px">
					<td id="labld26" width="70%" align="right">Total Value</td>
					<td id="tdSubTotValue" width="10%" align="right"><input
						id="txtSubTotValue" style="width: 100%; text-align: right;"
						class="Box"></input></td>
					<td id="tdTaxTotValue" width="10%" align="right"><input
						id="txtTaxTotValue" style="width: 100%; text-align: right;"
						class="Box"></input></td>
					<td id="tdTotValue" width="10%" align="right"><input
						id="txtTotValue" style="width: 100%; text-align: right;"
						class="Box"></input></td>
				</tr>
			</table>
		</div>
		<div
			style="background-color: #c0c0c0; border: 1px solid #ccc; display: block; height: 40px; margin: auto;  width: 94%;">
			<table>
				<tr>
					<td>
						<input id="btnRegionWise" type="button" class="btn btn-primary center-block form_button"
							value="Region Wise" onclick="funOnClckRegionWiseBtn('divRegionWise')" style="color:#000;" />
					</td>
					<td>
						<input id="btnItemWise" type="button" class="btn btn-primary center-block form_button"
							value="Product Wise" onclick="funOnClckItemWiseBtn('divItemWise')" style="color:#000;" />
					</td>
					<td>
						<input id="btnCustomerWise" type="button"
							class="btn btn-primary center-block form_button" value="Customer Wise"  onclick="funOnClckCuctomerWiseBtn('divCustomerWise')" style="color:#000;"/>
					</td>
					<td>
						<input id="btnCategoryWise" type="button"
							class="btn btn-primary center-block form_button" value="Group SubGroup Wise"  onclick="funOnClckGroupSubGroupWiseBtn('divCategoryWise')" style="background-size: 140px 24px; width: 140px; color:#000;"/>
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