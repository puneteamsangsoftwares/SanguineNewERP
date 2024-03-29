<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<meta http-equiv="X-UA-Compatible" content="IE=8">
	<script type="text/javascript" src="<spring:url value="/resources/js/jQuery.js"/>"></script>
	<script type="text/javascript" src="<spring:url value="/resources/js/jquery-ui.min.js"/>"></script>	
	<script type="text/javascript" src="<spring:url value="/resources/js/validations.js"/>"></script>
	<script type="text/javascript" src="<spring:url value="/resources/js/pagination.js"/>"></script>
        <!-- Load data to paginate -->
		<link rel="stylesheet" href="<spring:url value="/resources/css/pagination.css"/>" />
		
<title>CUSTOMER MASTER</title>
<%-- <tab:tabConfig/> --%>

<script type="text/javascript">
var listProductData;
var isLikeCustClk=false;
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
		
		$(document).ready(function(){
			$("#txtdtInstallions").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtdtInstallions" ).datepicker('setDate', 'today');
			$(document).ajaxStart(function(){
			    $("#wait").css("display","block");
			});
			$(document).ajaxComplete(function(){
				$("#wait").css("display","none");
			});
		});
		
		 $("#txtInstallationDate").datepicker(
		 {
			dateFormat : 'dd-mm-yy'
		 });
		$("#txtInstallationDate").datepicker('setDate', 'today');
		
		
		var clientCode='<%=session.getAttribute("clientCode").toString()%>';
		if(clientCode!='141.001') //sanguine 
		{
			  $("#lblLicenceAmt").text('Amount');
			  $("#lblAMCAmt").css('visibility','hidden'); 
			  //$("#txtAmount").css('visibility','hidden'); 
			  
			  $("#txtAMCAmount").css('visibility','hidden');
			  
			  $("#txtWarrInDays").css('visibility','hidden');
			  $("#lblWarrInDays").css('visibility','hidden');
			  $("#txtInstallationDate").css('visibility','hidden');
			  $("#lblInstallationDate").css('visibility','hidden');
			  // 
			  // $("#divProductDetails").css('visibility','hidden');
			   $('#divProductDetails').hide();
			  
		}
		
	});
	
	
	
	//Textfiled On blur geting data
	$(function() {
		
		$('#txtPartyCode').blur(function() {
			var code = $('#txtPartyCode').val();
			if(code.trim().length > 0 && code !="?" && code !="/")
			{
				funSetCustomer(code);
			}
		});
		
		
		$('#txtProdCode').blur(function() {
			var code = $('#txtProdCode').val();
			if(code.trim().length > 0 && code !="?" && code !="/")
			{
				funSetProduct(code);
			}
		});
		
		
		$('#txtTaxCode').blur(function() {
			var code = $('#txtTaxCode').val();
			if(code.trim().length > 0 && code !="?" && code !="/")
			{
				 funSetTax(code);
			}
		});
		
		
		$('#txtLocCode').blur(function() {
			var code = $('#txtLocCode').val();
			if(code.trim().length > 0 && code !="?" && code !="/")
			{
				funSetLocation(code);
			}
		});
		
		
		$('#txtPropCode').blur(function() {
			var code = $('#txtPropCode').val();
			if(code.trim().length > 0 && code !="?" && code !="/")
			{
				funSetPropertyData(code);
			}
		});
   
		
	});
	
</script>


	<script type="text/javascript">

		var fieldName;
		var posItemCode;
		var listRow=0;
		
		function funValidateFields()
		{
			var flg=true;
			if($("#txtPartyName").val().trim()=="")
			{
				alert("Please Enter Customer Name");
				$("#txtPartyName").focus();
				return false;
			}
			
			/* if(flg==true)
				{
				   $.ajax({
						type : "POST",
						url : getContextPath()+ "/saveCustomerMaster.html?",
						dataType : "json",
						async:false,
						success : function(response){ 
							},
						error : function(e){
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
				
				} */
			return flg;
			
	    }
		
		function funSetAdd()
		{
			if(document.getElementById("chkShipAdd").checked==true)
			{
				$("#txtShipAdd1").val(document.getElementById("billAdd1").value);
				$("#txtShipAdd2").val(document.getElementById("billAdd2").value);
				$("#txtShipCity").val(document.getElementById("billCity").value);
				$("#txtShipState").val(document.getElementById("billState").value);
				$("#txtShipPin").val(document.getElementById("billPin").value);
				$("#txtShipCountry").val(document.getElementById("billCountry").value);
			}
			else
			{
				$("#txtShipAdd1").val("");
				$("#txtShipAdd2").val("");
				$("#txtShipCity").val("");
				$("#txtShipState").val("");
				$("#txtShipPin").val("");
				$("#txtShipCountry").val("");
			}
		}	
		
		
		$(document).ready(function() {

			$("#txtAttName").focus();
			$("#lblParentAttName").text("");
<%-- 			var propcode='<%=session.getAttribute("propertyCode").toString()%>'; --%>
// 			funSetPropertyData(propcode);
			
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
			
// 			$("#txtPartyCode").focus();
	    });
		
		function funResetFields()
		{
			location.reload(true); 				
	    }
		
		function funHelp(transactionName)
		{
			fieldName=transactionName;
	        
	      //  window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	      window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;top=500,left=500")
	    }
	
		function funSetCustomer(code)
		{
			gurl=getContextPath()+"/loadPartyMasterData.html?partyCode=";
			$.ajax({
		        type: "GET",
		        url: gurl+code,
		        dataType: "json",
		        async:false,
		    
		        success: function(response)
		        {		        	
		        		if('Invalid Code' == response.strPCode){
		        			alert("Invalid Customer Code");
		        			$("#txtPartyCode").val('');
		        			$("#txtPartyCode").focus();
		        			
		        		}else{
		        			$("#txtPartyCode").val(response.strPCode);
							$("#txtPartyName").val(response.strPName);
							$("#txtManualCode").val(response.strManualCode);
							$("#txtPhone").val(response.strPhone);
							$("#txtMobile").val(response.strMobile);
							$("#txtFax").val(response.strFax);
							$("#txtContact").val(response.strContact);
							$("#txtEmail").val(response.strEmail);
							$("#txtBankName").val(response.strBankName);
							$("#txtBankAdd1").val(response.strBankAdd1);
							$("#txtBankAdd2").val(response.strBankAdd2);
							$("#txtBankAccountNo").val(response.strBankAccountNo);
							$("#txtBankABANo").val(response.strBankABANo);
							$("#txtIbanNo").val(response.strIBANNo);
							$("#txtSwiftCode").val(response.strSwiftCode);
							$("#txtTaxNo1").val(response.strTaxNo1);
							$("#txtTaxNo2").val(response.strTaxNo2);
							$("#txtVat").val(response.strVAT);
							$("#txtCst").val(response.strCST);
							$("#txtExcise").val(response.strExcise);
							$("#txtServiceTax").val(response.strServiceTax);
							$("#cmbPartyType").val(response.strPartyType);
							$("#txtAcCrCode").val(response.strAcCrCode);
							$("#txtCreditDays").val(response.intCreditDays);
							$("#txtCreditLimit").val(response.dblCreditLimit);
							$("#txtRegistration").val(response.strRegistration);
							$("#txtRange").val(response.strRange);
							$("#txtDivision").val(response.strDivision);
							$("#txtCommissionerate").val(response.strCommissionerate);
							$("#cmbCategory").val(response.strCategory);
							$("#cmbExcisable").val(response.strExcisable);
							$("#txtMainAdd1").val(response.strMAdd1);
							$("#txtMainAdd2").val(response.strMAdd2);
							$("#txtMainCity").val(response.strMCity);
							$("#txtMainState").val(response.strMState);
							$("#txtMainPin").val(response.strMPin);
							$("#txtMainCountry").val(response.strMCountry);
							$("#txtBillAdd1").val(response.strBAdd1);
							$("#txtBillAdd2").val(response.strBAdd2);
							$("#txtBillCity").val(response.strBCity);
							$("#txtBillState").val(response.strBState);
							$("#txtBillPin").val(response.strBPin);
							$("#txtBillCountry").val(response.strBCountry);
							$("#txtShipAdd1").val(response.strSAdd1);
							$("#txtShipAdd2").val(response.strSAdd2);
							$("#txtShipCity").val(response.strSCity);
							$("#txtShipState").val(response.strSState);
							$("#txtShipPin").val(response.strSPin);
							$("#txtShipCountry").val(response.strSCountry);
							$('#cmbPartyIndi').val(response.strPartyIndi);
							$('#txtDiscount').val(response.dblDiscount);
							$('#txtECCNo').val(response.strECCNo);
							$("#cmbCurrency").val(response.strCurrency);
							$('#txtAccManager').val(response.strAccManager);
							$('#txtdtInstallions').val(response.dtInstallions);
							$("#txtGSTNo").val(response.strGSTNo);
							$("#txtPNameMarathi").val(response.strPNHindi);
							toggle("txtPNameMarathi");
							$("#txtLocCode").val(response.strLocCode);
							$("#lblLocName").text(response.strLocName);
							$("#txtPropCode").val(response.strPropCode);
							$("#hidDebtorCode").val(response.strDebtorCode);
							$("#hidDebtorCode").val(response.strDebtorCode);
							$('#txtReturnDiscount').val(response.dblReturnDiscount);
							$("#cmbRegion").val(response.strRegion);
							if(response.strOperational=='Y')
							{
								$("#cmbOperational").val('Y');
							}
							else
							{
								$("#cmbOperational").val('N');
							}
							
							if(response.strApplForWT=='Y')
				        	{
				        		$("#chkApplForWT").attr('checked', true);
				        	}
				        	else
				        	{
				        		$("#chkApplForWT").attr('checked', false);
				        	}
							
							funSetCustomerTaxDtl(code);
							//funPartyProdData(code);
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
		
		
		function funSetCustomerTaxDtl(code)
		{
			funRemoveTaxRows();
			gurl=getContextPath()+"/loadCustomerTaxDtl.html?partyCode=";
			$.ajax({
		        type: "GET",
		        url: gurl+code,
		        dataType: "json",
		        async:false,
		      
		        success: function(response)
		        {
		        	$.each(response, function(i, item) 
		        	{
		        		funAddRowTaxForUpdate(item[0],item[1]);
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
		
		
		function funSetProduct(code)
		{
			gurl=getContextPath()+"/loadProductMasterData.html?prodCode=";
			$.ajax({
		        type: "GET",
		        url: gurl+code,
		        dataType: "json",
		      
		        success: function(response)
		        {
					$("#txtProdCode").val(response.strProdCode);
		        	$("#lblProdName").text(response.strProdName);
			        posItemCode=response.strPartNo;
			        $("#txtAmount").focus();
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
		
		function funSetData(code)
		{
			switch (fieldName) 
			{		   
			   case 'custMaster':
			   if(isLikeCustClk)
			   {
			   		funPartyProdDataForLikeUser(code);
			   }
		       else
			   {
			   		funSetCustomer(code);
			   }
			       break;
			   
			   case 'productInCRMCust':
			    	funSetProduct(code);
			        break;
			        
			   case 'taxmaster':
				   funSetTax(code);
			        break;
			        
			   case 'locationmaster':
				   funSetLocation(code);
				   break;  
			   case "property":
					funSetPropertyData(code);
					break;    
			}
		}
		function funSetTax(code)
		{
				$.ajax({
						type: "GET",
				        url: getContextPath()+"/loadTaxMasterData.html?taxCode="+code,
				        dataType: "json",
				        success: function(response)
				        {
				        	if('Invalid Code' == response.strTaxCode){
				        		alert("Invalid tax Code");
				        		$("#txtTaxCode").val('');
				        		$("#txtTaxCode").focus();
				        	}else{
				        		$("#txtTaxCode").val(response.strTaxCode);
					        	$("#txtTaxDesc").val(response.strTaxDesc);
					        	$("#btnTaxAdd").focus();
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
		
		function funAddRow() 
	    {	
			var strProdCode=$("#txtProdCode").val();
		   	 if(funDuplicateProduct(strProdCode))
			 {
		   		var clientCode='<%=session.getAttribute("clientCode").toString()%>';
		   		if(clientCode!='141.001')
	   			{
	   				funInsertProdRow1();			
	   			}else{
	   				funInsertProdRow();
	   			}
			 }
	    }
	
		function funInsertProdRow()
		{
			var prodCode='', amount='' ,itemName='', margin='', installationDate='', amcAmount='',warrInDays='',standingOrder='';
			
			if(!funCheckNull($("#txtProdCode").val(),"Product Code"))
			{
				$("#txtProdCode").focus();
				return false;
			}
			
			if(!funValidateNumeric($("#txtAmount").val()))
			{
				$("#txtAmount").focus();
				return false;
			}
			
			if(!funValidateNumeric($("#txtMargin").val()))
				{
					$("#txtMargin").focus();
					return false;
				}
			 
			prodCode = $("#txtProdCode").val();
		    amount = $("#txtAmount").val();
		    itemName = $("#lblProdName").text();
		    margin = $("#txtMargin").val();
		    standingOrder = $("#txtStandingOrder").val();
		    amcAmount = $("#txtAMCAmount").val();
		    installationDate = $("#txtInstallationDate").val();
		    warrInDays = $("#txtWarrInDays").val();
		    
		    var table = document.getElementById("tblProdDet1");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    rowCount=listRow;
// 		    rowCount=listRow;
		    row.insertCell(0).innerHTML= "<input name=\"listclsProdSuppMasterModel["+(rowCount)+"].strProdCode\" readonly=\"readonly\" class=\"Box\" size=\"15%\" id=\"txtProdCode."+(rowCount)+"\" value="+prodCode+">";		    
		    row.insertCell(1).innerHTML= "<input name=\"listclsProdSuppMasterModel["+(rowCount)+"].strProdName\" readonly=\"readonly\" class=\"Box\" size=\"30%\" id=\"txtProdName."+(rowCount)+"\" value='"+itemName+"'/>";
		    row.insertCell(2).innerHTML= "<input name=\"listclsProdSuppMasterModel["+(rowCount)+"].dblLastCost\" id=\"txtAmount."+(rowCount)+"\" required = \"required\" style=\"text-align: right;\" size=\"9%\" class=\"decimal-places-amt\" value="+amount+">";
		    row.insertCell(3).innerHTML = "<input name=\"listclsProdSuppMasterModel["+(rowCount)+"].dblAMCAmt\" id=\"dblAMCAmt."+(rowCount)+"\"  required = \"required\"  size=\"8%\" style=\" text-align: right; padding-right: 4px;\" class=\"decimal-places-amt\"    value='"+amcAmount+"' />";
			row.insertCell(4).innerHTML = "<input readonly=\"readonly\" size=\"10%\"  class=\"Box\"  name=\"listclsProdSuppMasterModel["+(rowCount)+"].dteInstallation\" id=\"dteInstallation."+(rowCount)+"\" style=\"text-align: left;  height:20px;\"  value='"+installationDate+"' />";
			row.insertCell(5).innerHTML = "<input readonly=\"readonly\" size=\"10%\" style=\"text-align: right; padding-right: 4px;\"  class=\"Box\"  name=\"listclsProdSuppMasterModel["+(rowCount)+"].intWarrantyDays\" id=\"intWarrantyDays."+(rowCount)+"\" style=\"text-align: left;  height:20px;\"  value='"+warrInDays+"' />";
		    row.insertCell(6).innerHTML= "<input name=\"listclsProdSuppMasterModel["+(rowCount)+"].dblStandingOrder\" id=\"txtStandingOrder."+(rowCount)+"\" required = \"required\" style=\"text-align: right;\" size=\"7%\" class=\"decimal-places-amt\" value="+standingOrder+">";
		    row.insertCell(7).innerHTML= "<input name=\"listclsProdSuppMasterModel["+(rowCount)+"].dblMargin\" id=\"txtMargin."+(rowCount)+"\" required = \"required\" style=\"text-align: right;\" size=\"7%\" class=\"decimal-places-amt\" value="+margin+">";
		    row.insertCell(8).innerHTML= '<input type="button" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRowForProd(this)">';
		   
		   
		    listRow++;
		    
		 //   funApplyNumberValidation();
		    
		    //rowCount++;
		   // return false;
		}
		 
		function funInsertProdRow1()
		{
			
			if(!funCheckNull($("#txtProdCode").val(),"Product Code"))
			{
				$("#txtProdCode").focus();
				return false;
			}
			
			if(!funValidateNumeric($("#txtAmount").val()))
			{
				$("#txtAmount").focus();
				return false;
			}
			
			if(!funValidateNumeric($("#txtMargin").val()))
				{
					$("#txtMargin").focus();
					return false;
				}
			 
			var prodCode = $("#txtProdCode").val();
		    var amount = $("#txtAmount").val();
		    var itemName = $("#lblProdName").text();
		    var margin = $("#txtMargin").val();
		    var standingOrder = $("#txtStandingOrder").val();
		    var table = document.getElementById("tblProdCRMCustDet");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    rowCount=listRow;
		    row.insertCell(0).innerHTML= "<input name=\"listclsProdSuppMasterModel["+(rowCount)+"].strProdCode\" readonly=\"readonly\" class=\"Box\" size=\"15%\" id=\"txtProdCode."+(rowCount)+"\" value="+prodCode+">";		    
		    row.insertCell(1).innerHTML= "<input name=\"listclsProdSuppMasterModel["+(rowCount)+"].strProdName\" readonly=\"readonly\" class=\"Box\" size=\"30%\" id=\"txtProdName."+(rowCount)+"\" value='"+itemName+"'/>";
		    row.insertCell(2).innerHTML= "<input name=\"listclsProdSuppMasterModel["+(rowCount)+"].dblStandingOrder\" id=\"txtStandingOrder."+(rowCount)+"\" required = \"required\" style=\"text-align: right;\" size=\"5%\" class=\"decimal-places-amt\" value="+standingOrder+">";
		    row.insertCell(3).innerHTML= "<input name=\"listclsProdSuppMasterModel["+(rowCount)+"].dblLastCost\" id=\"txtAmount."+(rowCount)+"\" required = \"required\" style=\"text-align: right;\" size=\"5%\" class=\"decimal-places-amt\" value="+amount+">";
		    row.insertCell(4).innerHTML= "<input name=\"listclsProdSuppMasterModel["+(rowCount)+"].dblMargin\" id=\"txtMargin."+(rowCount)+"\" required = \"required\" style=\"text-align: right;\" size=\"5%\" class=\"decimal-places-amt\" value="+margin+">";
		    row.insertCell(5).innerHTML= '<input type="button" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRowForProd(this)">';
		   // funApplyNumberValidation();
		    listRow++;
		  //  return false;
		}
		
		function funDeleteRow(obj)
		{
		    var index = obj.parentNode.parentNode.rowIndex;
		    var table = document.getElementById("tblChild");
		    table.deleteRow(index);
		}
		function funDeleteRowForTax(obj)
		{
		    var index = obj.parentNode.parentNode.rowIndex;
		    var table = document.getElementById("tblPartyTax");
		    table.deleteRow(index);
		}
		
		function funRemoveTaxRows()
		{
			var table = document.getElementById("tblPartyTax");
			var rowCount = table.rows.length;
			while(rowCount>1)
			{
				table.deleteRow(1);
				rowCount--;
			}
		}
		
		function funAddRowTax()
		{
		    var attCode = $("#txtTaxCode").val();
		    if(attCode=='')
		    {
		    	alert("Please select Tax Code");
		    	$("#txtTaxCode").focus();
		    	return false;
		    }
		    var taxCode = $("#txtTaxCode").val();
		    var taxDesc = $("#txtTaxDesc").val();
		    		    		    
		    var table = document.getElementById("tblPartyTax");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    row.insertCell(0).innerHTML= "<input class=\"Box\" size=\"11%\" name=\"listclsPartyTaxIndicatorDtlModel["+(rowCount)+"].strTaxCode\" id=\"txtTaxCode."+(rowCount-1)+"\" value='"+taxCode+"'>";
		    row.insertCell(1).innerHTML= "<input class=\"Box\" size=\"38%\" name=\"listclsPartyTaxIndicatorDtlModel["+(rowCount)+"].strTaxDesc\" id=\"txtTaxDesc."+(rowCount-1)+"\" value='"+taxDesc+"'>";
		    //row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" name=\"listclsPartyTaxIndicatorDtlModel["+(rowCount-1)+"].strTaxCode\" id=\"taxcode."+(rowCount-1)+"\" value="+taxCode+">";
		    //row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"20%\"  id=\"taxDesc."+(rowCount-1)+"\" value="+taxDesc+">";		    
		    row.insertCell(2).innerHTML= '<input type="button" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRowForTax(this)">';		    
		    // funResetTaxField();
		   // return false;
		}
		
		
		function funAddRowTaxForUpdate(taxCode,taxDesc)
		{   		    		    
		    var table = document.getElementById("tblPartyTax");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    row.insertCell(0).innerHTML= "<input class=\"Box\" size=\"11%\" name=\"listclsPartyTaxIndicatorDtlModel["+(rowCount)+"].strTaxCode\" id=\"txtTaxCode."+(rowCount-1)+"\" value='"+taxCode+"'>";
		    row.insertCell(1).innerHTML= "<input class=\"Box\" size=\"38%\" name=\"listclsPartyTaxIndicatorDtlModel["+(rowCount)+"].strTaxDesc\" id=\"txtTaxDesc."+(rowCount-1)+"\" value='"+taxDesc+"'>";
		    row.insertCell(2).innerHTML= '<input type="button" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRowForTax(this)">';
		  //  return false;
		}
		
		
		function funResetTaxField()
		{
			$("#chkApplForWT").attr('checked', false);
		}
		
		
		$(function()
		{
			$('a#baseUrl').click(function() 
			{
				if($("#txtPartyCode").val().trim()=="")
				{
					alert("Please Select Party Code");
					return false;
				}
				 window.open('attachDoc.html?transName=frmCustomerMaster.jsp&formName= Customer Master&code='+$('#txtPartyCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
              });
			
			
			$('#bodyCustomerMaster').keydown(function(e) {
				if(e.which == 116){
					resetForms('CustomermasterForm');
					funResetFields();
				}
			});
		});
		
	/*//$(".numeric").numeric();
			$(".integer").numeric(false, function() { alert("Integers only"); this.value = ""; this.focus(); });
			$(".positive").numeric({ negative: false }, function() { alert("No negative values"); this.value = ""; this.focus(); });
			$(".positive-integer").numeric({ decimal: false, negative: false }, function() { alert("Positive integers only"); this.value = ""; this.focus(); });
		    $(".decimal-places").numeric({ decimalPlaces: maxQuantityDecimalPlaceLimit, negative: false });
		    $(".decimal-places-amt").numeric({ decimalPlaces: maxAmountDecimalPlaceLimit, negative: false });
		} */
		
		
		
		
		function funDuplicateProduct(strProdCode)
		{
			var table = document.getElementById("tblProdCRMCustDet");
			var clientCode='<%=session.getAttribute("clientCode").toString()%>';
			if(clientCode=='141.001'){
				table = document.getElementById("tblProdDet1");
			}
		    var rowCount = table.rows.length;		   
		    var flag=true;
		    if(rowCount > 0)
		    {
		    	    if(clientCode=='141.001'){
		    	    	  $('#tblProdDet1 tr').each(function()
		    					    {
		    						    if(strProdCode==$(this).find('input').val())// `this` is TR DOM element
		    		    				{
		    						    	alert("Product Already added "+ strProdCode);
		    			    				flag=false;
		    		    				}
		    						});
		    	    	
		    	    }
		    	    else
		    	    {
		    	    	  $('#tblProdCRMCustDet tr').each(function()
		    					    {
		    						    if(strProdCode==$(this).find('input').val())// `this` is TR DOM element
		    		    				{
		    						    	alert("Product Already added "+ strProdCode);
		    			    				flag=false;
		    		    				}
		    						});
		    	    	
		             }  	
				  
				    
		    	}
		    return flag;
		}
		
		function funDeleteRowForProd(obj)
		{
		    var clientCode='<%=session.getAttribute("clientCode").toString()%>';
			if(clientCode=='141.001'){
				 var index = obj.parentNode.parentNode.rowIndex;
				    var table = document.getElementById("tblProdDet1");
				    table.deleteRow(index);
				
			}
			else
			{
				 var index = obj.parentNode.parentNode.rowIndex;
				 var table = document.getElementById("tblProdCRMCustDet");
				 table.deleteRow(index);
				
			}
		   
		}
		
		
    var btnAllProduct="";
	function  funLoadAllProduct()
	{
	
		var isOk=confirm("Do You Want to Select All Product ?");
		if(isOk)
		{
			var clientCode='<%=session.getAttribute("clientCode").toString()%>';
			
			funRemoveAllRows();
			var searchUrl="";
			searchUrl=getContextPath()+"/loadAllProductData.html";
			
			$.ajax({
			        type: "GET",
			        url: searchUrl,
				    dataType: "json",
				    async: false,
				    success: function(response)
				    {
				    	if(clientCode!='141.001'){
				    		//btnAllProduct="All Product";
				    		//funRemoveProdRows();
					    	//funRemoveProdRows();
					    	//listProductData[i].strProdCode listProductData[i].strProdName listProductData[i].dblListPrice
					    	
					    	
				    		$('#tblProdCRMCustDet tbody').empty();					    
					    	btnAllProduct="";					    	
					    	$.each(response, function(i,item)
					    	{
								
			    					funloadAllProductinGrid1(response[i].strProdCode,response[i].strProdName,response[i].dblListPrice,0,0);	
			    					
					    	});
					    	
				    	}
				    	else
				    	{
				    		 $.each(response, function(i,item)
								    	{
						    				count=i;
						    				//funloadAllProductinGrid(item.strProdCode,item.strProdName,item.dblLastCost,item.dblMargin,item.dblStandingOrder,item.dblAMCAmt,item.dteInstallation,item.intWarrantyDays);
					    					funloadAllProductinGrid(response[i].strProdCode,response[i].strProdName,response[i].dblMRP,'0','1');	

								    	});
					    	listRow=count+1;
				    		
				        }

				    	
				    /* 	$.each(response, function(i,item)
						    	{
									if(clientCode!='141.001'){
				    					funloadAllProductinGrid1(response[i].strProdCode,response[i].strProdName,response[i].dblMRP,'0','1');	
				    				}else{
				    					funloadAllProductinGrid(response[i].strProdCode,response[i].strProdName,response[i].dblMRP,'0','1');	
				    				}
				    				
						    	});
		 */
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
		
	
	function funRemoveProdRows()
	{
		var table = document.getElementById("tblProdDet1");
		var rowCount = table.rows.length;
		while(rowCount>0)
		{
			table.deleteRow(0);
			rowCount--;
		}
		/* var table = document.getElementById("tblProdCRMCustDet");
		var rowCount = table.rows.length;
		while(rowCount>0)
		{
			table.deleteRow(0);
			rowCount--;
		} */
	}
	
		function funloadAllProductinGrid(prodCode,itemName,amount,margin,standingOrder,amcAmount,installationDate,warrInDays)
		{
		    var table = document.getElementById("tblProdDet1");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    
		   
		    row.insertCell(0).innerHTML= "<input name=\"listclsProdSuppMasterModel["+(rowCount)+"].strProdCode\" readonly=\"readonly\" class=\"Box\" size=\"15%\" id=\"txtProdCode."+(rowCount)+"\" value="+prodCode+">";		    
		    row.insertCell(1).innerHTML= "<input name=\"listclsProdSuppMasterModel["+(rowCount)+"].strProdName\" readonly=\"readonly\" class=\"Box\" size=\"30%\" id=\"txtProdName."+(rowCount)+"\" value='"+itemName+"'/>";
		    row.insertCell(2).innerHTML= "<input name=\"listclsProdSuppMasterModel["+(rowCount)+"].dblLastCost\" id=\"txtAmount."+(rowCount)+"\" required = \"required\" style=\"text-align: right;\" size=\"9%\" class=\"decimal-places-amt\" value="+amount+">";
		    row.insertCell(3).innerHTML = "<input  size=\"8%\" style=\" text-align: right; padding-right: 4px;\" class=\"decimal-places-amt\"  style=\"text-align: right;\" name=\"listclsProdSuppMasterModel["+(rowCount)+"].dblAMCAmt\" id=\"dblAMCAmt."+(rowCount)+"\" style=\"text-align: left;  height:20px;\"  value='"+amcAmount+"' />";
			row.insertCell(4).innerHTML = "<input readonly=\"readonly\" size=\"10%\"  class=\"Box\"  name=\"listclsProdSuppMasterModel["+(rowCount)+"].dteInstallation\" id=\"dteInstallation."+(rowCount)+"\" style=\"text-align: left;  height:20px;\"  value='"+installationDate+"' />";
			row.insertCell(5).innerHTML = "<input readonly=\"readonly\" size=\"10%\" style=\"text-align: right; padding-right: 4px;\"  class=\"Box\"  name=\"listclsProdSuppMasterModel["+(rowCount)+"].intWarrantyDays\" id=\"intWarrantyDays."+(rowCount)+"\" style=\"text-align: left;  height:20px;\"  value='"+warrInDays+"' />";
		    row.insertCell(6).innerHTML= "<input name=\"listclsProdSuppMasterModel["+(rowCount)+"].dblStandingOrder\" id=\"txtStandingOrder."+(rowCount)+"\" required = \"required\" style=\"text-align: right;\" size=\"7%\" class=\"decimal-places-amt\" value="+standingOrder+">";
		    row.insertCell(7).innerHTML= "<input name=\"listclsProdSuppMasterModel["+(rowCount)+"].dblMargin\" id=\"txtMargin."+(rowCount)+"\" required = \"required\" style=\"text-align: right;\" size=\"7%\" class=\"decimal-places-amt\" value="+margin+">";
		    row.insertCell(8).innerHTML= '<input type="button" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRowForProd(this)">';
		   
		  //  funApplyNumberValidation();
		    return false;
		}
		
		
		function showTable()
		{
			var optInit = getOptionsFromForm();
		    $("#Pagination").pagination(listProductData.length, optInit);	
		    //$("#divValueTotal").show();
		    
		}

		var items_per_page = 15;
		function getOptionsFromForm()
		{
		    var opt = {callback: pageselectCallback};
			opt['items_per_page'] = items_per_page;
			opt['num_display_entries'] = 15;
			opt['num_edge_entries'] = 3;
			opt['prev_text'] = "Prev";
			opt['next_text'] = "Next";
		    return opt;
		} 
		
		 function funloadAllProductinGrid1(prodCode,itemName,amount,margin,standingOrder)
		{	
		    var table = document.getElementById("tblProdCRMCustDet");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    row.insertCell(0).innerHTML= "<input name=\"listclsProdSuppMasterModel["+(rowCount)+"].strProdCode\" readonly=\"readonly\" class=\"Box\" size=\"15%\" id=\"txtProdCode."+(rowCount)+"\" value="+prodCode+">";		    
		    row.insertCell(1).innerHTML= "<input name=\"listclsProdSuppMasterModel["+(rowCount)+"].strProdName\" readonly=\"readonly\" class=\"Box\" size=\"30%\" id=\"txtProdName."+(rowCount)+"\" value='"+itemName+"'/>";
		    row.insertCell(2).innerHTML= "<input name=\"listclsProdSuppMasterModel["+(rowCount)+"].dblStandingOrder\" id=\"txtStandingOrder."+(rowCount)+"\" required = \"required\" style=\"text-align: right;\" size=\"5%\" class=\"decimal-places-amt\" value="+standingOrder+">";
		    row.insertCell(3).innerHTML= "<input name=\"listclsProdSuppMasterModel["+(rowCount)+"].dblLastCost\" id=\"txtAmount."+(rowCount)+"\" required = \"required\" style=\"text-align: right;\" size=\"5%\" class=\"decimal-places-amt\" value="+amount+">";
		    row.insertCell(4).innerHTML= "<input name=\"listclsProdSuppMasterModel["+(rowCount)+"].dblMargin\" id=\"txtMargin."+(rowCount)+"\" required = \"required\" style=\"text-align: right;\" size=\"5%\" class=\"decimal-places-amt\" value="+margin+">";
		    row.insertCell(5).innerHTML= '<input type="button" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRowForProd(this)">';
		  //  funApplyNumberValidation();
		   // return false;
		} 
		
		function pageselectCallback(page_index, jq)
		{
	    	var max_elem = Math.min((page_index+1) * items_per_page, listProductData.length);
		    var newcontent="";
		
		    var rowCount=0;
		   		    	
			   	newcontent = '<table id="tblProdDetPg" class="transTablex" style="width: 100%;font-size:11px;font-weight: bold;">'
			   	+'<tr bgcolor="#c0c0c0">'
			   	+'<td width="10px">Product Code</td><td width="22px">Product Name</td>'
			   	+'<td width="2px">Std Order Qty</td><td width="23px">Amount</td><td width="20px">Margin %</td><td width="8px">Delete</td>'
			   	+'</tr>';
			   	
			  
			    for(var i=page_index*items_per_page;i<max_elem;i++)
			    {
			    
					    

						newcontent += '<tr><td>'+ "<input name=\"listclsProdSuppMasterModel["+(i)+"].strProdCode\" readonly=\"readonly\"   class=\"Box \" size=\"15%\"  id=\"txtProdCode."+(i)+"\" value='"+listProductData[i].strProdCode+"' ></td>";
						newcontent += '<td>'+ "<input name=\"listclsProdSuppMasterModel["+(i)+"].strProdName\" readonly=\"readonly\" class=\"Box\" size=\"30%\" id=\"txtProdName."+(rowCount)+"\"  value='"+listProductData[i].strProdName+"' ></td> ";
						if(btnAllProduct =="All Product")
						{
							newcontent += '<td>'+ "<input name=\"listclsProdSuppMasterModel["+(i)+"].dblStandingOrder\" id=\"txtStandingOrder."+(rowCount)+"\" required = \"required\" style=\"text-align: right;\" size=\"5%\" class=\"decimal-places-amt\" value="+listProductData[i].dblListPrice+"></td>";
							newcontent += '<td>'+ "<input name=\"listclsProdSuppMasterModel["+(i)+"].dblLastCost\" id=\"txtAmount."+(rowCount)+"\" required = \"required\" style=\"text-align: right;\" size=\"5%\" class=\"decimal-places-amt\" value="+listProductData[i].dblListPrice+" ></td>  ";
							newcontent += '<td>'+ "<input name=\"listclsProdSuppMasterModel["+(i)+"].dblMargin\" id=\"txtMargin."+(rowCount)+"\" required = \"required\" style=\"text-align: right;\" size=\"5%\" class=\"decimal-places-amt\"  value = '"+listProductData[i].dblListPrice+"' ></td>";
							
						}
						else
					    {
							newcontent += '<td>'+ "<input name=\"listclsProdSuppMasterModel["+(i)+"].dblStandingOrder\" id=\"txtStandingOrder."+(rowCount)+"\" required = \"required\" style=\"text-align: right;\" size=\"5%\" class=\"decimal-places-amt\" value="+listProductData[i].dblStandingOrder+"></td>";
							newcontent += '<td>'+ "<input name=\"listclsProdSuppMasterModel["+(i)+"].dblLastCost\" id=\"txtAmount."+(rowCount)+"\" required = \"required\" style=\"text-align: right;\" size=\"5%\" class=\"decimal-places-amt\" value="+listProductData[i].dblLastCost+" ></td>  ";
							newcontent += '<td>'+ "<input name=\"listclsProdSuppMasterModel["+(i)+"].dblMargin\" id=\"txtMargin."+(rowCount)+"\" required = \"required\" style=\"text-align: right;\" size=\"5%\" class=\"decimal-places-amt\"  value = '"+listProductData[i].dblMargin+"' ></td>";
							
					    }		
						newcontent += '<td>'+ '<input type="button" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRowForProd(this)">'+ '</td>'+'</tr>';

						rowCount++;
			    }
					    newcontent += '</table>';
					    $('#Searchresult').html(newcontent);
					    return false;
             }
		
		function funOnClickProdTab() {
			var strCustCode=$("#txtPartyCode").val();
			var table = document.getElementById("tblProdCRMCustDet");
			var rowCount = table.rows.length;
			if(strCustCode!='' && rowCount==0 )
			{
				funPartyProdData(strCustCode);
				
			}
			
			
		}
		
		function funPartyProdData(code)
		{
			var clientCode='<%=session.getAttribute("clientCode").toString()%>';
			funRemoveProdRows();
			var searchUrl="";
			searchUrl=getContextPath()+"/loadPartyProdData.html?partyCode="+code;
			
			$.ajax({
			        type: "GET",
			        url: searchUrl,
				    dataType: "json",
				    async:false,
				    beforeSend : function(){
						 $("#wait").css("display","block");
				    },
				    complete: function(){
				    	 $("#wait").css("display","none");
				    },
				    success: function(response)
				    {
				    	if(clientCode!='141.001'){
				    		funRemoveProdRows();
				    		$('#tblProdCRMCustDet tbody').empty();					    
					    	btnAllProduct="";					    	
					    	$.each(response, function(i,item)
					    	{
								
			    					funloadAllProductinGrid1(response[i].strProdCode,response[i].strProdName,response[i].dblLastCost,response[i].dblMargin,response[i].dblStandingOrder);	
			    					
					    	});
				    	}
				    	else
				    	{
				    		 $.each(response, function(i,item)
								    	{
						    				count=i;
						    				funloadAllProductinGrid(item.strProdCode,item.strProdName,item.dblLastCost,item.dblMargin,item.dblStandingOrder,item.dblAMCAmt,item.dteInstallation,item.intWarrantyDays);	
								    	});
					    	listRow=count+1;
				    		
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
		 * Delete a All record from a grid
		 */
		function funRemoveAllRows()
		{
			var table = document.getElementById("tblProdDet1");
			var rowCount = table.rows.length;
			while(rowCount>0)
			{
				table.deleteRow(0);
				rowCount--;
			}
			var table = document.getElementById("tblProdDet1");
			var rowCount = table.rows.length;
			while(rowCount>0)
			{
				table.deleteRow(0);
				rowCount--;
			}
		}
		
		function funSetLocation(code)
		{
			$.ajax({
			        type: "GET",
			        url: getContextPath()+"/loadLocationMasterData.html?locCode="+code,
			        dataType: "json",
			
			        success: function(response)
			        {
				       	if(response.strLocCode=='Invalid Code')
				       	{
				       		alert("Invalid Location Code");
				       		$("#txtLocCode").val('');
				       	}
				       	else
				       	{
				       		var pName= funGetCustomerLocationProperty(code);
				       		if(pName.length>0)
				       			{
				       				alert("Location Already Link to "+pName);
				       			}else
				       				{
				       				$("#txtLocCode").val(response.strLocCode);
							       	$("#lblLocName").text(response.strLocName);
				       				}
				       		
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
		
		
		function funSetPropertyData(code) {
			$("#txtPropCode").val(code);
			$.ajax({
				type : "GET",
				url : getContextPath() + "/loadPropertyMasterData.html?Code="
						+ code,
				dataType : "json",
				success : function(resp) {
					// we have the response
					if('Invalid Code' == resp.propertyCode){
						alert("Invalid Property Code")
						$("#txtPropCode").val('');
						$("#lblPropName").val('');
						$("#txtPropCode").focus();
						
					}else{
						$("#txtPropCode").val(resp.propertyCode);
						$("#lblPropName").text(resp.propertyName);
					
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

		
		function funGetCustomerLocationProperty(code)
		{
			var propCode=$("#txtPropCode").val();
			var retval=""
			$.ajax({
			        type: "GET",
			        url: getContextPath()+"/loadGetCustomerLocationProperty.html?locCode="+code+"&propCode="+propCode,
			        dataType: "json",
			        
			        success: function(response)
			        {
				       	
				       		retval=response.strPName;
				      
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
			return retval;
		}
	
	
		function funLikeCustomer()
		{
			isLikeCustClk=true;
			funHelp('custMaster');
		}
		
		function funPartyProdDataForLikeUser(code)
		{
			var clientCode='<%=session.getAttribute("clientCode").toString()%>';
			funRemoveProdRows();
			var searchUrl="";
			searchUrl=getContextPath()+"/loadPartyProdData.html?partyCode="+code;
			
			$.ajax({
			        type: "GET",
			        url: searchUrl,
				    dataType: "json",
				    async:false,
				    beforeSend : function(){
						 $("#wait").css("display","block");
				    },
				    complete: function(){
				    	 $("#wait").css("display","none");
				    },
				    success: function(response)
				    {
				    	if(clientCode!='141.001'){
				    		
				    		$('#tblProdCRMCustDet tbody').empty();					    	
					    	btnAllProduct="";	
					    	
					 	    $.each(response, function(i,item)
					    	{
									funloadAllProductinGrid1(response[i].strProdCode,response[i].strProdName,response[i].dblLastCost,response[i].dblMargin,response[i].dblStandingOrder);	
			    					
					    	});
					    
					    	
				    	}
				    	else
				    	{
				    		 $.each(response, function(i,item)
								    	{
						    				count=i;
						    				funloadAllProductinGrid(item.strProdCode,item.strProdName,item.dblLastCost,item.dblMargin,item.dblStandingOrder,item.dblAMCAmt,item.dteInstallation,item.intWarrantyDays);	
								    	});
					    	listRow=count+1;
				    		
				        }
				    	isLikeCustClk=false;
				    	
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
<body  id="bodyCustomerMaster">
	<div class="container">
		<label id="formHeading">Customer Master</label>
	<s:form name="CustomermasterForm" method="POST" action="saveCustomerMaster.html?saddr=${urlHits}">	
			<div style="border: 0px solid black;">
				<div id="tab_container" style="margin:10px 0px;; overflow:hidden;">
					<ul class="tabs" style="margin-bottom:10px;">
						<li class="active" data-state="tab1">General</li>
						<li data-state="tab2">Address</li>
						<li data-state="tab3" onclick="funOnClickProdTab()">Products</li>
						<li data-state="tab4">Tax</li>
						<li data-state="tab5">Addtional Info/Linkup</li>
					</ul><br>	
					<div id="tab1" class="tab_content">
						<div class="row masterTable" style="width:100%; margin-top:10px;">
								<div class="col-md-2">
									<label>Customer Code:</label><br>
									<s:input id="txtPartyCode" type="text" name="txtPartyCode"  path="strPCode" ondblclick="funHelp('custMaster')" cssClass="searchTextBox"/>
								</div>
				    		<div class="col-md-2">
				    			<label>Finance Code:</label><br>
				        		<s:input id="txtManualCode" type="text" name="txtManualCode" path="strManualCode" />
				        	</div>	
				    		<div class="col-md-2">
				        		<label>Name:</label><br>
				        		<s:input type="text" id="txtPartyName" autocomplete="off"  path="strPName" cssStyle="text-transform: uppercase;" required="true"/>
				        	</div>
				   			<div class="col-md-2">
				        	  	<label>Local Language Name:</label><br>
				        		<%-- <script type="text/javascript">
            						CreateHindiTextBox("txtPNameMarathi",72);
        						</script> --%>
				        		<input type="text" id="txtPNameMarathi" autocomplete="off" name="txtPNameMarathi" style="font-family: shivaji01;"/>
				        	</div>
				   			<div class="col-md-2">
					        	<label>Tel No:</label><br>
					        	<s:input  type="text" id="txtPhone" name="txtPhone" path="strPhone" />
					      	</div>
					      		<div class="col-md-2"></div>
					       <div class="col-md-2">
					        	<label> Mobile N0:</label>
					      <%--   pattern="[789][0-9]{9}" --%>
					        	<s:input  type="text" id="txtMobile" name="txtMobile" path="strMobile"/>
					       </div>
				 		 	<div class="col-md-2">
					    		<label>Fax:</label>
					        	<s:input id="txtFax" name="txtFax" path="strFax"/>
					        </div>
					    	<div class="col-md-2">
					    		<label>Contact Person:</label>
					        	<s:input id="txtContact" name="txtContact" path="strContact" autocomplete="off" cssStyle="text-transform: uppercase;" />
					       </div>			    
				  			<div class="col-md-2">
					        	<label>Email:</label>
					        	<s:input  type="email" placeholder="name@email.com"   id="txtEmail" name="txtEmail" path="strEmail"/>
					        </div>
				   			<div class="col-md-2">
					    		<label>Bank Name:</label>
					        	<s:input  id="txtBankName" name="txtBankName" path="strBankName" autocomplete="off" cssStyle="text-transform: uppercase;"/>
					       </div>
					       <div class="col-md-2"></div>
				    		<div class="col-md-2">
					    		<label>Bank Address Line 1:</label>
					        	<s:input  id="txtBankAdd1" name="txtBankAdd1" path="strBankAdd1"  cssStyle="text-transform: uppercase;"/>
					        </div>
				    	   <div class="col-md-2">
				    			<label>Bank Address Line 2:</label>
		       					<s:input id="txtBankAdd2"  name="txtBankAdd2" path="strBankAdd2" cssStyle="text-transform: uppercase;"/>
		       				</div>
				    	  	<div class="col-md-2">
					    		<label>Bank Account No:</label>
					        	<s:input id="txtBankAccountNo" name="txtBankAccountNo" path="strBankAccountNo"/>
					        </div>
					    	<div class="col-md-2">
					    		<label>ABA No:</label>
					       		<s:input id="txtBankABANo" name="txtBankABANo" path="strBankABANo"/>
				  			</div>
				  			<div class="col-md-2">
					    		<label>IBAN No:</label>
					        	<s:input id="txtIbanNo" name="txtIbanNo" path="strIBANNo"/>
					      	</div> 
					      	<div class="col-md-2"></div>
					      	<div class="col-md-2">
					    		<label>Bank Swift Code:</label>
					        	<s:input id="txtSwiftCode" name="txtSwiftCode" path="strSwiftCode"/>
					       </div>
				  			<div class="col-md-2">
				    		  	<label>Tax No. 1:</label>
					         	<s:input id="txtTaxNo1" name="txtTaxNo1" path="strTaxNo1"/>
					        </div>
					        <div class="col-md-2">
					    	 	<label>Tax No. 2:</label>
					        	<s:input id="txtTaxNo2" name="txtTaxNo2" path="strTaxNo2" />
					       </div>
					       <div class="col-md-2">
					    		<label>CST No/GST No:</label>
					      		<s:input id="txtCst" name="txtCst" path="strCST" />
					      	</div>
					      	<div class="col-md-2">
					    		<label>VAT:</label>
					        	<s:input id="txtVat" name="txtVat" path="strVAT"/>
					        </div>
					         <div class="col-md-2"></div>
				  			<div class="col-md-2">
					    		<s:label path="strExcise" >Excise No.</s:label>
					        	<s:input id="txtExcise" name="txtExcise" path="strExcise" />
					        </div>
					        <div class="col-md-2">
					    		<s:label path="strServiceTax" >Service Tax No.</s:label>
					        	<s:input id="txtServiceTax" name="txtServiceTax" path="strServiceTax" />
					       </div>
				  			<div class="col-md-2">
					    	 	<s:label path="strPartyType" >Customer Type</s:label>
					       		<s:select id="cmbPartyType" name="cmbPartyType" path="strPartyType" items="${typeList}" style="width:70%;" />
					       	</div>
					       	<div class="col-md-2">			    	
					    		<s:label path="strAcCrCode" >A/C Creditors Code</s:label>
					        	<s:input id="txtAcCrCode" name="txtAcCrCode" path="strAcCrCode"/>
					        </div>
				  			<div class="col-md-2">
				    			<label>Credit Days</label>
				        		<s:input type="number" id="txtCreditDays" name="txtCreditDays" path="intCreditDays"/>
				        	</div>
				        	 <div class="col-md-2"></div>
				        	<div class="col-md-2">
				    			<label>Credit Limit</label>
				        		<s:input type="number" id="txtCreditLimit" name="txtCreditLimit" path="dblCreditLimit"/>
				        	</div>
				  			<div class="col-md-2">
					    		<label>Registration No.</label>
					      	 	<s:input id="txtRegistration" name="txtRegistration" path="strRegistration" />
					      	 </div>
					      	 <div class="col-md-2">
					    		<label>Range:</label>
					        	<s:input id="txtRange" name="txtRange" path="strRange"/>
					        </div>
				  		 	<div class="col-md-2">
				    			<s:label path="strDivision" >Division</s:label>
				        		<s:input id="txtDivision" name="txtDivision" path="strDivision" />
				        	</div>
				        	<div class="col-md-2">
				    			<s:label path="strCommissionerate" >Commissionerate</s:label>
				        		<s:input id="txtCommissionerate" name="txtCommissionerate" path="strCommissionerate" />
				        	</div>
				  			 <div class="col-md-2"></div>
				  		 <!-- problem -->
				  			<div class="col-md-2">
				    			<s:label path="strCategory" >Category</s:label>
				        		<s:select id="cmbCategory" name="cmbCategory" path="strCategory" items="${categoryList}"  />
				        	</div>
				        	<div class="col-md-2">
				    			<s:label path="strExcisable" >Party Indicator</s:label>
				        		<s:select id="cmbPartyIndi" name="cmbPartyIndi" path="strPartyIndi" items="${partyIndicatorList}" style="width:50%;"  />
				        	</div>
							<div class="col-md-2">
								<label>Sale Discount</label>
				        		<s:input type="number" id="txtDiscount" name="txtDiscount" path="dblDiscount"/>
				        	</div>
				        	<div class="col-md-2">
				        	  	<label>Operational</label>
					    			<s:select id="cmbOperational" path="strOperational" style="width:70%;">
						    			<option selected="selected" value="Y">Yes</option>
					            		<option value="N">No</option>
				            		</s:select>
					    	</div>
				        	<div class="col-md-2">
								<label>Sale Return Discount</label>
				        		<s:input type="number" id="txtReturnDiscount" name="txtReturnDiscount" path="dblReturnDiscount" />
				      		 </div>
				      		 <div class="col-md-2"></div>
							<div class="col-md-2">
								<label>Currency </label>
									<s:select id="cmbCurrency" items="${currencyList}" path="strCurrency" style="width:70%;">
									</s:select>
							</div>
				  			<div class="col-md-2">
						   		<label>GST No.</label>
					       		<s:input id="txtGSTNo" name="txtGSTNo" path="strGSTNo"  />
					        </div>
					        <div class="col-md-2">
					         	<label>E.C.C.No</label>
				        		<s:input id="txtECCNo" name="txtECCNo" path="strECCNo" />
				        	</div>
					   		<div class="col-md-2">
					    		<label>Property Code</label>
								<s:input path="strPropCode" id="txtPropCode" ondblclick="funHelp('property');" value="${propertyCode}" cssClass="searchTextBox" />
							</div>
							<div class="col-md-2">
								<label id="lblPropName" style="background-color:#dcdada94; width: 100%; height: 52%; margin-top: 26px; text-align:   center;"
								>${propertyName}</label>
							</div>
								<div class="col-md-2"></div>
					 		<div class="col-md-2">
						   		<label>Location</label>
					      		<s:input id="txtLocCode" name="txtLocCode" path="strLocCode" cssClass="searchTextBox" ondblclick="funHelp('locationmaster')"/>
					   		</div>
					   		<div class="col-md-2">
					   		 	<label id="lblLocName" style="background-color:#dcdada94; width: 100%; height: 52%; margin-top: 26px; text-align:   center;"
					   		 	></label>
					   		</div> 
					   		<div class="col-md-2">
								<label>Applicable For Withholding</label>
					    		<s:checkbox id="chkApplForWT" path="strApplForWT" value="Y"/>	
					    	</div>
					</div>
				</div>	
					<div id="tab2" class="tab_content">
						<div class="row masterTable" style="width:100%; margin-top:10px;">
					
							<div class="col-md-2">
								<label>Region</label>
								<s:select id="cmbRegion" name="cmbRegion" path="strRegion" items="${hmRegion}"  />
							</div>
							<div class="col-md-12"><p style="margin:10px 0px;">Main Address</p></div>
							
							<div class="col-md-2">
				    			<s:label path="strMAdd1">Address Line 1:</s:label>
				        		<s:input cssStyle="text-transform: uppercase;" id="txtMainAdd1" name="txtMainAdd1" path="strMAdd1"/>
				        	</div>
				    		<div class="col-md-2">
				    	      <s:label path="strMAdd2"> Address Line 2:</s:label>
				              <s:input cssStyle="text-transform: uppercase;" id="txtMainAdd2" name="txtMainAdd2" path="strMAdd2"/>
				            </div>
				    		<div class="col-md-2">
				    			<s:label path="strMCity">City</s:label>
				       			<s:input id="txtMainCity" cssStyle="text-transform: uppercase;" name="txtMainCity" path="strMCity" />
				       		</div>
				       		<div class="col-md-2">
				       			 <s:label path="strMState"> State</s:label>
				       			 <s:input id="txtMainState" cssStyle="text-transform: uppercase;" name="txtMainState" path="strMState" />
				       		</div>
				       		<div class="col-md-4"></div>
				    		<div class="col-md-2">
				    			<s:label path="strMCountry"> Country</s:label>
				      			<s:input id="txtMainCountry" name="txtMainCountry" cssStyle="text-transform: uppercase;" path="strMCountry"  />
				      		</div>
				      		<div class="col-md-2">
				       			<s:label path="strMPin"> Pin</s:label>
				       			<s:input pattern="[0-9]{6}" id="txtMainPin" name="txtMainPin" path="strMPin"/>
				       		</div>
				       		
				       		<div class="col-md-12"><p style="margin:10px 0px;">Billing Address</p></div>
				    	
							<div class="col-md-2">
				    			<s:label path="strBAdd1">Address Line 1</s:label>
				        		<s:input  cssStyle="text-transform: uppercase;" id="txtBillAdd1" name="txtBillAdd1" path="strBAdd1"/>
				        	</div>
				    		<div class="col-md-2">
				    			<s:label path="strBAdd2">Address Line 2</s:label>
				        		<s:input cssStyle="text-transform: uppercase;" id="txtBillAdd2" name="txtBillAdd2" path="strBAdd2"/>
				        	</div>
				    		<div class="col-md-2">
				    			<s:label path="strBCity">City</s:label>
				        		<s:input id="txtBillCity" name="txtBillCity" cssStyle="text-transform: uppercase;" path="strBCity"  />
				        	</div>
				        	<div class="col-md-2">
				        		 <s:label path="strBState">State</s:label>
				       			 <s:input id="txtBillState" name="txtBillState" cssStyle="text-transform: uppercase;" path="strBState" />
				       		</div>
				       			<div class="col-md-4"></div>
				    		<div class="col-md-2">
				    			<s:label path="strBCountry">Country</s:label>
				       			<s:input id="txtBillCountry" name="txtBillCountry" cssStyle="text-transform: uppercase;" path="strBCountry" />
				       		</div>
				       		<div class="col-md-2">
				       			<s:label path="strBPin">Pin</s:label>
				        		<s:input pattern="[0-9]{6}" id="txtBillPin" name="txtBillPin" path="strBPin" />
				        	</div>
				    		<div class="col-md-12"><p style="margin:10px 0px;">Shipping Address</p></div>
				    		
				    		<div class="col-md-2">
				    			<s:label path="">  Same as Billing Address  </s:label>
				     			<s:checkbox id="chkShipAdd" name="chkShipAdd" path="" value="" onclick="funSetAdd()"  />
				     		</div>
				      		<div class="col-md-2">
				    			<s:label path="strSAdd1">  Address Line 1  </s:label>
				       			<s:input  cssStyle="text-transform: uppercase;" id="txtShipAdd1" name="txtShipAdd1" path="strSAdd1" />
				       		</div>
				    		<div class="col-md-2">
				    			<s:label path="strSAdd2">  Address Line 2  </s:label>
				       			<s:input  cssStyle="text-transform: uppercase;" id="txtShipAdd2" name="txtShipAdd2" path="strSAdd2"/>
				       		</div>
				       		<div class="col-md-2">
				    			<s:label path="strSCity"> City</s:label>
				       			<s:input id="txtShipCity" name="txtShipCity"  cssStyle="text-transform: uppercase;" path="strSCity"/>
				       		</div>
				       		<div class="col-md-4"></div>
				       		<div class="col-md-2">
				       			<s:label path="strSState"> State</s:label>
				       	 		<s:input id="txtShipState" name="txtShipState" cssStyle="text-transform: uppercase;" path="strSState" />
				       	  	</div>
				    		<div class="col-md-2">
				    	    	<s:label path="strSCountry"> Country</s:label>
				       			<s:input id="txtShipCountry" name="txtShipCountry" cssStyle="text-transform: uppercase;" path="strSCountry"  />
				       		</div>
				       		
				       		<div class="col-md-2">
				        		<s:label path="strSPin"> Pin</s:label>
				      			<s:input pattern="[0-9]{6}" id="txtShipPin" name="txtShipPin" path="strSPin"  />
				      		</div> 
						</div>
					</div>
					<div id="tab3" class="tab_content">
						<!-- Kindly change funAddRow  So that it cnnot add products -->
						<div class="row transTablex" style="width:100%; margin-top:10px;">
							
									<div class="col-md-2">
										<label>Product Code:</label>
										<input id="txtProdCode" ondblclick="funHelp('productInCRMCust')" type="text" Class="searchTextBox" />
									</div>
									
									<div class="col-md-3">
										<label id="lblProdName" class="namelabel" style="background-color:#dcdada94; width: 100%; height: 42%; margin: 27px 0px;"></label>
									</div>
						
									<div class="col-md-2">
										<label id="lblLicenceAmt">Licence Amount:</label>
										<input id="txtAmount" type="text" class="decimal-places-amt numberField"></input>
									</div>
									
									<div class="col-md-3">
										<label id="lblAMCAmt">AMC Amount:</label>
										<s:input  id="txtAMCAmount"  path="" class="decimal-places-amt numberField"/>
									</div>
								
				      	
								
									<div class="col-md-2">
										<label id="lblInstallationDate">Installation Date:</label>
										<s:input  id="txtInstallationDate"  path=""  cssClass="calenderTextBox" />
									</div>
									
									<div class="col-md-2">
										<label>Std Order Qty:</label>
										<input id="txtStandingOrder" type="text" class="decimal-places-amt numberField"></input>
									</div>
									
									<div class="col-md-3">
										<label>Margin:</label>
										<input id="txtMargin" type="text" class="decimal-places-amt numberField"></input>
									</div>
								
								<div class="col-md-1">
										<label id="lblWarrInDays">Warranty In Day's:</label>
										<s:input  id="txtWarrInDays"  path="" type="text"/>
									</div>
									
				      		<div class="col-md-6">
						            <input type="button"  class="btn btn-primary center-block"  id="btnAdd" value="Add" onclick="return funAddRow()"/>&nbsp;
									<input type="button"  class="btn btn-primary center-block" id="btnAllProd" value="All Product" onclick="return funLoadAllProduct()"/>
								 <input type="button"  class="btn btn-primary center-block"  id="btnLikeCustomer" value="Like Customer" onclick="funLikeCustomer()"/>
										
							</div>
						</div>
<!-- 						<div style="background-color: #a4d7ff; border: 1px solid #ccc; display: block; height: 250px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 80%;"> -->
<!-- 							<table id="tblProdDet" -->
<!-- 								style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll" -->
<!-- 								   class="transTablex col4-center"> -->
<!-- 								<tr > -->
<!-- 									<td style="border: 1px white solid;width:10%"><label>Product Code</label></td> -->
<!-- 									<td style="border: 1px  white solid;width:50%"><label>Product Name</label></td> -->
<!-- 									<td style="border: 1px  white solid;width:10%"><label>Standing Order</label></td> -->
<!-- 									<td style="border: 1px  white solid;width:10%"><label>Amount</label></td> -->
<!-- 									<td style="border: 1px  white solid;width:10%"><label>Margin %</label></td> -->
<!-- 									<td style="border: 1px  white solid;width:10%"><label>Delete</label></td> -->
<!-- 								</tr> -->
<!-- 								</table> -->
						<div class="dynamicTableContainer" style="height: 450px;" id="divProductDetails">
							<table style="height: 30px; border: #0F0;width: 100%; font-size:13px; font-weight: bold;border:1px solid #c0c0c0;">
								<tr style="bgcolor:#c0c0c0;">
									<td style="width:10%"><label>Product Code</label></td>
									<td style="width:25%"><label>Product Name</label></td>
									<td style="width:10%"><label>Licence Amount</label></td>
									<td style="width:10%"><label>AMC Amount</label></td>
									<td style="width:10%"><label>Installation Date</label></td>
									<td style="width:10%"><label>Warranty In Day's</label></td>
									<td style="width:10%"><label>Std Order Qty</label></td>
									<td style="width:10%"><label>Margin %</label></td>
									<td style="width:10%"><label>Delete</label></td>
								</tr>
							</table>
							<div
								style="border: 1px solid #ccc; display: block; height: 410px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 99.80%;">
									<table id="tblProdDet1"
									style="width: 100%; height: 24px; border: #0F0; table-layout: fixed; overflow: scroll"
										class="transTablex col11-center">
									<tbody>
									<col style="width:11%">					
									<col style="width:28%">
									<col style="width:11%">
									<col style="width:11%">
									<col style="width:11%">
									<col style="width:11%">
									<col style="width:12%">
									<col style="width:10%">
									<col style="width:3%">
									
									</tbody>
								</table>
							</div>
						</div>
								
					<div class="dynamicTableContainer" style="height: 450px;" id="divProductDetails1">
						<table style="height: 10px; border: #0F0;width: 100%;font-size:11px;
						font-weight: bold;">
							<tr bgcolor="white">
												<td style="border: 1px white solid;width:10%"><label>Product Code</label></td>
												<td style="border: 1px  white solid;width:50%"><label>Product Name</label></td>
												<td style="border: 1px  white solid;width:10%"><label>Std Order Qty</label></td>
												<td style="border: 1px  white solid;width:10%"><label>Amount</label></td>
												<td style="border: 1px  white solid;width:10%"><label>Margin %</label></td>
												<td style="border: 1px  white solid;width:10%"><label>Delete</label></td>
							</tr>
						</table>
						<div
							style="background-color: #C0E2FE; border: 1px solid #ccc; display: block; height: 410px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 99.80%;">
								<table id="tblProdCRMCustDet" style="width: 100%; height: 24px; border: #0F0; table-layout: fixed; overflow: scroll;background-color:white" class="transTablex col11-center">
								<tbody>
								<col style="width:10%">					
								<col style="width:50%">
								<col style="width:10%">
								<col style="width:10%">
								<col style="width:10%">
								<col style="width:10%">
								
								</tbody>
							</table>
						</div>
					</div> 
			
				<dl id="Searchresult" style="overflow:auto;width: 80%;"></dl>
				<div id="Pagination" class="pagination" style="width: 80%;margin-left: 26px;">
				</div>
			</div>
			
				<div id="tab4" class="tab_content">
					<div class="row transTablex" style="width:100%; margin-top:10px;">
						<div class="col-md-2">
							<label>Tax Code:</label>
							<input id="txtTaxCode" ondblclick="funHelp('taxmaster')" Class="searchTextBox" ></input>
						</div>
						<div class="col-md-2">
							<label>Tax Description:</label>
							<input id="txtTaxDesc" readonly="readonly" type="text"></input>
						</div>
						<div class="col-md-2">
							<input style="margin-top:23px;" id="btnTaxAdd" type="button" value="Add"  class="btn btn-primary center-block" onclick="return funAddRowTax()"></input>
						</div>
						<div class="col-md-3"></div>
					</div><br>
						<div style="border: 1px solid #ccc;height: 250px;background: #fbfafa; overflow-x: hidden; overflow-y: scroll; width: 45%;">
							<table id="tblPartyTax"
									style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
									class="transTablex col3-center">
						<!-- <table class="masterTable"  id="tblPartyTax" style="width:80%" > -->
								<tr style="background:#c0c0c0;">
									<td style="border: 1px white solid;width:10%"><label>Tax Code</label></td>
									<td style="border: 1px  white solid;width:30%"><label>Tax Description</label></td>
									<td style="border: 1px  white solid;width:10%"><label>Delete</label></td>
								</tr>

								<%-- <c:forEach items="${command.listProdAtt}" var="prodAtt"
									varStatus="status">
									<tr>
										<td><input name="listProdAtt[${status.index}].strAttCode"
											value="${prodAtt.strAttCode}" readonly="readonly" /></td>
										<td><input name="listProdAtt[${status.index}].strAttName"
											value="${prodAtt.strAttName}" readonly="readonly" /></td>
										<td><input
											name="listProdAtt[${status.index}].dblAttValue"
											value="${prodAtt.dblAttValue}" /></td>
										<td><input type="hidden"
											value="${prodAtt.strAVCode}" readonly="readonly" /></td>
										<td><input type="button" value="Delete"
											onClick="funDeleteRowForAttribute(this)" class="deletebutton"></td>
									</tr>
								</c:forEach> --%>
							</table>
						</div>
				</div>
				<div id="tab5" class="tab_content">
					<div class="row transTablex" style="width:100%; margin-top:10px;">
						<div class="col-md-2">
							<label>Date of Installation:</label>
								<s:input type="text" required="true" id="txtdtInstallions" path="dtInstallions" cssClass="calenderTextBox" style="width:70%;"/>
						</div>
						<div class="col-md-2">
							<label>Account Manager:</label>
								<s:input type="text"  id="txtAccManager" path="strAccManager"/>
						</div>
					</div>
				</div>
				</div>
			</div>
			<div class="center" style="text-align:center;">
				<input id="formsubmit" type="Submit" class="btn btn-primary center-block" onclick="return funValidateFields()" value="Submit" />
				<input  type="button" value="Reset" onclick="funResetFields()"
						class="btn btn-primary center-block" />
			</div>
		
			<div id="wait"
				style="display: none; width: 60px; height: 60px; border: 0px solid black; position: absolute; top: 60%; left: 55%; padding: 2px;">
				<img src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif"
					width="60px" height="60px" />
			</div>
			<s:input id="hidDebtorCode" type="hidden" path="strDebtorCode" />	
		</s:form>
	</div>
			<%-- <script type="text/javascript">
				funApplyNumberValidation();
			</script> --%>
 </body>
 </html>
