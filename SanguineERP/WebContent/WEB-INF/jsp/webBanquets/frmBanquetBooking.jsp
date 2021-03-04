<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>
<style type="text/css">


.label{
    float: left;
    padding-top: 2px;
    position: relative;
    text-align: left;
    vertical-align: middle;
}
.label:after{
 content:"*" ;
color:red    
}


</style>
<script type="text/javascript">

	var fieldName,listServiceRow=0,listEquipRow=0,listStaffRow=0,listItemRow=0,listExternalServiceRow=0;
	var totalTerrAmt = 0.0;
	var gflag;
	var gbookingflag;

	  $(document).ready(function(){		  
		  $(".tab_content").hide();
			$(".tab_content:first").show();
			$("ul.tabs li").click(function() {
				$("ul.tabs li").removeClass("active");
				$(this).addClass("active");
				$(".tab_content").hide();
				var activeTab = $(this).attr("data-state");
				$("#" + activeTab).fadeIn();
			});
			
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
				}
			}%>
			
			
			var message1='';
			<%if (session.getAttribute("notsuccess") != null) {
				if(session.getAttribute("successMessage") != null){%>
					message1='<%=session.getAttribute("successMessage").toString()%>';
					<%
					session.removeAttribute("successMessage");
				}
				boolean test1 = ((Boolean) session.getAttribute("notsuccess")).booleanValue();
				session.removeAttribute("notsuccess");
				if (test1) {
					%>	
					alert(message1);
					<%
				}
			}%>
			

	   });

	$(function() 
	{
	
		
		$('#txtFromTime').timepicker({
	        'timeFormat':'H:i:s'
		});
		$('#txtToTime').timepicker({
	        'timeFormat':'H:i:s'
		});
		
		$('#txtFromTime').timepicker('setTime', new Date());
		$('#txtToTime').timepicker('setTime', new Date());
	    $("#txtBookingDate").datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtBookingDate").datepicker('setDate','todate');
		$("#txtFromDate").datepicker('setDate','todate');
		$("#txtToDate").datepicker('setDate', 'todate');
		
		$('a#baseUrl').click(function() 
		{
			if($("#txtBookingNo").val().trim()=="")
			{
				alert("Please Select Reservation No ");
				return false;
			}
			window.open('attachDoc.html?transName=frmReservation.jsp&formName=Reservation &code='+$('#txtReservationNo').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
		});	
		
		
		
		
		
		
	});
function funCreateNewCustomer(){
		
		window.open("frmCustomerMaster.html", "myhelp", "scrollbars=1,width=500,height=350");
	}
	
	function funHelp(transactionName)
	{
		
		if(transactionName.includes('Booking') || transactionName.includes('QuotationNo')){
			var strcode = $("#cmbAgainst").val();
		if(strcode.includes('Booking')){
			fieldName='BookingNo';	
			transactionName = fieldName;
		}
		else if(strcode.includes('Quotation'))
			{
			fieldName='QuotationNo';
			transactionName = fieldName;
			}
		}
		else
			fieldName = transactionName;
		
	
			window.open("searchform.html?formname="+transactionName+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
			
	}

	
	function funSetData(code){

		switch(fieldName){
		
		    case 'custMaster' : 
		    	funSetCustomer(code);
				break;
			case 'PropertyWiseLocation' : 
				funSetAreaCode(code);
				break;
			case 'functionMaster' : 	
				funSetFunctionCode(code)
				break;
			case 'BillingInstCode' : 
				funSetBillingInstCode(code);
				break;
			case 'FunctionService' : 
				 funSetServiceData(code);
				 break;
			case 'equipmentCode' : 
				 funSetEquipmentName(code);
			     break;
			case 'ItemCode' : 
				 funSetItemData(code);
				 break;
			
			case 'StaffCatCode' : 
				funSetCatData(code);
				 break;
		    case 'StaffCode' : 
				funSetStaffData(code);
				 break;
		   
		    case 'BookingNo' : 
				funSetBookingData(code);
				 break;
				 
		    case 'banquetCode' : 
				funSetBanquetName(code);
				break;	 
		    	
		    case 'ExternalServices' : 
				funSetExternalService(code);
				break;	 
		
		    case 'suppcode' :
		    	funSetVendorName(code);
		    	break;
		    	
		    case 'QuotationNo' :
		    	funSetQuotationData(code);
		    	break;
		    
		} 
	}
	
	function funSetVendorName(code){
	
		gurl=getContextPath()+"/loadPartyMasterData.html?partyCode=";
		$.ajax({
	        type: "GET",
	        url: gurl+code,
	        dataType: "json",
	    
	        success: function(response)
	        {		        	
	        		if('Invalid Code' == response.strPCode){
	        			alert("Invalid Customer Code");
	        			$("#txtVendorCode").val('');
	        			$("#txtVendorCode").focus();
	        			  
	        		}else{
	        			$("#txtVendorCode").val(response.strPCode);
						$("#lblVendorName").text(response.strPName);
						
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
	
	function funSetCustomer(code)
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
	        			$("#txtCustomerCode").val('');
	        			$("#txtCustomerCode").focus();
	        			  
	        		}else{
	        			$("#txtCustomerCode").val(response.strPCode);
						$("#txtCustomerName").val(response.strPName);
						$("#txtMobileNo").val(response.strMobile);
						$("#txtEmailId").val(response.strEmail);
						
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
	
	function funSetAreaCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadLocationMasterData.html?locCode=" + code,
			dataType : "json",
			success : function(response){ 
				if(response.strLocCode=='Invalid Code')
	        	{
	        		alert("Invalid Location Code");
	        		$("#txtCorporateCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtAreaCode").val(response.strLocCode);
	        		$("#lblAreaCode").text(response.strLocName);
	        	}
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
	}
	function funSetBillingInstCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadBillingInstCode.html?billingInstructions=" + code,
			dataType : "json",
			success : function(response){
				$("#txtBillingInstructionCode").val(response.strBillingInstCode);
        	    $("#lblBillingInstDesc").text(response.strBillingInstDesc);
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
	}

	// 
	function funSetStaffCode(code)
	{
			var searchUrl="";
			searchUrl=getContextPath()+"/loadStaffMasterData.html?staffCode="+code;			
			$.ajax({
			        type: "GET",
			        url: searchUrl,
				    dataType: "json",
				    success: function(response)
				    {
				    	$("#txtEventCoordinatorCode").val(code);
				    	$("#lblEventCoordinatorCode").text(response.strStaffName);
				    
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
	
	
	function funSetStaffData(code)
	{
			var searchUrl="";
			searchUrl=getContextPath()+"/loadStaffMasterData.html?staffCode="+code;			
			$.ajax({
			        type: "GET",
			        url: searchUrl,
				    dataType: "json",
				    success: function(response)
				    { 
				    	$("#txtEventCoordinatorCode").val(code);
				    	$("#lblEventCoordinatorCode").text(response.strStaffName);
				    	
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
	
	
	
	
	function funSetFunctionCode(code)
	{
		$("#txtFunctionCode").val(code);
		var searchurl=getContextPath()+ "/loadFunctionMasterData.html?functionCode=" + code;
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",
			success : function(response)
			{ 
				if(response.strFunctionCode=='Invalid Code')
	        	{
	        		alert("Invalid Function Code");
	        		$("#txtFunctionCode").val('');
	        	}
				else
				{
					$("#txtFunctionCode").val(response.strFunctionCode);
	        		$("#lblFunctionName").text(response.strFunctionName);
	        		
	        		funSetServiceData(response.strFunctionCode)
				}

			},
			error : function(jqXHR, exception){
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
	
    function funSetServiceData(Code)
	{
    	funRemAllRows('tblInternalServiceDtl');
		var funcode=$("#txtFunctionCode").val();
		var searchurl=getContextPath()+ "/loadBookingServiceData.html?functionCode=" + funcode ;
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",
			success : function(response)
			{ 
				$.each(response, function(i,item)
	            {
				       funfillServiceRow(response[i][0],response[i][1],response[i][2],'N');
			    });
	        	
			},
			error : function(jqXHR, exception){
				if (jqXHR.status === 0) {
	                alert('Not connect.n Verify Network.');
	            } else if (jqXHR.status == 404) {
	                alert('Requested page not found. [404]');
	            } else if (jq.XHR.status == 500) {
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
	//
	function funSetBookingFunInternalServiceData()
	{
		funRemAllRows('tblInternalServiceDtl');
		var funcode=$("#txtFunctionCode").val();
		var bookCode=$("#txtBookingNo").val();
		var searchurl=getContextPath()+ "/loadBookingFunServiceData.html?functionCode=" + funcode+"&bookingCode="+ bookCode;
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",
			success : function(response)
			{ 
				$.each(response, function(i,item)
	            {
				       funfillServiceRow(response[i][0],response[i][1],response[i][2],response[i][3]);
			    });
	        	
			},
			error : function(jqXHR, exception){
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
	
	//
	function funSetBookingFunExternalServiceData()
	{
		listExternalServiceRow=0;
		funRemAllRows('tblExternalServiceDtl');
		var funcode=$("#txtFunctionCode").val();
		var bookCode=$("#txtBookingNo").val();
		var searchurl=getContextPath()+ "/loadBookingExternalServiceData.html?functionCode=" + funcode+"&bookingCode="+ bookCode;
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",
			success : function(response)
			{ 
				$.each(response, function(i,item)
	            {
					// a.strDocNo,a.strDocName,a.dblDocRate,a.strVendorCode, b.strPName
					funfillExternalServicesRow(response[i][4],response[i][3],response[i][1],response[i][0],response[i][2]);
				       // (vendorName,vendorCode,ServiceName,serviceCode,dblRate)
			    });
	        	
			},
			error : function(jqXHR, exception){
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
	
	function funSetQuotationFunExternalServiceData()
	{
		listExternalServiceRow=0;
		funRemAllRows('tblExternalServiceDtl');
		var funcode=$("#txtFunctionCode").val();
		var bookCode=$("#txtBookingNo").val();
		var searchurl=getContextPath()+ "/loadQuotationExternalServiceData.html?functionCode=" + funcode+"&QuotationCode="+ bookCode;
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",
			success : function(response)
			{ 
				$.each(response, function(i,item)
	            {
					// a.strDocNo,a.strDocName,a.dblDocRate,a.strVendorCode, b.strPName
					funfillExternalServicesRow(response[i][4],response[i][3],response[i][1],response[i][0],response[i][2]);
				       // (vendorName,vendorCode,ServiceName,serviceCode,dblRate)
			    });
	        	
			},
			error : function(jqXHR, exception){
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
	
	function funSetEquipmentName(code){
	
		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadEquipmentName.html?docCode=" + code,
			dataType : "json",
			success : function(response){ 
				
				$("#txtEquipmentCode").val(response.strEquipmentCode);
				$("#lblEquipmentCode").text(response.strEquipmentName);
				funfillEquipmentDtlRow(response.strEquipmentCode,response.strEquipmentName,response.dblEquipmentRate,'1');
	        		
	        	
			},
			error : function(jqXHR, exception){
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
	//
	function funSetCatData(code)
	{
		
			var searchUrl="";
			searchUrl=getContextPath()+"/loadStaffCategeoryMasterData.html?staffCatCode="+code;			
			$.ajax({
			        type: "GET",
			        url: searchUrl,
				    dataType: "json",
				    success: function(response)
				    {
				    	$("#txtStaffCatCode").val(response.strStaffCategeoryCode);
						$("#lblStaffCatCode").text(response.strStaffCategeoryName);
				    	funfillStaffCatRow(response.strStaffCategeoryCode,response.strStaffCategeoryName,'0');
				    	
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


	function funSetItemData(code)
	{
	
		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadItemCode.html?docCode=" + code,
			dataType : "json",
			success : function(response){
				$("#txtItemCode").val(response.strItemCode);
				$("#lblItemCode").text(response.strItemName);
				funfillMenuItemDtlRow(response.strItemCode,response.strItemName,response.dblAmount,'1');
	        		
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
	function funSetBanquetName(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadBanquetName.html?docCode=" + code,
			dataType : "json",
			success : function(response){ 

				if(response.strEquipmentCode=='Invalid Code')
	        	{
	        		alert("Invalid Equipment No");
	        		$("#txtBanquetCode").val('');
	        	}
	        	else
	        	{
	        		
	        		$("#txtBanquetCode").val(response.strBanquetCode);
	        		$("#lblBanquetName").text(response.strBanquetName);
	        		funLoadBanquetRate(response.strBanquetCode);
	        		
	        	}
			},
			error : function(e){

			}
		});
	}
	
	function funSetExternalService(code)
	{
	var vendorName=$("#lblVendorName").text();
		if(vendorName!=''){

			
			$.ajax({
				type : "GET",
				url : getContextPath()+ "/loadServiceMasterData.html?serviceCode="+code,
				dataType : "json",
				success : function(response){
					//$("#txtItemCode").val(response.strItemCode);
					//$("#lblItemCode").text(response.strItemName);
					
					funfillExternalServicesRow(vendorName,$("#txtVendorCode").val(),response.strServiceName,response.strServiceCode,response.dblRate);
		        		
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

		}else{
			alert("First Select The Vendor");
		}
		
	}
	
    var ServiceTotal=0;
	function funfillServiceRow(ServiceCode,ServiceName,Rate,Applicable)
	{
		
		var table = document.getElementById("tblInternalServiceDtl");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
	    row.insertCell(0).innerHTML= "<input  readonly=\"readonly\" class=\"Box\" size=\"15%\" name=\"listSeriveDtl["+(rowCount)+"].strDocNo\"  id=\"txtServiceCode."+(rowCount)+"\" value='"+ServiceCode+"' />";
	    row.insertCell(1).innerHTML= "<input  readonly=\"readonly\" class=\"Box\" size=\"40%\" name=\"listSeriveDtl["+(rowCount)+"].strDocName\"  id=\"txtServiceName."+(rowCount)+"\" value='"+ServiceName+"'/>";
	    row.insertCell(2).innerHTML= "<input  readonly=\"readonly\" class=\"Box\" size=\"25%\" style=\"padding-right: 5px;text-align: right;\"  name=\"listSeriveDtl["+(rowCount)+"].dblDocRate\"  id=\"txtServiceRate."+(rowCount)+"\" value='"+Rate+"'/>";
	    if(Applicable=='Y')
	    {
		    row.insertCell(3).innerHTML= "<input id=\"chkServiceSel."+(rowCount)+"\" type=\"checkbox\"  checked=\"checked\" class=\"GCheckBoxClass\" name=\"listSeriveDtl["+(rowCount)+"].strType\" size=\"3%\" value=\"Y\"   />";
		    ServiceTotal=ServiceTotal + Rate;
	  	    $("#txtTotalServiceAmt").val(ServiceTotal);
	    }
	    else
	    {
		    row.insertCell(3).innerHTML= "<input id=\"chkServiceSel."+(rowCount)+"\" type=\"checkbox\"  class=\"GCheckBoxClass\" name=\"listSeriveDtl["+(rowCount)+"].strType\" size=\"3%\" value=\"Y\"   />";

	    }	
	    
	}

	var EuipTotal=0;
	function funfillEquipmentDtlRow(EquipCode,EquipName,EquipRate,EquipQty)
	{
		if(funDuplicateEuipForUpdate(EquipCode))
	    {
			var table = document.getElementById("tblEquipDtl");
		    var rowCount = table.rows.length;  
		    var row = table.insertRow(rowCount);
		    rowCount=listEquipRow;
		    row.insertCell(0).innerHTML= "<input  readonly=\"readonly\" class=\"Box\" size=\"15%\" name=\"listEquipDtl["+(rowCount)+"].strDocNo\"  id=\"txtEquipCode."+(rowCount)+"\" value='"+EquipCode+"' />";
		    row.insertCell(1).innerHTML= "<input  readonly=\"readonly\" class=\"Box\" size=\"47%\" name=\"listEquipDtl["+(rowCount)+"].strDocName\"  id=\"txtEquipName."+(rowCount)+"\" value='"+EquipName+"'/>"; 
		    row.insertCell(2).innerHTML= "<input   class=\" decimal-places-amt\" size=\"9%\" name=\"listEquipDtl["+(rowCount)+"].dblDocQty\" style=\"text-align: right;\"  id=\"txtEquipQty."+(rowCount)+"\" value='"+EquipQty+"' onblur=\"funUpdateEuipPrice(this);\"/>";    
		    row.insertCell(3).innerHTML= "<input  readonly=\"readonly\" class=\"Box \" style=\"padding-right: 5px;text-align: right;\" size=\"21%\" name=\"listEquipDtl["+(rowCount)+"].dblDocRate\"  id=\"txtEquipRate."+(rowCount)+"\" value='"+EquipRate+"'/>";
		    row.insertCell(4).innerHTML= '<input type="button" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRowEquip(this)">';		    
		    listEquipRow++;
		    funCalculateEuipTotal();
		    funUpdateTotalBookingAmt();
			
	    }		
		
	     
	    
	}
	
	function funfillStaffCatRow(StaffCatCode,StaffCatName,StaffQty)
	{
		if(funDuplicateStaffUpdate(StaffCatCode))
	    {
			var table = document.getElementById("tblStaffCatDtl");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    rowCount=listStaffRow;
		    row.insertCell(0).innerHTML= "<input  readonly=\"readonly\" class=\"Box\" size=\"22%\" name=\"listStaffCatDtl["+(rowCount)+"].strDocNo\"  id=\"txtStaffCatCode."+(rowCount)+"\" value='"+StaffCatCode+"' />";
		    row.insertCell(1).innerHTML= "<input  readonly=\"readonly\" class=\"Box\" size=\"54%\" name=\"listStaffCatDtl["+(rowCount)+"].strDocName\"  id=\"txtStaffCatName."+(rowCount)+"\" value='"+StaffCatName+"'/>";
		    row.insertCell(2).innerHTML= "<input   class=\" decimal-places-amt\" size=\"20%\" name=\"listStaffCatDtl["+(rowCount)+"].dblDocQty\" style=\"text-align: right;\"  id=\"txtStaffCatNumber."+(rowCount)+"\" value='1' onblur=\"funCheckStaffNumber(this,'"+StaffCatCode+"','"+rowCount+"');\"/>";
		    row.insertCell(3).innerHTML= '<input type="button" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRowStaff(this)">';		    
		    listStaffRow++;
	    }
	     
	    
	}
	
	function funCheckStaffNumber(obj,StaffCatCode,cnt)
	{
		var staffCode = StaffCatCode;
		var staffCnt = obj.value;
		
		var searchurl=getContextPath()+ "/checkStaffCnt.html?staffCode=" + staffCode+"&staffCnt="+ staffCnt;
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",
			success : function(response){ 
				if(response)
					{
					
					}
				else
					{
						alert("Please select less count");
						$("#txtStaffCatNumber").val(0);
					}
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
		
	}
	
	var MenuTotal=0;
	function funfillMenuItemDtlRow(ItemCode,ItemName,ItemRate,ItemQty)
	{
		if(funDuplicateItemForUpdate(ItemCode))
		{
			var table = document.getElementById("tblMenuDtl");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    rowCount=listItemRow;
		    row.insertCell(0).innerHTML= "<input  readonly=\"readonly\" class=\"Box\" size=\"18%\" name=\"listMenuItemDtl["+(rowCount)+"].strDocNo\"  id=\"txtItemCode."+(rowCount)+"\" value='"+ItemCode+"'/>";
		    row.insertCell(1).innerHTML= "<input  readonly=\"readonly\" class=\"Box\" size=\"40%\" name=\"listMenuItemDtl["+(rowCount)+"].strDocName\"  id=\"txtItemName."+(rowCount)+"\" value='"+ItemName+"'/>";
		    row.insertCell(2).innerHTML= "<input  class=\"decimal-places-amt\" size=\"13%\" name=\"listMenuItemDtl["+(rowCount)+"].dblDocQty\"  id=\"txtItemQty."+(rowCount)+"\" style=\"text-align: right;\" value='"+ItemQty+"' onblur=\"funUpdateItemPrice(this);\"/>";
		    row.insertCell(3).innerHTML= "<input  readonly=\"readonly\" class=\"Box\" size=\"16%\" style=\"padding-right: 5px;text-align: right;\"  name=\"listMenuItemDtl["+(rowCount)+"].dblDocRate\"  id=\"txtItemRate."+(rowCount)+"\" value='"+ItemRate+"'/>";
		    row.insertCell(4).innerHTML= '<input type="button" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRowMenu(this)">';	
		    
		    listItemRow++;
		    funCalculateItemTotal();
		    funUpdateTotalBookingAmt();
		
		}
		
	     
	    
	}
	
	function funfillBanquetRow(ItemCode,ItemName,ItemRate)
	{
		$("#txtBanquetCode").val(ItemCode);
		$("#txtBanquetRate").val(ItemRate);
		$("#lblBanquetName").text(ItemName);
		
		
	}
	
	function funfillExternalServicesRow(vendorName,vendorCode,ServiceName,serviceCode,dblRate)
	{
		if(funDuplicateServices(ServiceName))
		{
			var table = document.getElementById("tblExternalServiceDtl");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    rowCount=listExternalServiceRow;
		 		    
		    row.insertCell(0).innerHTML= "<input  readonly=\"readonly\" class=\"Box\" size=\"25%\"   id=\"txtvendorName."+(rowCount)+"\" value='"+vendorName+"'/>";
		    row.insertCell(1).innerHTML= "<input  readonly=\"readonly\" class=\"Box\" style=\"width: 0px;\" name=\"listExternalServices["+(rowCount)+"].strVendorCode\" size=\"0%\"  id=\"txtvendorCode."+(rowCount)+"\" value='"+vendorCode+"'/>";
		    row.insertCell(2).innerHTML= "<input  readonly=\"readonly\" class=\"Box\" size=\"25%\" name=\"listExternalServices["+(rowCount)+"].strDocName\"  id=\"txtServiceName."+(rowCount)+"\" value='"+ServiceName+"'/>";
		    row.insertCell(3).innerHTML= "<input  readonly=\"readonly\" class=\"Box\" style=\"width: 0px;\"  name=\"listExternalServices["+(rowCount)+"].strDocNo\" size=\"0%\" id=\"txtServiceCode."+(rowCount)+"\" value='"+serviceCode+"'/>";
		    row.insertCell(4).innerHTML= "<input  readonly=\"readonly\" class=\"Box\" size=\"15%\" style=\"padding-right: 5px;text-align: right;\"  name=\"listExternalServices["+(rowCount)+"].dblDocRate\"  id=\"txtServiceRate."+(rowCount)+"\" value='"+dblRate+"'/>";
		    row.insertCell(5).innerHTML= '<input type="button" class="deletebutton" value = "Delete" onClick="Javacsript:funDeleteRowExternalServices(this)">';	
		    
		    listExternalServiceRow++;
		    funCalculateExternalServicesTotal();
		    funUpdateTotalBookingAmt();
		
		}
		
	     
	    
	}
	function funDeleteRowStaff(obj)
	{
		 var index = obj.parentNode.parentNode.rowIndex;
		 var table = document.getElementById("tblStaffCatDtl");
		 table.deleteRow(index);
	}
	function funDeleteRowEquip(obj)
	{
		 var index = obj.parentNode.parentNode.rowIndex;
		 var table = document.getElementById("tblEquipDtl");
		 table.deleteRow(index);
		 funCalculateEuipTotal();
	}
	function funDeleteRowMenu(obj)
	{
		 var index = obj.parentNode.parentNode.rowIndex;
		 var table = document.getElementById("tblMenuDtl");
		 table.deleteRow(index);
		 funCalculateItemTotal();
	}
	function funDeleteRowExternalServices(obj)
	{
		 var index = obj.parentNode.parentNode.rowIndex;
		 var table = document.getElementById("tblExternalServiceDtl");
		 table.deleteRow(index);
		 funCalculateExternalServicesTotal();
	}
	
	function funRemAllRows(tableName)
	{
		var table = document.getElementById(tableName);
		var rowCount = table.rows.length;
		while(rowCount>0)
		{
			table.deleteRow(0);
			rowCount--;
		}
	}
	
	function funSetBookingData(Code) {
		
		var searchurl=getContextPath()+ "/loadBanquetBookingHd.html?bookingCode=" + Code;
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",
			success : function(response)
			{ 
				if(response.strBookingNo=='Invalid Code')
	        	{
	        		alert("Invalid Booking Code");
	        		$("#txtBookingNo").val('');
	        	
	        	}
				else
				{
					$("#txtBookingNo").val(response.strBookingNo);
	        		$("#txtBookingDate").val(funGetDate(response.dteBookingDate));
	        		$("#txtFromDate").val(funGetDate(response.dteFromDate));
	        		$("#txtToDate").val(funGetDate(response.dteToDate));
	        		$("#txtMaxPaxNo").val(response.intMaxPaxNo);
	        		$("#txtMinPaxNo").val(response.intMinPaxNo);
	        		$("#txtAreaCode").val(response.strAreaCode);
	        		$("#txtBillingInstructionCode").val(response.strBillingInstructionCode);
	        		$("#cmbBookingStatus").val(response.strBookingStatus);
	        		$("#txtEmailId").val(response.strEmailID);
	        		$("#txtEventCoordinatorCode").val(response.strEventCoordinatorCode);
	        		$("#txtFunctionCode").val(response.strFunctionCode);
	        		funSetPropertyCode(response.strPropertyCode);
	        		
	        		$("#txtFromTime").val(response.tmeFromTime);
	        		$("#txtToTime").val(response.tmeToTime);
	        		
	        		$("#txtTotalBookingAmt").val(response.dblSubTotal);
	        		        
	        		
	        		funSetCustomer(response.strCustomerCode);
	        		funSetBookingFunInternalServiceData();
	        		funSetBookingFunExternalServiceData();
	        		funUpdateBookingDtl(response.listBanquetBookingDtlModels);
	        		
				}

			},
			error : function(jqXHR, exception){
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
	 function funUpdateBookingDtl(listBookingDtl){
		 funRemAllRows('tblEquipDtl');	
		 funRemAllRows('tblStaffCatDtl');
		 funRemAllRows('tblMenuDtl');
   		$.each(listBookingDtl, function(i,item)
           {
   			funfillBookingDtl(listBookingDtl[i].strType,listBookingDtl[i].strDocNo,listBookingDtl[i].strDocName,listBookingDtl[i].dblDocRate,listBookingDtl[i].dblDocQty);
			});
   	
		}
	 
	 function funUpdateQuotationDtl(listQuatationDtl){
		 funRemAllRows('tblEquipDtl');	
		 funRemAllRows('tblStaffCatDtl');
		 funRemAllRows('tblMenuDtl');
   		$.each(listQuatationDtl, function(i,item)
           {
   			funfillQuatationDtl(listQuatationDtl[i].strType,listQuatationDtl[i].strDocNo,listQuatationDtl[i].strDocName,listQuatationDtl[i].dblDocRate,listQuatationDtl[i].dblDocQty);
			});
   	
		}
	
	function funfillBookingDtl(strType,strDocNo,strDocName,dblDocRate,dblDocQty) {
		if(strType =='Equipment')
		{
			funfillEquipmentDtlRow(strDocNo,strDocName,dblDocRate,dblDocQty);	
		}
		else if(strType =='Staff')
		{
			funfillStaffCatRow(strDocNo,strDocName,dblDocQty);	
		}
		else if(strType =='Menu')
		{
			funfillMenuItemDtlRow(strDocNo,strDocName,dblDocRate,dblDocQty);	
		}
		else if(strType =='Banquet')
		{
			funfillBanquetRow(strDocNo,strDocName,dblDocRate);	
		}
		
	}
	
	function funfillQuatationDtl(strType,strDocNo,strDocName,dblDocRate,dblDocQty) {
		if(strType =='Equipment')
		{
			funfillEquipmentDtlRow(strDocNo,strDocName,dblDocRate,dblDocQty);	
		}
		else if(strType =='Staff')
		{
			funfillStaffCatRow(strDocNo,strDocName,dblDocQty);	
		}
		else if(strType =='Menu')
		{
			funfillMenuItemDtlRow(strDocNo,strDocName,dblDocRate,dblDocQty);	
		}
		else if(strType =='Banquet')
		{
			funfillBanquetRow(strDocNo,strDocName,dblDocRate);	
		}
		
	}
	 function  funGetDate(date) {
		 var dateSplit = date.split(" ")[0].split("-");    
		 date=dateSplit[2]+"-"+dateSplit[1]+"-"+dateSplit[0];
		 return date;
		
	}
	 function funSetPropertyCode(code){

			$.ajax({
				type : "GET",
				url : getContextPath()+ "/loadPropertyCode.html?docCode=" + code,
				dataType : "json",
				success : function(response){ 
					$("#txtPropertyCode").text(response.strPropertyName);
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
		}
	 
	 
	  function funLoadBanquetRate(code)
	  {


			$.ajax({
				type : "GET",
				url : getContextPath()+ "/loadBanquetRate.html?BanquetCode=" + code,
				dataType : "json",
				success : function(response){ 
					$("#txtBanquetRate").val(response[0][2]);
					funUpdateTotalBookingAmt();
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
		
	  }
 
   		   $(document).on('change', '[type=checkbox]', function() {
		     var checkbox = $(this).is(':checked');
		     var index = this.parentNode.parentNode.rowIndex;
		         if(checkbox)
		    	 {
		        	 var  Rate1=document.getElementById("txtServiceRate."+index).value;
				     var ServiceRate1 =$("#txtTotalServiceAmt").val();
				     var Total1=0;
				     if(ServiceRate1=='')
			    	 {
				    	 Total1=  parseFloat(Rate1);
				    	
			    	 }
				     else
				     {
				    	 Total1= parseFloat(ServiceRate1) + parseFloat(Rate1);
				     } 	 
				     $("#txtTotalServiceAmt").val(Total1);
				     funUpdateTotalBookingAmt();
		    	 
		    	 }else{
		    		 var  Rate2=document.getElementById("txtServiceRate."+index).value;
				     var ServiceRate2 =$("#txtTotalServiceAmt").val();
				     var Total2=0;
				     if(ServiceRate2=='')
				     {
				    	 Total2= parseFloat(Rate2);
				    	 
				     }
				     else
				     {
				    	 Total2= parseFloat(ServiceRate2) - parseFloat(Rate2);
				     } 	 
				   
				     $("#txtTotalServiceAmt").val(Total2);
				     funUpdateTotalBookingAmt();
		    		 
		    	 }
		    
		}); 
	
   		   
   		  
   		   
	   
   		function funCheckBooking(){
   			gflag=false;
   			var fromTime=$('#txtFromTime').val();
   			var fromDate=$('#txtFromDate').val();   			
   			var locName=$('#lblAreaCode').text();   	
   			
			$.ajax({
				type : "GET",
				url : getContextPath()+ "/checkBooking.html?fromTime=" + fromTime+"&fromDate="+fromDate+"&locName="+locName,
				dataType : "json",
				success : function(response){
					if(response==false)
						{
							gflag=true;
							gbookingflag=false;
						}		
					else
					{
						gbookingflag=true;
						alert("Select Different Date And Time  ");		
					}
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
			
			
		}
	 
	 
   		   
   		   
   		   
   		   
	   	function funUpdateEuipPrice(object)
		{
	   		 
	   		funCalculateEuipTotal();
	   		funUpdateTotalBookingAmt();
			/* var index=object.parentNode.parentNode.rowIndex;
			if(document.getElementById("txtEquipQty."+index).value !='')
			{
				var Qty=document.getElementById("txtEquipQty."+index).value;
				var AmtEquip=document.getElementById("txtEquipRate."+index).value;
				var TotalEquip=parseFloat($("#txtTotalEquipAmt").val()) +(parseFloat(Qty)*parseFloat(AmtEquip) );
				$("#txtTotalEquipAmt").val(TotalEquip);
				
			}
			 */
		
		}
		function funUpdateItemPrice(object)
		{
			funCalculateItemTotal();
			funUpdateTotalBookingAmt();
			
			/* var index=object.parentNode.parentNode.rowIndex;
			if(document.getElementById("txtItemQty."+index).value !='')
			{
				var Qty=document.getElementById("txtItemQty."+index).value;
				var AmtItem=document.getElementById("txtItemRate."+index).value;
				var TotalItem=parseFloat($("#txtTotalEquipAmt").val()) + (parseFloat(Qty) * parseFloat(AmtItem));
				$("#txtTotalEquipAmt").val(TotalItem);
			
			} */
			
		
		}
		function funCalculateEuipTotal()
		{
			 
		    var table = document.getElementById("tblEquipDtl");
		    var rowCount = table.rows.length;
		    var TotalEquip=0;
		    if(rowCount > 0)
		    {
			    $('#tblEquipDtl tr').each(function()
			    {
			    	var qty=$(this).find('input')[2].value;
			    	var amt=$(this).find('input')[3].value;
			    	
			    	TotalEquip=TotalEquip + (parseFloat(qty) * parseFloat(amt));
			    	
				});
			    $("#txtTotalEquipAmt").val(TotalEquip);
			    
				    
		   }
		  
			
		}
			
	
		function funCalculateItemTotal()
		{
			 var table = document.getElementById("tblMenuDtl");
			 var rowCount = table.rows.length;
			 var TotalItem=0;
		    if(rowCount > 0)
		    {
			    $('#tblMenuDtl tr').each(function()
			    {
			    	var qty=$(this).find('input')[2].value;
			    	var amt=$(this).find('input')[3].value;
			    	
			    	TotalItem=TotalItem + (parseFloat(qty) * parseFloat(amt));
			
				});
			    $("#txtTotalItemAmt").val(TotalItem);
				    
		   }
			
		}
		function funCalculateExternalServicesTotal()
		{
			funUpdateTotalBookingAmt();
			 var table = document.getElementById("tblExternalServiceDtl");
			 var rowCount = table.rows.length;
			 var TotalItem=0;
		    if(rowCount > 0)
		    {
			    $('#tblExternalServiceDtl tr').each(function()
			    {
			    	var amt=$(this).find('input')[4].value;
			    	
			    	TotalItem=TotalItem + parseFloat(amt);
			
				});
			    $("#txtTotalExternalServiceAmt").val(TotalItem);
				    
		   }
			
		    
		}
		
		function funDuplicateEuipForUpdate(strEuipCode)
		{
		 var table = document.getElementById("tblEquipDtl");
		    var rowCount = table.rows.length;		   
		    var flag=true;
		    if(rowCount > 0)
		    {
				    $('#tblEquipDtl tr').each(function()
				    {
					    if(strEuipCode==$(this).find('input').val())// `this` is TR DOM element
	    				{
					    	alert("Already added Equipment "+ strEuipCode );
					    	flag=false; 
					    	
		    			
	    				}
					});
				    
		   }
		    return flag;
		} 
		function funDuplicateStaffUpdate(strEuipCode)
		{
		 var table = document.getElementById("tblEquipDtl");
		    var rowCount = table.rows.length;		   
		    var flag=true;
		    if(rowCount > 0)
		    {
				    $('#tblStaffCatDtl tr').each(function()
				    {
					    if(strEuipCode==$(this).find('input').val())// `this` is TR DOM element
	    				{
					    	alert("Already added Staff "+ strEuipCode );
					    	flag=false; 
					    	
		    			
	    				}
					});
				    
		   }
		    return flag;
		}
		function funDuplicateItemForUpdate(strItemCode)
		{
		 var table = document.getElementById("tblMenuDtl");
		    var rowCount = table.rows.length;		   
		    var flag=true;
		    if(rowCount > 0)
		    {
				    $('#tblMenuDtl tr').each(function()
				    {
					    if(strItemCode==$(this).find('input').val())// `this` is TR DOM element
	    				{
					    	alert("Already added Item "+ strItemCode );
					    	flag=false; 
					    	
		    			
	    				}
					});
				    
		   }
		    return flag;
		}
		
		function funDuplicateServices(serviceName)
		{
		 var table = document.getElementById("tblExternalServiceDtl");
		    var rowCount = table.rows.length;		   
		    var flag=true;
		    if(rowCount > 0)
		    {
				    $('#tblExternalServiceDtl tr').each(function()
				    {
					    if(serviceName==$(this).find('input')[1].defaultValue)// `this` is TR DOM element
	    				{
					    	alert("Already added Item "+ serviceName );
					    	flag=false; 
	    				}
					});
				    
		   }
		    return flag;
		}
		
		function funUpdateTotalBookingAmt()
		{
			 var rateService =0;
		   	    if($("#txtTotalServiceAmt").val()!='')
			   	{
		   	    	
		   	    	rateService= $("#txtTotalServiceAmt").val(); 
			   	}
		   	    var rateItem =0;
		   	    if($("#txtTotalItemAmt").val()!='')
			   	{
		   	    	rateItem  =$("#txtTotalItemAmt").val();
			   	}
		   	    var rateEquip =0;
		   	    if($("#txtTotalEquipAmt").val()!='')
			   	{
		   	    	rateEquip =$("#txtTotalEquipAmt").val(); 
			   	}
		   	    var rateBanquet =0;
		   	    if($("#txtBanquetRate").val()!='')
			   	{
		   	    	rateBanquet =$("#txtBanquetRate").val(); 
			   	}
		   	    var rateExternalServices=0;
		   	 if($("#txtTotalExternalServiceAmt").val()!='')
			   	{
		   		rateExternalServices =$("#txtTotalExternalServiceAmt").val(); 
			   	}
		   	 
		   	   var FinalAmount = parseFloat(rateEquip) + parseFloat(rateItem) + parseFloat(rateService) + parseFloat(rateBanquet) + parseFloat(rateExternalServices) ;
		       $("#txtTotalBookingAmt").val(FinalAmount);
		}	
		
		
		function funValidateForm()
		{	
			var flag=true;
			if(gbookingflag==true)
			{
				alert("Select Different Date And Time  ");	
				 flag=false;
			}			
			if($("#txtAreaCode").val().trim().length==0)
			{
				alert("Please Select Area!!");
				flag=false;
			}
			else if($("#txtFunctionCode").val().trim().length==0)
			{
				alert("Please Select Fuction Code!!");
				flag=false;
			}
			else if($("#txtMaxPaxNo").val()=="0")
			{
				alert("Please Enter Max Pax!!");
				flag=false;
			}
			else if($("#txtBanquetCode").val().trim().length==0)
			{
				alert("Please Enter Banquet Code!!");
				$("#txtBanquetCode").focus();
				flag=false;
			}
			else if($('#txtFromDate').val()>$('#txtToDate').val())
			{				
					alert("Please Enter To Date is Greater Than From Date")
					flag=false;
			}
			else if($("#txtCustomerCode").val().trim().length==0)
			{
				 alert("Please Select Customer Code !!");
				 flag=false;
			}
			else if($("#txtCustomerName").val().trim().length==0)
			{
				 alert("Please Enter Customer Name !!");
				 flag=false;
			}		
			else if($("#txtMobileNo").val().trim().length==0)
			{
				 alert("Please Enter Mobile Number !!");
				 flag=false;
			}
			else if($("#txtEmailId").val().trim().length==0)
			{
				 alert("Please Enter Email Id !!");
				 flag=false;
			}
			else if($('#txtFromDate').val()==$('#txtToDate').val())
			{
				if(!($('#txtToTime').val() >= $('#txtFromTime').val()))
				{
					alert("Please Enter Out Time is Greater Than In Time")
					flag=false;
				}
			}			
			
						
			return flag; 
			
			
		}
	 
		function funChangeArrivalDate()
		{
			var arrivalDate=$("#txtFromDate").val();
			
		    //var currentDate=datepicker('setDate','todate');

		    var d = new Date();
		    var strDate = d.getFullYear() + "/" + (d.getMonth()+1) + "/" + d.getDate();
	    	
		    if (arrivalDate < currentDate) 
	  		 {
			    	alert("Arrival Date Should not be come before Current Date");
			    	$("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
			    	$("#txtFromDate").datepicker('setDate','todate');
					return false
	         }
	    	
	    	
		}
		
		function funCheckFromDate()
		{
			var arrivalDate=$("#txtFromDate").val();
		    var todate=$("#txtToDate").val();;

	    	if (todate < arrivalDate) 
	  		 {
			    	alert("To date should be greater then from Date");
			    	$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
			    	$("#txtToDate").datepicker('setDate','todate');
					return false;
	         }
	    	
	    	
		}
		
		function funCheckCuurntDate()
		{
			var bookinDate=$("#txtBookingDate").val();
		    var fromDate=$("#txtFromDate").val();;

	    	if (bookinDate < fromDate) 
	  		 {
			    	alert("Booking date should be greater then Current Date");
			    	$("#txtBookingDate").datepicker({ dateFormat: 'dd-mm-yy' });
			    	$("#txtBookingDate").datepicker('setDate','todate');;
					return false
	         }
	    	
	    	
		}
		function funCheckLocation(){
			
			var flag=true;
			if($("#txtAreaCode").val().trim().length==0)
			{
				alert("Select Area  ");	
				$("#txtAreaCode").focus();
				 flag=false;
			}	
			return flag;
		} 

		function funSetQuotationData(Code) {
			
			var searchurl=getContextPath()+ "/loadBanquetQuotation.html?quotationCode=" + Code;
			$.ajax({
				type : "GET",
				url : searchurl,
				dataType : "json",
				success : function(response)
				{ 
					if(response.strQuotationNo=='Invalid Code')
		        	{
		        		alert("Invalid Booking Code");
		        		$("#txtBookingNo").val('');
		        	
		        	}
					else
					{
						//$("#txtBookingNo").val(response.strQuotationNo);
		        		$("#txtBookingDate").val(funGetDate(response.dteQuotationDate));
		        		$("#txtFromDate").val(funGetDate(response.dteFromDate));
		        		$("#txtToDate").val(funGetDate(response.dteToDate));
		        		$("#txtMaxPaxNo").val(response.intMaxPaxNo);
		        		$("#txtMinPaxNo").val(response.intMinPaxNo);
		        		$("#txtAreaCode").val(response.strAreaCode);
		        		$("#txtBillingInstructionCode").val(response.strBillingInstructionCode);
		        		$("#cmbBookingStatus").val(response.strQuotationStatus);
		        		$("#txtEmailId").val(response.strEmailID);
		        		$("#txtEventCoordinatorCode").val(response.strEventCoordinatorCode);
		        		$("#txtFunctionCode").val(response.strFunctionCode);
		        		funSetPropertyCode(response.strPropertyCode);
		        		
		        		$("#txtFromTime").val(response.tmeFromTime);
		        		$("#txtToTime").val(response.tmeToTime);
		        		
		        		$("#txtTotalBookingAmt").val(response.dblSubTotal);
		        		        
		        		
		        		funSetCustomer(response.strCustomerCode);
		        		funSetBookingFunInternalServiceData();
		        		funSetQuotationFunExternalServiceData();
		        		funUpdateQuotationDtl(response.listBanquetQuotationDtlModels);
		        		
					}

				},
				error : function(jqXHR, exception){
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
		
		 /* $(document).ready(function(){
		    $("#div1").on('click', function(){
		            console.log("click!!!");
		        });
		});
		 */
		
</script>

</head>
<body>
   <div class="container transTable">
		<label id="formHeading">Banquet Booking</label>
	   <s:form name="Banquet Booking" method="POST" action="saveBanquetBooking.html">

	 <div id="tab_container">
	 <br>
			<ul class="tabs">
				<li data-state="tab1">Booking</li>
				<li data-state="tab2">Menu</li>
				<li data-state="tab3">Staff Category</li>
				<li data-state="tab4">Equipment</li>
				<li data-state="tab5">Internal Services</li>
				<li data-state="tab6">External Services</li>
			</ul>

     <div id="tab1" class="tab_content" style="margin-top: 40px;">
           <div class="row">
                
					<%-- <s:select id="cmbAgainst"
							path="" cssClass="BoxW124px">
							<s:option value="Waiting">Booking</s:option>
							<s:option value="Provisional">Quotation</s:option>

						</s:select> --%>
					<div class="col-md-2"><label>Against</label>
					        <s:select id="cmbAgainst" path="">
							     <s:option value="Booking">Booking</s:option>
							     <s:option value="Quotation">Quotation</s:option>
                            </s:select>
					 </div>
					 		
					 <div class="col-md-2"><br>
					       <s:input type="text" id="txtBookingNo" readonly="true" path="strBookingNo" 
					         cssClass="searchTextBox" ondblclick="funHelp('Booking');" style="margin-top: 7%;"/>
					 </div>
					  
                     <div class="col-md-2"><label>Property</label>
					       <s:select id="txtPropertyCode" path="strPropertyCode"
							items="${listOfProperty}" required="true"></s:select>
					 </div>
                    
                     <div class="col-md-2"><label id="lblPropName" style="background-color:#dcdada94; width: 100%; height: 50%; margin-top:16%;"></label>
					 </div>
				     <div class="col-md-4"></div>
				     
				     <div class="col-md-2"><label class="label">Area </label>
					        <s:input type="text" id="txtAreaCode" path="strAreaCode" cssClass="searchTextBox" 
					        readonly="true" ondblclick="funHelp('PropertyWiseLocation');" /> 
					 </div>
					 
					 <div class="col-md-2"><label id="lblAreaCode" style="background-color:#dcdada94; width: 100%; height: 50%; margin-top:11%;"></label>
					 </div>
						
					 <div class="col-md-2"><label>Booking Date</label>
					        <s:input type="text" id="txtBookingDate" path="dteBookingDate" cssClass="calenderTextBox" onchange="funCheckCuurntDate();" style="width:70%;"/> <!-- onchange="funChangeArrivalDate();" -->
					 </div>
					 
					 <div class="col-md-2"><label id="lblBookingDate" style="background-color:#dcdada94; width: 100%; height: 50%; margin-top:11%;"></label>
				     </div>
			         <div class="col-md-4"></div>
			         
                     <div class="col-md-2"><label>From Date</label>
					         <s:input type="text" id="txtFromDate" path="dteFromDate" cssClass="calenderTextBox" onchange="funChangeArrivalDate();funCheckBooking;" onblur="funCheckBooking();" onclick= " return funCheckLocation();" style="width:70%;"/>
					 </div>

					<!-- onchange="funChangeArrivalDate();"  -->
					<div class="col-md-2"><label>To Date</label>
					        <s:input type="text" id="txtToDate" path="dteToDate" style="width:70%;"
							     cssClass="calenderTextBox"  onchange="funCheckFromDate();" onblur="funCheckBooking();"/>
					</div>
					<!-- onchange="CalculateDateDiff();" -->
					
				    <div class="col-md-2"><label>In Time</label>
				            <s:input type="text" id="txtFromTime" path="tmeFromTime" style="width:70%;"
							      cssClass="calenderTextBox" onblur="funCheckBooking();"/>
				    </div>

					<div class="col-md-2"><label>Out Time</label>
					      <s:input type="text" id="txtToTime" path="tmeToTime" style="width:70%;" cssClass="calenderTextBox" />
					 </div>
					 <div class="col-md-4"></div>
					 
				    <div class="col-md-2"><label>Min Pax</label>
					       <s:input id="txtMinPaxNo" name="txtMinPaxNo"
							path="intMinPaxNo" style="width: 60%;text-align: right;" type="number" min="0" step="1"  />
					</div>
					
					<div class="col-md-2"><br><label class="label">Max Pax </label><br>
					       <s:input id="txtMaxPaxNo" path="intMaxPaxNo"
							style=" width: 60%; text-align: right;" type="number" min="0" step="1" name="txtMaxPaxNo" />
					</div>
			
				    <div class="col-md-2"><label>Billing Instructions</label>
					       <s:input type="text" id="txtBillingInstructionCode" path="strBillingInstructionCode" cssClass="searchTextBox" readonly="true"
							ondblclick="funHelp('BillingInstCode');" /> <label id="lblBillingInstDesc"></label>
					</div>
					
				    <div class="col-md-2"><label>Event Co-Ordinator</label>
					   <s:input type="text" id="txtEventCoordinatorCode" path="strEventCoordinatorCode" cssClass="searchTextBox" readonly="true"
							ondblclick="funHelp('StaffCode');" /> &nbsp;&nbsp;&nbsp;<label id="lblEventCoordinatorCode"></label></td>
				    </div>
                      <div class="col-md-4"></div>
                      
				     <div class="col-md-2"><label class="label">Function Code </label>
					<!--  <td><label>Function Code</label></td> -->
					       <s:input id="txtFunctionCode" path="strFunctionCode"
							readonly="true" ondblclick="funHelp('functionMaster')" 
							cssClass="searchTextBox" /> <label id="lblFunctionName"></label>
					</div>

				    <div class="col-md-2"><label>Booking Status</label>
					     <s:select id="cmbBookingStatus" path="strBookingStatus">
							   <s:option value="Waiting">Waiting</s:option>
							   <s:option value="Provisional">Provisional</s:option>
                         </s:select>
                    </div>

				   <div class="col-md-2"><label class="label">Banquet </label>
					      <s:input type="text" id="txtBanquetCode"	path="strBanquetCode" cssClass="searchTextBox" readonly="true"
							ondblclick="funHelp('banquetCode');" /><label id="lblBanquetName"></label>
						&nbsp;&nbsp;
				   </div>	
						
				   <div class="col-md-2"><label>Amount</label>
				        <s:input id="txtBanquetRate" path=""
						style="text-align: right; width: 60%;" name="txtBanquetRate" onblur="funUpdateTotalBookingAmt();"/>
				   </div>
							<!-- <label
						id="lblBanquetRate"></label></td> -->
			</div>
			
			 <br/>
       
				<div class="row">

					   <div class="col-md-2"><label class="label">Customer Code </label>
						   <s:input type="text" id="txtCustomerCode" readonly="true"
						     path="strCustomerCode" ondblclick="funHelp('custMaster');" class="searchTextBox" />
				       </div>
                       
                       <div class="col-md-2"><label id="lblGFirstName" class="label"> Name </label>
						        <input type="text" id="txtCustomerName"/>
						</div>

						<div class="col-md-2"><br>
						    <input type="Button" value="New Costomer"
							onclick="return funCreateNewCustomer()" class="btn btn-primary center-block" class="form_button" />
						</div>
						<div class="col-md-6"></div>
						
					    <div class="col-md-2"><label class="label">Mobile No </label>
						        <input type="text" id="txtMobileNo"  pattern="[789][0-9]{9}" title="Mobile number is wrong"/>
						</div>
                        
                        <div class="col-md-2"><label class="label">Email Id </label>
					       <s:input type="text" id="txtEmailId" path="strEmailID" />
					    </div>
			           <div class="col-md-8"></div>

                       <div class="col-md-2">
	                       <label>Total Booking Amount</label>
	                      <s:input id="txtTotalBookingAmt" path="dblSubTotal"  readonly="true" cssClass="shortTextBox"  style="text-align: right;width:70%; float:left;font-size: 15px;"/>
	                  </div>		
			       </div>
		        </div>	
			
	 <div id="tab2" class="tab_content" style="margin-top: 40px;">
				<!-- Generate Dynamic Table   -->
			 <div class="row">
					<div class="col-md-2"><label>Item Code</label>
						<!--  <td><label>Function Code</label></td> -->
						    <s:input id="txtItemCode" path="" readonly="true"
								ondblclick="funHelp('ItemCode')" cssClass="searchTextBox" /> 
					 </div>
					 
					 <div class="col-md-2"><br>
					        <label id="lblItemCode" style="background-color:#dcdada94; width: 100%; height: 50%; margin-top:7%;padding:2px;"></label>
                     </div>

				</div>
				<br />
				<div class="dynamicTableContainer" style="height: 400px; width: 80%">
					<table
						style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
						<tr bgcolor="#c0c0c0" style="height: 24px;">
							
							<!-- col1   -->
							<td align="center" style="width: 15%">Item Code</td>
							<!-- col1   -->


							<!-- col2   -->
							<td align="center" style="width: 30%">Item Name</td>
							<!-- col2   -->

							<!-- col2   -->
							<td align="center" style="width: 12%">Qty</td>
							<!-- col2   -->

							<!-- col2   -->
							<td align="center" style="width: 15%">Rate</td>
							<!-- col2   -->

							<!-- col3   -->
							<td align="center" style="width: 15%">Delete</td>

							<!-- col3   -->


						</tr>
					</table>
					<div
						style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 400px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
						<table id="tblMenuDtl"
							style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
							class="transTablex col3-center">
							<tbody>
						

							<!-- col2   -->
							<col width="15%">
							<!-- col2   -->

							<!-- col2   -->
							<col width="30%">
							<!-- col2   -->

							<!-- col2   -->
							<col width="12%">
							<!-- col2   -->


							<!-- col2   -->
							<col width="15%">
							<!-- col2   -->

							<!-- col2   -->
							<col width="13.5%">
							<!-- col2   -->

							</tbody>
						</table>
					</div>


				</div>
				
				<div style="margin:auto;width: 20%; float:right; margin-right:20%; ">
	                  <label>Total</label>
	                  <s:input id="txtTotalItemAmt" path=""  readonly="true" cssClass="shortTextBox" style="text-align: right;"/>
	           </div>
		</div>
			
		<div id="tab3" class="tab_content" style="margin-top: 40px;">
				<!-- Generate Dynamic Table   -->
			<div class="row">
					<div class="col-md-2"><label>Staff Category Code</label>
						<!--  <td><label>Function Code</label></td> -->
						<s:input id="txtStaffCatCode" path="" readonly="true"
								ondblclick="funHelp('StaffCatCode')" cssClass="searchTextBox" />
					</div>		
								
					<div class="col-md-2"><br>
					       <label id="lblStaffCatCode" style="background-color:#dcdada94; width: 100%; height: 50%; margin-top:7%;padding:2px;"></label>
                    </div>
             </div>
				<br />
				<div class="dynamicTableContainer" style="height: 400px; width: 80%">
					<table
						style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
						<tr bgcolor="#c0c0c0" style="height: 24px;">
							<!-- col1   -->
							<td align="center" style="width: 20%">Staff Category Code</td>
							<!-- col1   -->

							<!-- col2   -->
							<td align="center" style="width: 45%">Staff Category Name</td>
							<!-- col2   -->

							<!-- col2   -->
							<td align="center" style="width: 20%">Number</td>
							<!-- col2   -->

							<!-- col3   -->
							<td align="center"">Delete</td>
							<!-- col3   -->
                         </tr>
					</table>
					<div
						style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 400px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
						<table id="tblStaffCatDtl"
							style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
							class="transTablex col3-center">
							<tbody>
								<!-- col1   -->
							<col width="19%">
							<!-- col1   -->

							<!-- col2   -->
							<col width="43%">
							<!-- col2   -->

							<!-- col2   -->
							<col width="20%">
							<!-- col2   -->

							<!-- col2   -->
							<col width="13%">
							<!-- col2   -->

							</tbody>
						</table>
					</div>


				</div>
	        </div>
			<br>
			
		  <div id="tab4" class="tab_content" style="margin-top: 40px;">
			   <div class="row">
					<div class="col-md-2"><label>Equipment Code</label>
						<!--  <td><label>Function Code</label></td> -->
						<s:input id="txtEquipmentCode" path="" readonly="true"
								ondblclick="funHelp('equipmentCode')" cssClass="searchTextBox" />
					 </div>
					 
					 <div class="col-md-2"><br>
					      <label id="lblEquipmentCode" style="background-color:#dcdada94; width: 100%; height: 50%; margin-top:7%;padding:2px;"></label>
					  </div>
                  </div>

			
				<br />
				<div class="dynamicTableContainer" style="height: 400px; width: 80%">
					<table
						style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
						<tr bgcolor="#c0c0c0" style="height: 24px;">
							<!-- col1   -->
							<td align="center" style="width: 15%">Equipment Code</td>
							<!-- col1   -->

							<!-- col2   -->
							<td align="center" style="width: 40%">Equipment Name</td>
							<!-- col2   -->

							<!-- col3   -->
							<td align="center" style="width: 10%">Qty</td>
							<!-- col3   -->

							<!-- col4   -->
							<td align="center" style="width: 20%">Rate</td>
							<!-- col4   -->

							<!-- col5   -->
							<td align="center"">Delete</td>
							<!-- col5   -->


						</tr>
					</table>
					<div
						style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 400px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
						<table id="tblEquipDtl"
							style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
							class="transTablex col3-center">
							<tbody>
								<!-- col1   -->
							<col width="16%">
							<!-- col1   -->

							<!-- col2   -->
							<col width="42.5%">
							<!-- col2   -->

							<!-- col3   -->
							<col width="10.5%">
							<!-- col3   -->

							<!-- col4   -->
							<col width="21.5%">
							<!-- col4   -->

							<!-- col5   -->
							<col width="14%">
							<!-- col5   -->

							</tbody>
						</table>
					</div>


				</div>
				<div style="margin:auto;width: 20%; float:right; margin-right:20%; ">
	              <label>Total</label>
	             <s:input id="txtTotalEquipAmt" path=""  readonly="true" cssClass="shortTextBox" style="text-align: right;"/>
	           </div>
				
			</div>
			
			
			<div id="tab5" class="tab_content" style="margin-top: 70px;">
				
				<!-- Generate Dynamic Table   -->
				<div class="dynamicTableContainer" style="height: 400px; width: 80%">
					<table
						style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
						<tr bgcolor="#c0c0c0" style="height: 24px;">
							<!-- col1   -->
							<td align="center" style="width: 20%">Service Code</td>
							<!-- col1   -->

							<!-- col2   -->
							<td align="center" style="width: 50%">Service Name</td>
							<!-- col2   -->

							<!-- col2   -->
							<td align="center" style="width: 20%">Rate</td>
							<!-- col2   -->

							<!-- col3   -->
							<td align="center"">Select</td>
							<!-- col3   -->


						</tr>
					</table>
					<div
						style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 400px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
						<table id="tblInternalServiceDtl"
							style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
							class="transTablex col3-center">
							<tbody>
							<col width="35%">
							<!-- col1   -->

							<!-- col2   -->
							<col width="90%">
							<!-- col2   -->
							<!-- col2   -->
							<col width="35%">
							<!-- col2   -->

							<!-- col2   -->
							<col width="15%">
							<!-- col2   -->
							</tbody>
						</table>
					</div>


				</div>
				
				<div style="margin:auto;width: 20%; float:right; margin-right:20%; ">
	              <label>Total</label>
	            <s:input id="txtTotalServiceAmt" path=""  readonly="true" cssClass="shortTextBox" style="text-align: right;"/>
	           </div>
			</div>
			
			
		<div id="tab6" class="tab_content" style="margin-top: 40px;">
			<div class="row">
					<div class="col-md-2"><label>Vendor </label>
						  <s:input id="txtVendorCode" path="" readonly="true"
								ondblclick="funHelp('suppcode')" cssClass="searchTextBox" />
					</div>
					
					<div class="col-md-2"><br>
					      <label id="lblVendorName" style="background-color:#dcdada94; width: 100%; height: 50%; margin-top:7%;"></label> 
					</div>
						
					<div class="col-md-2"><label>External Service</label>
						  <s:input id="txtExternal" path="" readonly="true"
								ondblclick="funHelp('ExternalServices')" cssClass="searchTextBox" />
							<!-- <label id="lblEquipmentCode"></label> -->
					</div>
				</div>
			
				
				<!-- Generate Dynamic Table   -->
				<div class="dynamicTableContainer" style="height: 400px; width: 80%">
					<table
						style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
						<tr bgcolor="#c0c0c0" style="height: 24px;">
							<!-- col1   -->
							<td align="center" style="width: 25%">Vendor Name</td>
							<!-- col1   -->

							<!-- col2   -->
							<td align="center" style="width: 25%">Service Name</td>
							<!-- col2   -->

							<!-- col2   -->
							<td align="center" style="width: 20%">Rate</td>
							<!-- col2   -->

							<td align="center" style="width: 05%">Delete</td>

						</tr>
					</table>
					<div
						style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 400px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
						<table id="tblExternalServiceDtl"
							style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
							class="transTablex col3-center">
							<tbody>
							<col width="25%">
							<col width="0%">
							<!-- col1   -->

							<!-- col2   -->
							<col width="25%">
							<col width="0%">
							<!-- col2   -->
							<!-- col2   -->
							<col width="20%">
							<!-- col2   -->
							<!-- col2   -->
							<col width="5%">
							<!-- col2   -->
							</tbody>
							
						</table>
					</div>


				</div>
				
				<div style="margin:auto;width: 20%; float:right; margin-right:20%; ">
	              <label>Total</label>
	            <s:input id="txtTotalExternalServiceAmt" path=""  readonly="true" cssClass="shortTextBox" style="text-align: right;"/>
	           </div>
			</div>
		</div>

		<br />
		<p align="center">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" onclick="return funValidateForm();"/> 
			&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetDetailFields()"/>
		</p>
		<br />
	</s:form>
	</div>
</body>
</html>
