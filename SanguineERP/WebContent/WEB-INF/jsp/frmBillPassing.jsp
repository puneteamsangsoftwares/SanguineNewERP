<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
	
	    <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />

		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

<title>BILL PASSING</title>
	
<script type="text/javascript">

	$(document).ready(function() {

		$(".tab_content").hide();
		$(".tab_content:first").show();

		$("ul.tabs li").click(function() {
			$("ul.tabs li").removeClass("active");
			$(this).addClass("active");
			$(".tab_content").hide();

			var activeTab = $(this).attr("data-state");
			$("#" + activeTab).fadeIn();
		});
	});

	
		var fieldName;
		$(function()
		{
			$("#txtBillDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtBillDate" ).datepicker('setDate', 'today');
			$("#txtPassDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtPassDate" ).datepicker('setDate', 'today');
			
			$("#btnAddGRN").click(function()
			{
				var strGRNCodeAll =$("#txtGRNNo").val();
				if(strGRNCodeAll =='')
			    {
					alert("Please Enter GRN No");
		    		$("#txtGRNNo").focus();
		        	return false;
				}
				
				var strGRNCodeArr=strGRNCodeAll.split(',');
				$.each(strGRNCodeArr,function(i,strGRNCode){
				
					
					funSetGRN(strGRNCode);
					
					if(funDuplicateGRN(strGRNCode))
					{
							funAddGRNRow();
					}

				});
						
			});
			
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
			
			$("#btnSubmit").click(function()
			{
				if($("#txtBillDate").val().trim().length==0)
			    {
					alert("Please Enter Bill Date");
			       	return false;
				}
				if($("#txtPassDate").val().trim().length==0)
			    {
					alert("Please Enter Bill Passing Date");
			       	return false;
				}
				
				if(!fun_isDate($("#txtBillDate").val()))
				{
				 	alert('Invalid Date');
			        $("#txtBillDate").focus();
			        return false;
				}
				if(!fun_isDate($("#txtPassDate").val())){
					alert('Invalid Date')
			        $("#txtPassDate").focus();
			        return false;
				}
				if($("#txtSupplierCode").val().trim().length==0)
				{
				 	alert("Please Enter Supplier Code Or Search");
				 	$("#txtSupplierCode").focus();
				 	return false;
				}
				var GRNtable = document.getElementById("tblGRN");
				var rowCountGRN = GRNtable.rows.length;
				if(rowCountGRN == 0){
					alert('Please Add GRN In Grid');
					return false;
				}
				var table = document.getElementById("tblTax");
				var rowCount = table.rows.length;
				  
// 				if(rowCount == 0)
// 				{
// 					alert('Please Add Tax In Grid');
// 					return false;
// 				}
// 				else
// 				{
// 					return true;
// 				}
			});
		});
	
	
		function funHelp(transactionName) 
		{
			fieldName = transactionName;
			if(transactionName=="grncode")
			{
				if($("#txtSupplierCode").val()=='')
				{
					alert("Please Select Supplier");
					return false;
				}
				else
				{
					//window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
					window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
				}
			}
			else
			{
				//window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
				window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
			}
		}
		
		
		function funSetData(code)
		{
			switch (fieldName) 
			{
			    case 'suppcodeActive':
			    	funSetSupplier(code);
			        break;
			        
			    case 'BillPassing':
			    	funSetBillPassing(code);
			        break;
			        
			    /* case 'grnForBillBassing':
			    	funSetGRN(code);
			        break; */
			        
			    case 'taxmaster':
			    	funSetTax(code);
			    	break;
			}
		}
		
		
		function funSetBillPassing(code)
		{
			var searchUrl="";			
			searchUrl=getContextPath()+"/loadBillPassHd.html?billPassNo="+code;
			
			$.ajax({
			        type: "GET",
			        url: searchUrl,
				    dataType: "json",
				    success: function(response)
				    {
				    	if(response.strBillPassNo!="Invalid Code")
				    	{
					    	$("#txtBillPassingNo").val(code);
					    	$("#txtBillNo").val(response.strBillNo);
			        		$("#txtBillAmt").val(response.dblBillAmt);
			        		funSetSupplier(response.strSuppCode);
			        		$("#txtBillDate").val(response.dtBillDate);
			        		$("#txtPassDate").val(response.dtPassDate);
			        		$("#txtSupplierVoucherNo").val(response.strPVno);
			        		$("#txtNarration").val(response.strNarration);
			        		$("#cmbSettlementType").val(response.strSettlementType);
			        		
			        		funSetBillPassDtl(code);
				    	}
				    	else
				    	{
				    		 alert("Invalid Code");
				    		 $("#txtBillPassingNo").val('');
				    		 $("#txtBillPassingNo").focus();
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
		
		function funSetBillPassDtl(code)
		{
			var searchUrl="";
			searchUrl=getContextPath()+"/loadBillPassDtl.html?billPassNo="+code;
			
			$.ajax({
			        type: "GET",
			        url: searchUrl,
				    dataType: "json",
				    success: function(response)
				    {
				    	funRemoveGRNRows();
				    	$.each(response, function(i,item)
						{
				    		funAddGRNRowForUpdate(response[i].strGRNCode,response[i].dtGRNDate,response[i].strChallanNo,response[i].dblGRNAmt,response[i].dblAdjustAmt);				    		
						});
				    	funSetBillPassTaxDtl(code);
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
		
		
		function funAddGRNRowForUpdate(strGRNCode,dtGRNDate,strChallanNo,dblGRNAmt,dblAdjustAmt)
		{
		    var value=parseFloat(dblGRNAmt)-parseFloat(dblAdjustAmt);
		    
		    var table = document.getElementById("tblGRN");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		  
		    row.insertCell(0).innerHTML= "<input class=\"Box\" size=\"19%\" name=\"listBillPassDtl["+(rowCount)+"].strGRNCode\" id=\"txtGRNCode."+(rowCount)+"\" value="+strGRNCode+" >";
		    row.insertCell(1).innerHTML= "<input class=\"Box\" size=\"18%\" name=\"listBillPassDtl["+(rowCount)+"].dtGRNDate\" id=\"txtGRNDate."+(rowCount)+"\" value="+dtGRNDate+">";		    	    
		    row.insertCell(2).innerHTML= "<input size=\"18%\" name=\"listBillPassDtl["+(rowCount)+"].strChallanNo\" id=\"txtChallanNo."+(rowCount)+"\" value="+strChallanNo+">";
		    row.insertCell(3).innerHTML= "<input class=\"Box\" step=\"any\" required=\"required\" style=\"text-align: right;width:95%\" size=\"16%\" name=\"listBillPassDtl["+(rowCount)+"].dblAdjustAmt\" id=\"txtAdjustAmt."+(rowCount)+"\" value="+dblAdjustAmt+">";
		    row.insertCell(4).innerHTML= "<input class=\"Box\" size=\"12%\" style=\"text-align:right;\" name=\"listBillPassDtl["+(rowCount)+"].dblGRNAmt\" id=\"txtGRNAmt."+(rowCount)+"\" value="+value+">";
		    row.insertCell(5).innerHTML= '<input type="button" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteGRNRow(this)">';
		    
		    funCalGRNTotal();
		    
		    return false;
		}
		
		
		function funSetBillPassTaxDtl(code)
		{
			var searchUrl="";
			searchUrl=getContextPath()+"/loadBillPassTaxDtl.html?billPassNo="+code;
			
			$.ajax({
			        type: "GET",
			        url: searchUrl,
				    dataType: "json",
				    success: function(response)
				    {
				    	funRemoveTaxRows();
				    	$.each(response, function(i,item)
						{
				    		funAddTaxRowForUpdate(response[i].strTaxCode,response[i].strTaxDesc,response[i].strTaxableAmt,response[i].strTaxAmt);				    		
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
		
		
		function funAddTaxRowForUpdate(taxCode,taxDesc,taxableAmt,taxAmt) 
		{
		    var table = document.getElementById("tblTax");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		   
		    row.insertCell(0).innerHTML= "<input class=\"Box\" size=\"22%\" name=\"listBillPassTaxDtl["+(rowCount)+"].strTaxCode\" id=\"txtTaxCode."+(rowCount)+"\" value="+taxCode+" >";
		    row.insertCell(1).innerHTML= "<input class=\"Box\" size=\"22%\" name=\"listBillPassTaxDtl["+(rowCount)+"].strTaxDesc\" id=\"txtTaxDesc."+(rowCount)+"\" value="+taxDesc+">";
		    row.insertCell(2).innerHTML= "<input type=\"number\" step=\"any\" required = \"required\" style=\"text-align: right;\" size=\"15.5%\" name=\"listBillPassTaxDtl["+(rowCount)+"].strTaxableAmt\" id=\"txtTaxableAmt."+(rowCount)+"\" value="+taxableAmt+">";
		    row.insertCell(3).innerHTML= "<input type=\"number\" step=\"any\" required = \"required\" style=\"text-align: right;\" size=\"15.5%\" name=\"listBillPassTaxDtl["+(rowCount)+"].strTaxAmt\" id=\"txtTaxAmt."+(rowCount)+"\" value="+taxAmt+">";
		    row.insertCell(4).innerHTML= '<input type="button" size=\"6%\" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteTaxRow(this)">';
		    
		    funCalTaxTotal();
		    funClearFieldsOnTaxTab();
		    
		    return false;
		}
		
		function funSetSupplier(code)
		{
			var searchUrl="";			
			searchUrl=getContextPath()+"/loadSupplierMasterData.html?partyCode="+code;			
			$.ajax({
			        type: "GET",
			        url: searchUrl,
				    dataType: "json",
				    success: function(response)
				    {
				    	if(response.strPCode!="Invalid Code")
					    	{
						    	$("#txtSupplierCode").val(response.strPCode);
				        		$("#lblSupplierName").text(response.strPName);
				        		$("#txtSupplierVoucherNo").focus();
					    	}
				    	else
				    		{
				    			alert("Invalid Code");
				    			$("#txtSupplierCode").val('');
				    			$("#txtSupplierCode").focus();
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
		
		
		function funSetGRN(code)
		{
			var searchUrl="";
			$("#txtGRNNo").val(code);
			searchUrl=getContextPath()+"/loadGRNData.html?grnNo="+code;
			$.ajax({
			        type: "GET",
			        url: searchUrl,
				    dataType: "json",
				    async:false,
				    success: function(response)
				    {
				    	if(response.strGRNCode!="Invalid Code")
				    	{
					    	$("#txtGRNNo").val(response.strGRNCode);
					    	$("#lblGRNDate").text(response.dtGRNDate);
					    	$("#lblChallanNo").text(response.strBillNo);
					    	$("#lblGRNAmt").text(response.dblTotal);
					    	$("#txtAdjustAmt").focus();
				    	}
				    	else
				    	{
				    		alert("Invalid Code");
				    		$("#txtGRNNo").val('');
				    		$("#txtGRNNo").focus();
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
	
		
		function funSetTax(code)
		{
			
			$.ajax({
			   		type: "GET",
			        url: getContextPath()+"/loadTaxMasterData.html?taxCode="+code,
			        dataType: "json",
			        success: function(response)
			        {
			        	$("#txtTaxCode").val(code);
			        	$("#lblTaxDesc").text(response.strTaxDesc);
			        	//$("#txtTaxPer").val(response.dblPercent);
			        	$("#txtTaxableAmt").focus();
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
		
	
		function funClearFieldsOnGRNTab() 
		{
			$("#txtGRNNo").val("");
			$("#lblGRNDate").text("");
			$("#lblChallanNo").text("");
			$("#lblGRNAmt").text("");
			$("#txtAdjustAmt").val("0");
			$("#txtGRNNo").focus();
		}
		
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
		    
		    row.insertCell(0).innerHTML= "<input class=\"Box\" size=\"22%\" name=\"listBillPassTaxDtl["+(rowCount)+"].strTaxCode\" id=\"txtTaxCode."+(rowCount)+"\" value='"+taxCode+"' >";
		    row.insertCell(1).innerHTML= "<input class=\"Box\" size=\"22%\" name=\"listBillPassTaxDtl["+(rowCount)+"].strTaxDesc\" id=\"txtTaxDesc."+(rowCount)+"\" value='"+taxDesc+"'>";		    	    
		    row.insertCell(2).innerHTML= "<input type=\"number\" step=\"any\" required = \"required\" style=\"text-align: right;\" size=\"15.5%\" name=\"listBillPassTaxDtl["+(rowCount)+"].strTaxableAmt\" id=\"txtTaxableAmt."+(rowCount)+"\" value="+taxableAmt+">";
		    row.insertCell(3).innerHTML= "<input type=\"number\" step=\"any\" required = \"required\" style=\"text-align: right;\" size=\"15.5%\" name=\"listBillPassTaxDtl["+(rowCount)+"].strTaxAmt\" id=\"txtTaxAmt."+(rowCount)+"\" value="+taxAmt+">";		    
		    row.insertCell(4).innerHTML= '<input type="button" size=\"6%\" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteTaxRow(this)" >';
		    
		    funCalTaxTotal();
		    funClearFieldsOnTaxTab();
		    
		    return false;
		}
		
		
		function funCalTaxTotal()
		{
			var totalTaxAmt=0,totalTaxableAmt=0;
			var table = document.getElementById("tblTax");
			var rowCount = table.rows.length;
			for(var i=0;i<rowCount;i++)
			{
				totalTaxableAmt=parseFloat(document.getElementById("txtTaxableAmt."+i).value)+totalTaxableAmt;
				totalTaxAmt=parseFloat(document.getElementById("txtTaxAmt."+i).value)+totalTaxAmt;
			}
			$("#lblTaxableAmt").text(totalTaxableAmt);
			$("#lblTaxTotal").text(totalTaxAmt);
			$("#lblGRNTaxTotal").text(totalTaxAmt);
			
			var subTotal=parseFloat($("#lblGRNSubTotal").text());
			var totalTax=parseFloat($("#lblGRNTaxTotal").text());
			var grandTotal=subTotal+totalTax;
			$("#lblGRNGrandTotal").text(grandTotal);
			$("#lblGRNGrandTotal1").text(grandTotal);
		}
		
		
		function funAddGRNRow()
		{
			var strGRNCode = $("#txtGRNNo").val();
			var dtGRNDate=$("#lblGRNDate").text();
		    var strChallanNo = $("#lblChallanNo").text();
		    var dblGRNAmt=$("#lblGRNAmt").text();		   
		    var dblAdjustAmt=$("#txtAdjustAmt").val();		   
		    var value=parseFloat(dblGRNAmt)-parseFloat(dblAdjustAmt);
		    
		    var table = document.getElementById("tblGRN");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    
		    row.insertCell(0).innerHTML= "<input class=\"Box\" size=\"19%\" name=\"listBillPassDtl["+(rowCount)+"].strGRNCode\" id=\"txtGRNCode."+(rowCount)+"\" value="+strGRNCode+" >";
		    row.insertCell(1).innerHTML= "<input class=\"Box\" size=\"18%\" name=\"listBillPassDtl["+(rowCount)+"].dtGRNDate\" id=\"txtGRNDate."+(rowCount)+"\" value="+dtGRNDate+">";		    	    
		    row.insertCell(2).innerHTML= "<input size=\"18%\" name=\"listBillPassDtl["+(rowCount)+"].strChallanNo\" id=\"txtChallanNo."+(rowCount)+"\" value="+strChallanNo+">";
		    row.insertCell(3).innerHTML= "<input class=\"Box\" step=\"any\" required=\"required\" style=\"text-align: right;width:95%\" size=\"16%\"  name=\"listBillPassDtl["+(rowCount)+"].dblAdjustAmt\" id=\"txtAdjustAmt."+(rowCount)+"\" value="+dblAdjustAmt+">";
		    row.insertCell(4).innerHTML= "<input class=\"Box\" size=\"12%\" style=\"text-align: right;\" name=\"listBillPassDtl["+(rowCount)+"].dblGRNAmt\" id=\"txtGRNAmt."+(rowCount)+"\" value="+value+">";
		    row.insertCell(5).innerHTML= '<input type="button" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteGRNRow(this)">';
		    
		    funCalGRNTotal();
		    funClearFieldsOnGRNTab();
		    funApplyNumberValidation();
		    
		    return false;
		}
		
		function funCalGRNTotal()
		{
			var totalGRNAmt=0;
			var table = document.getElementById("tblGRN");
			var rowCount = table.rows.length;
			for(var i=0;i<rowCount;i++)
			{
				totalGRNAmt=parseFloat(document.getElementById("txtGRNAmt."+i).value)+totalGRNAmt;
			}
			
			$("#lblGRNSubTotal").text(totalGRNAmt);
// 			var totalTax=parseFloat($("#lblGRNTaxTotal").text());
// 			var grandTotal=totalGRNAmt+totalTax;
			var grandTotal=totalGRNAmt
			$("#lblGRNGrandTotal").text(grandTotal);
			$("#lblGRNGrandTotal1").text(grandTotal);
		}
		
		
		
		function funDeleteGRNRow(obj) 
		{
		    var index = obj.parentNode.parentNode.rowIndex;
		    var table = document.getElementById("tblGRN");
			table.deleteRow(index);
		}
		
		function funDeleteTaxRow(obj) 
		{
		    var index = obj.parentNode.parentNode.rowIndex;
		    var table = document.getElementById("tblTax");
			table.deleteRow(index);
		}
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
		function funRemoveGRNRows()
		{
			var table = document.getElementById("tblGRN");
			var rowCount = table.rows.length;
			while(rowCount>0)
			{
				table.deleteRow(0);
				rowCount--;
			}
		}
		
		$(function()
		{
			$('#txtSupplierCode').blur(function () {
				var code=$("#txtSupplierCode").val();;
				if (code.trim().length > 0 && code !="?" && code !="/"){					   
					funSetSupplier(code);
					
				   }
			});
			
			$('#txtBillPassingNo').blur(function () {
				var code=$("#txtBillPassingNo").val();
				if (code.trim().length > 0 && code !="?" && code !="/"){					   
					funSetBillPassing(code);
				   }
			});
			
			/* $('#txtGRNNo').blur(function () {
				var code=$("#txtGRNNo").val();
				if (code.trim().length > 0 && code !="?" && code !="/"){					   
					funSetGRN(code);
				   }
			}); */
			
			$('#txtTaxCode').blur(function () {
				var code=$('#txtTaxCode').val();
				if (code.trim().length > 0 && code !="?" && code !="/"){					   
					funSetTax(code);
				   }
			});
		});
			    	
			    	
		function funApplyNumberValidation(){
			$(".numeric").numeric();
			$(".integer").numeric(false, function() { alert("Integers only"); this.value = ""; this.focus(); });
			$(".positive").numeric({ negative: false }, function() { alert("No negative values"); this.value = ""; this.focus(); });
			$(".positive-integer").numeric({ decimal: false, negative: false }, function() { alert("Positive integers only"); this.value = ""; this.focus(); });
		    $(".decimal-places").numeric({ decimalPlaces: maxQuantityDecimalPlaceLimit, negative: false });
		    $(".decimal-places-amt").numeric({ decimalPlaces: maxAmountDecimalPlaceLimit, negative: false });
		}
		
		$(document).ready(function(){
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
			<%if(null!=session.getAttribute("rptBillPassingCode")){%>
			code='<%=session.getAttribute("rptBillPassingCode").toString()%>';
			<%session.removeAttribute("rptBillPassingCode");%>
			var isOk=confirm("Do You Want to Generate Slip?");
			if(isOk){
			window.open(getContextPath()+"/invokeBillPassingReport.html?docCode="+code,'_blank');
			}
			<%}%>
			
			var flagOpenFromAuthorization="${flagOpenFromAuthorization}";
			if(flagOpenFromAuthorization == 'true')
			{
				funSetBillPassing("${authorizationBillPassingCode}");
			}
	    });
		function funResetFields()
		{
			location.reload(true); 
		} 
		
		
		
		function funDuplicateGRN(strGRNCode)
		{
		 var table = document.getElementById("tblGRN");
		    var rowCount = table.rows.length;	
		  //  for()
		    var flag=true;
		    if(rowCount > 0)
		    	{
				    $('#tblGRN tr').each(function()
				    {
					    if(strGRNCode==$(this).find('input').val())// `this` is TR DOM element
	    				{
					    	alert("Already Added : "+strGRNCode );
					    	flag=false;
		    			
	    				}
					});
				    
		    	}
		    return flag;
		}
		
		function funOpenGRN(transactionName)
		{
			fieldName = transactionName;
			var strSuppCode=$("#txtSupplierCode").val();
			//var strGRNCode = $("#txtGRNNo").val();
			if(fieldName=='GRNCode' && strSuppCode!='')
			{
				
			//	var retval=window.showModalDialog("frmPIforPO.html","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
				var retval=window.open("frmGRNList.html?strSuppCode="+strSuppCode+"","","dialogHeight:950px;dialogWidth:600px;dialogLeft:400px;")
			
				var timer = setInterval(function ()
			    {
					if(retval.closed)
					{
						if (retval.returnValue != null)
						{
							strVal=retval.returnValue.split("#")
							$("#txtGRNNo").val(strVal[0]);
								
							var GRNCodes=strVal[0].split(",");
						    var html = '';
							/* for(var cnt=0;cnt<GRNCodes.length;cnt++)
							{
						 		html += '<option value="' + GRNCodes[cnt] + '" >' + GRNCodes[cnt]+ '</option>';
							}
							$('#cmbPIDoc').html(html); */
						}
						clearInterval(timer);
					}
			    }, 500);
			}
		}
		
		
		
	</script>
</head>
<body>
	<div class="container">
		<label id="formHeading">Bill Passing</label>
	<s:form name="billPassingForm" method="POST" action="saveBillPassing.html?saddr=${urlHits}">
	
		<div style="border: 0px solid black; width: 100%; height: 100%; margin-left: auto; margin-right: auto; background-color: #C0E4FF;">
			<div id="tab_container" style="height: 530px">
				<ul class="tabs">
					<li class="active" data-state="tab1">General</li>
<!-- 					<li data-state="tab2" style="width: 54px; padding-left: 37px">Tax</li> -->
				</ul>
				<div id="tab1" class="tab_content" style="margin-top: 39px;">
					<div class="row masterTable">
						<div class="col-md-2">	
							<label>Bill Passing No</label>
							<s:input id="txtBillPassingNo" path="strBillPassNo"
									ondblclick="funHelp('BillPassing')" cssClass="searchTextBox" />
								<!-- <td><label>Bill No</label></td> -->
						</div>
						<div class="col-md-2">	
							<s:label id="txtBillNo" path="strBillNo" style="background-color:#dcdada94; width: 100%; height: 52%; margin-top: 26px; text-align:center;"
							/>
						</div>
						<div class="col-md-2">	
							<label>Date</label>
							<s:input id="txtBillDate" required="required" pattern="\d{1,2}-\d{1,2}-\d{4}"
									path="dtBillDate" cssClass="calenderTextBox" style="width:80%;"/>
						</div>
						<div class="col-md-2">	
							<label>Supplier</label>
							<s:input id="txtSupplierCode" path="strSuppCode" required="required" 
									ondblclick="funHelp('suppcodeActive')" cssClass="searchTextBox" />
						</div>
						<div class="col-md-2">	
							<label id="lblSupplierName" style="background-color:#dcdada94; width: 185%; height: 52%; margin-top: 26px; text-align:center;"></label>
						</div>
						<div class="col-md-2"></div>	
						<div class="col-md-2">	
							<label>Supplier Vouch No</label>
							<s:input id="txtSupplierVoucherNo" path="strPVno"/>
						</div>
						<div class="col-md-2">	
							<label>Bill Amount</label>
							<s:input id="txtBillAmt" path="dblBillAmt"/>
						</div>
						<div class="col-md-2">	
							<label>Passing Date</label>
							<s:input id="txtPassDate" required="required" pattern="\d{1,2}-\d{1,2}-\d{4}"
									path="dtPassDate" cssClass="calenderTextBox" style="width:80%;"/>
						</div>
						<div class="col-md-2">			
							<label>Narration</label>
							<s:input id="txtNarration" path="strNarration" />
						</div>
						<div class="col-md-2">	
							<label>Currency</label>
							<s:select id="cmbCurrancy" path="strCurrency" style="width:80%;">
								<s:option value="Rs">Rs</s:option>
								<s:option value="$">$</s:option>
							</s:select>
						</div>
						<div class="col-md-2">	</div>
						<div class="col-md-2">			
							<label>GRN Code</label>
							<input id="txtGRNNo" ondblclick="funOpenGRN('GRNCode')" class="searchTextBox">
						</div>
						<div class="col-md-2">
									<!-- ondblclick="funHelp('grnForBillBassing');" -->
							<label>Date</label>
							<label id="lblGRNDate" style="background-color:#dcdada94; width: 100%; height: 52%;text-align:center;"></label>
						</div>
						<div class="col-md-2">
							<label>Challan No</label>
							<label id="lblChallanNo" style="background-color:#dcdada94; width: 100%; height: 52%;text-align:center;"></label>
						</div>	
						<div class="col-md-2">
							<label>Value</label>
							<label id="lblGRNAmt" style="background-color:#dcdada94; width: 100%; height: 52%;text-align:center;"></label>
						</div>
						<div class="col-md-2">
								<label>Adjustment</label>
								<input type="number" id="txtAdjustAmt" value="0" style="text-align: right;">
						</div>
						<div class="col-md-2"></div>
						<div class="col-md-2">
							<label>Settlement Type</label>
							<s:select id="cmbSettlementType" path="strSettlementType" items="${settlementTypeList}" style="width:80%;"></s:select>
						</div>
						<div class="col-md-2">
							<input id="btnAddGRN" type="button" value="Add" class="btn btn-primary center-block" style="margin-top:20px;" />
						</div>
					</div>
					<br>	
					<table style="height:20px;border:#0F0;font-size:11px;font-weight: bold;width:70%">
							<tr bgcolor="#c0c0c0">
								<td style="width: 20%; height: 16px;" align="left">Code</td>
								<td style="width: 18%; height: 16px;" align="left">Date</td>
								<td style="width: 18%; height: 16px;" align="left">Challan No</td>
								<td style="width: 16%; height: 16px;" align="left">Adjustment</td>
								<td style="width: 16%; height: 16px;" align="left">Value</td>
								<td style="width: 16%; height: 16px;" align="center">Delete</td>
							</tr>
					</table>
					<div style="background-color: #fbfafa;border: 1px solid #ccc;display: block; height: 150px;
    					overflow-x: hidden; overflow-y: scroll;width: 70%;">
						<table id="tblGRN" class="transTablex col6-center" style="width: 100%;">
							<tbody>    
								<col style="width:17%"><!--  COl1   -->
								<col style="width:17%"><!--  COl2   -->
								<col style="width:17%"><!--  COl3   -->
								<col style="width:17%"><!--  COl4   -->
								<col style="width:17%"><!--  COl5   -->
								<col style="width:17%"><!--  COl6   -->
							</tbody>							
						</table>
					</div>			
						<div class="row transtable" id="tblGRNTotal">
								<div class="col-md-2">
									<label>Sub Total</label>
									<input id="lblGRNSubTotal" type="text"></input>
<!-- 								<td width="100px"><label>Tax</label></td> -->
<!-- 								<td><label id="lblGRNTaxTotal">0</label></td> -->
								</div>
								<div class="col-md-2">
									<label>Grand Total</label>
									<input id="lblGRNGrandTotal" type="text"></input>
								</div>
							</div>
						</div>

<!-- 				<div id="tab2" class="tab_content"> -->
<!-- 					<br> -->
<!-- 					<br> -->
<!-- 					<table class="masterTable"> -->
<!-- 					<tr><th colspan="5"></th></tr> -->
<!-- 					<tr> -->
						
<!-- 						<td><label>Tax Code</label></td> -->
<!-- 						<td> -->
<!-- 							<input type="text" id="txtTaxCode" ondblclick="funHelp('taxmaster');" class="searchTextBox"/> -->
<!-- 						</td> -->
						
<!-- 						<td><label>Tax Description</label></td> -->
<!-- 						<td colspan="2"> -->
<!-- 							<label id="lblTaxDesc"></label> -->
<!-- 						</td> -->
<!-- 						</tr><tr> -->
<!-- 						<td><label>Taxable Amount</label></td> -->
<!-- 						<td> -->
<!-- 							<input type="number" style="text-align: right;" step="any" id="txtTaxableAmt" class="BoxW116px"/> -->
<!-- 						</td> -->
						
<!-- 						<td><label>Tax Amount</label></td> -->
<!-- 						<td> -->
<!-- 							<input type="number" style="text-align: right;" step="any" id="txtTaxAmt" class="BoxW116px"/> -->
<!-- 						</td> -->
												
<!-- 						<td> -->
<!-- 							<input type="button" id="btnAddTax" value="Add" class="smallButton"/> -->
<!-- 						</td> -->
<!-- 					</tr> -->
<!-- 				</table> -->
<!-- 				<br> -->
<!-- 				<table style="width: 80%;" class="transTablex col5-center"> -->
<!-- 				<tr> -->
<!-- 					<td style="width:10%">Tax Code</td> -->
<!-- 					<td style="width:10%">Description</td> -->
<!-- 					<td style="width:10%">Taxable Amount</td> -->
<!-- 					<td style="width:10%">Tax Amount</td> -->
<!-- 					<td style="width:5%">Delete</td> -->
<!-- 				</tr> -->
				
<!-- 				</table> -->
<!-- 				<div style="background-color: #a4d7ff;border: 1px solid #ccc;display: block; height: 150px; -->
<!--     				margin: auto;overflow-x: hidden; overflow-y: scroll;width: 80%;"> -->
<!-- 							<table id="tblTax" class="transTablex col5-center" style="width: 100%;"> -->
<!-- 							<tbody>     -->
<%-- 									<col style="width:10%"><!--  COl1   --> --%>
<%-- 									<col style="width:10%"><!--  COl2   --> --%>
<%-- 									<col style="width:10%"><!--  COl3   --> --%>
<%-- 									<col style="width:10%"><!--  COl4   --> --%>
<%-- 									<col style="width:6%"><!--  COl5   -->									 --%>
<!-- 							</tbody>							 -->
<!-- 							</table> -->
<!-- 					</div>			 -->
<!-- 				<br> -->
<!-- 				<table id="tblTaxTotal" class="masterTable"> -->
<!-- 					<tr> -->
<!-- 						<td width="130px"><label>Taxable Amt Total</label></td> -->
<!-- 						<td><label id="lblTaxableAmt"></label></td> -->
						
<!-- 						<td  width="130px"><label>Tax</label></td> -->
<!-- 						<td><label id="lblTaxTotal"></label></td> -->
<!-- 					</tr> -->
					
<!-- 					<tr> -->
<!-- 						<td><label>Grand Total</label></td> -->
<!-- 						<td colspan="3"><label id="lblGRNGrandTotal1"></label></td> -->
<!-- 					</tr> -->
<!-- 				</table> -->
<!-- 						</div> -->
				</div>
			</div>
			<div class="center" style="text-align:center">
				<a href="#"><button class="btn btn-primary center-block" id="btnSubmit" value="Submit">Submit</button></a> &nbsp;
				<a href="#"><button class="btn btn-primary center-block"  value="Reset" onclick="funResetFields();">Reset</button></a>
			</div>
	</s:form>
</div>
	<script type="text/javascript">funApplyNumberValidation();</script>
</body>
</html>