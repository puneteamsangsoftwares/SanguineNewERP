<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html >
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
	
	    <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />

		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
	
<title>SUPPLIER MASTER</title>
<%-- <tab:tabConfig/> --%>

<script type="text/javascript">
var strcheckboxStatus="N";
	$(document).ready(function() {
		
		
		var strIndustryType='<%=session.getAttribute("strIndustryType").toString()%>';
   		if(strIndustryType=='MilkFederation') 
   		{
			$("#lblSupplierName").text('Farmer Name ');
			$("#lblSupplierCode").text('Farmer Code ');
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
	});
</script>


	<script type="text/javascript">

		var fieldName;
		var posItemCode;
		var clickCount =0.0;
		
		function funValidateFields()
		{
			
			var flg=true;
			if($("#txtPartyName").val().trim()=="")
			{
				alert("Please Enter Supplier Name");
				$("#txtPartyName").focus();
				return false;
			}
			
			if(clickCount==0){
				clickCount=clickCount+1;
			if($('#txtPartyCode').val()=='')
			{
				var code = $('#txtPartyName').val().trim();
				 $.ajax({
				        type: "GET",
				        url: getContextPath()+"/checkSuppName.html?suppName="+code,
				        async: false,
				        dataType: "text",
				        success: function(response)
				        {
				        	if(response=="true")
				        		{
				        			alert("Supplier Name Already Exist!");
				        			$('#txtPartyName').focus();
				        			flg= false;
					    		}
					    	else
					    		{
					    			flg=true;
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
			//alert("flg"+flg);
			return flg;
			
			}
				else
				{
					return false;
				}
			
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
		
		 $(document).ready(function()
		 {
			$("#txtAttName").focus();
			$("#lblParentAttName").text("");
			var propcode='<%=session.getAttribute("propertyCode").toString()%>';
			funSetPropertyData(propcode);
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
			
			$("#txtPartyCode").focus();
	    });
		
		function funHelp(transactionName)
		{
			fieldName=transactionName;
	        
	    //    window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	        window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	    }
	
		
		function funSetSupplier(code)
		{
			gurl=getContextPath()+"/loadSupplierMasterData.html?partyCode=";
			$.ajax({
		        type: "GET",
		        url: gurl+code,
		        dataType: "json",
		        success: function(response)
		        {
		       		if('Invalid Code' == response.strPCode){
		       			alert("Invalid Supplier Code");
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
						$("#cmbPartyIndi").val(response.strPartyIndi);
						$("#txtGSTNo").val(response.strGSTNo);
						$("#txtPropCode").val(response.strPropCode);
						$("#hidDebtorCode").val(response.strDebtorCode);
						$("#txtLocCode").val(response.strLocCode);
					 	$("#txtExternalCode").val(response.strExternalCode);
					 	$("#cmbCurrency").val(response.strCurrency);
						if(response.strLocCode.length>0)
						{}
						if(response.strOperational=='')
						{
							$("#cmbOperationalYN").val('Y');
						}else
						{
							$("#cmbOperationalYN").val(response.strOperational);
						}
						
						if(response.strExcisable=='Y')
				    	{
							$("#cmbExciseSuppYN").val("Yes");
				    	}
				    	else
				    	{
				    		$("#cmbExciseSuppYN").val("No");
				    	}
						
						if(response.strComesaRegion=='Y')
							document.getElementById("chkComesaRegion").checked=true;
				    	else
				    		document.getElementById("chkComesaRegion").checked=false;
				    	
						funSetSupplierTaxDtl(code);
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
		
		
		function funSetSupplierTaxDtl(code)
		{
			funRemoveTaxRows();
			gurl=getContextPath()+"/loadSupplierTaxDtl.html?partyCode=";
			$.ajax({
		        type: "GET",
		        url: gurl+code,
		        dataType: "json",
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
			   case 'suppcode':
			    	funSetSupplier(code);
			        break;
			   
			   case 'productmaster':
			    	funSetProduct(code);
			        break;
			        
			   case 'taxmaster':
				   funSetTax(code);
			        break;     
			  
			   case "property":
					funSetPropertyData(code);
					break;
			
			   case 'locationmaster':
				   funSetLocation(code);	
					
			        
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
			 
			var prodCode = $("#txtProdCode").val();
		    var amount = $("#txtAmount").val();
		    var itemName = $("#lblProdName").text();
		    var table = document.getElementById("tblProdDet");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    row.insertCell(0).innerHTML= "<input name=\"listBomDtlModel["+(rowCount)+"].strProdCode\" readonly=\"readonly\" class=\"Box\" size=\"20%\" id=\"txtProdCode."+(rowCount)+"\" value="+prodCode+">";		    
		    row.insertCell(1).innerHTML= "<input name=\"listBomDtlModel["+(rowCount)+"].strProdName\" readonly=\"readonly\" style=\"margin-left: -10%;\" class=\"Box\" size=\"35%\" id=\"txtProdName."+(rowCount)+"\" value='"+itemName+"'/>";
		    row.insertCell(2).innerHTML= "<input name=\"listBomDtlModel["+(rowCount)+"].dblAmount\" id=\"txtAmount."+(rowCount)+"\" required = \"required\" style=\"text-align: right;margin-left: 40%;\" size=\"14%\" class=\"decimal-places-amt\" value="+amount+">";
		    row.insertCell(3).innerHTML= '<input type="button" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRow(this)">';
		    funApplyNumberValidation();
		    return false;
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
		    row.insertCell(0).innerHTML= "<input class=\"Box\" size=\"31%\" name=\"listclsPartyTaxIndicatorDtlModel["+(rowCount-1)+"].strTaxCode\" id=\"txtTaxCode."+(rowCount-1)+"\" value='"+taxCode+"'>";
		    row.insertCell(1).innerHTML= "<input class=\"Box\" size=\"38%\" name=\"listclsPartyTaxIndicatorDtlModel["+(rowCount-1)+"].strTaxDesc\" id=\"txtTaxDesc."+(rowCount-1)+"\" value='"+taxDesc+"'>";
		    //row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" name=\"listclsPartyTaxIndicatorDtlModel["+(rowCount-1)+"].strTaxCode\" id=\"taxcode."+(rowCount-1)+"\" value="+taxCode+">";
		    //row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"20%\"  id=\"taxDesc."+(rowCount-1)+"\" value="+taxDesc+">";		    
		    row.insertCell(2).innerHTML= '<input type="button" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRowForTax(this)">';		    
		     funResetTaxField()
		    return false;
		}
		
		
		function funAddRowTaxForUpdate(taxCode,taxDesc)
		{   		    		    
		    var table = document.getElementById("tblPartyTax");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    row.insertCell(0).innerHTML= "<input class=\"Box\" size=\"31%\" name=\"listclsPartyTaxIndicatorDtlModel["+(rowCount-1)+"].strTaxCode\" id=\"txtTaxCode."+(rowCount-1)+"\" value='"+taxCode+"'>";
		    row.insertCell(1).innerHTML= "<input class=\"Box\" size=\"38%\" name=\"listclsPartyTaxIndicatorDtlModel["+(rowCount-1)+"].strTaxDesc\" id=\"txtTaxDesc."+(rowCount-1)+"\" value='"+taxDesc+"'>";
		    row.insertCell(2).innerHTML= '<input type="button" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRowForTax(this)">';
		    return false;
		}
		
		
		function funResetTaxField()
		{
			$("#txtTaxCode").val('');
			$("#txtTaxDesc").val('');
			$("#txtTaxCode").focus();
		   
		}
		$(function()
		{
			/*$("#txtPartyCode").blur(function()
			{
			    fieldName='suppliermaster';
			    gurl=getContextPath()+"/loadSupplierMasterData.html?partyCode=";
				funSetData($('#txtPartyCode').val());
			});*/
		    
			$('a#baseUrl').click(function() 
			{
				if($("#txtPartyCode").val().trim()=="")
				{
					alert("Please Select Party Code");
					return false;
				}


				 window.open('attachDoc.html?transName=frmSupplierMaster.jsp&formName= Supplier Master&code='+$('#txtPartyCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
              });
			
			
			$('#bodySupplierMaster').keydown(function(e) {
				if(e.which == 116){
					resetForms('suppliermasterForm');
					funResetFields();
				}
			});
			
			
			$('#txtPartyCode').blur(function() {
					var code = $('#txtPartyCode').val();
					if (code.trim().length > 0 && code !="?" && code !="/") {
						funSetSupplier(code);
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
		function funResetFields()
		{
			location.reload(true); 
		}
		
		
		function funComoBox()
		{
			//document.getElementById("chkNotInUse").checked=true;
			var strVal=$('#cmbExciseSuppYN').val();
			if(strVal=='N')
				{
				document.all[ 'txtExcise' ].style.display = 'none';
				}else 
					{
					document.all[ 'txtExcise' ].style.display = 'block';
					}		
			
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
				       		var pName= funGetSupplierLocationProperty(code);
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
		
		function funGetSupplierLocationProperty(code)
		{
			var propCode=$("#txtPropCode").val();
			var retval=""
			$.ajax({
			        type: "GET",
			        url: getContextPath()+"/loadGetSupplierLocationProperty.html?locCode="+code+"&propCode="+propCode,
			        dataType: "json",
			        async:false,
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
		
		
		function funOpenExportImport()			
		{
			var transactionformName="frmSupplieMaster";
			//var guestCode=$('#txtGuestCode').val();
			
			
		//	response=window.showModalDialog("frmExcelExportImport.html?formname="+transactionformName+"&strLocCode="+locCode,"","dialogHeight:500px;dialogWidth:500px;dialogLeft:550px;");
			response=window.open("frmExcelExportImport.html?formname="+transactionformName,"dialogHeight:500px;dialogWidth:500px;dialogLeft:550px;");
	        
			
		}
		 
		</script>

</head>
<body  id="bodySupplierMaster">
<div class="container">
		<label id="formHeading">Supplier Master</label>
		<s:form name="suppliermasterForm" method="POST" action="saveSupplierMaster.html?saddr=${urlHits}">	
		<div> 
			<div id="tab_container">
					<ul class="tabs">
						<li class="active" data-state="tab1">General</li>
						<li data-state="tab2">Address</li>
						<li data-state="tab3">Products</li>
						<li data-state="tab4">Tax</li>
					</ul>
				<div id="tab1" class="tab_content" style="margin-top: 50px;">
					<div class="row masterTable">
						<div class="col-md-12">
					     	<!--  <a id="baseUrl" href="#">Attatch Documents</a> -->
					        <a onclick="funOpenExportImport()" href="javascript:void(0);" style="font-size:14px;">Export/Import</a>
						</div>
					   	<div class="col-md-2">
					    	<label id="lblSupplierCode">Supplier Code </label>
				        	<s:input id="txtPartyCode" name="txtPartyCode"  path="strPCode" ondblclick="funHelp('suppcode')" readOnly="true"  cssClass="searchTextBox"/>
				        </div>	    
				    	<div class="col-md-2">
				    		<label>Finance Code </label>
				    		<s:input id="txtManualCode" cssClass="BoxW116px"  name="txtManualCode" path="strManualCode" />
				        </div>
				    	<div class="col-md-2">
				    		<label id="lblSupplierName">Name  </label>
				        	<s:input size="80px" type="text" id="txtPartyName" autocomplete="off" name="txtPartyName" path="strPName" cssStyle="text-transform: uppercase;" required="true"/>
				        </div>
				   		<div class="col-md-2">
				    		<label>Tel No.</label>
					       	<s:input  type="text" id="txtPhone" name="txtPhone" path="strPhone" cssClass="BoxW116px"  />
					    </div> 
					    <div class="col-md-4"></div>
					   	<div class="col-md-2">	 
					      	<label> Mobile No.  </label>
					      	<!-- pattern="[789][0-9]{9}" -->
					      	<s:input  type="text" pattern="[0-9]{10,10}"  maxlength="11"  placeholder="Enter Valid MobileNo." id="txtMobile" name="txtMobile" path="strMobile" />
					     </div>
				 		 <div class="col-md-2">	
				    		<label>Fax</label>
					    	<s:input id="txtFax" name="txtFax" path="strFax" cssClass="BoxW116px" />
					     </div>
					     <div class="col-md-2">	
					    	 <label>Contact Person</label>
					    	 <s:input id="txtContact" name="txtContact" path="strContact" autocomplete="off" cssStyle="text-transform: uppercase;" cssClass="BoxW116px" />
					     </div>	
					     <div class="col-md-2">		    
				  			<label>Email  </label>
					      	<s:input   placeholder="name@email.com"   id="txtEmail" name="txtEmail" path="strEmail" />
					     </div>
					      <div class="col-md-4"></div>
					     <div class="col-md-2">		
				   			<label>Bank Name  </label>
					    	<s:input  id="txtBankName" name="txtBankName" path="strBankName" autocomplete="off" cssStyle="text-transform: uppercase;" />
					     </div>
					     <div class="col-md-2">	   
				    		<label>Bank Address Line 1  </label>
					    	<s:input  id="txtBankAdd1" name="txtBankAdd1" maxlength="45" path="strBankAdd1"  cssStyle="text-transform: uppercase;" />
					      </div>
				    	 <div class="col-md-2">	 
				    		<label>Bank Address Line 2  </label>
				    		<s:input id="txtBankAdd2"  name="txtBankAdd2" maxlength="45" path="strBankAdd2" cssStyle="text-transform: uppercase;" />
		       			</div>
				    	<div class="col-md-2">	 
				    		<label>Bank Account No.</label>
					    	<s:input id="txtBankAccountNo" name="txtBankAccountNo" path="strBankAccountNo" cssClass="BoxW116px" />
					     </div>
					       <div class="col-md-4"></div>
					    <div class="col-md-2">	
					    	<label>ABA No.</label>
					    	<s:input id="txtBankABANo" name="txtBankABANo" path="strBankABANo" cssClass="BoxW116px" />
					     </div>
				  		 <div class="col-md-2">	
				  		 	<label>IBAN No</label>
					    	<s:input id="txtIbanNo" name="txtIbanNo" path="strIBANNo" cssClass="BoxW116px" />
					     </div>
					     <div class="col-md-2">	
					       	<label>Bank Swift Code</label>
					    	<s:input id="txtSwiftCode" name="txtSwiftCode" path="strSwiftCode" cssClass="BoxW116px" />
					     </div>
				  		 <div class="col-md-2">	
				  		 	<label>Tax No. 1</label>
					        <s:input id="txtTaxNo1" name="txtTaxNo1" path="strTaxNo1" cssClass="BoxW116px" />
					     </div>
					     <div class="col-md-4"></div>
					     <div class="col-md-2">	
				    		<label>Tax No. 2</label>
					       <s:input id="txtTaxNo2" name="txtTaxNo2" path="strTaxNo2" cssClass="BoxW116px" />
				  		</div>
				  		<div class="col-md-2">	
				  			<label>CST No/GST No</label>
					       <s:input id="txtCst" name="txtCst" path="strCST" cssClass="BoxW116px" />
					    </div>
					    <div class="col-md-2">	
					    	<label>VAT</label>
					        <s:input id="txtVat" name="txtVat" path="strVAT" cssClass="BoxW116px" />
				  		</div>
				  		<div class="col-md-2">
					    	<label  >Excise Supp No.</label>
					    	<s:select id="cmbExciseSuppYN" name="strExcisable" path="strExcisable" cssClass="BoxW124px" onchange="funComoBox()" style="width:50%;">
					    	 <option value="N">No</option>
 				 			<option value="Y">Yes</option>
					    	</s:select>
					    </div>
					     <div class="col-md-4"></div>
					    <div class="col-md-2">    
					     	<label>Comesa Region Supplier</label><br>
							<s:checkbox id="chkComesaRegion" path="strComesaRegion" value="Y"></s:checkbox>
					     </div>
					     <div class="col-md-2">   
					        <s:input id="txtExcise" name="txtExcise" path="strExcise" cssClass="BoxW116px" style="display:none; margin-top:26px;" />
				  		</div>
				  		<div class="col-md-2">
				  			<label>Currency </label>
							<s:select id="cmbCurrency" items="${currencyList}" path="strCurrency" cssClass="BoxW124px" style="width:80%;">
							</s:select>
				  		</div>
				  		<div class="col-md-2">
					  		<s:label path="strServiceTax" >Service Tax No.</s:label>
					        <s:input id="txtServiceTax" name="txtServiceTax" path="strServiceTax" cssClass="BoxW116px" />
					    </div>
					    <div class="col-md-4"></div>
					    <div class="col-md-2">
				  			<label>Operational</label>
					    	<s:select id="cmbOperationalYN" name="strOperational" path="strOperational" cssClass="BoxW124px" style="width:60%;">
 				 			<option value="Y">Yes</option>
 				 			<option value="N">No</option>
					    	</s:select>
					    </div>
					    <div class="col-md-2">
				  			<s:label path="strPartyType" >Supplier Type</s:label>
					       	<s:select id="cmbPartyType" name="cmbPartyType" path="strPartyType" items="${typeList}" cssClass="BoxW124px" style="width:60%;"/>
					    </div>
					    <div class="col-md-2">			    	
					    	<s:label path="strAcCrCode" >A/C Creditors Code</s:label>
					        <s:input id="txtAcCrCode" name="txtAcCrCode" path="strAcCrCode" cssClass="BoxW116px" />
				  		</div>
				  		<div class="col-md-2">
				  			<label>Credit Days</label>
				        	<s:input id="txtCreditDays" name="txtCreditDays" path="intCreditDays" class="BoxW116px"/>
				        </div>
				           <div class="col-md-4"></div>
				        <div class="col-md-2">
				    		<label>Credit Limit</label>
				        	<s:input id="txtCreditLimit" name="txtCreditLimit" path="dblCreditLimit" class="BoxW116px"/>
				  		</div>
				  		<div class="col-md-2">
					    	<label>Registration No.</label>
					        <s:input id="txtRegistration" name="txtRegistration" path="strRegistration" cssClass="BoxW116px" />
					    </div>
					     <div class="col-md-2">
					    	<label>Range:</label>
					        <s:input id="txtRange" name="txtRange" path="strRange" cssClass="BoxW116px" />
				  		</div>
				  		<div class="col-md-2">
				  		 	<s:label path="strDivision" >Division</s:label>
				        	<s:input id="txtDivision" name="txtDivision" path="strDivision" cssClass="BoxW116px" />
				        </div>
				        <div class="col-md-4"></div>
				        <div class="col-md-2">
				    		<s:label path="strCommissionerate" >Commissionerate</s:label>
				        	<s:input id="txtCommissionerate" name="txtCommissionerate" path="strCommissionerate" cssClass="BoxW116px" />
				  		</div>
				  		 <!-- problem -->
				  		<div class="col-md-2">
				  			<s:label path="strCategory" >Category</s:label>
				        	<s:select id="cmbCategory" name="cmbCategory" path="strCategory" items="${categoryList}" cssClass="BoxW124px" />
				    	</div>
				    	<div class="col-md-2">
				    		<label >Party Indicator</label>
				        	<s:select id="cmbPartyIndi" name="cmbPartyIndi" path="strPartyIndi" items="${partyIndicatorList}" cssClass="BoxW124px" style="width:70%;"/>
						</div>
						<div class="col-md-2">
						   <label>GST No.</label>
					       <s:input id="txtGSTNo" name="txtGSTNo" path="strGSTNo" cssClass="BoxW116px" />
					    </div>
					      <div class="col-md-4"></div>
					    <div class="col-md-2">
					        <label>External Code</label>
						    <s:input id="txtExternalCode" name="txtExternalCode" path="strExternalCode"  autocomplete="off" cssClass="BoxW116px"/>
						   	<s:errors path="strExternalCode"></s:errors>
						</div>  
						<div class="col-md-2">  
					    	<label>Property Code</label>
							<s:input path="strPropCode" id="txtPropCode" ondblclick="funHelp('property');" cssClass="searchTextBox"  readOnly="true" />
						</div>
						<div class="col-md-2">  
							<label id="lblPropName" style="background-color:#dcdada94; width: 100%; height: 56%;margin-top: 25px;
    							text-align: center;"></label>
					   </div>
					   <div class="col-md-6"></div>
					   <div class="col-md-2">  
						   	<label>Location</label>
					       	<s:input id="txtLocCode" name="txtLocCode" path="strLocCode" cssClass="searchTextBox" ondblclick="funHelp('locationmaster')"/>
					   </div>
					   <div class="col-md-2"> 		
					   		<label id="lblLocName" style="background-color:#dcdada94; width: 100%; height: 56%;margin-top: 25px;
    							text-align: center;"></label>
						</div>
				</div>
			</div>
							
							
			<div id="tab2" class="tab_content">
			<br><br>
				<div class="row masterTable">
					<div class="col-md-12"><p style="margin: 8px 0px;">Main Address</p></div>
			    		<div class="col-md-2">
			    			<s:label path="strMAdd1">Address Line 1</s:label>
			        		<s:input cssStyle="text-transform: uppercase;" id="txtMainAdd1" name="txtMainAdd1" path="strMAdd1"/>
			        	</div>
			        	<div class="col-md-2">
			    			<s:label path="strMAdd2">  Address Line 2  </s:label>
			       			<s:input  cssStyle="text-transform: uppercase;" id="txtMainAdd2" name="txtMainAdd2" path="strMAdd2"/>
			       		</div>
			       		<div class="col-md-2">
			    			<s:label path="strMCity">City</s:label>
			       			<s:input id="txtMainCity" cssStyle="text-transform: uppercase;" name="txtMainCity" path="strMCity"  />
			       		</div>
			       		<div class="col-md-2">
			     			 <s:label path="strMState"> State</s:label>
			      			 <s:input id="txtMainState" cssStyle="text-transform: uppercase;" name="txtMainState" path="strMState" />
			    		</div>
			    		<div class="col-md-4"></div>
			    		<div class="col-md-2">
			    			<s:label path="strMCountry"> Country</s:label>
			       			<s:input id="txtMainCountry" name="txtMainCountry" cssStyle="text-transform: uppercase;" path="strMCountry" />
			       		</div>
			       		<div class="col-md-2">
			         		<s:label path="strMPin"> Pin</s:label>	
			       			<s:input pattern="[0-9]{6}" id="txtMainPin" name="txtMainPin" path="strMPin" />
			       		</div>
		  			<div class="col-md-12"><p style="margin: 8px 0px;">Billing Address</p></div>
						<div class="col-md-2">
			    			<s:label path="strBAdd1"> Address Line 1 </s:label>
			       	 		<s:input  cssStyle="text-transform: uppercase;" id="txtBillAdd1" name="txtBillAdd1" path="strBAdd1"/>
			    		</div>
			    		<div class="col-md-2">	
			    			<s:label path="strBAdd2">  Address Line 2 </s:label>
			     			 <s:input  cssStyle="text-transform: uppercase;" id="txtBillAdd2" name="txtBillAdd2" path="strBAdd2"/>
			     		</div>
			     		<div class="col-md-2">	
			    			<s:label path="strBCity"> City</s:label>
			       			<s:input id="txtBillCity" name="txtBillCity" cssStyle="text-transform: uppercase;" path="strBCity" />
			       		</div>
			       		<div class="col-md-2">	
			    			<s:label path="strBState"> State</s:label>
							<s:input id="txtBillState" name="txtBillState" cssStyle="text-transform: uppercase;" path="strBState" />
			    		</div>
		    			<div class="col-md-4"></div>
			    		<div class="col-md-2">	
					    	<s:label path="strBCountry"> Country</s:label>
			        		<s:input id="txtBillCountry" name="txtBillCountry" cssStyle="text-transform: uppercase;" path="strBCountry" />
			        	</div>
			        	<div class="col-md-2">	
							 <s:label path="strBPin"> Pin</s:label>
			       			<s:input pattern="[0-9]{6}" id="txtBillPin" name="txtBillPin" path="strBPin" />
			    		</div>	
		    		
		    		<div class="col-md-12"><P style="margin: 8px 0px;">Shipping Address</P></div>
		    		<div class="col-md-12">
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
		        		<s:input id="txtShipCity" name="txtShipCity"  cssStyle="text-transform: uppercase;" path="strSCity"  />
		        	</div>
		        	<div class="col-md-2">
		      			 <s:label path="strSState"> State</s:label>
		     			 <s:input id="txtShipState" name="txtShipState" cssStyle="text-transform: uppercase;" path="strSState"/>
		     		</div>
		     		<div class="col-md-4"></div>
		     		<div class="col-md-2">
		    			<s:label path="strSCountry"> Country</s:label>
		      			<s:input id="txtShipCountry" name="txtShipCountry" cssStyle="text-transform: uppercase;" path="strSCountry"  />
		      		</div>
		      		<div class="col-md-2">
		      		 	<s:label path="strSPin"> Pin</s:label>
		       			<s:input pattern="[0-9]{6}" id="txtShipPin" name="txtShipPin" path="strSPin" />
		    		</div>	
			   </div>	
			</div>
			
			<div id="tab3" class="tab_content">
				<!-- Kindly change funAddRow  So that it cnnot add products -->
					<br><br>
						<div class="row transTablex" style="overflow:hidden;">
							<div class="col-md-2">
								<label>Product Code:</label>
								<input id="txtProdCode" type="text" ondblclick="funHelp('productmaster')" Class="searchTextBox" readOnly="true"></input>
							</div>
							<div class="col-md-2">
								<label id="lblProdName" class="namelabel" style="background-color:#dcdada94; width: 100%; height: 56%;margin-top: 25px;
    							text-align: center;"></label>
							</div>
							<div class="col-md-2">
								<label>Amount:</label>
								<input id="txtAmount" type="text" class="decimal-places-amt numberField" ></input>
							</div>
							<div class="col-md-2">
								<input id="btnAdd" type="button" class="btn btn-primary center-block" value="Add" onclick="return funAddRow()" style="color:#000; margin-top: 24px;"></input>
							</div>				
						</div>
						<br>
						<div style="background-color: #fbfafa; display: block; height: 250px; width:66%; overflow-x: hidden; overflow-y: scroll;">
							<table id="tblProdDet" style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
									class="transTablex col4-center">
								<tr style="background-color: #c0c0c0; ">
									<td><label style="width:50%">Product Code</label></td>
									<td><label>Product Name</label></td>
									<td><label style="margin-left: 60%;">Amount</label></td>
									<td><label>Delete</label></td>
								</tr>
							</table>
						</div>
			</div>
			<div id="tab4" class="tab_content">
				<br><br>
						<div class="row transTablex" style="overflow:hidden;">
							<div class="col-md-2">
								<label>Tax Code</label>
								<input id="txtTaxCode" ondblclick="funHelp('taxmaster')" type="text" Class="searchTextBox"  readOnly="true"></input>
							</div>
							<div class="col-md-2">
								<label>Tax Description</label>
								<input id="txtTaxDesc" type="text" readonly="readonly" ></input>
							</div>
							<div class="col-md-2">	
								<input id="btnTaxAdd" type="button" value="Add" class="btn btn-primary center-block" onclick="return funAddRowTax()" style="color:#000; margin-top: 24px;"></input>
							</div>
						</div>
						<br>
						<div style="background-color: #fbfafa; display: block; height: 250px; width: 66%; overflow-x: hidden; overflow-y: scroll;">
							<table id="tblPartyTax" style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
										class="transTablex col3-center">
								<!-- <table class="masterTable"  id="tblPartyTax" style="width:80%" > -->
								<tr style="background-color: #c0c0c0; width:10%">
									<td><label>Tax Code</label></td>
									<td><label>Tax Description</label></td>
									<td><label>Delete</label></td>
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
											name="listProdAtt[${status.index}].strAVCode"
											value="${prodAtt.strAVCode}" readonly="readonly" /></td>
										<td><input type="button" value="Delete"
											onClick="funDeleteRowForAttribute(this)" class="deletebutton"></td>
									</tr>
								</c:forEach> --%>
							</table>
					</div>
				</div>
			</div>
		</div>
		<br>
		<div class="center" style="margin-right:34%;">
			<a href="#"><button class="btn btn-primary center-block" id="formsubmit" value="Submit" onclick="return funValidateFields()" 
				>Submit</button></a>&nbsp;
			<a href="#"><button class="btn btn-primary center-block"  value="reset" onclick=" funResetFields()"
				>Reset</button></a>
		</div>
		<br>
		<s:input id="hidDebtorCode" type="hidden" path="strDebtorCode" />	
	<br><br>
</s:form>
</div>
<script type="text/javascript">
		funApplyNumberValidation();
	</script>
</body>
</html>