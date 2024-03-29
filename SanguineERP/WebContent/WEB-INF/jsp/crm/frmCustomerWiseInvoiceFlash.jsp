
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<meta http-equiv="X-UA-Compatible" content="IE=8">

		
<title>Insert title here</title>

<script type="text/javascript">
		var invoceFlashData,maxQuantityDecimalPlaceLimit=2,frmDte1="",toDte1="";
		
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
					
					var locCode='<%=session.getAttribute("locationCode").toString()%>';
					funSetLocation(locCode);
					var custCode='${custCode}'; 
					if(custCode!="Without DrillDown")
					{
						frmDte1='${fromDate}';
						toDte1='${toDate}';	
						$('#txtFromDate').val(frmDte1);
						$('#txtToDate').val(toDte1);
						$("#txtLocCode").val('${locCode}');
						$("#txtCustCode").val(custCode);
						$("#cmbSettlement").val('${settleCode}');
						$("#cmbCurrency").val('${currencyCode}');
						funSetLocation('${locCode}');
						funSetCuster(custCode);
						funOnExecuteBtn('divInvoiceWise');
					}
					
						
					
					
					
					
					$(document).ajaxStart(function()
							{
							    $("#wait").css("display","block");
							});
							$(document).ajaxComplete(function()
							{
								$("#wait").css("display","none");
							});
		
				});
		
		$(function() 
				{
					
					
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
				        
				 case 'custMaster' :
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
			        			$("#strCustCode").val('');
			        			$("#strCustCode").focus();
			        		}else{			   
			        			$("#txtCustCode").val(response.strPCode);
								$("#lblCustName").text(response.strPName);
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
				
				$(document).ajaxStart(function()
				{
				    $("#wait").css("display","block");
				});
				$(document).ajaxComplete(function()
				{
					$("#wait").css("display","none");
				});
			});
		 	
		
			
			

			function showTable()
			{
				var optInit = getOptionsFromForm();
			    $("#Pagination").pagination(invoceFlashData.length, optInit);	
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
			
			
			
			function pageselectCallback(page_index, jq)
			{
			    // Get number of elements per pagionation page from form
			    var max_elem = Math.min((page_index+1) * items_per_page, invoceFlashData.length);
			    var newcontent="";
			  		    	
				   	newcontent = '<table id="tblInvoiceFlash" class="transTablex" style="width: 100%;font-size:11px;font-weight: bold;"><tr bgcolor="#75c0ff"><td id="labld1" size="10%">Invoice Code</td><td id="labld2"> Date</td><td id="labld3"> Customer Name</td>	<td id="labld4"> Against </td> <td id="labld5"> Vehicle No </td>	<td id="labld6"> Excisable </td> <td id="labld7"> SubTotal</td><td id="labld8"> Tax Amount</td><td id="labld9"> Grand Toal</td></tr>';
				   	// Iterate through a selection of the content and build an HTML string
				    for(var i=page_index*items_per_page;i<max_elem;i++)
				    {
				        newcontent += '<tr><td><a id="stkLedgerUrl.'+i+'" href="#" onclick="funClick(this);">'+invoceFlashData[i].strInvCode+'</a></td>';
				        newcontent += '<td>'+invoceFlashData[i].dteInvDate+'</td>';
				        newcontent += '<td>'+invoceFlashData[i].strCustName+'</td>';
				        newcontent += '<td>'+invoceFlashData[i].strAgainst+'</td>';
				        newcontent += '<td>'+invoceFlashData[i].strVehNo+'</td>';
				        newcontent += '<td align="Center">'+invoceFlashData[i].strExciseable+'</td>';
				        newcontent += '<td align="right">'+parseFloat(invoceFlashData[i].dblSubTotalAmt).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+parseFloat(invoceFlashData[i].dblTaxAmt).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				        newcontent += '<td align="right">'+parseFloat(invoceFlashData[i].dblTotalAmt).toFixed(maxQuantityDecimalPlaceLimit)+'</td>';
				    }
			    
			    newcontent += '</table>';
			    // Replace old content with new content
			   
			    $('#Searchresult').html(newcontent);
			   
			    // Prevent click eventpropagation
			    return false;
			}
			
			function funClick(obj,dteObj)
			{
				var code=document.getElementById(""+obj.id+"").innerHTML;
				window.open(getContextPath()+"/rptInvoiceSlipFromat2.html?rptInvCode="+code,'_blank');
				window.open(getContextPath()+"/rptInvoiceSlipNonExcisableFromat2.html?rptInvCode="+code,'_blank');
			}
			
			
			
			$(document).ready(function () 
			 {			 

			 });
			
			
		
			
			
		
			
			function funGetTotalValue(dblTotalValue,dblSubTotalValue,dblTaxTotalValue,dblExtraCharges)
			{
				$("#txtTotValue").val(parseFloat(dblTotalValue).toFixed(maxQuantityDecimalPlaceLimit));
				$("#txtSubTotValue").val(parseFloat(dblSubTotalValue).toFixed(maxQuantityDecimalPlaceLimit));
				$("#txtTaxTotValue").val(parseFloat(dblTaxTotalValue).toFixed(maxQuantityDecimalPlaceLimit));
				$("#txTotExtraValue").val(parseFloat(dblExtraCharges).toFixed(maxQuantityDecimalPlaceLimit));

			}
			
		
			
			function funOpenInvoiceFormat()
			{
				var invPath="";
					invoiceformat='<%=session.getAttribute("invoieFormat").toString()%>';
					if(invoiceformat=="Format 1")
						{
							invPath="openRptInvoiceSlip";
							
						}
					else if(invoiceformat=="Format 2")
						{
							invPath="rptInvoiceSlipFromat2";
						}
					else if(invoiceformat=="Format 5")
						{
							invPath="rptInvoiceSlipFormat5Report";
						}
					else if(invoiceformat=="RetailNonGSTA4"){
						 invPath="openRptInvoiceRetailNonGSTReport";
						}
					else if("Format 6")
						{
							invPath="rptInvoiceSlipFormat6Report";
						}
						else
					    {
							invPath="rptInvoiceSlipFormat6Report";
					    }
				return invPath;
			}
			
			function funApplyNumberValidation(){
				$(".numeric").numeric();
				$(".integer").numeric(false, function() { alert("Integers only"); this.value = ""; this.focus(); });
				$(".positive").numeric({ negative: false }, function() { alert("No negative values"); this.value = ""; this.focus(); });
				$(".positive-integer").numeric({ decimal: false, negative: false }, function() { alert("Positive integers only"); this.value = ""; this.focus(); });
			    $(".decimal-places").numeric({ decimalPlaces: maxQuantityDecimalPlaceLimit, negative: false });
			    $(".decimal-places-amt").numeric({ decimalPlaces: maxAmountDecimalPlaceLimit, negative: false });
			}
			
		
			
			
			function funOnExecuteBtn( divId)
			{
				
				var settCode=$('#cmbSettlement').val();
				var locCode=$('#txtLocCode').val();
				var custCode=$('#txtCustCode').val();
				var currencyCode=$('#cmbCurrency').val();
				var searchUrl=getContextPath()+"/loadInvoiceFlash.html?settlementcode="+settCode+"&frmDte="+frmDte1+"&toDte="+toDte1+"&locCode="+locCode+"&custCode="+custCode+"&currencyCode="+currencyCode;
			
				$.ajax({
				        type: "GET",
				        url: searchUrl,
					    dataType: "json",
					    async:false,
					    success: function(response)
					    {
					    	funBillWiseProductDetail(response[0])
					    	document.getElementById("txtSubTotValue").style.visibility = "visible"; 
							document.getElementById("txtTaxTotValue").style.visibility = "visible";
							funGetTotalValue(response[1],response[2],response[3],response[4]);
					    	
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
				return false;
			}
			
			function funBillWiseProductDetail(ProdDtl)
			{
				$('#tblInvoiceDet tbody').empty();
				for(var i=0;i<ProdDtl.length;i++)
				{
				 var data=ProdDtl[i];
				 
				data.dblSubTotalAmt=parseFloat(data.dblSubTotalAmt).toFixed(maxQuantityDecimalPlaceLimit);
				data.dblTaxAmt=parseFloat(data.dblTaxAmt).toFixed(maxQuantityDecimalPlaceLimit);
				data.dblTotalAmt=parseFloat(data.dblTotalAmt).toFixed(3);
				var invoiceUrl=funOpenInvoiceFormat();
			    var table = document.getElementById("tblInvoiceDet");
			    var rowCount = table.rows.length;
			    var row = table.insertRow(rowCount);
			    row.insertCell(0).innerHTML= "<a  name=\"StrInvCode["+(rowCount)+"]\"  href="+invoiceUrl+"\.html?rptInvCode="+data.strInvCode+"&rptInvDate="+data.dteInvDate+"\ target=\"_blank\"  id=\"StrInvCode."+(rowCount)+"\" >"+data.strInvCode+"</a>";		    
			    row.insertCell(1).innerHTML= "<input name=\"DteInvDate["+(rowCount)+"]\" readonly=\"readonly\" class=\"Box\" size=\"15%\" id=\"DteInvDate."+(rowCount)+"\" value='"+data.dteInvDate+"'>";
			    row.insertCell(2).innerHTML= "<input name=\"strSerialNo["+(rowCount)+"]\" readonly=\"readonly\" class=\"Box\" size=\"15%\" id=\"strSerialNo."+(rowCount)+"\" value='"+data.strSerialNo+"'>";
			    row.insertCell(3).innerHTML= "<input name=\"CustomerName["+(rowCount)+"]\" readonly=\"readonly\" class=\"Box\" size=\"30%\" id=\"CustomerName."+(rowCount)+"\" value='"+data.strCustName+"'>";
			    row.insertCell(4).innerHTML= "<input name=\"strSettleDesc["+(rowCount)+"]\" id=\"strSettleDesc."+(rowCount)+"\" readonly=\"readonly\"   size=\"14%\" class=\"Box\" value="+data.strSettleDesc+">";
			    row.insertCell(5).innerHTML= "<input name=\"StrAgainst["+(rowCount)+"]\" readonly=\"readonly\" class=\"Box\" size=\"25%\" id=\"StrAgainst."+(rowCount)+"\" value='"+data.strAgainst+"'>";
			    row.insertCell(6).innerHTML= "<input name=\"StrVehNo["+(rowCount)+"]\" id=\"StrVehNo."+(rowCount)+"\" readonly=\"readonly\" size=\"14%\" class=\"Box\" value="+data.strVehNo+">";
			    row.insertCell(7).innerHTML= "<input name=\"StrCurrency["+(rowCount)+"]\" id=\"StrCurrency."+(rowCount)+"\" readonly=\"readonly\" size=\"10%\" class=\"Box\" value="+data.strCurrency+">";
			    row.insertCell(8).innerHTML= "<input name=\"DblSubTotalAmt["+(rowCount)+"]\" id=\"DblSubTotalAmt."+(rowCount)+"\" readonly=\"readonly\" style=\"text-align: right;\" size=\"12%\" class=\"Box\" value="+data.dblSubTotalAmt+">";
			    row.insertCell(9).innerHTML= "<input name=\"DblTaxAmt["+(rowCount)+"]\" id=\"DblTaxAmt."+(rowCount)+"\" readonly=\"readonly\" style=\"text-align: right;\" size=\"11%\" class=\"Box\" value="+data.dblTaxAmt+">";
			    row.insertCell(10).innerHTML= "<input name=\"DblExtraChargesAmt["+(rowCount)+"]\" id=\"DblExtraChargesAmt."+(rowCount)+"\" readonly=\"readonly\" style=\"text-align: right;\" size=\"11%\" class=\"Box\" value="+data.dblExtraCharges+">";
			    row.insertCell(11).innerHTML= "<input name=\"DblTotalAmt["+(rowCount)+"]\" id=\"DblTotalAmt."+(rowCount)+"\" readonly=\"readonly\" style=\"text-align: right;\" size=\"10%\" class=\"Box\" value="+data.dblTotalAmt+">";
			   
			    
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
		 		var settCode=$('#cmbSettlement').val();
				var locCode=$('#txtLocCode').val();
				if(locCode=="")
					{
					locCode="All";
					}
				var custCode=$('#txtCustCode').val();
				var currencyCode=$('#cmbCurrency').val();
				window.location.href = getContextPath()+"/exportBillWiseInvoiceFlash.html?settlementcode="+settCode+"&frmDte="+frmDte1+"&toDte="+toDte1+"&locCode="+locCode+"&custCode="+custCode+"&currencyCode="+currencyCode;
		 	}
		 	
			function funResetCustomer()
		 	{
				$("#txtCustCode").val("All");
				$("#lblCustName").text("");
				$("#txtProdCode").val("All");
				$("#lblProdName").text("");
		 	}
		 	 
			
			
		</script>
</head>

<body>
	<div class="container">
		<label id="formHeading">Customer Wise Invoice Flash</label>
		<s:form name="Form" method="GET" action="">
			<div class="row transTable">
				<div class="col-md-3">
					<div class="row">
						<div class="col-md-6">
							<label>From Date</label><br>
								<s:input id="txtFromDate" required="required" path=""
						  			name="fromDate" onchange="funChangeFromDate();" cssClass="calenderTextBox" />
						</div>
						<div class="col-md-6">
							<label id="lblToDate">To Date</label>
								<s:input id="txtToDate" name="toDate" path=""
									cssClass="calenderTextBox" onchange="funChangeToDate();"/>
						</div>
					</div>
				</div>
				<div class="col-md-2">			
					<label id="">Settlement</label>
					<s:select id="cmbSettlement" path="strSettlementCode" items="${settlementList}">
			    	</s:select>	
			    </div>
			    	<div class="col-md-6"></div>
			  	<div class="col-md-2">
			 		<label>Location Code</label>
					<s:input type="text" id="txtLocCode" path="strLocCode"
						cssClass="searchTextBox" ondblclick="funHelp('locationmaster');" />
				</div>
				<div class="col-md-3">	
					<label id="lblLocName" style="background-color:#dcdada94; width: 100%; height: 42%; margin-top:24px; padding:2px;"></label>
				</div>
					<div class="col-md-6"></div>
				
				<div class="col-md-2">
					<label id="">Customer Code</label>
					<s:input type="text" id="txtCustCode" path="strCustCode"
						cssClass="searchTextBox" ondblclick="funHelp('custMaster');" value="All"/>
				</div>
				<div class="col-md-3"> 
					<label id="lblCustName" style="background-color:#dcdada94; width: 100%; height: 43%; margin-top:24px; padding:2px;"></label>
				</div>
				<div class="col-md-6"></div>
				<div class="col-md-2">	
					<label id="">Currency</label>
					<s:select id="cmbCurrency" path="strCurrencyCode" items="${currencyList}" style="width:80%;">
			         </s:select>
			     </div>
				 </div>
					<p class="center" style="margin-right:63%;">
						<input class="btn btn-primary center-block" id="btnExecute"   type="button"  value="EXECUTE" onclick="funOnExecuteBtn('divInvoiceWise')" />
							
						<input class="btn btn-primary center-block" id="btnExport"   type="button"  value="EXPORT" onclick="funExportReport()"  />
							
						<input class="btn btn-primary center-block" value="RESET"  type="button"  onclick="funResetCustomer()" />
							
					</p>
				
			
				<div id="divInvoiceWise" class="dynamicTableContainer"
						style="height: 400px;">
						<table style="width: 100%; border: #0F0; table-layout: fixed;"
							class="transTablex col15-center">
							<tr bgcolor="#c0c0c0">
								<td width="6%">Invoice Code</td>
								<!--  COl1   -->
								<td width="4.3%">Date</td>
								<!--  COl2   -->
								<td width="4.4%">JV No</td>
								<!--  COl3   -->
								<td width="10%">Customer Name</td>
								<!--  COl4   -->
								<td width="5.4%"> Settement</td>
								<!--  COl5   -->
								<td width="4.2%">Against</td>
								<!-- COl6   -->
								<td width="4.5%">Vehicle No</td>
								<!-- COl7   -->
								<td width="4.5%">Currency</td>  
								<!--  COl8   -->
								<td width="5.8%">SubTotal</td>
								<!--  COl9   -->
								<td width="5.3%">Tax Amount</td>
								<!--  COl10   -->
								<td width="5.3%">Extra Charges</td>
								<!--  COl11   -->
								<td width="5.2%">Grand Total</td>
								<!--COl12   -->
			
							</tr>
						</table>
						<div
							style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 330px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
							<table id="tblInvoiceDet"
								style="width: 100%; border: #0F0; table-layout: fixed;"
								class="transTablex col15-center">
								<tbody>
								<col style="width: 5%">
								<!--  COl1   -->
								<col style="width: 4%">
								<!--  COl2   -->
								<col style="width: 4%">
								<!--  COl3   -->
								<col style="width: 10%">
								<!--  COl4   -->
								<col style="width: 4.3%">
								<!--  COl5   -->
								<col style="width: 4%">
								<!--COl6   -->
								<col style="width: 5.2%">  
								<!--COl7   -->
								<col style="width: 4.2%">
								<!-- COl8   -->
								<col style="width: 5.5%">
								<!--  COl9   -->
								<col style="width: 5%">
								<!--  COl10   -->
								<col style="width: 5%">
								<!--  COl10   -->
								<col style="width: 4.8%">
								<!--  COl11  -->
								</tbody>
							</table>
						</div>
				</div>
					<div id="divValueTotal"
						style="display: block; height: 50px;overflow-x: hidden; overflow-y: hidden;">
						<table id="tblTotalFlash" class="transTablex"
							style="font-size: 11px; font-weight: bold;">
							<tr style="margin-left: 28px">
								<td id="labld26" style="width:48%; text-align:right">Total</td>
								<td id="tdSubTotValue" style="width:13%; align:right">
									<input id="txtSubTotValue" style="width: 100%; text-align: right;" class="Box"></input>
								</td>
								<td id="tdTaxTotValue" style="width:13%; align:right">
									<input id="txtTaxTotValue" style="width: 100%; text-align: right;" class="Box"></input>
								</td>
								<td id="tdTotExtraValue" style="width:14%; align:right">
									<input id="txTotExtraValue" style="width: 100%; text-align: right;" class="Box"></input>
								</td>
								<td id="tdTotValue" style="width:14%; align:right">
									<input id="txtTotValue" style="width: 100%; text-align: right;" class="Box"></input>
								</td>
								
			
							</tr>
						</table>
					</div>
		</s:form>
		</div>
</body>
</html>