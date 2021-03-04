<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<meta http-equiv="X-UA-Compatible" content="IE=8">
<title>Sub Contractor Master</title>
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
	
	
	//Textfiled On blur geting data
	$(function() {
		
		$('#txtPartyCode').blur(function() {
			var code = $('#txtPartyCode').val();
			if(code.trim().length > 0 && code !="?" && code !="/")
			{
				funSetSubContractor(code);
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
		
		function funValidateFields()
		{
			var flg=true;
			if($("#txtPartyName").val().trim()=="")
			{
				alert("Please Enter Sub Contractor Name");
				$("#txtPartyName").focus();
				return false;
			}
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
	
		function funSetSubContractor(code)
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
							$("#txtGSTNo").val(response.strGSTNo);
							$("#txtPropCode").val(response.strPropCode);
							
							$("#txtPartyName").focus();
							
							funSetCustomerTaxDtl(code);
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
			gurl=getContextPath()+"/loadSubContractorTaxDtl.html?partyCode=";
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
		        	if('Invalid Code' == response.strProdCode)
		        	{
		        		$("#txtProdCode").val("");
			        	$("#lblProdName").text("");
			        	alert("Invalid Product Code");
			            $("#txtProdCode").focus();
		        	}
		        	else
		        	{
		        		$("#txtProdCode").val(response.strProdCode);
			        	$("#lblProdName").text(response.strProdName);
				        posItemCode=response.strPartNo;
				        $("#txtAmount").focus();
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
		
		function funSetData(code)
		{
			switch (fieldName) 
			{		   
			   case 'subContractor':
				   funSetSubContractor(code);
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
				        		$("#txtTaxDesc").val('');
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
		    row.insertCell(0).innerHTML= "<input name=\"listBomDtlModel["+(rowCount)+"].strProdCode\" readonly=\"readonly\" class=\"Box\" size=\"13%\" id=\"txtProdCode."+(rowCount)+"\" value="+prodCode+">";		    
		    row.insertCell(1).innerHTML= "<input name=\"listBomDtlModel["+(rowCount)+"].strProdName\" readonly=\"readonly\" class=\"Box\" size=\"40%\" id=\"txtProdName."+(rowCount)+"\" value='"+itemName+"'/>";
		    row.insertCell(2).innerHTML= "<input name=\"listBomDtlModel["+(rowCount)+"].dblAmount\" id=\"txtAmount."+(rowCount)+"\" required = \"required\" style=\"text-align: right;\" size=\"14%\" class=\"decimal-places-amt\" value="+amount+">";
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
		    row.insertCell(0).innerHTML= "<input class=\"Box\" size=\"16%\" name=\"listclsPartyTaxIndicatorDtlModel["+(rowCount-1)+"].strTaxCode\" id=\"txtTaxCode."+(rowCount-1)+"\" value='"+taxCode+"'>";
		    row.insertCell(1).innerHTML= "<input class=\"Box\" size=\"35%\" name=\"listclsPartyTaxIndicatorDtlModel["+(rowCount-1)+"].strTaxDesc\" id=\"txtTaxDesc."+(rowCount-1)+"\" value='"+taxDesc+"'>";
		    row.insertCell(2).innerHTML= '<input type="button" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRowForTax(this)">';		    
		     funResetTaxField()
		    return false;
		}
		
		
		function funAddRowTaxForUpdate(taxCode,taxDesc)
		{   		    		    
		    var table = document.getElementById("tblPartyTax");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    row.insertCell(0).innerHTML= "<input class=\"Box\" size=\"15%\" name=\"listclsPartyTaxIndicatorDtlModel["+(rowCount-1)+"].strTaxCode\" id=\"txtTaxCode."+(rowCount-1)+"\" value='"+taxCode+"'>";
		    row.insertCell(1).innerHTML= "<input class=\"Box\" size=\"22%\" name=\"listclsPartyTaxIndicatorDtlModel["+(rowCount-1)+"].strTaxDesc\" id=\"txtTaxDesc."+(rowCount-1)+"\" value='"+taxDesc+"'>";
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
			$('a#baseUrl').click(function() 
			{
				if($("#txtPartyCode").val().trim()=="")
				{
					alert("Please Select Sub Contractor Code");
					return false;
				}
				 window.open('attachDoc.html?transName=frmSubContractorMaster.jsp&formName= Customer Master&code='+$('#txtPartyCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
              });
			
			
			$('#bodyCustomerMaster').keydown(function(e) {
				if(e.which == 116){
					resetForms('CustomermasterForm');
					funResetFields();
				}
			});
			
			
			$('#txtPartyCode').blur(function() {
					var code = $('#txtPartyCode').val();
					if (code.trim().length > 0 && code !="?" && code !="/") {
						funSetCustomer(code);
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

	</script>
</head>
<body  id="bodySubContractorMaster">
	<div class="container">
		<label id="formHeading">Sub Contractor Master</label>
			<s:form name="SubContractorMasterForm" method="POST" action="saveSubContractorMaster.html?saddr=${urlHits}">	

		<div style="border: 0px solid black;">
			<div id="tab_container" style="margin-top:10px; overflow:hidden;">
				<ul class="tabs">
					<li class="active" data-state="tab1">General</li>
					<li data-state="tab2">Address</li>
					<li data-state="tab3">Products</li>
					<li data-state="tab4">Tax</li>
				</ul>
				<br/><br/>
				<div id="tab1" class="tab_content">
					<div class="row masterTable">
						 <div class="col-md-12"><p style="margin:10px 0px;">Attatch Documents</p></div>
						<div class="col-md-2">
							<label>Sub Contractor Code:</label><br>
							<s:input type="text" id="txtPartyCode" name="txtPartyCode"  path="strPCode" ondblclick="funHelp('subContractor')" cssClass="searchTextBox"/>
						</div>
						<div class="col-md-2">
							<label>Finance Code:</label><br>
							<s:input id="txtManualCode" name="txtManualCode" path="strManualCode" />						
						</div>
						<div class="col-md-2">
							<label>Name:</label><br>
							<s:input type="text" id="txtPartyName" autocomplete="off" name="txtPartyName" path="strPName" cssStyle="text-transform: uppercase;" required="true"/>						
						</div>
						<div class="col-md-2">
							<label>Tel No:</label><br>
								<s:input  type="text"   id="txtPhone" name="txtPhone" path="strPhone" />						
						</div>
						<div class="col-md-2">
							<label>Mobile No:</label><br>
								<!-- pattern="[789][0-9]{9}" -->
					        	<s:input  type="text" pattern="[0-9]{10,10}"  maxlength="11"  placeholder="Enter Valid MobileNo." id="txtMobile" name="txtMobile" path="strMobile"/>
						</div><div class="col-md-2"></div>
						<div class="col-md-2">
							<label>Fax:</label><br>
								<s:input id="txtFax" name="txtFax" path="strFax"/>
						</div>
						<div class="col-md-2">
							<label>Contact Person:</label><br>
								<s:input id="txtContact" name="txtContact" path="strContact" autocomplete="off" cssStyle="text-transform: uppercase;" />
						</div>
						<div class="col-md-2">
							<label>Email :</label><br>
								<s:input  type="text" placeholder="name@email.com" id="txtEmail" name="txtEmail" path="strEmail" />
						</div>
						<div class="col-md-2">
							<label>Bank Name:</label><br>
								<s:input  id="txtBankName" name="txtBankName" path="strBankName" autocomplete="off" cssStyle="text-transform: uppercase;"/>
						</div>
						<div class="col-md-2">
							<label>Bank Address Line 1:</label><br>
								<s:input  id="txtBankAdd1" name="txtBankAdd1" path="strBankAdd1"  cssStyle="text-transform: uppercase;"/>
						</div><div class="col-md-2"></div>
						<div class="col-md-2">
							<label>Bank Address Line 2 :</label><br>
								<s:input id="txtBankAdd2"  name="txtBankAdd2" path="strBankAdd2" cssStyle="text-transform: uppercase;" />
						</div>
						<div class="col-md-2">
							<label>Bank Account No :</label><br>
								<s:input id="txtBankAccountNo" name="txtBankAccountNo" path="strBankAccountNo" />
						</div>
						<div class="col-md-2">
							<label>ABA No :</label><br>
								<s:input id="txtBankABANo" name="txtBankABANo" path="strBankABANo" />
						</div>
						<div class="col-md-2">
							<label>IBAN No :</label><br>
								<s:input id="txtIbanNo" name="txtIbanNo" path="strIBANNo"/>
						</div>
						<div class="col-md-2">
							<label>Bank Swift Code :</label><br>
								<s:input id="txtSwiftCode" name="txtSwiftCode" path="strSwiftCode" />
						</div><div class="col-md-2"></div>
						<div class="col-md-2">
							<label>Tax No. 1 :</label><br>
								<s:input id="txtTaxNo1" name="txtTaxNo1" path="strTaxNo1" />
						</div>
						<div class="col-md-2">
							<label>Tax No. 2 :</label><br>
								<s:input id="txtTaxNo2" name="txtTaxNo2" path="strTaxNo2"/>
						</div>
						<div class="col-md-2">
							<label>CST No/GST No:</label><br>
								<s:input id="txtCst" name="txtCst" path="strCST" />
						</div>
						<div class="col-md-2">
							<label>VAT:</label><br>
								<s:input id="txtVat" name="txtVat" path="strVAT"/>
						</div>
						<div class="col-md-2">
							<s:label path="strExcise">Excise No.</s:label><br>
								<s:input id="txtExcise" name="txtExcise" path="strExcise" />
						</div><div class="col-md-2"></div>
						<div class="col-md-2">
							<s:label path="strServiceTax" >Service Tax No.</s:label><br>
								<s:input id="txtServiceTax" name="txtServiceTax" path="strServiceTax" />
						</div>
						<div class="col-md-2">
							<s:label path="strPartyType">Sub Contractor Type</s:label><br>
								<s:select id="cmbPartyType" name="cmbPartyType" path="strPartyType" items="${typeList}" style="width:80%;"/>
						</div>
						<div class="col-md-2">
							<s:label path="strAcCrCode">A/C Creditors Code</s:label><br>
								<s:input id="txtAcCrCode" name="txtAcCrCode" path="strAcCrCode"/>
						</div>
						<div class="col-md-2">
							<label>Credit Days</label><br>
								<s:input id="txtCreditDays" name="txtCreditDays" path="intCreditDays" />
						</div>
						<div class="col-md-2">
							<label>Credit Limit</label><br>
								<s:input id="txtCreditLimit" name="txtCreditLimit" path="dblCreditLimit"/>
						</div><div class="col-md-2"></div>
						<div class="col-md-2">
							<label>Registration No</label><br>
								<s:input id="txtRegistration" name="txtRegistration" path="strRegistration" />
						</div>
						<div class="col-md-2">
							<label>Range</label><br>
								<s:input id="txtRange" name="txtRange" path="strRange"/>
						</div>
						<div class="col-md-2">
							<s:label path="strDivision" >Division</s:label><br>
								<s:input id="txtDivision" name="txtDivision" path="strDivision" />
						</div>
						<div class="col-md-2">
							<s:label path="strCommissionerate" >Commissionerate</s:label><br>
								<s:input id="txtCommissionerate" name="txtCommissionerate" path="strCommissionerate"  />
						</div>
						 <!-- problem -->
						<div class="col-md-2">
							<s:label path="strCategory" >Category</s:label><br>
								<s:select id="cmbCategory" name="cmbCategory" path="strCategory" items="${categoryList}"/>
						</div><div class="col-md-2"></div>
						<div class="col-md-2">
							<s:label path="strExcisable" >Party Indicator</s:label><br>
								<s:select id="cmbExcisable" name="cmbExcisable" path="strExcisable" items="${partyIndicatorList}"  />
						</div>
						<div class="col-md-2">
							<label>GST No</label><br>
								<s:input id="txtGSTNo" name="txtGSTNo" path="strGSTNo" />
						</div>
						<div class="col-md-2">
							<label>Property Code</label><br>
								<s:input path="strPropCode" id="txtPropCode" ondblclick="funHelp('property');" cssClass="searchTextBox" />
						</div>
						<div class="col-md-2">
							<label id="lblPropName" style="background-color:#dcdada94; width: 100%; height: 52%; margin-top: 26px; text-align:   center;"
							></label>
						</div>
					</div>
				</div>			
				<div id="tab2" class="tab_content">
					<div class="row masterTable">
						 <div class="col-md-12"><p style="margin:10px 0px;">Main Address</p></div>
							<div class="col-md-2">
								<s:label path="strMAdd1">Address Line 1</s:label><br>
									<s:input type="text" cssStyle="text-transform: uppercase;" id="txtMainAdd1" name="txtMainAdd1" path="strMAdd1"/>
							</div>
								<div class="col-md-2">
									<s:label path="strMAdd2">Address Line 2</s:label><br>
										<s:input type="text" cssStyle="text-transform: uppercase;" id="txtMainAdd2" name="txtMainAdd2" path="strMAdd2"/>
								</div>
								<div class="col-md-2">
									<s:label path="strMCity">City</s:label><br>
										<s:input type="text" id="txtMainCity" cssStyle="text-transform: uppercase;" name="txtMainCity" path="strMCity"  />
								</div>
								<div class="col-md-2">
									<s:label path="strMState">State</s:label><br>
										<s:input type="text"  id="txtMainState" cssStyle="text-transform: uppercase;" name="txtMainState" path="strMState"  />
								</div>
								<div class="col-md-4"></div>
								<div class="col-md-2">
								   <s:label path="strMCountry">Country</s:label><br>
									<s:input type="text"  id="txtMainCountry" name="txtMainCountry" cssStyle="text-transform: uppercase;" path="strMCountry" />
								</div>
								<div class="col-md-2">
								  <s:label path="strMPin">Pin</s:label><br>
									<s:input pattern="[0-9]{6}" id="txtMainPin" name="txtMainPin" path="strMPin" />
								</div>
								<div class="col-md-12"><p style="margin:10px 0px;">Billing Address</p></div>
								<div class="col-md-2">
								  <s:label path="strBAdd1">Address Line 1</s:label><br>
									<s:input type="text"  cssStyle="text-transform: uppercase;" id="txtBillAdd1" name="txtBillAdd1" path="strBAdd1"/>
								</div>
								<div class="col-md-2">
									<s:label path="strBAdd2">Address Line 2</s:label><br>
									<s:input type="text" cssStyle="text-transform: uppercase;" id="txtBillAdd2" name="txtBillAdd2" path="strBAdd2"/>
								</div>
								<div class="col-md-2">
									<s:label path="strBCity">City</s:label><br>
									<s:input  type="text" id="txtBillCity" name="txtBillCity" cssStyle="text-transform: uppercase;" path="strBCity" />
								</div>
								<div class="col-md-2">
									<s:label path="strBState">State</s:label><br>
									<s:input  type="text" id="txtBillState" name="txtBillState" cssStyle="text-transform: uppercase;" path="strBState"  />
								</div>
								<div class="col-md-4"></div>
								<div class="col-md-2">
									<s:label path="strBCountry">Country</s:label><br>
									<s:input  type="text" id="txtBillCountry" name="txtBillCountry" cssStyle="text-transform: uppercase;" path="strBCountry"  />
								</div>
								<div class="col-md-2">
									<s:label path="strBPin">Pin</s:label><br>
									<s:input pattern="[0-9]{6}" id="txtBillPin" name="txtBillPin" path="strBPin" />
								</div>
								<div class="col-md-12"><p style="margin:10px 0px;">Shipping Address</p></div>
								<div class="col-md-2">
									<s:label path="">Same as Billing Address</s:label><br>
									<s:checkbox   id="chkShipAdd" name="chkShipAdd" path="" value="" onclick="funSetAdd()"  />
								</div>
								<div class="col-md-2">
									<s:label path="strSAdd1">Address Line 1</s:label><br>
									<s:input  type="text" cssStyle="text-transform: uppercase;" id="txtShipAdd1" name="txtShipAdd1" path="strSAdd1" />
								</div>
								<div class="col-md-2">
									<s:label path="strSAdd2">Address Line 2</s:label><br>
									<s:input  type="text" cssStyle="text-transform: uppercase;" id="txtShipAdd2" name="txtShipAdd2" path="strSAdd2"/>
								</div>
								<div class="col-md-2">
									<s:label path="strSCity">City</s:label><br>
									<s:input  type="text" id="txtShipCity" name="txtShipCity"  cssStyle="text-transform: uppercase;" path="strSCity" />
								</div>
								<div class="col-md-4"></div>
								<div class="col-md-2">
									<s:label path="strSState"> State</s:label><br>
									<s:input  type="text" id="txtShipState" name="txtShipState" cssStyle="text-transform: uppercase;" path="strSState"  />
								</div>
								
								<div class="col-md-2">
									<s:label path="strSCountry">Country</s:label><br>
									<s:input  type="text" id="txtShipCountry" name="txtShipCountry" cssStyle="text-transform: uppercase;" path="strSCountry"/>
								</div>
								<div class="col-md-2">
									<s:label path="strSPin"> Pin</s:label><br>
									<s:input pattern="[0-9]{6}" id="txtShipPin" name="txtShipPin" path="strSPin"/>
								</div>
					   		</div>
					  </div>
					<div id="tab3" class="tab_content">
						<!-- Kindly change funAddRow  So that it cnnot add products -->
						<div class="row transTablex">
							<div class="col-md-5">
								<div class="row">
									<div class="col-md-5">
										<label>Product Code:</label>
										<input id="txtProdCode" ondblclick="funHelp('productmaster')" type="text" cssClass="searchTextBox" />
									</div>
									<div class="col-md-6">
										<label id="lblProdName" class="namelabel"  style="background-color:#dcdada94; width: 100%; height: 54%; margin-top:24px; padding:2px;"></label>
									</div>
								</div>
							</div>
							<div class="col-md-5">
								<div class="row">
									<div class="col-md-5">
										<label>Amount:</label>
										<input id="txtAmount" type="text" class="decimal-places-amt numberField" ></input>
									</div>
									<div class="col-md-7">
										<input style="margin-top: 19px;" id="btnAdd" type="button" class="btn btn-primary center-block" value="Add" onclick="return funAddRow()"></input>
									</div>
								</div>
							</div>
						</div><br>
						<div style="display: block; height: 250px;width: 60%;overflow-x: hidden; overflow-y: scroll;background: #fbfafa;">
							<table id="tblProdDet"
									style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
									class="transTablex col4-center">
								<tr style="background: #c0c0c0;">
									<td style="border: 1px white solid;width:10%"><label>Product Code</label></td>
									<td style="border: 1px  white solid;width:30%"><label>Product Name</label></td>
									<td style="border: 1px  white solid;width:10%"><label>Amount</label></td>
									<td style="border: 1px  white solid;width:10%"><label>Delete</label></td>
								</tr>
							</table>
						</div>
					</div>
					<div id="tab4" class="tab_content">
						<div class="row transTablex">
							<div class="col-md-2">
								<label>Tax Code:</label>
								<input id="txtTaxCode" ondblclick="funHelp('taxmaster')" Class="searchTextBox" ></input>
							</div>
							<div class="col-md-2">
								<label>Tax Description:</label>
								<input id="txtTaxDesc" readonly="readonly" type="text"></input>
							</div>
							<div class="col-md-3">
								<input style="margin-top: 21px;" id="btnTaxAdd" type="button" value="Add"  class="btn btn-primary center-block" onclick="return funAddRowTax()"></input>
							</div>
							<div class="col-md-3"></div>
						</div><br>
						<div style="border: 1px solid #ccc; display: block; width: 50%; height: 250px; overflow-x: hidden; overflow-y: scroll; background:#fbfafa;">
							<table id="tblPartyTax" style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
									class="transTablex col3-center">
								<!-- <table class="masterTable"  id="tblPartyTax" style="width:80%" > -->
								<tr style="background:#c0c0c0;">
									<td style="border: 1px white solid;width:10%"><label>Tax Code</label></td>
									<td style="border: 1px  white solid;width:20%"><label>Tax Description</label></td>
									<td style="border: 1px  white solid;width:10%"><label>Delete</label></td>
								</tr>
								<%-- <c:forEach items="${command.listProdAtt}" var="prodAtt"
										varStatus="status">
								<tr>
									<td><input name="listProdAtt[${status.index}].strAttCode"
											value="${prodAtt.strAttCode}" readonly="readonly" /></td>
									<td><input name="listProdAtt[${status.index}].strAttName"
											value="${prodAtt.strAttName}" readonly="readonly" /></td>
									<td><input name="listProdAtt[${status.index}].dblAttValue"
											value="${prodAtt.dblAttValue}" /></td>
									<td><input type="hidden" name="listProdAtt[${status.index}].strAVCode"
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
		<div class="center" style="margin-right: 35%;">
			<a href="#"><button class="btn btn-primary center-block" id="formsubmit" value="Submit" onclick="return funValidateFields()" 
				class="form_button">Submit</button></a> &nbsp;
			<a href="#"><button class="btn btn-primary center-block" value="Reset" onclick="funResetField()"
				class="form_button">Reset</button></a>
		</div>
	</s:form>
	</div>
		<script type="text/javascript">
			funApplyNumberValidation();
		</script>
</body>
</html>