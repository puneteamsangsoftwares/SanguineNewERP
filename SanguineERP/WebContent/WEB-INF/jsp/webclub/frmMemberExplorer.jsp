<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> <!-- charset=ISO-8859-1" pageEncoding="ISO-8859-1"%> -->
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<%-- <script type="text/javascript" src="<spring:url value="/resources/js/hindiTextBox.js"/>"></script> --%>
<title>Member Explorer</title>
<style>
	.ui-autocomplete {
 		max-height: 200px;
   		overflow-y: auto;
   /* prevent horizontal scrollbar */
		overflow-x: hidden;
	/* add padding to account for vertical scrollbar */
		padding-right: 20px;
			}
	/* IE 6 doesn't support max-height
	* we use height instead, but this forces the menu to always be this tall
	*/
	*	html .ui-autocomplete {height: 200px;}
		table{ border-collapse: unset;}
		table .transTable{border:1px solid #000;}
		tr{border:1px solid #000}
		ul.tabs1 li {
			background:none;
			padding: 4px;
			overflow: hidden;
			position: relative;
			color: #88898e;
			font-size: 13px;
			height:21px;
		}
		ul.tabs1 li.active {
			border-bottom: 2px solid #007bff;
			color: #000;
			transition: all 0.9s ease 0s;
		}
 
		
		
		
</style>
			<%-- <script src="http://www.hinkhoj.com/common/js/keyboard.js"></script> --%>
			<%-- <script src="hindiTyping.js"></script> --%>
     <link rel="stylesheet" type="text/css" href="http://www.hinkhoj.com/common/css/keyboard.css" /> 
  
<script type="text/javascript">

/*On form Load It Reset form :Ritesh 22 Nov 2014*/
 $(document).ready(function () {
	 
    resetForms('Member Explorer');
    $("#txtGroupName").focus();
    $(".tab_content").hide();
	$(".tab_content:first").show();
	$("#tab_container").hide();
	$("ul.tabs li").click(function() {
		$("ul.tabs li").removeClass("active");
		$(this).addClass("active");
		$(".tab_content").hide();

		var activeTab = $(this).attr("data-state");
		$("#" + activeTab).fadeIn();
    
    
}); 
	$("ul.tabs1 li").click(function() {
		$("ul.tabs1 li").removeClass("active");
		$(this).addClass("active");
		$(".tab_content1").hide();

		var activeTab = $(this).attr("data-state");
		$("#" + activeTab).fadeIn();
    
    
}); 
	$('#itemImage').attr('src', getContextPath()+"/resources/images/company_Logo.png");
	 funGetImage();
 });
 var clickCount =0.0;
 var fieldName;
 var listRow=0;
 var map = new Map();
 var map1 = new Map();
 var gMemCode='';
/**
 * AutoComplte when user Type the Name then Display Exists Group Name
 */
 $(document).ready(function()
			{
				$("#lblReceived").text(0);		 							
				$("#lblIssued").text(0);
				$(function() {
					
					$("#txtGroupName").autocomplete({
					source: function(request, response)
					{
						var searchUrl=getContextPath()+"/AutoCompletGetGroupName.html";
						$.ajax({
						url: searchUrl,
						type: "POST",
						data: { term: request.term },
						dataType: "json",
							success: function(data) 
							{
								response($.map(data, function(v,i)
								{
									return {
										label: v,
										value: v
										};
								}));
							}
						});
					}
				});
				});
			});


	/**
	* Reset The Group Name TextField
	**/
	function funResetFields()
	{
		
    }
	
	
		/**
		* Open Help
		**/
		function funHelp(transactionName)
		{	       
	       // window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	       fieldName = transactionName;
	       window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	       
	    }
		
		/**
		* Get and Set data from help file and load data Based on Selection Passing Value(Group Code)
		**/
		function funSetData(code)
		{
			switch(fieldName)
			{			
				case "WCMemberCode":
					funSetMemberDataReceived(code);
					break;			
				
				case 'WCmemProfileCustomer' :
					funloadMemberData(code);
					funloadMemberWiseFieldData(code);
					funShowAttachDocumentsCount(code);
					break;				
			}
		}
		
		
		function funCallFormAction(actionName,object) 
		{
			if($("#txtCustCode").val().trim().length<1)
			{
				alert("Enter Member Code");
				$("#txtCustCode").focus();				
			}
			else
			{	
				$("#tab_container").show();
				$("#txtAttachedDocCount").css("display","block");
			}
			return false;
		}
		
		function funPrintForm() 
		{
			if($("#txtCustCode").val().trim().length<1)
			{
				alert("Select Member Code");
				$("#txtCustCode").focus();				
			}
			else{			
					window.open(getContextPath()+"/printMeberData.html?memberCode="+gMemCode,'_blank');		
			}
			return false;
		}
		
		 function funShowImagePreview(input)
		 {
			 if (input.files && input.files[0])
			 {
				 var filerdr = new FileReader();
				 filerdr.onloadend = function(event) 
				 {
				 	$('#memImage').attr('src', event.target.result);
				 }
				 filerdr.readAsDataURL(input.files[0]);
			 }
		 }

		 function funGetImage()
			{
				var code = $("#txtCustCode").val();
				searchUrl=getContextPath()+"/loadImage.html?custCode="+code;
				$("#itemImage").attr('src', searchUrl);
			}
		 
		 function funSetMemberData(response)
		 {			 
			 var address = response.strResidentAddressLine1+" "+response.strResidentAddressLine2+" "+
			 response.strResidentAddressLine3+" "+response.strResidentAreaCode+" "+response.strResidentCountryCode;
			 $("#txtMCName").text(response.strFullName);
			 $("#txtEmailId").text(response.strResidentEmailID);
			 $("#txtMobNo").text(response.strResidentMobileNo);
			 $("#txtAddress").text(address);
			 $("#txtDob").text(response.dteDateofBirth);
			 $("#txtMemStartDate").text(response.dteMembershipStartDate);
			 $("#txtMemExpiryDate").text(response.dteMembershipExpiryDate);			 
			 $("#tblExplorer").css("display","block");
		 }
		 
		 function funSetMemberDataReceived(code){
			 resetTables(); 
			 $("#txtFacilityCode").val(code);
				var searchurl=getContextPath()+"/loadWebClubMemberProfileData.html?primaryCode="+code;
				//alert(searchurl);
				 $.ajax({
					        type: "GET",
					        url: searchurl,
					        dataType: "json",
					        success: function(response)
					        {
					        	if(response.strFacilityCode=='Invalid Code')
					        	{
					        		alert("Invalid Category Code");
					        		
					        	}
					        	else
					        	{
					        		//$("#txtCustCode").val(response[0].strMemberCode);	 
						        	//$("#lblMemCode").text(response[0].strFirstName);
					        	}
					        	funSetMemberTableReceived(response[0].strMemberCode);
					        	funGetFieldsMemberWise(response[0].strMemberCode);
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
		 
		 function funSetMemberTableReceived(code)
		 {
			 var searchurl=getContextPath()+"/loadPDCMemberWiseData.html?memCode="+code;
				 $.ajax({
					        type: "GET",
					        url: searchurl,
					        dataType: "json",
					        success: function(response)
					        {
					        	if(response.strFacilityCode=='Invalid Code')
					        	{
					        		alert("Invalid Member Code");
					        		$("#txtMemCode").val('');
					        	}
					        	else
					        	{
					        		
					        		var table=document.getElementById("tblDetails");
					    			var rowCount=table.rows.length;
					    			while(rowCount>0)
					    			{
					    			   table.deleteRow(0);
					    			   rowCount--;
					    			} 
					    			
					    			 var table1=document.getElementById("tblDetailss");
						    			var rowCount1=table1.rows.length;
						    			while(rowCount1>0)
						    			{
						    			   table1.deleteRow(0);
						    			   rowCount1--;
						    			} 
					    			var totRec;
					    			var totIssu;
					        		$.each(response, function(cnt,item)
						 					{
					        					
					        					//$("#txtMemCode").val(item[0]);
					        					if(item.strType=="Received")
					        						{
					        							funAddRowReceived(item.strMemName,item.strDrawnOn,item.strChequeNo,item.dteChequeDate,item.dblChequeAmt);
					        							totRec= parseInt($("#lblReceived").text())+parseInt(item.dblChequeAmt);
					        						    $("#lblReceived").text(totRec);
					        						}
					        					else
					        						{
					        							funAddRowIssued(item.strMemName,item.strDrawnOn,item.strChequeNo,item.dteChequeDate,item.dblChequeAmt);
					        							totIssu= parseInt($("#lblIssued").text())+parseInt(item.dblChequeAmt);
					        										    $("#lblIssued").text(totIssu);
					        						}	
								      		});		
					        		//$("#txtMemCode").val(code);	 						        						        	
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
		 
		 function funGetFieldsMemberWise(code){
			 resetTables(); 
			// $("#txtFacilityCode").val(code);
				var searchurl=getContextPath()+"/loadFieldsMemberWise.html?memCode="+code;
				 $.ajax({
					        type: "GET",
					        url: searchurl,
					        dataType: "json",
					        success: function(response)
					        {
					        	if(response.strFacilityCode=='Invalid Code')
					        	{
					        		alert("Invalid Category Code");					        		
					        	}
					        	else
					        	{	
									map=response;
							        	for (var i in map) {	
							        		if(i!='strMemberCode'&&i!='strClientCode')
							        			{
							        				funAddFieldListRow(i,map[i]);							        				
							        			}							        	    
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
		 
		 
		 /**
			 * Adding Product Data in grid 
			 */
			function funAddRowReceived(memCode,drawnOn,chequeNo,chequeDate,chequeAmt) 
			{   	
				
			    var table = document.getElementById("tblDetails");
			    var rowCount = table.rows.length;
			    var row = table.insertRow(rowCount);   
			    
			    rowCount=listRow;
			    row.insertCell(0).innerHTML= "<input  readonly=\"true\" size=\"21%\" name=\"listPDCDtlRecieved["+(rowCount)+"].strMemCode\" value='"+memCode+"' id=\"txtMemCodeRec."+(rowCount)+"\" >";
				row.insertCell(1).innerHTML= "<input  readonly=\"true\" class=\"Box\" size=\"22%\" name=\"listPDCDtlRecieved["+(rowCount)+"].strDrawnOn\" value='"+drawnOn+"' id=\"txtBankCodeRec."+(rowCount)+"\" >";
				row.insertCell(2).innerHTML= "<input  readonly=\"true\" class=\"Box\" size=\"22%\" name=\"listPDCDtlRecieved["+(rowCount)+"].strChequeNo\" value='"+chequeNo+"' id=\"txtChequeNoRec."+(rowCount)+"\" >";	
				//row.insertCell(2).innerHTML= "<input class=\"Box\" type=\"text\" name=\"listPDCDtlRecieved["+(rowCount)+"].strChequeNo\" size=\"15%\" style=\"text-align: right;\" id=\"txtChequeNoRec."+(rowCount)+"\" value='"+chequeNo+"'/>";	
			    row.insertCell(3).innerHTML= "<input  readonly=\"true\" class=\"Box\" size=\"22%\" name=\"listPDCDtlRecieved["+(rowCount)+"].dteChequeDate\" id=\"txtChkDte."+(rowCount)+"\" value="+chequeDate+">";
			    row.insertCell(4).innerHTML= "<input  readonly=\"true\" class=\"Box\" size=\"22%\" name=\"listPDCDtlRecieved["+(rowCount)+"].dblChequeAmt\" value='"+chequeAmt+"' id=\"txtAmtRec."+(rowCount)+"\" >";	
			    row.insertCell(5).innerHTML= "<input  readonly=\"true\" class=\"Box\" size=\"22%\" name=\"listPDCDtlRecieved["+(rowCount)+"].strType\" value='Received' id=\"txtRecieved."+(rowCount)+"\" >";	
				   
			    listRow++;			       
			}
		 
			function funAddRowIssued(memCode,drawnOn,chequeNo,chequeDate,chequeAmt) 
			{   	    	    
			    var table = document.getElementById("tblDetailss");
			    var rowCount = table.rows.length;
			    var row = table.insertRow(rowCount);   
			    
			    rowCount=listRow;
			    row.insertCell(0).innerHTML= "<input  readonly=\"true\" class=\"Box\" size=\"21%\" name=\"listPDCDtlIssued["+(rowCount)+"].strMemCode\" value='"+memCode+"' id=\"txtMemCodeIssued."+(rowCount)+"\" >";
				row.insertCell(1).innerHTML= "<input  readonly=\"true\" class=\"Box\" size=\"22%\" name=\"listPDCDtlIssued["+(rowCount)+"].strDrawnOn\" value='"+drawnOn+"' id=\"txtBankCodeIssued."+(rowCount)+"\" >";
				row.insertCell(2).innerHTML= "<input  readonly=\"true\" class=\"Box\" size=\"22%\" name=\"listPDCDtlIssued["+(rowCount)+"].strChequeNo\" value='"+chequeNo+"' id=\"txtChequeNoIssued."+(rowCount)+"\" >";	
				//row.insertCell(2).innerHTML= "<input class=\"Box\" type=\"text\" name=\"listPDCDtlIssued["+(rowCount)+"].strChequeNo\" size=\"15%\" style=\"text-align: right;\" id=\"txtChequeNoIssued."+(rowCount)+"\" value='"+chequeNo+"'/>";	
			    row.insertCell(3).innerHTML= "<input  readonly=\"true\" class=\"Box\" size=\"22%\" name=\"listPDCDtlIssued["+(rowCount)+"].dteChequeDate\" id=\"txtChkDteIssued."+(rowCount)+"\" value="+chequeDate+">";
			    row.insertCell(4).innerHTML= "<input  readonly=\"true\" class=\"Box\" size=\"22%\" name=\"listPDCDtlIssued["+(rowCount)+"].dblChequeAmt\" value='"+chequeAmt+"' id=\"txtAmtIssued."+(rowCount)+"\" >";	
			    row.insertCell(5).innerHTML= "<input  readonly=\"true\" class=\"Box\" size=\"22%\" name=\"listPDCDtlIssued["+(rowCount)+"].strType\" value='Issued' id=\"txtIssued."+(rowCount)+"\" >";	
			
			    listRow++;			   		   		    
			} 
			function funAddFieldListRow(fieldName,fieldDataType) 
			{
						var table = document.getElementById("tblFieldsData");
						var rowCount = table.rows.length;
						var row = table.insertRow(rowCount);
						row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"30%\"  id=\"txFieldName."+(rowCount)+"\" value='"+fieldName+"'>";
						row.insertCell(1).innerHTML= "<input type=\"text\" readonly=\"true\" class=\"longTextBox\" size=\"30%\" id=\"txFieldValue."+(rowCount)+"\" value='"+fieldDataType+"' >";
			}  
			
		function resetTables()
		{
			$('#tblDetails').empty();
			$('#tblDetailss').empty();
			$('#tblFieldsData').empty();
		}
		 
		
		
		
		
		


		 function funloadMemberData(code)
			{
			 	gMemCode=code;
				var searchurl=getContextPath()+"/loadWebClubMemberProfileData.html?primaryCode="+code;
				//alert(searchurl);
				 $.ajax({
					        type: "GET",
					        url: searchurl,
					        dataType: "json",
					        async:false,
					        success: function(response)
					        {
					        	if(response.strMemberCode=='Invalid Code')
					        	{
					        		alert("Invalid Member Code");
					        		$("#txtMemberCode").val('');
					        	}
					        	else
					        	{  
					        		funloadMemberPhoto(response[0].strMemberCode);
					        		funSetMemberTableReceived(response[0].strMemberCode);
					        		funRemoveAllRows();
					        		var memberCode = response[0].strMemberCode ;
					        		var menber = memberCode.split(" ");
						        	$("#txtMemberCode").text(menber[0]);
						        	$("#txtCustCode").val(menber[0]);
						        	//$("#txtChangeDependentMemberCode").val(menber[0]);
						        	$("#tabDepeList").hide();
						        	$("#tabSpouse").hide();
						        	var isSpous;
						        	if(response[0].strMaritalStatus=="married")
					        		{						        	
					        			isSpous=funSetSpouseData(response[1]);	
					        			$("#tabSpouse").show();
					        		}		        	
						        	
						        	var k = 1;
						        	if(isSpous==true)
						        		{
						        			k =2;
						        		}
						        	
									for(var i=k;i<response.length;i++)
										{
											funAddDependentTableRow(response[i],i);
						    				$("#tabDepeList").show();
										}
						        	
									$("#txtFirstName").text(response[0].strFirstName);							        							        						        	
						        	$("#txtMiddleName").text(response[0].strMiddleName);
						        	$("#txtLastName").text(response[0].strLastName);
						        	$("#txtFullName").text(response[0].strFullName);
						        	
						        	$("#txtFirstName").focus();
						        	
						        	$("#txtAadharCardNo").text(response[0].strAadharCardNo);
						        	$("#txtVoterIdNo").text(response[0].strVoterIdNo);
						        	$("#txtPassportNo").text(response[0].strPassportNo);
						        	
						        	if(response[0].strBankCode!='')
						        		{
						        			funSetBankMasterData(response[0].strBankCode)							        	
						        		}
						        	//$("#txtBankCode").text(response[0].strBankCode);
						        	$("#txtIfscCOde").text(response[0].strIfscCOde);
						        	$("#txtAccNo").text(response[0].strAccNo);
						        	$("#txtBranchName").text(response[0].strBranchName);						        	
						        	
						        	$("#txtCustomerCode").text(response[0].strCustomerCode);
						        	$("#txtPrefixCode").text(response[0].strPrefixCode);
						        	$("#txtNameOnCard").text(response[0].strNameOnCard);
						        	$("#txtResidentAddressLine1").text(response[0].strResidentAddressLine1);
						        	$("#txtResidentAddressLine2").text(response[0].strResidentAddressLine2);
						        	
						        	$("#txtResidentAddressLine3").text(response[0].strResidentAddressLine3);
						        	$("#txtResidentLandMark").text(response[0].strResidentLandMark);						        	
						        	//$("#txtResidentAreaCode").val(response[0].strResidentAreaCode);	
									if(response[0].strResidentAreaCode!='')
									{
										funSetResAreaCode(response[0].strResidentAreaCode);
									}
									if(response[0].strResidentCtCode!='')
									{
										funSetResCityCode(response[0].strResidentCtCode);
									}
									if(response[0].strResidentStateCode!='')
									{
										funSetResStateCode(response[0].strResidentStateCode);
									}
									if(response[0].strResidentCountryCode!='')
									{
										funSetResCountryCode(response[0].strResidentCountryCode);
									}
									if(response[0].strResidentRegionCode!='')
									{
										funSetResRegionCode(response[0].strResidentRegionCode);
									}									
									
						        	//funSetResAreaCode(response[0].strResidentAreaCode);
						        	//$("#txtResidentCtCode").val(response[0].strResidentCtCode);		
						        	//funSetResCityCode(response[0].strResidentCtCode);
						        	//$("#txtResidentStateCode").val(response[0].strResidentStateCode);
						        	//funSetResStateCode(response[0].strResidentStateCode);
						        	//$("#txtResidentRegionCode").val(response[0].strResidentRegionCode);
						        	//funSetResRegionCode(response[0].strResidentRegionCode);
						        	//$("#txtResidentCountryCode").val(response[0].strResidentCountryCode);
						        	//funSetResCountryCode(response[0].strResidentCountryCode);
						        	$("#txtResidentPinCode").text(response[0].strResidentPinCode);
						        	$("#txtResidentTelephone1").text(response[0].strResidentTelephone1);
						        	$("#txtResidentTelephone2").text(response[0].strResidentTelephone2);
						        	
						        	$("#txtResidentFax1").text(response[0].strResidentFax1);
						        	$("#txtResidentFax2").text(response[0].strResidentFax2);
						        	$("#txtResidentMobileNo").text(response[0].strResidentMobileNo);
						        	$("#txtResidentEmailID").text(response[0].strResidentEmailID);
						        	$("#txtCompanyCode").text(response[0].strCompanyCode);
						        	
						        	$("#txtCompanyName").text(response[0].strCompanyName);
						        	$("#txtHoldingCode").text(response[0].strHoldingCode);
						        	$("#txtJobProfileCode").text(response[0].strJobProfileCode);
						        	$("#txtCompanyAddressLine1").text(response[0].strCompanyAddressLine1);
						        	$("#txtCompanyAddressLine2").text(response[0].strCompanyAddressLine2);						        	
						        	$("#txtCompanyAddressLine3").text(response[0].strCompanyAddressLine3);
						        	$("#txtCompanyLandMark").text(response[0].strCompanyLandMark);
						        	
						        	
						        	if(response[0].strCompanyAreaCode!='')
									{
						        		funSetComAreaCode(response[0].strCompanyAreaCode);
									}	
						        	if(response[0].strCompanyCtCode!='')
									{
						        		funSetComCityCode(response[0].strCompanyCtCode);
									}	
						        	if(response[0].strCompanyStateCode!='')
									{
						        		funSetComStateCode(response[0].strCompanyStateCode);
									}	
						        	if(response[0].strCompanyCountryCode!='')
									{
						        		funSetComCountryCode(response[0].strCompanyCountryCode);
									}	
						        	if(response[0].strCompanyRegionCode!='')
									{
						        		funSetComRegionCode(response[0].strCompanyRegionCode);
									}	
						        	//$("#txtCompanyAreaCode").val(response[0].strCompanyAreaCode);
						        	//funSetComAreaCode(response[0].strCompanyAreaCode);
						        	//$("#txtCompanyCtCode").val(response[0].strCompanyCtCode);
						        	//funSetComCityCode(response[0].strCompanyCtCode);
						        	//$("#txtCompanyStateCode").val(response[0].strCompanyStateCode);	
						        	//funSetComStateCode(response[0].strCompanyStateCode);
						        	//$("#txtCompanyCountryCode").val(response[0].strCompanyCountryCode);	
						        	//funSetComCountryCode(response[0].strCompanyCountryCode);
						        	//$("#txtCompanyRegionCode").val(response[0].strCompanyRegionCode);
						        	//funSetComRegionCode(response[0].strCompanyRegionCode);
						        	
						        	$("#txtCompanyPinCode").text(response[0].strCompanyPinCode);
						        	$("#txtCompanyTelePhone1").text(response[0].strCompanyTelePhone1);
						        	$("#txtCompanyTelePhone2").text(response[0].strCompanyTelePhone2);
						        	
						        	$("#txtCompanyFax1").text(response[0].strCompanyFax1);
						        	$("#txtCompanyFax2").text(response[0].strCompanyFax2);
						        	$("#txtCompanyMobileNo").text(response[0].strCompanyMobileNo);
						        	$("#txtCompanyEmailID").text(response[0].strCompanyEmailID);
						        	$("#txtBillingAddressLine1").text(response[0].strBillingAddressLine1);
						        	
						        	$("#txtBillingAddressLine2").text(response[0].strBillingAddressLine2);
						        	$("#txtBillingAddressLine3").text(response[0].strBillingAddressLine3);
						        	$("#txtBillingLandMark").text(response[0].strBillingLandMark);
						        	
						        	
						        	
						        	if(response[0].strBillingAreaCode!='')
									{
						        		funSetBillingAreaCode(response[0].strBillingAreaCode);
									}	
						        	
						        	if(response[0].strBillingCtCode!='')
									{
						        		funSetBillingCityCode(response[0].strBillingCtCode);
									}							        	
						        	
						        	if(response[0].strBillingStateCode!='')
									{
						        		funSetBillingStateCode(response[0].strBillingStateCode);
									}	
						        	if(response[0].strBillingCountryCode!='')
									{
						        		funSetBillingCountryCode(response[0].strBillingCountryCode);
									}	
						        	if(response[0].strBillingRegionCode!='')
									{
						        		funSetBillingRegionCode(response[0].strBillingRegionCode);
									}	
						        	//$("#txtBillingAreaCode").val(response[0].strBillingAreaCode);
						        	//funSetBillingAreaCode(response[0].strBillingAreaCode);
						        	//$("#txtBillingCtCode").val(response[0].strBillingCtCode);
						        	//funSetBillingCityCode(response[0].strBillingCtCode);
						        	//$("#txtBillingStateCode").val(response[0].strBillingStateCode);
						        	//funSetBillingStateCode(response[0].strBillingStateCode);
						        	//$("#txtBillingCountryCode").val(response[0].strBillingCountryCode);
						        	//funSetBillingCountryCode(response[0].strBillingCountryCode);
						        	//$("#txtBillingRegionCode").val(response[0].strBillingRegionCode);
						        	//funSetBillingRegionCode(response[0].strBillingRegionCode);
						        	
						        	$("#txtBillingPinCode").text(response[0].strBillingPinCode);
						        	$("#txtBillingTelePhone1").text(response[0].strBillingTelePhone1);
						        	
						        	$("#txtBillingTelePhone2").text(response[0].strBillingTelePhone2);
						        	$("#txtBillingFax1").text(response[0].strBillingFax1);
						        	$("#txtBillingFax2").text(response[0].strBillingFax2);
						        	$("#txtBillingMobileNo").text(response[0].strBillingMobileNo);
						        	$("#txtBillingEmailID").text(response[0].strBillingEmailID);
						        	
						        	$("#txtBillingFlag").text(response[0].strBillingFlag);
						        	$("#txtGender").text(response[0].strGender);
						        	
						        	var dob=response.dteDateofBirth;						        	
						        	//alert("DOB="+dob);
						        	
						        	
									
									$("#txtdtMembershipStartDate").text(response[0].dteMembershipStartDate);
						        	$("#txtdtMembershipEndDate").text(response[0].dteMembershipEndDate);
						        	$("#cmbMemberBlock").text(response[0].strBlocked);
						        	
						        	
						        	
						        	
						        	
						        	
						        	
						        	
						            $("#txtdtDateofBirth").datepicker({dateFormat: 'dd-mm-yyyy'}).datepicker('setDate', dob);						        	
						        	$("#txtdtDateofBirth").text(response[0].dteDateofBirth);
						        	$("#cmbMaritalStatus").text(response[0].strMaritalStatus);
						        	if(response[0].strGender=='M')
						        		{
						        		$("#cmbGender").text('Male');
						        		}
						        	else{
						        		$("#cmbGender").text('Female');
						        	}
						        	
						        	//$("#cmbGender").text(response[0].strGender);
						        	
						        	//$("#txtProfessionCode").text(response[0].strProfessionCode);
						        	if(response[0].strProfessionCode!='')
						        		{
						        			funSetProfessionCode(response[0].strProfessionCode);
						        		}					        	
						        	//$("#txtMSCategoryCode").text(response[0].strCategoryCode);
						        	if(response[0].strCategoryCode!='')
						        		{
						        			funSetMemberCategory(response[0].strCategoryCode);
						        		}
						        	$("#txtPanNumber").text(response[0].strPanNumber);
						        	
						        	$("#txtProposerCode").text(response[0].strProposerCode);
						        	$("#txtSeconderCode").text(response[0].strSeconderCode);
						        	$("#txtBlocked").text(response[0].strBlocked);
						        	
						        	//$("#txtBlockedReasonCode").text(response[0].strBlockedreasonCode);
						        	//$("#txtQualification").text(response[0].strQualification);
						        	if(response[0].strQualification!='')
						        		{
						        			funSetEducationCode(response[0].strQualification);
						        		}
						        	//$("#txtDesignationCode").text(response[0].strDesignationCode);
						        	if(response[0].strDesignationCode!='')
						        		{
						        			funSetDesignationCode(response[0].strDesignationCode);
						        		}
						        	$("#txtLocker").text(response[0].strLocker);
						        	$("#txtLibrary").text(response[0].strLibrary);
						        	
						        	$("#txtInstation").text(response[0].strInstation);
						        	$("#cmbGolfMemberShip").text(response[0].strGolfMemberShip);
						        	//$("#cmbSendInnvoicethrough").text(response[0].strSendInvThrough);
						        	//$("#strSendCircularNoticeThrough").text(response[0].strSendCircularNoticeThrough);
						        	$("#cmbResident").text(response[0].strResident);
						        	
						        	
						        	$("#cmbLockerDetail").text(response[0].strLocker);
						        	$("#cmbLibrary").text(response[0].strLibrary);
						        	$("#cmbSeniorCitizen").text(response[0].strSeniorCitizen);
						        	$("#cmbStopCredit").text(response[0].strStopCredit);
						        	$("#cmbsendInnvoicethrough").text(response[0].strSendInvThrough);
						        	$("#cmbNotice").text(response[0].strSendCircularNoticeThrough);
						        	
						        	$("#txtSeniorCitizen").text(response[0].strSeniorCitizen);
						        	$("#txtdblEntranceFee").text(response[0].dblEntranceFee);
						        	$("#txtdblSubscriptionFee").text(response[0].dblSubscriptionFee);
						        	
						        	$("#txtStopCredit").text(response[0].strStopCredit);
						        	$("txtFatherMemberCode").text(response[0].strFatherMemberCode);
						        	//$("#txtStatusCode").val(response.strStatusCode);
						        	if(response[0].strBlockedreasonCode!="")
						        		{
						        			funSetBlockReasonCode(response[0].strBlockedreasonCode);
							        	
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
		
		
		
		 function funloadMemberPhoto(code)
			{
				var searchUrl1=getContextPath()+"/loadMembProfileImage.html?prodCode="+code;
				$("#memImage").attr('src', searchUrl1);
			}
		
		
		
		
		 function funRemoveAllRows() 
		    {
				 var table = document.getElementById("tblDependentData");
				 var rowCount = table.rows.length;			   
				//alert("rowCount\t"+rowCount);
				for(var i=rowCount-1;i>=0;i--)
				{
					table.deleteRow(i);						
				} 
		    }
		
		
		
		
		 function funSetSpouseData(response)
		 {
			 var flgISSpouse =false;
			 if(!(response.dteAnniversary=="" || response.dteAnniversary==null) )
			 {
				 $("#txtSpouseCode").text(response.strMemberCode);
				 $("#txtSpouseFirstName").text(response.strFirstName);
				 $("#txtSpouseMiddleName").text(response.strMiddleName);
				 $("#txtSpouseLastName").text(response.strLastName);
				 $("#txtSpouseProfessionName").text(response.strProfessionCode);
				 $("#txtdtSpouseDateofBirth").text(response.dteDateofBirth);
				 $("#txtSpouseCompanyCode").text(response.strCompanyCode);
				 $("#txtSpouseJobProfileCode").text(response.strJobProfileCode);
				 $("#txtdtAnniversary").text(response.dteAnniversary);
				 $("#cmbSpouseFacilityBlock").text(response.strBlocked);
				 $("#cmbSpouseStopCredit").text(response.strStopCredit);
				 $("#txtSpouseCustCode").text(response.strCustomerCode);
 			 	 $("#txtSpouseProfessionCode").text(response.strProfessionCode);
				 $("#txtSpouseResidentEmailID").text(response.strResidentEmailID);
	 			 $("#txtSpouseResidentMobileNo").text(response.strResidentMobileNo);
	// 			 $("#").val();
	 			flgISSpouse =true;
			 }
			 return flgISSpouse; 
		 }
		
		
		 function funSetBankMasterData(bankCode)
			{
			    $("#txtBankCode").text(bankCode);
				var searchurl=getContextPath()+"/loadWebClubBankMasterData.html?bankCode="+bankCode;
				 $.ajax({
					        type: "GET",
					        url: searchurl,
					        dataType: "json",
					        success: function(response)
					        {
					        	if(response.strBankCode=='Invalid Code')
					        	{
					        		alert("Invalid Bank Code");
					        		//$("#txtBankCode").val('');
					        	}
					        	else
					        	{
						        	$("#txtBankCode").text(response.strBankName);
						        	$("#txtBankName").focus();
						        	$("#txtBranchName").text(response.strBranch);
						        	$("#txtMICR").text(response.strMICR);
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
		
		function funSetResAreaCode(code){

			$("#txtResidentAreaCode").text(code);
			var searchurl=getContextPath()+"/loadAreaCode.html?docCode="+code;
			//alert(searchurl);
			
				$.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strAreaCode=='Invalid Code')
			        	{
			        		alert("Invalid Group Code");
			        		$("#txtGroupCode").text('');
			        	}
			        	else
			        	{
			        		funSetResCityCode(response.strCityCode);
				        	$("#txtResidentAreaCode").text(response.strAreaName);
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
		
		function funSetComAreaCode(code){

			$("#txtCompanyAreaCode").text(code);
			var searchurl=getContextPath()+"/loadAreaCode.html?docCode="+code;
			//alert(searchurl);
			
				$.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strAreaCode=='Invalid Code')
			        	{
			        		alert("Invalid Group Code");
			        		$("#txtGroupCode").val('');
			        	}
			        	else
			        	{
			        		funSetComCityCode(response.strCityCode);
				        	$("#txtCompanyAreaCode").text(response.strAreaName);
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
		
		function funSetBillingAreaCode(code){

			$("#txtBillingAreaCode").text(code);
			var searchurl=getContextPath()+"/loadAreaCode.html?docCode="+code;
			//alert(searchurl);
			
				$.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strAreaCode=='Invalid Code')
			        	{
			        		alert("Invalid Group Code");
			        		$("#txtGroupCode").val('');
			        	}
			        	else
			        	{
			        		funSetBillingCityCode(response.strCityCode);		        		
				        	$("#txtBillingAreaCode").text(response.strAreaName);
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
		
		
		
		
	function funSetResCityCode(code){
			$("#txtResidentCtCode").text(code);
			var searchurl=getContextPath()+"/loadCityCode.html?docCode="+code;
			//alert(searchurl);
			
				$.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strCityCode=='Invalid Code')
			        	{
			        		alert("Invalid City Code In");
			        		$("#txtResidentCtCode").text('');
			        	}
			        	else
			        	{
			        		$("#txtResidentCtCode").text(response.strCityName);
			        		funSetResStateCode(response.strStateCode);	
			        		funSetResCountryCode(response.strCountryCode);
			        		$("#txtResidentPinCode").text(response.strSTDCode);
			        		
//	 		        		$("#txtCityName").val(response.strCityName);
//	 		        		$("#txtCityStdCode").val(response.strSTDCode);
//	 		        		$("#txtStateCode").val(response.strStateCode);
//	 		        		$("#txtCountryCode").val(response.strCountryCode);
			        		 
			        		
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
		
	function funSetComCityCode(code){
		
		$("#txtCompanyCtCode").text(code);
		var searchurl=getContextPath()+"/loadCityCode.html?docCode="+code;
		//alert(searchurl);
		
			$.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strCityCode=='Invalid Code')
		        	{
		        		alert("Invalid City Code In");
		        		$("#txtResidentCtCode").val('');
		        	}
		        	else
		        	{
		        			funSetComStateCode(response.strStateCode);
		        			$("#txtCompanyPinCode").text(response.strSTDCode);	        			
			        		$("#txtCompanyCtCode").text(response.strCityName);
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

	function funSetBillingCityCode(code){
		
		$("#txtBillingCtCode").text(code);
		var searchurl=getContextPath()+"/loadCityCode.html?docCode="+code;
		//alert(searchurl);
		
			$.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strCityCode=='Invalid Code')
		        	{
		        		alert("Invalid City Code In");
		        		$("#txtResidentCtCode").val('');
		        	}
		        	else
		        	{
		        		funSetBillingCountryCode(response.strCountryCode);
		        		funSetBillingStateCode(response.strStateCode);     		
		        		
		        		$("#txtBillingPinCode").text(response.strSTDCode);	        		
			        	$("#txtBillingCtCode").text(response.strCityName);
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

	function funSetResCountryCode(code){
		    
		$("#txtResidentCountryCode").text(code);
		var searchurl=getContextPath()+"/loadCountryCode.html?docCode="+code;
		//alert(searchurl);
		
			$.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strCountryCode=='Invalid Code')
		        	{
		        		alert("Invalid Country Code In");
		        		$("#txtCountryCode").val('');
		        	}
		        	else
		        	{
		        		$("#txtResidentCountryCode").text(response.strCountryName);
		        		//$("#txtCountryName").val(response.strCountryName);
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
	function funSetComCountryCode(code){
		  
		$("#txtCompanyCountryCode").text(code);
		var searchurl=getContextPath()+"/loadCountryCode.html?docCode="+code;
		//alert(searchurl);
		
			$.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strCountryCode=='Invalid Code')
		        	{
		        		alert("Invalid Country Code In");
		        		$("#txtCountryCode").val('');
		        	}
		        	else
		        	{
		        		$("#txtCompanyCountryCode").text(response.strCountryName);
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

	function funSetBillingCountryCode(code){
		 
		$("#txtBillingCountryCode").text(code);
		var searchurl=getContextPath()+"/loadCountryCode.html?docCode="+code;
		//alert(searchurl);
		
			$.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strCountryCode=='Invalid Code')
		        	{
		        		alert("Invalid Country Code In");
		        		$("#txtCountryCode").val('');
		        	}
		        	else
		        	{
		        		
		        		$("#txtBillingCountryCode").text(response.strCountryName);
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

	function funSetResStateCode(code){

		$("#txtResidentStateCode").text(code);
		var searchurl=getContextPath()+"/loadStateCode.html?docCode="+code;
		//alert(searchurl);
		
			$.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strStateCode=='Invalid Code')
		        	{
		        		alert("Invalid State Code In");
		        		$("#txtStateCode").val('');
		        	}
		        	else
		        	{
		        		$("#txtResidentStateCode").text(response.strStateName);
		        		funSetResRegionCode(response.strRegionCode);
		        		//$("#txtResidentRegionCode").text(response.strRegionName); 		
		        		 
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
		
	function funSetComStateCode(code){
		  
		$("#txtCompanyStateCode").text(code);
		var searchurl=getContextPath()+"/loadStateCode.html?docCode="+code;
		//alert(searchurl);
		
			$.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strStateCode=='Invalid Code')
		        	{
		        		alert("Invalid State Code In");
		        		$("#txtCompanyStateCode").val('');
		        	}
		        	else
		        	{
		        		funSetComRegionCode(response.strRegionCode);
		        		funSetComCountryCode(response.strCountryCode);	        		
		        		$("#txtCompanyStateCode").text(response.strStateName);
		        		 
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


	function funSetBillingStateCode(code){
		  
		$("#txtBillingStateCode").text(code);
		var searchurl=getContextPath()+"/loadStateCode.html?docCode="+code;
		//alert(searchurl);
		
			$.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strStateCode=='Invalid Code')
		        	{
		        		alert("Invalid State Code In");
		        		$("#txtStateCode").val('');
		        	}
		        	else
		        	{
		        		funSetBillingRegionCode(response.strRegionCode);
		        		$("#txtBillingStateCode").text(response.strStateName);
		        		 
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

	function funSetResRegionCode(code){
		
		//$("#txtResidentRegionCode").text(code);
		var searchurl=getContextPath()+"/loadRegionCode.html?docCode="+code;
		//alert(searchurl);
		
			$.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strRegionCode=='Invalid Code')
		        	{
		        		alert("Invalid Region Code In");
		        		$("#txtBillingRegionCode").text('');
		        	}
		        	else
		        	{
		        		$("#txtResidentRegionCode").text(response.strRegionName);
		        		//$("#txtRegionName").val(response.strRegionName);
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

	function funSetComRegionCode(code){
		
		$("#txtCompanyRegionCode").text(code);
		var searchurl=getContextPath()+"/loadRegionCode.html?docCode="+code;
		//alert(searchurl);
		    
			$.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strRegionCode=='Invalid Code')
		        	{
		        		alert("Invalid Region Code In");
		        		$("#txtRegionCode").val('');
		        	}
		        	else
		        	{
		        		$("#txtCompanyRegionCode").text(response.strRegionName);	        		
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

	function funSetBillingRegionCode(code){
		
		$("#txtBillingRegionCode").text(code);
		var searchurl=getContextPath()+"/loadRegionCode.html?docCode="+code;
		//alert(searchurl);
		
			$.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strRegionCode=='Invalid Code')
		        	{
		        		alert("Invalid Region Code In");
		        		$("#txtRegionCode").val('');
		        	}
		        	else
		        	{
		        		$("#txtBillingRegionCode").text(response.strRegionName);
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

	
	function funAddDependentTableRow(response,i)
	{
			var table = document.getElementById("tblDependentData");
			var rowCount = table.rows.length;
			var row = table.insertRow(rowCount);
			
		    var genratedMemberCode = response.strMemberCode;
		    var dependentName = response.strFullName;
		    var relation = response.strDepedentRelation;
		    var gender = response.strGender;
		    var mStatus  = response.strMaritalStatus;
		    var DOB = response.dteDateofBirth ;
		    var memExpDate = response.dteDateofBirth;
		    var blocked = response.strBlocked;
		    var blockedReason = response.strBlockedreasonCode;
		    var profession = response.strProfessionCode;
		    var customerCode = response.strCustomerCode;
		    if(genratedMemberCode==null)
		    	{
		    		genratedMemberCode="";
		    	}
		    if(dependentName==null)
	    	{
		    	dependentName="";
	    	}
		    
		    if(relation==null)
	    	{
		    	relation="";
	    	}
		    
		    if(gender==null)
	    	{
		    	gender="";
	    	}
		    
		    if(mStatus==null)
	    	{
		    	mStatus="";
	    	}
		    
		    if(DOB==null)
	    	{
		    	DOB="";
	    	}
		    
		    if(memExpDate==null)
	    	{
		    	memExpDate="";
	    	}
		    
		    if(blocked==null)
	    	{
		    	blocked="";
	    	}
		    
		    if(blockedReason==null)
	    	{
		    	blockedReason="";
	    	}
		    
		    if(profession==null)
	    	{
		    	profession="";
	    	}
		    
		    if(customerCode==null)
	    	{
		    	customerCode="";
	    	}
		    
		    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"9%\" name=\"listDependentMember["+(rowCount)+"].strMemberCode\" id=\"txttblDependentMemberCode."+(rowCount)+"\" value='"+genratedMemberCode+"' onclick=\"funRowClick(this)\"  >";
		    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"15%\" name=\"listDependentMember["+(rowCount)+"].strDependentFullName\" id=\"txttblDependentName."+(rowCount)+"\" value='"+dependentName+"' onclick=\"funRowClick(this)\">";
		    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"8%\" name=\"listDependentMember["+(rowCount)+"].strDepedentRelation\" id=\"txttblDepedentRelation."+(rowCount)+"\" value='"+relation+"' onclick=\"funRowClick(this)\">";
		    row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"2%\" name=\"listDependentMember["+(rowCount)+"].strGender\" id=\"txttblDependentGender."+(rowCount)+"\" value='"+gender+"' onclick=\"funRowClick(this)\">";
		    row.insertCell(4).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"8%\" name=\"listDependentMember["+(rowCount)+"].strMaritalStatus\" id=\"txttblDependentMaritalStatus."+(rowCount)+"\" value='"+mStatus+"' onclick=\"funRowClick(this)\">";
		    row.insertCell(5).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" name=\"listDependentMember["+(rowCount)+"].dteDependentDateofBirth\" id=\"txttblDependentDateofBirth."+(rowCount)+"\" value='"+DOB+"' onclick=\"funRowClick(this)\">";
		    row.insertCell(6).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"2%\" name=\"listDependentMember["+(rowCount)+"].strBlocked\" id=\"txttblDependentBlocked."+(rowCount)+"\" value='"+blocked+"' onclick=\"funRowClick(this)\">";
		    row.insertCell(7).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"15%\" name=\"listDependentMember["+(rowCount)+"].strDependentReasonCode\" id=\"txttblDependentReasonCode."+(rowCount)+"\" value='"+blockedReason+"' onclick=\"funRowClick(this)\">";
		    row.insertCell(8).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" name=\"listDependentMember["+(rowCount)+"].strProfessionCode\" id=\"txttblProfessionCode."+(rowCount)+"\" value='"+profession+"' onclick=\"funRowClick(this)\">";
		    row.insertCell(9).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" name=\"listDependentMember["+(rowCount)+"].dteMembershipExpiryDate\" id=\"txttbldteMembershipExpiryDate."+(rowCount)+"\" value='"+memExpDate+"' onclick=\"funRowClick(this)\">";
		   // row.insertCell(10).innerHTML= "<input type=\"button\" class=\"deletebutton\" size=\"10%\" value = \"\" onClick=\"Javacsript:funDeleteRow(this)\"/>";
			//row.insertCell(11).innerHTML= "<input Type=\"hidden\" readonly=\"readonly\" class=\"Box\" size=\"10%\" name=\"listDependentMember["+(rowCount)+"].strCustomerCode\" id=\"txttblCustomerCode."+(rowCount)+"\" value='"+customerCode+"' onclick=\"funRowClick(this)\">";
		    
			genratedMemberCode=genratedMemberCode.split(" ");


			
			var  nextdependentCode =1+parseInt(genratedMemberCode[1]);
			if(nextdependentCode<10)
		    	{
				nextdependentCode = "0" + nextdependentCode;
		    	}
			
		    $("#txtChangeDependentCode").val(nextdependentCode);
		    
		   return false;
}
	
	function funAddFieldDataMemberWise(fieldName,fieldDataType) 
	{
				var table = document.getElementById("tblFieldData");
				var rowCount = table.rows.length;
				var row = table.insertRow(rowCount);
				if(fieldDataType[1].includes("-"))
					{	
						var str=fieldDataType[1].split("-");	
						fieldDataType[1]=str[2]+"-"+str[1]+"-"+str[0];
					}
				
			    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" size=\"30%\" name=\"listField["+(rowCount)+"].strFieldName\" id=\"txFieldName."+(rowCount)+"\" value='"+fieldName+"'>";
			    row.insertCell(1).innerHTML= "<input type=\"readonly\" readonly=\"true\" size=\"30%\" name=\"listField["+(rowCount)+"].strFieldValue\" id=\"txFieldValue."+(rowCount+1)+"\" value='"+fieldDataType[1]+"' >";
				
	}
	

	function funSetProfessionCode(code){

		//$("#txtProfessionCode").text(code);
		var searchurl=getContextPath()+"/loadProfession.html?docCode="+code;
		//alert(searchurl);
		
			$.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strProfessionCode=='Invalid Code')
		        	{
		        		alert("Invalid Profession Code In");
		        		$("#txtProfessionCode").val('');
		        	}
		        	else
		        	{
		        		$("#txtProfessionCode").text(response.strProfessionName);
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
	
	
	
	
	
	
	function funSetMemberCategory(code)
	{
		//$("#txtMSCategoryCode").val(code);
		var searchurl=getContextPath()+"/loadWebClubMemberCategoryMaster.html?catCode="+code;
		//alert(searchurl);
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strGCode=='Invalid Code')
			        	{
			        		alert("Invalid Category Code");
			        		$("#txtMSCategoryCode").val('');
			        	}
			        	else
			        	{
			        		//$("#txtMSCategoryCode").text(code);
				        	$("#txtMSCategoryCode").text(response.strCatName);
				        	
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
	
	
	
	function funSetEducationCode(code){

		//$("#txtQualification").val(code);
		var searchurl=getContextPath()+"/loadEducation.html?docCode="+code;
		//alert(searchurl);
		
			$.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strEducationCode=='Invalid Code')
		        	{
		        		alert("Invalid Qualification Code In");
		        		$("#txtQualification").val('');
		        	}
		        	else
		        	{
		        		$("#txtQualification").text(response.strEducationDesc);
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

	function funSetBlockReasonCode(code){

		$("#txtBlockedReasonCode").val(code);
		var searchurl=getContextPath()+"/loadReason.html?docCode="+code;
		//alert(searchurl);
		
			$.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strReasonCode=='Invalid Code')
		        	{
		        		alert("Invalid Blocked Reason Code In");
		        		$("#txtBlockedReasonCode").val('');
		        	}
		        	else
		        	{
		        		$("#txtBlockedReasonCode").text(response.strReasonDesc);
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
	
	function funSetDesignationCode(code){

		//$("#txtDesignationCode").val(code);
		var searchurl=getContextPath()+"/loadDesignation.html?docCode="+code;
		//alert(searchurl);
		
			$.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strDesignationCode=='Invalid Code')
		        	{
		        		alert("Invalid Designation Code In");
		        		$("#txtDesignationCode").val('');
		        	}
		        	else
		        	{
		        		$("#txtDesignationCode").text(response.strDesignationName);
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
	
	 function funloadMemberWiseFieldData(code)
		{
			var searchurl=getContextPath()+"/loadWebClubMemberWiseFieldData.html?primaryCode="+code;
			//alert(searchurl);
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        async:false,
				        success: function(response)
				        {
				        	if(response.strMemberCode=='Invalid Code')
				        	{
				        		alert("Invalid Member Code");
				        		$("#txtMemberCode").val('');
				        		
				        	}
				        	else
				        	{  					        		
				        		funDeleteTableAllRowsField();
				        		map1=response;
					        	for (var i in map1) {	
					        		if(i!='strMemberCode')
					        			{
					        				funAddFieldDataMemberWise(i,map1[i]);						        				
					        			}		        	    
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
	 
	 
	 function funShowAttachDocumentsCount(code)
		{
		 	code=$("#txtCustCode").val();	 
			var searchurl=getContextPath()+"/loadAttachedDocumentsCount.html?docCode="+code;
			//alert(searchurl);
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        async:false,
				        success: function(response)
				        {
				        	if(response=='')
				        	{
				        		$("#txtAttachedDocCount").text('Attached Document : 0');
				        		$("#txtAttachedDocCount").css("display","none");
				        	}
				        	else
				        	{ 				        		
				        		$("#txtAttachedDocCount").text('Attached Document : '+response[0]);	
				        		$("#txtAttachedDocCount").css("display","none");
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
	 
	 
	 function funDeleteTableAllRowsField()
		{
			$("#tblFieldData tr").remove();
		}
	
	 $(function()
     		{			
     			$('#baseUrl').click(function() 
     			{  
     				 if($("#txtCustCode").val().trim()=="")
     				{
     					alert("Please Select Member Code");
     					return false;
     				} 
     				window.open('onlyShowDocuments.html?transName=frmMemberExplorer.jsp&formName=Member Explorer&code='+$('#txtCustCode').val()+' 01',"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
     			});
     		});
	 
	 
	 
	 $(function()
	     		{			
	     			$('#txtAttachedDocCount').click(function() 
	     			{  
	     				 if($("#txtCustCode").val().trim()=="")
	     				{
	     					alert("Please Select Member Code");
	     					return false;
	     				} 
	     				window.open('onlyShowDocuments.html?transName=frmMemberExplorer.jsp&formName=Member Explorer&code='+$('#txtCustCode').val()+' 01',"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
	     			});
	     		});
	
</script>
</head>
	<body onload="funOnLoad();">
		<div class="container">
			<label id="formHeading">Member Explorer</label>
		
			<s:form name="Member Explorer" method="POST" action="showMemberExplorer.html?saddr=${urlHits}">
				<br>
				<div class="row masterTable">
				<div class="col-md-2"  style="border-style:none;">Member Code
					<s:input id="txtCustCode" path="strCustomerCode" readonly="true"
							cssClass="searchTextBox" ondblclick="funHelp('WCmemProfileCustomer')" />
				
			</div>
				<br/>
					<div align="center" style="margin-right:58%;">
						<a href="#"><button class="btn btn-primary center-block" value="Show" onclick="return funCallFormAction('submit',this);" 
							class="form_button">Submit</button></a>&nbsp;
						<a href="#"><button class="btn btn-primary center-block" type="reset"
							value="Reset" class="form_button" onclick="funResetField()">Reset</button></a>&nbsp;
					
						<a href="#"><button class="btn btn-primary center-block" value="Print" onclick="return funPrintForm();" class="form_button">Print</button></a>
						<td><label id="txtAttachedDocCount" style=" display: none;"></label></td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						
					</div>
					 <!-- <table class="masterTable">
						<tr>
							<td style="width:150px;background-color: #C0E4FF;">
							 	<div style="width:150px" > <img id="memImage" src="" width="150px" height="155px" alt="" onchange="funShowImagePreview(this);" ></div>&nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;
							</td>
						</tr>
						<tr></tr>
					</table> --> 
				
				<table id="tblExplorer" 
					style="border: 0px solid black; width: 100%; height: 100%; margin-left: auto; margin-right: auto;">
				<tr>
					<td> 
						<div id="tab_container" style="height: 600px">
							<ul class="tabs">
								<li class="active" data-state="tab1">Member Profile</li>
								<li data-state="tab2">Address Info</li>
								<li data-state="tab3">Personal Info</li>
								<li data-state="tab4" id="tabSpouse">Spouse Info</li>
								<li data-state="tab5">Membership Info</li>
								<li data-state="tab6">Bank Info</li>
								<li data-state="tab7">Other Info</li>
								<li data-state="tab8" id="tabDepeList">Dependent List</li>
								<li data-state="tab9">PDC </li>
							</ul>
							
		<!--        tab-1  Member Profile    -->
							<div id="tab1" class="tab_content" style="width: 1000px;display: block;"><br><br>
								<table class="transTable">
									<tr>
										 <td rowspan="9" width="20%">
				       						<img id="memImage" src=""  width="170px" height="150px" alt="Item Image" /></td> 
										<td width="18%">Member Code</td>
												<td><label id="txtMemberCode"></label></td>
											<s:errors path=""></s:errors>
									</tr>
									<tr>
										<td width="18%">Prefix Code</td>
										<td><label id="txtPrefixCode"></label></td>
									</tr>
									<tr>
										<td width="18%"><label>Name On Card</label></td>
										<td width="100%"><label id="txtNameOnCard"></label></td>
									</tr>
									<tr>
										<td width="18%"><label>First Name</label></td>
										<td width="100%"><label id="txtFirstName"></label></td>
									</tr>
									<tr>
										<td width="18%"><label>Middle Name</label></td>
										<td width="100%"><label id=txtMiddleName></label></td>
									</tr>
									<tr>
										<td width="18%"><label>Last  Name</label></td>
										<td width="100%"><label id="txtLastName"></label></td>
									</tr>
								</table>
							</div>
				
		<!--        tab-2 Address Info    -->
						<div id="tab2" class="tab_content" style="width: 1000px;"><br><br>
								<table id="tblExplorer" 
										style="border: 0px solid black; width: 100%; height: 100%; margin-left: auto; margin-right: auto;">
									<tr>
										<td> 
											<div id="tab_container" style="height: 600px">
												<ul class="tabs1">
													<li class="active" data-state="tab11">Resident Address</li>
													<li data-state="tab22">Company Address</li>
													<li data-state="tab33">Billing Address</li>
												</ul>
											
								<!--       tabA  Resident Address    -->
											<div id="tab11" class="tab_content1" style="width: 1000px;display: block;"><br><br>
												<table class="transTable">
													<tr>
														<td width="18%">Resident Add L1</td>
																<td><label id="txtResidentAddressLine1"></label></td>
															<s:errors path=""></s:errors>
													</tr>
													<tr>
														<td width="18%">Resident Add L2</td>
														<td><label id="txtResidentAddressLine2"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Resident Add L3</label></td>
														<td width="100%"><label id="txtResidentAddressLine3"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Resident LandMark</label></td>
														<td width="100%"><label id="txtResidentLandMark"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Resident Area </label></td>
														<td width="100%"><label id=txtResidentAreaCode></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Resident City </label></td>
														<td width="100%"><label id="txtResidentCtCode"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Resident State </label></td>
														<td width="100%"><label id="txtResidentStateCode"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Resident Region </label></td>
														<td width="100%"><label id="txtResidentRegionCode"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Resident Country </label></td>
														<td width="100%"><label id="txtResidentCountryCode"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Resident Tel1</label></td>
														<td width="100%"><label id="txtResidentTelephone1"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Resident Tel2</label></td>
														<td width="100%"><label id="txtResidentTelephone2"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Resident Fax1</label></td>
														<td width="100%"><label id="txtResidentFax1"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Resident Fax2</label></td>
														<td width="100%"><label id="txtResidentFax2"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Resident PinCode</label></td>
														<td width="100%"><label id=txtResidentPinCode></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Resident Mobile No</label></td>
														<td width="100%"><label id=txtResidentMobileNo></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Resident Email ID</label></td>
														<td width="100%"><label id=txtResidentEmailID></label></td>
													</tr>
											</table>
								
											</div>
										
								<!--       tabB  Company Address    -->
											<div id="tab22" class="tab_content1" style="width: 1000px;display: none;"><br><br>
												<table class="transTable">
													<tr>
														<td width="18%">Company Code</td>
																<td><label id="txtCompanyCode"></label></td>
															<s:errors path=""></s:errors>
													</tr>
													<tr>
														<td width="18%">Job Profile</td>
														<td><label id="txtJobProfileCode"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Adress Line1 </label></td>
														<td width="100%"><label id="txtCompanyAddressLine1"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Adress Line 2</label></td>
														<td width="100%"><label id="txtCompanyAddressLine2"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Adress Line 3</label></td>
														<td width="100%"><label id=txtCompanyAddressLine3></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Landmark</label></td>
														<td width="100%"><label id="txtCompanyLandMark"></label></td>
													</tr>
													<!-- <tr>
														<td width="18%"><label>Holding Code</label></td>
														<td width="100%"><label id="txtHoldingCode"></label></td>
													</tr> -->
													<tr>
														<td width="18%"><label>Area </label></td>
														<td width="100%"><label id="txtCompanyAreaCode"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>City </label></td>
														<td width="100%"><label id="txtCompanyCtCode"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>State </label></td>
														<td width="100%"><label id="txtCompanyStateCode"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Region </label></td>
														<td width="100%"><label id="txtCompanyRegionCode"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Country </label></td>
														<td width="100%"><label id="txtCompanyCountryCode"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Telephone</label></td>
														<td width="100%"><label id="txtCompanyTelePhone1"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Fax</label></td>
														<td width="100%"><label id=txtCompanyFax1></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Pin Code</label></td>
														<td width="100%"><label id=txtCompanyPinCode></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Mobile No</label></td>
														<td width="100%"><label id=txtCompanyMobileNo></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Email ID</label></td>
														<td width="100%"><label id=txtCompanyEmailID></label></td>
													</tr>
													
											</table>
								
											</div>
								<!--      tabC  Billing Address   -->
											<div id="tab33" class="tab_content1" style="width: 1000px;display: none;"><br><br>
											
												<table class="transTable">
													<tr>
														<td width="18%">Address L1</td>
															<td><label id="txtBillingAddressLine1"></label></td>
															<s:errors path=""></s:errors>
													</tr>
													<tr>
														<td width="18%">Address L2</td>
														<td><label id="txtBillingAddressLine2"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Address L3 </label></td>
														<td width="100%"><label id="txtBillingAddressLine3"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Landmark</label></td>
														<td width="100%"><label id="txtBillingLandMark"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Area </label></td>
														<td width="100%"><label id=txtBillingAreaCode></label></td>
													</tr>
													<tr>
														<td width="18%"><label>City </label></td>
														<td width="100%"><label id="txtBillingCtCode"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Country </label></td>
														<td width="100%"><label id="txtBillingCountryCode"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Region </label></td>
														<td width="100%"><label id="txtBillingRegionCode"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Telephone</label></td>
														<td width="100%"><label id="txtBillingTelePhone1"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Fax</label></td>
														<td width="100%"><label id="txtBillingFax1"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>State Code</label></td>
														<td width="100%"><label id="txtBillingStateCode"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Pin Code</label></td>
														<td width="100%"><label id="txtBillingPinCode"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Mobile</label></td>
														<td width="100%"><label id="txtBillingMobileNo"></label></td>
													</tr>
													<tr>
														<td width="18%"><label>Email ID</label></td>
														<td width="100%"><label id=txtBillingEmailID></label></td>
													</tr>
											</table>
								
											</div>
										</div>
									</td>
								</tr>
						</table>
					</div>
					
		<!--     tab-3 Personal Info   -->
							<div id="tab3" class="tab_content" style="width: 1000px;display: block;"><br><br>
								<table class="transTable">
									<tr>
										<td width="18%">Profession</td>
												<td><label id="txtProfessionCode"></label></td>
											<s:errors path=""></s:errors>
									</tr>
									<tr>
										<td width="18%">Date Of Birth</td>
										<td><label id="txtdtDateofBirth"></label></td>
									</tr>
									<tr>
										<td width="18%"><label>Marital Status</label></td>
										<td width="100%"><label id="cmbMaritalStatus"></label></td>
									</tr>
									<tr>
										<td width="18%"><label>Sex</label></td>
										<td width="100%"><label id="cmbGender"></label></td>
									</tr>
								</table>
							</div>
						
		<!--     tab-4  Spouse Info    -->
							<div id="tab4" class="tab_content" style="width: 1000px;display: block;"><br><br>
								<table class="transTable">
									<tr>
										<td width="18%">Spouse Code</td>
												<td><label id="txtSpouseCode"></label></td>
											<s:errors path=""></s:errors>
									</tr>
									<tr>
										<td width="18%">First Name</td>
										<td><label id="txtSpouseFirstName"></label></td>
									</tr>
									<tr>
										<td width="18%"><label>Middle Name</label></td>
										<td width="100%"><label id="txtSpouseMiddleName"></label></td>
									</tr>
									<tr>
										<td width="18%"><label>Last Name</label></td>
										<td width="100%"><label id="txtSpouseLastName"></label></td>
									</tr>
									<tr>
										<td width="18%"><label>Profession Code</label></td>
										<td width="100%"><label id="txtSpouseProfessionCode"></label></td>
									</tr>
									<tr>
										<td width="18%"><label>Date Of Birth</label></td>
										<td width="100%"><label id="txtdtSpouseDateofBirth"></label></td>
									</tr>
									<tr>
										<td width="18%"><label>Mobile No</label></td>
										<td width="100%"><label id="txtSpouseResidentMobileNo"></label></td>
									</tr>
									<tr>
										<td width="18%"><label>Email ID</label></td>
										<td width="100%"><label id="txtSpouseResidentEmailID"></label></td>
									</tr>
									<tr>
										<td width="18%"><label>Anniversary Date</label></td>
										<td width="100%"><label id="txtdtAnniversary"></label></td>
									</tr>
									<tr>
										<td width="18%"><label>Company Code</label></td>
										<td width="100%"><label id="txtSpouseCompanyCode"></label></td>
									</tr>
									<tr>
										<td width="18%"><label>Job Profile</label></td>
										<td width="100%"><label id="txtSpouseJobProfileCode"></label></td>
									</tr>
									<tr>
										<td width="18%"><label>Spouse Block</label></td>
										<td width="100%"><label id="cmbSpouseFacilityBlock"></label></td>
									</tr>
									<tr>
										<td width="18%"><label>StopCredit Supply</label></td>
										<td width="100%"><label id="cmbSpouseStopCredit"></label></td>
									</tr>
							</table>
								
						</div>
					
		<!--    tab-5  Membership Info  -->
							<div id="tab5" class="tab_content" style="width: 1000px;display: block;"><br><br>
								<table class="transTable">
									<tr>
										<td width="18%">Membership Category</td>
												<td><label id="txtMSCategoryCode"></label></td>
											<s:errors path=""></s:errors>
									</tr>
									<!-- <tr>
										<td width="18%">Proposer Code</td>
										<td><label id="txtProposerCode"></label></td>
									</tr> 
									<tr>
										<td width="18%"><label>Seconder Code</label></td>
										<td width="100%"><label id="txtSeconderCode"></label></td>
									</tr>
									<tr>
										<td width="18%"><label>Father/Mother Code</label></td>
										<td width="100%"><label id="txtFatherMemberCode"></label></td>
									</tr>
									<tr>
										<td width="18%"><label>Status</label></td>
										<td width="100%"><label id="txtStatusCode"></label></td>
									</tr>-->
									<tr>
										<td width="18%"><label>Reason</label></td>
										<td width="100%"><label id="txtBlockedReasonCode"></label></td>
									</tr>
									<tr>
										<td>Qualification</td>
										<td><label id="txtQualification"></label></td>
									</tr>
									<tr>
										<td width="18%"><label>Designation</label></td>
										<td width="100%"><label id="txtDesignationCode"></label></td>
									</tr>
									<tr>
										<td width="18%"><label>Member From</label></td>
										<td width="100%"><label id="txtdtMembershipStartDate"></label></td>
									</tr>
									<tr>
										<td width="18%"><label>Member To</label></td>
										<td width="100%"><label id="txtdtMembershipEndDate"></label></td>
									</tr>
								<!-- 	<tr>
										<td width="18%"><label>Ballot Date</label></td>
										<td width="100%"><label id="txtdtBallotDate"></label></td>
									</tr> -->
									<tr>
										<td width="18%"><label>Allow Card Validation</label></td>
										<td width="100%"><label id="chkCardValidtion"></label></td>
									</tr>
									<tr>
										<td width="18%"><label>Member Blocked</label></td>
										<td width="100%"><label id="cmbMemberBlock"></label></td>
									</tr>
									<tr>
										<td width="18%"><label>Entrance Fee</label></td>
										<td width="100%"><label id="txtdblEntranceFee"></label></td>
									</tr>
									<tr>
										<td width="18%"><label>Subscription Fee</label></td>
										<td width="100%"><label id="txtdblSubscriptionFee"></label></td>
									</tr>
									<tr>
										<td width="18%">Pan Number</td>
										<td><label id="txtPanNumber"></label></td>
									</tr>
									<tr>
										<td width="18%">Aadhar Card No</td>
										<td><label id="txtAadharCardNo"></label></td>
									</tr>
									<tr>
										<td width="18%">Voter Id Card No</td>
										<td><label id="txtVoterIdNo"></label></td>
									</tr>
									<tr>
										<td width="18%">Passport No</td>
										<td><label id="txtPassportNo"></label></td>
									</tr>
									<!-- <tr>
										<td width="18%">Billing Detail</td>
										<td><label id="cmbBillingDetail"></label></td>
									</tr> -->
									<tr>
										<td width="18%">Locker Detail</td>
										<td><label id="cmbLockerDetail"></label></td>
									</tr>
									<tr>
										<td width="18%">Library Facility</td>
										<td><label id="cmbLibrary"></label></td>
									</tr>
									<tr>
										<td width="18%">Senior Citizen</td>
										<td><label id="cmbSeniorCitizen"></label></td>
									</tr>
									<tr>
										<td width="18%">Stop Credit Supply</td>
										<td><label id="cmbStopCredit"></label></td>
									</tr>
									<tr>
										<td width="18%">Resident</td>
										<td><label id="cmbResident"></label></td>
									</tr>
									<tr>
										<td width="18%">Instation</td>
										<td><label id="txtInstation"></label></td>
									</tr>
									<tr>
										<td width="18%">Golf Membership</td>
										<td><label id="cmbGolfMemberShip"></label></td>
									</tr>
									<tr>
										<td width="18%">Send Innvoice through</td>
										<td><label id="cmbsendInnvoicethrough"></label></td>
									</tr>
									<tr>
										<td width="18%">Circulars/Notice</td>
										<td><label id="cmbNotice"></label></td>
									</tr>
							</table>
						</div>
						
		<!--   tab-6  Bank Info  -->
							<div id="tab6" class="tab_content" style="width: 1000px;display: block;"><br><br>
								<table class="transTable">
									<tr>
										<td width="18%">Bank Code</td>
												<td><label id="txtBankCode"></label></td>
											<s:errors path=""></s:errors>
									</tr>
									<tr>
										<td width="18%">IFSC Code</td>
										<td><label id="txtIfscCOde"></label></td>
									</tr>
									<tr>
										<td width="18%"><label>Account No</label></td>
										<td width="100%"><label id="txtAccNo"></label></td>
									</tr>
									<tr>
										<td width="18%"><label>Branch</label></td>
										<td width="100%"><label id="txtBranchName"></label></td>
									</tr>
								</table>
							</div>
						
		<!--    tab-7  Other Info   -->
							<div id="tab7" class="tab_content" style="width: 1000px;height: 290px; display: none;">
								<br><br><br>
								 <div class="masterTable" style="height:293px !important width :803px!important " >
									<table style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
											<tr bgcolor="#c0c0c0">
											<td style="width:10%;">Field Name</td>
											<td style="width:15%;">Field Value</td>										
										</tr>
									</table>
									<div style="border: 1px solid #ccc; display: block; height: 250px; margin: auto; overflow-x: hidden; overflow-y: auto; width: 99.80%;">
										<table id="tblFieldsData" style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll" class="transTablex col8-center">
											<tbody id="tblFieldData">								
												<col style="width:10%">					
												<col style="width:15%">								
											</tbody>
										</table>
									</div>
								</div> 						
							</div>
						
		<!--   tab-8  Dependent List  -->
							<div id="tab8" class="tab_content" style="width: 100%;display: block;"><br><br>
								<div class="container masterTable " style="height: 300px;width: 99.80%;">
									<!-- <table style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
										<tr bgcolor="#c0c0c0">				
											<td style="width:15.1%;">Member Code</td>
											<td style="width:6.1%;">Full Name</td>
											<td style="width:6.1%;">Relation</td>
											<td style="width:6.1%;">Sex</td>
											<td style="width:6.1%;">Marital</td>
											<td style="width:6.8%;">DOB</td>
											<td style="width:6.8%;">Blocked</td>
											<td style="width:6.8%;">Blocked Reason</td>
											<td style="width:6.8%;">Profession</td>
											<td style="width:6.8%;">Mem Exp Date</td>
											
										</tr>
									</table> -->
							
						<div class="container masterTable" style="width :100%; overflow:auto; border: 0.5px solid grey;">
							<table class="table table-striped masterTable"  style="width :100%;">
									<thead>
										<tr>
											 <th>Member Code</th>
											 <th>Full Name</th>
											 <th>Relation</th>
											 <th>Sex</th>
											 <th>Marital</th>
											 <th>DOB</th>
											 <th>Blocked</th>
											 <th>Blocked Reason</th>
											 <th>Profession</th>
											 <th>Mem Exp Date</th>
										</tr>
									</thead>
									<tbody id="tblDependentData" class="transTablex">
									</tbody>
								 </table> 
							</div>
												
								<%-- <div style="border: 1px solid #ccc; display: block; height: 250px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 99.80%;">
									<table id="tblDependentData"
										style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
										class="transTablex col8-center">
										<tbody>			
											<col style="width:10%;">	
											<col style="width:10%;">
											<col style="width:10%;">
											<col style="width:10%;">
											<col style="width:10%;">
											<col style="width:10%;">
											<col style="width:10%;">
										</tbody>
									</table>
								</div> --%>
							</div>	
						</div>
						
		<!--   tab-9 PDC   -->
						
							<div id="tab9" class="tab_content" style="width: 1190px;height: 290px; display: none;">
								<br/><br/>
								<label><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Recieved Cheque</b></label><br/><br/>
						<div class="dynamicTableContainer" style="height: 300px;width: 99.80%;">
							<table style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
								<tr bgcolor="#c0c0c0">				
									<td style="width:6.1%;">&nbsp;Member Code</td>
									<td style="width:6.1%;">&nbsp;Drawn On</td>
									<td style="width:6.1%;">&nbsp;Cheque No</td>
									<td style="width:6.1%;">&nbsp;Cheque Date</td>
									<td style="width:6.1%;">&nbsp;Amount</td>
									<td style="width:6.8%;">&nbsp;Type</td>
								</tr>
							</table>							
							<div style="border: 1px solid #ccc; display: block; height: 250px; margin: auto; overflow-x: auto; overflow-y: auto; width: 99.80%;">
								<table id="tblDetails"
									style="width: 100%; border: #0F0; table-layout: fixed; overflow: auto"
									class="transTablex col8-center">
									<tbody>			
										<col style="width:20.5%;">	
										<col style="width:21.5%;">
										<col style="width:21.5%;">
										<col style="width:21.7%;">
										<col style="width:21.5%;">
										<col style="width:21%;">
										<col style="width:2.4%;">
									</tbody>
								</table>
							</div> 
						</div>	
						<label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Total&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
						<label id="lblReceived"></label>
						
						<br/>
						<label><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Issued Cheque</b></label>
						<br/><br/>
						<div class="dynamicTableContainer" style="height: 300px;width: 99.80%;">
							<table
								style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
								<tr bgcolor="#c0c0c0">				
									<td style="width:6.1%;">&nbsp;Member Code</td>
									<td style="width:6.1%;">&nbsp;Drawn On</td>
									<td style="width:6.1%;">&nbsp;Cheque No</td>
									<td style="width:6.1%;">&nbsp;Cheque Date</td>
									<td style="width:6.1%;">&nbsp;Amount</td>
									<td style="width:6.8%;">&nbsp;Type</td>
								</tr>
							</table>
							
							<div style="border: 1px solid #ccc; display: block; height: 250px; margin: auto; overflow-x: auto; overflow-y: auto; width: 99.80%;">
								<table id="tblDetailss"
									style="width: 100%; border: #0F0; table-layout: fixed; overflow: auto"
									class="transTablex col8-center">
									<tbody>			
										<col style="width:20.5%;">	
										<col style="width:21.5%;">
										<col style="width:21.5%;">
										<col style="width:21.7%;">
										<col style="width:21.5%;">
										<col style="width:21%;">
										<col style="width:2.4%;">
									</tbody>
								</table>
							</div>
						</div>
					<label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Total&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
						<label id="lblIssued"></label>
						
								
							</div>
								
					</div>
					 </td>
				</tr>
			</table> 
	</s:form>
</div>
</body>
</html>