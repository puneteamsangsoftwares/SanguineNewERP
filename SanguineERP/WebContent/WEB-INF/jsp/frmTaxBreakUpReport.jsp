<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  	<link rel="stylesheet" type="text/css" href="default.css" />
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Tax BreakUp Report</title>
    <script type="text/javascript">
    function funOnLoad()
	{
	  	var loggedInProperty="${LoggedInProp}";
		var loggedInLocation="${LoggedInLoc}";
		$("#cmbProperty").val(loggedInProperty);
		$("#cmbLocation").val(loggedInLocation);
	}	
    
    function funChangeLocationCombo()
	{
		var propCode=$("#cmbProperty").val();
		funFillLocationCombo(propCode);
	}

	function funFillLocationCombo(propCode) 
	{
		var searchUrl = getContextPath() + "/loadLocationForProperty.html?propCode="+ propCode;
		$.ajax({
			type : "GET",
			url : searchUrl,
			dataType : "json",
			success : function(response) {
				var html = '<option value="ALL">ALL</option>';
				$.each(response, function(key, value) {
					html += '<option value="' + value[1] + '">'+value[0]
							+ '</option>';
				});
				html += '</option>';
				$('#cmbLocation').html(html);
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
	
		$(document).ready(function() 
			{
				var startDate="${startDate}";
				var arr = startDate.split("/");
				Dat=arr[0]+"-"+arr[1]+"-"+arr[2];
				$("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
				$("#txtFromDate").datepicker('setDate',Dat);
				$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
				$("#txtToDate").datepicker('setDate', 'today');
				$("#cmbLocation").val("${locationCode}");
			});
		function funHelp(transactionName)
		{
			fieldName=transactionName;
	     //  window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	       window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	    }
		function funSetData(code)
		{
			switch (fieldName) 
			{			   
			   case 'taxmaster':
			      	funSetTax(code);
			    	break;
			   case 'suppcode':
			    	funSetSupplier(code);
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
				        		$("#lblTaxName").text('');
				        		$("#txtTaxCode").focus();
				        	}else{
				        		$("#txtTaxCode").val(response.strTaxCode);
					        	$("#lblTaxName").text(response.strTaxDesc);
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
		
		function funSetSupplier(code) {
			var searchUrl = "";
			searchUrl = getContextPath()
					+ "/loadSupplierMasterData.html?partyCode=" + code;

			$.ajax({
				type : "GET",
				url : searchUrl,
				dataType : "json",
				success : function(response) {
					if ('Invalid Code' == response.strPCode) {
						alert('Invalid Code');
						$("#txtSuppCode").val('');
						$("#lblsuppName").text('');
						$("#txtSuppCode").focus();
					} else {
						$("#txtSuppCode").val(response.strPCode);
						$("#lblsuppName").text(response.strPName);
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

		function funResetFields()
		{
			location.reload(true); 
		}
 </script>
 </head>
<body onload="funOnLoad()">
<div class="container">
		<label id="formHeading">Tax BreakUp Report</label>
	  <s:form action="rptTaxBreakUpReport.html" method="POST" name="frmTaxBreakUpReport" target="_blank">
	
	<br>
	
			<div class="row masterTable">
			       <div class="col-md-2"><label>Property Code</label>
					    <s:select id="cmbProperty" name="propCode" path="strPropertyCode"  cssStyle="width:auto;" onchange="funChangeLocationCombo();">
			    			<s:options items="${listProperty}"/>
			    		</s:select>
					</div>
						
					<div class="col-md-2"><label>Location</label></td>
				        <s:select id="cmbLocation" name="locCode" path="strLocationCode" cssStyle="width:auto;" >
			    			<s:options items="${listLocation}"/>
			    		</s:select>
					</div>
			        <div class="col-md-8"></div>
			        
				    <div class="col-md-2"><label id="lblFromDate">From Date</label>
			            <s:input id="txtFromDate" name="fromDate" path="dtFromDate" cssClass="calenderTextBox" cssStyle="width:70%;"/>
			        	<s:errors path="dtFromDate"></s:errors>
			        </div>
				        
			        <div class="col-md-2"><label id="lblToDate">To Date</label>
			              <s:input id="txtToDate" name="toDate" path="dtToDate" cssClass="calenderTextBox" cssStyle="width:70%;"/>
			        	<s:errors path="dtToDate"></s:errors>
			        </div>
					<div class="col-md-8"></div>
					
				    <div class="col-md-2"><label>Tax Code</label>
					    <s:input type="text" id="txtTaxCode" path="strTaxCode" ondblclick="funHelp('taxmaster')" cssClass="searchTextBox" />
					</div>
					<div class="col-md-2"><br><label id="lblTaxName" style="background-color:#dcdada94; width: 100%; height: 53%;margin-top: 2px; padding: 3px; text-align:center;">All Tax</label>
					</div>
					<div class="col-md-8"></div>
										
					<div class="col-md-2"><label>Supplier Code</label>
					 	<s:input type="text" id="txtSuppCode" path="strSuppCode" ondblclick="funHelp('suppcode')" cssClass="searchTextBox" />
					</div>
					<div class="col-md-2"><br><label id="lblsuppName" style="background-color:#dcdada94; width: 175%; height: 53%;margin-top: 2px; padding: 3px;text-align:center;">All Supplier</label>
					</div>
					<div class="col-md-8"></div>
					
				   <div class="col-md-2"><label>Report Type</label>
					    <s:select id="cmbDocType" path="strDocType" style="width:auto;">
				    		<s:option value="PDF">PDF</s:option>
				    		<s:option value="XLS">EXCEL</s:option>
				    		<s:option value="HTML">HTML</s:option>
				    		<s:option value="CSV">CSV</s:option>
				    	</s:select>
			       </div>
	           </div>
			
			<br>
			<p align="center" style="margin-right: 28%;">
				 <input type="submit" value="Submit" class="btn btn-primary center-block" class="form_button" />
				 &nbsp;
				 <input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields();"/>			     
			</p>
	</s:form>
	</div>
</body>
</html>