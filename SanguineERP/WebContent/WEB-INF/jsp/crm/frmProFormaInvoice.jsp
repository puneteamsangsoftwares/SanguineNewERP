<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>ProForma Invoice</title>
       
<style type="text/css">

.transTable td{
	border-left: none;
	padding-left: 0px;
}

</style>

<script type="text/javascript">


		var QtyTol=0.00;	
		var bookingNO
		$(document).ready(function() 
		{	
			var sgData ;
			var prodData;
			var clientCode='<%=session.getAttribute("clientCode").toString()%>';				
			var Against='';<%-- '<%=session.getAttribute("Banquet").toString()%>'; --%>			
			var customerCode='';<%-- '<%=session.getAttribute("CustomerCode").toString()%>';		 --%>	
			bookingNO=''; <%-- '<%=session.getAttribute("BookingNo").toString()%>';	 --%>	
			if(bookingNO!=''&&Against!=''&&customerCode!='')
			 {
				 $("#cmbAgainst").val(Against);	
				 $("#txtCustCode").val(funSetBookingNo);					 
				 document.all["txtSOCode"].style.display = 'block';
				 document.all["btnFill"].style.display = 'block';  
				 $("#txtSOCode").val(bookingNO);	
				 funSetCuster(customerCode);
				 funSetBookingNo(bookingNO);
				 funSetSalesOrderDtl();
				 <%session.removeAttribute("Banquet");%>
				 <%session.removeAttribute("BookingNo");%>
				 <%session.removeAttribute("CustomerCode");%>
			 }
			 else
			 {
				
				 $("#txtReservationNo").val("");
				 <%session.removeAttribute("Banquet");%>
				 <%session.removeAttribute("BookingNo");%>
				 <%session.removeAttribute("CustomerCode");%>
				 
			 }   
		
				
			$(".tab_content").hide();
			$(".tab_content:first").show();
	
			$("ul.tabs li").click(function() {
				$("ul.tabs li").removeClass("active");
				$(this).addClass("active");
				$(".tab_content").hide();
				var activeTab = $(this).attr("data-state");
				$("#" + activeTab).fadeIn();
			});
			
			var code='<%=session.getAttribute("locationCode").toString()%>';
			funSetLocation(code);
<%-- 			var dayEndDate='<%=session.getAttribute("dayEndDate").toString()%>'; --%>

			  $("#txtDCDate").datepicker({ dateFormat: 'dd-mm-yy' });
				$("#txtDCDate" ).datepicker('setDate', 'today');
				$("#txtDCDate").datepicker(); 
				
				 $("#txtAginst").datepicker({ dateFormat: 'dd-mm-yy' });
					$("#txtAginst" ).datepicker('setDate', 'today');
					$("#txtAginst").datepicker();
					
					 $("#txtWarrPeriod").datepicker({ dateFormat: 'dd-mm-yy' });
						$("#txtWarrPeriod" ).datepicker('setDate', 'today');
						$("#txtWarrPeriod").datepicker();
						
						 $("#txtWarraValidity").datepicker({ dateFormat: 'dd-mm-yy' });
							$("#txtWarraValidity" ).datepicker('setDate', 'today');
							$("#txtWarraValidity").datepicker();		
				
							var message='';
							<%if (session.getAttribute("success") != null) {
					            if(session.getAttribute("successMessage") != null){%>
					            message='<%=session.getAttribute("successMessage").toString()%>';
					            <%
					            session.removeAttribute("successMessage");
					            }
								boolean test = ((Boolean) session.getAttribute("success")).booleanValue();
								session.removeAttribute("success");
								if (test) {
								%>	
					alert("Data Save successfully\n\n"+message);
				<%
				}}%>
						
							<%if(null!=session.getAttribute("rptInvCode")){%>
							
							code='<%=session.getAttribute("rptInvCode").toString()%>';
<%-- 							dccode='<%=session.getAttribute("rptDcCode").toString()%>'; --%>
							dccode='';
							<%if(null!=session.getAttribute("rptInvDate")){%>
							invDate='<%=session.getAttribute("rptInvDate").toString()%>';
							invoiceformat='<%=session.getAttribute("invoieFormat").toString()%>';
<%-- 							invoiceformat='<%=session.getAttribute("invoieFormat").toString()%>'; --%>
							<%session.removeAttribute("rptInvCode");%>
							<%session.removeAttribute("rptInvDate");%>
							<%session.removeAttribute("rptDcCode");%>
							var isOk=confirm("Do You Want to Generate Slip?");
							if(isOk){
								
 							if(invoiceformat=="Format 1")
 								{
 								window.open(getContextPath()+"/rptProFormaInvoiceSlipFormat5Report.html?rptInvCode="+code+"&rptInvDate="+invDate,'_blank');
		 						//window.open(getContextPath()+"/openRptProFormaInvoiceSlip.html?rptInvCode="+code,'_blank');
		 						/* window.open(getContextPath()+"/openRptProFormaInvoiceProductSlip.html?rptInvCode="+code+"&rptInvDate="+invDate,'_blank');
		 						window.open(getContextPath()+"/rptProFormaTradingInvoiceSlip.html?rptInvCode="+code+"&rptInvDate="+invDate,'_blank'); */
								}
							else{
								if(invoiceformat=="Format 2")
								{
								window.open(getContextPath()+"/rptProFormaInvoiceSlipFromat2.html?rptInvCode="+code+"&rptInvDate="+invDate,'_blank');
								//window.open(getContextPath()+"/rptProFormaInvoiceSlipNonExcisableFromat2.html?rptInvCode="+code+"&rptInvDate="+invDate,'_blank');
								//window.open(getContextPath()+"/rptDeliveryChallanInvoiceSlip.html?strDocCode="+dccode,'_blank');
								}else if(invoiceformat=="Format 5")
								{
									
									window.open(getContextPath()+"/rptProFormaInvoiceSlipFormat5Report.html?rptInvCode="+code+"&rptInvDate="+invDate,'_blank');
								}
								else if(invoiceformat=="RetailNonGSTA4"){
								window.open(getContextPath()+"/openRptProFormaInvoiceRetailNonGSTReport.html?rptInvCode="+code,'_blank');
							    }else
							    	{
							    	window.open(getContextPath()+"/openRptProFormaInvoiceRetailReport.html?rptInvCode="+code,'_blank');
							    	}
							}
							}
// 							var isOk=confirm("Do You Want to Generate Product Detail Slip?");
// 							if(isOk){
// 								window.open(getContextPath()+"/openRptInvoiceProductSlip.html?rptInvCode="+code+"&rptInvDate="+invDate,'_blank');
// 									}
							<%}%><%}%>
							
							$('a#baseUrl').click(function() 
									{
										if($("#txtDCCode").val().trim() == "")
										{
											alert("Please Select Invoice Code");
											return false;
										}
										window.open('attachDoc.html?transName=frmInovice.jsp&formName=Invoice&code='+$("#txtDCCode").val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
									});				
		});
		
		
		
		
		
		function funHelp(transactionName)
		{
			var strIndustryType='<%=session.getAttribute("selectedModuleName").toString()%>';
			if(strIndustryType=='7-WebBanquet') 
	   		{
				if(transactionName.includes('deliveryChallan'))
					{
					transactionName='BookingNo';	
					}
				else if(transactionName.includes('custMasterActive'))
				{
					transactionName='CustomerInfo';
				}
				
				else if(transactionName.includes('proformaInvoice'))
				{
					transactionName='proformaInvoice';
				}
			}
			
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
				    	
				 case 'productProduced':
					 var cust=$("#txtCustCode").val();
					 if(cust.length>0)
						 {
				    	funSetProduct(code);
						 }else{
							 alert("Please Select customer code");
						 }
					 break;
				        
				 case 'deliveryChallan':   
					 //funSetDeliveryChallanData(code);
					 $('#txtSOCode').val(code);
					 break;
					 
					  
				 case 'proformaInvoice':
					   funSetInvoiceData(code)
					  break;
				        
				 case 'OpenTaxesForSales':
				       funSetTax(code);
				       break;
				       
				 case 'VehCode' : 
					 funSetVehCode(code);
						break;	      
				  case 'subgroup':
				    	funSetSubGroup(code);
				        break;
				        
				  case 'BookingNo':
				    	funSetBookingNo(code);
				        break;  
				        
				  case 'CustomerInfo':
				    	funSetCustNo(code);
				        break;    
				}
			}
		 	
		 	function funSetCustNo(code)
		 	{
		 		$("#txtCustCode").val(code);
		 	}
		 	
		 	function funSetBookingNo(code)
		 	{
		 		$("#txtSOCode").val(code);
		 	}
		 	
		 	function funSetSubGroup(code)
			{
				$("#hidSubGroupCode").val(code);
				gurl=getContextPath()+"/loadSubGroupMasterData.html?subGroupCode="+code;
				$.ajax({
				        type: "GET",
				        url: gurl,
				        dataType: "json",
				        success: function(response)
				        {
					        	$("#txtSubGroup").val(response.strSGName);
						},
				        error: function(e)
				        {				        	
				        	alert("Invalid SubGroup Code");
			        		$("#txtSubgroupCode").val('');
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
// 				$("#txtCustCode").focus();
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
	        			$("#txtCustCode").val('');
	        			$("#txtCustCode").focus();
	        			$("#lblCustomerName").text('');
	        		}else{			   
	        			$("#txtCustCode").val(response.strPCode);
						$("#lblCustomerName").text(response.strPName);
						$("#txtSAddress1").val(response.strSAdd1);
						$("#txtSAddress2").val(response.strSAdd2);
						$("#txtSCity").val(response.strSCity);
						$("#txtSState").val(response.strSState);
						$("#txtSPin").val(response.strSPin);
						$("#txtSCountry").val(response.strSCountry);
						$("#hidcustDiscount").val(response.dblDiscount);
						$("#txtDiscountPer").val(response.dblDiscount);
						
						$("#txtLocCode").focus();
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
	
	
	
	
	function funSetProduct(code)
	{
		var searchUrl="";
		var locCode = $("#txtLocCode").val();
		var custCode=$("#txtCustCode").val();
		searchUrl=getContextPath()+"/loadProductDataForInvoice.html?prodCode="+code+"&suppCode="+custCode+"&locCode="+locCode;
		$.ajax({
			type: "GET",
		    url: searchUrl,
			dataType: "json",
			success: function(response)
			{
			    if(response!="Invalid Product Code")
			    {
			    	var currValue='<%=session.getAttribute("currValue").toString()%>';
			    	if(currValue==null)
			    	{
			    		currValue=1;
			    	}
			    	var dblStock=funGetProductStock(response[0][0]);
			    	$("#spStock").text(dblStock);
					$("#hidProdCode").val(response[0][0]);
					$("#txtProdName").val(response[0][1]);
					$("#txtPrice").val(parseFloat((response[0][3])/parseFloat(currValue)).toFixed(maxQuantityDecimalPlaceLimit));
					$("#hidUnitPrice").val(parseFloat((response[0][3])/parseFloat(currValue)).toFixed(maxQuantityDecimalPlaceLimit));
					
					$("#txtWeight").val(response[0][7]);
					$("#hidProdType").val(response[0][6]);
					$("#hidPrevInvCode").val(response[0][8]);
					$("#hidPreInvPrice").val(response[0][9]);
					if(parseFloat(response[0][11])==0)
					{
						$("#txtPurchasePrice").val(parseFloat((response[0][10])/parseFloat(currValue)).toFixed(maxQuantityDecimalPlaceLimit));
					}else
					{
						$("#txtPurchasePrice").val(parseFloat((response[0][11])/parseFloat(currValue)).toFixed(maxQuantityDecimalPlaceLimit));
					}
					$("#txtQty").focus();
				}
			    else
				{
			    	alert("Invalid Product Code");
			    	$("#txtProdName").val('') 
			    	$("#txtProdName").focus();
			    	return false;
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
	
	
	function funSetDeliveryChallanData(code)
	{
		gurl=getContextPath()+"/loadDeliveryChallanHdData.html?dcCode="+code;
		$.ajax({
	        type: "GET",
	        url: gurl,
	        dataType: "json",
	        success: function(response)
	        {		        	
	        		if('Invalid Code' == response.strDCCode){
	        			alert("Invalid Delivery Challan Code");
	        			$("#txtSOCode").val('');
	        			$("#txtSOCode").focus();
	        			
	        		}else{	
	        			funRemoveAllRows();
	        			$('#txtDCCode').val(response.strInvCode);
	        			$('#txtDCDate').val(response.dteInvDate);
	        		//	$('#txtAginst').val(response.strAgainst);
	        			$('#cmbAgainst').val(response.strAgainst);
	        			if(response.strAgainst=="Delivery Challan")
	        			{
	        			document.all["txtSOCode"].style.display = 'block';
	        			document.all["btnFill"].style.display = 'block';
	        			
	        			}else
	        				{
	        				document.all["txtSOCode"].style.display = 'none';
	        				document.all["btnFill"].style.display = 'none';
	        				}
	        			$('#txtPONo').val(response.strPONo);
	        			$('#txtLocCode').val(response.strLocCode);
	        			$('#lblLocName').text(response.strLocName);
	        			$('#txtVehNo').val(response.strVehNo);
	        			$('#txtWarrPeriod').val(response.strWarrPeriod);
	        			$('#txtWarraValidity').val(response.strWarraValidity);
	        			$('#txtNarration').val(response.strNarration);
	        			$('#txtPackNo').val(response.strPackNo);
	        			$('#txtDktNo').val(response.strDktNo);
	        			$('#txtMInBy').val(response.strMInBy);
	        			$('#txtTimeOut').val(response.strTimeInOut);
	        			$('#txtReaCode').val(response.strReaCode);
	        			$("#txtSOCode").val(response.strSOCode);
						$("#txtSODate").val(response.dteSODate);
						$("#txtCustCode").val(response.strCustCode);
						$("#lblCustomerName").text(response.strCustName);
						$("#txtSAddress1").val(response.strSAdd1);
						$("#txtSAddress2").val(response.strSAdd2);
						$("#txtSCity").val(response.strSCity);
						$("#txtSState").val(response.strSState);
						$("#txtSPin").val(response.strSPin);
						$("#txtSCountry").val(response.strSCountry);
						QtyTol=0.00;
						$.each(response.listclsDeliveryChallanModelDtl, function(i,item)
		       	       	    	 {
		       	       	    	    funfillDCDataRow(response.listclsDeliveryChallanModelDtl[i]);
		       	       	    		$("#txtQtyTotl").val(QtyTol);
		       	       	    	 });
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
 	
	
	
	function funSetInvoiceData(code)
	{
		gurl=getContextPath()+"/loadProFormaInvoiceHdData.html?invCode="+code;
		$.ajax({
	        type: "GET",
	        url: gurl,
	        dataType: "json",
	        success: function(response)
	        {		        	
	        		if(null == response.strInvCode){
	        			alert("Invalid  Invoice Code");
	        			$("#txtSOCode").val('');
	        			$("#txtSOCode").focus();
	        			funRemoveAllRows();
	        			
	        		}else{	
	        			funRemoveAllRows();
	        			$('#txtDCCode').val(code);
	        			$('#txtDCDate').val(response.dteInvDate);
	        	//		$('#txtAginst').val(response.strAgainst);
	        			$('#cmbAgainst').val(response.strAgainst);
	        			if(response.strAgainst=="Delivery Challan")
	        			{
	        			document.all["txtSOCode"].style.display = 'block';
	        			document.all["btnFill"].style.display = 'block';
	        			
	        			}else
	        				{
	        				document.all["txtSOCode"].style.display = 'none';
	        				document.all["btnFill"].style.display = 'none';
	        				}
	        			$('#txtPONo').val(response.strPONo);
	        			$('#txtLocCode').val(response.strLocCode);
	        			$('#lblLocName').text(response.strLocName);
	        			$('#txtVehNo').val(response.strVehNo);
	        			$('#txtWarrPeriod').val(response.strWarrPeriod);
	        			$('#txtWarraValidity').val(response.strWarraValidity);
	        			$('#txtNarration').val(response.strNarration);
	        			$('#txtPackNo').val(response.strPackNo);
	        			$('#txtDktNo').val(response.strDktNo);
	        			$('#txtMInBy').val(response.strMInBy);
	        			$('#txtTimeOut').val(response.strTimeInOut);
	        			$('#txtReaCode').val(response.strReaCode);
	        			$("#txtSOCode").val(response.strSOCode);
						$("#txtSODate").val(response.dteSODate);
						$("#txtCustCode").val(response.strCustCode);
						$("#lblCustomerName").text(response.strCustName);
						$("#txtSAddress1").val(response.strSAdd1);
						$("#txtSAddress2").val(response.strSAdd2);
						$("#txtSCity").val(response.strSCity);
						$("#txtSState").val(response.strSState);
						$("#txtSPin").val(response.strSPin);
						$("#txtSCountry").val(response.strSCountry);
						$("#txtSubTotlAmt").val(response.dblSubTotalAmt);
						$("#txtFinalAmt").val(response.dblTotalAmt);
						$("#txtDiscount").val(response.dblDiscountAmt);
						$("#txtDiscountPer").val(response.dblDiscount);
						
						$("#cmbSettlement").val(response.strSettlementCode);
						$('#txtMobileNoForSettlement').val(response.strMobileNoForSettlement);
						$("#hidcustDiscount").val(response.dblDiscountAmt);
						QtyTol=0.00;
						$.each(response.listclsInvoiceModelDtl, function(i,item)
		       	       	{
							var prevData="loadInvData";					
		       	       	  	funfillDCDataRow(response.listclsInvoiceModelDtl[i],prevData);
		       	       		$("#txtQtyTotl").val(QtyTol);
		       	       	});
						
						funRemoveTaxRows();
						$.each(response.listInvoiceTaxDtl, function(i,item)
			            {
							funFillTaxRow(response.listInvoiceTaxDtl[i]);
			            });
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
 	
	
	function funFillTaxRow(taxDtl) 
	{
		var currValue='<%=session.getAttribute("currValue").toString()%>';
		if(currValue==null)
		{
			currValue=1;
		}
	    var table = document.getElementById("tblTax");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
	    var taxCode=taxDtl.strTaxCode;
	    var taxDesc=taxDtl.strTaxDesc;
	    var taxableAmt=(taxDtl.strTaxableAmt/currValue).toFixed(maxQuantityDecimalPlaceLimit);
	    var taxAmt=(taxDtl.strTaxAmt/currValue).toFixed(maxQuantityDecimalPlaceLimit);
		
	    row.insertCell(0).innerHTML= "<input class=\"Box\" style=\"width:99%;\" name=\"listInvoiceTaxDtl["+(rowCount)+"].strTaxCode\" id=\"txtTaxCode."+(rowCount)+"\" value='"+taxCode+"' >";
	    row.insertCell(1).innerHTML= "<input class=\"Box\" style=\"width:99%;\" name=\"listInvoiceTaxDtl["+(rowCount)+"].strTaxDesc\" id=\"txtTaxDesc."+(rowCount)+"\" value='"+taxDesc+"'>";		    	    
	    row.insertCell(2).innerHTML= "<input type=\"number\" step=\"any\" required = \"required\" style=\"text-align: right; width:99%; border:1px solid #a2a2a2;padding:1px;\" name=\"listInvoiceTaxDtl["+(rowCount)+"].strTaxableAmt\" id=\"txtTaxableAmt."+(rowCount)+"\" value="+taxableAmt+">";
	    row.insertCell(3).innerHTML= "<input type=\"number\" step=\"any\" required = \"required\" style=\"text-align: right; width:99%; border:1px solid #a2a2a2;padding:1px;\" name=\"listInvoiceTaxDtl["+(rowCount)+"].strTaxAmt\" id=\"txtTaxAmt."+(rowCount)+"\" value="+taxAmt+">";		    
	    row.insertCell(4).innerHTML= '<input type="button" size=\"6%\" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteTaxRow(this)" >';
	    
	    funCalTaxTotal();
	    funClearFieldsOnTaxTab();
	    
	    return false;
	}
	
	

	function btnAdd_onclick()
	{
		
		if($("#hidProdCode").val().length<=0)
			{
				$("#txtProdName").focus();
				alert("Please Enter Product Name Or Search");
				return false;
			}		
		
		if($("#txtDiscount").val().length<=0)
		{
			$("#txtDiscount").focus();
			alert("Please Enter Discount");
			return false;
		}
		if($("#hidUnitPrice").val().length<=0 || $("#hidUnitPrice").val()==0)
		{
			$("#hidUnitPrice").focus();
			alert("Please Enter Sales Price");
			return false;
		}
	    if($("#txtQty").val().trim().length==0 || $("#txtQty").val()== 0)
	        {		
	          alert("Please Enter Quantity");
	          $("#txtQty").focus();
	          return false;
	       } 
	    if( parseFloat($("#spStock").text())<= 0)
        {		
          alert("Please Add Stock");
          $("#txtQty").focus();
          return false;
       } 
	    else
	    	{
	    	var strProdCode=$("#hidProdCode").val();
	    	// funSeProductUnitPrice(strProdCode);
	    	// var unitprice= $("#hidbillRate").val();
	    	 
	    	 if(funDuplicateProduct(strProdCode))
	    		 {
	    		 
	    		 funAddProductRow();
	    		 }
	    	}
	}
	
	function funDuplicateProduct(strProdCode)
	{
	    var table = document.getElementById("tblProdDet");
	    var rowCount = table.rows.length;		   
	    var flag=true;
	    if(rowCount > 0)
	    	{
			    $('#tblProdDet tr').each(function()
			    {
				    if(strProdCode==$(this).find('input').val())// `this` is TR DOM element
    				{
				    	alert("Already added "+ strProdCode);
	    				flag=false;
    				}
				});
			    
	    	}
	    return flag;
	}
	
	function funAddProductRow()
	{
		var table = document.getElementById("tblProdDet");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
	    var strProdCode = $("#hidProdCode").val().trim();
		var strProdName=$("#txtProdName").val().trim();
		var strProdType=$("#hidProdType").val();	
	    var dblQty = $("#txtQty").val();
	    parseFloat(dblQty).toFixed(maxQuantityDecimalPlaceLimit);
	    var dblWeight=$("#txtWeight").val();
	    var dblTotalWeight=dblQty*dblWeight;
	  	var packingNo= $("#txtPackingNo").val();
	    var strSerialNo = $("#txtSerialNo").val();
	    var strInvoiceable = $("#cmbInvoiceable").val();
	    var strRemarks=$("#txtRemarks").val();
	    var prodDisPer=$("#txtProdDisper").val();
	    
	    var prevInvCode=$("#hidPrevInvCode").val();
	    var prevProdrice=$("#hidPreInvPrice").val();
        var unitprice=$("#hidUnitPrice").val();
       unitprice=parseFloat(unitprice).toFixed(maxQuantityDecimalPlaceLimit);
	   var totalPrice=unitprice*dblQty;
	   
	   var disAmt=(prodDisPer*totalPrice)/100;
	   var grandtotalPrice=totalPrice- disAmt;
	   

       var strCustCode=$("#txtCustCode").val();
       var strSOCode="";
	   row.insertCell(0).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strProdCode\" readonly=\"readonly\" class=\"Box txtProdCode\" style=\"width:99%;\" id=\"txtProdCode."+(rowCount)+"\" value='"+strProdCode+"' />";		  		   	  
	    row.insertCell(1).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strProdName\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"txtProdName."+(rowCount)+"\" value='"+strProdName+"'/>";
	    row.insertCell(2).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strProdType\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"txtProdTpye."+(rowCount)+"\" value='"+strProdType+"'/>";
	    row.insertCell(3).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblQty\" type=\"text\"  required = \"required\" style=\"text-align: right;width:99%;border:1px solid #c0c0c0;\"   class=\"decimal-places inputText-Auto  txtQty\" id=\"txtQty."+(rowCount)+"\" value="+dblQty+" onblur=\"Javacsript:funUpdatePrice(this)\">";
	    row.insertCell(4).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblWeight\" type=\"text\"  required = \"required\" style=\"text-align: right;width:99%;border:1px solid #c0c0c0;\"  class=\"decimal-places inputText-Auto\" id=\"txtWeight."+(rowCount)+"\" value="+dblWeight+" >";
	    row.insertCell(5).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblTotalWeight\" readonly=\"readonly\" class=\"Box\" style=\"text-align: right;width:99%;\"  id=\"dblTotalWeight."+(rowCount)+"\"   value='"+dblTotalWeight+"'/>";
	    row.insertCell(6).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblUnitPrice\" readonly=\"readonly\" class=\"Box txtUnitprice\" style=\"text-align:right;width:99%;\"  id=\"unitprice."+(rowCount)+"\"   value='"+unitprice+"'/>";
	    row.insertCell(7).innerHTML= "<input readonly=\"readonly\" class=\"Box totalValueCell\" style=\"text-align: right;width:99%;\"  id=\"totalPrice."+(rowCount)+"\"   value='"+totalPrice+"'/>";
	    
	    row.insertCell(8).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblDisAmt\" readonly=\"readonly\" class=\"Box dblDisAmt\" style=\"text-align: right;width:99%;\"  id=\"dblDisAmt."+(rowCount)+"\"   value='"+disAmt+"'/>";
	    row.insertCell(9).innerHTML= "<input readonly=\"readonly\" class=\"Box grandtotalPrice\" style=\"text-align: right;width:99%;\"  id=\"grandtotalPrice."+(rowCount)+"\"   value='"+grandtotalPrice+"'/>";
	    
	    row.insertCell(10).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strPktNo\" type=\"text\"    class=\"Box\" style=\"width:99%;border:1px solid #c0c0c0;\" id=\"txtPktNo."+(rowCount)+"\" value="+packingNo+" >";
		row.insertCell(11).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strRemarks\" style=\"width:99%;\" id=\"txtRemarks."+(rowCount)+"\" value='"+strRemarks+"'/>";
	    row.insertCell(12).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strInvoiceable\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"txtInvoiceable."+(rowCount)+"\" value="+strInvoiceable+" >";
	    row.insertCell(13).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strSerialNo\" type=\"text\"    class=\"Box\" style=\"width:99%;border:1px solid #c0c0c0;\" id=\"txtSerialNo."+(rowCount)+"\" value="+strSerialNo+" >";	    
	 	row.insertCell(14).innerHTML= '<input  class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRow(this)">';		    
	 	row.insertCell(15).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strCustCode\" type=\"text\" class=\"Box\" style=\"width:99%;border:1px solid #c0c0c0;\" id=\"txtCustCode."+(rowCount)+"\" value="+strCustCode+" >";
	 	row.insertCell(16).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strSOCode\" type=\"text\"  class=\"Box\" style=\"width:99%;border:1px solid #c0c0c0;\" id=\"txtSOCOde."+(rowCount)+"\" value="+strSOCode+" >";
	 	 row.insertCell(17).innerHTML= "<input readonly=\"readonly\" class=\"Box prevInvCode\" style=\"text-align: right;width:99%;\"  id=\"prevInvCode."+(rowCount)+"\"   value='"+prevInvCode+"'/>";
	 	 row.insertCell(18).innerHTML= "<input readonly=\"readonly\" class=\"Box prevProdrice\" style=\"text-align: right;width:99%;\"  id=\"prevProdrice."+(rowCount)+"\"   value='"+prevProdrice+"'/>";
	 	QtyTol+=parseFloat(dblQty);
	 	$("#txtQtyTotl").val(QtyTol);
	    $("#txtSubGroup").focus();
	    funCalculateTotalAmt();
	    funClearProduct();
	   // funGetTotal();
	    return false;
	}
	
	function funSeProductUnitPrice(code)
	{
		var strCustCode = $("#txtCustCode").val();
		var discount= $("#txtDiscount").val();
		var searchUrl="";
		searchUrl=getContextPath()+"/loadInvoiceProductDetail.html?prodCode="+code+"&strCustCode="+strCustCode+"&discount="+discount;
		$.ajax
		({
	        type: "GET",
	        url: searchUrl,
		    dataType: "json",
		    success: function(response)
		    {
		     $("#hidbillRate").val(response);
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
	
	
	
	
	function funUpdatePrice(object)
	{
		var index=object.parentNode.parentNode.rowIndex;
		var Qty=document.getElementById("txtQty."+index).value;
		var price=document.getElementById("txtPrice."+index).value;
		var discount=document.getElementById("txtDiscount."+index).value;
		var ItemPrice;
		ItemPrice=(parseFloat(Qty)*parseFloat(price))-parseFloat(discount);
		
		document.getElementById("txtAmount."+index).value=parseFloat(ItemPrice);
		funGetTotal();
	}
	
	
	function funDeleteRow(obj) 
	{
	    var index = obj.parentNode.parentNode.rowIndex;
	    var table = document.getElementById("tblProdDet");
	    table.deleteRow(index);
	}
	
	function funfillDCDataRow(DCDtl,prevInvData)
	{
		var table = document.getElementById("tblProdDet");
		
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
	    var strProdCode = DCDtl.strProdCode;
		var strProdName=DCDtl.strProdName;
		var strProdType=DCDtl.strProdType;	
	    var dblQty = DCDtl.dblQty;
	    parseFloat(dblQty).toFixed(maxQuantityDecimalPlaceLimit);
	    var dblWeight=DCDtl.dblWeight;
	    var dblTotalWeight=dblQty*dblWeight;
	    
	  	var packingNo= DCDtl.strPktNo;
	    var strSerialNo = DCDtl.strSerialNo;
	    var strInvoiceable = DCDtl.strInvoiceable;
	    var strRemarks=DCDtl.strRemarks;

	    var disAmt=DCDtl.dblDisAmt;
	    var unitprice="";
	   
	    var CustCode=$("#txtCustCode").val();
	    var SOCode=$("#txtSOCode").val();
	    var precode="";
	    var preAmt="";
	    
	    if(prevInvData=="loadInvData")
	    {
	    	precode=DCDtl.prevInvCode;
	    	preAmt=DCDtl.prevUnitPrice;
	    	unitprice=DCDtl.dblUnitPrice;
	    }
	    else
	    {
	 		precode=prevInvData.strInvCode;
	 		preAmt=prevInvData.dblUnitPrice;
	 		unitprice=DCDtl.dblPrice;
		}
	   
	    var totalPrice=unitprice*dblQty;
	    var grandtotalPrice=totalPrice-disAmt;
	    row.insertCell(0).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strProdCode\" readonly=\"readonly\" class=\"Box txtProdCode\" style=\"width:99%;\" id=\"txtProdCode."+(rowCount)+"\" value='"+strProdCode+"' />";		  		   	  
	    row.insertCell(1).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strProdName\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"txtProdName."+(rowCount)+"\" value='"+strProdName+"'/>";
	    row.insertCell(2).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strProdType\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"txtProdTpye."+(rowCount)+"\" value='"+strProdType+"'/>";
	    row.insertCell(3).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblQty\" type=\"text\"  required = \"required\" style=\"text-align: right;width:99%;border:1px solid #c0c0c0;\"   class=\"decimal-places inputText-Auto  txtQty\" id=\"txtQty."+(rowCount)+"\" value="+dblQty+" onblur=\"Javacsript:funUpdatePrice(this)\">";
	    row.insertCell(4).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblWeight\" type=\"text\"  required = \"required\" style=\"text-align: right;width:99%;border:1px solid #c0c0c0;\"  class=\"decimal-places inputText-Auto\" id=\"txtWeight."+(rowCount)+"\" value="+dblWeight+" >";
	    row.insertCell(5).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblTotalWeight\" readonly=\"readonly\" class=\"Box\" style=\"text-align: right;width:99%;\"  id=\"dblTotalWeight."+(rowCount)+"\"   value='"+dblTotalWeight+"'/>";
	    row.insertCell(6).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblUnitPrice\" readonly=\"readonly\" class=\"Box txtUnitprice\" style=\"text-align: right;width:99%;\"  id=\"unitprice."+(rowCount)+"\"   value='"+unitprice+"'/>";
	    row.insertCell(7).innerHTML= "<input readonly=\"readonly\" class=\"Box totalValueCell\" style=\"text-align: right;\" \size=\"3.9%\" id=\"totalPrice."+(rowCount)+"\"   value='"+totalPrice+"'/>";
	    
	    row.insertCell(8).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblDisAmt\" readonly=\"readonly\" class=\"Box dblDisAmt\" style=\"text-align: right;width:99%;\"  id=\"dblDisAmt."+(rowCount)+"\"   value='"+disAmt+"'/>";
	    row.insertCell(9).innerHTML= "<input readonly=\"readonly\" class=\"Box grandtotalPrice\" style=\"text-align: right;\" \size=\"4.9%\" id=\"grandtotalPrice."+(rowCount)+"\"   value='"+grandtotalPrice+"'/>";
	    
	    row.insertCell(10).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strPktNo\" type=\"text\"    class=\"Box\" style=\"width:99%;border:1px solid #c0c0c0;\" id=\"txtPktNo."+(rowCount)+"\" value="+packingNo+" >";
	    row.insertCell(11).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strRemarks\" size=\"5%\" id=\"txtRemarks."+(rowCount)+"\" value='"+strRemarks+"'/>";
	    row.insertCell(12).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strInvoiceable\" readonly=\"readonly\" class=\"Box\"  style=\"width:99%;\" id=\"txtInvoiceable."+(rowCount)+"\" value="+strInvoiceable+" >";
	    row.insertCell(13).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strSerialNo\" type=\"text\"    class=\"Box\" style=\"width:99%;border:1px solid #c0c0c0;\" id=\"txtSerialNo."+(rowCount)+"\" value="+strSerialNo+" >";	    
	 	row.insertCell(14).innerHTML= '<input  class="deletebutton" value = "Delete" onClick="">';		    
	 	row.insertCell(15).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strCustCode\" type=\"text\"    class=\"Box\" style=\"width:99%;border:1px solid #c0c0c0;\" id=\"txtCustCode."+(rowCount)+"\" value="+CustCode+" >";
	 	row.insertCell(16).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strSOCode\" type=\"text\"    class=\"Box\" style=\"width:99%;border:1px solid #c0c0c0;\" id=\"txtSOCOde."+(rowCount)+"\" value="+SOCode+" >";
	 	row.insertCell(17).innerHTML= "<input readonly=\"readonly\" class=\"Box prevInCode\" style=\"text-align: right;width:99%;\"  id=\"prevInCode."+(rowCount)+"\"   value='"+precode+"'/>";
	 	row.insertCell(18).innerHTML= "<input readonly=\"readonly\" class=\"Box prevInvPrice\" style=\"text-align: right;width:99%;\"  id=\"prevInvPrice."+(rowCount)+"\"   value='"+preAmt+"'/>";
	 	
	 	$("#txtSubGroup").focus();
		funClearProduct();
		funCalculateTotalAmt();
		
		QtyTol+=dblQty;
		
		return false;
	}
	
	

	function funCallFormAction(actionName,object) 
	{
		var flg=true;
		var table = document.getElementById("tblProdDet");
		var rowCount = table.rows.length;	

		if ($("#txtCPODate").val()=="") 
		{
			alert('Invalid Date');
			$("#txtCPODate").focus();
			return false;  
		}
	
		if($("#txtSettlementType").val()=="Online Payment")
		{
	 		if($("#txtMobileNoForSettlement").val()=="")
	 		{
	 			alert('Mobile No. Not found ');
	 			return false;
	 		}
		}
	  	if(rowCount<1)
		{
			alert("Please Add Product in Grid");
			return false;
		}
		else
		{
			var clientCode='<%=session.getAttribute("clientCode").toString()%>';
			if(clientCode!='226.001')
			{
			  	var isOk=confirm("Do You Want to Settle in Cash?");
				if(isOk)
				{
					$('#cmbSettlement').val();
					$('#cmbSettlement').val("S000001");
				}else
				{
				    $('#cmbSettlement').val();
					$('#cmbSettlement').val("S000002");
				}
			}
	
			return true;
		}
	}
	
	
	function funClearProduct()
	{
		$("#txtSubGroup").val("");
		$("#txtProdName").val("");
		$("#lblUOM").text("");
		$("#lblProdName").text("");
		$("#txtQty").val("");
		$("#txtPrice").val("");
		
		$("#txtRemarks").val("");
		$("#txtWeight").val("");
// 		$("#txtDiscount").val(0);
	}
	
	function funApplyNumberValidation(){
		$(".numeric").numeric();
		$(".integer").numeric(false, function() { alert("Integers only"); this.value = ""; this.focus(); });
		$(".positive").numeric({ negative: false }, function() { alert("No negative values"); this.value = ""; this.focus(); });
		$(".positive-integer").numeric({ decimal: false, negative: false }, function() { alert("Positive integers only"); this.value = ""; this.focus(); });
	    $(".decimal-places").numeric({ decimalPlaces: maxQuantityDecimalPlaceLimit, negative: false });
	}
	function funResetFields()
	{
		location.reload(true); 
	}
	
	function funRemoveAllRows() 
    {
		 var table = document.getElementById("tblProdDet");
		 var rowCount = table.rows.length;			   
		//alert("rowCount\t"+rowCount);
		for(var i=rowCount-1;i>=0;i--)
		{
			table.deleteRow(i);						
		} 
    }
	
	function funShowSOFieled()
	{
		
		var agianst = $("#cmbAgainst").val();
		if(agianst=="Direct")
			{
			document.all["txtSOCode"].style.display = 'none';
			document.all["btnFill"].style.display = 'none'; 		
			}if(agianst=="Sales Order")
			{
				document.all["txtSOCode"].style.display = 'block';
				document.all["btnFill"].style.display = 'none'; 		
				}
			if(agianst=="Banquet")
			{
			document.all["txtSOCode"].style.display = 'block';
			document.all["btnFill"].style.display = 'block'; 		
			}
				else{
					document.all["txtSOCode"].style.display = 'block';
					document.all["btnFill"].style.display = 'block';
					}
			}
	
	
	function btnFill_onclick()
	{
		var code =$('#txtSOCode').val();
		 var  cmbAgainst=$('#cmbAgainst').val();
		 if(cmbAgainst="Delivery challan")
		if(code.toString.lenght!=0 || code==null)
			{
		
				gurl=getContextPath()+"/loadDeliveryChallanHdData.html?dcCode="+code;
				$.ajax({
			        type: "GET",
			        url: gurl,
			        dataType: "json",
			        success: function(response)
			        {		        	
			        		if('Invalid Code' == response.strSOCode){
			        			alert("Invalid Customer Code");
			        			$("#txtSOCode").val('');
			        			$("#txtSOCode").focus();
			        			
			        		}else{	
			        			funRemoveAllRows();
			        		 	$('#txtSOCode').val(code); 
// 			        			$('#txtAginst').val(response.strAgainst);
// 			        			$('#cmbAgainst').val(cmbAgainst);
// 			        			if(response.strAgainst=="Delivery Challan")
// 			        			document.all["txtSOCode"].style.display = 'block';
// 			        			document.all["btnFill"].style.display = 'block';
			        			
			        			$('#txtPONo').val(response.strPONo);
			        			$('#txtPONo').val(response.strPONo);
			        			$('#txtLocCode').val(response.strLocCode);
			        			$('#lblLocName').text(response.strLocName);
			        			$('#txtVehNo').val(response.strVehNo);
			        			$('#txtWarrPeriod').val(response.strWarrPeriod);
			        			$('#txtWarraValidity').val(response.strWarraValidity);
			        			$('#txtNarration').val(response.strNarration);
			        			$('#txtPackNo').val(response.strPackNo);
			        			$('#txtDktNo').val(response.strDktNo);
			        			$('#txtMInBy').val(response.strMInBy);
			        			$('#txtTimeOut').val(response.strTimeInOut);
			        			$('#txtReaCode').val(response.strReaCode);
 			        			
								$("#txtSODate").val(response.dteSODate);
								$("#txtCustCode").val(response.strCustCode);
								$("#lblCustomerName").text(response.strCustName);
								$("#txtSAddress1").val(response.strSAdd1);
								$("#txtSAddress2").val(response.strSAdd2);
								$("#txtSCity").val(response.strSCity);
								$("#txtSState").val(response.strSState);
								$("#txtSPin").val(response.strSPin);
								$("#txtSCountry").val(response.strSCountry);
								$("#txtSubTotlAmt").val(response.dblSubTotalAmt);
								$("#txtFinalAmt").val(response.dblTotalAmt);
								$('#cmbSettlement').val(response.strSettlementCode);
								QtyTol=0.00;
			        			$.each(response.listclsDeliveryChallanModelDtl, function(i,item)
				       	        {
					       	         funfillDCDataRow(response.listclsDeliveryChallanModelDtl[i],response.listclsInvoiceBean[i]);
				       	     	 $("#txtQtyTotl").val(QtyTol);
				       	       	});
			        			
			        		
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
		
	}
	

	$(function()
			{
				$("#txtDCCode").blur(function() 
					{
						var code=$('#txtDCCode').val();
						if(code.trim().length > 0 && code !="?" && code !="/")
						{
							funSetInvoiceData(code);
						}
					});
				
				
				$("#txtLocCode").blur(function() 
					{
						var code=$('#txtLocCode').val();
						if(code.trim().length > 0 && code !="?" && code !="/")
						{
							funSetLocation(code);
						}
					});
				
				$("#txtCustCode").blur(function() 
					{
						var code=$('#txtCustCode').val();
						if(code.trim().length > 0 && code !="?" && code !="/")
						{
							funSetCuster(code);
						}
					});
				
				$("#txtProdName").blur(function() 
					{
						var code=$('#hidProdCode').val();
						if(code.trim().length > 0 && code !="?" && code !="/")
						{
							funSetProduct(code);
						}
					});
				
				$("#txtTaxCode").blur(function() 
					{
						var code=$('#txtTaxCode').val();
						if(code.trim().length > 0 && code !="?" && code !="/")
						{
							 funSetTax(code);
						}
					});
				
				$("#txtVehCode").blur(function() 
					{
						var code=$('#txtVehCode').val();
						if(code.trim().length > 0 && code !="?" && code !="/")
						{
							funSetVehCode(code);
						}
					});
				
				$("#txtSubGroup").blur(function() 
					{
						var code=$('#hidSubGroupCode').val();
						if(code.trim().length > 0 && code !="?" && code !="/")
						{
							funSetSubGroup(code);
						}
					});
			 
				
				
			});
	
	
	/**
	 * Calculate Total Amount
	 */
	function funCalculateTotalAmt()
	{
		var totalAmt=0;
		var dblDisAmt=0;
		var table = document.getElementById("tblProdDet");
		var rowCount = table.rows.length;
		
		for(var i=0;i<rowCount;i++)
		{
			totalAmt=parseFloat(document.getElementById("totalPrice."+i).value)+totalAmt;
			dblDisAmt=parseFloat(document.getElementById("dblDisAmt."+i).value)+dblDisAmt;
		}
		
		$("#txtSubTotlAmt").val(totalAmt);
		
		var discount=(totalAmt*parseFloat($("#txtDiscountPer").val()))/100;
		dblDisAmt=dblDisAmt+parseFloat(discount);
		$("#txtDiscount").val(dblDisAmt);
		var disc=$("#txtDiscount").val();
		var finalAmt=totalAmt-disc;
		$("#txtFinalAmt").val(finalAmt);
	}
	
	
	
	/**
	 * Ready Function for Tax
	 */
	$(function()
	{
		$("#btnAddTax").click(function()
		{
			if($("#txtTaxCode").val()=='')
		    {
				alert("Please Enter Tax Code");
		   		$("#txtTaxCode").focus();
		       	return false;
			}
			else
			{
				funAddTaxRow();
			}
		});
		
		$("#btnGenTax").click(function()
		{
			
 			funCalculateIndicatorTax();
		});
		
		$('#txtTaxableAmt').blur(function () 
		{
			funCalculateTaxForSubTotal(parseFloat($("#txtTaxableAmt").val()),taxPer);
		});
	});
	
	
	
	/**
	 * Calculating Tax per Tax indicator 
	 */
	function funCalculateIndicatorTax()
	{
		var prodCodeForTax="";
		funRemoveTaxRows();
		var table = document.getElementById("tblProdDet");
	    var rowCount = table.rows.length;
		var currValue='<%=session.getAttribute("currValue").toString()%>';
		if(currValue==null)
		{
		  currValue=1;
		}
	    var cnt=0;
	    for(var cnt=0;cnt<rowCount;cnt++)
	    {
	    	
// 	    	var prodCode= $(this).find(".txtProdCode").val();
	    	var prodCode=document.getElementById("txtProdCode."+cnt).value
	    	var discAmt=0;
	    	var suppCode=$("#txtCustCode").val();
         	var discPer=0;
	    	if($("#txtDiscPer").val()!='')
	    	{	
	    		discPer=parseFloat($("#txtDiscPer").val());
	    		discAmt=(taxableAmount*discPer)/100
	    	}
 	    	var vari=document.getElementById("totalPrice." + cnt).value;
			//var taxableAmount= parseFloat($(this).find(".totalValueCell").val());
			var taxableAmount=parseFloat(vari);
			
	    	var discAmt=(taxableAmount*discPer)/100;
// 	    	taxableAmount=taxableAmount-discAmt;
	    	
	    	var qty=parseFloat(document.getElementById("txtQty."+cnt).value);		    	
	    	var unitPrice=parseFloat(document.getElementById("unitprice."+cnt).value)/currValue;
	    	var discAmt1=parseFloat(document.getElementById("txtDiscount").value);
	    
	    	prodCodeForTax=prodCodeForTax+"!"+prodCode+","+unitPrice+","+suppCode+","+qty+","+0;
	    }
		
	    prodCodeForTax=prodCodeForTax.substring(1,prodCodeForTax.length).trim();
	    forTax(prodCodeForTax);
	}
	
	
	function forTax(prodCodeForTax)
	{
		var dteInv =$('#txtDCDate').val();
		var CIFAmt=0;
		var settlement='';
	    gurl=getContextPath()+"/getTaxDtlForProduct.html?prodCode="+prodCodeForTax+"&taxType=Banquet&transDate="+dteInv+"&CIFAmt="+CIFAmt+"&strSettlement="+settlement,
	    $.ajax({
			type: "GET",
		    url:gurl,
			dataType: "json",
		    success: function(response)
		    {
		       	$.each(response, function(i,item)
			    {
		       		var spItem=item.split('#');
		       		if(spItem[1]=='null')
		       		{
		       		}
		       		else
			    	{
		       			var dblExtraCharge="0.0";
		       			var taxableAmt=parseFloat(spItem[0]);
		        		var taxCode=spItem[1];
			        	var taxDesc=spItem[2];
			        	var taxPer1=parseFloat(spItem[4]);
			        	var taxAmt=parseFloat(spItem[5]);
			        	taxAmt=taxAmt.toFixed(2);
			        	taxableAmt=taxableAmt.toFixed(2);
			        	funAddTaxRow1(taxCode,taxDesc,taxableAmt,taxAmt);
			    	}
			    });
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
	
	/**
	 * Calculating Tax subtotal amount
	 */
	function funCalculateTaxForSubTotal(taxableAmt,taxPercent)
	{
		var taxAmt=(taxableAmt*taxPercent/100);
		taxAmt=taxAmt.toFixed(2);
		$("#txtTaxAmt").val(taxAmt);
	}
	
	/**
	 * Remove all tax form grid 
	 */
	function funRemoveTaxRows()
	{
		var table = document.getElementById("tblTax");
		var rowCount = table.rows.length;
		while(rowCount>0)
		{
			table.deleteRow(0);
			rowCount--;
		}
	}
	
	/**
	 * Filling Tax in Grid
	 */
	function funAddTaxRow1(taxCode,taxDesc,taxableAmt,taxAmt) 
	{	
	    var table = document.getElementById("tblTax");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
	    row.insertCell(0).innerHTML= "<input class=\"Box\" style=\"width:99%;\" name=\"listInvoiceTaxDtl["+(rowCount)+"].strTaxCode\" id=\"txtTaxCode."+(rowCount)+"\" value='"+taxCode+"' >";
	    row.insertCell(1).innerHTML= "<input class=\"Box\" style=\"width:99%;\" name=\"listInvoiceTaxDtl["+(rowCount)+"].strTaxDesc\" id=\"txtTaxDesc."+(rowCount)+"\" value='"+taxDesc+"'>";		    	    
	    row.insertCell(2).innerHTML= "<input type=\"number\" step=\"any\" required = \"required\" style=\"text-align: right; width:99%; border:1px solid #a2a2a2;padding:1px;\" name=\"listInvoiceTaxDtl["+(rowCount)+"].strTaxableAmt\" id=\"txtTaxableAmt."+(rowCount)+"\" value="+taxableAmt+">";
	    row.insertCell(3).innerHTML= "<input type=\"number\" step=\"any\" required = \"required\" style=\"text-align: right; width:99%; border:1px solid #a2a2a2;padding:1px;\" name=\"listInvoiceTaxDtl["+(rowCount)+"].strTaxAmt\" id=\"txtTaxAmt."+(rowCount)+"\" value="+taxAmt+">";		    
	    row.insertCell(4).innerHTML= '<input type="button" size=\"6%\" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteTaxRow(this)" >';
	    funCalTaxTotal();
	    funClearFieldsOnTaxTab();
	    
	    return false;
	}
	
	/**
	 * Delete a particular tax form grid
	 */
	function funDeleteTaxRow(obj) 
	{
	    var index = obj.parentNode.parentNode.rowIndex;
	    var table = document.getElementById("tblTax");
		table.deleteRow(index);
		funCalTaxTotal();
	}
	
	/**
	 * Calculating Total Tax 
	 */
	function funCalTaxTotal()
	{
		var totalTaxAmt=0,totalTaxableAmt=0;
		var table = document.getElementById("tblTax");
		var rowCount = table.rows.length;
		var subTotal=parseFloat($("#txtSubTotlAmt").val());
		for(var i=0;i<rowCount;i++)
		{
			totalTaxableAmt=parseFloat(document.getElementById("txtTaxableAmt."+i).value)+totalTaxableAmt;
			totalTaxAmt=parseFloat(document.getElementById("txtTaxAmt."+i).value)+totalTaxAmt;
		}
		
		totalTaxableAmt=totalTaxableAmt.toFixed(2);
		totalTaxAmt=totalTaxAmt.toFixed(2);
		var grandTotal=parseFloat(subTotal)+parseFloat(totalTaxAmt);
		grandTotal=grandTotal.toFixed(2);
		$("#lblTaxableAmt").text(totalTaxableAmt);
		$("#lblTaxTotal").text(totalTaxAmt);
		$("#txtPOTaxAmt").val(totalTaxAmt);
// 		$("#lblPOGrandTotal").text(grandTotal);
// 		var taxAmt=$("#txtPOTaxAmt").val();
		var disAmt = $('#txtDiscount').val();
	//	var extCharge = $('#txtExtraCharges').val();
		var finalAmt=parseFloat(subTotal)+parseFloat(totalTaxAmt)-disAmt;
		$("#txtFinalAmt").val(finalAmt);
	}
	
		/**
		 * Reset Tax field
		 */
		function funClearFieldsOnTaxTab()
		{
			$("#txtTaxCode").val("");
			$("#lblTaxDesc").text("");
			$("#txtTaxableAmt").val("");
			$("#txtTaxAmt").val("");
			$("#txtTaxCode").focus();
		
		}
		function funAddTaxRow() 
		{
			var taxCode = $("#txtTaxCode").val();
			var taxDesc=$("#lblTaxDesc").text();
		    var taxableAmt = $("#txtTaxableAmt").val();
		    var taxAmt=$("#txtTaxAmt").val();
		    var table = document.getElementById("tblTax");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    row.insertCell(0).innerHTML= "<input class=\"Box\" style=\"width:99%;\" name=\"listInvoiceTaxDtl["+(rowCount)+"].strTaxCode\" id=\"txtTaxCode."+(rowCount)+"\" value='"+taxCode+"' >";
		    row.insertCell(1).innerHTML= "<input class=\"Box\" style=\"width:99%;\" name=\"listInvoiceTaxDtl["+(rowCount)+"].strTaxDesc\" id=\"txtTaxDesc."+(rowCount)+"\" value='"+taxDesc+"'>";		    	    
		    row.insertCell(2).innerHTML= "<input type=\"number\" step=\"any\" required = \"required\" style=\"text-align: right; width:99%; border:1px solid #a2a2a2;padding:1px;\" name=\"listInvoiceTaxDtl["+(rowCount)+"].strTaxableAmt\" id=\"txtTaxableAmt."+(rowCount)+"\" value="+taxableAmt+">";
		    row.insertCell(3).innerHTML= "<input type=\"number\" step=\"any\" required = \"required\" style=\"text-align: right; width:99%; border:1px solid #a2a2a2;padding:1px;\" name=\"listInvoiceTaxDtl["+(rowCount)+"].strTaxAmt\" id=\"txtTaxAmt."+(rowCount)+"\" value="+taxAmt+">";		    
		    row.insertCell(4).innerHTML= '<input type="button" size=\"6%\" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteTaxRow(this)" >';
		    funCalTaxTotal();
		    funClearFieldsOnTaxTab();
		    return false;
		}
	
		
		function funSetVehCode(code){

			$.ajax({
				type : "GET",
				url : getContextPath()+ "/LoadVehicleMaster.html?docCode=" + code,
				dataType : "json",
				success : function(response){ 
					
					if('Invalid Code' == response.strVehCode){
	        			alert("Invalid Vehicle Code");
	        			$("#txtVehCode").val('');
	        			$("#txtVehCode").focus();
	        		}else{
	        			$("#txtVehNo").val(response.strVehNo);
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
	
		
		
		//Open Against Form


		function funOpenAgainst() 
		{
			if ($("#cmbAgainst").val() == "Sales Order") 
			{
				if($("#txtLocCode").val()=="")
				{
					alert("Please Enter LocationCode");
					$("#txtLocCode").focus();
					return false;
				}
				if($("#txtCustCode").val()=="")
				{
					alert("Please Customer");
					$("#txtCustCode").focus();
					return false;
				}
				if ($("#txtSODate").val()=="") 
			    {
				 	alert('Invalid Date');
				 	$("#txtSODate").focus();
				 	return false;  
			    }
				var date = $('#txtDCDate').val();
				var array = new Array();
			//split string and store it into array
				array = date.split('-');

			//from array concatenate into new date string format: "DD.MM.YYYY"
				var dtFullfilled = (array[2] + "-" + array[1] + "-" + array[0]);
				var locCode = $('#txtLocCode').val();
				var custCode = $('#txtCustCode').val();
				funOpenInvoiceHelp(locCode,dtFullfilled,custCode);
				return false;
			} else if ($("#cmbAgainst").val() == "Banquet") 
			{
				if($("#txtCustCode").val()=="")
				{
					alert("Please Customer");
					$("#txtCustCode").focus();
					return false;
				}
				var date = $('#txtDCDate').val();
				var array = new Array();
			
				array = date.split('-');

			
				var dtFullfilled = (array[2] + "-" + array[1] + "-" + array[0]);
				var locCode = $('#txtLocCode').val();
				var custCode = $('#txtCustCode').val();
				funOpenInvoiceHelpForBanquet(locCode,dtFullfilled,custCode);
				return false;
			}
			
			else{
				funHelp('deliveryChallan');
			}
		}
		// Against  From and Set  Code in combo box
		
		 function funOpenInvoiceHelpForBanquet(locCode,dtFullfilled,custCode) {

			var retval = window.open("frmInvoiceSale.html?strlocCode="+locCode+"&dtFullFilled="+dtFullfilled+"&strCustCode="+custCode,"",
					"dialogHeight:600px;dialogWidth:500px;dialogLeft:400px;");
				
			var timer = setInterval(function ()
			    {
				if(retval.closed)
					{
						if (retval.returnValue != null)
						{
							strVal = retval.returnValue.split("#")
							$("#txtSOCode").val(strVal[0]);
							funRemRows();
							funSetSalesOrderDtl();
							var SOCodes=strVal[0].split(",");
						}
						clearInterval(timer);
					}
			    }, 500);						
		}
		//Open Against  From and Set  Code in combo box
		function funOpenInvoiceHelp(locCode,dtFullfilled,custCode) {

			var retval = window.open("frmInvoiceSale.html?strlocCode="+locCode+"&dtFullFilled="+dtFullfilled+"&strCustCode="+custCode,"",
					"dialogHeight:600px;dialogWidth:500px;dialogLeft:400px;");
				
			var timer = setInterval(function ()
			    {
				if(retval.closed)
					{
						if (retval.returnValue != null)
						{
							strVal = retval.returnValue.split("#")
							$("#txtSOCode").val(strVal[0]);
							funRemRows();
							funSetSalesOrderDtl();
							var SOCodes=strVal[0].split(",");
						}
						clearInterval(timer);
					}
			    }, 500);
			
		}
		function funRemRows() {
			var table = document.getElementById("tblProdDet");
			var rowCount = table.rows.length;

			while(rowCount>0)
			{
				table.deleteRow(0);
				rowCount--;
			}
		}
		
		
		function funSetSalesOrderTaxDtl()
		{
			if(bookingNO!=null)
				{
					strCodes = bookingNO;
				}
			else
				{
					strCodes = $('#txtSOCode').val();
				 	strSOCodes = strCodes.split(",")
				}
		    
						
			var searchUrl=getContextPath()+ "/loadSOTaxDtlforInvoice.html?SOCode=" + strCodes ;
			$.ajax({
				type: "GET",
				url: searchUrl,
				dataType: "json",
				success: function(response)
				{
					$.each(response, function(cnt,item)
					{
			    		funAddTaxRow1(response[cnt][0], response[cnt][1], response[cnt][2], response[cnt][3]);
					});
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
		
		function funSetSalesOrderDtl()
		{	
			strCodes = $('#txtSOCode').val();
			strSOCodes = strCodes.split(",")
		   	var searchUrl=getContextPath()+ "/loadAgainstSOForInvoice.html?SOCode=" + strCodes ;
			$.ajax({
				type: "GET",
				url: searchUrl,
				dataType: "json",
				async:false,
				success: function(response)
				{	
					QtyTol=0.00;				    	
					$.each(response, function(cnt,item)
					{
			    		funfillProdRow(response[cnt].strProdCode,response[cnt].strProdName,response[cnt].dblUnitPrice,response[cnt].dblAcceptQty
					   		,response[cnt].dblWeight,"",response[cnt].strCustCode,response[cnt].strSOCode,response[cnt].PrevUnitPrice
					   		,response[cnt].PrevInvCode,response[cnt].dblDiscount);
			    		 $("#txtQtyTotl").val(QtyTol);
					});
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
			
			funSetSalesOrderTaxDtl();
		}
		
		
		
		/**
		 * Filling Grid
		 */
		 function funfillProdRow(strProdCode, strProdName, dblUnitPrice, dblAcceptQty,dblWeight, strSpCode,strCustCode,strSOCode
			,prevUnitPrice,prevInvCode,disAmt) {

			var table = document.getElementById("tblProdDet");
			var rowCount = table.rows.length;
			var row = table.insertRow(rowCount);
				
			
			dblUnitPrice=parseFloat(dblUnitPrice).toFixed(maxAmountDecimalPlaceLimit);
			dblWeight=parseFloat(dblWeight).toFixed(maxQuantityDecimalPlaceLimit);
				
			var dblTotalPrice = parseFloat(dblAcceptQty).toFixed(maxQuantityDecimalPlaceLimit) * dblUnitPrice;
			dblTotalPrice=parseFloat(dblTotalPrice).toFixed(maxAmountDecimalPlaceLimit);
			var strProdType="";	
				 
			dblAcceptQty=parseFloat(dblAcceptQty).toFixed(maxQuantityDecimalPlaceLimit);
			var dblTotalWeight=dblAcceptQty*dblWeight;
			var packingNo= $("#txtPackingNo").val();
			var strSerialNo = $("#txtSerialNo").val();
			var strInvoiceable = $("#cmbInvoiceable").val();
			var strRemarks=$("#txtRemarks").val();
			var grandtotalPrice=dblTotalPrice-disAmt;
			
			row.insertCell(0).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strProdCode\" readonly=\"readonly\" class=\"Box txtProdCode\" style=\"width:99%;\" id=\"txtProdCode."+(rowCount)+"\" value='"+strProdCode+"' />";		  		   	  
			row.insertCell(1).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strProdName\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"txtProdName."+(rowCount)+"\" value='"+strProdName+"'/>";
			row.insertCell(2).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strProdType\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"txtProdTpye."+(rowCount)+"\" value='"+strProdType+"'/>";
			row.insertCell(3).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblQty\" type=\"text\"  required = \"required\" style=\"text-align: right;width:99%;border:1px solid #c0c0c0;\"   class=\"decimal-places inputText-Auto  txtQty\" id=\"txtQty."+(rowCount)+"\" value="+dblAcceptQty+" onblur=\"Javacsript:funUpdatePrice(this)\">";
			row.insertCell(4).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblWeight\" type=\"text\"  required = \"required\" style=\"text-align: right;width:99%;border:1px solid #c0c0c0;\"  class=\"decimal-places inputText-Auto\" id=\"txtWeight."+(rowCount)+"\" value="+dblWeight+" >";
			row.insertCell(5).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblTotalWeight\" readonly=\"readonly\" class=\"Box\" style=\"text-align: right;width:99%;\"  id=\"dblTotalWeight."+(rowCount)+"\"   value='"+dblTotalWeight+"'/>";
			row.insertCell(6).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblUnitPrice\" readonly=\"readonly\" class=\"Box txtUnitprice\" style=\"text-align: right;width:99%;\"  id=\"unitprice."+(rowCount)+"\"   value='"+dblUnitPrice+"'/>";
			row.insertCell(7).innerHTML= "<input readonly=\"readonly\" class=\"Box totalValueCell\" style=\"text-align: right;width:99%;\"  id=\"totalPrice."+(rowCount)+"\"   value='"+dblTotalPrice+"'/>";
			row.insertCell(8).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblDisAmt\" readonly=\"readonly\" class=\"Box dblDisAmt\" style=\"text-align: right;width:99%;\"  id=\"dblDisAmt."+(rowCount)+"\"   value='"+disAmt+"'/>";
			row.insertCell(9).innerHTML= "<input readonly=\"readonly\" class=\"Box grandtotalPrice\" style=\"text-align: right;width:99%;\"  id=\"grandtotalPrice."+(rowCount)+"\"   value='"+grandtotalPrice+"'/>";
				    
			row.insertCell(10).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strPktNo\" type=\"text\"    class=\"Box\" style=\"width:99%;border:1px solid #c0c0c0;\" id=\"txtPktNo."+(rowCount)+"\" value="+packingNo+" >";
			row.insertCell(11).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strRemarks\" style=\"width:99%;\" id=\"txtRemarks."+(rowCount)+"\" value='"+strRemarks+"'/>";
			row.insertCell(12).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strInvoiceable\" readonly=\"readonly\" class=\"Box\"  style=\"width:99%;\" id=\"txtInvoiceable."+(rowCount)+"\" value="+strInvoiceable+" >";
			row.insertCell(13).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strSerialNo\" type=\"text\"    class=\"Box\" style=\"width:99%;border:1px solid #c0c0c0;\" id=\"txtSerialNo."+(rowCount)+"\" value="+strSerialNo+" >";	    
			row.insertCell(14).innerHTML= '<input  class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRow(this)">';		    
			row.insertCell(15).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strCustCode\" type=\"text\"    class=\"Box\" style=\"width:99%;border:1px solid #c0c0c0;\" id=\"txtCustCode."+(rowCount)+"\" value="+strCustCode+" >";
			row.insertCell(16).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strSOCode\" type=\"text\"    class=\"Box\" style=\"width:99%;border:1px solid #c0c0c0;\" id=\"txtSOCOde."+(rowCount)+"\" value="+strSOCode+" >";
			row.insertCell(17).innerHTML= "<input readonly=\"readonly\" class=\"Box prevInvCode\" style=\"text-align: right;width:99%;\"  id=\"prevInvCode."+(rowCount)+"\"   value=''/>";
			row.insertCell(18).innerHTML= "<input readonly=\"readonly\" class=\"Box prevUnitPrice\" style=\"text-align: right;width:99%;\"  id=\"prevUnitPrice."+(rowCount)+"\"   value=''/>";
				 	
			QtyTol+=parseFloat(dblAcceptQty);
			$("#txtSubGroup").focus();
			funCalculateTotalAmt();
			funClearProduct();
			
			return false;
		}
		
	
		function btnUpdate_onclick()
		{
			var strProdCode=$("#hidProdCode").val();
			if(funDuplicateProductForUpdate(strProdCode))
				{
				 funUpdateProductDtl(strProdCode);
				}else
				{
					 alert("Product Not Found !");
				}
		}
		
		function funUpdateProductDtl(strProdCode)
		{
		    var table = document.getElementById("tblProdDet");
		    var rowCount = table.rows.length;		   
		    var flag=true;
		    if(rowCount > 0)
		    	{
				    $('#tblProdDet tr').each(function()
				    {
					    if(strProdCode==$(this).find('input').val())// `this` is TR DOM element
	    				{
					    	var qty= $('#txtQty').val();
					    	qty=parseFloat(qty);
					    	if(qty>0)
					    		{
					    		    var txtFinalAmt=$('#txtFinalAmt').val();
					    		    txtFinalAmt = parseFloat(txtFinalAmt);
					    		    var txtSubTotlAmt=$('#txtSubTotlAmt').val();
					    		    txtSubTotlAmt = parseFloat(txtSubTotlAmt);
					    		    
					    		    var oldProdValue=$(this).closest("tr").find(".totalValueCell").val();
					    		    oldProdValue = parseFloat(oldProdValue);
					    		    txtFinalAmt = txtFinalAmt-oldProdValue;
					    		    txtSubTotlAmt = txtSubTotlAmt-oldProdValue;
					    		    
					    		    
							    	$(this).closest("tr").find(".txtQty").val(qty);  
							    	var untiprice =$(this).closest("tr").find(".txtUnitprice").val();
							    	untiprice = parseFloat(untiprice).toFixed(maxQuantityDecimalPlaceLimit);
							    	var total= qty*untiprice;
							    	$(this).closest("tr").find(".totalValueCell").val(total);
							    	
							    	 txtFinalAmt = txtFinalAmt + qty*untiprice;
							    	 txtSubTotlAmt = txtSubTotlAmt + qty*untiprice;
							    	 $('#txtFinalAmt').val(txtFinalAmt);
							    	 $('#txtSubTotlAmt').val(txtSubTotlAmt);
					    		}
	    				}
					});
				    
		    	}
		    return flag;
		}
		
		
	function funDuplicateProductForUpdate(strProdCode)
		{
		 var table = document.getElementById("tblProdDet");
		    var rowCount = table.rows.length;		   
		    var flag=false;
		    if(rowCount > 0)
		    	{
				    $('#tblProdDet tr').each(function()
				    {
					    if(strProdCode==$(this).find('input').val())// `this` is TR DOM element
	    				{
					    	flag=true; 
					    	
		    			
	    				}
					});
				    
		    	}
		    return flag;
		}
		
	$(document).ready(function()
			{
				$(function() {
					
					$("#txtSubGroup").autocomplete({
					source: function(request, response)
					{
						var searchUrl=getContextPath()+"/AutoCompletGetSubgroupNameForInv.html";
						$.ajax({
						url: searchUrl,
						type: "POST",
						data: { term: request.term },
						dataType: "json",
						 
							success: function(data) 
							{
								sgData=data;
								response($.map(data, function(v,i)
								{
								//	$('#hidSubGroupCode').val(   );
									return {
										label: v.strSGName,
										value: v.strSGName
										
										};
										
										
								}));
								
							}
						});
					},
					minLength: 0,
				    minChars: 0,
				    max: 12,
				    autoFill: true,
				    mustMatch: true,
				    matchContains: false,
				    scrollHeight: 220,
				}).on('focus', function(event) {
				    var self = this;
					  //  var sgName= $("#txtSubGroup").val();
					    $(self).autocomplete( "search", '');
					});					 
				});
			});
		
function funGetKeyCode(event,controller) {
		
	    var key = event.keyCode;
	    
	    if(controller=='Settlement' && key==13 || controller=='Settlement' && key==9)
	    {
	    	$('#txtSubGroup').focus();
	    }
	    
	    
	    if(controller=='SubGroup' && key==13 || controller=='SubGroup' && key==9)
	    {
	    	$.each(sgData, function(i,item)
			    	{
				var sgName = $("#txtSubGroup").val();
						if(sgName==item.strSGName)
							{
							$('#hidSubGroupCode').val(item.strSGCode);
							$('#txtProdName').focus();
							
							}
			    	});
	    	
	    }
	    
	    if(controller=='Product' && key==13 || controller=='Product' && key==9)
	    {
	    
	    	var custCode = $("#txtCustCode").val();
	    	var prodName = $("#txtProdName").val();
	    	funSetProduct(prodName);
	 	    	
	    		}
	    
	  
	   
		    if(controller=='Qty' && key==13 || controller=='Qty' && key==9)
		    {
		    	$('#btnAdd').focus();
		    }
		    
		    if(controller=='AddBtn' && key==13)
		    {
			    	if($("#txtQty").val().trim().length==0 || $("#txtQty").val()== 0)
			        {		
			          alert("Please Enter Quantity");
			          $("#txtQty").focus();
			          return false;
			       	}else{
				    	funAddProductRow();
				    	$("#txtSubGroup").focus();
		    }
	    }
	}

function funChangeCombo() {
	$("#txtSubGroup").focus();
	}
	
$(document).keypress(function(e) {
	  if(e.keyCode == 120) {
		  if(funCallFormAction())
			  {
			  var isOk=confirm("Do You Want to Settle in Cash?");
				if(isOk)
				{
						$('#cmbSettlement').val();
						$('#cmbSettlement').val("S000001");
						document.forms["InvForm"].submit();
				}else
					{
					    $('#cmbSettlement').val();
						$('#cmbSettlement').val("S000002");
						document.forms["InvForm"].submit();
					}
			   }
		 
	  }
	});
	
function funGetProductStock(strProdCode)
{
	var searchUrl="";	
	var locCode=$("#txtLocCode").val();
	var dblStock="0";
	var strInvDate=$("#txtDCDate").val();
	strInvDate=strInvDate.split("-")[2]+"-"+strInvDate.split("-")[1]+"-"+strInvDate.split("-")[0];
	searchUrl=getContextPath()+"/getProductStockInUOM.html?prodCode="+strProdCode+"&locCode="+locCode+"&strTransDate="+strInvDate+"&strUOM=RecUOM";
	//alert(searchUrl);		
	$.ajax({
	        type: "GET",
	        url: searchUrl,
		    dataType: "json",
		    async: false,
		    success: function(response)
		    {
		    	dblStock= response;
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
	return Math.round(dblStock * 100) / 100;
}
	
	
function funSetTax(code)
{
	$.ajax({
	   		type: "GET",
	        url: getContextPath()+"/loadTaxMasterData.html?taxCode="+code,
	        dataType: "json",
	        success: function(response)
	        {
	         	var currValue='<%=session.getAttribute("currValue").toString()%>';
	    		if(currValue==null)
	    		{
	    		  currValue=1;
	    		}
	        	taxOnTax='N';
	        	$("#txtTaxCode").val(code);
	        	$("#lblTaxDesc").text(response.strTaxDesc);
	        	$("#txtTaxableAmt").val($("#txtSubTotlAmt").val()/currValue);
	        	$("#txtTaxableAmt").focus();
	        	taxPer=parseFloat(response.dblPercent);
	        	funCalculateTaxForSubTotal(parseFloat($("#txtTaxableAmt").val()),taxPer);
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
	function funCalculateDiscount()
	{
		
		
	}
	
function funChangeCombo() {
		
		// Ajax call loadSettlementMasterData  --> pass settlement code
		var code=$("#cmbSettlement").val();
		var searchurl=getContextPath()+"/loadSettlementMasterData.html?code="+code;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strSettlementCode=='Invalid Code')
			        	{
			        		alert("Settlement type not found");
			        	}
			        	else
			        	{
				        	$("#txtSettlementType").val(response.strSettlementType);
				        	//alert($("#txtSettlementType").val());
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
</head>
<body >
	<div class="container transTable">
		<label id="formHeading">ProForma Invoice</label>
	    <s:form name="InvForm" method="POST" action="saveProFormaInvoice.html?saddr=${urlHits}">
		<input type="hidden" value="${urlHits}" name="saddr">
		<input type="hidden" id="authorizePer" value="${authorizePer}">
		<br>
		<div id="tab_container" style="margin-bottom: 35px;">
						<ul class="tabs">
							<li class="active" data-state="tab1">Invoice</li>
							<li data-state="tab2">Address</li>
							<li data-state="tab3">Taxes</li>
						</ul>

		<div id="tab1" class="tab_content" style="margin-top: 50px;">
						
							<!-- 	<tr>
									<th align="right" colspan="9"><a id="baseUrl" href="#">
											Attach Documents </a></th>
								</tr> -->

		   <div class="row">
		
				<div class="col-md-2"><label>Invoice Code</label>
					 <s:input path="strInvCode" id="txtDCCode" ondblclick="funHelp('proformaInvoice')" cssClass="searchTextBox" />
				</div>

				<div class="col-md-2"><label>Invoice Date</label>
					 <s:input path="dteInvDate" id="txtDCDate" required="required" readonly="true" cssClass="calenderTextBox" style="width:70%"/>
				</div>
				<div class="col-md-8"></div>
				
				<div class="col-md-2"><label>Against</label>
					 <s:select id="cmbAgainst" path="strAgainst" items="${againstList}" onchange="funShowSOFieled()" style="width:auto;"/>
				</div>
				
				<div class="col-md-2"><s:input id="txtSOCode" path="strSOCode" ondblclick="funOpenAgainst()" style="display:none;margin-top: 26px;" class="searchTextBox"></s:input>
				</div>
				
				<div class="col-md-1"><input type="Button" id="btnFill" value="Fill" onclick="return btnFill_onclick()" style="display:none; margin-top: 26px;" class="btn btn-primary center-block" />
				</div>

				<div class="col-md-2"><label>Date</label>
						<s:input path="" id="txtAginst" cssClass="calenderTextBox" style="width:70%"/>
				</div>
                 <div class="col-md-4"></div>
                 
				<div class="col-md-2"><label>Customer Code</label>
						<s:input path="strCustCode" id="txtCustCode" ondblclick="funHelp('custMasterActive')" cssClass="searchTextBox" />
				</div>
				
				<div class="col-md-2"><label id="lblCustomerName" class="namelabel" style="background-color:#dcdada94; width: 100%; height: 50%; margin-top: 17%;padding:2px;"></label>
				</div>

				<div class="col-md-2"><label>PO NO</label>
					 <s:input id="txtPONo" type="text" path="strPONo"/>
				</div>
                <div class="col-md-6"></div>
                
				<div class="col-md-2"><label>Location Code</label>
					<s:input type="text" id="txtLocCode" path="strLocCode" cssClass="searchTextBox" readonly="true"/>
			    </div>
			    
				<div class="col-md-2"><label id="lblLocName" style="background-color:#dcdada94; width: 100%; height: 50%; margin-top: 17%;padding:2px;"></label>
			   </div>

				<div class="col-md-2"><label>Vehicle No</label>
					<s:input id="txtVehNo" type="text" path="strVehNo" cssClass="searchTextBox" ondblclick="funHelp('VehCode');" />
				</div>
				<div class="col-md-6">	</div>
						
				<div class="col-md-2"><label>Settlement</label>
					<s:select id="cmbSettlement" path="strSettlementCode" items="${settlementList}"
							onkeypress="funGetKeyCode(event,'Settlement')" onclick="funChangeCombo()" />
				</div>
								
				<div class="col-md-2"><label>Warrenty Start Date</label>
					<s:input path="strWarrPeriod" id="txtWarrPeriod" cssClass="calenderTextBox" style="width:70%"/>
				</div>

				<div class="col-md-2"><label>Warranty Validity</label>
					<s:input path="strWarraValidity" id="txtWarraValidity" cssClass="calenderTextBox" style="width:70%"/>
				</div>
				<div class="col-md-6">	</div>
							
				<div class="col-md-2"><label>Mobile No.</label>
						<s:input  type="text"  id="txtMobileNoForSettlement" name="txtMobileNoForSettlement" path="strMobileNoForSettlement" class="numeric"/>
				</div>
									
				<div class="col-md-2"><input type="hidden" id="txtSettlementType"> 
				</div>
				<div class="col-md-8">	</div>
							
				<div class="col-md-2"><label for="a">Sub-Group</label>
					<input id="txtSubGroup" style="width:80%;text-transform: uppercase;"  name="SubgroupName" class="searchTextBox" 
						onkeypress="funGetKeyCode(event,'SubGroup')" ondblclick="funHelp('subgroup')"/>
				</div>
				
				<div class="col-md-2"><input type="hidden" id="hidSubGroupCode"/></div>
				
				<div class="col-md-2"><label>Product</label>
					<input id="txtProdName" class="searchTextBox" onkeypress="funGetKeyCode(event,'Product')" ondblclick="funHelp('productProduced')" />
				</div>
				
				<div class="col-md-2"><input type="hidden" id="hidProdCode"/></div>	
				
				<div class="col-md-2"><label>Batch No</label>
					<s:input id="txtSerialNo" path="strSerialNo" type="text"/>
				</div>
			    <div class="col-md-2"></div>
			    
				<div class="col-md-2"><label>Purchase price</label>
					<input id="txtPurchasePrice" readonly="readonly" type="text" step="any" class="decimal-places numberField" />
			    </div>
			    
				<div class="col-md-2"><label>Sale price</label>
					<input id="hidUnitPrice"  type="text" step="any" class="decimal-places numberField" />
				</div>
				
				<div class="col-md-2"><label>Stock</label>
				   <label id="spStock" class="namelabel"></label><span id="spStockUOM"></span>
				</div>
				<div class="col-md-6">	</div>
				
				<div class="col-md-2"><label>Wt/Unit</label>
					<input type="text" id="txtWeight" step="any" class="decimal-places numberField" />
				</div>
				
				<div class="col-md-2"><label>Quantity</label>
					<input id="txtQty" type="text" step="any" class="decimal-places numberField" style="width: 60%" onkeypress="funGetKeyCode(event,'AddBtn')" />	
					<label id="lblUOM"></label>
			   </div>
 								
				<div class="col-md-2"><label>Invoiceable</label>
						<s:select id="cmbInvoiceable" name="cmbInvoiceable" path="" style="width:auto">
							<option value="N">No</option>
							<option value="Y">Yes</option>
						</s:select>
				</div>
				<div class="col-md-6"></div>
								
				<div class="col-md-2"><label>Packing No</label>
						<input id="txtPackingNo" type="text"/>
				</div>

				<div class="col-md-2"><label>Remarks</label>
						<input id="txtRemarks" type="text" />
				</div>
				
				<div class="col-md-2"><label>Discount %</label>
					  <input type="text" id="txtProdDisper" value="0" class="decimal-places-amt numberField"/>
				</div>
				
				<div class="col-md-1"><br><input type="button" value="Add" class="btn btn-primary center-block" 
				         class="smallButton" onclick="return btnAdd_onclick()" />
				</div>
				
				<div class="col-md-1"><br><input type="button" value="Update" class="btn btn-primary center-block" 
		                 class="smallButton" onclick="return btnUpdate_onclick()" />
				</div>	
			</div>
						
			<div class="dynamicTableContainer" style="height: 300px; ">
					<table style="width: 150%; border: #0F0; table-layout: fixed;" class="transTablex col15-center">
						<tr bgcolor="#c0c0c0">
										<td width="7%">Product Code</td>
										<!--  COl1   -->
										<td width="11.5%">Product  Name</td>
										<!--  COl2   -->
										<td width="5%"></td> 
										<!--  COl3   -->
										<td width="4%">Qty</td>
										<!--  COl4   -->
									  	<td width="5%">Wt/Unit</td> 
										<!-- COl5   -->
										<td width="3%">Total Wt</td> 
										<!-- COl6   -->
 										<td width="4%">Unit Price</td> 
										<!--  COl7   -->
										<td width="5%">Total Amt</td>
										<!--  COl8   -->
										<!-- COl6   -->
 										<td width="3%">Disc Amt</td> 
										<!--  COl7   -->
										<td width="5%"> Grand Amt</td>
										<!--  COl8   -->
									   <td width="4.5%">Packing No</td>
										<!--  COl9   -->
										<td width="5%">Remarks</td>
										<!--COl10   -->
										<td width="4.5%">Invoice</td> 
										<!--  COl11   -->
										<td width="4.3%">Serial No</td>
										<!-- COl12   -->
										<td width="4.5%">Delete</td> 
										<!--  COl13   -->
                                        <td width="8%">Customer Code</td> 
										<!-- COl14   -->
                                        <td width="5%">SOCode</td> 
											<!-- COl15   -->
											        <td width="5.5%">Pre Bill</td> 
											<!-- COl15   -->
											        <td width="5%">Pre Price</td> 
											<!-- COl15   -->
									</tr>
								</table>
							<div style="background-color:#fafbfb;
					                    border: 1px solid #ccc;
					                    display: block;
					                    height: 238px;
					                    margin: auto;
					                    overflow-x: hidden;
					                    overflow-y: scroll;
					                    width: 150%;">
						<table id="tblProdDet" style="width: 100%; border: #0F0; table-layout: fixed;"
										class="transTablex col15-center">
								<tbody>
										<col style="width: 7%">
										<!--  COl1   -->
										<col style="width: 12%">
										<!--  COl2   -->
 										<col style="width: 5%"> 
										<!--  COl3   -->
										<col style="width: 4%">
										<!--  COl4   -->
										<col style="width: 5%"> 
										<!--COl5   -->
										<col style="width: 3%"> 
										<!--COl6   -->
 										<col style="width: 5%"> 
										<!-- COl7   -->
										<col style="width: 5%"> 
										<!-- COl7   -->
										<col style="width: 3%"> 
										<!-- COl7   -->
										<col style="width: 5%"> 
										<!--  COl8   -->
										<col style="width: 5%"> 
										<!--  COl9   -->
										<col style="width: 5%"> 
										<!--  COl10  -->
										<col style="width: 4.5%">
								    	<!--COl11  -->
										<col style="width: 4.3%"> 
										<!--  COl12   -->
										<col style="width: 4.5%"> 
										<!--COl13   -->
										<col style="width: 8%">
										<!--  COl14   -->
										<col style="width: 5%">
										<!--  COl15   -->
										<col style="width: 5%">
										<!--  COl15   -->
										<col style="width: 5%">
										<!--  COl15   -->

										</tbody>

									</table>
								</div>
                            </div>

                  <div class="row">
						<div class="col-md-2"><label>Narration</label>
							  <s:textarea id="txtNarration" path="strNarration" style="width:100%;height:35%"/>
						</div>
						
						<div class="col-md-2"><label>Pack No</label>
							  <s:input id="txtPackNo" path="strPackNo" type="text" style="width:100%;height:35%"/>
						</div>

						<div class="col-md-2"><label>Docket No of Courier</label>
							  <s:input id="txtDktNo" path="strDktNo" type="text" readonly="true" style="width:100%;height:35%"/>
                        </div>
                        <div class="col-md-6">	</div>
                        
						<div class="col-md-2"><label>Material Sent Out By</label>
							  <s:input id="txtMInBy" path="strMInBy" type="text"/>
						</div>
						
						<div class="col-md-2"><label>Time Out</label>
							 <s:input id="txtTimeOut" path="strTimeInOut" type="text"/>
						</div>
										
						<div class="col-md-2"><label>Reason Code</label>
							 <s:input id="txtReaCode" path="strReaCode" type="text"/>
						</div>
						<div class="col-md-6">	</div>
						
						<div class="col-md-2"><label id="lblQtyTotl">Total Qty</label>
							 <input type="text" id="txtQtyTotl" value="0.00" readonly="true" />
					    </div>
							
						<div class="col-md-2"><label id="lblsubTotlAmt">SubTotal Amount</label>
							 <s:input type="text" id="txtSubTotlAmt" path="dblSubTotalAmt" readonly="true"
									cssClass="decimal-places-amt numberField" />
						</div>
											
						<div class="col-md-2"><label >Discount Per</label>
							   <s:input type="text" id="txtDiscountPer" path="dblDiscount" value="0"
								cssClass="decimal-places-amt numberField" onkeypress="funCalculateDiscount();" />
						</div>
						<div class="col-md-6"></div>				
											
						<div class="col-md-2"><label >Discount Amount</label>	
								<s:input type="text" id="txtDiscount" path="dblDiscountAmt" value="0"
									cssClass="decimal-places-amt numberField"  />
						</div>
											
						<div class="col-md-2"><label id="lblFinalAmt">Final Amount</label>
								<s:input type="text" id="txtFinalAmt" path="dblTotalAmt" readonly="true"
									 cssClass="decimal-places-amt numberField" />
						</div>
				 </div>
            </div>
                 
	     <div id="tab2" class="tab_content" style="margin-top: 15px;">
	           <br>
	           <br>
			<div class="row">
					  <div class="col-md-12" align="left"><label>Ship To</label>
					  </div>

					  <div class="col-md-6"><label>Address Line 1</label>
							<s:input path="strSAdd1" id="txtSAddress1"/>
					  </div>
                     <div class="col-md-6">	</div>
                     
					 <div class="col-md-6"><label>Address Line 2</label>
						    <s:input path="strSAdd2" id="txtSAddress2"/>
					 </div>
                     <div class="col-md-6">	</div>
                     
					 <div class="col-md-3"><label>City</label>
						    <s:input path="strSCity" id="txtSCity"/>
					 </div>

					 <div class="col-md-3"><label>State</label>
						    <s:input path="strSState" id="txtSState"/>
					 </div>
                      <div class="col-md-6">	</div>
                      
					 <div class="col-md-3"><label>Country</label>
							<s:input path="strSCtry" id="txtSCountry"/>
					</div>

					<div class="col-md-3"><label>Pin Code</label>
					 		<s:input path="strSPin" id="txtSPin"/>
					</div>
				    <div class="col-md-6">	</div>
				 </div>   
			</div>
						
		<div id="tab3" class="tab_content" style="margin-top: 15px;">
			<br>
			<br>
			<div class="row">
							
				<div class="col-md-12">
				      <input type="button" id="btnGenTax" value="Calculate Tax" class="btn btn-primary center-block" class="form_button">
						<label id="tx"></label>
				</div>
								
				<div class="col-md-2"><label>Tax Code</label>
						<input type="text" id="txtTaxCode" ondblclick="funHelp('OpenTaxesForSales');" class="searchTextBox"/>
				</div>
									
				<div class="col-md-2"><label>Tax Description</label>
					   <label id="lblTaxDesc"></label>
				</div>
				<div class="col-md-8">	</div>
				
				<div class="col-md-2"><label>Taxable Amount</label>
					 	<input type="number" style="text-align: right;" step="any" id="txtTaxableAmt"/>
				</div>
									
				<div class="col-md-2"><label>Tax Amount</label>
						<input type="number" style="text-align: right;" step="any" id="txtTaxAmt"/>
				</div>
															
				<div class="col-md-2"><br>
				        <input type="button" id="btnAddTax" value="Add" class="btn btn-primary center-block" class="smallButton"/>
				</div>
			</div>
					
				<br>
				<table style="width: 70%; margin: 0px; background: #c0c0c0;" class="transTablex col5-center">
								<tr>
									<td style="width:10%">Tax Code</td>
									<td style="width:10%">Description</td>
									<td style="width:10%">Taxable Amount</td>
									<td style="width:10%">Tax Amount</td>
									<td style="width:5%">Delete</td>
								</tr>							
							</table>
							<div style="background-color: #fafbfb;border: 1px solid #ccc;display: block; height: 150px;
			    				overflow-x: hidden; overflow-y: scroll;width: 70%;">
									<table id="tblTax" class="transTablex col5-center" style="width: 100%;">
									<tbody>    
											<col style="width:10%"><!--  COl1   -->
											<col style="width:10%"><!--  COl2   -->
											<col style="width:10%"><!--  COl3   -->
											<col style="width:10%"><!--  COl4   -->
											<col style="width:5%"><!--  COl5   -->									
									</tbody>							
									</table>
							</div>			
						<br>
						
			<div id="tblTaxTotal" class="row masterTable">
					<div class="col-md-2"><label>Taxable Amt Total</label>
						<label id="lblTaxableAmt" style="background-color:#dcdada94; width: 100%; height: 50%; margin-top: 11%;"></label>
					</div>
								
					<div class="col-md-2"><label>Tax</label>
						<label id="lblTaxTotal" style="background-color:#dcdada94; width: 100%; height: 50%; margin-top: 11%;"></label>
					</div>
					
					<div class="col-md-2"><s:input type="hidden" id="txtPOTaxAmt" path="dblTaxAmt"/>
					</div>
							
					<div class="col-md-2"><label>Grand Total</label>
							<label id="lblPOGrandTotal" style="background-color:#dcdada94; width: 100%; height: 50%; margin-top: 11%;"></label>
					</div>
				</div>
			</div>
		</div>
	   <br>
     	<p align="center">
			<input type="submit" value="Submit" onclick="return funCallFormAction('submit',this)" class="btn btn-primary center-block" class="form_button" /> 
			&nbsp; 
			<input type="button" id="reset" name="reset" value="Reset" class="btn btn-primary center-block" class="form_button" />
		</p>
		<br><br>
		<s:input type="hidden" id="hidProdType" path="strProdType"></s:input>
		
		<input type="hidden" id="hidPrevInvCode" ></input>	
		<input type="hidden" id="hidPreInvPrice" ></input>
		
		<br>
		<div id="wait" style="display:none;width:60px;height:60px;border:0px solid black;position:absolute;top:60%;left:55%;padding:2px;">
				<img src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif" width="60px" height="60px" />
			
		</div>
		<input type="hidden" id="hidbillRate" ></input>	
		<input type="hidden" id="hidcustDiscount" ></input>	
	</s:form>
	</div>
	
	<script type="text/javascript">
	funApplyNumberValidation();

	</script>
</body>
</html>
