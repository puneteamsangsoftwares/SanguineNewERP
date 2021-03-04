<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Invoice</title>
       <script type="text/javascript" src="<spring:url value="/resources/js/pagination.js"/>"></script>

<style type="text/css">
.transTable td{
	padding-left:0px;
	border-left:none;
}
</style>
<script type="text/javascript">

var QtyTol=0.00;	
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
			
			var code='<%=session.getAttribute("locationCode").toString()%>';
			funSetLocation(code);
			var dayEndDate='<%=session.getAttribute("dayEndDate").toString()%>';
		//	 $("#txtDCDate").datepicker({ dateFormat: 'dd-mm-yy' });
			 $("#txtDCDate" ).val(dayEndDate);
		//		$("#txtDCDate" ).datepicker('setDate', dayEndDate);
		//		$("#txtDCDate").datepicker();
				
				
							var code='';
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
							
							
							var code='';
							<%if(null!=session.getAttribute("rptInvCode")){%>
							code='<%=session.getAttribute("rptInvCode").toString()%>';
							<%session.removeAttribute("rptInvCode");%>
							var isOk=confirm("Do You Want to Generate Slip?");
							if(isOk){
								window.open(getContextPath()+"/rptComercialTaxInvSlip.html?rptInvCode="+code,'_blank');
							}
							<%}%>
							
		});
		
		
	function funGetKeyCode(event,controller) {
	    var key = event.keyCode;
	    
	    if(controller=='BillNo' && key==13)
	    {
	    	document.getElementById('txtChallanDate').focus();
	    }
	    
	    if(controller=='BillDate' && key==13)
	    {
	    	document.getElementById('txtPayMode').focus();
	    }
	}
		
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
				        
				 case 'custMaster' :
				    	funSetCuster(code);
				    	break;  
				    	
				 case 'productmaster':
				    	funSetProduct(code);
				        break;
				        
				 case 'nonindicatortax':
				    	funSetTax(code);
				    	break;
					  
				 case 'invoice':
					   funSetInvoiceData(code)
					  break;
				        
				    
				       
				}
			}
		 	
		 	//get and set Tax 
			function funSetTax(code)
			{
				$.ajax({
				   		type: "GET",
				        url: getContextPath()+"/loadTaxMasterData.html?taxCode="+code,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strTaxCode!="Invalid Code")
					    	{
				        		$("#txtTaxCode").val(code);
					        	$("#lblTaxDesc").text(response.strTaxDesc);
					        	$("#txtTaxableAmt").val($("#txtFinalAmt").val());
					        	$("#txtTaxableAmt").focus();
					        	taxPer=parseFloat(response.dblPercent);
					        	funCalculateTaxForSubTotal(parseFloat($("#txtTaxableAmt").val()),taxPer);
					    	}
				        	else
				        	{
				        		$("#txtTaxCode").val('');
					        	$("#lblTaxDesc").text('');
					        	alert("Invalid Tax Code");
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
				    	
							$("#txtProdCode").val(response[0][0]);
							$("#lblProdName").text(response[0][1]);
							$("#txtPrice").val(response[0][3]);
							$("#hidUnitPrice").val(response[0][3]);
							$("#txtUnitPrice").val(response[0][3]);
							//$("#cmbUOM").val(response[0][2]);
							$("#txtWeight").val(response[0][7]);
							$("#hidProdType").val(response[0][6]);
							$("#lblUOM").text(response[0][2]);
							
							$("#txtQty").focus();
					     }
				    	else
				    		{
				    		  alert("Invalid Product Code");
				    		  $("#txtProdCode").val('') 
				    		  $("#txtProdCode").focus();
				    		  $("#lblProdName").text('');
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
	
	
	function funSetInvoiceData(code)
	{
		gurl=getContextPath()+"/loadComericalInvoiceHdData.html?invCode="+code;
		$.ajax({
	        type: "GET",
	        url: gurl,
	        dataType: "json",
	        success: function(response)
	        {		        	
	        		if(null == response.strInvCode){
	        			alert("Invalid  Invoice Code");
	        			$("#txtDCCode").val('');
	        			$("#txtDCCode").focus();
	        			$('#txtNarration').val('');
	        			funRemoveAllRows();
	        			
	        		}else{	
	        			funRemoveAllRows();
	        			$('#txtDCCode').val(code);
	        			$('#txtDCDate').val(response.dteInvDate);
	        			$('#txtAginst').val(response.strAgainst);
	        			
	        			
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
						$("#txtDiscount").val(response.dblDiscount);
						
						QtyTol=0.00;
						$.each(response.listclsInvoiceModelDtl, function(i,item)
		       	       	    	 {
		       	       	    	    funfillDCDataRow(response.listclsInvoiceModelDtl[i]);
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
		
	    var table = document.getElementById("tblTax");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
	    var taxCode=taxDtl.strTaxCode;
	    var taxDesc=taxDtl.strTaxDesc;
	    var taxableAmt=taxDtl.strTaxableAmt;
	    var taxAmt=taxDtl.strTaxAmt;
	    
	    row.insertCell(0).innerHTML= "<input class=\"Box\" style=\"width:99%\" name=\"listInvoiceTaxDtl["+(rowCount)+"].strTaxCode\" id=\"txtTaxCode."+(rowCount)+"\" value='"+taxCode+"' >";
	    row.insertCell(1).innerHTML= "<input class=\"Box\" style=\"width:99%\" name=\"listInvoiceTaxDtl["+(rowCount)+"].strTaxDesc\" id=\"txtTaxDesc."+(rowCount)+"\" value='"+taxDesc+"'>";		    	    
	    row.insertCell(2).innerHTML= "<input type=\"number\" step=\"any\" required = \"required\" style=\"text-align: right;width:99%; border:1px solid #c0c0c0;\" name=\"listInvoiceTaxDtl["+(rowCount)+"].strTaxableAmt\" id=\"txtTaxableAmt."+(rowCount)+"\" value="+taxableAmt+">";
	    row.insertCell(3).innerHTML= "<input type=\"number\" step=\"any\" required = \"required\" style=\"text-align: right;width:99%; border:1px solid #c0c0c0;\" name=\"listInvoiceTaxDtl["+(rowCount)+"].strTaxAmt\" id=\"txtTaxAmt."+(rowCount)+"\" value="+taxAmt+">";		    
	    row.insertCell(4).innerHTML= '<input type="button" style=\"width:99%\" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteTaxRow(this)" >';
	    
	    funCalTaxTotal();
	    funClearFieldsOnTaxTab(); 
	    
	    return false;  
	}
	
	
	function btnAdd_onclick()
	{
		
		if($("#txtProdCode").val().length<=0)
			{
				$("#txtProdCode").focus();
				alert("Please Enter Product Code Or Search");
				return false;
			}		
		
		
	    if($("#txtQty").val().trim().length==0 || $("#txtQty").val()== 0)
	        {		
	          alert("Please Enter Quantity");
	          $("#txtQty").focus();
	          return false;
	       } 
	    else
	    	{
	    	var strProdCode=$("#txtProdCode").val();
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
	    var strProdCode = $("#txtProdCode").val();
		var strProdName=$("#lblProdName").text();
		var strProdType=$("#hidProdType").val();	
	    var dblQty = $("#txtQty").val();
	    parseFloat(dblQty).toFixed(maxQuantityDecimalPlaceLimit);
	    var dblWeight=$("#txtWeight").val();
	    var dblTotalWeight=dblQty*dblWeight;
	  	var packingNo= $("#txtPackingNo").val();
	    var strSerialNo = $("#txtSerialNo").val();
	    var strInvoiceable ="N";
	    var strRemarks=$("#txtRemarks").val();
	   
	    $("#txtUnitPrice").val();
        var unitprice=$("#txtUnitPrice").val();
       unitprice=parseFloat(unitprice).toFixed(maxQuantityDecimalPlaceLimit);
	   var totalPrice=unitprice*dblQty;
	    var strUOM=$("#lblUOM").text();
       var strCustCode=$("#txtCustCode").val();
       var strSOCode="";
	   row.insertCell(0).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strProdCode\" readonly=\"readonly\" class=\"Box txtProdCode\" style=\"width:99%;\" id=\"txtProdCode."+(rowCount)+"\" value='"+strProdCode+"' />";		  		   	  
	    row.insertCell(1).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strProdName\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"txtProdName."+(rowCount)+"\" value='"+strProdName+"'/>";
	    row.insertCell(2).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strProdType\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\"  id=\"txtProdTpye."+(rowCount)+"\" value='"+strProdType+"'/>";
	    row.insertCell(3).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblQty\" type=\"text\"  required = \"required\" style=\"text-align: right;border: 1px solid #c0c0c0;width:99%;\"   class=\"decimal-places inputText-Auto  txtQty\" id=\"txtQty."+(rowCount)+"\" value="+dblQty+" onblur=\"Javacsript:funUpdatePrice(this)\">";
	    row.insertCell(4).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblWeight\" type=\"text\"  required = \"required\"  style=\"text-align: right;border: 1px solid #c0c0c0;width:99%;\" class=\"decimal-places inputText-Auto\" id=\"txtWeight."+(rowCount)+"\" value="+dblWeight+" >";
	    row.insertCell(5).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblTotalWeight\" readonly=\"readonly\" class=\"Box\" style=\"text-align: right;width:99%;\" id=\"dblTotalWeight."+(rowCount)+"\"   value='"+dblTotalWeight+"'/>";
	    row.insertCell(6).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblUnitPrice\" readonly=\"readonly\" class=\"Box txtUnitprice\" style=\"text-align: right;width:99%;\"  id=\"unitprice."+(rowCount)+"\"   value='"+unitprice+"'/>";
	    row.insertCell(7).innerHTML= "<input readonly=\"readonly\" class=\"Box totalValueCell\" style=\"text-align: right;width:99%;\"  id=\"totalPrice."+(rowCount)+"\"   value='"+totalPrice+"'/>";
	    row.insertCell(8).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strPktNo\" type=\"text\"   class=\"Box\"  style=\"border: 1px solid #a2a2a2;width:99%;\"  id=\"txtPktNo."+(rowCount)+"\" value="+packingNo+" >";
	    row.insertCell(9).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strRemarks\" style=\"width:99%;\" id=\"txtRemarks."+(rowCount)+"\" value='"+strRemarks+"'/>";
	    row.insertCell(10).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strInvoiceable\" readonly=\"readonly\" class=\"Box\"  style=\"width:99%;\" id=\"txtInvoiceable."+(rowCount)+"\" value="+strInvoiceable+" >";
	    row.insertCell(11).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strSerialNo\" type=\"text\" class=\"Box\"  style=\"border: 1px solid #a2a2a2;width:99%;\" id=\"txtSerialNo."+(rowCount)+"\" value="+strSerialNo+" >";	    
	 	row.insertCell(12).innerHTML= '<input  class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRow(this)">';		    
	 	row.insertCell(13).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strCustCode\" type=\"text\" style=\"border: 1px solid #a2a2a2;width:99%;\"   class=\"Box\" id=\"txtCustCode."+(rowCount)+"\" value="+strCustCode+" >";
	 	row.insertCell(14).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strSOCode\" type=\"text\"  style=\"border: 1px solid #a2a2a2;width:99%;\"  class=\"Box\" id=\"txtSOCOde."+(rowCount)+"\" value="+strSOCode+" >";
	 	row.insertCell(15).innerHTML= "<input type=\"hidden\"  name=\"listclsInvoiceModelDtl["+(rowCount)+"].strUOM\" type=\"text\"    class=\"Box\" style=\"width:99%;\" id=\"txtUOM."+(rowCount)+"\" value="+strUOM+" >";
	 	
	 	QtyTol+=parseFloat(dblQty);
	 	$("#txtQtyTotl").val(QtyTol);
	    $("#txtProdCode").focus();
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
	
	function funfillDCDataRow(DCDtl)
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
	    
	    var strUOM=DCDtl.strUOM;
	    var unitprice=DCDtl.dblUnitPrice;
	    var totalPrice=unitprice*dblQty;
	    var CustCode=DCDtl.strCustCode;
	    var SOCode=DCDtl.strSOCode;
	    row.insertCell(0).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strProdCode\" readonly=\"readonly\" class=\"Box txtProdCode\" style=\"width:99%;\" id=\"txtProdCode."+(rowCount)+"\" value='"+strProdCode+"' />";		  		   	  
	    row.insertCell(1).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strProdName\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"txtProdName."+(rowCount)+"\" value='"+strProdName+"'/>";
	    row.insertCell(2).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strProdType\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"txtProdTpye."+(rowCount)+"\" value='"+strProdType+"'/>";
	    row.insertCell(3).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblQty\" type=\"text\"  required = \"required\"  style=\"text-align: right;width:99%;border: 1px solid #c0c0c0;width:99%;\"  class=\"decimal-places inputText-Auto  txtQty\" id=\"txtQty."+(rowCount)+"\" value="+dblQty+" onblur=\"Javacsript:funUpdatePrice(this)\">";
	    row.insertCell(4).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblWeight\" type=\"text\"  required = \"required\" style=\"text-align: right;border: 1px solid #c0c0c0;width:99%;\" class=\"decimal-places inputText-Auto\" id=\"txtWeight."+(rowCount)+"\" value="+dblWeight+" >";
	    row.insertCell(5).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblTotalWeight\" readonly=\"readonly\" class=\"Box\" style=\"text-align: right;width:99%;\"  id=\"dblTotalWeight."+(rowCount)+"\"   value='"+dblTotalWeight+"'/>";
	    row.insertCell(6).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblUnitPrice\" readonly=\"readonly\" class=\"Box txtUnitprice\" style=\"text-align: right;width:99%;\"  id=\"unitprice."+(rowCount)+"\"   value='"+unitprice+"'/>";
	    row.insertCell(7).innerHTML= "<input readonly=\"readonly\" class=\"Box totalValueCell\" style=\"text-align: right;width:99%;\"  id=\"totalPrice."+(rowCount)+"\"   value='"+totalPrice+"'/>";
	    row.insertCell(8).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strPktNo\" type=\"text\"    class=\"Box\"  style=\"border: 1px solid #a2a2a2;width:99%;\" id=\"txtPktNo."+(rowCount)+"\" value="+packingNo+" >";
	    row.insertCell(9).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strRemarks\" style=\"width:99%;\" id=\"txtRemarks."+(rowCount)+"\" value='"+strRemarks+"'/>";
	    row.insertCell(10).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strInvoiceable\" readonly=\"readonly\" class=\"Box\"  style=\"width:99%;\" id=\"txtInvoiceable."+(rowCount)+"\" value="+strInvoiceable+" >";
	    row.insertCell(11).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strSerialNo\" type=\"text\" style=\"border: 1px solid #a2a2a2;width:99%;\"   class=\"Box\" id=\"txtSerialNo."+(rowCount)+"\" value="+strSerialNo+" >";	    
	 	row.insertCell(12).innerHTML= '<input  class="deletebutton" value = "Delete" onClick="">';		    
	 	row.insertCell(13).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strCustCode\" type=\"text\" style=\"border: 1px solid #a2a2a2;width:99%;\"  class=\"Box\"  id=\"txtCustCode."+(rowCount)+"\" value="+CustCode+" >";
	 	row.insertCell(14).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strSOCode\" type=\"text\"  style=\"border: 1px solid #a2a2a2;width:99%;\"  class=\"Box\"  id=\"txtSOCOde."+(rowCount)+"\" value="+SOCode+" >";
	 	row.insertCell(15).innerHTML= "<input type=\"hidden\"  name=\"listclsInvoiceModelDtl["+(rowCount)+"].strUOM\" type=\"text\"    class=\"Box\" style=\"width:99%;\" id=\"txtUOM."+(rowCount)+"\" value="+strUOM+" >"; 	
	 	$("#txtProdCode").focus();
		    funClearProduct();
		    funCalculateTotalAmt();
// 		    funGetTotal();
		
		 QtyTol+=dblQty;
		
		    return false;
	    
	    return false;
	
	}
	
	function funClearProduct()
	{
		$("#txtProdCode").val("");
		$("#strUOM").val("");
		$("#lblProdName").text("");
		$("#txtQty").val("");
		$("#txtPrice").val("");
		
		$("#txtRemarks").val("");
		$("#txtWeight").val("");
		$("#txtUnitPrice").val("");
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
				else{
					document.all["txtSOCode"].style.display = 'block';
					document.all["btnFill"].style.display = 'block';
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
				
				$('#txtCustCode').blur(function () {
					var code=$('#txtCustCode').val();
					if (code.trim().length > 0 && code !="?" && code !="/"){
						   funSetCuster(code);
					   }
					});
				
				$('#txtLocCode').blur(function () {
					var code=$('#txtLocCode').val();
					if (code.trim().length > 0 && code !="?" && code !="/"){
						funSetLocation(code);
					   }
					});
				
				$('#txtProdCode').blur(function () {
					var code=$('#txtProdCode').val();
					if (code.trim().length > 0 && code !="?" && code !="/"){								  
						funSetProduct(code);
					   }
					}); 
				
				$('#txtTaxCode').blur(function () {
					var code=$('#txtTaxCode').val();
					if (code.trim().length > 0 && code !="?" && code !="/"){								  
						funSetTax(code);
					   }
					}); 
				
			});
	
	
	/**
	 * Calculate Total Amount
	 */
	function funCalculateTotalAmt()
	{
		var totalAmt=0;
		var table = document.getElementById("tblProdDet");
		var rowCount = table.rows.length;
		for(var i=0;i<rowCount;i++)
		{
			totalAmt=parseFloat(document.getElementById("totalPrice."+i).value)+totalAmt;
		}
		
		$("#txtSubTotlAmt").val(totalAmt);
		$("#txtFinalAmt").val(totalAmt);
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
		    
		    var cnt=0;
			$('#tblProdDet tr').each(function(){
				
		    	var prodCode= $(this).find(".txtProdCode").val();
		    	var custCode=$("#txtCustCode").val();
	         	var discPer=0;
//	 	    	if($("#txtDiscPer").val()!='')
//	 	    	{	
//	 	    		discPer=parseFloat($("#txtDiscPer").val());
//	 	    	}
	 	    	var vari=document.getElementById("totalPrice." + cnt).value;
	 	    	var qty=parseFloat(document.getElementById("txtQty."+cnt).value);	
	 	    	var unitPrice=parseFloat(document.getElementById("unitprice."+cnt).value);
		    	var discAmt1=0;
				var taxableAmount=parseFloat(vari);
				
		    	var discAmt=(taxableAmount*discPer)/100;
		    	taxableAmount=taxableAmount-discAmt;
		    	prodCodeForTax=prodCodeForTax+"!"+prodCode+","+unitPrice+","+custCode+","+qty+","+discAmt1;
		    	
		    	cnt++;
		    });
			
		    prodCodeForTax=prodCodeForTax.substring(1,prodCodeForTax.length).trim();
		     forTax(prodCodeForTax);
		}
		
		
		function forTax(prodCodeForTax){
			var dteInv =$('#txtDCDate').val();
			var CIFAmt=0;
			var settlement='';
		    gurl=getContextPath()+"/getTaxDtlForProduct.html?prodCode="+prodCodeForTax+"&taxType=Sales&transDate="+dteInv+"&CIFAmt="+CIFAmt+"&strSettlement="+settlement,
		    
		    		$.ajax({
		    		
			   		type: "GET",
			//        url: getContextPath()+"/getTaxDtlForProduct.html?prodCode="+prodCodeForTax,
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
			        		  //var taxableAmt=parseFloat(spItem[0])+dblExtraCharge;
			        			var taxableAmt=parseFloat(spItem[0]);
				        		var taxCode=spItem[1];
					        	var taxDesc=spItem[2];
					        	var taxPer1=parseFloat(spItem[4]);
//	 				        	var taxAmt=(taxableAmt*taxPer1)/100;
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
	    row.insertCell(0).innerHTML= "<input class=\"Box\" style=\"width:99%\" name=\"listInvoiceTaxDtl["+(rowCount)+"].strTaxCode\" id=\"txtTaxCode."+(rowCount)+"\" value='"+taxCode+"' >";
	    row.insertCell(1).innerHTML= "<input class=\"Box\" style=\"width:99%\" name=\"listInvoiceTaxDtl["+(rowCount)+"].strTaxDesc\" id=\"txtTaxDesc."+(rowCount)+"\" value='"+taxDesc+"'>";		    	    
	    row.insertCell(2).innerHTML= "<input type=\"number\" step=\"any\" required = \"required\" style=\"text-align: right; width:99%; border:1px solid #c0c0c0;\"  name=\"listInvoiceTaxDtl["+(rowCount)+"].strTaxableAmt\" id=\"txtTaxableAmt."+(rowCount)+"\" value="+taxableAmt+">";
	    row.insertCell(3).innerHTML= "<input type=\"number\" step=\"any\" required = \"required\" style=\"text-align: right; width:99%; border:1px solid #c0c0c0;\"  name=\"listInvoiceTaxDtl["+(rowCount)+"].strTaxAmt\" id=\"txtTaxAmt."+(rowCount)+"\" value="+taxAmt+">";		    
	    row.insertCell(4).innerHTML= '<input type="button" style=\"width:99%\" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteTaxRow(this)" >';
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
		$("#lblPOGrandTotal").text(grandTotal);
		var taxAmt=$("#txtPOTaxAmt").val();
	//	var disAmt = $('#txtDisc').val();
	//	var extCharge = $('#txtExtraCharges').val();
		var finalAmt=parseFloat(subTotal)+parseFloat(totalTaxAmt);
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
		    row.insertCell(2).innerHTML= "<input type=\"number\" step=\"any\" required = \"required\" style=\"text-align: right;width:99%; border:1px solid #c0c0c0;\" name=\"listInvoiceTaxDtl["+(rowCount)+"].strTaxableAmt\" id=\"txtTaxableAmt."+(rowCount)+"\" value="+taxableAmt+">";
		    row.insertCell(3).innerHTML= "<input type=\"number\" step=\"any\" required = \"required\" style=\"text-align: right;width:99%; border:1px solid #c0c0c0;\"  name=\"listInvoiceTaxDtl["+(rowCount)+"].strTaxAmt\" id=\"txtTaxAmt."+(rowCount)+"\" value="+taxAmt+">";		    
		    row.insertCell(4).innerHTML= '<input type="button" style=\"width:99%;\" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteTaxRow(this)" >';
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
	
		
		/**
		 * Filling Grid
		 */
		function funfillProdRow(strProdCode, strProdName, dblUnitPrice, dblAcceptQty,
				dblWeight, strSpCode,strCustCode,strSOCode) {
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

			    
			    row.insertCell(0).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strProdCode\" readonly=\"readonly\" class=\"Box txtProdCode\" style=\"width:99%;\" id=\"txtProdCode."+(rowCount)+"\" value='"+strProdCode+"' />";		  		   	  
			    row.insertCell(1).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strProdName\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"txtProdName."+(rowCount)+"\" value='"+strProdName+"'/>";
			    row.insertCell(2).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strProdType\" readonly=\"readonly\" class=\"Box\" style=\"width:99%;\" id=\"txtProdTpye."+(rowCount)+"\" value='"+strProdType+"'/>";
			    row.insertCell(3).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblQty\" type=\"text\"  required = \"required\"  style=\"text-align: right;width:99%;border: 1px solid #c0c0c0;\"   class=\"decimal-places inputText-Auto  txtQty\" id=\"txtQty."+(rowCount)+"\" value="+dblAcceptQty+" onblur=\"Javacsript:funUpdatePrice(this)\">";
			    row.insertCell(4).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblWeight\" type=\"text\"  required = \"required\" style=\"text-align: right;border: 1px solid #c0c0c0;width:99%;\" class=\"decimal-places inputText-Auto\" id=\"txtWeight."+(rowCount)+"\" value="+dblWeight+" >";
			    row.insertCell(5).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblTotalWeight\" readonly=\"readonly\" class=\"Box\" style=\"text-align: right;width:99%;\"  id=\"dblTotalWeight."+(rowCount)+"\"   value='"+dblTotalWeight+"'/>";
			    row.insertCell(6).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].dblUnitPrice\" readonly=\"readonly\" class=\"Box txtUnitprice\" style=\"text-align: right;width:99%;\"  id=\"unitprice."+(rowCount)+"\"   value='"+dblUnitPrice+"'/>";
			    row.insertCell(7).innerHTML= "<input readonly=\"readonly\" class=\"Box totalValueCell\" style=\"text-align: right;width:99%;\"    id=\"totalPrice."+(rowCount)+"\"   value='"+dblTotalPrice+"'/>";
			    row.insertCell(8).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strPktNo\" type=\"text\"    class=\"Box\"  style=\"border: 1px solid #a2a2a2;width:99%;\" id=\"txtPktNo."+(rowCount)+"\" value="+packingNo+" >";
			    row.insertCell(9).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strRemarks\" style=\"width:99%;\" id=\"txtRemarks."+(rowCount)+"\" value='"+strRemarks+"'/>";
			    row.insertCell(10).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strInvoiceable\" readonly=\"readonly\" class=\"Box\"  style=\"width:99%;\" id=\"txtInvoiceable."+(rowCount)+"\" value="+strInvoiceable+" >";
			    row.insertCell(11).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strSerialNo\" type=\"text\"    class=\"Box\" style=\"border: 1px solid #a2a2a2;width:99%;\"  id=\"txtSerialNo."+(rowCount)+"\" value="+strSerialNo+" >";	    
			 	row.insertCell(12).innerHTML= '<input  class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRow(this)">';		    
			 	row.insertCell(13).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strCustCode\" type=\"text\"  style=\"border: 1px solid #a2a2a2;width:99%;\"  class=\"Box\"  id=\"txtCustCode."+(rowCount)+"\" value="+strCustCode+" >";
			 	row.insertCell(14).innerHTML= "<input name=\"listclsInvoiceModelDtl["+(rowCount)+"].strSOCode\" type=\"text\"  style=\"border: 1px solid #a2a2a2;width:99%;\"  class=\"Box\"  id=\"txtSOCOde."+(rowCount)+"\" value="+strSOCode+" >";
			 	
			 	
			 	QtyTol+=parseFloat(dblAcceptQty);
// 			 	var txtTotQty = $("#txtQtyTotl").val();
// 				$("#txtQtyTotl").val(parseFloat(txtTotQty)+dblAcceptQty);
				
			 	
			    $("#txtProdCode").focus();
			    funCalculateTotalAmt();
			    funClearProduct();
			   // funGetTotal();
			    return false;
		}
		
</script>
</head>
<body >
	<div  class="container transTable">
		<label id="formHeading">Commercial Tax Innvoice</label>
	   <s:form name="SOForm" method="POST"  action="saveCommercialInvoice.html?saddr=${urlHits}">
<%-- 		<input type="hidden" value="${urlHits}" name="saddr"> --%>
		<br>
		
		 <div id="tab_container">
						<ul class="tabs">
							<li class="active" data-state="tab1"
								style="width: 100px; padding-left: 27px">Invoice</li>
							<li data-state="tab2" style="width: 100px; padding-left: 27px">Address</li>
							<li data-state="tab3" style="width: 100px; padding-left: 27px">Taxes</li>
						</ul>

		  <div id="tab1" class="tab_content" style="margin-top: 50px;height: 830px;">
					
								<!-- <tr>
									<th align="right" colspan="9"><a id="baseUrl" href="#">
											Attach Documents </a></th>
								</tr>
 -->
				 <div class="row">
			           <div class="col-md-2"><label>Invoice Code</label>
							<s:input path="strInvCode" id="txtDCCode" ondblclick="funHelp('invoice')" cssClass="searchTextBox" />
					   </div>

			           <div class="col-md-2"><label>Invoice Date</label>
							<s:input path="dteInvDate" id="txtDCDate" readonly="true"  required="required" cssClass="calenderTextBox" style="width:70%"/>
					    </div>
						<div class="col-md-8"></div>
							
					   <div class="col-md-2"><label>Customer Code</label>
							<s:input path="strCustCode" id="txtCustCode" ondblclick="funHelp('custMaster')" cssClass="searchTextBox" />
					   </div>
					  
					  <div class="col-md-2"><label id="lblCustomerName" class="namelabel" style="background-color:#dcdada94; width: 100%; height: 50%; margin-top: 17%;padding: 2px;"></label>
					   </div>

					  <div class="col-md-2" style="display:none"><s:input id="txtSOCode" path="strSOCode"
											 style="display:none" class="searchTextBox"></s:input>
					   </div>
					   <div class="col-md-8"></div>
								
					   <div class="col-md-2"><label>Location Code</label>
							<s:input type="text" id="txtLocCode" path="strLocCode" cssClass="searchTextBox" readonly="true" />
					   </div>
					   
					  <div class="col-md-2"><label id="lblLocName" style="background-color:#dcdada94; width: 100%; height: 50%; margin-top: 11%;padding: 2px;"></label></div>
                      <div class="col-md-8"></div>
                      
					  <div class="col-md-2"><label>Product</label>
						    <input id="txtProdCode" ondblclick="funHelp('productmaster')" class="searchTextBox" />
					   </div>
					   
					   <div class="col-md-2"  align="left">
					         <label id="lblProdName" class="namelabel" style="background-color:#dcdada94; width: 100%; height: 50%; margin-top: 11%;padding: 2px;"></label>
					   </div>

					   <div class="col-md-2"><label>Serial No</label>
							<s:input id="txtSerialNo" path="strSerialNo" type="text"/>
                       </div>
                      
                      <div class="col-md-6"></div>
                      
                      <div class="col-md-2"><label>Wt/Unit</label>
							<input type="text" id="txtWeight" class="decimal-places numberField" />
					  </div>
				
					  <div class="col-md-2"><label>Quantity</label>
							<input id="txtQty" type="text" class="decimal-places numberField" style="width: 60%" onkeypress="funGetKeyCode(event,'Qty')"/>
					 </div>
									
					 <div class="col-md-2"><label>Unit Price</label>
							<input id="txtUnitPrice" type="text" class="decimal-places numberField" style="width: 60%" />
					 </div>	
					 <div class="col-md-6"></div>	
								
                     <div class="col-md-2"><label>UOM</label>
							<label id='lblUOM' style="background-color:#dcdada94; width: 100%; height: 50%;padding: 2px;"></label>
					 </div>
					 
					 <div class="col-md-2"><label>Packing No</label>
							<input id="txtPackingNo" type="text" />
					 </div>

					 <div class="col-md-2"><label>Remarks</label>
							<input id="txtRemarks" type="text" />
					 </div>
											
					 <div class="col-md-2"><br>
					      <input type="button" value="Add" class="btn btn-primary center-block" class="smallButton"
								onclick="return btnAdd_onclick()" />
					 </div>
		
		<div class=" col-md-12 dynamicTableContainer" style="height: 300px; width: 100%;padding:0px;">
					<table style="height: 20px; border: #0F0; width: 109%; font-size: 11px; font-weight: bold;">
							<tr bgcolor="#c0c0c0">
										<td width="5%">Product Code</td>
										<!--  COl1   -->
										<td width="14%">Product  Name</td>
										<!--  COl2   -->
										<td width="5%"></td>
										<!--  COl3   -->
										<td width="3%">Qty</td>
										<!--  COl4   -->
									   <td width="3%">Wt/Unit</td> 
										<!-- COl5   -->
										<td width="5%">Total Wt</td> 
										<!-- COl6   -->
 										<td width="4%">Unit Price</td> 
										<!--  COl7   -->
										<td width="6%">Total Amt</td>
										<!--  COl8   -->
									    <td width="7%">Packing No</td>
										<!--  COl9   -->
										<td width="7%">Remarks</td>
										<!--COl10   -->
										<td width="5%">Invoice</td> 
										<!--  COl11   -->
										<td width="5%">Serial No</td>
										<!-- COl12   -->
										<td width="4%">Delete</td> 
										<!--  COl13   -->
                                        <td width="6%">Customer Code</td> 
										<!-- COl14   -->
                                        <td width="7%">SOCode</td> 
											<!-- COl15   -->
										<td width="5%"></td> 
										  <!-- COl16   -->
										
							</tr>
						</table>
					 <div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 250px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 109%;">
							<table id="tblProdDet" style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
										class="transTablex col15-center">
										<tbody>
										<col style="width: 5%">
										<!--  COl1   -->
										<col style="width: 15%">
										<!--  COl2   -->
										<col style="width: 6%">
										<!--  COl3   -->
										<col style="width: 4%">
										<!--  COl4   -->
										<col style="width: 4%"> 
										<!--COl5   -->
										<col style="width: 6%"> 
										<!--COl6   -->
 										<col style="width: 5%"> 
										<!-- COl7   -->
										<col style="width: 7%"> 
										<!--  COl8   -->
										<col style="width: 8%"> 
										<!--  COl9   -->
										<col style="width: 8%"> 
										<!--  COl10  -->
										<col style="width: 6%">
								    	<!--COl11  -->
										<col style="width: 6%"> 
										<!--  COl12   -->
										<col style="width: 5%"> 
										<!--COl13   -->
										<col style="width: 7%">
										<!--  COl14   -->
										<col style="width: 8%">
										<!--  COl15   -->
										<col style="width: 5%">
										<!--  COl16   -->
										
										</tbody>

									</table>
								</div>

							</div>
                 
                 <div class="col-md-2"><label>Narration</label>
						<s:textarea id="txtNarration" path="strNarration" Cols="50" rows="3" style="width:100%;height:35px;" />
				 </div>
				
				 <div class="col-md-2"><label>Pack No</label>
						<s:input id="txtPackNo" path="strPackNo" type="text" />
				 </div>
					
				 <div class="col-md-2"><label>Docket No of Courier</label>
						<s:input id="txtDktNo" path="strDktNo" type="text" />
				 </div>
                  <div class="col-md-6"></div>
                  	
				 <div class="col-md-2"><label>Material Sent Out By</label>
						<s:input id="txtMInBy" path="strMInBy" type="text"/>
				  </div>
						
				  <div class="col-md-2"><label>Time Out</label>
						<s:input id="txtTimeOut" path="strTimeInOut" type="text"/>
				   </div>
											
				  <div class="col-md-2"><label>Reason Code</label>
						<s:input id="txtReaCode" path="strReaCode" type="text"/>
				  </div>
				   <div class="col-md-6"></div>
							
				   <div class="col-md-2"><label id="lblQtyTotl">Total Qty</label>
					   <input type="text" id="txtQtyTotl" value="0.00" readOnly="true"/>
				  </div>
							
				  <div class="col-md-2"><label id="lblsubTotlAmt">SubTotal Amount</label>
					   <s:input type="text" id="txtSubTotlAmt" path="dblSubTotalAmt" readonly="true" cssClass="decimal-places-amt numberField" />
				  </div>
				 
				  <div class="col-md-2"><label id="lblFinalAmt">Final Amount</label>
					   <s:input type="text" id="txtFinalAmt" path="dblTotalAmt" readonly="true" cssClass="decimal-places-amt numberField" />
				  </div>
			</div>
			</div>
				
		<div id="tab2" class="tab_content" style="margin-top: 50px;height:280px;">
			 <div class="row">
					 <div class="col-md-12" align="left"><label>Ship To</label>
					 </div>
					
                     <div class="col-md-6"><label>Address Line 1</label>
							<s:input path="strSAdd1" id="txtSAddress1"/>
					 </div>
                      <div class="col-md-6"></div>
                      
					 <div class="col-md-6"><label>Address Line 2</label>
						<s:input path="strSAdd2" id="txtSAddress2"/>
					 </div>
					  <div class="col-md-6"></div>
					
					 <div class="col-md-3"><label>City</label>
						 <s:input path="strSCity" id="txtSCity" style="width:70%;"/>
					 </div>
					 
                     <div class="col-md-3"><label>State</label>
						   <s:input path="strSState" id="txtSState" style="width:70%;"/>
					 </div>
                     <div class="col-md-6"></div>
                     
					 <div class="col-md-3"><label>Country</label>
						  <s:input path="strSCtry" id="txtSCountry" style="width:70%;"/>
					 </div>

					<div class="col-md-3"><label>Pin Code</label>
						  <s:input path="strSPin" id="txtSPin" class="positive-integer" style="width:70%;"/>
					</div>
			</div>
		 </div>		
		 		
		 <div id="tab3" class="tab_content" style="margin-top: 55px; height: 440px;">
		      <div class="row">
					 <div class="col-md-12">
					     <input type="button" id="btnGenTax" value="Calculate Tax" class="btn btn-primary center-block" class="form_button">
					     <label id="tx"></label>
					 </div>
								
					 <div class="col-md-2"><label>Tax Code</label>
							<input type="text" id="txtTaxCode" ondblclick="funHelp('nonindicatortax');" class="searchTextBox"/>
					 </div>
									
					 <div class="col-md-2"><label>Tax Description</label>
						    <label id="lblTaxDesc" style="background-color:#dcdada94; width: 100%; height: 50%;padding: 2px;"></label>
					 </div>
					 <div class="col-md-8"></div>
					 
					 <div class="col-md-2"><label>Taxable Amount</label>
							<input type="number" style="text-align: right;" step="any" id="txtTaxableAmt"/>
					 </div>
									
					 <div class="col-md-2"><label>Tax Amount</label>
							<input type="number" style="text-align: right;" step="any" id="txtTaxAmt"/>
					  </div>
															
					  <div class="col-md-2"><br>
					        <input type="button" id="btnAddTax" value="Add" class="btn btn-primary center-block" class="smallButton"/>
					  </div>
				 	  <div class="col-md-6"></div>
				  </div>
							<br>
							<table style="width: 70%;margin: 0px; background: #c0c0c0;"" class="transTablex col5-center">
								<tr style="background-color: #c0c0c0;">
									<td style="width:10%">Tax Code</td>
									<td style="width:10%">Description</td>
									<td style="width:10%">Taxable Amount</td>
									<td style="width:10%">Tax Amount</td>
									<td style="width:3%">Delete</td>
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
											<col style="width:3%"><!--  COl5   -->									
									</tbody>							
								  </table>
							</div>			
						<br>
				
						<div class="row" id="tblTaxTotal" class="masterTable">
							    <div class="col-md-2"><label>Taxable Amt Total</label>
								       <label id="lblTaxableAmt" style="background-color:#dcdada94; width: 100%; height: 80%;padding: 2px;"></label>
								</div>
								
								<div class="col-md-2"><label>Tax</label>
								       <label id="lblTaxTotal" style="background-color:#dcdada94; width: 100%; height: 80%;padding: 2px;"></label>
								</div> 
								   
							    <div class="col-md-2">
								      <s:input type="hidden" id="txtPOTaxAmt" path="dblTaxAmt"/>
							    </div>
							
							    <div class="col-md-2"><label>Grand Total</label>
							          <label id="lblPOGrandTotal" style="background-color:#dcdada94; width: 100%; height: 80%;padding:2px;;"></label>
							    </div>
						</div>
					
				     </div>       
                </div>
	         <br>
        <div align="center" style="margin-right: 15%;">
			<input type="submit" value="Submit" onclick="return funCallFormAction('submit',this)" class="btn btn-primary center-block" class="form_button" />
			&nbsp;
			<input type="button" id="reset" name="reset" value="Reset" class="btn btn-primary center-block" class="form_button" />
		</div>
		<br><br>
		<s:input type="hidden" id="hidProdType" path="strProdType"></s:input>
		
		<br>
		<div id="wait" style="display:none;width:60px;height:60px;border:0px solid black;position:absolute;top:60%;left:55%;padding:2px;">
				<img src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif" width="60px" height="60px" />
			
			
			</div>
			<input type="hidden" id="hidbillRate" ></input>	
			<input type="hidden" id="hidUnitPrice" ></input>
	
	</s:form>
	</div>
	<script type="text/javascript">
		//funApplyNumberValidation();
	</script>
</body>
</html>
