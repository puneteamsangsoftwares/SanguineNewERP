<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>GRN</title>
<link rel="stylesheet" type="text/css"
	href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />


<style type="text/css">
.contents {
	min-height: calc(100vh - -760px);
}

.transTable {
	overflow: hidden;
}
</style>
<script type="text/javascript">
   //Set GRN textField focus when Form is Load
   
   
   var grneditable;
   var strCurrentDateForTransaction;
   var strRoundOffFinalAmtOnTransaction=${strRoundOffFinalAmtOnTransaction};
   var mapForGroupTax=new Map();
	$(document).ready(function () {
		
	 resetForms('grn');
	 
	    $("#txtGRNCode").focus();
	    var a=new Map();
	    strAllMapForGRTax="${mapTaxGroupName}";
	    var strAllGRTaxWithSplit=strAllMapForGRTax.replace("{"," ");
	    for(var j=0;j<strAllGRTaxWithSplit.split(",").length;j++)
    	{
    	   var strIndividualTax=strAllGRTaxWithSplit.split(",")[j];
    	   mapForGroupTax.set(strIndividualTax.split("=")[0].trim(),strIndividualTax.split("=")[1]);    
    	  
    	}
	//   alert(a[0].GT0000001 );
	    /* strCurrentDateForTransaction="${strCurrentDateForTransaction}" ;
		  if(strCurrentDateForTransaction=="true"){
			//  $("#txtGRNDate").prop('disabled', true);
			//  document.getElementById("txtGRNDate").readOnly = true;
			 // document.getElementById("txtGRNDate").disabled = true;

		  } */
	});
	
   //Set tab which have Active on form loding
	$(document).ready(function()
	{
		var clientCode='<%=session.getAttribute("clientCode").toString()%>';
		$(".tab_content").hide();
		$(".tab_content:first").show();

		$("ul.tabs li").click(function() 
		{
			$("ul.tabs li").removeClass("active");
			$(this).addClass("active");
			$(".tab_content").hide();
			var activeTab = $(this).attr("data-state");
			$("#" + activeTab).fadeIn();
			
		});
		
		if(clientCode=='382.000')
    	{
			document.getElementById("idConsolidated").style.color = "#d2e3e8";
			document.getElementById("chkConsPO").style.color = "#d2e3e8";
			document.getElementById("chkConsPO").disabled = true;
			document.getElementById("btnFill").style.color = "#d2e3e8";
			document.getElementById("cmbPODoc").style.color = "#d2e3e8";
			document.getElementById("lblPOCode").style.color = "#d2e3e8";
			document.getElementById("idAgainst").style.color = "#d2e3e8";
			document.getElementById("cmbAgainst").style.color = "#d2e3e8";
			 
			document.getElementById("txtExpiry").style.color = "#d2e3e8";
			document.getElementById("lblCurrencyList").style.color = "#d2e3e8";
			document.getElementById("cmbCurrency").style.color = "#d2e3e8";
			document.getElementById("txtDblConversion").style.color = "#d2e3e8";
			
			document.getElementById("lblInwRefNo").style.color = "#d2e3e8";
			document.getElementById("txtInwRefNo").style.color = "#d2e3e8";
			document.getElementById("lblRefDate").style.color = "#d2e3e8";
			document.getElementById("txtRefDate").style.color = "#d2e3e8";
			document.getElementById("lblRejectedQty").style.color = "#d2e3e8";
			document.getElementById("txtRejected").style.color = "#d2e3e8";
			document.getElementById("idlblDCWT").style.color = "#d2e3e8";
			document.getElementById("txtDCWt").style.color = "#d2e3e8";
			document.getElementById("idlblDCQty").style.color = "#d2e3e8";
			document.getElementById("txtDCQty").style.color = "#d2e3e8";
			document.getElementById("idQuantityReceiveable").style.color = "#d2e3e8";
			document.getElementById("txtQtyRec").style.color = "#d2e3e8";
			document.getElementById("idBinNo").style.color = "#d2e3e8";
			document.getElementById("idPOWeight").style.color = "#d2e3e8";
			document.getElementById("txtPOWt").style.color = "#d2e3e8";
			document.getElementById("idlblRework").style.color = "#d2e3e8";
			document.getElementById("txtRework").style.color = "#d2e3e8";
			document.getElementById("idlblPackAndForwording").style.color = "#d2e3e8";
			document.getElementById("txtPack").style.color = "#d2e3e8";
			document.getElementById("idlblRemark").style.color = "#d2e3e8";
			document.getElementById("txtRemark").style.color = "#d2e3e8";
    	}
		//Ajax Wait 
	 	$(document).ajaxStart(function()
	 	{
		    $("#wait").css("display","block");
	  	});
	 	
		$(document).ajaxComplete(function()
		{
		    $("#wait").css("display","none");
		});	  
		funOnChangeCurrency();
		  grneditable="${grneditable}" ;
		  if(grneditable=="false"){
			  $("#txtGRNCode").prop('disabled', true);
		  }
	});
	
</script>

<script type="text/javascript">
	
		//Define Global variable 
		var fieldName,listRow=0;
		var gUOM,gTaxIndicator,gTaxOnGD,gTaxCal,gTaxType;
		var gTaxPer,gTaxAmount;
		var Locrow;
		var groupTaxRow;
		var gPOQty=0;
		var gPOCode="";
		var taxOnTax='N';
		var clientCode='<%=session.getAttribute("clientCode").toString()%>';
		var strOpenTaxCalculation= '<%=session.getAttribute("strOpenTaxCalculation").toString()%>'; 
		
		$(function()
		{
			$("#lblIssueLocation").css('visibility', 'hidden');
			$("#lblIssueLocName").css('visibility', 'hidden');
			$("#txtIssueLocCode").css('visibility', 'hidden');
			 
			//Set date in date picker
			$( "#txtGRNDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
			$( "#txtChallanDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
			$( "#txtDueDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
			$( "#txtRefDate" ).datepicker({ dateFormat: 'dd-mm-yy' });
			$("#lblLocName").text('<%=session.getAttribute("locationName").toString()%>');
				
			if($("#cmbAgainst").val()=="Direct")
			{
				$("#txtQtyRec").attr("disabled", "disabled");
				$("#txtDocCode").css('visibility','hidden');
			}
			
			//Attached document link
			$('a#baseUrl').click(function() 
			{
				if($("#txtGRNCode").val().trim()=="")
				{
					alert("Please Select GRN Code");
					return false;
				}
				window.open('attachDoc.html?transName=frmGRN.jsp&formName=GRN&code='+$('#txtGRNCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
			});
			
			//Tax Add in grid
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
			
			//Generate tax
			$("#btnGenTax").click(function()
			{
				if($("#txtSuppCode").val().trim()=='')
				{
					alert('Please Select Supplier!!!');
					return false;
				}
				funCalculateIndicatorTax();
			});
			
			//Generate tax
			$("#btnGenTaxFrontBtn").click(function()
			{
				if($("#txtSuppCode").val().trim()=='')
				{
					alert('Please Select Supplier!!!');
					return false;
				}
				funCalculateIndicatorTax();
			});
			
					
			$('#txtTaxableAmt').blur(function () 
			{
				funCalculateTaxForSubTotal(parseFloat($("#txtTaxableAmt").val()),taxPer);
			});
		});
		
		
		//Remove all Row from productGrid
		function funRemoveProductRows()
		{
			var table = document.getElementById("tblProduct");
			var rowCount = table.rows.length;
			while(rowCount>0)
			{
				table.deleteRow(0);
				rowCount--;
			}
		}
		
		
		//Fill Product Grid from Against 
		function funFillTableForAgainst(prodCode,prodName,unitPrice,dblTotalPrice,qtyrecevd,code,
				uom,strExpiry,dblDiscount,strIssueLocation,strIsueLocName,strStkble,strReqCode,unitWeight,strMISCode,currValue,strCurrency,freeQuantity) 
		{
			var qtyrecb = parseFloat(qtyrecevd).toFixed(maxQuantityDecimalPlaceLimit);
		    var dcQty = "0";
		    var totalWt = "0";
		    var totalPrice =dblTotalPrice;
		    totalPrice=parseFloat(totalPrice).toFixed(maxAmountDecimalPlaceLimit);
		    unitPrice=parseFloat(unitPrice).toFixed(maxAmountDecimalPlaceLimit);
		    qtyrecevd=parseFloat(qtyrecevd).toFixed(maxQuantityDecimalPlaceLimit);
		    dblDiscount=parseFloat(dblDiscount).toFixed(maxAmountDecimalPlaceLimit);
		    
			var totalweight=unitWeight*qtyrecevd;
		    var table = document.getElementById("tblProduct");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    
		    
			//var cmbCurrency=$("#cmbCurrency").val();
			//var currValue=funGetCurrencyCode(cmbCurrency);
			var groupTaxCode="";
		    var groupTaxName="";
			if(strOpenTaxCalculation=='Y') //if(clientCode=='382.000' || clientCode=='389.001' || clientCode=='211.001' || clientCode=='384.001')
	    	{
		    	 groupTaxCode= $("#txtGroupTaxCode").val();
		    	 groupTaxName=mapForGroupTax.get(groupTaxCode);
		    	 if(groupTaxCode == "No Tax")
	    		 {
		    		 groupTaxCode="";
	    		 }
	    	}
			
		    
		    row.insertCell(0).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strProdCode\" readonly=\"readonly\" class=\"Box prodCode\" size=\"9%\" id=\"txtProdCode."+(rowCount)+"\" value='"+prodCode+"'>";
		    row.insertCell(1).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strProdName\" readonly=\"readonly\" class=\"Box\" size=\"15%\" id=\"lblProdName."+(rowCount)+"\" value='"+prodName+"' >";
		    unitPrice=unitPrice/currValue;
		    dblDiscount=dblDiscount/currValue;
		    totalPrice=totalPrice/currValue;
		    row.insertCell(2).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblQty\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" size=\"6%\" class=\"decimal-places inputText-Auto QtyCell\" id=\"txtQuantity1."+(rowCount)+"\" value='"+qtyrecevd+"' onblur=\"funUpdatePrice(this);\" >";
		    row.insertCell(3).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblFreeQty\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" size=\"7%\" class=\"decimal-places inputText-Auto QtyCell\" id=\"txtFreeQty1."+(rowCount)+"\" value='"+freeQuantity+"' onblur=\"funUpdatePrice(this);\" >";
		    row.insertCell(4).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblRejected\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" size=\"7%\" class=\"decimal-places inputText-Auto RejCell\"id=\"txtRejected."+(rowCount)+"\" value=0 onblur=\"funUpdatePrice(this);\">"; 
		    row.insertCell(5).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strUOM\" readonly=\"readonly\" class=\"Box\" size=\"4%\" id=\"txtUOM."+(rowCount)+"\" value="+uom+">";
		    if($("#hidstrRateEditableYN").val()=="No")
		    {
		    row.insertCell(6).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblUnitPrice\" readonly=\"readonly\"  type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" size=\"6%\" class=\"decimal-places-amt inputText-Auto\" id=\"txtCostRM."+(rowCount)+"\" value='"+unitPrice+"'>";
			}else{
				row.insertCell(6).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblUnitPrice\"  type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" size=\"8%\" class=\"decimal-places-amt inputText-Auto\" id=\"txtCostRM."+(rowCount)+"\" value='"+unitPrice+"'>";	
			}
		    row.insertCell(7).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblDiscount\" type=\"text\" required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\"  size=\"6%\" class=\"decimal-places-amt inputText-Auto\" id=\"txtDiscount."+(rowCount)+"\" value='"+dblDiscount+"' onblur=\"funUpdatePrice(this);\" >";
		    row.insertCell(8).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblTotalPrice\" class=\"Box totalPriceCell\" readonly=\"readonly\" style=\"text-align: right;\" size=\"6%\" id=\"txtTotalPrice."+(rowCount)+"\" value='"+totalPrice+"' >";
		    row.insertCell(9).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"13%\"   id=\"strGroupTaxName."+(rowCount)+"\" value = '"+groupTaxName+"' onclick=funHelp1("+(rowCount)+",'groupTaxCodeForGRN') >";
		    row.insertCell(10).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strRemarks\" style=\"text-align: right;\" size=\"17%\"  id=\"txtRemark."+(rowCount)+"\" value='"+""+"'>";
		    row.insertCell(11).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblQtyRbl\"    required = \"required\" size=\"7%\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" readonly=\"readonly\" class=\"decimal-places inputText-Auto\" id=\"txtQtyRec."+(rowCount)+"\" value='"+qtyrecb+" '>"; 
		    row.insertCell(12).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblDCQty\" type=\"text\"  required = \"required\" size=\"6%\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" class=\"decimal-places inputText-Auto\" id=\"txtDCQty."+(rowCount)+"\" value="+dcQty+">";
		    row.insertCell(13).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblDCWt\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" size=\"6%\" class=\"decimal-places inputText-Auto\" id=\"txtDCWt."+(rowCount)+"\" value=0>";
		    row.insertCell(14).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblWeight\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" size=\"5%\" class=\"decimal-places inputText-Auto\" id=\"txtWtUnit."+(rowCount)+"\" value='"+unitWeight+"'>";
		    
		    row.insertCell(15).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblTotalWt\" class=\"Box totalWeightCell\" readonly=\"readonly\" size=\"6%\" style=\"text-align: right;\"  id=\"txtTotalWeight."+(rowCount)+"\" value="+totalweight+">";
		    row.insertCell(16).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblPackForw\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\"  size=\"6%\" class=\"decimal-places inputText-Auto\" id=\"txtPack."+(rowCount)+"\" value=0 onblur=\"funUpdatePrice(this);\" >";
		    row.insertCell(17).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblPOWeight\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%\"  size=\"6%\" class=\"decimal-places inputText-Auto\" id=\"txtPOWt."+(rowCount)+"\" value=0>";
		    if(strReqCode=="" && strStkble=="Yes")
		    {
				row.insertCell(18).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strIssueLocation\" required = \"required\" class=\"Box IssueLocCode\" size=\"4%\"  id=\"txtIssueLocation."+(rowCount)+"\" onblur=\"funCheckIssueLocation(this)\" value='"+strIssueLocation+"' ><input type=button   onclick=funHelp1("+(rowCount)+",'IssueLoc1') value=...>";
            	row.insertCell(19).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strIsueLocName\" readonly=\"readonly\" class=\"Box\" size=\"13%\"  id=\"txtIsueLocName."+(rowCount)+"\" value='"+strIsueLocName+"' >";
		    }
		    else
		    {
		    	/* row.insertCell(16).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strIssueLocation\" required = \"required\" class=\"Box IssueLocCode\" size=\"9%\"  id=\"txtIssueLocation."+(rowCount)+"\" onblur=\"funCheckIssueLocation(this)\" value='"+strIssueLocation+"' ><input type=button   onclick=funHelp1("+(rowCount)+",'IssueLoc1') value=...>"; */
				row.insertCell(18).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strIssueLocation\" readonly=\"readonly\" class=\"Box IssueLocCode\" size=\"4%\"  id=\"txtIssueLocation."+(rowCount)+"\" value='"+strIssueLocation+"' >";
	        	row.insertCell(19).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strIsueLocName\" readonly=\"readonly\" class=\"Box\" size=\"13%\"  id=\"txtIsueLocName."+(rowCount)+"\" value='"+strIsueLocName+"' >";
		    }
		    row.insertCell(20).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strCode\" readonly=\"readonly\" class=\"Box PoCode\" size=\"10%\" id=\"txtCode."+(rowCount)+"\" value="+code+">";
		    row.insertCell(21).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblRework\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%\" size=\"5%\" class=\"decimal-places inputText-Auto\" id=\"txtRework."+(rowCount)+"\" value=0>";
		    row.insertCell(22).innerHTML= "<input type=\"hidden\" id=\"txtTempTax."+(rowCount)+"\" size=\"0%\" value="+gTaxAmount+">";
		    row.insertCell(23).innerHTML= '<input type="button" value = "Delete" class="deletebutton" onClick="Javacsript:funDeleteRow(this)">'; 
		    row.insertCell(24).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strExpiry\" type=\"hidden\" value = '"+strExpiry+"' >";
			row.insertCell(25).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strStkble\" type=\"hidden\" value = '"+strStkble+"' >";
			row.insertCell(26).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strMISCode\" type=\"hidden\" value = '"+strMISCode+"' >";
			row.insertCell(27).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strGroupTaxCode\" type=\"hidden\"   id=\"groupTaxCode."+(rowCount)+"\" value = '"+groupTaxCode+"' >";
		    
		    funApplyNumberValidation();
		}
		
		
		
		//Check issue Location
		function funCheckIssueLocation(object)
		{
			var index=object.parentNode.parentNode.rowIndex;
			var code=object.value;
			if(code.trim().length!=0)
			{
		    	funSetIssueLoc1(code,index);
			}
		}
		
		
		//Calculating Discount
		function funCalCulateMultiPODiscount()
		{
			if ($('#txtDocCode').val() != "") 
			{
				strCodes = $('#txtDocCode').val();
				var searchUrl = getContextPath()+ "/loadMultiPODiscount.html?POCodes=" + strCodes;
				$.ajax({
						type : "GET",
						url : searchUrl,
						dataType : "json",
						async : false,
						success : function(response)
						{
							$("#txtDiscAmount").val(response.dblDiscount.toFixed(maxAmountDecimalPlaceLimit));
							$("#txtExtraCharges").val(response.dblExtra.toFixed(maxAmountDecimalPlaceLimit));
							
							var totalWeight=0.00;
							var totalPrice=0.00;
							var totalQty=0.00;
							
							$('#tblProduct tr').each(function() {
							    var totalPriceCell = $(this).find(".totalPriceCell").val();
							    var totalQtyCell = $(this).find(".QtyCell").val();
							    var totalWeigthCell = $(this).find(".totalWeightCell").val();
							    var RejQty=$(this).find(".RejCell").val();
							    totalQty=parseFloat(totalQtyCell)+totalQty-parseFloat(RejQty);
							   
								totalPrice=parseFloat(totalPriceCell)+totalPrice;
								totalWeight=parseFloat(totalWeigthCell)+totalWeight;
							 });

							totalQty=parseFloat(totalQty).toFixed(maxAmountDecimalPlaceLimit);
							totalPrice=parseFloat(totalPrice).toFixed(maxAmountDecimalPlaceLimit);
							totalWeight=parseFloat(totalWeight).toFixed(maxAmountDecimalPlaceLimit);
							$("#txtSubTotal").val(totalPrice);
							$("#txtTotalWt").val(totalWeight);
							$("#txtTotalQty").val(totalQty);
							funCalDiscountPercentage();
						},
						error : function(jqXHR, exception)
						{
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

		
		
		//Check Validation before Adding Data in grid
		function btnAdd_onclick() 
	    {
			var strProdCode=$("#txtProdCode").val();
			var cmbPOCode=$("#cmbPODoc").val();
			var totalQty=0;
			if($("#txtProdCode").val().trim().length == 0 && document.getElementById("lblProdName").innerHTML.trim().length == 0){
				alert("Please Enter Product Code Or Search");
				$("#txtProdCode").focus()
				 return false;
			}
			
			if($("#txtQuantity").val().trim().length==0 || $("#txtQuantity").val()==0)
			{
				if(($("#txtFreeQty").val().trim().length==0 || $("#txtFreeQty").val()==0))
				{
					alert("Please Enter Quantity");
					$("#txtQuantity").focus();
					return false;
				}
				
			}
			
			
			if($("#txtCostRM").val().trim().length==0 || $("#txtQuantity").val()==0 )
			{
				if(($("#txtFreeQty").val().trim().length==0 || $("#txtFreeQty").val()==0))
				{
					alert("Please Enter Unit Price");
					$("#txtCostRM").focus();
					return false;
					
				}
				
			}
			if(parseFloat($("#txtRejected").val()) > parseFloat($("#txtQuantity").val()))
			{
				alert("Rejected Quantity con not be greater than Received Quantity");
				$("#txtRejected").focus();
				return false;
			}
			if ($("#cmbAgainst").val() == 'Purchase Order' && cmbPOCode.trim().length>0)
			{
				$('#tblProduct tr').each(function() 
				{
					var prodCode = $(this).find(".prodCode").val(); 
					var totalQtyCell = $(this).find(".QtyCell").val(); 
					var GridPOcode = $(this).find(".PoCode").val();
					if(prodCode==strProdCode && gPOCode==GridPOcode)
					 {
					    totalQty=parseFloat(totalQtyCell)+parseFloat(totalQty);
					 }
				});
			    var POQty=parseFloat(gPOQty)-parseFloat(totalQty);
			    //alert("POQty"+POQty+"totalQty\t"+totalQty);
			    var GRNOrderQty=$("#txtQuantity").val();
			    if(parseFloat(GRNOrderQty)>parseFloat(POQty))
		    	{
		   			alert("GRN Qty can not be > PO Qty");
				    $("#txtQuantity").focus();
				    return false;
				}
			}
			if( $("#hidstrStkble").val()=="Y" && $("#txtIssueLocCode").val()=="")
			{
				alert("Please Enter Issue Location For Non Stockable Item");
				return false;
			}
			else
			{
				funAddRow() ;
			}
			/* if(funDuplicateProduct(strProdCode))
			{
				funAddRow() ;
			} */
		
			var check=$("txtDiscount").val
			if(check.contains=="%")	{
			}else{
			}
		}
		//Check Duplicate Product in grid
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
				    	funResetProductFields();
	    				flag=false;
    				}
				});
		    }
		    return flag;
		}
		
// 		   function allLetter(inputtxt)  
// 		    {  
// 		     var reglet = /^[A-Za-z]+$/;
// 		     if (!/[^a-zA-Z]/.test(inputtxt))
// 		       {  
// 		    	 alert("Please use number only");
// 		        return false;  
// 		       }  
// 		     if (!/[^0-9a-zA-Z]/.test(inputtxt))
// 		       {  
// 		    	 if (!/[^0-9]/.test(inputtxt))
// 			       { 
// 		    		 return true;
// 			       }else{
		    	 
// 				    	 alert("Please use number only");
// 				        return false;  
// 			       }
// 			  }  
		     
// 		    }  
		
		
		//Add Data in grid after click Add Button
		function funAddRow() 
		{
			 var  qtyDecPlace='<%=session.getAttribute("qtyDecPlace").toString()%>';
			  var  amtDecPlace='<%=session.getAttribute("amtDecPlace").toString()%>';
			
		    var prodCode = $("#txtProdCode").val().trim();
		    var prodName = document.getElementById("lblProdName").innerHTML;
		    var unitPrice = $("#txtCostRM").val();
		    unitPrice=parseFloat(unitPrice).toFixed(maxAmountDecimalPlaceLimit);
		    var strUOM=$("#cmbUOM").val()
		    var wtunit = $("#txtWtUnit").val();
		    wtunit=parseFloat(wtunit).toFixed(maxQuantityDecimalPlaceLimit);
		   
		    var qtyrecevd = $("#txtQuantity").val();
		    if($("#txtQuantity").val()=="")
	    	{
		    	qtyrecevd=0;
	    	}
		    
		    qtyrecevd=parseFloat(qtyrecevd).toFixed(qtyDecPlace);
		    
		    var qtyrecb = $("#txtQtyRec").val();
		    qtyrecb=parseFloat(qtyrecb).toFixed(qtyDecPlace);
		    
		    var dcWt = $("#txtDCWt").val();
		    dcWt=parseFloat(dcWt).toFixed(maxQuantityDecimalPlaceLimit);
		    
		    var dcQty = $("#txtDCQty").val();
		    dcQty=parseFloat(dcQty).toFixed(qtyDecPlace);
		    
		    var rejected = $("#txtRejected").val();
		    rejected=parseFloat(rejected).toFixed(maxQuantityDecimalPlaceLimit);
		   
		    var poWt = $("#txtPOWt").val();
		    poWt=parseFloat(poWt).toFixed(maxQuantityDecimalPlaceLimit);
		    
		    var rework = $("#txtRework").val();
		    rework=parseFloat(rework).toFixed(maxQuantityDecimalPlaceLimit);
		    
		    var packforward = $("#txtPack").val();
		    packforward=parseFloat(packforward).toFixed(maxQuantityDecimalPlaceLimit);
		    
		    var remarks = $("#txtRemark").val();
		    var disc = $("#txtDiscount").val();
		   
		    if(disc.indexOf("%")> -1)
		    {
		    	var d=disc.split("%");
		    	disc=unitPrice*qtyrecevd*d[0]/100;
		    }
		    
		 
		    
		    
		    
		    //allLetter(disc) ;
		    // discount per(% symbol checking from regulor exp)
		    
// 		    if (!/[^a-zA-Z]/.test(disc))
// 		       {  
// 		    	 alert("Please use number only");
// 		    	 $("#txtDiscount").val("");
// 		        return false;  
// 		       }  
// 		     if (!/[^0-9a-zA-Z]/.test(disc))
// 		       {  
// 		    	 if (!/[^0-9]/.test(disc))
// 			       { 
// 		    		 return true;
// 			       }else{
		    	 
// 				    	 alert("Please use number only");
// 				    	 $("#txtDiscount").val("");
// 				        return false;  
// 			       }
// 			  }
		    
		    var binNo = $("#txtBinNo").val();
		    var code = gPOCode;
		    var totalWt = qtyrecevd*wtunit;
		    totalWt=parseFloat(totalWt).toFixed(maxQuantityDecimalPlaceLimit);
		    
		    var totalPrice = (parseFloat(qtyrecevd)-parseFloat(rejected)) * parseFloat(unitPrice);
		    totalPrice=parseFloat(totalPrice).toFixed(amtDecPlace)-parseFloat(disc);
			
		    var strExpiry=$("#txtExpiry").val();
		    var strIssueLocCode=$("#txtIssueLocCode").val();
		    var strIssueLocName=$("#lblIssueLocName").text();
		    var strStkble=$("#hidstrStkble").val();
		    var strMISCode="";
		    var freeQuantity  = $("#txtFreeQty").val();
		    freeQuantity=parseFloat(freeQuantity).toFixed(maxQuantityDecimalPlaceLimit);
		    var groupTaxCode="";
		    var groupTaxName="";
		    if(strOpenTaxCalculation=='Y') // if(clientCode=='382.000' || clientCode=='389.001' || clientCode=='211.001' || clientCode=='384.001')
	    	{
		    	 groupTaxCode= $("#txtGroupTaxCode").val();
		    	 groupTaxName=mapForGroupTax.get(groupTaxCode);
		    	 if(groupTaxCode == "No Tax")
	    		 {
		    		 groupTaxCode="";
	    		 }
	    	}
		    var table = document.getElementById("tblProduct");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);		   
		    rowCount=listRow;
		   
		    row.insertCell(0).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strProdCode\" readonly=\"readonly\" class=\"Box prodCode\" size=\"9%\" id=\"txtProdCode."+(rowCount)+"\" value='"+prodCode+"'>";
		    row.insertCell(1).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strProdName\" readonly=\"readonly\" class=\"Box\" size=\"17%\"  id=\"lblProdName."+(rowCount)+"\" value='"+prodName+"' >";
		    row.insertCell(2).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblQty\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" size=\"6%\" class=\"decimal-places inputText-Auto QtyCell\" id=\"txtQuantity1."+(rowCount)+"\" value='"+qtyrecevd+"' onblur=\"funUpdatePrice(this);\">";
		    row.insertCell(3).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblFreeQty\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" size=\"6%\" class=\"decimal-places inputText-Auto QtyCell\" id=\"txtFreeQty1."+(rowCount)+"\" value='"+freeQuantity+"' onblur=\"funUpdatePrice(this);\">";
		    row.insertCell(4).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblRejected\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" class=\"decimal-places inputText-Auto RejCell\" size=\"7%\" id=\"txtRejected."+(rowCount)+"\" value='"+rejected+"' onblur=\"funUpdatePrice(this);\">";
		    row.insertCell(5).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strUOM\" readonly=\"readonly\" class=\"Box\" size=\"5%\" id=\"txtUOM."+(rowCount)+"\" value="+strUOM+">";
		    if($("#hidstrRateEditableYN").val()=="No")
		    {
		    	row.insertCell(6).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblUnitPrice\" readonly=\"readonly\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" class=\"decimal-places-amt inputText-Auto price\" size=\"6%\" id=\"txtCostRM."+(rowCount)+"\" value='"+unitPrice+"' onblur=\"funUpdatePrice(this);\">";
		    }else{
		    	row.insertCell(6).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblUnitPrice\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" class=\"decimal-places-amt inputText-Auto price\" size=\"8%\" id=\"txtCostRM."+(rowCount)+"\" value='"+unitPrice+"' onblur=\"funUpdatePrice(this);\">";
		    }
		    row.insertCell(7).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblDiscount\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" class=\"decimal-places-amt inputText-Auto txtDisc\" size=\"6%\" id=\"txtDiscount."+(rowCount)+"\" value='"+disc+"' onblur=\"funUpdatePrice(this);\">";		    
		    row.insertCell(8).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblTotalPrice\" class=\"Box totalPriceCell\" readonly=\"readonly\" style=\"text-align: right;\" size=\"9%\" id=\"txtTotalPrice."+(rowCount)+"\" value="+totalPrice+">";
		    row.insertCell(9).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"15%\"   id=\"strGroupTaxName."+(rowCount)+"\" value = '"+groupTaxName+"' onclick=funHelp1("+(rowCount)+",'groupTaxCodeForGRN') >";
		    row.insertCell(10).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strRemarks\"  size=\"17%\"  id=\"txtRemark."+(rowCount)+"\" value='"+remarks+"'>";		   
		    row.insertCell(11).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblQtyRbl\" readonly=\"readonly\" type=\"text\"  required = \"required\" size=\"7%\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" class=\"decimal-places inputText-Auto QtyRecable\" id=\"txtQtyRec."+(rowCount)+"\" value='"+qtyrecb+"'>";
		    row.insertCell(12).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblDCQty\" type=\"text\"  required = \"required\" size=\"6%\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" class=\"decimal-places inputText-Auto\" id=\"txtDCQty."+(rowCount)+"\" value='"+dcQty+"'>";
		    row.insertCell(13).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblDCWt\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" size=\"6%\" class=\"decimal-places inputText-Auto\" id=\"txtDCWt."+(rowCount)+"\" value='"+dcWt+"'>";
		    row.insertCell(14).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblWeight\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" size=\"5%\" class=\"decimal-places inputText-Auto\" id=\"txtWtUnit."+(rowCount)+"\" value="+wtunit+">";
		    row.insertCell(15).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblTotalWt\" class=\"Box totalWeightCell\" readonly=\"readonly\" size=\"6%\" style=\"text-align: right;\" id=\"txtTotalWeight."+(rowCount)+"\" value="+totalWt+">";
		    row.insertCell(16).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblPackForw\"type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" class=\"decimal-places inputText-Auto\" size=\"6%\" id=\"txtPack."+(rowCount)+"\" value="+packforward+" onblur=\"funUpdatePrice(this);\">";
		    row.insertCell(17).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblPOWeight\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%\" class=\"decimal-places inputText-Auto\"  size=\"6%\" id=\"txtPOWt."+(rowCount)+"\" value="+poWt+">";		    
		    if(strStkble=="Yes")
		    {
			    row.insertCell(18).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strIssueLocation\" required = \"required\" readonly=\"readonly\" class=\"Box IssueLocCode\" size=\"4%\"  id=\"txtIssueLocation."+(rowCount)+"\" value='"+strIssueLocCode+"' ><input type=button   onclick=funHelp1("+(rowCount)+",'IssueLoc1') value=...>";
			    row.insertCell(19).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strIsueLocName\" readonly=\"readonly\" class=\"Box\" size=\"20%\"  id=\"txtIsueLocName."+(rowCount)+"\" value='"+strIssueLocName+"' >";
		    }
		    else
		    {
		    	row.insertCell(18).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strIssueLocation\" readonly=\"readonly\" class=\"Box IssueLocCode\" size=\"4%\"  id=\"txtIssueLocation."+(rowCount)+"\" value='"+strIssueLocCode+"' >";
			    row.insertCell(19).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strIsueLocName\" readonly=\"readonly\" class=\"Box\" size=\"20%\"  id=\"txtIsueLocName."+(rowCount)+"\" value='"+strIssueLocName+"' >";
		    } 
		    row.insertCell(20).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strCode\" readonly=\"readonly\" class=\"Box PoCode\" size=\"10%\" id=\"txtCode."+(rowCount)+"\" value="+code+">";		    
		    row.insertCell(21).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblRework\" type=\"text\" required = \"required\" style=\"text-align: right;width:100%\" class=\"decimal-places inputText-Auto\" size=\"5%\" id=\"txtRework."+(rowCount)+"\" value="+rework+">";
		    row.insertCell(22).innerHTML= "<input type=\"hidden\" id=\"txtTempTax."+(rowCount)+"\" size=\"0%\" value="+gTaxAmount+">";
		    row.insertCell(23).innerHTML= '<input type="button" value = "Delete" class="deletebutton" onClick="Javacsript:funDeleteRow(this)">';
		    row.insertCell(24).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strExpiry\" type=\"hidden\" value = '"+strExpiry+"' >";
		    row.insertCell(25).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strStkble\" type=\"hidden\" value = '"+strStkble+"' >";
		    row.insertCell(26).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strMISCode\" type=\"hidden\" value = '"+strMISCode+"' >";
		    row.insertCell(27).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strGroupTaxCode\" type=\"hidden\"   id=\"groupTaxCode."+(rowCount)+"\" value = '"+groupTaxCode+"' >";

		    listRow++;
		    funUpdateIssueUOM();
		    funResetProductFields();
		    funGetTotal();
		    
		    funApplyNumberValidation();
		    $("#txtProdCode").focus();
		    return false;
		}
		 
		
		
		function uniCharCode(event) {
		    var keyCode = event.keyCode;
		    if(keyCode==13)
		    {
		    	alert(keyCode);	
		    }
		}		
		
		
		
		//Update UOM in product Master when user Change the UOM From GRN 
		function funUpdateIssueUOM()
		{
			var strProdCode = $("#txtProdCode").val();				
			var strUOM=$("#cmbUOM").val();
			if(strUOM!="")
			{
				var transaction="PO";
				var searchUrl=getContextPath()+"/updateUOMData.html?strProdCode="+strProdCode+"&strUOM="+strUOM+"&transaction="+transaction;
				$.ajax({			
		        	type: "GET",
			        url: searchUrl,
			        dataType: "text",
			        success: function(response)
			        {	
			        	//alert(response);
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
		
		//Update price when user chenge the qty and also Check the validation
		function funUpdatePrice(object)
		{
			var index=object.parentNode.parentNode.rowIndex;
			var QtyRecable=document.getElementById("txtQtyRec."+index).value;
			var RecQty=document.getElementById("txtQuantity1."+index).value;
			var RejQty=document.getElementById("txtRejected."+index).value;
			
			if(parseFloat(RejQty) > parseFloat(RecQty) )
			{
				alert("Rejected qty can not be greater than Receive qty");
				document.getElementById("txtRejected."+index).value=("0.00");
				return false;
			}
				
			RecQty=parseFloat(RecQty)-parseFloat(RejQty);
			var price=parseFloat(document.getElementById("txtCostRM."+index).value)*parseFloat(RecQty);			
			var dicount=parseFloat(document.getElementById("txtDiscount."+index).value);
			var pF=parseFloat(document.getElementById("txtPack."+index).value);
			price=parseFloat(price)+parseFloat(pF)-parseFloat(dicount);
			document.getElementById("txtTotalPrice."+index).value=parseFloat(price).toFixed(maxAmountDecimalPlaceLimit);
			funGetTotal();
		}
		
		//Calculating Discount
		function funCalDiscountAmt()
		{
			var dicPer=0;
			if($("#txtDiscPer").val()!="")
				{
					dicPer=$("#txtDiscPer").val();
				}
			var subtotal=$("#txtSubTotal").val();
			var discountAmt=parseFloat(dicPer)*(parseFloat(subtotal)/100);
			$("#txtDiscAmount").val(parseFloat(discountAmt).toFixed(maxAmountDecimalPlaceLimit));
			funGetFinalAmt();			
		}
		
		//Calculating discount percentage
		function funCalDiscountPercentage()
		{
			var dicAmt=0;
			if($("#txtDiscAmount").val()!="")
			{
				dicAmt=$("#txtDiscAmount").val();
			}
			var subtotal=$("#txtSubTotal").val();
			if(subtotal!=0)
			{
				var discountPer=(parseFloat(dicAmt)/(parseFloat(subtotal))*100);
				$("#txtDiscPer").val(parseFloat(discountPer).toFixed(maxAmountDecimalPlaceLimit));
				funGetFinalAmt();
			}
			else
			{
				$("#txtDiscPer").val("0.0");
			}
		}
		
		
		//Calculating final Amount	
		function funGetFinalAmt()
		{
			var subtotal=$("#txtSubTotal").val();
			var taxAmt=$("#txtGRNTaxAmt").val();
			var discountAmt=0;
			var extraCharges=0;
			var lessAmt=0;
			if($("#txtDiscAmount").val()!="")
			{
				discountAmt=parseFloat($("#txtDiscAmount").val());
			}
			if($("#txtExtraCharges").val()!="")
			{
				extraCharges=parseFloat($("#txtExtraCharges").val());
			}
			if($("#txtLessAmt").val()!="")
			{
				lessAmt=parseFloat($("#txtLessAmt").val());
			}
			var finalAmt=(parseFloat(subtotal) + parseFloat(extraCharges) + parseFloat(taxAmt))- parseFloat(lessAmt)-parseFloat(discountAmt);
		
			finalAmt=parseFloat(finalAmt).toFixed(maxAmountDecimalPlaceLimit);
			var roundOff=0.0;
			var finalAmtWithRoundoff=Math.round(finalAmt);
			roundOff=(parseFloat(finalAmtWithRoundoff)-parseFloat(finalAmt)).toFixed(maxAmountDecimalPlaceLimit);
			/* if((Math.round(finalAmt))>finalAmt)
			{
				roundOff=-((Math.round(finalAmt))-finalAmt);
				
			}else{
				
				roundOff=finalAmt-(Math.round(finalAmt));
			} */
			
    		$("#hidRoundOff").val(roundOff)
			
			if(strRoundOffFinalAmtOnTransaction){
				$("#txtFinalAmt").val(finalAmtWithRoundoff);	
			}else{
				$("#txtFinalAmt").val(finalAmt);
			}
			finalAmt=Math.round(finalAmt);
			$("#lblGRNGrandTotal").text(finalAmtWithRoundoff);
			funCalculateOtherChargesTotal();
			//HELLO
		}
		
		//Calculating subtotal amount
		function funGetTotal()
		{
			var totalWeight=0.00;
			var totalPrice=0.00;
			var totalQty=0.00;
			
			$('#tblProduct tr').each(function() {
			    var totalPriceCell = $(this).find(".totalPriceCell").val();
			    var totalQtyCell = $(this).find(".QtyCell").val();
			    var totalWeigthCell = $(this).find(".totalWeightCell").val();
			    var RejQty=$(this).find(".RejCell").val();
			    totalQty=parseFloat(totalQtyCell)+totalQty-parseFloat(RejQty);
			   
				totalPrice=parseFloat(totalPriceCell)+totalPrice;
				totalWeight=parseFloat(totalWeigthCell)+totalWeight;			  
			 });

			totalQty=parseFloat(totalQty).toFixed(maxAmountDecimalPlaceLimit);
			totalPrice=parseFloat(totalPrice).toFixed(maxAmountDecimalPlaceLimit);
			totalWeight=parseFloat(totalWeight).toFixed(maxAmountDecimalPlaceLimit);
			$("#txtSubTotal").val(totalPrice);
			$("#txtTotalWt").val(totalWeight);
			$("#txtTotalQty").val(totalQty);
			funCalDiscountAmt();
			funCalculateOtherChargesTotal();
		}
		
		//Delete particular row when click on delete button on product 
		function funDeleteRow(obj)
		{
		    var index = obj.parentNode.parentNode.rowIndex;
		    var table = document.getElementById("tblProduct");
		    table.deleteRow(index);
		    funGetTotal();
		}

		//After deleting tax calculating total amount
		function funDeleteRowOfFixedAmtTax(obj)
		{
		    var index = obj.parentNode.parentNode.rowIndex;
		    var table = document.getElementById("tblTaxOnFixedAmt");
		    table.deleteRow(index);
		    funGetTotal();
		}
		
		//Remove all rows
		function funRemProdRows()
		{
			var table = document.getElementById("tblProduct");
			var rowCount = table.rows.length;
			while(rowCount>0)
			{
				table.deleteRow(0);
				rowCount--;
			}
		}
		
		//Set defalut value when click on reset field
		function funResetProductFields()
		{
			$("#txtProdCode").val('');
		    $("#lblProdName").text('');
		    $("#txtCostRM").val('0');
		    $("#txtWtUnit").val('0');
		    $("#txtStock").val('0');
		    $("#txtQuantity").val('');
		    $("#txtDiscount").val('0');
		    $("#txtRejected").val('0');
		    $("#txtDCWt").val('0');
		    $("#txtDCQty").val('0');
		    $("#txtQtyRec").val('0');
		    $("#txtBinNo").val('');
		    $("#txtPOWt").val('0');
		    $("#txtRework").val('0');
		    $("#txtPack").val('0');
		    $("#txtRemark").val('');
		    $("#cmbUOM").val("");
		    $("#txtIssueLocCode").val("");
		    $("#lblIssueLocName").text('');
		    $("#hidstrStkble").val(""); 
		    
		    $("#lblIssueLocation").css('visibility', 'hidden');
			$("#lblIssueLocName").css('visibility', 'hidden');
			$("#txtIssueLocCode").css('visibility', 'hidden');
			
		    $("#txtProdCode").focus();
		}
			
		
		/**
		 * Check duplicate document code
		 */
		function funCheckDupDocCode(docCode)
		{
			var codes=$("#txtDocCode").val();
			var arrCodes=codes.split(",");
			for(var i=0;i<arrCodes.length;i++)
			{
				if(arrCodes[i]==docCode)
				{
					return false;
				}
			}
			//alert("End Of For");
			return true;
		}
		
		
		//Open purchase help
		function funOpenHelp()
		{
			if ($("#cmbAgainst").val() == 'Purchase Order')
			{
				var location=$("#txtLocCode").val();
				var POCode=$("#cmbPODoc").val();
				//alert(POCode);
				if(POCode.trim().length>0)
				{
					fieldName = "prodforPO";
					transactionName=fieldName;
				//	window.showModalDialog("searchform.html?formname="+transactionName+"&POCode="+POCode+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
					window.open("searchform.html?formname="+transactionName+"&POCode="+POCode+"&locationCode="+location+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;top=500,left=500")
				}
			}
			/* if($("#cmbAgainst").val() == 'Invoice')
				{
					var POCode=$("#cmbPODoc").val();
					//alert(POCode);
					if(POCode.trim().length>0)
					{
						fieldName = "invoice";
						transactionName=fieldName;
					//	window.showModalDialog("searchform.html?formname="+transactionName+"&POCode="+POCode+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
						window.open("searchform.html?formname="+transactionName+"&POCode="+POCode+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;top=500,left=500")
					}
				} */
			
			
			else
			{
				funHelp("productInUse");
			}
		}
		
		//Open common Help 
		function funHelp(transactionName)
		{
			fieldName=transactionName;
			//alert("sd");
			if(fieldName=='productInUse')
			{
				if($("#txtLocCode").val()=='')
				{
					alert("Please Select Location");
				}
				else
				{
					var location=$("#txtLocCode").val();
					var searchProd="RawProduct";
			       // window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
				window.open("searchform.html?formname="+searchProd+"&locationCode="+location+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;top=500,left=500")
				}
			}
			else
			{
				if(transactionName=="Issuelocationmaster")
				{
					transactionName="locationmaster";
				}
			//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
			window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;top=500,left=500")
			}
	    }
		
		//Open issue Location help form
		function funHelp1(row,transactionName)
		{
			
			
			
			if(transactionName=='IssueLoc1')
			{
				Locrow=row;
				fieldName = transactionName;
				transactionName="locationmaster";
			}
			if(transactionName=='groupTaxCodeForGRN')
			{
				groupTaxRow=row;
				fieldName = transactionName;

			}
			// window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
			 window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;top=500,left=500")
		}
		
		//Set data on the basis of help or selection 
		function funSetData(code)
		{
			switch (fieldName) 
			{
			    case 'grncode':
			    	funLoadGRNHd(code);
			        break;
			        
			    case 'locationmaster':
			    	funSetLocation(code);
			        break;
			        
			    case 'productInUse':
			    	funSetProduct(code);
			        break;
			        
			    case 'suppcodeActive':
			    	funSetSupplier(code);
			        break;
			    
			    case 'PRCodeAgainstGRN':
			    	funSetPurchaseReturn(code);
			        break;
			        
			    case 'SRCodeAgainstGRN':
			    	funSetSalesReturn(code);
			        break;
			        
			    case 'ShortSupplyAgainstGRN':
			    	funSetShortSupplyPO(code);
			        break;
			        
			    case 'OpenTaxesForPurchase':
			    	funSetTax(code);
			    	break;
			    	
			    case 'Issuelocationmaster':
			    	funSetIssueLocation(code);
			        break;
			        
			    case 'IssueLoc1':
			    	funSetIssueLoc1(code,Locrow);
			        break; 
			    case 'prodforPO':
			    	funSetProductForPO(code);
			        break;
			        
			    case 'dsCodeAgainstGRN':
			    	funSetDSCode(code);
			        break; 
			        
			    case 'grnslip':
			    	funLoadGRNSlip(code);
			        break;
			    case 'groupTaxCodeForGRN':
			    	funSetgroupTaxCodeForGRN(code,groupTaxRow);
			        break; 
			        
			    /* case 'invoice':
			    	funSetInvoice(code);
			        break;   */  
			        
			}
		}
		
		function funSetInvoice(code)
		{
			var currValue=$("#txtDblConversion").val();
    		if(currValue==null ||currValue==''||currValue==0)
    		{
    		  currValue=1;
    		}
			
			gurl=getContextPath()+"/loadInvoiceHdDataForGRN.html?invCode="+code;
				$.ajax({
			        type: "GET",
			        url: gurl,
			        dataType: "json",
			        success: function(response)
			        {		        	
			        		if('Invalid Code' == response.strInvCode){
			        			alert("Invalid  Invoice Code");
			        			$("#txtDocCode").val('');
			        			$("#txtDocCode").focus();
			        			
			        		}else{	
			        			funRemProdRows();
			        			$("#txtDocCode").val(code);
			        			var count=0;
								$.each(response.listclsInvoiceModelDtl, function(i,item)
				       	       	    	 {
											count=i;
												funAddProductForGRN(item.strProdCode, item.strProdName,item.strUOM, (item.dblUnitPrice).toFixed(maxAmountDecimalPlaceLimit), item.dblWeight
														,item.dblQty, item.dblQty, 0.0,item.dblQty, 0.0,0.0
														,0.0,0.0, '', 0.00, '',0.00
														,(item.dblQty*item.dblUnitPrice).toFixed(maxAmountDecimalPlaceLimit),'N','','',''
														,'','','');
				       	       	    	 });
								listRow=count+1;
								funGetQtyTotal();
								funGetTotal();
								
								
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
		
		//Set PO product data   
		function funSetProductForPO(code)
		{
			var searchUrl="";
			var POCode=$("#cmbPODoc").val();
			var suppCode=$("#txtSuppCode").val();
			var billDate=$("#txtGRNDate").val();
			searchUrl=getContextPath()+"/loadProductDataForPOTrans.html?prodCode="+code+"&POCode="+POCode+"&billDate="+billDate+"&suppCode="+suppCode;
			//alert(searchUrl);
			$.ajax({
				type : "GET",
				url : searchUrl,
				async: false,
				dataType : "json",
				success : function(response) {

					if ('Invalid Code' == response.strProdCode) {
						alert('Invalid Product Code');
						$("#txtProdCode").val('');
						$("#lblProdName").text('');
						$("#txtProdCode").focus();
					} else 
					{
					  	var currValue=$("#txtDblConversion").val();
			    		if(currValue==null ||currValue==''||currValue==0)
			    		{
			    		  currValue=1;
			    		}
			    		$('#txtCostRM').attr('readonly', false);
						$("#txtProdCode").val(response[0]);
						document.getElementById("lblProdName").innerHTML = response[1];
						$("#txtCostRM").val(response[2]/currValue);
						$("#txtWtUnit").val(response[3]);
						$("#txtBinNo").val(response[4]);
						$("#cmbUOM").val(response[5]);
						$("#txtExpiry").val(response[6]);
						$("#hidstrStkble").val(response[7]);
						$("#txtQtyRec").val(response[8]);
						if($("#hidstrRateEditableYN").val()=="No")
						{
							// Rate Editable false     
							$('#txtCostRM').attr('readonly', true);
						}
						gPOQty=response[8];
						gPOCode=response[9];
						if(response[7]=="Yes")
							{
								$("#lblIssueLocation").css('visibility', 'visible');
								$("#lblIssueLocName").css('visibility', 'visible');
								$("#txtIssueLocCode").css('visibility', 'visible');
								$("#txtIssueLocCode").focus();
							}
						else
							{
								$("#lblIssueLocation").css('visibility', 'hidden');
								$("#lblIssueLocName").css('visibility', 'hidden');
								$("#txtIssueLocCode").css('visibility', 'hidden');
								$("#txtQuantity").focus();
							}
						
						var strProdCode=response[0];
						var table = document.getElementById("tblProduct");
					    var rowCount = table.rows.length;		   
					    var totalQty=0;
					    if(rowCount > 0)
				    	{
					    	$('#tblProduct tr').each(function() {
						    	var prodCode = $(this).find(".prodCode").val(); 
							    var totalQtyCell = $(this).find(".QtyCell").val(); 
							    var GridPOcode = $(this).find(".PoCode").val();
							    if(prodCode==strProdCode && gPOCode==GridPOcode)
							    {
							    	totalQty=parseFloat(totalQtyCell)+parseFloat(totalQty);
							    }
							});
				    	}
					    var POQty=parseFloat(gPOQty)-parseFloat(totalQty);
					    $("#txtQuantity").val(POQty);
					    //Contract Rate Editable
					    /* if(response[12]=="Contract Rate Amt")
						{
							$('#txtCostRM').attr('readonly', true);
						} */
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
	
	
	
		
		//Change and set issue location when user location change in grid
		function funSetIssueLoc1(code,Locrow)
		{
			var flag=0;
			var searchUrl="";  
			searchUrl = getContextPath()
			+ "/loadLocationMasterData.html?locCode=" + code;
			$.ajax({
			        type: "GET",
			        url: searchUrl,
			        async : true,
				    dataType: "json",
				    success: function(response)
				    {
				    	if(response.strLocCode!="Invalid Code")
			    		{
				    		document.getElementById("txtIssueLocation."+Locrow).value=response.strLocCode;						
			    			document.getElementById("txtIsueLocName."+Locrow).value=response.strLocName;
			    			
			    		}
				    	else
			    		{
			    			alert("Invalid Issue Location Code");
			    			document.all("txtIssueLocation."+Locrow).value="";
			    			document.all("txtIssueLocation."+Locrow).focus();
			    			return false;
			    		}
				    },
				    error: function(jqXHR, exception)
				    {
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
		
		//Get and set issue Location when user select Non stockable item Directly  
		function funSetIssueLocation(code)
		{
			var searchUrl = "";
			searchUrl = getContextPath()+ "/loadLocationMasterData.html?locCode=" + code;
			$.ajax({
				type : "GET",
				url : searchUrl,
				dataType : "json",
				success : function(response) {
					if (response.strLocCode == 'Invalid Code') {
						alert("Invalid Location Code");
						$("#txtIssueLocCode").val('');
						$("#lblIssueLocName").text("");
						$("#txtIssueLocCode").focus();
					} else {
						$("#txtIssueLocCode").val(response.strLocCode);
						$("#lblIssueLocName").text(response.strLocName);
						$("#txtQuantity").focus();
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
		
		//calculating tax based on Tax Indicator 
		function funCalculateIndicatorTax()
		{
			var prodCodeForTax="";
			var currValue=$("#txtDblConversion").val();
    		if(currValue==null ||currValue==''||currValue==0)
    		{
    		  currValue=1;
    		}
			funRemoveTaxRows();
			var table = document.getElementById("tblProduct");
		    var rowCount = table.rows.length;
		    for(var cnt=0;cnt<rowCount;cnt++)
		    {
		    	var prodCode=document.getElementById("txtProdCode."+cnt).value;
		    	var suppCode=$("#txtSuppCode").val();
		    	var discPer=0;
		    	if($("#txtDiscPer").val()=='')
		    	{}
		    	else
		    	{
		    		discPer=parseFloat($("#txtDiscPer").val());
		    	}
		    	var taxableAmount=parseFloat(document.getElementById("txtTotalPrice."+cnt).value);
		    	var discAmt=(taxableAmount*discPer)/100;
		    	taxableAmount=taxableAmount-discAmt;
		    	
		    	var qty=parseFloat(document.getElementById("txtQuantity1."+cnt).value);		    	
		    	var unitPrice=parseFloat(document.getElementById("txtCostRM."+cnt).value);
		    	var discAmt1=parseFloat(document.getElementById("txtDiscount."+cnt).value);
		    	var GroupTaxCode=document.getElementById("groupTaxCode."+cnt).value;
                if(GroupTaxCode == "No Tax")
               	{
                	GroupTaxCode="";
               	}
		    	/*var qty=parseFloat($(this).find(".QtyCell").val());
		    	var discAmt1=parseFloat($(this).find(".txtDisc").val());
		    	var unitPrice=parseFloat($(this).find(".price").val());*/
	    	    if(strOpenTaxCalculation=='Y')   //if(clientCode=='382.000' || clientCode=='389.001' || clientCode=='211.001' || clientCode=='384.001' )
		    	{
	    	    	var weight=0;
			    	prodCodeForTax=prodCodeForTax+"!"+prodCode+","+unitPrice+","+suppCode+","+qty+","+discAmt1+","+weight+","+GroupTaxCode;
		    	}
	    	    else
	    	    {
			    	prodCodeForTax=prodCodeForTax+"!"+prodCode+","+unitPrice+","+suppCode+","+qty+","+discAmt1;
	    	    }	
		    	//alert(prodCodeForTax);
		    }
		    
		    prodCodeForTax=prodCodeForTax.substring(1,prodCodeForTax.length).trim();
		    
		    var dteGrn =$("#txtGRNDate").val();
		    var arrdtGrn=dteGrn.split("-");
		    dteGrn=arrdtGrn[2]+"-"+arrdtGrn[1]+"-"+arrdtGrn[0];
		    var CIFAmt=$("#txtCIF").val();
		    var settlement='';
		    $.ajax({
				type: "GET",
			    url: getContextPath()+"/getTaxDtlForProduct.html?prodCode="+prodCodeForTax+"&taxType=Purchase&transDate="+dteGrn+"&CIFAmt="+CIFAmt+"&strSettlement="+settlement,
			    dataType: "json",
			    success: function(response)
			    {
			    	$.each(response, function(i,item)
				    {
			    		var spItem=item.split('#');
			       		if(spItem[1]=='null')
			       		{}
			       		else
				    	{
			       			var taxableAmt=parseFloat(spItem[0]);
				       		var taxCode=spItem[1];
				        	var taxDesc=spItem[2];
				        	var taxPer1=parseFloat(spItem[4]);
				        	//var taxAmt=(taxableAmt*taxPer1)/100;
				        	var taxAmt=parseFloat(spItem[5]);
				        	funAddTaxRow1(taxCode,taxDesc,taxableAmt,taxAmt);
				    	}
				    });
			    	funCalTaxTotal();
			    	
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
		//get and set Tax 
		function funGetTaxForCheckTaxOnTax(code)
		{
			$.ajax({
			   		type: "GET",
			        url: getContextPath()+"/loadTaxMasterData.html?taxCode="+code,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strTaxOnTax=='Y')
			        		{
			        		taxOnTax=response.strTaxOnTax;	
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
		
		
		//get and set Tax 
		function funSetTax(code)
		{
			$.ajax({
			   		type: "GET",
			        url: getContextPath()+"/loadTaxMasterData.html?taxCode="+code,
			        dataType: "json",
			        success: function(response)
			        {
			         
			        	taxOnTax='N';
			        	$("#txtTaxCode").val(code);
			        	$("#lblTaxDesc").text(response.strTaxDesc);
			        	$("#txtTaxableAmt").val($("#txtSubTotal").val());
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
		
		//Calculating Tax Subtotal
		function funCalculateTaxForSubTotal(taxableAmt,taxPercent)
		{
		
			var taxAmt=((taxableAmt)*taxPercent/100);
			taxAmt=taxAmt.toFixed(2);
			$("#txtTaxAmt").val(taxAmt);
		}
		
		//Add tax in Grid
		function funAddTaxRow() 
		{
			var taxCode = $("#txtTaxCode").val();
			var taxDesc=$("#lblTaxDesc").text();
		    var taxableAmt = Math.round($("#txtTaxableAmt").val());
		    var taxAmt=Math.round($("#txtTaxAmt").val());
	
		    var table = document.getElementById("tblTax");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    
		    row.insertCell(0).innerHTML= "<input class=\"Box\" size=\"15%\" name=\"listGRNTaxDtl["+(rowCount)+"].strTaxCode\" id=\"txtTaxCode."+(rowCount)+"\" value='"+taxCode+"' >";
		    row.insertCell(1).innerHTML= "<input class=\"Box\" size=\"22%\" style=\"margin-left: -17%;\" name=\"listGRNTaxDtl["+(rowCount)+"].strTaxDesc\" id=\"txtTaxDesc."+(rowCount)+"\" value='"+taxDesc+"'>";		    	    
		    row.insertCell(2).innerHTML= "<input type=\"number\" class=\"Box\" step=\"any\" required = \"required\" style=\"text-align: right;border: 1px solid #a2a2a2;padding: 1px;margin-left: -70%;width: 164%;\" size=\"20.5%\" name=\"listGRNTaxDtl["+(rowCount)+"].strTaxableAmt\" id=\"txtTaxableAmt."+(rowCount)+"\" value="+taxableAmt+">";
		    row.insertCell(3).innerHTML= "<input type=\"number\" class=\"Box\" step=\"any\" required = \"required\" style=\"text-align: right;border: 1px solid #a2a2a2;padding: 1px;\" size=\"15.5%\" name=\"listGRNTaxDtl["+(rowCount)+"].strTaxAmt\" id=\"txtTaxAmt."+(rowCount)+"\" value="+taxAmt+">";		    
		    row.insertCell(4).innerHTML= '<input type="button" size=\"6%\" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteTaxRow(this)" >';
		    
		    funCalTaxTotal();
		    funClearFieldsOnTaxTab();
		    
		    return false;
		}
		
		
	/* 	function funCalTaxTotalForBlankIndi()
		{
			var totalTaxAmt=0,totalTaxableAmt=0;
			var table = document.getElementById("tblTax");
			var rowCount = table.rows.length;
			var subtotal=0;
			for(var i=0;i<rowCount;i++)
			{
				totalTaxableAmt=parseFloat(document.getElementById("txtTaxableAmt."+i).value)+totalTaxableAmt;
				totalTaxAmt=parseFloat(document.getElementById("txtTaxAmt."+i).value)+totalTaxAmt;
				subtotal=parseFloat(document.getElementById("txtTaxableAmt."+i).value);
			}
			
			totalTaxableAmt=totalTaxableAmt.toFixed(2);
			totalTaxAmt=totalTaxAmt.toFixed(2);
			var grandTotal=parseFloat(totalTaxableAmt)+parseFloat(totalTaxAmt);
			grandTotal=grandTotal.toFixed(2);
			$("#lblTaxableAmt").text(subtotal);
			$("#lblTaxTotal").text(totalTaxAmt);
			
			$("#lblGRNGrandTotal").text(grandTotal);
			$("#txtGRNTaxAmt").val(totalTaxAmt);
			
			funGetFinalAmt();			
		} */
		
		//filling tax in Grid
		function funAddTaxRow1(taxCode,taxDesc,taxableAmt,taxAmt) 
		{	
		    var table = document.getElementById("tblTax");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
			
		    taxableAmt=taxableAmt.toFixed(2);
		    taxAmt=taxAmt.toFixed(2);
    	
		    row.insertCell(0).innerHTML= "<input class=\"Box\" size=\"15%\" name=\"listGRNTaxDtl["+(rowCount)+"].strTaxCode\" id=\"txtTaxCode."+(rowCount)+"\" value='"+taxCode+"' >";
		    row.insertCell(1).innerHTML= "<input class=\"Box\" size=\"22%\" style=\"margin-left: -17%;\" name=\"listGRNTaxDtl["+(rowCount)+"].strTaxDesc\" id=\"txtTaxDesc."+(rowCount)+"\" value='"+taxDesc+"'>";		    	    
		    row.insertCell(2).innerHTML= "<input type=\"number\" step=\"any\" required = \"required\" style=\"text-align: right;border: 1px solid #a2a2a2;padding: 1px;margin-left: -70%;width: 164%;\" size=\"20.5%\" name=\"listGRNTaxDtl["+(rowCount)+"].strTaxableAmt\" id=\"txtTaxableAmt."+(rowCount)+"\" value="+taxableAmt+">";
		    row.insertCell(3).innerHTML= "<input type=\"number\" step=\"any\" required = \"required\" style=\"text-align: right;border: 1px solid #a2a2a2;padding: 1px;/* margin-left: 0%; */;\" size=\"15.5%\" name=\"listGRNTaxDtl["+(rowCount)+"].strTaxAmt\" id=\"txtTaxAmt."+(rowCount)+"\" value="+taxAmt+">";		    
		    row.insertCell(4).innerHTML= '<input type="button" size=\"6%\" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteTaxRow(this)" >';
		    
		    funGetTaxForCheckTaxOnTax(taxCode);
		    funCalTaxTotal();
		    funClearFieldsOnTaxTab();
		    
		    return false;
		}
		
		//Calculating tax
		function funCalTaxTotal()
		{
			var totalTaxAmt=0,totalTaxableAmt=0;
			var table = document.getElementById("tblTax");
			var rowCount = table.rows.length;
			var subtotal=0;
			for(var i=0;i<rowCount;i++)
			{
			//	funGetTaxForCheckTaxOnTax(document.getElementById("txtTaxCode."+i).value);
				
				totalTaxableAmt=parseFloat(document.getElementById("txtTaxableAmt."+i).value)+totalTaxableAmt;
				totalTaxAmt=parseFloat(document.getElementById("txtTaxAmt."+i).value)+totalTaxAmt;
				subtotal=parseFloat(document.getElementById("txtTaxableAmt."+i).value);
			}
			
			totalTaxableAmt=totalTaxableAmt.toFixed(2);
			totalTaxAmt=totalTaxAmt.toFixed(2);
			var grandTotal=parseFloat(totalTaxableAmt)+parseFloat(totalTaxAmt);
			grandTotal=grandTotal.toFixed(2);
			
			if(taxOnTax=='Y')
				{
					$("#lblTaxableAmt").text(totalTaxableAmt);
				}else
					{
					$("#lblTaxableAmt").text(subtotal);
					}
			
			$("#lblTaxTotal").text(totalTaxAmt);
			
			$("#lblGRNGrandTotal").text(grandTotal);
			$("#txtGRNTaxAmt").val(totalTaxAmt);
			
			funGetFinalAmt();			
		}
		
		
		function funClearFieldsOnTaxTab()
		{
			$("#txtTaxCode").val("");
			$("#lblTaxDesc").text("");
			$("#txtTaxableAmt").val("");
			$("#txtTaxAmt").val("");
			$("#txtTaxCode").focus();
		}
		/**
		 * Delete a particular tax row 
		**/
		function funDeleteTaxRow(obj) 
		{
		    var index = obj.parentNode.parentNode.rowIndex;
		    var table = document.getElementById("tblTax");
			table.deleteRow(index);
			funCalTaxTotal();
		}
		
		/**
		 * Remove a All tax row 
		**/
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
		
	
		//Textfiled On blur geting data
		$(function() {
			
			$('#txtGRNCode').blur(function() {
				var code = $('#txtGRNCode').val();
				if(code.trim().length > 0 && code !="?" && code !="/")
				{
					funLoadGRNHd(code);
				}
			});

			$('#txtSuppCode').blur(function() {
				var code = $('#txtSuppCode').val();
				if(code.trim().length > 0 && code !="?" && code !="/"){
					funSetSupplier(code);
				}
			});

			$('#txtLocCode').blur(function() {
				var code = $('#txtLocCode').val();
				if(code.trim().length > 0 && code !="?" && code !="/"){
					funSetLocation(code);
				}
			});
			
			$('#txtDocCode').blur(function() {
				var code = $('#txtDocCode').val();
				if(code.trim().length > 0 && code !="?" && code !="/")
				{
					if(($("#cmbAgainst").val()=="Invoice"))
						{
						funSetInvoice(code);
						}
					
				}
			});
			
			
			$('#txtProdCode').keydown(function(e){
				var code=$('#txtProdCode').val();
				if (e.which == 9){
				  	if (code.trim().length > 8) {
				  		funSetProduct(code);
				  	}
				  	
				}
				if(e.which == 13)
				{
					if(code.trim().length > 8 )
					{
						 funCallBarCodeProduct(code)
					}else if (code.trim().length > 0)
			  		{
			  			funSetProduct(code);
			  		}
				}
			});

			$('#txtProdCode').blur(function() {
				var code = $('#txtProdCode').val();
				if ($("#cmbAgainst").val() == 'Purchase Order')
				{
					var POCode=$('#cmbPODoc').val();
					if(POCode.trim().length > 0)
					{
						if (code.trim().length > 0)
						{
							funSetProductForPO(code);
						}
					}
				}
				else
				{
					if(code.trim().length > 0 && code !="?" && code !="/"){
						funSetProduct(code);
					}
				}
			});
			
			$('#txtIssueLocCode').blur(function() {
				var code = $('#txtIssueLocCode').val();
				if(code.trim().length > 0 && code !="?" && code !="/"){
					funSetIssueLocation(code);
				}
			});
		});
		
		

		//Get and set GRNHd data
		function funLoadGRNHd(code) {
			var searchUrl = "";
			searchUrl = getContextPath() + "/loadGRNHd.html?GRNCode=" + code;
			//alert(searchUrl);
			$.ajax({
				type : "GET",
				url : searchUrl,
				dataType : "json",
				success : function(response) {
					if ('Invalid Code' == response.strGRNCode) {
						alert('Invalid Code');
						$("#txtGRNCode").val('');
						$("#txtGRNCode").focus();

					} else {
						funSetGRNHd(response);
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

		
		//Set data in textfiled
		function funSetGRNHd(response) {
	
			var currValue=parseFloat(response.dblConversion);
			$("#txtGRNCode").val(response.strGRNCode);
			$("#txtGRNNo").val(response.strNo);
			$("#txtGRNDate").val(response.dtGRNDate);
			$("#txtBillNo").val(response.strBillNo);
			$("#txtSuppCode").val(response.strSuppCode);
			$("#txtSuppName").text(response.strSuppName);
			$("#txtChallanDate").val(response.dtBillDate);
			$("#txtDueDate").val(response.dtDueDate);
			$("#cmbAgainst").val(response.strAgainst);
			$("#txtDblConversion").val(currValue);
			
			
			$("#txtPayMode").val(response.strPayMode);
			if(response.strPayMode=='Credit')
			{
				//$("#txtPayMode").val(response.strPayMode.toLowerCase());
				$("#txtPayMode").val(response.strPayMode);
			}
			
			funOnChange();
			
			
    		if(currValue==null ||currValue==0)
    		{
    		  currValue=1;
    		}
			$("#txtDocCode").val(response.strPONo);
			var POCodes=response.strPONo.split(",");
			var html = '';
			for(var cnt=0;cnt<POCodes.length;cnt++)
			{
				html += '<option value="' + POCodes[cnt] + '" >' + POCodes[cnt]+ '</option>';
			}
			$('#cmbPODoc').html(html);
			$("#txtInwRefNo").val(response.strRefNo);
			$("#txtRefDate").val(response.dtRefDate);
			$("#txtSubTotal").val((parseFloat(response.dblSubTotal)/currValue).toFixed(maxAmountDecimalPlaceLimit));
			$("#txtDiscPer").val(parseFloat(response.dblDisRate).toFixed(maxAmountDecimalPlaceLimit));
			$("#txtDiscAmount").val((parseFloat(response.dblDisAmt)/currValue).toFixed(maxAmountDecimalPlaceLimit));
			$("#txtNarration").val(response.strNarration);
			$("#txtExtraCharges").val((parseFloat(response.dblExtra)/currValue).toFixed(maxAmountDecimalPlaceLimit));
			$("#txtLessAmt").val((parseFloat(response.dblLessAmt)/currValue).toFixed(maxAmountDecimalPlaceLimit));
			$("#txtFinalAmt").val((parseFloat(response.dblTotal)/currValue).toFixed(maxAmountDecimalPlaceLimit));
			
			$("#txtFOB").val((parseFloat(response.dblFOB)/currValue).toFixed(maxAmountDecimalPlaceLimit));
			$("#txtFreight").val((parseFloat(response.dblFreight)/currValue).toFixed(maxAmountDecimalPlaceLimit));
			$("#txtInsurance").val((parseFloat(response.dblInsurance)/currValue).toFixed(maxAmountDecimalPlaceLimit));
			$("#txtOtherCharges").val((parseFloat(response.dblOtherCharges)/currValue).toFixed(maxAmountDecimalPlaceLimit));
			$("#txtClearingAgentCharges").val((parseFloat(response.dblClearingCharges)/currValue).toFixed(maxAmountDecimalPlaceLimit));
			$("#txtVATClaim").val((parseFloat(response.dblVATClaim)/currValue).toFixed(maxAmountDecimalPlaceLimit));
			
			$("#txtTimeIn").val(response.strTimeInOut);
			$("#txtVehicleNo").val(response.strVehNo);
			$("#txtMInBy").val(response.strMInBy);
			$("#txtLocCode").val(response.strLocCode);
			$("#lblLocName").text(response.strLocName);
			$("#btnAdd").focus();
			$("#hidRoundOff").val((parseFloat(response.dblRoundOff)/currValue).toFixed(maxAmountDecimalPlaceLimit));
			$("#cmbCurrency").val(response.strCurrency);
			
			funLoadGRNDtl(response.strGRNCode,currValue);
			funLoadGRNTaxDtl(response.strGRNCode,currValue);
			funCalculateOtherChargesTotal();
		//	funCalTaxTotal();
		}

		
		//Get GrnDtl data
		function funLoadGRNDtl(code,currValue) {
			var searchUrl = "";
			var strIssueLocation="";
			var strIsueLocName="";
			var strStkble="";
			searchUrl = getContextPath() + "/loadGRNDtl.html?GRNCode=" + code;
			$.ajax({
				type : "GET",
				url : searchUrl,
				dataType : "json",
				success : function(response) {
					funRemProdRows();
					var count=0;
					$.each(response, function(i, item) {
						count=i;
						funAddProductForGRN(this.strProdCode, this.strProdName,this.strUOM, this.dblUnitPrice/currValue, this.dblWeight
							,this.dblQty, this.dblQtyRbl, this.dblDCWt,this.dblDCQty, this.dblRejected,this.dblPOWeight
							,this.dblRework,this.dblPackForw, this.strRemarks, this.dblDiscount/currValue, '',this.strCode
							,this.dblTotalPrice/currValue,this.strExpiry,this.strIssueLocation,this.strIsueLocName,this.strStkble
							,this.strMISCode,this.strReqCode,this.dblFreeQty,this.strGroupTaxCode);
					});
					listRow=count+1;
					funGetQtyTotal();
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
		
		//Get grn taxDtl data
		function funLoadGRNTaxDtl(code,currValue) 
		{
			var searchUrl = "";
			searchUrl = getContextPath() + "/loadGRNTaxDtl.html?GRNCode=" + code;
			$.ajax({
				type : "GET",
				url : searchUrl,
				dataType : "json",
				success : function(response) 
				{
					funRemoveTaxRows();
					$.each(response, function(i,item)
		            {
						funAddTaxRow1(response[i].strTaxCode,response[i].strTaxDesc,response[i].strTaxableAmt/currValue,response[i].strTaxAmt/currValue);
		            });
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

		//Set product data in grid
		function funAddProductForGRN(prodCode, prodName, uom, unitPrice,wtunit, qtyrecevd, qtyrecb, dcWt, dcQty, rejected, poWt
				,rework, packforward, remarks, disc, binNo, code,dblTotalPrice,strExpiry,strIssueLocCode,strIsueLocName
				,strNONStkble,strMISCode,strReqCode,freeQuantity,groupTaxCode) {
			
			
			
			var currValue=1;
		  	/* var currValue=$("#txtDblConversion").val();
    		if(currValue==null ||currValue==''||currValue==0)
    		{
    		  currValue=1;
    		} */
			unitPrice = parseFloat(unitPrice).toFixed(maxAmountDecimalPlaceLimit);
    		unitPrice=(unitPrice/currValue).toFixed(maxAmountDecimalPlaceLimit);
			wtunit = parseFloat(wtunit).toFixed(maxQuantityDecimalPlaceLimit);
			qtyrecevd = parseFloat(qtyrecevd).toFixed(maxQuantityDecimalPlaceLimit);
			qtyrecb = parseFloat(qtyrecb).toFixed(maxQuantityDecimalPlaceLimit);
			dcWt = parseFloat(dcWt).toFixed(maxQuantityDecimalPlaceLimit);
			dcQty = parseFloat(dcQty).toFixed(maxQuantityDecimalPlaceLimit);
			rejected = parseFloat(rejected).toFixed(maxQuantityDecimalPlaceLimit);
			poWt = parseFloat(poWt).toFixed(maxQuantityDecimalPlaceLimit);
			rework = parseFloat(rework).toFixed(maxQuantityDecimalPlaceLimit);
			packforward = parseFloat(packforward).toFixed(maxQuantityDecimalPlaceLimit);
			disc = (parseFloat(disc)/currValue).toFixed(maxAmountDecimalPlaceLimit);
			freeQuantity = parseFloat(freeQuantity).toFixed(maxQuantityDecimalPlaceLimit);
			var groupTaxName="";
			if(strOpenTaxCalculation=='Y') //if(clientCode=='382.000' || clientCode=='389.001' || clientCode=='211.001' || clientCode=='384.001' )
	    	{
				if(groupTaxCode.length>0)
				{
					groupTaxName=mapForGroupTax.get(groupTaxCode);
				}
				else
				{
					groupTaxName="No Tax";	
					groupTaxCode="";
				}
				
	    	}
			
    	
			var totalWt = qtyrecevd * wtunit;
			totalWt = parseFloat(totalWt).toFixed(maxAmountDecimalPlaceLimit);
			var totalPrice = parseFloat(dblTotalPrice).toFixed(maxAmountDecimalPlaceLimit);
			totalPrice=(totalPrice/currValue).toFixed(maxAmountDecimalPlaceLimit);;
			var table = document.getElementById("tblProduct");
			var rowCount = table.rows.length;
			var row = table.insertRow(rowCount);
			row.insertCell(0).innerHTML = "<input name=\"listGRNDtl["
					+ (rowCount)
					+ "].strProdCode\" readonly=\"readonly\" class=\"Box\" size=\"9%\" id=\"txtProdCode."
					+ (rowCount) + "\" value=" + prodCode + ">";
			row.insertCell(1).innerHTML = "<input name=\"listGRNDtl["
					+ (rowCount)
					+ "].strProdName\" readonly=\"readonly\" size=\"17%\" class=\"Box\"  id=\"lblProdName."
					+ (rowCount) + "\" value='" + prodName + "' >";
			
		   row.insertCell(2).innerHTML = "<input name=\"listGRNDtl["
						+ (rowCount)
						+ "].dblQty\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" size=\"6%\" class=\"decimal-places inputText-Auto QtyCell\" id=\"txtQuantity1."
						+ (rowCount) + "\" value=" + qtyrecevd
						+ " onblur=\"funUpdatePrice(this);\" >";
						
						
			row.insertCell(3).innerHTML = "<input name=\"listGRNDtl["
							+ (rowCount)
							+ "].dblFreeQty\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" size=\"6%\" class=\"decimal-places inputText-Auto QtyCell\" id=\"txtFreeQty1."
							+ (rowCount) + "\" value=" + freeQuantity
							+ " onblur=\"funUpdatePrice(this);\" >";
			row.insertCell(4).innerHTML = "<input name=\"listGRNDtl["
					+ (rowCount)
					+ "].dblRejected\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" size=\"7%\" class=\"decimal-places inputText-Auto RejCell\" id=\"txtRejected."
					+ (rowCount) + "\" value=" + rejected + " onblur=\"funUpdatePrice(this);\">";
			row.insertCell(5).innerHTML = "<input name=\"listGRNDtl["
					+ (rowCount)
					+ "].strUOM\" readonly=\"readonly\" class=\"Box\" size=\"5%\" id=\"txtUOM."
					+ (rowCount) + "\" value=" + uom + ">";
			row.insertCell(6).innerHTML = "<input name=\"listGRNDtl["
					+ (rowCount)
					+ "].dblUnitPrice\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" size=\"8%\" class=\"decimal-places-amt inputText-Auto\" id=\"txtCostRM."
					+ (rowCount) + "\" value='" + unitPrice + "' onblur=\"funUpdatePrice(this);\">";
			row.insertCell(7).innerHTML = "<input name=\"listGRNDtl["
					+ (rowCount)
					+ "].dblDiscount\" type=\"text\" required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\"  size=\"6%\" class=\"decimal-places-amt inputText-Auto\" id=\"txtDiscount."
					+ (rowCount) + "\" value=" + disc + " onblur=\"funUpdatePrice(this);\">";	
			
			row.insertCell(8).innerHTML = "<input name=\"listGRNDtl["
						+ (rowCount)
						+ "].dblTotalPrice\" class=\"Box totalPriceCell\" readonly=\"readonly\" style=\"text-align: right;\" size=\"9%\" id=\"txtTotalPrice."
						+ (rowCount) + "\" value=" + totalPrice + ">";
		    row.insertCell(9).innerHTML= "<input  readonly=\"readonly\" class=\"Box\" size=\"15%\"   id=\"strGroupTaxName."+(rowCount)+"\" value = '"+groupTaxName+"' onclick=funHelp1("+(rowCount)+",'groupTaxCodeForGRN') >";
		     
		  
			row.insertCell(10).innerHTML = "<input name=\"listGRNDtl["
						+ (rowCount)
						+ "].strRemarks\"  size=\"17%\"  id=\"txtRemark."
						+ (rowCount) + "\" value='" + remarks + "'>";
						
		   row.insertCell(11).innerHTML = "<input name=\"listGRNDtl["+ (rowCount)+ "].dblQtyRbl\" type=\"text\" required = \"required\" readonly=\"readonly\" size=\"7%\" style=\"text-align:right;width:100%;border:1px solid #a2a2a2;padding:1px;\" class=\"decimal-places inputText-Auto\" id=\"txtQtyRec."+ (rowCount) + "\" value=" + qtyrecb + ">";
		   row.insertCell(12).innerHTML = "<input name=\"listGRNDtl["+ (rowCount)+ "].dblDCQty\" type=\"text\" required = \"required\" size=\"6%\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" class=\"decimal-places inputText-Auto\" id=\"txtDCQty."+ (rowCount) + "\" value=" + dcQty + ">";
		   row.insertCell(13).innerHTML = "<input name=\"listGRNDtl["+ (rowCount)+ "].dblDCWt\" type=\"text\" required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" size=\"6%\" class=\"decimal-places inputText-Auto\" id=\"txtDCWt."+ (rowCount) + "\" value=" + dcWt + ">";
			
					
					
		   row.insertCell(14).innerHTML = "<input name=\"listGRNDtl["
					+ (rowCount)
					+ "].dblWeight\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" size=\"5%\" class=\"decimal-places inputText-Auto\" id=\"txtWtUnit."
					+ (rowCount) + "\" value=" + wtunit + ">";
			row.insertCell(15).innerHTML = "<input name=\"listGRNDtl["
					+ (rowCount)
					+ "].dblTotalWt\" class=\"Box totalWeightCell\" readonly=\"readonly\" size=\"6%\" style=\"text-align: right;\"  id=\"txtTotalWeight."
					+ (rowCount) + "\" value=" + totalWt + ">";
		
			row.insertCell(16).innerHTML = "<input name=\"listGRNDtl["
					+ (rowCount)
					+ "].dblPackForw\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\"  size=\"6%\" class=\"decimal-places inputText-Auto\" id=\"txtPack."
					+ (rowCount) + "\" value=" + packforward + " onblur=\"funUpdatePrice(this);\">";
			
			row.insertCell(17).innerHTML = "<input name=\"listGRNDtl["
					+ (rowCount)
					+ "].dblPOWeight\"type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\"  size=\"6%\" class=\"decimal-places inputText-Auto\" id=\"txtPOWt."
					+ (rowCount) + "\" value=" + poWt + ">";
					
					if(strReqCode!="" || strNONStkble=="No" )
					{
						row.insertCell(18).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strIssueLocation\" readonly=\"readonly\" class=\"Box IssueLocCode\" size=\"4%\"  id=\"txtIssueLocation."+(rowCount)+"\" value='"+strIssueLocCode+"' >";
						row.insertCell(19).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strIsueLocName\" readonly=\"readonly\" class=\"Box\" size=\"20%\"  id=\"txtIsueLocName."+(rowCount)+"\" value='"+strIsueLocName+"' >";
					}
					else
					{
						 row.insertCell(18).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strIssueLocation\" required = \"required\" readonly=\"readonly\" class=\"Box IssueLocCode\" size=\"4%\"  id=\"txtIssueLocation."+(rowCount)+"\" value='"+strIssueLocCode+"' ><input type=button   onclick=funHelp1("+(rowCount)+",'IssueLoc1') value=...>";
						 row.insertCell(19).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strIsueLocName\" readonly=\"readonly\" class=\"Box\" size=\"20%\"  id=\"txtIsueLocName."+(rowCount)+"\" value='"+strIsueLocName+"' >";
					}		
					
					
					
					
			row.insertCell(20).innerHTML = "<input name=\"listGRNDtl["
					+ (rowCount)
					+ "].strCode\"readonly=\"readonly\" class=\"Box\" size=\"10%\"  id=\"txtCode."
					+ (rowCount) + "\" value=" + code + ">";

			row.insertCell(21).innerHTML = "<input name=\"listGRNDtl["
					+ (rowCount)
					+ "].dblRework\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" size=\"5%\" class=\"decimal-places inputText-Auto\" id=\"txtRework."
					+ (rowCount) + "\" value=" + rework + ">";
            row.insertCell(22).innerHTML= "<input type=\"hidden\" id=\"txtTempTax."+(rowCount)+"\" size=\"0%\" value="+gTaxAmount+">";
		    row.insertCell(23).innerHTML= '<input type="button" value = "Delete" class="deletebutton" onClick="Javacsript:funDeleteRow(this)">';
		    row.insertCell(24).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strExpiry\" type=\"hidden\" value = '"+strExpiry+"' >";
		    row.insertCell(25).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strStkble\" type=\"hidden\" value = '"+strNONStkble+"' >";
		    row.insertCell(26).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strMISCode\" type=\"hidden\" value = '"+strMISCode+"' >";
		    row.insertCell(27).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strGroupTaxCode\" type=\"hidden\"   id=\"groupTaxCode."+(rowCount)+"\" value = '"+groupTaxCode+"' >";
			funResetProductFields();
			funApplyNumberValidation();
			return false;
		}

		//Get and set total qty 
		function funGetQtyTotal()
		{
			var totalWeight=0.00;
			var totalQty=0.00;
			$('#tblProduct tr').each(function() {
			    var totalQtyCell = $(this).find(".QtyCell").val();
			    var totalWeigthCell = $(this).find(".totalWeightCell").val();
			    var RejQty=$(this).find(".RejCell").val();
			    totalQty=parseFloat(totalQtyCell)+totalQty-parseFloat(RejQty);
				totalWeight=parseFloat(totalWeigthCell)+totalWeight;
			});
			totalQty=parseFloat(totalQty).toFixed(maxAmountDecimalPlaceLimit);
			totalWeight=parseFloat(totalWeight).toFixed(maxAmountDecimalPlaceLimit);
			$("#txtTotalWt").val(totalWeight);
			$("#txtTotalQty").val(totalQty);
		}
		
		//Get and Set location data
		function funSetLocation(code) {
			var searchUrl = "";
			searchUrl = getContextPath()+ "/loadLocationMasterData.html?locCode=" + code;
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

		//Get prodcut data 
		function funSetProduct(code) {
			var searchUrl = "";
			var suppCode=$("#txtSuppCode").val();
			var locCode=$("#txtLocCode").val();
			var currCode=$("#cmbCurrency").val();
			var billDate=$("#txtGRNDate").val();
			//var currValue=funGetCurrencyCode(currCode);
			var currValue=$("#txtDblConversion").val();
    		if(currValue==null ||currValue==''||currValue==0)
    		{
    		  currValue=1;
    		}
			var strRateFrom='<%=session.getAttribute("RateFrom").toString()%>';
			if(suppCode!="")
			{
				if(strRateFrom=="SupplierRate")
				{
					searchUrl = getContextPath()+ "/loadProductDataWithSuppWiseRate.html?prodCode=" + code+"&suppCode="+suppCode;
				}
				else
				{
					searchUrl = getContextPath()+ "/loadProductDataWithTax.html?prodCode=" + code+"&locCode="+locCode+"&suppCode="+suppCode+"&billDate="+billDate;
				}
			}
			else
			{
				searchUrl = getContextPath()+ "/loadProductDataWithTax.html?prodCode=" + code+"&locCode="+locCode+"&suppCode="+suppCode+"&billDate="+billDate;
			}
				$.ajax({
					type : "GET",
					url : searchUrl,
					dataType : "json",
					success : function(response) {

						if ('Invalid Code' == response.strProdCode) {
							alert('Invalid Product Code');
							$("#txtProdCode").val('');
							$("#lblProdName").text('');
							$("#txtProdCode").focus();
						} else {
						  	
				    		if(currValue==null)
				    		{
				    		  currValue=1;
				    		}
				    		$('#txtCostRM').attr('readonly', false);
							$("#txtProdCode").val(response.strProdCode);
							document.getElementById("lblProdName").innerHTML = response.strProdName;
							$("#txtCostRM").val(parseFloat((response.dblCostRM)/currValue).toFixed(maxAmountDecimalPlaceLimit));
							$("#txtWtUnit").val(response.dblWeight);
							$("#txtBinNo").val(response.strBinNo);
							$("#cmbUOM").val((response.strUOM).toUpperCase());
							$("#txtExpiry").val(response.strExpDate);
							$("#hidstrStkble").val(response.strNonStockableItem);
							if(response.strNonStockableItem=="Y")
							{
								$("#lblIssueLocation").css('visibility', 'visible');
								$("#lblIssueLocName").css('visibility', 'visible');
								$("#txtIssueLocCode").css('visibility', 'visible');
								if(response.strLocCode.length>0)
									{
										$("#txtIssueLocCode").val(response.strLocCode);
										$("#txtCostRM").focus().select();
									}else
										{
											$("#txtIssueLocCode").focus();
										}
							}
							else
							{
								$("#lblIssueLocation").css('visibility', 'hidden');
								$("#lblIssueLocName").css('visibility', 'hidden');
								$("#txtIssueLocCode").css('visibility', 'hidden');
								$("#txtCostRM").focus().select();
							}
							$("#btnAddChar").css('visibility', 'visible');
							
								if($("#hidstrRateEditableYN").val()=="No")
								{
									// Rate Editable false     
									$('#txtCostRM').attr('readonly', true);
								}else{
									 if($("#cmbAgainst").val()=="Rate Contractor")
										{
										 if(response.strRemark=="Not Contract Rate Amt")
										 {
											 $('#txtCostRM').attr('readonly', false);
										 }else{
										   // Rate Editable false     
										   $('#txtCostRM').attr('readonly', true);
										 }
										}
								}
							
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
		
		

		//set supplier Data
		function funSetSupplier(code) {
			var searchUrl = "";
			searchUrl = getContextPath()+ "/loadSupplierMasterData.html?partyCode=" + code;
			$.ajax({
				type : "GET",
				url : searchUrl,
				dataType : "json",
				success : function(response) {
					if ('Invalid Code' == response.strPCode) {
						alert('Invalid Code');
						$("#txtSuppCode").val('');
						$("#txtSuppName").text('');
						$("#txtSuppCode").focus();
					} else {
						$("#txtSuppCode").val(response.strPCode);
						$("#txtSuppName").text(response.strPName);
						$("#cmbCurrency").val(response.strCurrency);
						$("#txtGRNDate").focus();
					}
					funOnChangeCurrency();
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

		//Get and Set Purchase order Data
		function funSetPurchaseOrder() {
			var strMISCode="";
			if ($('#txtDocCode').val() != "") {
				strCodes = $('#txtDocCode').val();
				strDNCodes = strCodes.split(",")
				var count=0,dblConversionRate=1;
				funRemoveProductRows();
				funRemoveTaxRows();
			 	for (ci = 0; ci < strDNCodes.length; ci++)
				{
					var searchUrl = getContextPath()+ "/loadAgainstPO.html?POCode=" + strDNCodes[ci];
					$.ajax({
						type : "GET",
						url : searchUrl,
						dataType : "json",
						async : false,
						success : function(response) {
							$("#txtFOB").val(response[7]);
							$("#txtFreight").val(response[1]);
							$("#txtInsurance").val(response[2]);
							
							$("#txtOtherCharges").val(response[3]);
							$("#txtCIF").val(response[4]);
							$("#txtClearingAgentCharges").val(response[5]);
							$("#txtVATClaim").val(response[6]);
							
							$.each(response[0], function(i, item) {
								count++;
								gTaxType = response[0][i].strTaxType;
								gTaxCal =  response[0][i].strTaxCalculation;
								gTaxPer =  response[0][i].dblTaxPercentage;
								gTaxOnGD =  response[0][i].strTaxOnGD;
								dblConversionRate= response[0][i].dblConversionRate;
								$("#cmbCurrency").val( response[0][i].strCurrency);
								$("#txtDblConversion").val(dblConversionRate);
								
						
								
								//alert(response[i].dblWeight);
								funFillTableForAgainst( response[0][i].strProdCode, response[0][i].strProdName, response[0][i].dblRate
									, response[0][i].dblTotalPrice, response[0][i].dblQty, response[0][i].strCode, response[0][i].strUOM
									, response[0][i].strExpiry, response[0][i].dblDiscount, response[0][i].strIssueLocation
									, response[0][i].strIsueLocName, response[0][i].strStkble, response[0][i].strReqCode
									, response[0][i].dblWeight,strMISCode, response[0][i].dblConversionRate, response[0][i].strCurrency,response[0][i].dblFreeQty);
							});
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
					
					funSetPOTaxDtl(strDNCodes[ci],dblConversionRate);
					
				} 
				listRow=count;
				if ($("#cmbAgainst").val() == "Purchase Order") 
				    {
				    	funCalCulateMultiPODiscount();
				    }
				 
			}
		}
		
		
		//Set PO TaxDtl
		function funSetPOTaxDtl(code,currValue) 
		{
			
			//var cmbCurrency=$("#cmbCurrency").val();
			//var currValue=funGetCurrencyCode(cmbCurrency);
			if(currValue==null)
    		{
    		  currValue=1;
    		}
			
			var searchUrl = "";
			searchUrl = getContextPath() + "/loadPOTaxDtlonGRN.html?POCode=" + code;
			$.ajax({
				type : "GET",
				url : searchUrl,
				dataType : "json",
				success : function(response) 
				{					
					$.each(response, function(i,item)
		            {
						funAddTaxRow1(response[i].strTaxCode,response[i].strTaxDesc,response[i].strTaxableAmt/currValue,response[i].strTaxAmt/currValue);
		            });
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
		

		//Set Purchase Return Data
		function funSetPurchaseReturn(code) 
		{
			var strIssueLocation ="";
			var strIsueLocName="";
			var strStkble="";
			var strMISCode="";
			var strReqCode="";
			searchUrl = getContextPath() + "/loadAgainstPR.html?PRCode=" + code;
			$.ajax({
				type : "GET",
				url : searchUrl,
				dataType : "json",
				success : function(response) {
					funRemProdRows();
					$.each(response, function(i, item) {
						gTaxType = response[i].strTaxType;
						gTaxCal = response[i].strTaxCalculation;
						gTaxPer = response[i].dblTaxPercentage;
						gTaxOnGD = response[i].strTaxOnGD;
						funFillTableForAgainst(response[i].strProdCode,response[i].strProdName,response[i].dblUnitPrice
								,response[i].dblTotalPrice, response[i].dblQty,response[i].strPRCode, response[i].strUOM
								,response[i].strExpiry,0,strIssueLocation,strIsueLocName,strStkble,strReqCode
								,response[i].dblWeight,strMISCode,response[0][i].dblFreeQty);
					});
					funGetTotal();
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

		//Get and set Short SupplyPO Data
		function funSetShortSupplyPO(code) {
			var strReqCode="";
			var strMISCode="";
			searchUrl = getContextPath()
					+ "/loadAgainstShortSupply.html?POCode=" + code;
			$.ajax({
				type : "GET",
				url : searchUrl,
				dataType : "json",
				success : function(response) {
					funRemProdRows();
					$.each(response, function(i, item) {
						gTaxType = response[i].strTaxType;
						gTaxCal = response[i].strTaxCalculation;
						gTaxPer = response[i].dblTaxPercentage;
						gTaxOnGD = response[i].strTaxOnGD;
						funFillTableForAgainst(response[i].strProdCode,response[i].strProdName,response[i].dblRate
							,response[i].dblTotalPrice,response[i].dblQty,response[i].strCode,response[i].strUOM
							,response[i].strExpiry,response[i].dblDiscount,response[i].strIssueLocation
							,response[i].strIsueLocName,response[i].strStkble,strReqCode,response[i].dblWeight,strMISCode,response[0][i].dblFreeQty);
					});
					funGetTotal();
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

		
		
		//Get and set sales Return Data
		function funSetSalesReturn(code) {
			var searchUrl = "";
			searchUrl = getContextPath()+ "/loadSupplierMasterData.html?partyCode=" + code;
			$.ajax({
				type : "GET",
				url : searchUrl,
				dataType : "json",
				success : function(response) {
					$("#txtSuppCode").val(response.strPCode);
					$("#txtSuppName").text(response.strPName);
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

		
		
		//Open Against Form
		function funOpenAgainst() {
			if ($("#cmbAgainst").val() == "Purchase Order") {
				if ($("#txtSuppCode").val() != "") {
					var suppCode = $("#txtSuppCode").val();
					funOpenPOHelp(suppCode);
				}else {
					alert("Please Select Supplier");
					$("#txtSuppCode").focus();
					return false;
				}
			} else if ($("#cmbAgainst").val() == "Purchase Return") {
				funHelp("PRCodeAgainstGRN");
				fieldName = "PRCodeAgainstGRN";
			} else if ($("#cmbAgainst").val() == "Short Supply") {
				funHelp("ShortSupplyAgainstGRN");
				fieldName = "ShortSupplyAgainstGRN";
			} else if ($("#cmbAgainst").val() == "Sales Return") {
				funHelp("SRCodeAgainstGRN");
				fieldName = "SRCodeAgainstGRN";
			}else if ($("#cmbAgainst").val() == "Delivery Schedule") {
				funHelp("dsCodeAgainstGRN");
				fieldName = "dsCodeAgainstGRN";
			}
			
			/* else if($("#cmbAgainst").val() == "Invoice")
			{
				funHelp('invoice');
				} */
		}
		
		
		
		//Open Against PO From and Set PO Code in combo box
		function funOpenPOHelp(suppCode) {
// 			var retval = window.showModalDialog(
// 					"frmGRNPODetails.html?strSuppCode=" + suppCode, "",
// 					"dialogHeight:600px;dialogWidth:500px;dialogLeft:400px;")
			var retval = window.open(
					"frmGRNPODetails.html?strSuppCode=" + suppCode, "",
					"dialogHeight:600px;dialogWidth:500px;top=500,left=500")
			
			var timer = setInterval(function ()
						    {
							if(retval.closed)
								{
									if (retval.returnValue != null)
									{
										strVal=retval.returnValue.split("#")
										$("#txtDocCode").val(strVal[0]);
										
// 										funSetPurchaseOrder();
										
										var POCodes=strVal[0].split(",");
										var html = '';
										for(var cnt=0;cnt<POCodes.length;cnt++)
										{
						 						html += '<option value="' + POCodes[cnt] + '" >' + POCodes[cnt]
						 								+ '</option>';
						 					//html += '</option>';
						 					
										}
										$('#cmbPODoc').html(html);
					
									}
									clearInterval(timer);
								}
						    }, 500);		
					
// 			if (retval != null)
// 			{
// 				strVal = retval.split("#")
// 				$("#txtDocCode").val(strVal[0]);
				
// 				funSetPurchaseOrder();
				
// 				var POCodes=strVal[0].split(",");
// 				var html = '';
// 				for(var cnt=0;cnt<POCodes.length;cnt++)
// 				{
//  						html += '<option value="' + POCodes[cnt] + '" >' + POCodes[cnt]
//  								+ '</option>';
//  					//html += '</option>';
 					
// 				}
// 				$('#cmbPODoc').html(html);
// 			}
		}

		
		
		//Combo Box Change then set value
		function funOnChange() {
			if ($("#cmbAgainst").val() == "Direct")
			{
				$("#txtDocCode").css('visibility', 'hidden');
				//$("#txtProdCode").attr("disabled", false);
				$('#txtProdCode').attr('readonly', false);
			}
			else 
			{
				$("#txtDocCode").css('visibility', 'visible');
				//$("#txtProdCode").attr("disabled", true);
				$('#txtProdCode').attr('readonly', true);
			}
			
		}

		
		
		function btnShow_onclick() {
			document.all("tblTaxOnFixedAmt").style.visibility = "visible";
			document.all("tblTaxOnFixedAmt").style.position = "absolute";
			document.all("tblTaxOnFixedAmt").style.top = "400px";
			document.all("tblTaxOnFixedAmt").style.left = "20%";
		}

		
		
		function btnClose_onclick() 
		{
			document.all("tblTaxOnFixedAmt").style.visibility = "hidden";
			document.all("txtNarration").focus();
		}
		
		
		//Display Message After Submit Data
		$(function() {
			strChangeUOM='<%=session.getAttribute("changeUOM").toString()%>';
			if(strChangeUOM!="N")
			{
				$("#cmbUOM").prop("disabled", false);
			}
			else
			{
				$("#cmbUOM").prop("disabled", true);
			}
			
			var message='';
			<%if (session.getAttribute("success") != null) {
				if (session.getAttribute("successMessage") != null) {%>
					message='<%=session.getAttribute("successMessage").toString()%>';
					<%session.removeAttribute("successMessage");
				}
				boolean test = ((Boolean) session.getAttribute("success"))
						.booleanValue();

				if (test) {%>	
					alert("Data Save successfully\n\n"+message);
				<%}
			}%>
			
			<%if (session.getAttribute("success") != null) {
				if (session.getAttribute("successMessageMIS") != null) {%>
					message='<%=session.getAttribute("successMessageMIS")
							.toString()%>';
					<%session.removeAttribute("successMessageMIS");
					boolean test = ((Boolean) session.getAttribute("success"))
							.booleanValue();
					if (test) {%>	
						alert("Data Save successfully\n\n"+message);
					<%}
				}
				session.removeAttribute("success");
			}%>
			
			<%if (session.getAttribute("JVGen") != null) {
				if (session.getAttribute("JVGenMessage") != null) {%>
					message='<%=session.getAttribute("JVGenMessage").toString()%>';
					<%session.removeAttribute("JVGenMessage");
				}
				boolean test = ((Boolean) session.getAttribute("JVGen"))
						.booleanValue();
				session.removeAttribute("JVGen");
				if (!test) {%>
					alert("Problem in JV Posting\n\n"+message);
				<%}
			}%>
			
			
			//Open GRN Slip 
			var code='';
			<%if (null != session.getAttribute("rptGRNCode")) {%>
				code='<%=session.getAttribute("rptGRNCode").toString()%>';
				<%session.removeAttribute("rptGRNCode");%>
				var isOk=confirm("Do You Want to Generate Slip?");
				if(isOk)
				{
					window.open(getContextPath()+"/openRptGrnSlip.html?rptGRNCode="+code,'_blank');
				}
						
				if(null!='<%=session.getAttribute("BatchProcessList")%>' && '<%=session.getAttribute("BatchProcessList")%>'!="null")
				{
				//	window.showModalDialog("frmBatchProcess.html","","dialogHeight:450px;dialogWidth:800px;dialogLeft:300px;");
					window.open("frmBatchProcess.html","","dialogHeight:450px;dialogWidth:800px;top=500,left=500");
				}
			<%}%>
			
			<%-- if(null!='<%=session.getAttribute("strmsg")%>' && '<%="Inserted"==session.getAttribute("strmsg")%>')
			{
				funCheckNonStkItem(code);
			} --%>
			 //Set Date in Date Picker
			$("#txtGRNDate").datepicker();
			$('#txtGRNDate').datepicker('setDate', 'today');
			$("#txtDueDate").datepicker();
			$('#txtDueDate').datepicker('setDate', 'today');
			$("#txtChallanDate").datepicker();
			$('#txtChallanDate').datepicker('setDate', 'today');
			$("#txtRefDate").datepicker();
			$('#txtRefDate').datepicker('setDate', 'today');
			/**
			 * Checking Authorization
			**/
			var flagOpenFromAuthorization="${flagOpenFromAuthorization}";
			if(flagOpenFromAuthorization == 'true'){
				funLoadGRNHd("${authorizationGRNCode}");
			}
		});
		
		//Check Product is Stockable or NonStockable
		function funCheckNonStkItem(code) {
			var searchUrl = "";
			searchUrl = getContextPath() + "/CheckNonStkItem.html?GRNCode=" + code;
			$.ajax({
				type : "GET",
				url : searchUrl,
				dataType : "json",
				success : function(response)
				{
					if(response==true)
					{
						window.open("frmNonStkMIS.html?GRNCode="+code,'_blank');
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
		
		//Apply Validation on Number TextFiled
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
			$(".decimal-places-amt").numeric({
				decimalPlaces : maxAmountDecimalPlaceLimit,
				negative : false
			});
		}
		
		//Check Validation before Submit the data
		function funValidateFields() 
		{
			var table = document.getElementById("tblProduct");
		    var rowCount = table.rows.length;
		    
 		    var spGRNDate=$("#txtGRNDate").val().split('-');
		    var grnDate=spGRNDate[0]+'/'+spGRNDate[1]+'/'+spGRNDate[2];		    
		    
		    var grnDate = new Date(spGRNDate[2],spGRNDate[1]-1,spGRNDate[0]);
		    var td=new Date();
		    var d2 = new Date(td.getYear()+1900,td.getMonth(),td.getDate());
		    var dateDiff=grnDate-d2;
		    if(dateDiff>0)
		    {
		    	alert("Future date is not allowed for grn");
		    	$("#txtGRNDate").focus();
				return false;		    	
		    } 
		    if($("#txtGRNCode").val()==""){
		    	strCurrentDateForTransaction="${strCurrentDateForTransaction}" ;
			    if(strCurrentDateForTransaction=="true"){
			    	if(dateDiff<0){
			    		alert("Back date is not allowed for GRN ");
				    	$("#txtGRNDate").focus();
						return false;		    	
			    	}
			    }	
		    }
		    
		    
			if (!fun_isDate($("#txtGRNDate").val()))
			{
				alert('Invalid GRN Date');
				$("#txtGRNDate").focus();
				return false;
			}
			if (!fun_isDate($("#txtDueDate").val()))
			{
				alert('Invalid Due Date');
				$("#txtDueDate").focus();
				return false;
			}
			if (!fun_isDate($("#txtChallanDate").val()))
			{
				alert('Invalid Challan Date');
				$("#txtChallanDate").focus();
				return false;
			}
			if (!fun_isDate($("#txtRefDate").val()))
			{
				alert('Invalid Inward Ref Date');
				$("#txtRefDate").focus();
				return false;
			}
			if($("#txtSuppCode").val().trim().length==0)
			{
				alert("Please Enter Supplier Code or Search");
				$("#txtSuppCode").focus();
				return false;
			}
			
			if(  $("#cmbAgainst").val() == null )
			{
		 		alert("Please Select Against");
				return false;
		 	}
			
			if($("#cmbAgainst").val()!="Direct")
			{
				if($("#txtDocCode").val().trim().length==0)
				{
					alert("Please Enter "+$("#cmbAgainst").val()+" Code");
					return false;
				}
			}
			if($("#txtLocCode").val().trim().length==0)
			{
				alert("Please Enter Location Code or Search");
				$("#txtLocCode").focus();
				return false;
			}
			
			if($("#txtBillNo").val().trim().length==0)
			{
				alert("Please Enter Bill No.");
				$("#txtBillNo").focus();
				return false;
			}
			if(rowCount<1)
			{
				alert("Please Add Product in Grid");
				$("#txtProdCode").focus();
				return false;
			}
			if($("#txtDiscAmount").val()=="")
			{
				$("#txtDiscAmount").val("0.00");
			}
			if($("#txtDiscPer").val()=="")
			{
				$("#txtDiscPer").val("0.00");
			}
			if($("#txtExtraCharges").val()=="")
			{
				$("#txtExtraCharges").val("0.00");
			}
			if($("#txtLessAmt").val()=="")
			{
				$("#txtLessAmt").val("0.00");
			}
			var dtGRNDate=$("#txtGRNDate").val();
			 
			//alert(funGetMonthEnd(document.all("txtLocCode").value,dtGRNDate));
			if(funGetMonthEnd(document.all("txtLocCode").value,dtGRNDate)!=true)
			{
            	alert("Month End Done For Selected Month");
	            return false;
            }
			else
			{
				return true;
			}
		}
		
		//Check Month End done or not
		function funGetMonthEnd(strLocCode,transDate) {
			var strMonthEnd="";
			var searchUrl = "";
			searchUrl = getContextPath()+ "/checkMonthEnd.html?locCode=" + strLocCode+"&GRNDate="+transDate;

			$.ajax({
				type : "GET",
				url : searchUrl,
				dataType : "json",
				async: false,
				success : function(response) {
					strMonthEnd=response;
					//alert(strMonthEnd);
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
			if(strMonthEnd=="1" || strMonthEnd=="-1")
				return false;
			if(strMonthEnd=="0")
				return true;
		}
		
		//Reset Filed
		function funResetFields()
		{
			location.reload(true); 
		}
	

	function funAddChar()
	{
		var prodCode= $("#txtProdCode").val();
		window.open("frmTransectionProdChar.html?prodCode=" + prodCode, "Characteristics", "scrollbars=1,width=500,height=200,top=500, left=500");
	}
	
	function funSetCharData(value)
	{
		//alert(value);
		funLoadCharBean(value);
		var charName = "jai";
		var specf = 2;
// 		$.each(value, function(i, item)
// 			{
// 				charName = value.CharName;
// 				specf = value.specf;
// 			});
		//var datat ='{ "Char" : ['{' "CharName":"'+charName+'","specf":"'+charName+'"}]}';
// 		searchUrl = getContextPath()+ "/person?Chaar=" + value;

// 		$.ajax({
// 			type : "GET",
// 			url : searchUrl,
// 			dataType : "json",
// 			data: value, 
// 			async: false,
//  			contentType: 'application/json',
//  		    mimeType: 'application/json',
// 			success : function(data) {
// 				alert(data.id + " " + data.name);
				
// 			},
// 			error : function(jqXHR, exception) {
// 				if (jqXHR.status === 0) {
// 					alert('Not connect.n Verify Network.');
// 				} else if (jqXHR.status == 404) {
// 					alert('Requested page not found. [404]');
// 				} else if (jqXHR.status == 500) {
// 					alert('Internal Server Error [500].');
// 				} else if (exception === 'parsererror') {
// 					alert('Requested JSON parse failed.');
// 				} else if (exception === 'timeout') {
// 					alert('Time out error.');
// 				} else if (exception === 'abort') {
// 					alert('Ajax request aborted.');
// 				} else {
// 					alert('Uncaught Error.n' + jqXHR.responseText);
// 				}
// 			}
// 		});
	}
	
	
	
	function funLoadCharBean(value) {
		var searchUrl = "";
		searchUrl = getContextPath() + "/charTransectionData.html";
		//alert(searchUrl);
		$.ajax({
			type : "POST",
			url : searchUrl,
			data : JSON.stringify({ name: "Gerry", id: 20 },{ name: "Merray", id: 50 }),
			//data : JSON.stringify({ "chaaar": [{ name: "Gerry", id: 20 },{ name: "Merray", id: 50 }] }),
			contentType: 'application/json',
			success : function(data) {
				if ('Invalid Code' == value) {
					alert('Hii');
				} else {
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
	    
	    if(controller=='PayMode' && key==13)
	    {
	    	document.getElementById('txtProdCode').focus();
	    }
	    
	    
	    if(controller=='QtyRecv' && key==13)
	    {
// 	    	document.getElementById('btnAdd').focus();
	    	btnAdd_onclick();
	    }
	    
	    if(controller=='UnitPrice' && key==13)
	    {
	    	document.getElementById('txtQuantity').focus();
	    }
	    
	    else if(controller=='AddBtn' && key==13)
	    {
	    	funAddRow();	
	    }
	}
	
	function funDuplicateProductFroRow(strProdCode)
	{
	 var table = document.getElementById("tblProduct");
	    var rowCount = table.rows.length;		   
	    var flag=false;
	    if(rowCount > 0)
	    	{
			    $('#tblProduct tr').each(function()
			    {
				    if(strProdCode==$(this).find('input').val())// `this` is TR DOM element
    				{
				    	flag=true; 
				    	
	    			
    				}
				});
			    
	    	}
	    return flag;
	}
	

	function funCallBarCodeProduct(code)
{
	
		var locCode=$("#txtLocCode").val();
		var searchUrl = "";
		var suppCode=$("#txtSuppCode").val();
		var billDate=$("#txtGRNDate").val();
		var strRateFrom='<%=session.getAttribute("RateFrom").toString()%>';
		if(suppCode!="")
		{
			if(strRateFrom=="SupplierRate")
			{
				searchUrl = getContextPath()+ "/loadProductDataWithSuppWiseRate.html?prodCode=" + code+"&suppCode="+suppCode;
			}
			else
			{
				searchUrl = getContextPath()+ "/loadProductDataWithTax.html?prodCode=" + code+"&locCode="+locCode+"&suppCode="+suppCode+"&billDate="+billDate;
			}
		}
		else
		{
			searchUrl = getContextPath()+ "/loadProductDataWithTax.html?prodCode=" + code+"&locCode="+locCode+"&suppCode="+suppCode+"&billDate="+billDate;
		}
		$.ajax({
				type : "GET",
				url : searchUrl,
				dataType : "json",
				success : function(response) {

					if ('Invalid Code' == response.strProdCode) {
						alert('Invalid Product Code');
						$("#txtProdCode").val('');
						$("#lblProdName").text('');
						$("#txtProdCode").focus();
					} else {
						 var strProdCode = response.strProdCode;
						if(funDuplicateProductFroRow(strProdCode))
							{
							
							 var table = document.getElementById("tblProduct");
							  var rowCount = table.rows.length;
							  
							    if(rowCount > 0)
							    	{
									    $('#tblProduct tr').each(function()
									    {
										    if(strProdCode==$(this).find('input').val())// `this` is TR DOM element
						    				{
										    	
										    	var index=$(this).index(); //this.parentNode.parentNode.rowIndex;
												var QtyRecable=document.getElementById("txtQuantity1."+index).value;

										    	QtyRecable=parseFloat(QtyRecable);
										    	QtyRecable+=1;
										    	document.getElementById("txtQuantity1."+index).value=QtyRecable;
										    	var totalPrice = parseFloat(response.dblCostRM)*QtyRecable;
										    	document.getElementById("txtTotalPrice."+index).value=totalPrice;
										    	
//											    	if(QtyRecable>0)
//											    		{
//											    			AddRowBarCodeWise(response.strProdCode,response.strProdName,0,0,0,QtyRecable,response.dblWeight
//																	,0,response.strUOM,response.dblCostRM,0,0,'',0
//																	,'','',gPOCode,0,gTaxAmount,'',$("#hidstrStkble").val(),'');
//											    		}
						    				}
										    
										});
									    
							    	}
							   															  
							}
								else
						    	{
						    			funAddRowBarCodeWise(response.strProdCode,response.strProdName,0,0,0,1,response.dblWeight
												,0,response.strUOM,response.dblCostRM,0,0,'',0
												,'','',gPOCode,0,gTaxAmount,'',$("#hidstrStkble").val(),'');
							    }
						$("#txtProdCode").val("");
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
	
	
	function funAddRowBarCodeWise(prodCode,prodName,qtyrecb,dcQty,dcWt,qtyrecevd,wtunit
			,rejected,strUOM,unitPrice,disc,packforward,remarks,poWt,
			strIssueLocCode,strIssueLocName,code,rework,gTaxAmount,strExpiry,strStkble,strMISCode)
	{
			var  qtyDecPlace='<%=session.getAttribute("qtyDecPlace").toString()%>';
			var  amtDecPlace='<%=session.getAttribute("amtDecPlace").toString()%>';
		
			var totalWt = parseFloat(qtyrecevd).toFixed(qtyDecPlace)*parseFloat(wtunit).toFixed(qtyDecPlace);
		    totalWt=parseFloat(totalWt).toFixed(maxQuantityDecimalPlaceLimit);
		    
		    var totalPrice = (parseFloat(qtyrecevd)-parseFloat(rejected)) * parseFloat(unitPrice);
		    totalPrice=parseFloat(totalPrice).toFixed(amtDecPlace)-parseFloat(disc);
			
		    
		    var table = document.getElementById("tblProduct");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);		   
		    rowCount=listRow;
		   
		    row.insertCell(0).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strProdCode\" readonly=\"readonly\" class=\"Box prodCode\" size=\"9%\" id=\"txtProdCode."+(rowCount)+"\" value='"+prodCode+"'>";
		    row.insertCell(1).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strProdName\" readonly=\"readonly\" class=\"Box\" size=\"17%\"  id=\"lblProdName."+(rowCount)+"\" value='"+prodName+"' >";
		   
		    
		    row.insertCell(2).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblQtyRbl\" readonly=\"readonly\" type=\"text\"  required = \"required\" size=\"7%\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" class=\"decimal-places inputText-Auto QtyRecable\" id=\"txtQtyRec."+(rowCount)+"\" value='"+qtyrecb+"'>";
		    row.insertCell(3).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblDCQty\" type=\"text\"  required = \"required\" size=\"6%\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" class=\"decimal-places inputText-Auto\" id=\"txtDCQty."+(rowCount)+"\" value='"+dcQty+"'>";
		    row.insertCell(4).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblDCWt\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" size=\"6%\" class=\"decimal-places inputText-Auto\" id=\"txtDCWt."+(rowCount)+"\" value='"+dcWt+"'>";
		    row.insertCell(5).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblQty\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" size=\"6%\" class=\"decimal-places inputText-Auto QtyCell\" id=\"txtQuantity1."+(rowCount)+"\" value='"+qtyrecevd+"' onblur=\"funUpdatePrice(this);\">";
		    row.insertCell(6).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblWeight\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" size=\"5%\" class=\"decimal-places inputText-Auto\" id=\"txtWtUnit."+(rowCount)+"\" value="+wtunit+">";
		    row.insertCell(7).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblTotalWt\" class=\"Box totalWeightCell\" readonly=\"readonly\" size=\"6%\" style=\"text-align: right;;border:1px solid #a2a2a2;padding:1px;\" id=\"txtTotalWeight."+(rowCount)+"\" value="+totalWt+">";
		    row.insertCell(8).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblRejected\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;\" class=\"decimal-places inputText-Auto RejCell\" size=\"7%\" id=\"txtRejected."+(rowCount)+"\" value='"+rejected+"' onblur=\"funUpdatePrice(this);\">";
		    row.insertCell(9).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strUOM\" readonly=\"readonly\" class=\"Box\" size=\"5%\" style=\"border:1px solid #a2a2a2;padding:1px;\"id=\"txtUOM."+(rowCount)+"\" value="+strUOM+">";
		    row.insertCell(10).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblUnitPrice\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%\" class=\"decimal-places-amt inputText-Auto price\" size=\"6%\" id=\"txtCostRM."+(rowCount)+"\" value='"+unitPrice+"' onblur=\"funUpdatePrice(this);\">";
		    row.insertCell(11).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblDiscount\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" class=\"decimal-places-amt inputText-Auto txtDisc\" size=\"6%\" id=\"txtDiscount."+(rowCount)+"\" value='"+disc+"' onblur=\"funUpdatePrice(this);\">";
		    row.insertCell(12).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblPackForw\"type=\"text\"  required = \"required\" style=\"text-align: right;width:100%;border:1px solid #a2a2a2;padding:1px;\" class=\"decimal-places inputText-Auto\" size=\"6%\" id=\"txtPack."+(rowCount)+"\" value="+packforward+" onblur=\"funUpdatePrice(this);\">";
		    row.insertCell(13).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblTotalPrice\" class=\"Box totalPriceCell\" readonly=\"readonly\" style=\"text-align: right;;border:1px solid #a2a2a2;padding:1px;\" size=\"7%\" id=\"txtTotalPrice."+(rowCount)+"\" value="+totalPrice+">";
		    row.insertCell(14).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strRemarks\"  size=\"17%\"  id=\"txtRemark."+(rowCount)+"\" value='"+remarks+"'>";
		    row.insertCell(15).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblPOWeight\" type=\"text\"  required = \"required\" style=\"text-align: right;width:100%\" class=\"decimal-places inputText-Auto\"  size=\"6%\" id=\"txtPOWt."+(rowCount)+"\" value="+poWt+">";
		    
		    if(strStkble=="Yes")
		    {
			    row.insertCell(16).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strIssueLocation\" required = \"required\" readonly=\"readonly\" class=\"Box IssueLocCode\" size=\"4%\"  id=\"txtIssueLocation."+(rowCount)+"\" value='"+strIssueLocCode+"' ><input type=button   onclick=funHelp1("+(rowCount)+",'IssueLoc1') value=...>";
			    row.insertCell(17).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strIsueLocName\" readonly=\"readonly\" class=\"Box\" size=\"20%\"  id=\"txtIsueLocName."+(rowCount)+"\" value='"+strIssueLocName+"' >";
		    }
		    else
		    {
		    	row.insertCell(16).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strIssueLocation\" readonly=\"readonly\" class=\"Box IssueLocCode\" size=\"4%\"  id=\"txtIssueLocation."+(rowCount)+"\" value='"+strIssueLocCode+"' >";
			    row.insertCell(17).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strIsueLocName\" readonly=\"readonly\" class=\"Box\" size=\"20%\"  id=\"txtIsueLocName."+(rowCount)+"\" value='"+strIssueLocName+"' >";
		    } 
		    
		    
		    row.insertCell(18).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strCode\" readonly=\"readonly\" class=\"Box PoCode\" size=\"10%\" id=\"txtCode."+(rowCount)+"\" value="+code+">";
		    
		    row.insertCell(19).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].dblRework\" type=\"text\" required = \"required\" style=\"text-align: right;width:100%\" class=\"decimal-places inputText-Auto\" size=\"5%\" id=\"txtRework."+(rowCount)+"\" value="+rework+">";
		    row.insertCell(20).innerHTML= "<input type=\"hidden\" id=\"txtTempTax."+(rowCount)+"\" size=\"0%\" value="+gTaxAmount+">";
		    row.insertCell(21).innerHTML= '<input type="button" value = "Delete" class="deletebutton" onClick="Javacsript:funDeleteRow(this)">';
		    row.insertCell(22).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strExpiry\" type=\"hidden\" value = '"+strExpiry+"' >";
		    row.insertCell(23).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strStkble\" type=\"hidden\" value = '"+strStkble+"' >";
		    row.insertCell(24).innerHTML= "<input name=\"listGRNDtl["+(rowCount)+"].strMISCode\" type=\"hidden\" value = '"+strMISCode+"' >";
		    
		    listRow++;
// 		    funUpdateIssueUOM();
		    funResetProductFields();
		    funGetTotal();
		    funApplyNumberValidation();
		    $("#txtProdCode").focus();
		    return false;
		
	}
	
	
	function funSetDSCode(code)
	{
		
		var searchUrl="";
		searchUrl=getContextPath()+"/loadAgainstDS.html?dsCode="+code;			
		$.ajax({
		        type: "GET",
		        url: searchUrl,
			    dataType: "json",
			    success: function(response)
			    {
			    	$("#txtDocCode").val(response.strPONo);
			    	$("#txtLocCode").val(response.strLocCode);
			    	$("#lblLocName").text(response.strLocName);

			    	funRemoveProductRows();
		    		$.each(response.listGRNDtl, function(i,item)
		                    {	
		    			funAddProductForGRN(this.strProdCode, this.strProdName,this.strUOM, this.dblUnitPrice, this.dblWeight
								,this.dblQty, this.dblQtyRbl, this.dblDCWt,this.dblDCQty, this.dblRejected,this.dblPOWeight
								,this.dblRework,this.dblPackForw, this.strRemarks, this.dblDiscount, '',this.strCode
								,this.dblTotalPrice,this.strExpiry,this.strIssueLocation,this.strIsueLocName,this.strStkble
								,this.strMISCode,this.strReqCode,this.strGroupTaxCode);
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
	
	
	function funGetCurrencyCode(code){

		var amt=1;
		$.ajax({
			type : "POST",
			url : getContextPath()+ "/loadCurrencyCode.html?docCode=" + code,
			dataType : "json",
			async:false,
			success : function(response){ 
				if(response.strCurrencyCode=='Invalid Code')
	        	{
	        		
	        	}
	        	else
	        	{        
	        		amt=response.dblConvToBaseCurr;
		        
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
		return amt;
	}

function funOnChangeCurrency(){
	var cmbCurrency=$("#cmbCurrency").val();
	var currValue=funGetCurrencyCode(cmbCurrency);
	$("#txtDblConversion").val(currValue);
}	
		
function funCalculateOtherChargesTotal()
{
	$("#txtFOB").val($("#txtSubTotal").val());
	var FOBAmt=$("#txtFOB").val();
	var freightAmt=$("#txtFreight").val();
	var insuranceAmt=$("#txtInsurance").val();
	var otherChargesAmt=$("#txtOtherCharges").val();
	var CIFAmt=(parseFloat(FOBAmt)+parseFloat(freightAmt)+parseFloat(insuranceAmt)+parseFloat(otherChargesAmt));
	$("#txtCIF").val(CIFAmt);
	var otherCharges=parseFloat(freightAmt)+parseFloat(insuranceAmt)+parseFloat(otherChargesAmt);
	
	var subTotal=$("#txtSubTotal").val();
	var extraCharges=$("#txtExtraCharges").val();
	var discAmt=$("#txtDiscAmount").val();
	discAmt=parseFloat(discAmt).toFixed(maxAmountDecimalPlaceLimit);
	var taxAmt=$("#txtGRNTaxAmt").val();
	
	var finalAmt=(parseFloat(subTotal)+parseFloat(otherCharges)+parseFloat(extraCharges)+parseFloat(taxAmt)-parseFloat(discAmt));
	finalAmt=parseFloat(finalAmt).toFixed(maxAmountDecimalPlaceLimit);
	
	var roundOff=0.0;
	var finalAmtWithRoundoff=Math.round(finalAmt);
	roundOff=(parseFloat(finalAmtWithRoundoff)-parseFloat(finalAmt)).toFixed(maxAmountDecimalPlaceLimit);
	
	$("#hidRoundOff").val(roundOff)
	
	if(strRoundOffFinalAmtOnTransaction){
		$("#txtFinalAmt").val(finalAmtWithRoundoff);	
	}else{
		$("#txtFinalAmt").val(finalAmt);
	}
	
	$("#lblPOGrandTotal").text(finalAmtWithRoundoff);
}
  
   function funSetgroupTaxCodeForGRN(code,groupTaxRow)
   {

		var flag=0;
		var searchUrl="";  
		searchUrl = getContextPath()
		+ "/loadGroupTaxCodeForGRN.html?groupTaxCode=" + code;
		$.ajax({
		        type: "GET",
		        url: searchUrl,
		        async : true,
			    dataType: "json",
			    success: function(response)
			    {
		    		document.getElementById("groupTaxCode."+groupTaxRow).value=response[0][0]; 		    		

		
			    	document.getElementById("strGroupTaxName."+groupTaxRow).value=response[0][1];						
			    },
			    error: function(jqXHR, exception)
			    {
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

<body>
	<div class="container">
		<label id="formHeading">GRN</label>
		<s:form name="grn" method="POST"
			action="saveGRN.html?saddr=${urlHits}">
			<input type="hidden" id="authorizePer" value="${authorizePer}">
			<input id="txtWtUnit" type="hidden" value="0"
				class="decimal-places numberField"></input>

			<div id="tab_container">
				<ul class="tabs">
					<li class="active" data-state="tab1">General</li>
					<li data-state="tab2">Taxes</li>
					<li data-state="tab3">Other Charges</li>
				</ul>
				<div id="tab1" class="tab_content">
					<div class="row transTable">
						<div class="col-md-2">
							<label id="lblGRNCode">GRN Code</label>
							<s:input id="txtGRNCode" path="strGRNCode"
								ondblclick="funHelp('grncode')" cssClass="searchTextBox" />
						</div>
						<div class="col-md-2">
							<label id="lblGRNNo">GRN No</label>
							<s:input id="txtGRNNo" path="strGRNNo" />
						</div>
						<div class="col-md-2">
							<label id="lblGRNDate">GRN Date</label>
							<s:input id="txtGRNDate" required="required" path="dtGRNDate"
								pattern="\d{1,2}-\d{1,2}-\d{4}" cssClass="calenderTextBox"
								style="width:80%" />
						</div>
						<div class="col-md-2">
							<label id="lblBillNo">Bill No</label>
							<s:input id="txtBillNo" path="strBillNo" required="required"
								onkeypress="funGetKeyCode(event,'BillNo')" />
						</div>
						<div class="col-md-4"></div>

						<div class="col-md-2">
							<label id="lblSuppCode">Supplier</label>
							<s:input id="txtSuppCode" required="required" path="strSuppCode"
								ondblclick="funHelp('suppcodeActive')" cssClass="searchTextBox" />
						</div>

						<div class="col-md-2">
							<label for="strSuppName" id="txtSuppName"
								style="font-size: 12px; background-color: #dcdada94; width: 100%; height: 51%; margin-top: 27px; padding: 4px;"></label>
						</div>

						<div class="col-md-2">
							<label id="lblChallanDate">Bill Date</label>
							<s:input id="txtChallanDate" required="required"
								path="dtBillDate" pattern="\d{1,2}-\d{1,2}-\d{4}"
								cssClass="calenderTextBox"
								onkeypress="funGetKeyCode(event,'BillDate')" style="width:80%" />
						</div>

						<div class="col-md-2">
							<label id="lblDueDate">Due Date</label>
							<s:input id="txtDueDate" required="required" path="dtDueDate"
								pattern="\d{1,2}-\d{1,2}-\d{4}" cssClass="calenderTextBox"
								style="width:80%" />
						</div>
						<div class="col-md-4"></div>

					

						<div class="col-md-2">
							<label id="lblPayMode">Settlement Mode</label>
							<s:select id="txtPayMode" path="strPayMode"
								items="${settlementList}"
								onkeypress="funGetKeyCode(event,'PayMode')">
							</s:select>

							<%-- <div class="col-md-2"><s:select id="txtPayMode" path="strPayMode"  cssClass="BoxW124px" onkeypress="funGetKeyCode(event,'PayMode')">
											<option value="Credit" selected>CREDIT</option>
											<option value="Cash">CASH</option>
										</s:select></div> --%>
						</div>

						<div class="col-md-2">
							<label id="lblLocation">Location</label>
							<s:input id="txtLocCode" path="strLocCode" required="required"
								value="${locationCode}" ondblclick="funHelp('locationmaster')"
								cssClass="searchTextBox" />
						</div>

						<div class="col-md-2">
							<s:label id="lblLocName" path="strLocName"
								style="background-color:#dcdada94; width: 100%; height:51%;margin-top: 27px;padding:4px;" />
						</div>
						<div class="col-md-2">
							<label>Free Qty</label>
							<s:input id="txtFreeQty" value="0" style="text-align: right;"
								path="dblFreeQty" cssClass="decimal-places-amt numberField" />
						</div>
						<div class="col-md-4"></div>
						<div class="col-md-2">
							<label>Product Code</label> <input id="txtProdCode"
								ondblclick="funOpenHelp()" class="searchTextBox"></input>
						</div>

						<div class="col-md-2">
							<label id="lblProdName"
								style="font-size: 12px; background-color: #dcdada94; width: 100%; height: 51%; margin-top: 27px; padding: 4px;"></label>
						</div>
						  <div class="col-md-2">
							<label>Quantity Received</label> <input id="txtQuantity" value=""
								type="text" class="decimal-places numberField"
								onkeypress="funGetKeyCode(event,'QtyRecv')"></input>
						</div>
						<div class="col-md-2">
							<label>Unit Price</label> <input type="text" id="txtCostRM"
								value="0" style="text-align: right;"
								class="decimal-places-amt numberField"
								onkeypress="funGetKeyCode(event,'UnitPrice')"></input>
						</div>
						<div class="col-md-2">
							<label id="lblGroupTaxCode">Tax Mode</label>
							<s:select id="txtGroupTaxCode" path="strGroupTaxCode"
								items="${mapTaxGroupName}">
							</s:select>
                       </div>
						
					</div>


					<div class="row transTable">
						<div class="col-md-0"></div>
                     <div class="col-md-2">
							<label id="lblPOCode">PO Code</label> <select id="cmbPODoc"></select>
						</div>

						<div class="col-md-2">
							<input type="hidden" id="txtExpiry"></input>
						</div>
						
						
                      

						<div class="col-md-2">
							<label>UOM</label>
							<s:select id="cmbUOM" name="cmbUOM" path="" items="${uomList}" />
						</div>
						<!-- <td width="0%"><input id="txtWtUnit" type="hidden" value="0" class="decimal-places numberField" ></input></td> -->
						

						<div class="col-md-2">
							<label>Discount Amount</label> <input id="txtDiscount" value="0"
								style="text-align: right;" type="text"></input>
						</div>
						<div class="col-md-4"></div>
							<div class="col-md-2">
							<label id="idAgainst"> Against </label>
							<s:select id="cmbAgainst" items="${strProcessList}"
								onchange="funOnChange();" name="cmbAgainst" path="strAgainst">
							</s:select>
						</div>

						<div class="col-md-2">
							<label id="idConsolidated"> Consolidated PO </label><br> <input type="checkbox"
								id="chkConsPO">
						</div>

						<div class="col-md-2">
							<s:input id="txtDocCode" path="strPONo" readonly="readonly"
								ondblclick="funOpenAgainst()" class="searchTextBox"
								style="margin-top:23px;"></s:input>
						</div>

						<div class="col-md-2">
							<br> <input type="button" value="Fill"
								class="btn btn-primary center-block" class="smallButton"
								onclick="funSetPurchaseOrder();" id=btnFill />
						</div>
						<div class="col-md-4"></div>
						
                           <div class="col-md-2">
							<label id="lblCurrencyList">Currency </label>
							<s:select id="cmbCurrency" items="${currencyList}"
								path="strCurrency" onchange="funOnChangeCurrency()">
							</s:select>
						</div>

						<div class="col-md-2">
							<br>
							<s:input id="txtDblConversion" path="dblConversion" type="text"
								style="margin-top:10px; text-align:right;"></s:input>
						</div>

						<div class="col-md-2">
							<label id="lblInwRefNo">Inward Ref No</label>
							<s:input id="txtInwRefNo" path="strRefNo" />
						</div>
						<div class="col-md-2">
							<label id="lblRefDate">Inward Ref Date</label>
							<s:input id="txtRefDate" required="required" path="dtRefDate"
								pattern="\d{1,2}-\d{1,2}-\d{4}" cssClass="calenderTextBox"
								style="width:80%" />
						</div>

						<!-- 									<td><input id="btnAddChar" type="button" value="..."   onclick="funAddChar()"  style="visibility: hidden" ></input></td> -->

						<div class="col-md-2">
							<label id="lblIssueLocation">Issue Location</label> <input
								id="txtIssueLocCode" ondblclick="funHelp('Issuelocationmaster')"
								Class="searchTextBox" />
						</div>

						<div class="col-md-2">
							<s:label id="lblIssueLocName" path="strLocName"
								style="background-color:#dcdada94; width: 100%; height:51%;margin-top: 27px;padding:4px;" />
						</div>
                  

						<div class="col-md-2">
							<label id="lblRejectedQty">Rejected</label> <input id="txtRejected" value="0"
								style="text-align: right;" type="text"
								class="decimal-places numberField"></input>
						</div>
						

						<div class="col-md-2">
							<label id="idlblDCWT" >DC/Wt</label> <input id="txtDCWt" value="0" type="text"
								style="text-align: right;" class="decimal-places numberField"></input>
						</div>

						<div class="col-md-2">
							<label id="idlblDCQty">DC Qty</label> <input id="txtDCQty" value="0" type="text"
								style="text-align: right;" class="decimal-places numberField"></input>
						</div>

						<div class="col-md-2">
							<label id="idQuantityReceiveable">Quantity Receiveable</label> <input id="txtQtyRec"
								value="0" type="text" style="text-align: right;"
								class="decimal-places numberField"></input>
						</div>
						<div class="col-md-4"></div>

						<div class="col-md-2">
							<label id="idBinNo">Bin No</label> <input id="txtBinNo" value="" type="text"></input>
						</div>

						<div class="col-md-2">
							<label id="idPOWeight">PO Weight</label> <input id="txtPOWt" value="0.00"
								type="text" style="text-align: right;"
								class="decimal-places numberField"></input>
						</div>

						<div class="col-md-2">
							<label id="idlblRework">Rework</label> <input id="txtRework" value="0.00"
								type="text" style="text-align: right;"
								class="decimal-places numberField"></input>
						</div>

						<div class="col-md-2">
							<label id="idlblPackAndForwording">Packaging & Forwording</label> <input id="txtPack"
								value="0.00" type="text" style="text-align: right;"
								class="decimal-places numberField"></input>
						</div>
						<div class="col-md-4"></div>

						<div class="col-md-2">
							<label id="idlblRemark">Remarks</label> <input id="txtRemark" value="" type="text"></input>
						</div>
						   
						<%-- <div class="col-md-2"><s:select id="txtPayMode" path="strPayMode"  cssClass="BoxW124px" onkeypress="funGetKeyCode(event,'PayMode')">
											<option value="Credit" selected>CREDIT</option>
											<option value="Cash">CASH</option>
						</s:select></div> --%>	
											
						<div class="col-md-2">
							<input id="hidstrStkble" type="hidden" />
						</div>
						<div class="col-md-8"></div>
                      	<div class="col-md-2">
							<br> <input id="btnAdd" type="button" value="Add"
								onclick="return btnAdd_onclick();"
								class="btn btn-primary center-block"
								onkeypress="funGetKeyCode(event,'AddBtn')"></input>
						</div>
                        <div class="col-md-2">
								<input type="button" id="btnGenTaxFrontBtn" value="Calculate Tax"
									class="btn btn-primary center-block" class="form_button" style="margin-top: 10%;" />
						</div>
					</div>
					<br>
					<div class="dynamicTableContainer" style="height: 400px">
						<table style="height: 20px; border: #0F0; width: 158%; font-size: 11px; font-weight: bold;">
							<tbody><tr bgcolor="#c0c0c0">
							<td width="3%">Product Code</td>
								<!--  COl1   -->
								<td width="3%">Product Name</td>
								<!--  COl2   -->
								<td width="2%" style="padding-left: 18px;">Qty Rec'd</td>
								<!--  COl8   -->
								<td width="2%">Free Qty</td>
								<!--  COl9   -->
								<td width="1%" style="padding-right: 0px;">Rejected</td>
								<!--  COl11   -->
								<td width="1%" style="padding-left: 1px;">UOM</td>
								<!--  COl12   -->
								<td width="2%" style="padding-right: 10px;">Unit Price</td>
								<!--  COl13   -->
								<td width="1%" style="/* padding-right: 9px; */">Discount</td>
								<!--  COl14   -->
								<td width="2%">Total Price</td>
								<!--  COl16   -->
								<td width="3%" style="padding-left: 10px;">Tax Name</td>
								<td width="3%" style="padding-left:30px;">Remarks</td>
								<!--  COl17   -->
								<td width="3%" style="align: center;padding-left: 18px;">Qty Rec'able</td>
								<!--  COl5  -->
								<td width="2%">DC Qty</td>
								<!--  COl6   -->
								<td width="2%">DC Wt</td>
								<!--  COl7   -->
								<td width="1%">Wt/Unit</td>
								<!--  COl9   -->
								<td width="2%">Total Wt</td>
								<!--  COl10   -->								
								<td width="1%">P&amp;F</td>
								<!--  COl15   -->							
								<td width="1%">PO Weight</td>
								<!--  COl18   -->
								<td width="3%" style="adding-left: 5px;">Issue Loc Code</td>
								<!--  COl3   -->
								<td width="4%">Location Name</td>
								<!--  COl4   -->
								<td width="2%">code</td>
								<!--  COl19   -->
								<td width="1%">rework</td>
								<!--  COl120   -->
								<td style="width: 10%; display: none">gTaxAmount</td>
								<!--  COl21   -->
								<td width="1%" style="align-content: flex-end;">Delete</td>
								<!--  COl22   -->
								<td style="width: 5%; display: none">Stkble</td>
								<!-- COl23   -->
								<td style="width: 5%; display: none">MISCode</td>
								<!-- COl24   -->
							</tr>
						</tbody></table>
						<div
							style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height:360px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 158%;">
							<table id="tblProduct"
								style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll;display:flex"
								class="transTablex col20-center">
								<tbody>
								<col style="width: 7%">
								<!--  COl1   -->
								<col style="width: 12%">
								<!--  COl2   -->
								<col style="width: 6%">
								<!--  COl5   -->
								<col style="width: 6%">
								<!--  COl6   -->
								<col style="width: 6%">
								<!--  COl7   -->
								<col style="width: 6%">
								<!--  COl8   -->
								<col style="width: 6%">
								<!--  COl9   -->
								<col style="width: 6%">
								<!--  COl9   -->
								<col style="width: 6%">
								<!--  COl10   -->
								<col style="width: 5%">
								<!--  COl11 -->
								<col style="width: 6%">
								<!--  COl12   -->
								<col style="width: 6%">
								<!--  COl13   -->
								<col style="width: 5%">
								<!--  COl14   -->
								<col style="width: 5%">
								<!--  COl15   -->
								<col style="width: 6%">
								<!--  COl16   -->
								<col style="width: 10%">
								<!--  COl17   -->
								<col style="width: 6%">
								<!--  COl18   -->
								<col style="width: 5%">
								<!--  COl3   -->
								<col style="width: 13%">
								<!--  COl4   -->
								<col style="width: 8%">
								<!--  COl19   -->
								<col style="width: 5%">
								<!--  COl20   -->
								<col style="width: 1%">
								<!--  COl21   -->
								<col style="width: 10%">
								<!--  COl22   -->
								<col style="width: 2%">
								<!--  COl23   -->
								<col style="width: 3%; display: none">
								<!--  COl24  -->
								<col style="width: 3%; display: none">
								<!--  COl25  -->

								<%-- <c:forEach items="${command.listGRNDtl}" var="grn" varStatus="status">
					
									<tr>
										<td><input readonly="readonly" class="Box" size="10%" name="listGRNDtl[${status.index}].strProdCode" value="${grn.strProdCode}"/></td>
										<td><input readonly="readonly" class="Box" size="35%" name="listGRNDtl[${status.index}].strProdName" value="${grn.strProdName}" /></td>
										<td><input readonly="readonly" class="inputText-Right Box" size="7%" name="listGRNDtl[${status.index}].dblQtyRbl" value="${grn.dblQtyRbl}" /></td>
										<td><input readonly="readonly" class="inputText-Right Box" size="6%" name="listGRNDtl[${status.index}].dblDCQty" value="${grn.dblDCQty}" /></td>
										<td><input readonly="readonly" class="inputText-Right Box" size="6%" name="listGRNDtl[${status.index}].dblDCWt" value="${grn.dblDCWt}"/></td>
										<td><input class="inputText-Right Box"  size="6%" name="listGRNDtl[${status.index}].dblQty" id="txtQuantity1.${status.index}" id="txtQuantity1.${status.index}" value="${grn.dblQty}"/></td>
										<td><input class="inputText-Right Box"  size="6%" name="listGRNDtl[${status.index}].dblWeight" value="${grn.dblWeight}" /></td>
										<td><input readonly="readonly" class="inputText-Right Box"  size="6%" name="listGRNDtl[${status.index}].dblTotalWt" value="${grn.dblTotalWt}" id="txtTotalWeight.${status.index}" /></td>
										<td><input class="inputText-Right Box"  size="6%" name="listGRNDtl[${status.index}].dblRejected" value="${grn.dblRejected}" class="inputText-Auto"/></td>
										<td><input readonly="readonly" class="Box" size="5%" name="listGRNDtl[${status.index}].strUOM" value="${grn.strUOM}"/></td>
										<td><input class="inputText-Right Box" readonly="readonly" size="6%" name="listGRNDtl[${status.index}].dblUnitPrice" id="txtCostRM.${status.index}" value="${grn.dblUnitPrice}" /></td>
										<td><input class="inputText-Right Box" size="6%"  name="listGRNDtl[${status.index}].dblDiscount" value="${grn.dblDiscount}" /></td>
										<td><input class="inputText-Right Box"  size="6%" name="listGRNDtl[${status.index}].dblPackForw" value="${grn.dblPackForw}"  /></td>
										<td><input readonly="readonly" class="inputText-Right Box" size="6%" name="listGRNDtl[${status.index}].dblTotalPrice" value="${grn.dblTotalPrice}" id="txtTotalPrice.${status.index}"  /></td>
										<td><input class="inputText-Left Box"  size="30%" name="listGRNDtl[${status.index}].strRemarks" value="${grn.strRemarks}" /></td>
										<td><input class="inputText-Right Box" size="6%" name="listGRNDtl[${status.index}].dblPOWeight" value="${grn.dblPOWeight}" /></td>					
										<td><input readonly="readonly" class="Box" size="15%"  name="listGRNDtl[${status.index}].strCode" value="${grn.strCode}" /></td>
										<td><input class="inputText-Right Box" size="5%" name="listGRNDtl[${status.index}].dblRework" value="${grn.dblRework}" /></td>
					
										 <td><input type="button" value = "Delete" onClick="Javacsript:funDeleteRow(this)" class="deletebutton"></td>
										
									</tr>
								</c:forEach> --%>
								</tbody>
							</table>
						</div>

					</div>
					<br>
					<div class="row transTable">
						<div class="col-md-2">
							<label id="lblTotalWt">Total Weight</label> <input type="text"
								id="txtTotalWt" value="0.0"
								style="background-color: #fff; text-align: right;"
								disabled="disabled" class="decimal-places-amt numberField" />
						</div>

						<div class="col-md-2">
							<label id="lblTotalQty">Total Quantity</label> <input
								id="txtTotalQty" type="text" value="0.0"
								style="background-color: #fff; text-align: right;"
								disabled="disabled" class="decimal-places-amt numberField" />
						</div>
						<div class="col-md-2">
							<label id="lblSubTotal">Sub Total</label>
							<s:input id="txtSubTotal" type="text" path="dblSubTotal"
								readonly="true" style="text-align: right;"
								cssClass="decimal-places-amt numberField" />
						</div>

						<div class="col-md-2">
							<label id="lblDiscPer">Discount %</label>
							<s:input id="txtDiscPer" path="dblDisRate" type="text"
								style="text-align: right;" onblur="funCalDiscountAmt();"
								class="decimal-places-amt numberField" />
						</div>
						<div class="col-md-2">
							<label id="lblDiscAmount">Discount Amount</label>
							<s:input id="txtDiscAmount" path="dblDisAmt" type="text"
								style="text-align: right;" onblur="funCalDiscountPercentage();"
								class="decimal-places-amt numberField" />
						</div>

						<div class="col-md-2">
							<label id="lblNarration">Narration</label>
							<s:textarea cssStyle="width:80%" id="txtNarration"
								path="strNarration" />
						</div>

						<div class="col-md-2">
							<label id="lblExtraCharges">Extra Charges</label>
							<s:input id="txtExtraCharges" type="text" path="dblExtra"
								style="text-align:right" onblur="funGetTotal();"
								class="decimal-places-amt numberField" />
						</div>

						<div class="col-md-2">
							<label id="lblLessAmt">Less Amount</label>
							<s:input id="txtLessAmt" path="dblLessAmt" type="text"
								style="text-align:right; " onblur="funGetTotal();"
								class="decimal-places-amt numberField" />
						</div>
						<div class="col-md-2">
							<label id="lblFinalAmt">Final Amount</label>
							<s:input type="text" id="txtFinalAmt" path="dblTotal"
								style="text-align: right;" readonly="true"
								cssClass="decimal-places-amt numberField" />
						</div>
						<div class="col-md-2">
							<label id="lblVehicleNo">Vehicle No</label>
							<s:input id="txtVehicleNo" path="strVehNo" />
						</div>
						<div class="col-md-2">
							<label id="lblTimeIn">Time In</label>
							<s:input id="txtTimeIn" path="strTimeInOut" />
						</div>
						<div class="col-md-2">
							<label id="lblMInBy">Material Brought In By</label>
							<s:input id="txtMInBy" path="strMInBy" />
						</div>
					</div>
				</div>

				<div id="tab2" class="tab_content">
					<br>
					<br>
					<div class="container masterTable">
						<div class="row">
							<div class="col-md-12">
								<input type="button" id="btnGenTax" value="Calculate Tax"
									class="btn btn-primary center-block" class="form_button">
							</div>
							<div class="col-md-2">
								<label>Tax Code</label> <input type="text" id="txtTaxCode"
									ondblclick="funHelp('OpenTaxesForPurchase');"
									class="searchTextBox" />
							</div>
							<div class="col-md-2">
								<label>Tax Description</label> <label id="lblTaxDesc"
									style="background-color: #dcdada94; width: 100%; height: 52%; text-align: center;"></label>
							</div>
							<div class="col-md-8"></div>

							<div class="col-md-2">
								<label>Taxable Amount</label> <input type="number"
									style="text-align: right;" step="any" id="txtTaxableAmt" />
							</div>
							<div class="col-md-2">
								<label>Tax Amount</label> <input type="number"
									style="text-align: right;" step="any" id="txtTaxAmt" />
							</div>
							<div class="col-md-2">
								<input type="button" id="btnAddTax" value="Add"
									class="btn btn-primary center-block" style="margin-top: 27px;" />
							</div>
						</div>
					</div>
					<br>
					<table style="width: 60%; margin: 0px;"
						class="transTablex col5-center">
						<tr style="background-color: #c0c0c0;">
							<td style="width: 10%">Tax Code</td>
							<td style="width: 7%">Description</td>
							<td style="width: 8%">Taxable Amount</td>
							<td style="width: 6%">Tax Amount</td>
							<td style="width: 6%">Delete</td>
						</tr>
					</table>
					<div
						style="background-color: #fbfafa; border: 1px solid #ccc; display: block; height: 150px; overflow-x: hidden; overflow-y: scroll; width: 60%;">
						<table id="tblTax" class="transTablex col5-center"
							style="width: 100%;">
							<tbody>
							<col style="width: 5%;">
							<!--  COl1   -->
							<col style="width: 3%;">
							<!--  COl2   -->
							<col style="width: 5%;">
							<!--  COl3   -->
							<col style="width: 10%">
							<!--  COl4   -->
							<col style="width: 6%">
							<!--  COl5   -->
							</tbody>
						</table>
					</div>
					<br>
					<div id="tblTaxTotal" class="row masterTable">
						<div class="col-md-2">
							<label>Taxable Amt Total</label> <label id="lblTaxableAmt"
								style="background-color: #dcdada94; width: 100%; height: 55%; text-align: center;"></label>
						</div>
						<div class="col-md-2">
							<label>Tax</label> <label id="lblTaxTotal"
								style="background-color: #dcdada94; width: 100%; height: 55%; text-align: center;"></label>
							<s:input type="hidden" id="txtGRNTaxAmt" path="dblTaxAmt" />
						</div>
						<div class="col-md-2">
							<label>Grand Total</label> <label id="lblGRNGrandTotal"
								style="background-color: #dcdada94; width: 100%; height: 55%; text-align: center;"></label>
						</div>
					</div>
				</div>

				<div id="tab3" class="tab_content">
					<br>
					<br>
					<div class="row masterTable" id="tblOtherCharges">
						<div class="col-md-2">
							<label id="lblFOB">FOB</label>
							<s:input type="text" id="txtFOB" path="dblFOB"
								onblur="funCalculateOtherChargesTotal();"
								class="decimal-places-amt numberField" />
						</div>
						<div class="col-md-2">
							<label id="lblFreight">Freight</label>
							<s:input type="text" id="txtFreight" path="dblFreight"
								onblur="funCalculateOtherChargesTotal();"
								class="decimal-places-amt numberField" />
						</div>
						<div class="col-md-2">
							<label id="lblInsurance">Insurance</label>
							<s:input type="text" id="txtInsurance" path="dblInsurance"
								onblur="funCalculateOtherChargesTotal();"
								class="decimal-places-amt numberField" />
						</div>
						<div class="col-md-2">
							<label id="lblOtherCharges">Other Charges</label>
							<s:input type="text" id="txtOtherCharges" path="dblOtherCharges"
								onblur="funCalculateOtherChargesTotal();"
								class="decimal-places-amt numberField" />
						</div>
						<div class="col-md-4"></div>
						<div class="col-md-2">
							<label id="lblCIF">CIF</label>
							<s:input type="text" id="txtCIF" path="dblCIF" readonly="true"
								onblur="funCalculateOtherChargesTotal();"
								class="decimal-places-amt numberField" />
						</div>
						<div class="col-md-2">
							<label id="lblClearingAgentCharges">Clearing Agent
								Charges</label>
							<s:input type="text" id="txtClearingAgentCharges"
								path="dblClearingAgentCharges"
								class="decimal-places-amt numberField" />
						</div>
						<div class="col-md-2">
							<label id="lblVATClaim">VAT Claim</label>
							<s:input type="text" id="txtVATClaim" path="dblVATClaim"
								class="decimal-places-amt numberField" />
						</div>
					</div>
				</div>
			</div>
			<br>
			<br>

			<div class="center" style="text-align: center">
				<a href="#"><button class="btn btn-primary center-block"
						value="Submit" id="btnSaveGRN"
						onclick="return funValidateFields();">Submit</button></a> &nbsp; 
					<input type="button"  class="btn btn-primary center-block"
						id="btnReset" value="Reset" onclick="funResetFields()" />
			</div>

			<div id="wait"
				style="display: none; width: 60px; height: 60px; border: 0px solid black; position: absolute; top: 60%; left: 55%; padding: 2px;">
				<img
					src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif"
					width="60px" height="60px" />
			</div>
			<s:input id="hidRoundOff" value="0" path="dblRoundOff" type="hidden"></s:input>
			<s:input id="hidstrRateEditableYN" value="" path="StrRateEditableYN"
				type="hidden"></s:input>

		</s:form>
	</div>
	<script type="text/javascript">
	funApplyNumberValidation();
	funOnChange();
	</script>
</body>
</html>