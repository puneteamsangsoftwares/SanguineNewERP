<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>

        <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

<style type="text/css">
		
		
	.txtTextArea
	{
		width: 270px;
        height: 45px;
		resize: none;		
	}		
	
	#narrationBuilderTbl th 
	{
	    background: #f18d05 -moz-linear-gradient(center top , #0f5495, #73addd) repeat scroll 0 0;
		border: 1px solid #0f5495;
	    border-radius: 0;
	    box-shadow: 0 1px 0 rgba(90, 52, 139, 0.16), 0 1px 0 #0f5495 inset;
	    color: #fff;
	    transition: all 0.9s ease 0s;
	}
	
</style>

<script type="text/javascript">
	var fieldName;
	var accountType;		
		
	
	function setAccountCodeAndName(response)
	{
		switch(accountType)
		{		
			case "debtorControlAC": 
				if(response.strAccountCode=='Invalid Code')
	        	{
	        		alert("Invalid Account Code");
	        		$("#txtDebtorControlACCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtDebtorControlACCode").val(response.strAccountCode);
		        	$("#txtDebtorControlACName").val(response.strAccountName);
		        	$("#txtDebtorControlACName").focus();		
	        	}
				 break;				 
			case "debtorBillableAC": 
				if(response.strAccountCode=='Invalid Code')
	        	{
	        		alert("Invalid Account Code");
	        		$("#txtDebtorBillableACCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtDebtorBillableACCode").val(response.strAccountCode);
		        	$("#txtDebtorBillableACName").val(response.strAccountName);
		        	$("#txtDebtorBillableACName").focus();		
	        	}
				 break;
			case "debtorSuspenseAC": 
				if(response.strAccountCode=='Invalid Code')
	        	{
	        		alert("Invalid Account Code");
	        		$("#txtDebtorSuspenseACCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtDebtorSuspenseACCode").val(response.strAccountCode);
		        	$("#txtDebtorSuspenseACName").val(response.strAccountName);
		        	$("#txtDebtorSuspenseACName").focus();		
	        	}
				 break;
			case "debtorSuspenseCode": 
				if(response.strAccountCode=='Invalid Code')
	        	{
	        		alert("Invalid Account Code");
	        		$("#txtDebtorsSuspenseCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtDebtorsSuspenseCode").val(response.strAccountCode);
		        	$("#txtDebtorsSuspenseName").val(response.strAccountName);
		        	$("#txtDebtorsSuspenseName").focus();		
	        	}
				 break;				 
			case "roundingOffAC": 
				if(response.strAccountCode=='Invalid Code')
	        	{
	        		alert("Invalid Account Code");
	        		$("#txtRoundingOffACCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtRoundingOffACCode").val(response.strAccountCode);
		        	$("#txtRoundingOffACName").val(response.strAccountName);
		        	$("#txtRoundingOffACName").focus();		
	        	}
				 break;
			case "reservationAdvPartyAC": 
				if(response.strAccountCode=='Invalid Code')
	        	{
	        		alert("Invalid Account Code");
	        		$("#txtReservationAdvPartyACCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtReservationAdvPartyACCode").val(response.strAccountCode);
		        	$("#txtReservationAdvPartyACName").val(response.strAccountName);
		        	$("#txtReservationAdvPartyACName").focus();		
	        	}
				 break;
			case "roomAdvAC": 
				if(response.strAccountCode=='Invalid Code')
	        	{
	        		alert("Invalid Account Code");
	        		$("#txtRoomAdvACCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtRoomAdvACCode").val(response.strAccountCode);
		        	$("#txtRoomAdvACName").val(response.strAccountName);
		        	$("#txtRoomAdvACName").focus();		
	        	}
				 break;
			case "invoicerAdv": 
				if(response.strAccountCode=='Invalid Code')
	        	{
	        		alert("Invalid Account Code");
	        		$("#txtInvoicerAdvCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtInvoicerAdvCode").val(response.strAccountCode);
		        	$("#txtInvoicerAdvName").val(response.strAccountName);
		        	$("#txtInvoicerAdvName").focus();		
	        	}
				 break;
			case "onlineNEFTAC": 
				if(response.strAccountCode=='Invalid Code')
	        	{
	        		alert("Invalid Account Code");
	        		$("#txtOnlineNEFTACCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtOnlineNEFTACCode").val(response.strAccountCode);
		        	$("#txtOnlineNEFTACName").val(response.strAccountName);
		        	$("#txtOnlineNEFTACName").focus();		
	        	}
				 break;
			case "roomAC": 
				if(response.strAccountCode=='Invalid Code')
	        	{
	        		alert("Invalid Account Code");
	        		$("#txtRoomACCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtRoomACCode").val(response.strAccountCode);
		        	$("#txtRoomACName").val(response.strAccountName);
		        	$("#txtRoomACName").focus();		
	        	}
				 break;
			case "postDatedAdvAC": 
				if(response.strAccountCode=='Invalid Code')
	        	{
	        		alert("Invalid Account Code");
	        		$("#txtPostDatedChequeACCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtPostDatedChequeACCode").val(response.strAccountCode);
		        	$("#txtPostDatedChequeACName").val(response.strAccountName);
		        	$("#txtPostDatedChequeACName").focus();		
	        	}
				 break;
			case "ecsBank": 
				if(response.strAccountCode=='Invalid Code')
	        	{
	        		alert("Invalid Account Code");
	        		$("#txtECSBankCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtECSBankCode").val(response.strAccountCode);
		        	$("#txtECSBankName").val(response.strAccountName);
		        	$("#txtECSBankName").focus();		
	        	}
				 break;	 
			case "defaultSanction": 
				if(response.strAccountCode=='Invalid Code')
	        	{
	        		alert("Invalid Account Code");
	        		$("#txtDefaultSanctionCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtDefaultSanctionCode").val(response.strAccountCode);
		        	$("#txtDefaultSanctionName").val(response.strAccountName);
		        	$("#txtDefaultSanctionName").focus();		
	        	}
				 break;	
			case "debtorLedgerAC": 
				if(response.strAccountCode=='Invalid Code')
	        	{
	        		alert("Invalid Account Code");
	        		$("#txtDebtorLedgerACCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtDebtorLedgerACCode").val(response.strAccountCode);
		        	$("#txtDebtorLedgerACName").val(response.strAccountName);
		        	$("#txtDebtorLedgerACName").focus();		
	        	}
				 break;	 
			case "advAC": 
				if(response.strAccountCode=='Invalid Code')
	        	{
	        		alert("Invalid Account Code");
	        		$("#txtAdvACCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtAdvACCode").val(response.strAccountCode);
		        	$("#txtAdvACName").val(response.strAccountName);
		        	$("#txtAdvACName").focus();		
	        	}
				 break;	 
		}
	}
	
	function funLoadAccountMaster(accountCode)
	{	    
		var searchurl=getContextPath()+"/loadAccountMasterData.html?accountCode="+accountCode;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	setAccountCodeAndName(response);
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
		funLoadAccountMaster(code);
	}
	
	/* to set account type */
	function funSetACType(accountName)
	{
		accountType=accountName;
		funHelp("accountCode");
	}
	
	/* set date values */
	function funSetDate(dteRevenuePostedUpToDate,responseValue)
	{
		var id=dteRevenuePostedUpToDate;
		var value=responseValue;
		var date=responseValue.split(" ")[0];
		
		var y=date.split("-")[0];
		var m=date.split("-")[1];
		var d=date.split("-")[2];
		
		$(id).val(d+"-"+m+"-"+y);
		
	}
	
	/* To check and Set CheckBox Value To Y/N */
	function funSetCheckStatusAndValue(currentCheckBox,flag)
	{			    
		var value=flag;
	    if(value=="Y")
	    {  
	    	$(currentCheckBox).prop("checked",true);
	    	$(currentCheckBox).val("Y");
        }
	    else	    
        {         
	    	$(currentCheckBox).prop("checked",false);
	    	$(currentCheckBox).val("N");
        }	    		    	   
	}	
	
	function funLoadAndFillFormData()
	{	  
		var searchurl=getContextPath()+"/loadParameterSetupData.html";
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {			        	
						$("#txtAccountNarrationJV").val(response.strAcctNarrJv);
						$("#txtAccountNarrationJVPay").val(response.strAcctNarrPay);
						$("#txtAccountNarrationJVReceipt").val(response.strAcctNarrRec);
					/* 	$("#").val(response.strAdAgeLimit);
						$("#").val(response.strAdultAgeLimit);
						$("#").val(response.strAdultGuest);
						$("#").val(response.strAdultMember); */
						$("#txtAdvACCode").val(response.strAdvanceACCode);
						$("#txtAdvACName").val(response.strAdvanceAcct);
						/* $("#").val(response.strAIMS);	 */																	
						funSetCheckStatusAndValue(chkAmadeusInterfaceYN,response.strAmadeusInterface);
						/* $("#").val(response.strApDebtorReceiptEntry);
						$("#").val(response.strAPECSBankCode);
						$("#").val(response.strAPJVEntry);
						$("#").val(response.strAPPaymentEntry);
						$("#").val(response.strAPReceiptEntry);
						$("#").val(response.strAutoGenCode); */
						$("#txtDebtorBillableACCode").val(response.strBillableCode);
						$("#txtDebtorBillableACName").val(response.strBillableName);
						
						$("#txtBillPrefix").val(response.strBillPrefix);
						/* $("#").val(response.strCashFlowCode);
						$("#").val(response.strCategoryCode);
						$("#").val(response.strChildGuest);
						$("#").val(response.strChildMember);
						$("#").val(response.strclientid); */
						$("#txtDebtorControlACCode").val(response.strControlCode);																
						$("#txtDebtorControlACName").val(response.strControlName);
			
						funSetCheckStatusAndValue(chkCreditLimitCtlYN,response.strCreditLimit);
						/* $("#").val(response.strCreditorControlAccount);
						$("#").val(response.strCreditorLedgerAccount);
						$("#").val(response.strCRM); */
						$("#txtDebtorCurrencyAmtUnit").val(response.strCurrencyCode);
						$("#txtDebtorCurrencyAmt").val(response.strCurrencyDesc);
					/* 	$("#").val(response.strCustImgPath);
						$("#").val(response.strDatabase);
						$("#").val(responseresponse.strDbServer()); */
						$("#txtRoomACCode").val(response.strDbtRoomACCode);
						$("#txtRoomACName").val(response.strDbtRoomACName);
						$("#txtRoomAdvACCode").val(response.strDbtRoomAdvCode);
						$("#txtRoomAdvACName").val(response.strDbtRoomAdvName);
						
						$("#txtDebtorSuspenseACCode").val(response.strDbtrSuspAcctCode);					
						$("#txtDebtorSuspenseACName").val(response.strDbtrSuspAcctName);
						
						$("#txtDebtorLedgerACCode").val(response.strDebtorLedgerACCode);
						$("#txtDebtorLedgerACName").val(response.strDebtorLedgerACName);
						/* $("#").val(response.strDebtorAck); */
						$("#txtDebtorNarrationJV").val(response.strDebtorNarrJv);
						/* $("#").val(response.strDebtorNarrPay);
						$("#").val(response.strDebtorNarrRec);
						$("#").val(response.strDebtorPreProfiling); */
						$("#txtECSBankCode").val(response.strECSBankcode);
						$("#txtECSBankName").val(response.strECSBankName);
						$("#txtECSLetterCode").val(response.strEcsLetterCode);
						$("#txtBccEmailId").val(response.strEmailBcc);
						$("#txtCcEmailId").val(response.strEmailCc);
						$("#txtFromEmailId").val(response.strEmailFrom);
						$("#txtPortNo").val(response.strEmailSMTPPort);
						$("#txtEmailSMTPServerId").val(response.strEmailSmtpServer);				
				/* 		$("#").val(response.strExportType);
						$("#").val(response.strGolfFac);
						$("#").val(response.strGroupCode);	 */								
						funSetCheckStatusAndValue(chkIntegrityCheckYN,response.strIntegrityChk);
						$("#cmbInvoiceBasedOn").val(response.strInvoiceBasedOn);					
		/* 				$("#").val(response.strInvoiceNarrRec); */
						$("#txtInvoicerAdvCode").val(response.strInvoicerAdvCode);	
						$("#txtInvoicerAdvName").val(response.strInvoicerAdvName);									
						funSetCheckStatusAndValue(chkBlockJVEntryYN,response.strjventry);
						$("#txtInvoiceHeader1").val(response.strInvoiceHeader1);
						$("#txtInvoiceHeader2").val(response.strInvoiceHeader2);
						$("#txtInvoiceHeader3").val(response.strInvoiceHeader3);
						$("#txtInvoiceFooter1").val(response.strInvoiceFooter1);
						$("#txtInvoiceFooter2").val(response.strInvoiceFooter2);
						$("#txtInvoiceFooter3").val(response.strInvoiceFooter3);	
/* 						
						$("#").val(response.strLabelsetting);
						$("#").val(response.strLastCreated); */
						$("#txtInvoiceLetterCode").val(response.strLetterCode);
						$("#txtReminderLetterCodePrefix").val(response.strLetterPrefix);
/* 						$("#").val(response.strLogo); */
						funSetCheckStatusAndValue(chkMasterDrivenNarrationYN,response.strMasterDrivenNarration);
						/* $("#").val(response.strMemberPreProfiling);		 */								
						funSetCheckStatusAndValue(chkBlockMemberReceiptYN,response.strmembrecp);			
						funSetCheckStatusAndValue(chkActivateJourVoucherNarrJVYN,response.strNarrActivateJv);			
						funSetCheckStatusAndValue(chkActivateJourVoucherNarrPayYN,response.strNarrActivatePay);			
						funSetCheckStatusAndValue(chkActivateJourVoucherNarrReceiptYN,response.strNarrActivateRec);			
						funSetCheckStatusAndValue(chkActivateJourVoucherNarrInvoiceYN,response.strNarrActivateInv);
						$("#txtPassword").val(response.strPassword);									
						funSetCheckStatusAndValue(chkBlockPaymentEntryYN,response.strpayentry);
	/* 					$("#").val(response.strPettyCashAccountCode);
						$("#").val(response.strPMS); */
						$("#txtCommonDBName").val(response.strPOSCommonDB);
						$("#txtMSDNDBName").val(response.strPOSMSDNdb);			
						$("#txtQFileDBName").val(response.strPOSQfileDB);						
						$("#txtPostDatedChequeACCode").val(response.strPostDatedChequeACCode);			
						$("#txtPostDatedChequeACName").val(response.strPostDatedChequeACName);						
					/* 	$("#").val(response.strpropertyid);
						$("#").val(response.strReceiptBcc);
						$("#").val(response.strReceiptCc); */
						$("#txtReceiptLetterCode").val(response.strReceiptLetterCode);									
						funSetCheckStatusAndValue(chkBlockReceiptEntryYN,response.strrecpentry);
						$("#txtReservationAdvPartyACCode").val(response.strReserveAccCode);
						$("#txtReservationAdvPartyACName").val(response.strReserveAccName);
						$("#txtRoundingOffACCode").val(response.strRoundingCode);
						$("#txtRoundingOffACName").val(response.strRoundingName);
/* 						$("#").val(response.strRoundOffCode); */
						$("#txtDefaultSanctionCode").val(response.strSancCode);
						$("#txtDefaultSanctionName").val(response.strSancName);
			/* 			$("#").val(response.strServiceTaxAccount);			
						$("#").val(response.strSmtpPassword);
						$("#").val(response.strSmtpUserid);	 */									
						funSetCheckStatusAndValue(chkSSLRequiredYN,response.strSSLRequiredYN);
						$("#txtDebtorsSuspenseCode").val(response.strSuspenceCode);				
						$("#txtDebtorsSuspenseName").val(response.strSuspenceName);
						
						funSetCheckStatusAndValue(chkTallyAlifTransLockYN,response.strTallyAlifTransLockYN);
	/* 					$("#").val(response.strTaxCode); */
						$("#cmbTAXIndicatorInTransYN").val(response.strTaxIndicator);
/* 						$("#").val(response.strTypeOfPOsting); */
						$("#txtUserId").val(response.strUserid);
						$("#txtVoucherNarrationJV").val(response.strVouchNarrJv);
						$("#txtVoucherNarrationPay").val(response.strVouchNarrPay);
						$("#txtVoucherNarrationReceipt").val(response.strVouchNarrRec);
						$("#txtVoucherNarrationInvoice").val(response.strVouchNarrInvoice);
/* 						$("#").val(response.strYeaOutsta);	 */											
						funSetCheckStatusAndValue(chkSingleUserYN,response.allowSingleUserLogin);						
						
						/* $("#dteLastARTransDate").val(response.DteLastAR);						
						$("#dteRevenueTransDate").val(response.DteLastRV);								
						$("#dteRevenuePostedUpToDate").val(response.DteRVPosted); */																							
						
						funSetDate(dteLastARTransDate,response.dteLastAR);
						funSetDate(dteRevenueTransDate,response.dteLastRV);
						funSetDate(dteRevenuePostedUpToDate,response.dteRVPosted);
						
		/* 				$("#").val(objGlobal.funCurrentDate("yyyy-MM-dd"));		 */									
						funSetCheckStatusAndValue(chkEmailViaOutlookYN,response.emailViaOutlook);						
						funSetCheckStatusAndValue(chkIncludeBanquetMemberYN,response.includeBanquetMember);			
						funSetCheckStatusAndValue(chkMSOfficeInstalledYN,response.isMSOfficeInstalled);		
						funSetCheckStatusAndValue(chkMultipleDebtorYN,response.isMultipleDebtor);
						$("#txtOnlineNEFTACCode").val(response.neftonlineAccountCode);
						$("#txtOnlineNEFTACName").val(response.neftonlineAccountName);
						$("#txtPettyCash").val(response.dblPettyAmt);
						$("#strShowPLRevenue").val(response.strShowPLRevenue);
						
						
					/* 	$("#").val(response.PDCAccountCode);
						$("#").val(response.PDCAccountDesc);
						$("#").val(response.sML); */		        	
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
		
	/* To load and fill all data on the form when form open */
 	$(document).ready(function()
	{
		funLoadAndFillFormData();		
	}); 
	
	function funIconified()
	{	    
	   var cl=$("#btnIconified").attr("class"); 	   
	   
	   if(cl=="btnMaximize")
	   {
	       $("#btnIconified").removeClass("btnMaximize");		
	       $("#btnIconified").addClass("btnMinimize");	
	       $("#divBox").fadeToggle("fast","linear");
	       $("#thTittleBar").text("Reco Report Parameters (Show Details)");
	       
	   }	   
	   else
	   {
	       $("#btnIconified").removeClass("btnMinimize");		
	       $("#btnIconified").addClass("btnMaximize");
	       $("#divBox").fadeToggle("fast","linear");
	       $("#thTittleBar").text("Reco Report Parameters (Hide Details)");
	       
	   }	
	   /* $("#divBox").fadeIn(); */
	   /* $("#divBox").fadeOut(); */
	   /* $("#divBox").slideToggle("fast"); */ 
	}
	
	/* To Disable spellcheck For All TextArea Of Class .txtTextArea */
	$(document).ready(function()
	{
	    $(".txtTextArea").each(function(index,element)
	    {
	   		var textArea=element;
       		textArea.spellcheck = false;
	   	});    
	});
	
	/* To Set CheckBox Value To Y/N */
	function funSetCheckBoxValueYN(currentCheckBox)
	{		
	    var isSelected="N";
	    if($(currentCheckBox).prop("checked") == true)
	    {           
	        isSelected="Y";
        }
	    if($(currentCheckBox).prop("checked") == false)
        {         
	        isSelected="N";
        }
	    $(currentCheckBox).val(isSelected);		    	   
	}	
	
	/* For All Dates */
	$(document).ready(function()
	{
	    $("#dteLastARTransDate").datepicker(
	    {
			dateFormat : 'dd-mm-yy'
		});
		$("#dteLastARTransDate").datepicker('setDate', 'today');

		$("#dteRevenueTransDate").datepicker(
		{
			dateFormat : 'dd-mm-yy'
		});
		$("#dteRevenueTransDate").datepicker('setDate', 'today');
		
		$("#dteRevenuePostedUpToDate").datepicker(
		{
			dateFormat : 'dd-mm-yy'
		});
		$("#dteRevenuePostedUpToDate").datepicker('setDate', 'today');    		
				
	});
	
	/* For Show Tabs */
	$(document).ready(function()
	{	   
	    $(".tab_conents").hide();
	    $(".tab_conents:first").show();
	    $(".tabs li").click(function()
	    {	       
	       $("ul.tabs li").removeClass("active"); 
	       $(this).addClass("active");
	       $(".tab_conents").hide();
	       var currentTab=$(this).attr("data-state");
	       $("#"+currentTab).fadeIn();
	    });
	});
	
	function funHelp(transactionName)
	{
		fieldName=transactionName;
	//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
	/**
	* Success Message After Saving Record
	**/
	 $(document).ready(function()
				{
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

		funLoadAndFillFormData();		
	});
	
</script>

</head>
<body>
   <div class="container masterTable">
	<label id="formHeading">Parameter Setup</label>
	<s:form name="ParameterSetup" method="POST" action="saveParameterSetup.html" >
        <!-- table which holds all tabs header -->
		
			<div class="row">
				<div id="tab_container" style="height: 100%;">
					<ul class="tabs" >
						<li class="active" data-state="tab1" style="width: 23.5%; ">AR Parameters</li>
						<li data-state="tab2" style="width: 23.5%; ">Invoicing Parameters</li>
						<li data-state="tab3" style="width: 23.5%; ">Narration Builder</li>
						<li data-state="tab4" style="width: 23.5%; ">Email Settings</li>						
					</ul>
				</div>
        <br>
        <br>
        
        <!-- AR Parameters Tab -->
        <div id="tab1" class="tab_conents">
        	<div class="row">
        		<div class="col-md-6"><label>Debtor Control A/C</label>
			    	<div class="row">
        				<div class="col-md-6"><s:input id="txtDebtorControlACCode" path="strControlCode" readonly="true" ondblclick="funSetACType('debtorControlAC')" cssClass="searchTextBox"/></div>			        			        
			    		<div class="col-md-6"><s:input id="txtDebtorControlACName" path="strControlName" cssClass="longTextBox" cssStyle="width:96%"/></div>			    				    		        			  
				</div></div>
				
				<div class="col-md-6"><label>Debtor Billable A/C</label>
			    	<div class="row">
        				<div class="col-md-6"><s:input id="txtDebtorBillableACCode" path="strBillableCode" readonly="true" ondblclick="funSetACType('debtorBillableAC')" cssClass="searchTextBox"/></div>			        			        
			    		<div class="col-md-6"><s:input id="txtDebtorBillableACName" path="strBillableName" cssClass="longTextBox" cssStyle="width:96%"/></div>			    		        			   
				</div></div>
				
				<div class="col-md-6"><label>Debtor Suspense A/C</label>
			    	<div class="row">
        				<div class="col-md-6"><s:input id="txtDebtorSuspenseACCode" path="strDbtrSuspAcctCode" readonly="true" ondblclick="funSetACType('debtorSuspenseAC')" cssClass="searchTextBox"/></div>			        			        
			    		<div class="col-md-6"><s:input id="txtDebtorSuspenseACName" path="strDbtrSuspAcctName" cssClass="longTextBox" cssStyle="width:96%"/></div>			    		        			   
				</div></div>	
																		
				<div class="col-md-6"><label>Debtors Suspense Code</label>
			    	<div class="row">
        				<div class="col-md-6"><s:input id="txtDebtorsSuspenseCode" path="strSuspenceCode" readonly="true" ondblclick="funSetACType('debtorSuspenseCode')" cssClass="searchTextBox"/></div>			        			        
			    		<div class="col-md-6"><s:input id="txtDebtorsSuspenseName" path="strSuspenceName" cssClass="longTextBox" cssStyle="width:96%"/></div>			    		        			   
				</div></div>
				
				<div class="col-md-6"><label>Rounding Off A/C</label>
			    	<div class="row">
        				<div class="col-md-6"><s:input id="txtRoundingOffACCode" path="strRoundingCode" readonly="true" ondblclick="funSetACType('roundingOffAC')" cssClass="searchTextBox"/></div>			        			        
			    		<div class="col-md-6"><s:input id="txtRoundingOffACName" path="strRoundingName" cssClass="longTextBox" cssStyle="width:96%"/></div>			    		        			   
				</div></div>
				
				<div class="col-md-6"><label>Reservation Advance Party A/C</label>
			    	<div class="row">
        				<div class="col-md-6"><s:input id="txtReservationAdvPartyACCode" path="strReserveAccCode" readonly="true" ondblclick="funSetACType('reservationAdvPartyAC')" cssClass="searchTextBox"/></div>			        			        
			    		<div class="col-md-6"><s:input id="txtReservationAdvPartyACName" path="strReserveAccName" cssClass="longTextBox" cssStyle="width:96%"/></div>			    		        			   
				</div></div>
				
				<div class="col-md-6"><label>Room Advance A/C</label>
			    	<div class="row">
        				<div class="col-md-6"><s:input id="txtRoomAdvACCode" path="strDbtRoomAdvCode" readonly="true" ondblclick="funSetACType('roomAdvAC')" cssClass="searchTextBox"/></div>			        			        
			    		<div class="col-md-6"><s:input id="txtRoomAdvACName" path="strDbtRoomAdvName" cssClass="longTextBox" cssStyle="width:96%"/></div>			    		        			   
				</div></div>
				
				<div class="col-md-6"><label>Invoicer Advance </label>
			    	<div class="row">
        				<div class="col-md-6"><s:input id="txtInvoicerAdvCode" path="strInvoicerAdvCode" readonly="true" ondblclick="funSetACType('invoicerAdv')" cssClass="searchTextBox"/></div>			        			        
			    		<div class="col-md-6"><s:input id="txtInvoicerAdvName" path="strInvoicerAdvName" cssClass="longTextBox" cssStyle="width:96%"/></div>			    		        			   
				</div></div>
				
				<div class="col-md-6"><label>Online NEFT A/C Code</label>
			    	<div class="row">
        				<div class="col-md-6"><s:input id="txtOnlineNEFTACCode" path="NEFTOnlineAccountCode" readonly="true" ondblclick="funSetACType('onlineNEFTAC')" cssClass="searchTextBox"/></div>			        			        
			    		<div class="col-md-6"><s:input id="txtOnlineNEFTACName" path="NEFTOnlineAccountName" cssClass="longTextBox" cssStyle="width:96%"/></div>			    		        			   
				</div></div>
				
				<div class="col-md-6"><label>Room A/C</label>
			    	<div class="row">
        				<div class="col-md-6"><s:input id="txtRoomACCode" path="strDbtRoomACCode" readonly="true" ondblclick="funSetACType('roomAC')" cssClass="searchTextBox"/></div>			        			        
			    		<div class="col-md-6"><s:input id="txtRoomACName" path="strDbtRoomACName" cssClass="longTextBox" cssStyle="width:96%"/></div>			    		        			   
				</div></div>
				
				<div class="col-md-6"><label>Post Dated Cheque A/C</label>
			    	<div class="row">
        				<div class="col-md-6"><s:input id="txtPostDatedChequeACCode" path="strPostDatedChequeACCode" readonly="true" ondblclick="funSetACType('postDatedAdvAC')" cssClass="searchTextBox"/></div>			        			        
			    		<div class="col-md-6"><s:input id="txtPostDatedChequeACName" path="strPostDatedChequeACName" cssClass="longTextBox" cssStyle="width:96%"/></div>			    		        			   
				</div></div>
				
				<div class="col-md-6"><label>ECS Bank</label>
			    	<div class="row">
        				<div class="col-md-6"><s:input id="txtECSBankCode" path="strECSBankcode" readonly="true" ondblclick="funSetACType('ecsBank')" cssClass="searchTextBox"/></div>		        			        
			    	    <div class="col-md-6"><s:input id="txtECSBankName" path="strECSBankName" cssClass="longTextBox" cssStyle="width:96%"/></div>			    		        			   
				</div></div>
				
				<div class="col-md-6"><label>Default Sanction</label>
			    	<div class="row">
        				<div class="col-md-6"><s:input id="txtDefaultSanctionCode" path="strSancCode" readonly="true" ondblclick="funSetACType('defaultSanction')" cssClass="searchTextBox"/></div>			        			        
			    		<div class="col-md-6"><s:input id="txtDefaultSanctionName" path="strSancName" cssClass="longTextBox" cssStyle="width:96%"/></div>			    		        			   
				</div></div>
				
				<div class="col-md-3"><label>Reminder Letter Code Prefix</label>
			    	 	<s:input id="txtReminderLetterCodePrefix" path="strLetterPrefix"  cssClass="simpleTextBox" style="width:100%" />			        			        			    				    		        			  
				</div>
				
				<div class="col-md-3"><label>Debtor Currency</label>
			    <div class="row">
			    			<div class="col-md-6"><s:input id="txtDebtorCurrencyAmt" path="strCurrencyDesc" placeholder="Amount" cssClass="simpleTextBox" style="width: 100%" /></div>				        			        
			    			<div class="col-md-6"><s:input id="txtDebtorCurrencyAmtUnit" path="strCurrencyCode" placeholder="Rs. / CR / $ / etc." cssClass="longTextBox" cssStyle="width:100%"/></div>				    		        			   
				</div></div>
				
				<div class="col-md-3"><label>Last A/R Transfer Date</label>	
			  	   <s:input type="text" id="dteLastARTransDate" path="dteLastAR"  class="calenderTextBox" style="width:100%; background-position: 240px 4px;" />			   	    		    		 
				</div>
				
				<div class="col-md-3"><label>Revenue Transfer Date</label>	
			   	    <s:input type="text" id="dteRevenueTransDate" path="dteLastRV" class="calenderTextBox"  style="width:100%; background-position: 240px 4px;" />		    		  
				</div>
				
				<div class="col-md-3"><label>Revenue Posted UpTo</label>	
			   	    <s:input type="text" id="dteRevenuePostedUpToDate" path="dteRVPosted"  class="calenderTextBox" style="width:100%; background-position: 240px 4px;" />		    		  
				</div>
				
				<div class="col-md-3"><label>Credit Limit Control</label><br />
			    		<s:checkbox id="chkCreditLimitCtlYN"  path="strCreditLimit" value=""  onclick="funSetCheckBoxValueYN(this)" />			        			        			    				    		        			  
				</div>
				
				<div class="col-md-12" style="height:15px;"></div>
				
				 <div class="col-md-12"><label>Block Transactions For Black Listed Members</label></div>
			    	
			    	<div class="col-md-2"><label>JV Entry</label>
			    		<s:checkbox id="chkBlockJVEntryYN"  path="strjventry" value=""  onclick="funSetCheckBoxValueYN(this)" />
			    	</div>	
			    	
			    	<div class="col-md-2"><label>Payment Entry</label>
			    		<s:checkbox id="chkBlockPaymentEntryYN"  path="strpayentry" value=""  onclick="funSetCheckBoxValueYN(this)" />
			    	</div>
			    	
			    	<div class="col-md-2"><label>Receipt Entry</label>
			    		<s:checkbox id="chkBlockReceiptEntryYN"  path="strrecpentry" value=""  onclick="funSetCheckBoxValueYN(this)" />
			    	</div>
			    	
			    	<div class="col-md-2"><label>Member Receipt</label>
			    		<s:checkbox id="chkBlockMemberReceiptYN"  path="strmembrecp" value=""  onclick="funSetCheckBoxValueYN(this)"/>			        			        			    				    		        			  
				    </div>
				
				<div class="col-md-2"><label>Amadeus PMS Interface</label>
			    		<s:checkbox id="chkAmadeusInterfaceYN"  path="strAmadeusInterface" value=""  onclick="funSetCheckBoxValueYN(this)" />		        			        			    				    		        			  
				</div>
				
				<div class="col-md-12" style="height:15px;"></div>
				
				<div class="col-md-6"><label>Debtor Ledger A/C</label>
				<div class="row">
			    	<div class="col-md-6"><s:input id="txtDebtorLedgerACCode" path="strDebtorLedgerACCode" readonly="true" ondblclick="funSetACType('debtorLedgerAC')" cssClass="searchTextBox"/></div>			        			        
			    	<div class="col-md-6"><s:input id="txtDebtorLedgerACName" path="strDebtorLedgerACName" cssClass="longTextBox" cssStyle="width:96%"/></div>			    		        			   
				</div></div>
				
				<div class="col-md-6"><label>Advance A/C</label>
			    <div class="row">
			    	<div class="col-md-6"><s:input id="txtAdvACCode" path="strAdvanceACCode" readonly="true" ondblclick="funSetACType('advAC')" cssClass="searchTextBox"/></div>		        			        
			    	<div class="col-md-6"><s:input id="txtAdvACName" path="strAdvanceAcct" cssClass="longTextBox" cssStyle="width:96%"/></div>			    		        			   
				</div></div>
				
				<div class="col-md-3"><label>Master Driven Narration</label><br>
			    		<s:checkbox id="chkMasterDrivenNarrationYN"  path="StrMasterDrivenNarration" value=""  onclick="funSetCheckBoxValueYN(this)" />			        			        			    				    		        			  
				</div>
				
				<div class="col-md-3"><label>MS-Office Installed</label><br>
			    		<s:checkbox id="chkMSOfficeInstalledYN"  path="IsMSOfficeInstalled" value=""  onclick="funSetCheckBoxValueYN(this)" />			        			        			    				    		        			  
				</div>
				
				<div class="col-md-3"><label>Include Banquet Member</label><br>
			    		<s:checkbox id="chkIncludeBanquetMemberYN"  path="IncludeBanquetMember" value=""  onclick="funSetCheckBoxValueYN(this)" />		        			        			    				    		        			  
				</div>
				
				<div class="col-md-3"><label>Mupltiple Debtor</label><br>
			    		<s:checkbox id="chkMultipleDebtorYN"  path="IsMultipleDebtor" value=""  onclick="funSetCheckBoxValueYN(this)" />			        			        			    				    		        			  
				</div>
				<br><br>
				<div class="col-md-3"><label>Single User Login</label><br>
			    		<s:checkbox id="chkSingleUserYN"  path="AllowSingleUserLogin" value=""  onclick="funSetCheckBoxValueYN(this)" />			        			        			    				    		        			  
				</div>
				
				<div class="col-md-3"><label>Email Via Outlook</label><br>
			    		<s:checkbox id="chkEmailViaOutlookYN"  path="EmailViaOutlook" value=""  onclick="funSetCheckBoxValueYN(this)" />		        			        			    				    		        			  
				</div>
				
				<div class="col-md-3"><label>Tally/Alif Transaction Lock</label><br>
			    		<s:checkbox id="chkTallyAlifTransLockYN"  path="strTallyAlifTransLockYN" value=""  onclick="funSetCheckBoxValueYN(this)" />			        			        			    				    		        			  
				</div>
				
				<div class="col-md-3"><label>Stock In Hand Code</label><br>
        				<s:input id="txtstckInHandCode" path="strStockInHandAccCode" cssClass="longTextBox"  /><%-- cssClass="longTextBox" --%>
        		</div>
        		
        		<div class="col-md-12" style="height:15px;"></div>
        		
        		<div class="col-md-3"><label>Stock In Hand Name</label>
        				<s:input id="txtstckInHandName" path="strStockInHandAccName" cssClass="longTextBox"  /><%-- cssClass="longTextBox" --%>
        		</div>
        		
        		<div class="col-md-3"><label>Closing Stock(P & I) Code</label>
        	 			<s:input id="txtstckInHandCode" path="strClosingCode" cssClass="longTextBox"  /><%-- cssClass="longTextBox" --%>
        		</div>
        		
        		<div class="col-md-3"><label>Closing Stock Name</label>
        		         <s:input id="txtstckInHandName" path="strClosingName" cssClass="longTextBox"  /><%-- cssClass="longTextBox" --%>
        		</div>
        		
        		<div class="col-md-3"><label>Petty Cash</label>
        				<s:input id="txtPettyCash" path="" class="decimal-places numberField"  value="0"  />
        		</div>																							<%-- cssClass="longTextBox" --%>
        			
        		<div class="col-md-3"><label>Show P/L Revenue Data </label>
        			 <s:select path="strShowPLRevenue" id="txtShowPLRevenue" cssClass="BoxW48px" cssStyle="width:100%">
					         <s:option selected="selected" value="POS">POS Revenue</s:option>
					         <s:option  value="Invoice">Invoice</s:option>
					</s:select>
				</div>
					
<!--         		<td colspan="1"></td> -->
        	</div>
        </div>
        <!-- Invoicing Parameters Tab -->
        <div id="tab2" class="tab_conents">
        	<div class="row">
        		<div class="col-md-3"><label>Invoice Header 1</label>
        		       <s:textarea id="txtInvoiceHeader1" path="strInvoiceHeader1" class="txtTextArea"  style="border:none;"/><%-- cssClass="longTextBox" --%>
        		</div>
        		
        		<div class="col-md-3"><label>Invoice Header 2</label>
        			   <s:textarea id="txtInvoiceHeader2" path="strInvoiceHeader2" class="txtTextArea"  style="border:none;"/><%-- cssClass="longTextBox" --%>
        		</div>
        		
        		<div class="col-md-3"><label>Invoice Header 3</label>
        			   <s:textarea id="txtInvoiceHeader3" path="strInvoiceHeader3" class="txtTextArea"  style="border:none;"/><%-- cssClass="longTextBox" --%>
        		</div>
        		
        		<div class="col-md-3"><label>Invoice Footer 1</label>
        		       <s:textarea id="txtInvoiceFooter1" path="strInvoiceFooter1" class="txtTextArea"  style="border:none;" /><%-- cssClass="longTextBox" --%>
        		</div>
        		
        		<div class="col-md-3"><label>Invoice Footer 2</label>
        			   <s:textarea id="txtInvoiceFooter2" path="strInvoiceFooter2" class="txtTextArea"  style="border:none;"/><%-- cssClass="longTextBox" --%>
        		</div>
        		
        		<div class="col-md-3"><label>Invoice Footer 3</label>
        				<s:textarea id="txtInvoiceFooter3" path="strInvoiceFooter3" class="txtTextArea"  style="border:none;"/><%-- cssClass="longTextBox" --%>
        		</div>
        		
        		<div class="col-md-3"><label>Invoice Based On</label>
        				<s:select id="cmbInvoiceBasedOn" path="strInvoiceBasedOn" items="${listInvoiceBasedOn}" cssClass="BoxW124px" />
        		</div>
        		
        		<div class="col-md-3"><label>Bill Prefix</label>
			    		<s:input id="txtBillPrefix" path="strBillPrefix" cssClass="simpleTextBox" style="width: 100%" />			        			        			    				    		        			  
				</div>
				
				<div class="col-md-3"><label>TAX Indiactor In Transaction</label>
        				<s:select id="cmbTAXIndicatorInTransYN" path="strTaxIndicator" items="${listTAXIndicatorInTrans}" cssClass="BoxW124px" />
        		</div>
        		
        		<div class="col-md-3"><label>Integrity Check</label><br>
        				<s:checkbox id="chkIntegrityCheckYN"  path="strIntegrityChk" value=""  onclick="funSetCheckBoxValueYN(this)" />
        		</div>
        		
        		<div class="col-md-4"><label>Common DataBase Name</label>			    				        			       
			 			<s:input id="txtCommonDBName" path="strPOSCommonDB"/>			    		        			   
				</div>
				
				<div class="col-md-4"><label>Q File DataBase Name</label>			    				        			       
			    		<s:input id="txtQFileDBName" path="strPOSQfileDB"/>			    		        			   
				</div>
				
				<div class="col-md-4"><label>MSDN DataBase Name</label>			    				        			       
			    		<s:input id="txtMSDNDBName" path="strPOSMSDNdb"/>			    		        			   
				</div>
        	</div>
        </div>
        <!-- Narration Builder Tab -->
        <div id="tab3" class="tab_conents">
        	<div class="row" id="narrationBuilderTbl">
        	
        		<div class="col-md-12"><label><b> Journal Voucher </b></label>
        		</div>
        		
        		<div class="col-md-3"><label>Voucher Narration</label>
        				<s:textarea id="txtVoucherNarrationJV" path="strVouchNarrJv" class="txtTextArea" style="border:none;"/><%-- cssClass="longTextBox" --%>
        		</div>
        		
        		<div class="col-md-3"><label>Account Narration</label>
        				<s:textarea id="txtAccountNarrationJV" path="strAcctNarrJv" class="txtTextArea" style="border:none;"/><%-- cssClass="longTextBox" --%>
        		</div>
        		
        		<div class="col-md-3"><label>Debtor Narration</label>
        				<s:textarea id="txtDebtorNarrationJV" path="strDebtorNarrJv" class="txtTextArea" style="border:none;" /><%-- cssClass="longTextBox" --%>
        		</div>
        		
        		<div class="col-md-3"><label>Select Parameters</label>
        			   <s:select id="cmbSelectParameters" path="" items="${listSelectParameters}" cssClass="BoxW200px" /> 
        	    </div>  
        	         		
        		<div class="col-md-3"><label>Activate Journal Voucher Narration</label><br>
        				<s:checkbox id="chkActivateJourVoucherNarrJVYN"  path="strNarrActivateJv" value=""  onclick="funSetCheckBoxValueYN(this)" />      		
        		</div> 
        		<br>       		
        		<div class="col-md-12"><label><b> Payments </b></label>
        		</div>
        		
        		<div class="col-md-3"><label>Voucher Narration</label>
        				<s:textarea id="txtVoucherNarrationPay" path="strVouchNarrPay" class="txtTextArea" style="border:none;"/><%-- cssClass="longTextBox" --%>
        		</div>
        		
        		<div class="col-md-3"><label>Select Parameters</label>
        			    <s:select id="cmbPaySelectParameters" path="" items="${listSelectParameters}" cssClass="BoxW200px" /> 
        	     </div>  
        	          		
        		<div class="col-md-3"><label>Activate Payments Narration</label><br>
        			   <s:checkbox id="chkActivateJourVoucherNarrPayYN"  path="strNarrActivatePay" value=""  onclick="funSetCheckBoxValueYN(this)" />        		
        		</div>
        		
        		<div class="col-md-12"><label><b> Receipts </b></label>
        		</div>
        		
        		<div class="col-md-3"><label>Voucher Narration</label>
        			  <s:textarea id="txtVoucherNarrationReceipt" path="strVouchNarrRec" class="txtTextArea" style="border:none;" /><%-- cssClass="longTextBox" --%>
        		</div>
        		
        		<div class="col-md-3"><label>Select Parameters</label>
        			<s:select id="cmbRecptSelectParameters" path="" items="${listSelectParameters}" cssClass="BoxW200px" /> 
        		</div>    
        		  		
        		<div class="col-md-3"><label>Activate Receipts Narration</label><br>
        			<s:checkbox id="chkActivateJourVoucherNarrReceiptYN"  path="strNarrActivateRec" value=""  onclick="funSetCheckBoxValueYN(this)" />        		
        		</div>
        		
        		<div class="col-md-12"><label><b> Invoice </b></label>
        		</div>
        		
        		<div class="col-md-3"><label>Voucher Narration</label>
        				<s:textarea id="txtVoucherNarrationInvoice" path="strVouchNarrInvoice" class="txtTextArea" style="border:none;" /><%-- cssClass="longTextBox" --%>
        		</div>
        		
        		<div class="col-md-3"><label>Select Parameters</label>
        				<s:select id="cmbInvSelectParameters" path="" items="${listSelectParameters}" cssClass="BoxW200px" />    
        		</div>   
        		 		
        		<div class="col-md-3"><label>Activate Invoice Narration</label><br>
        			 <s:checkbox id="chkActivateJourVoucherNarrInvoiceYN"  path="strNarrActivateInv" value=""  onclick="funSetCheckBoxValueYN(this)" />        		
        		</div>
        	</div>
        </div>
        <!-- Email Settings Tab -->
        
        <div id="tab4" class="tab_conents">
        	<div class="row">
        		<div class="col-md-3"><label>SMTP Server ID</label>        						    				        			      
			    		<s:input id="txtEmailSMTPServerId" path="strEmailSmtpServer" cssClass="longTextBox" />			    		        			   				
        		</div>
        		
        		<div class="col-md-3"><label>Is SSL Required</label><br>        						    				        			      
			    		<s:checkbox id="chkSSLRequiredYN"  path="strSSLRequiredYN" value=""  onclick="funSetCheckBoxValueYN(this)" />		        			   				
        		</div>
        		
        		<div class="col-md-3"><label>Port No.</label>       						    				        			      
			    		<s:input id="txtPortNo" path="strEmailSMTPPort" cssClass="longTextBox" />			    		        			   				
        		</div>
        		
        		<div class="col-md-3"><label>User ID</label>       						    				        			      
			    		<s:input id="txtUserId" path="strUserid" cssClass="longTextBox" />			    		        			   				
        		</div>
        		
        		<div class="col-md-3"><label>Password</label>        						    				        			      
			    		<s:password id="txtPassword" path="strPassword" cssClass="longTextBox" />			    		        			   				
        		</div>
        		
        		<div class="col-md-3"><label>From</label>        						    				        			      
			    		<s:input id="txtFromEmailId" path="strEmailFrom" cssClass="longTextBox"/>		
			    		<a href="#">(Show Details...)</a>
			   	</div>
			   	
        		<div class="col-md-3"><label>Cc</label>
        			<s:textarea id="txtCcEmailId" path="strEmailCc" class="txtTextArea" /><%-- cssClass="longTextBox" --%>
        			<label>(Use ; as Seperator)</label>   
        		</div>
        		
        		<div class="col-md-3"><label>Bcc</label>
        			<s:textarea id="txtBccEmailId" path="strEmailBcc" class="txtTextArea" /><%-- cssClass="longTextBox" --%>
        			<label>(Use ; as Seperator)</label>
        		</div>
        		
        		<div class="col-md-6"><label>Invoice Letter Code</label>
			    	<div class="row">
			    		<div class="col-md-6"><s:input id="txtInvoiceLetterCode" path="strLetterCode" readonly="true" ondblclick="funSetACType('')" cssClass="searchTextBox"/></div>		        			        
			    		<div class="col-md-6"><s:input id="txtInvoiceLetterName" path="" readonly="true" cssClass="longTextBox" cssStyle="width:96%"/></div>
					</div>
				</div>
				
				<div class="col-md-6"><label>Receipt Letter Code</label>
			    	<div class="row">
			    		<div class="col-md-6"><s:input id="txtReceiptLetterCode" path="strReceiptLetterCode" readonly="true" ondblclick="funSetACType('')" cssClass="searchTextBox"/></div>			        			        
			    		<div class="col-md-6"><s:input id="txtReceiptLetterName" path="" readonly="true" cssClass="longTextBox" cssStyle="width:96%"/></div>
			    	</div>	
			    </div>
			    
				<div class="col-md-6"><label>ECS Letter Code</label>
			    	<div class="row">
			    		<div class="col-md-6"><s:input id="txtECSLetterCode" path="strEcsLetterCode" readonly="true" ondblclick="funSetACType('')" cssClass="searchTextBox"/></div>			        			        
			    		<div class="col-md-6"><s:input id="txtECSLetterName" path="" readonly="true" cssClass="longTextBox" cssStyle="width:96%"/></div>
			    	</div>
			    </div>
			    
				<div class="col-md-6"><label>Password Protect PDF's</label> <br>      						    				        			      
			    		<s:checkbox id="chkPassProtPDFYN"  path="" value=""  onclick="funSetCheckBoxValueYN(this)" /><br>
			    		<label>Note: Password Format(Membership No + Date Of Birth(ddmmyyyy))</label>
			    </div>        		  	
        	</div>
       <br />  <br /> 
        	     	
        	<table class="masterTable">        		
        		<tr>
        			<th><input type="button" class="btn btn-primary center-block" id="btnIconified" class="btnMaximize" onclick='funIconified()' style="width:100px; height:22px"/></th>
        			<th id="thTittleBar" colspan="2" style="height: 30px;">Reco Report Parameters (Hide Details)</th>
        		</tr>
        		<tr   id="divBox" >                		    	
			    	<td colspan="4">
			    		<div style="height: 150px; " >
			    			<table class="masterTable" style="margin: 0px; width: 100%">
			    				<tr>
				        			<td style="background-color: #c0c0c0"><label>Revenue Posting &amp; JV Reco To Email</label></td>
				        			<td style="background-color: #c0c0c0"><s:textarea id="txtCcEmailId" path="" class="txtTextArea" /></td><!-- cssClass="longTextBox" -->
				        			<td style="background-color: #c0c0c0"><label>(Use ; as Seperator)</label></td>   				        			
				        		</tr>
				        		<tr>
				        			<td><label>Revenue Posting &amp; JV Reco Cc Email</label></td>
				        			<td><s:textarea id="txtBccEmailId" path="" class="txtTextArea" /></td><!-- cssClass="longTextBox" -->
				        			<td><label>(Use ; as Seperator)</label></td>				        			
				        		</tr>
			    			</table>
			    		</div>			    		
			    	</td>				    	      			   			
        		</tr>        		
        	</table>
        </div>        	        
        </div>
		
		<p align="right">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" />&nbsp
			<input type="reset" value="Reset"  class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>
		
	</s:form>
	</div>	
</body>
</html>
