<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
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
		<script type="text/javascript" src="<spring:url value="/resources/js/Accordian/jquery.multi-accordion-1.5.3.js"/>"></script>
	 
<style type="text/css">
.center {
	text-align: center;
}	
.btn{
margin:0px;}
</style>
	
	
	<script type="text/javascript">
		
	$(document).ready(function() {	
// 	    date picker
   		$("#txtdtDateofBirth").datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtdtDateofBirth" ).datepicker('setDate', 'today');
		$("#txtdtDateofBirth").datepicker();
		
        $("#txtdtBallotDate").datepicker({ dateFormat: 'dd-mm-yy' });
        $("#txtdtBallotDate" ).datepicker('setDate', 'today');
        $("#txtdtBallotDate").datepicker();
            
        $("#txtdtMembershipStartDate").datepicker({ dateFormat: 'dd-mm-yy' });
        $("#txtdtMembershipStartDate" ).datepicker('setDate', 'today');
        $("#txtdtMembershipStartDate").datepicker();
        
        $("#txtdtMembershipEndDate").datepicker({ dateFormat: 'dd-mm-yy' });
        $("#txtdtMembershipEndDate" ).datepicker('setDate', 'today');
        $("#txtdtMembershipEndDate").datepicker();
        
        $("#txtdtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
        $("#txtdtToDate" ).datepicker('setDate', 'today');
        $("#txtdtToDate").datepicker();
        
        $("#txtdtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
        $("#txtdtToDate" ).datepicker('setDate', 'today');
        $("#txtdtToDate").datepicker();
        
        
        $("#txtdtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
        $("#txtdtFromDate" ).datepicker('setDate', 'today');
        $("#txtdtFromDate").datepicker();
        
        $("#txtdtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
        $("#txtdtFromDate" ).datepicker('setDate', 'today');
        $("#txtdtFromDate").datepicker();
        
        $("#txtdtSpouseDateofBirth").datepicker({ dateFormat: 'dd-mm-yy' });
        $("#txtdtSpouseDateofBirth" ).datepicker('setDate', 'today');
        $("#txtdtSpouseDateofBirth").datepicker();
        
        $("#txtdtAnniversary").datepicker({ dateFormat: 'dd-mm-yy' });
        $("#txtdtAnniversary" ).datepicker('setDate', 'today');
        $("#txtdtAnniversary").datepicker();
        
        $("#txtdteDependentDateofBirth").datepicker({ dateFormat: 'dd-mm-yy' });
        $("#txtdteDependentDateofBirth" ).datepicker('setDate', 'today');
        $("#txtdteDependentDateofBirth").datepicker();
        
        $("#txtdteDependentMemExpDate").datepicker({ dateFormat: 'dd-mm-yy' });
        $("#txtdteDependentMemExpDate" ).datepicker('setDate', 'today');
        $("#txtdteDependentMemExpDate").datepicker();
        
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
            
            
       
            
            $('#cmbMaritalStatus').change(function () {
            	var memcode=$('#txtMemberCode').val();
        		var maritalStatus = $('#cmbMaritalStatus').val();
        		if(maritalStatus=="Married")
        			{
	        			document.all[ "headerSpouse" ].style.display = 'block';
	        			document.all[ "divSpouse" ].style.display = 'block';
	        			
	        			
	        			document.all[ "headerDependent" ].style.display = 'block';	        			
	        			document.all[ "divDependent" ].style.display = 'block';
	        			
	        			
	        			
	        			$('#txtChangeDependentCode').val("03");
	        			$('#txtChangeDependentMemberCode').val(memcode);		
	        			
	        			$('#txtSpouseCode').val(memcode +" 02");
	        			
	        			
	        			
        			}else
        			{
        				document.all[ "headerSpouse" ].style.display = 'none';
            			document.all[ "divSpouse" ].style.display = 'none';
            			
            			
	        			document.all[ "headerDependent" ].style.display = 'none';	        			
	        			document.all[ "divDependent" ].style.display = 'none';
	        			
            			
            			$('#txtChangeDependentCode').val("02");
            			$('#txtChangeDependentMemberCode').val(memcode);
        			}
        		
        		 
        	});
            
            
            

        });
		
	
        $(document)
                .ready(
                        function()
                        {
                            var message = '';
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

		});
        
        
        function funResetField()
		{
			location.reload(true); 
		}
        
        
        /* function funValidate()
		{
        	var flag =true;
        	
        	if($("#txtMemberCode").val().trim().length==0)
        		{
        			alert("Enter Member Code")
        			flag =false;
        		}
        	else if($("#txtFirstName").val().trim().length==0)
    		{
        		alert("Enter FirstName")
    			flag =false;
    		}
        	else if($("#txtResidentAddressLine1").val().trim().length==0)
    		{
        		alert("Enter Resident Address Line1")
    			flag =false;
    		}
        	else if($("#txtResidentAreaCode").val().trim().length==0)
    		{
        		alert("Enter Resident Area Code")
    			flag =false;
    		}
        	else if($("#txtProfessionCode").val().trim().length==0)
    		{
        		alert("Enter Profession Code")
    			flag =false;
    		}
        	else if($("#txtMSCategoryCode").val().trim().length==0)
    		{
        		alert("Enter Membership Category")
    			flag =false;
    		}
        	else if($("#txtQualification").val().trim().length==0)
    		{
        		alert("Enter Qualification")
    			flag =false;
    		}
        	
        	
        	
        	
			 return flag;
		} */
        

		 
		 
			
			function funloadMemberData(code)
			{
				var searchurl=getContextPath()+"/loadWebClubMemberPre-ProfileData.html?primaryCode="+code;
				//alert(searchurl);
				 $.ajax({
					        type: "GET",
					        url: searchurl,
					        success: function(response)
					        {
					        	if(response.strMemberCode=='Invalid Code')
					        	{
					        		alert("Invalid Member Code");
					        		$("#txtMemberCode").val('');
					        	}
					        	else
					        	{  
					        		funDeleteTableAllRows();
					        		//funRemoveAllRows();
					        		var memberCode = response[0].strMemberCode ;
					        		var menber = memberCode.split(" ");
						        	$("#txtMemberCode").val(menber[0]);
						        	$("#txtChangeDependentMemberCode").val(menber[0]);
						        	$("#txtCustCode").val(response[0].strCustomerCode);
						        	var isSpous;
						        	if(response[0].strMaritalStatus=="married")
						        		{
							        		document.all[ "headerSpouse" ].style.display = 'block';
						        			document.all[ "divSpouse" ].style.display = 'block';
						        			isSpous=funSetSpouseData(response[1]);
						        		}
						        	
						        	var k = 1;
						        	if(isSpous==true)
						        		{
						        			k =2;
						        		}
						        	
									for(var i=k;i<response.length;i++)
										{
											funAddDependentTableRow(response[i],i);
										}
						        	$("#txtFirstName").val(response[0].strFirstName);							        							        						        	
						        	$("#txtMiddleName").val(response[0].strMiddleName);
						        	$("#txtLastName").val(response[0].strLastName);
						        	$("#txtFullName").val(response[0].strFullName);
						        	
						        	$("#txtFirstName").focus();
						        	
						        	$("#txtCustomerCode").val(response[0].strCustomerCode);
						        	$("#txtPrefixCode").val(response[0].strPrefixCode);
						        	$("#txtNameOnCard").val(response[0].strNameOnCard);
						        	$("#txtResidentAddressLine1").val(response[0].strResidentAddressLine1);
						        	$("#txtResidentAddressLine2").val(response[0].strResidentAddressLine2);
						        	
						        	$("#txtResidentAddressLine3").val(response[0].strResidentAddressLine3);
						        	$("#txtResidentLandMark").val(response[0].strResidentLandMark);
						        	if(response[0].strResidentAreaCode!='')
						        		{
						        			funSetResAreaCode(response[0].strResidentAreaCode);
						        		}
						        	
						        	//$("#txtResidentAreaCode").val(response[0].strResidentAreaCode);
						        	$("#txtResidentCtCode").val(response[0].strResidentCtCode);
						        	$("#txtResidentStateCode").val(response[0].strResidentStateCode);
						        	
						        	$("#txtResidentRegionCode").val(response[0].strResidentRegionCode);
						        	$("#txtResidentCountryCode").val(response[0].strResidentCountryCode);
						        	$("#txtResidentPinCode").val(response[0].strResidentPinCode);
						        	$("#txtResidentTelephone1").val(response[0].strResidentTelephone1);
						        	$("#txtResidentTelephone2").val(response[0].strResidentTelephone2);
						        	
						        	$("#txtResidentFax1").val(response[0].strResidentFax1);
						        	$("#txtResidentFax2").val(response[0].strResidentFax2);
						        	$("#txtResidentMobileNo").val(response[0].strResidentMobileNo);
						        	$("#txtResidentEmailID").val(response[0].strResidentEmailID);
						        	$("#txtCompanyCode").val(response[0].strCompanyCode);
						        	
						        	$("#txtCompanyName").val(response[0].strCompanyName);
						        	$("#txtHoldingCode").val(response[0].strHoldingCode);
						        	$("#txtJobProfileCode").val(response[0].strJobProfileCode);
						        	$("#txtCompanyAddressLine1").val(response[0].strCompanyAddressLine1);
						        	$("#txtCompanyAddressLine2").val(response[0].strCompanyAddressLine2);
						        	
						        	$("#txtCompanyAddressLine3").val(response[0].strCompanyAddressLine3);
						        	$("#txtCompanyLandMark").val(response[0].strCompanyLandMark);
						        	if(response[0].strCompanyAreaCode!='')
						        		{
							        		funSetComAreaCode(response[0].strCompanyAreaCode);
						        		}						        	
						        	//$("#txtCompanyCtCode").val(response[0].strCompanyCtCode);
						        	$("#txtCompanyStateCode").val(response[0].strCompanyStateCode);
						        	
						        	$("#txtCompanyRegionCode").val(response[0].strCompanyRegionCode);
						        	$("#txtCompanyCountryCode").val(response[0].strCompanyCountryCode);
						        	$("#txtCompanyPinCode").val(response[0].strCompanyPinCode);
						        	$("txtCompanyTelePhone1").val(response[0].strCompanyTelePhone1);
						        	$("#txtCompanyTelePhone2").val(response[0].strCompanyTelePhone2);
						        	
						        	$("#txtCompanyFax1").val(response[0].strCompanyFax1);
						        	$("#txtCompanyFax2").val(response[0].strCompanyFax2);
						        	$("#txtCompanyMobileNo").val(response[0].strCompanyMobileNo);
						        	$("#txtCompanyEmailID").val(response[0].strCompanyEmailID);
						        	$("#txtBillingAddressLine1").val(response[0].strBillingAddressLine1);
						        	
						        	$("#txtBillingAddressLine2").val(response[0].strBillingAddressLine2);
						        	$("#txtBillingAddressLine3").val(response[0].strBillingAddressLine3);
						        	$("#txtBillingLandMark").val(response[0].strBillingLandMark);
						        	if(response[0].strCompanyAreaCode!='')
					        		{
						        		funSetBillingAreaCode(response[0].strBillingAreaCode);							        	
					        		}
						        	//$("#txtBillingAreaCode").val(response[0].strBillingAreaCode);
						        	$("#txtBillingCtCode").val(response[0].strBillingCtCode);
						       
						        	$("#txtBillingStateCode").val(response[0].strBillingStateCode);
						        	$("#txtBillingRegionCode").val(response[0].strBillingRegionCode);
						        	$("#txtBillingCountryCode").val(response[0].strBillingCountryCode);
						        	$("#txtBillingPinCode").val(response[0].strBillingPinCode);
						        	$("#txtBillingTelePhone1").val(response[0].strBillingTelePhone1);
						        	
						        	$("#txtBillingTelePhone2").val(response[0].strBillingTelePhone2);
						        	$("#txtBillingFax1").val(response[0].strBillingFax1);
						        	$("#txtBillingFax2").val(response[0].strBillingFax2);
						        	$("#txtBillingMobileNo").val(response[0].strBillingMobileNo);
						        	$("#txtBillingEmailID").val(response[0].strBillingEmailID);
						        	
						        	$("#txtBillingFlag").val(response[0].strBillingFlag);
						        	$("#txtGender").val(response[0].strGender);
						        	
						        	var dob=response.dteDateofBirth;						        	
						        	//alert("DOB="+dob);
						        	
						        	
						            $("#txtdtDateofBirth").datepicker({dateFormat: 'dd-mm-yy'}).datepicker('setDate', dob);						        	
						        	$("#txtdtDateofBirth").val(response[0].dteDateofBirth);
						        	$("#cmbMaritalStatus").val(response[0].strMaritalStatus);
						        	if(response[0].strCompanyAreaCode!='')
					        		{
						        	funSetProfessionCode(response[0].strProfessionCode);
					        		}
						        	//$("#txtProfessionCode").val(response[0].strProfessionCode);
						        	if(response[0].strCompanyAreaCode!='')
					        		{
							        	funSetMemberCategory(response[0].strCategoryCode);
					        		}
						        	//$("#txtMSCategoryCode").val(response[0].strCategoryCode);
						        	$("#txtPanNumber").val(response[0].strPanNumber);
						        	$("#txtProposerCode").val(response[0].strProposerCode);
						        	$("#txtSeconderCode").val(response[0].strSeconderCode);
						        	$("#txtBlocked").val(response[0].strBlocked);
						        	if(response[0].strBlockedreasonCode!='')
					        		{
						        		funSetBlockReasonCode(response[0].strBlockedreasonCode);
					        		}
						        	//$("#txtBlockedreasonCode").val(response[0].strBlockedreasonCode);
						        	if(response[0].strQualification!='')
					        		{
						        		funSetEducationCode(response[0].strQualification);
					        		}
						        	//$("#txtQualification").val(response[0].strQualification);
						        	if(response[0].strDesignationCode!='')
					        		{
						        		funSetDesignationCode(response[0].strDesignationCode);
					        		}
						        	//$("#txtDesignationCode").val(response[0].strDesignationCode);
						        	$("#txtLocker").val(response[0].strLocker);
						        	$("#txtLibrary").val(response[0].strLibrary);
						        	
						        	$("#txtInstation").val(response[0].strInstation);
						        	$("#txtSeniorCitizen").val(response[0].strSeniorCitizen);
						        	$("#txtdblEntranceFee").val(response[0].dblEntranceFee);
						        	$("#txtdblSubscriptionFee").val(response[0].dblSubscriptionFee);
						        	$("#txtGolfMemberShip").val(response[0].strGolfMemberShip);
						        	
						        	$("#txtStopCredit").val(response[0].strStopCredit);
						        	$("txtFatherMemberCode").val(response[0].strFatherMemberCode);
						        	
						        	//$("#txtStatusCode").val(response.strStatusCode);
						        	
						        	
						        	
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
		 
		 function funSetSpouseData(response)
		 {
			 var flgISSpouse =false;
			 if(!(response.dteAnniversary=="" || response.dteAnniversary==null) )
			 {
				 $("#txtSpouseCode").val(response.strMemberCode);
				 $("#txtSpouseFirstName").val(response.strFirstName);
				 $("#txtSpouseMiddleName").val(response.strMiddleName);
				 $("#txtSpouseLastName").val(response.strLastName);
				 $("#txtSpouseProfessionName").val(response.strProfessionCode);
				 $("#txtdtSpouseDateofBirth").val(response.dteDateofBirth);
				 $("#txtSpouseCompanyCode").val(response.strCompanyCode);
				 $("#txtSpouseJobProfileCode").val(response.strJobProfileCode);
				 $("#txtdtAnniversary").val(response.dteAnniversary);
				 $("#cmbSpouseFacilityBlock").val(response.strBlocked);
				 $("#cmbSpouseStopCredit").val(response.strStopCredit);
				 if(response.strCustomerCode!='')
					 {
					 $("#txtSpouseCustCode").val(response.strCustomerCode);
					 }
				
 			 	 $("#txtSpouseProfessionCode").val(response.strProfessionCode);
				 $("#txtSpouseResidentEmailID").val(response.strResidentEmailID);
	 			 $("#txtSpouseResidentMobileNo").val(response.strResidentMobileNo);
	// 			 $("#").val();
	 			flgISSpouse =true;
			 }
			 return flgISSpouse; 
		 }
		 
		 

		 
		 function funHelp(transactionName)
			{
				fieldName=transactionName;
			//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
				window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
			}
		 
		 
	function funSetData(code){

		switch(fieldName){

			case 'WCResAreaMaster' : 
				funSetResAreaCode(code);
				break;
			case 'WCComAreaMaster' : 
				funSetComAreaCode(code);
				break;
			case 'WCBillingAreaMaster' : 
				funSetBillingAreaCode(code);
				break;
				
			case 'WCResCityMaster' : 
				funSetResCityCode(code);
				break;
			case 'WCComCityMaster' : 
				funSetComCityCode(code);
				break;
			case 'WCBillingCityMaster' : 
				funSetBillingCityCode(code);
				break;
			
			case 'WCResCountryMaster' : 
				funSetResCountryCode(code);
				break;
			case 'WCComCountryMaster' : 
				funSetComCountryCode(code);
				break;
			case 'WCBillingCountryMaster' : 
				funSetBillingCountryCode(code);
				break;
			
			case 'WCResStateMaster' : 
				funSetResStateCode(code);
				break;
				
			case 'WCComStateMaster' : 
				funSetComStateCode(code);
				break;
				
			case 'WCBillingStateMaster' : 
				funSetBillingStateCode(code);
				break;				
			
			case 'WCResRegionMaster' : 
				funSetResRegionCode(code);
				break;
			case 'WCComRegionMaster' : 
				funSetComRegionCode(code);
				break;
			case 'WCBillingRegionMaster' : 
				funSetBillingRegionCode(code);
				break;
				
			case 'WCmemProfile' :
				funloadMemberData(code);
				break;
			
			/* case 'WCmemProfileCustomer' :
				funloadMemberData(code);
				//funloadMemberCustomerData(code);
				break;	 */	
				
			case 'WCmemPre-ProfileCustomer' :
				funloadMemberData(code);				
				break;				
				
			case 'WCEducationMaster' : 
				funSetEducationCode(code);
				break;
			case 'WCMaritalMaster' : 
				funSetMaritalCode(code);
				break;
			case 'WCProfessionMaster' : 
				funSetProfessionCode(code);
				break;
			case 'WCDesignationMaster' : 
				funSetDesignationCode(code);
				break;
			case 'WCReasonMaster' : 
				funSetReasonCode(code);
				break;
			case 'WCBlockReasonMaster' : 
				funSetBlockReasonCode(code);
				break;	
				
			case 'WCProfessionMaster' :
				funSetProfessionForMember(code);
				break;
				
			case 'WCDependentProfessionMaster' :
				funSetProfessionForDependent(code);
				break;
				
				
			case 'WCDependentReasonMaster' : 
				funSetDependentReasonCode(code);
				break;	
				
			case 'WCSpouseProfessionMaster' :	
				funSetProfessionForSpouse(code);
				break;
				
				
			case 'WCMemberForm':
		    	funSetFormNo(code);
		        break; 	
			
			case 'WCCatMaster' :	
				funSetMemberCategory(code);
				break;
				
				
		}
	}
	
	 function funSetMemberCategory(code)
		{
			$("#txtMSCategoryCode").val(code);
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
					        	$("#txtMSCategoryCode").val(code);
					        	$("#txtMemberName").val(response.strCatName);
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
		$("#txtResidentAreaCode").val(code);
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
		        		alert("Invalid Area Code");
		        		$("#txtGroupCode").val('');
		        	}
		        	else
		        	{
		        		funSetResCityCode(response.strCityCode);  
		        		//$("#txtResidentAreaCode").val(response.strAreaCode);
			        	$("#txtResidentAreaName").val(response.strAreaName);
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

		$("#txtCompanyAreaCode").val(code);
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
		        		alert("Invalid Company Area Code");
		        		$("#txtGroupCode").val('');
		        	}
		        	else
		        	{
			        	$("#txtCompanyAreaName").val(response.strAreaName);
			        	funSetComCityCode(response.strCityCode);
			        	
			        	
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

		$("#txtBillingAreaCode").val(code);
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
		        		alert("Invalid Billing Area Code");
		        		$("#txtGroupCode").val('');
		        	}
		        	else
		        	{
		        		funSetBillingCityCode(response.strCityCode);
			        	$("#txtBillingAreaName").val(response.strAreaName);
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
		$("#txtResidentCtCode").val(code);
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
		        		
		        		
		        		$("#txtResidentCtCode").val(response.strCityCode);	
		        		$("#txtResidentCtName").val(response.strCityName);	
		        		
		        		$("#txtResidentPinCode").val(response.strSTDCode);	
		        		funSetResStateCode(response.strStateCode);
		        		funSetResCountryCode(response.strCountryCode);	       		
		        		
// 		        		$("#txtCityName").val(response.strCityName);
// 		        		$("#txtCityStdCode").val(response.strSTDCode);
// 		        		$("#txtStateCode").val(response.strStateCode);
// 		        		$("#txtCountryCode").val(response.strCountryCode);
		        		 
		        		
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
	
	$("#txtCompanyCtCode").val(code);
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
	        			$("#txtCompanyPinCode").val(response.strSTDCode);
	        			funSetComStateCode(response.strStateCode);
	        			funSetComCountryCode(response.strCountryCode);
		        		$("#txtCompanyCtName").val(response.strCityName);
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
	
	$("#txtBillingCtCode").val(code);
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
	        		        		
		        	$("#txtBillingCtName").val(response.strCityName);
		        	$("#txtBillingPinCode").val(response.strSTDCode);	
		        	funSetBillingStateCode(response.strStateCode);
	        		funSetBillingCountryCode(response.strCountryCode);
	        		
		        	
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
	    
	$("#txtResidentCountryCode").val(code);
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
	        		//funSetResRegionCode(response.strRegionCode);
	        		$("#txtResidentCountryCode").val(response.strCountryCode);
	        		$("#txtResidentCountryName").val(response.strCountryName);
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
	  
	$("#txtCompanyCountryCode").val(code);
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
	        		$("#txtCompanyCountryName").val(response.strCountryName);
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
	 
	$("#txtBillingCountryCode").val(code);
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
	        		$("#txtBillingCountryName").val(response.strCountryName);
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

	$("#txtResidentStateCode").val(code);
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
	        		funSetResRegionCode(response.strRegionCode);
	        		$("#txtResidentStateCode").val(response.strStateCode);
	        		$("#txtResidentStateName").val(response.strStateName);    
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
	  
	$("#txtCompanyStateCode").val(code);
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
	        		$("#txtCompanyStateName").val(response.strStateName);
	        		 
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
	  
	$("#txtBillingStateCode").val(code);
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
	        		$("#txtBillingStateName").val(response.strStateName);
	        		 
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
	
	$("#txtResidentRegionCode").val(code);
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
	        		//alert("Invalid Region Code In");
	        		$("#txtRegionCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtResidentRegionCode").val(response.strRegionCode);
	        		$("#txtResidentRegionName").val(response.strRegionName);
	        		
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
	
	$("#txtCompanyRegionCode").val(code);
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
	        		//alert("Invalid Region Code In");
	        		$("#txtRegionCode").val('');
	        	}
	        	else
	        	{
	        		
	        		$("#txtCompanyRegionName").val(response.strRegionName);
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
	
	$("#txtBillingRegionCode").val(code);
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
	        		//alert("Invalid Region Code In");
	        		$("#txtRegionCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtBillingRegionName").val(response.strRegionName);
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

	function btnAdd_onclick() 
	{	
		var dependentMemberCode=$("#txtChangeDependentMemberCode").val();
	    var ChangedependentCode =$("#txtChangeDependentCode").val();
	    var genratedMemberCode = "";
	    genratedMemberCode = dependentMemberCode+" "+ ChangedependentCode;
		
		if(funDuplicateMember(genratedMemberCode))
			{
	   		funAddDependentRow();
			}
	}
	function funAddDependentRow() 
	{
				var table = document.getElementById("tblDependentData");
				var rowCount = table.rows.length;
				var row = table.insertRow(rowCount);
// 				var name = $("#tblDependentData").find('tr:first').find('td:first').text();
// 				alert(name);
// 				alert("Hello "+$(this).find('td:first').text())
				
				
				var dependentCode = $("#txtDependentCode").val();
				var dependentName = $("#txtDependentName").val()
				var dependentMemberCode=$("#txtChangeDependentMemberCode").val();
			    var ChangedependentCode =$("#txtChangeDependentCode").val();
			    var genratedMemberCode = "";
			    var typeMember = "";
			    genratedMemberCode = dependentMemberCode+" "+ ChangedependentCode;
			    
			    var relation = $("#txtDependentRelation").val();
			    var gender = $("#cmbDependentGender").val();
			    
			    var mStatus  = $("#cmbDependentMaritalStatus").val();
			    var DOB = $("#txtdteDependentDateofBirth").val();
			    var memExpDate = $("#txtdteDependentMemExpDate").val();
			    var blocked = $("#cmbDependentBlock").val();
			    var blockedReason = $("#txtDependentReasonCode").val();
			    var profession = $("#txtDependentProfessionCode").val();
			    
			    
			    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"20%\" name=\"listDependentMember["+(rowCount)+"].strMemberCode\" id=\"txttblDependentMemberCode."+(rowCount)+"\" value='"+genratedMemberCode+"' onclick=\"funRowClick()\" >";
			    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"30%\" name=\"listDependentMember["+(rowCount)+"].strDependentFullName\" id=\"txttblDependentName."+(rowCount)+"\" value='"+dependentName+"'>";
			    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"20%\" name=\"listDependentMember["+(rowCount)+"].strDepedentRelation\" id=\"txttblDepedentRelation."+(rowCount)+"\" value='"+relation+"'>";
			    row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" name=\"listDependentMember["+(rowCount)+"].strGender\" id=\"txttblDependentGender."+(rowCount)+"\" value='"+gender+"'>";
			    row.insertCell(4).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" name=\"listDependentMember["+(rowCount)+"].strMaritalStatus\" id=\"txttblDependentMaritalStatus."+(rowCount)+"\" value='"+mStatus+"'>";
			    row.insertCell(5).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"20%\" name=\"listDependentMember["+(rowCount)+"].dteDependentDateofBirth\" id=\"txttblDependentDateofBirth."+(rowCount)+"\" value='"+DOB+"'>";
			    row.insertCell(6).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"20%\" name=\"listDependentMember["+(rowCount)+"].strBlocked\" id=\"txttblDependentBlocked."+(rowCount)+"\" value='"+blocked+"'>";
			    row.insertCell(7).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"5%\" name=\"listDependentMember["+(rowCount)+"].strDependentReasonCode\" id=\"txttblDependentReasonCode."+(rowCount)+"\" value='"+blockedReason+"'>";
			    row.insertCell(8).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"5%\" name=\"listDependentMember["+(rowCount)+"].strProfessionCode\" id=\"txttblProfessionCode."+(rowCount)+"\" value='"+profession+"'>";
			    row.insertCell(9).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"5%\" name=\"listDependentMember["+(rowCount)+"].dteMembershipExpiryDate\" id=\"txttbldteMembershipExpiryDate."+(rowCount)+"\" value='"+memExpDate+"'>";
			       
			    var dependentNumber = parseInt(ChangedependentCode) + 1;
			    if(dependentNumber<10)
			    	{
			    		dependentNumber = "0" + dependentNumber;
			    	}
			    $("#txtChangeDependentCode").val(dependentNumber);
			    
			 
			   return false;
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
			    
			    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"20%\" name=\"listDependentMember["+(rowCount)+"].strMemberCode\" id=\"txttblDependentMemberCode."+(rowCount)+"\" value='"+genratedMemberCode+"' onclick=\"funRowClick(this)\"  >";
			    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"30%\" name=\"listDependentMember["+(rowCount)+"].strDependentFullName\" id=\"txttblDependentName."+(rowCount)+"\" value='"+dependentName+"' onclick=\"funRowClick(this)\">";
			    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"20%\" name=\"listDependentMember["+(rowCount)+"].strDepedentRelation\" id=\"txttblDepedentRelation."+(rowCount)+"\" value='"+relation+"' onclick=\"funRowClick(this)\">";
			    row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" name=\"listDependentMember["+(rowCount)+"].strGender\" id=\"txttblDependentGender."+(rowCount)+"\" value='"+gender+"' onclick=\"funRowClick(this)\">";
			    row.insertCell(4).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" name=\"listDependentMember["+(rowCount)+"].strMaritalStatus\" id=\"txttblDependentMaritalStatus."+(rowCount)+"\" value='"+mStatus+"' onclick=\"funRowClick(this)\">";
			    row.insertCell(5).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"20%\" name=\"listDependentMember["+(rowCount)+"].dteDependentDateofBirth\" id=\"txttblDependentDateofBirth."+(rowCount)+"\" value='"+DOB+"' onclick=\"funRowClick(this)\">";
			    row.insertCell(6).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"20%\" name=\"listDependentMember["+(rowCount)+"].strBlocked\" id=\"txttblDependentBlocked."+(rowCount)+"\" value='"+blocked+"' onclick=\"funRowClick(this)\">";
			    row.insertCell(7).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"5%\" name=\"listDependentMember["+(rowCount)+"].strDependentReasonCode\" id=\"txttblDependentReasonCode."+(rowCount)+"\" value='"+blockedReason+"' onclick=\"funRowClick(this)\">";
			    row.insertCell(8).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"5%\" name=\"listDependentMember["+(rowCount)+"].strProfessionCode\" id=\"txttblProfessionCode."+(rowCount)+"\" value='"+profession+"' onclick=\"funRowClick(this)\">";
			    row.insertCell(9).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"5%\" name=\"listDependentMember["+(rowCount)+"].dteMembershipExpiryDate\" id=\"txttbldteMembershipExpiryDate."+(rowCount)+"\" value='"+memExpDate+"' onclick=\"funRowClick(this)\">";
			    row.insertCell(10).innerHTML= "<input Type=\"hidden\" readonly=\"readonly\" class=\"Box\" size=\"1%\" name=\"listDependentMember["+(rowCount)+"].strCustomerCode\" id=\"txttblCustomerCode."+(rowCount)+"\" value='"+customerCode+"' onclick=\"funRowClick(this)\">";
			    
				genratedMemberCode=genratedMemberCode.split(" ");


				
				var  nextdependentCode =1+parseInt(genratedMemberCode[1]);
				if(nextdependentCode<10)
			    	{
					nextdependentCode = "0" + nextdependentCode;
			    	}
				
			    $("#txtChangeDependentCode").val(nextdependentCode);
			    
			   return false;
	}
	


	function funResetTableData()
	{
		
		funDeleteTableAllRows(); 
		$('txtDependentName').val("");
		
		var dependentMemberCode=$("#txtChangeDependentMemberCode").val();
		 var fullName = $('#txtFullName').val();
		 var typeMember = "Primary";
		 var table = document.getElementById("tblDependentData");
		 var dependentcode = dependentMemberCode+" 01";
		 var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    
		    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"50%\" name=\"listDependentMember["+(rowCount)+"].strDependentMemberCode\" id=\"txtDependentMemberCode."+(rowCount)+"\" value='"+dependentcode+"'>";
		    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"50%\" name=\"listDependentMember["+(rowCount)+"].strDependentName\" id=\"txtDependentName."+(rowCount)+"\" value='"+fullName+"'>";
		    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"50%\" name=\"listDependentMember["+(rowCount)+"].strDependentMemberType\" id=\"txtDependentMemberType."+(rowCount)+"\" value='"+typeMember+"'>";
		 
		    $("#txtChangeDependentCode").val("02");  
		
	}
	
	function funFillDependentMasterTableData(docCode)
	{
		
// 		searchUrl=getContextPath()+"/loadDependentMasterData.html?docCode="+docCode;
// 		//alert(searchUrl);
// 		$.ajax({
// 		        type: "GET",
// 		        url: searchUrl,
// 			    dataType: "json",
			
// 			    success: function(response)
// 			    {
//     	    		funDeleteTableAllRows();
// 			    	$.each(response, function(i,item)
// 					{
// 			    		funLoadDependentTableData(response[i]);
// 					}); 
							
					    	
							
// 			    },
// 			    error: function(jqXHR, exception) {
// 		            if (jqXHR.status === 0) {
// 		                alert('Not connect.n Verify Network.');
// 		            } else if (jqXHR.status == 404) {
// 		                alert('Requested page not found. [404]');
// 		            } else if (jqXHR.status == 500) {
// 		                alert('Internal Server Error [500].');
// 		            } else if (exception === 'parsererror') {
// 		                alert('Requested JSON parse failed.');
// 		            } else if (exception === 'timeout') {
// 		                alert('Time out error.');
// 		            } else if (exception === 'abort') {
// 		                alert('Ajax request aborted.');
// 		            } else {
// 		                alert('Uncaught Error.n' + jqXHR.responseText);
// 		            }
// 		        }
// 		      });
	}
	
	
	
	
	
	
	
	function funLoadDependentTableData(rowData)
	{
		var table = document.getElementById("tblDependentData");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
		
		var dependentcode = rowData.strDependentMemberCode;
		var fullName = rowData.strDependentName;
		var arr = dependentcode.split(' ');
		var lastDependentCode = parseInt(arr[1]) +1;
		
		if(lastDependentCode<10)
    	{
			lastDependentCode = "0" + lastDependentCode;
    	}
		
		$('#txtChangeDependentCode').val(lastDependentCode);
		

		if(dependentcode == null){
			dependentcode="";
		}
		
		if(lastDependentCode == null){
			lastDependentCode="";
		}
		
		if(fullName == null){
			fullName="";
		}
		
		var strType="Primary"
		row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"50%\" name=\"listDependentMember["+(rowCount)+"].strDependentMemberCode\" id=\"txtDependentMemberCode."+(rowCount)+"\" value='"+dependentcode+"'>";
	    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"50%\" name=\"listDependentMember["+(rowCount)+"].strDependentName\" id=\"txtDependentName."+(rowCount)+"\" value='"+fullName+"'>";
	   
	    if(lastDependentCode==01)
	    	{
	    		row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"50%\"  id=\"txtTypeName."+(rowCount)+"\" value='"+strType+"'>";
	    	
	    	}
	    else
	    {
	    	row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"50%\"  id=\"txtTypeName."+(rowCount)+"\" value=''>";
	    }
	    
	    
	}

	
	function funDeleteTableAllRows()
	{
		$("#tblDependentData tr").remove();
	}

	
	function funSetEducationCode(code){

		$("#txtQualification").val(code);
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
		        		$("#txtQualificationName").val(response.strEducationDesc);
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
	
	
	function funSetProfessionCode(code){

		$("#txtProfessionCode").val(code);
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
		        		$("#txtProfessionName").val(response.strProfessionName);
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

		$("#txtDesignationCode").val(code);
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
		        		$("#txtDesignationName").val(response.strDesignationName);
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
	
	
	function funSetReasonCode(code){

		$("#txtReasonCode").val(code);
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
		        		alert("Invalid Reason Code In");
		        		$("#txtReasonCode").val('');
		        	}
		        	else
		        	{
		        		$("#txtReasonName").val(response.strReasonDesc);
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
		        		$("#txtBlockedReasonName").val(response.strReasonDesc);
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
	
	function funRowClick(object)
	{

   var no = object.parentNode.parentNode.rowIndex;
    
//      var no = parseInt( $("#tblDependentData").parent().index() );
      alert(no);
//      no =  parseInt(no)-1;           
    var DependentMemberCode = document.all("txttblDependentMemberCode."+no).value
	var DependentName = document.all("txttblDependentName."+no).value
	var relation = document.all("txttblDepedentRelation."+no).value
	var gender = document.all("txttblDependentGender."+no).value
	var mStatus = document.all("txttblDependentMaritalStatus."+no).value
	var DOB = document.all("txttblDependentDateofBirth."+no).value
	var blocked = document.all("txttblDependentBlocked."+no).value
	var blockedReason = document.all("txttblDependentReasonCode."+no).value
	var profession = document.all("txttblProfessionCode."+no).value
	var memExpDate = document.all("txttbldteMembershipExpiryDate."+no).value
	var customerCode = document.all("txttblCustomerCode."+no).value
    
	DependentMemberCode = DependentMemberCode.split(" ");
	
    
    $("#txtDependentCode").val(DependentMemberCode);
	$("#txtDependentName").val(DependentName)
	$("#txtDependentRelation").val(relation);
	$("#cmbDependentGender").val(gender);
	$("#cmbDependentMaritalStatus").val(mStatus);
	$("#txtdteDependentDateofBirth").val(DOB);
	$("#cmbDependentBlock").val(blocked);
	$("#txtDependentReasonCode").val(blockedReason);
	$("#txtDependentProfessionCode").val(profession);
	$("#txtdteDependentMemExpDate").val(memExpDate);
	 
	$("#txtChangeDependentMemberCode").val(DependentMemberCode[0]);
    $("#txtChangeDependentCode").val(DependentMemberCode[1]);
    
    $("#txttblCustomerCode").val(customerCode);
   
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
	
	
	function funSetProfessionForMember(code){

		$("#txtProfessionCode").val(code);
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
		        		$("#txtProfessionName").val(response.strProfessionName);
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
	
	function funSetProfessionForDependent(code){

		$("#txtDependentProfessionCode").val(code);
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
		        		$("#txtDependentProfessionCode").val('');
		        	}
		        	else
		        	{
		        		$("#strDependentProfessionName").val(response.strProfessionName);
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
	
	function funSetDependentReasonCode(code){

		$("#txtDependentReasonCode").val(code);
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
		        		alert("Invalid Reason Code In");
		        		$("#txtDependentReasonCode").val('');
		        	}
		        	else
		        	{
		        		$("#txtDependentReasonName").val(response.strReasonDesc);
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
	
	function funSetProfessionForSpouse(code){

		$("#txtSpouseProfessionCode").val(code);
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
		        		$("#txtSpouseProfessionCode").val('');
		        	}
		        	else
		        	{
		        		$("#txtSpouseProfessionName").val(response.strProfessionName);
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
	
	
	
	
	function funDuplicateMember(memberCode)
	{
	    var table = document.getElementById("tblDependentData");
	    var rowCount = table.rows.length;		   
	    var flag=true;
	    if(rowCount > 0)
	    	{
			    $('#tblDependentData tr').each(function()
			    {
				    if(memberCode==$(this).find('input').val())// `this` is TR DOM element
    				{
				    	alert("Already added "+ memberCode);
				    	 //funClearReqData();
	    				flag=false;
    				}
				});
			    
	    	}
	    return flag;
	  
	}
	
	function funProceed(){

		var formNo=$("#txtFormNo").val();
		if(parseInt(formNo)!=0)
			{
			
				//document.all[ 'multiAccordion' ].style.display = 'block';
				//document.all[ 'paraSubmit' ].style.display = 'block';
				
				//document.all[ 'uitblFrom' ].style.display = 'none';
				//document.all[ 'paraProceed' ].style.display = 'none';
				
			//	location.href = "frmMemberPreProfile.html";
				window.location.assign(getContextPath()+"/frmMemberProfile.html?saddr=1")
				
// 				var searchurl=getContextPath()+"/frmMemberProfile.html?formNo="+formNo;
// 				//alert(searchurl);
				
// 					$.ajax({ location.href='frmMemberPreProfile.html'
// 				        type: "GET",
// 				        url: searchurl,
// 				        dataType: "json",
// 				        success: function(response)
// 				        {
// 				        	if(response.strProfessionCode=='Invalid Code')
// 				        	{
// 				        		alert("Invalid Profession Code In");
// 				        		$("#txtSpouseProfessionCode").val('');
// 				        	}
// 				        	else
// 				        	{
// 				        		$("#txtSpouseProfessionName").val(response.strProfessionName);
// 				        	}
				        	
// 				        },
// 					error: function(jqXHR, exception) {
// 			            if (jqXHR.status === 0) {
// 			                alert('Not connect.n Verify Network.');
// 			            } else if (jqXHR.status == 404) {
// 			                alert('Requested page not found. [404]');
// 			            } else if (jqXHR.status == 500) {
// 			                alert('Internal Server Error [500].');
// 			            } else if (exception === 'parsererror') {
// 			                alert('Requested JSON parse failed.');
// 			            } else if (exception === 'timeout') {
// 			                alert('Time out error.');
// 			            } else if (exception === 'abort') {
// 			                alert('Ajax request aborted.');
// 			            } else {
// 			                alert('Uncaught Error.n' + jqXHR.responseText);
// 			            }		            
// 			        }
// 				});





 function funSetMemberCategory(code)
		{
			$("#txtMSCategoryCode").val(code);
			var searchurl=getContextPath()+"/loadMemberProfileForm.html?";
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
					        	$("#txtMSCategoryCode").val(code);
					        	$("#txtMemberName").val(response.strCatName);
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








 			}
		else
			{
				alert("Please Select Correct Form No..")
			}
		
	}
	
	function isNumber(evt) {
        var iKeyCode = (evt.which) ? evt.which : evt.keyCode
        if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57))
            return false;

        return true;
    }
	
	function funValidate()
	{	
		
		//pattern="[789][0-9]{9}"
		
		
		
		var flag=true;		
		$('#multiAccordion').multiAccordion({
			click: function(event, ui) {
			},
			init: function(event, ui) {
			},
			tabShown: function(event, ui) {
			},
			tabHidden: function(event, ui) {
			}			
		});
		
		
		
		if($("#txtResidentMobileNo").val().trim().length>=1)
		{
			if(/[789][0-9]{9}/.$("#txtResidentMobileNo").val())
				{
				$('#multiAccordion').multiAccordion("option", "active", [0]);
				document.getElementById("txtResidentMobileNo").focus();
				alert("Enter Correct Resident Mobile No");
				flag=false;
				}
			
			
			/* if(($("#txtResidentMobileNo").val().match("[789][0-9]{9}")))
			        {
						$('#multiAccordion').multiAccordion("option", "active", [0]);
						document.getElementById("txtResidentMobileNo").focus();
						alert("Enter Correct Resident Mobile No");
						flag=false;
			        }		 */	
		}		
		else if($("#txtMemberCode").val().trim().length<1)
		{
			$('#multiAccordion').multiAccordion("option", "active", [0]);
			document.getElementById("txtMemberCode").focus();
			alert("Enter Member Code");
			flag=false;
		}
		else if($("#txtFirstName").val().trim().length<1)
		{
			$('#multiAccordion').multiAccordion("option", "active", [0]);
			document.getElementById("txtFirstName").focus();
			alert("Enter First Name");
			flag=false;
		}		
		else if($("#txtResidentAddressLine1").val().trim().length<1)
		{
			$('#multiAccordion').multiAccordion("option", "active", [1]);
			document.getElementById("txtResidentAddressLine1").focus();
			alert("Resident Address Line1 ");
			flag=false;
		}			
		else if($("#txtResidentAreaCode").val().trim().length<1)
		{
			$('#multiAccordion').multiAccordion("option", "active", [1]);
			document.getElementById("txtResidentAreaCode").focus();
			alert("Enter Resident Area Name ");
			flag=false;
		}
		else if($("#txtResidentCtCode").val().trim().length<1)
		{
			$('#multiAccordion').multiAccordion("option", "active", [1]);
			document.getElementById("txtResidentCtCode").focus();
			alert("Enter Resident City Name ");
			flag=false;
		}		
		else if($("#txtResidentCountryCode").val().trim().length<1)
		{
			$('#multiAccordion').multiAccordion("option", "active", [1]);
			document.getElementById("txtResidentCountryCode").focus();
			alert("Resident Country Name ");
			flag=false;
		} 
		return flag;		
	}
	
	function funSetFormNo(code)
	{
		$("#txtFormNo").val(code);
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
	
	function funFillNameOnCard()
	{			
	$("#txtNameOnCard").val($("#txtFirstName").val()+" "+$("#txtMiddleName").val()+" "+$("#txtLastName").val());
	var demo=$("#txtFirstName").val()+" "+$("#txtMiddleName").val()+" "+$("#txtLastName").val();
	//alert(demo);
	}
	
	function isNumber(evt) {
        var iKeyCode = (evt.which) ? evt.which : evt.keyCode
        if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57))
            return false;

        return true;
    }  
	
	
		 	
</script>
</head>

<body>
 <div class="container">
	<label id="formHeading">Member Pre-Profile</label></div>
		<div>
	<s:form name="frmMemberPreProfile" action="saveMemberPreProfile.html?saddr=${urlHits}" method="POST">
		<br>
		
		 <div class="container mastertable"  style="background-color:#f2f2f2;" id="uitblFrom"> 
			<div class="row" style="background-color:#f2f2f2;">
  				<div class="col-md-12">
  					<label>From No:</label>
  				</div>
				<div class="col-md-12">
					<s:input type="text" id="txtFormNo" 
						name="txtFormNo" path="intFormNo" required="true"
						cssStyle="width: 20%; text-transform: uppercase;" ondblclick="funHelp('WCMemberForm')" /><s:errors path=""></s:errors>
				</div>
						
			</div>
		 </div> 
		
		<div id="paraProceed" class="center">
		<a href="#"><button class="btn btn-primary center-block" value="Submit" onclick="funProceed()" value="Proceed"
						class="form_button">Proceed</button></a>
			
		</div>
	
		
		<div id="multiAccordion" style="display:none;">	
		<h3><a href="#">Member Pre-Profile Detail</a></h3>
		<div>
			<div class="container transtable"  style="background-color:#f2f2f2;">
			<div class="row" >
				<div class="col-md-9">
  					<div class="row" ><div class="col-md-4"><label>Member Code</label><br><s:input id="txtMemberCode" type="search" 
									ondblclick="funHelp('WCmemPre-ProfileCustomer')" cssClass="searchTextBox" placeholder="Enter Member Code"
								  class="form-control" path="strMemberCode" ></s:input></div>
									<div class="col-md-4"><label>Prefix Code</label><br><s:select id="txtPrefixCode" path="strPrefixCode" name="txtPrefixCode">
													 <option value="Mr">Mr</option>
									 				 <option value="Mrs">Mrs</option>
									 				 <option value="Ms">Ms</option>
													 </s:select></div>
									<div class="col-md-4"><label>First  Name</label><br><s:input id="txtFirstName" placeholder="Enter First Name "  path="strFirstName"  type="text"></s:input></div>
									<div class="col-md-4"><label>Middle  Name</label><br><s:input id="txtMiddleName" placeholder="Enter Middle Name " path="strMiddleName" type="text"></s:input></div>
									<div class="col-md-4"><label>Last  Name</label><br><s:input id="txtLastName" placeholder="Enter Last Name " path="strLastName" 
										 type="text"></s:input></div>
					</div>
					<div class="row" >
					
					<div class="col-md-4"><label>Name On Card</label><br><s:input id="txtNameOnCard" placeholder="Enter Name On Card " path="strNameOnCard" type="text" onclick="funFillNameOnCard()" ></s:input></div>
									
					</div>
					</div>
				<!-- <div class="col-md-3">
				             <div><img id="memImage" src="" width="170px" height="150px" alt="Member Image"  ></div>
				                 <div ><input  id="memberImage" name="memberImage"   type="file" accept="image/gif,image/png,image/jpeg" onchange="funShowImagePreview(this);" style="width:170px;background-color: #C0E4FF"/></div></div> -->
	        </div></div>
	</div>
									
<h3><a href="#">Address Information</a></h3>
			<div>							
	<div id="tab_container" style="height: 250px">
			<div><ul class="tabs">
					<li class="active" data-state="tab1">Resident Address</li>
					<li data-state="tab2"> Company Address</li>
					<li data-state="tab3">Billing Address</li>
				</ul></div><br>
							
  <div id="tab1" class="tab_content">	
	     <div class="container transtable" style="background-color:#f2f2f2;">
			<div class="row" style="margin:0px; margin-top:26px;">
				<div class="col-md-12" style="align:left;"></div>
  				<div class="col-md-3"><label>Resident Address Line1</label><br><s:input id="txtResidentAddressLine1" path="strResidentAddressLine1" required="required"
						type="text"></s:input></div>
  				<div class="col-md-3"><label>Resident Address Line2</label><br><s:input id="txtResidentAddressLine2" path="strResidentAddressLine2" type="text"></s:input></div>
  				<div class="col-md-3"><label>Resident Address Line3</label><br><s:input id="txtResidentAddressLine3" path="strResidentAddressLine3"
						 type="text"></s:input></div>
  				<div class="col-md-3"><label>Resident LandMark</label><br><s:input id="txtResidentLandMark" path="strResidentLandMark" type="text"></s:input></div>
  		
				<div class="col-md-3"><label>Resident Area Name</label><br><s:input  id="txtResidentAreaName" path="strResidentAreaName" ondblclick="funHelp('WCResAreaMaster')" type="text" readonly="true" cssClass="searchTextBox"></s:input><s:input id="txtResidentAreaCode" path="strResidentAreaCode" type="hidden" readonly="true" ></s:input></div>
  				<div class="col-md-3"><label>Resident City Name</label><br><s:input id="txtResidentCtName" path="strResidentCtName" ondblclick="funHelp('WCResCityMaster')" type="text" readonly="true"  cssClass="searchTextBox"></s:input><s:input  id="txtResidentCtCode" path="strResidentCtCode" type="hidden" readonly="true" ></s:input></div>
  				<div class="col-md-3"><label>Resident State Name</label><br><s:input id="txtResidentStateName" path="strResidentStateName" ondblclick="funHelp('WCResStateMaster')" type="text" readonly="true" cssClass="searchTextBox"></s:input><s:input id="txtResidentStateCode" path="strResidentStateCode" type="hidden" readonly="true" ></s:input></div>
  				<div class="col-md-3"><label>Resident Country Name</label><br><s:input id="txtResidentCountryName" path="strResidentCountryName"  ondblclick="funHelp('WCResCountryMaster')" readonly="true" cssClass="searchTextBox" type="text"></s:input><s:input id="txtResidentCountryCode" path="strResidentCountryCode" type="hidden" readonly="true" ></s:input></div>
  				<div class="col-md-3"><label>Resident Region Name</label><br><s:input id="txtResidentRegionName" path="strResidentRegionName" ondblclick="funHelp('WCResRegionMaster')" type="text" readonly="true" cssClass="searchTextBox"></s:input><s:input id="txtResidentRegionCode" path="strResidentRegionCode" type="hidden" readonly="true" ></s:input></div>
		  				
  		
  				<%-- <div class="col-md-3"><label>Resident Area Code</label><br><s:input id="txtResidentAreaCode" path="strResidentAreaCode" readonly="true" ondblclick="funHelp('WCResAreaMaster')" type="text"  cssClass="searchTextBox"></s:input></div>
  				<div class="col-md-3"><label>Resident City Code</label><br><s:input id="txtResidentCtCode" path="strResidentCtCode"  readonly="true" ondblclick="funHelp('WCResCityMaster')" type="text"  cssClass="searchTextBox"></s:input></div>
  				<div class="col-md-3"><label>Resident State Code</label><br><s:input id="txtResidentStateCode" path="strResidentStateCode" readonly="true" ondblclick="funHelp('WCResStateMaster')" type="text" cssClass="searchTextBox"></s:input></div>
  				<div class="col-md-3"><label>Resident Region Code</label><br><s:input id="txtResidentRegionCode" path="strResidentRegionCode" readonly="true" ondblclick="funHelp('WCResRegionMaster')" type="text" cssClass="searchTextBox"></s:input></div>
  				<div class="col-md-3"><label>Resident Country Code</label><br><s:input id="txtResidentCountryCode" path="strResidentCountryCode" readonly="true" required="required" ondblclick="funHelp('WCResCountryMaster')" cssClass="searchTextBox" type="text"></s:input></div>
  				 --%>
  				
  				
  				<div class="col-md-3"><label>Resident Telephone1</label><br><s:input id="txtResidentTelephone1" path="strResidentTelephone1" 
					class="decimal-places numberField" type="text"></s:input></div>
  				<div class="col-md-3"><label>Resident Telephone2</label><br><s:input id="txtResidentTelephone2" path="strResidentTelephone2" 
					class="decimal-places numberField" type="text"></s:input></div>
  				<div class="col-md-3"><label>Resident Fax1</label><br><s:input id="txtResidentFax1" path="strResidentFax1"  
					class="decimal-places numberField" type="text"></s:input></div>
  				
  				<div class="col-md-3"><label>Resident Fax2</label><br><s:input id="txtResidentFax2" path="strResidentFax2"  
					class="decimal-places numberField" type="text"></s:input></div>
  				<div class="col-md-3"><label>Resident PinCode</label><br><s:input id="txtResidentPinCode" path="strResidentPinCode" onkeypress="javascript:return isNumber(event)" readonly="true" 
					class="decimal-places numberField" type="text"></s:input></div>
  				<div class="col-md-3"><label>Resident Mobile No</label><br><s:input id="txtResidentMobileNo" path="strResidentMobileNo"  onkeypress="javascript:return isNumber(event)"
					class="decimal-places numberField" type="text"></s:input></div>
  				<div class="col-md-3"><label>Resident Email ID</label><br><s:input id="txtCompanyEmailID" path="strResidentEmailID" type="text"></s:input></div>
			</div></div>
			</div>
			
			
	<div id="tab2" class="tab_content">
			
				<div class="container transtable"  style="background-color:#f2f2f2;">
			<div class="row" style="margin:0px; margin-top:26px;">
  				<div class="col-md-6"><label>Company Code</label><br>
  					<div class="row" ><div class="col-md-6"><s:input id="txtCompanyCode"
									ondblclick="" cssClass="searchTextBox"
									 type="text" path="strCompanyCode" ></s:input></div>
									<div class="col-md-6"><s:input id="txtCompanyName" path="strCompanyName" type="text"></s:input></div></div></div>
									
				<div class="col-md-6"><label>Job Profile</label><br>
					<div class="row" ><div class="col-md-6"><s:input id="txtJobProfileCode"
									ondblclick="" 
									type="text" path="strJobProfileCode" ></s:input></div>
								  <div class="col-md-6"><s:input id="txtJobProfileName" path="" type="text"></s:input></div></div></div>
			
			
			<div class="col-md-6">
				<div class="row"><div class="col-md-6"><label>Adress Line1 </label><br><s:input id="txtCompanyAddressLine1" path="strCompanyAddressLine1" type="text"></s:input></div>
			<div class="col-md-6"><label>Adress Line 2</label><br><s:input id="txtBillingAddressLine2" path="strCompanyAddressLine2" 
								 type="text"></s:input></div></div></div>
			<div class="col-md-6">
				<div class="row"><div class="col-md-6"><label>Adress Line 3</label><br><s:input id="txtCompanyAddressLine3" path="strCompanyAddressLine3" 
								type="text"></s:input></div>
			<div class="col-md-6"><label>Landmark</label><br><s:input id="txtCompanyLandMark" path="strCompanyLandMark" 
									type="text"></s:input></div></div></div>
									
									
			<div class="col-md-6"><label>Holding Code</label><br>
				<div class="row"><div class="col-md-6"><s:input id="txtHoldingCode"
									ondblclick="" 
									type="text" path="strHoldingCode" ></s:input></div>
								 <div class="col-md-6"><s:input id="txtHoldingName" path="" type="text"></s:input></div></div></div>
									
			<div class="col-md-6"><div class="row"><div class="col-md-6"><label>Area Code</label><s:input id="txtCompanyAreaName"
									ondblclick="funHelp('WCComAreaMaster')" cssClass="searchTextBox" readonly="true" type="text" path="strCompanyAreaName" ></s:input><s:input id="txtCompanyAreaCode" path="strCompanyAreaCode" type="hidden"></s:input></div>
									<div class="col-md-6">
									<label>City Code</label>
				                     <s:input id="txtCompanyCtName" ondblclick="funHelp('WCComCityMaster')"  cssClass="searchTextBox" readonly="true" type="text" path="strCompanyCtName" ></s:input>
									<s:input id="txtCompanyAreaCode" path="strCompanyCtCode" type="hidden"></s:input>
									</div>	</div></div>
											
			<div class="col-md-6"><div class="row" >
			                <div class="col-md-6"><label>State Code</label><s:input id="txtCompanyStateName"
									ondblclick="funHelp('WCComStateMaster')"  cssClass="searchTextBox" readonly="true"
									type="text" path="strCompanyStateName" ></s:input><s:input id="txtCompanyStateCode" path="strCompanyStateCode" type="hidden"></s:input></div>
							<div class="col-md-6"><label>Country Code</label><s:input id="txtCompanyCountryName" 
									ondblclick="funHelp('WCComCountryMaster')" cssClass="searchTextBox"  readonly="true" 
									type="text" path="strCompanyCountryName" ></s:input>
									<s:input id="txtCompanyCountryCode" path="strCompanyCountryCode" type="hidden"></s:input>
									</div></div></div>
			
			<div class="col-md-6"><div class="row">
			            <div class="col-md-6"><label>Region Code</label><s:input id="txtCompanyRegionName"
									ondblclick="funHelp('WCComRegionMaster')" cssClass="searchTextBox" readonly="true"
									type="text" path="strCompanyRegionName" ></s:input>
							    <s:input id="txtCompanyRegionCode" path="strCompanyRegionCode" type="hidden"></s:input></div>
		                <div class="col-md-6"><label>Pin Code</label><s:input id="txtCompanyPinCode" path="strCompanyPinCode"  readonly="true" onkeypress="javascript:return isNumber(event)"
									class="decimal-places numberField" type="text"></s:input></div>
			</div></div>

			<div class="col-md-6"><label>Telephone</label><br>
				<div class="row" ><div class="col-md-6"><s:input id="txtCompanyTelePhone1" path="strCompanyTelePhone1"  onkeypress="javascript:return isNumber(event)"
									class="decimal-places numberField" type="text"></s:input></div>
									<div class="col-md-6"><s:input id="txtCompanyTelePhone2" path="strCompanyTelePhone2" 
									class="decimal-places numberField" type="text"></s:input></div></div></div>
			
			<div class="col-md-6"><label>Fax</label><br>
				<div class="row"><div class="col-md-6"><s:input id="txtCompanyFax1" path="strCompanyFax1" 
									class="decimal-places numberField" type="text"></s:input></div>
								<div class="col-md-6"><s:input id="txtCompanyFax2" path="strCompanyFax2" 
									class="decimal-places numberField" type="text"></s:input></div></div></div>
				
			
			<div class="col-md-3"><label>Mobile No</label><br><s:input id="txtCompanyMobileNo" path="strCompanyMobileNo" onkeypress="javascript:return isNumber(event)"
									class="decimal-places numberField" type="text"></s:input></div>
									
			<div class="col-md-4"><label>Email ID</label><br><s:input id="txtCompanyEmailID" path="strCompanyEmailID" 
								type="text" style="width: 67%" ></s:input></div>
	
		</div></div>
			</div>			
			
			
<div id="tab3" class="tab_content">		
			
			<div class="container transtable"  style="background-color:#f2f2f2;">
			<div class="row" style="margin:0px; margin-top:26px;">
  				<div class="col-md-6">
  					<div class="row"><div class="col-md-6"><label>Address Line 1</label><br><s:input id="txtBillingAddressLine1" path="strBillingAddressLine1" 
								type="text"></s:input></div>
									 <div class="col-md-6"><label>Address Line2</label><br><s:input id="txtBillingAddressLine2" path="strBillingAddressLine2" 
									 type="text"></s:input></div></div></div>
			
			<div class="col-md-6">
  					<div class="row"><div class="col-md-6"><label>Address Line3</label><br><s:input id="txtBillingAddressLine3" path="strBillingAddressLine3" 
									type="text"></s:input></div>
									<div class="col-md-6"><label>Landmark</label><br><s:input id="txtBillingLandMark" path="strBillingLandMark" 
									type="text"></s:input></div></div></div>	
		
			<div class="col-md-6"><div class="row"><div class="col-md-6"><label>Area Code</label>
			                      <s:input id="txtBillingAreaName" readonly="true"
									ondblclick="funHelp('WCBillingAreaMaster')" cssClass="searchTextBox"
									type="text" path="strBillingAreaName" ></s:input><s:input id="txtBillingAreaCode" path="strBillingAreaCode" readonly="true"
									 type="hidden"></s:input></div>
									<div class="col-md-6"><label>City Code</label><s:input id="txtBillingCtName"
									ondblclick="funHelp('WCBillingCityMaster')" cssClass="searchTextBox" readonly="true"
									type="text" path="strBillingCtName" ></s:input><s:input id="txtBillingCtCode" path="strBillingCtCode" readonly="true"
									 type="hidden"></s:input></div></div></div>
				
			<div class="col-md-6"><div class="row">
			                <div class="col-md-6"> <label>State Code</label><s:input id="txtBillingStateName"
									ondblclick="funHelp('WCBillingStateMaster')"  cssClass="searchTextBox" readonly="true"
									type="text" path="strBillingStateName"  required="required" ></s:input>
								 <s:input id="txtBillingStateCode" path="strBillingStateCode" readonly="true"
									type="hidden"></s:input></div>
			                <div class="col-md-6"><label>Country Code</label><s:input id="txtBillingCountryName"
									ondblclick="funHelp('WCBillingCountryMaster')"  cssClass="searchTextBox" readonly="true"
									type="text" path="strBillingCountryName"></s:input><s:input id="txtBillingCountryCode" path="strBillingCountryCode" readonly="true"
									type="hidden"></s:input></div></div></div>
			
			<div class="col-md-6"><div class="row">
			            <div class="col-md-6"><label>Region Code</label><s:input id="txtBillingRegionName"
									ondblclick="funHelp('WCBillingRegionMaster')"  cssClass="searchTextBox" readonly="true"
									type="text" path="strBillingRegionName" ></s:input>
							    	<s:input id="txtBillingRegionCode" path="strBillingRegionCode" readonly="true"
									 type="hidden"></s:input></div>
			            <div class="col-md-6"><label>Pin Code</label><s:input id="txtBillingPinCode" path="strBillingPinCode" readonly="true"
								onkeypress="javascript:return isNumber(event)"	class="decimal-places numberField" type="text"></s:input></div>			 	
			</div></div>		 	
			
			<div class="col-md-6"><label>Telephone</label><br>
				<div class="row"><div class="col-md-6"><s:input id="txtBillingTelePhone1" path="strBillingTelePhone1" onkeypress="javascript:return isNumber(event)"
									class="decimal-places numberField" type="text"></s:input></div>
								<div class="col-md-6"><s:input id="txtBillingTelePhone2" path="strBillingTelePhone2" 
									class="decimal-places numberField" type="text"></s:input></div></div></div>
			<div class="col-md-6"><label>Fax</label><br>
				<div class="row"><div class="col-md-6"><s:input id="txtBillingFax1" path="strBillingFax1" 
									class="decimal-places numberField" type="text"></s:input></div>
								 <div class="col-md-6"><s:input id="txtBillingFax2" path="strBillingFax2" 
									class="decimal-places numberField" type="text"></s:input></div></div></div>	
			
			<div class="col-md-3"><label>Mobile</label><br><s:input id="txtBillingMobileNo" path="strBillingMobileNo" onkeypress="javascript:return isNumber(event)"
									class="decimal-places numberField" type="text"></s:input></div>
		
			<div class="col-md-3"><label>Email ID</label><br><s:input id="txtBillingEmailID" path="strBillingEmailID" 
								 type="text"></s:input></div>
			</div></div>
			</div>
		
		</div>
		</div>
			
					
<h3><a href="#">Personal Information</a></h3>
		<div>		
			<div class="container transtable"  style="background-color:#f2f2f2;">
			<div class="row">
  				<div class="col-md-6"><label>Profession Code</label><br>
  					<div class="row"><div class="col-md-6"><s:input id="txtProfessionCode"  ondblclick="funHelp('WCProfessionMaster')" cssClass="searchTextBox" readonly="true"
									type="text" path="strProfessionCode" placeholder="Select Profession Code" ></s:input></div>
								<div class="col-md-6"><s:input id="txtProfessionName" path="" placeholder="Profession Name"  readonly="true"
									cssStyle="width: 30%%;" type="text"></s:input></div></div></div>
				
				<div class="col-md-6">
					<div class="row"><div class="col-md-6"><label>Date Of Birth</label><br><s:input id="txtdtDateofBirth" name="txtdtDateofBirth" path="dteDateofBirth" cssClass="calenderTextBox"></s:input></div>
									<div class="col-md-6"><label>Marital Status</label><br><s:select id="cmbMaritalStatus" name="cmbMaritalStatus" path="strMaritalStatus">
													 <option value="Single">Single</option>
									 				 <option value="Married">Married</option>
													 </s:select></div></div></div>
				<div class="col-md-3"><label>Sex</label><br><s:select id="cmbGender" name="cmbGender" path="strGender">
										 <option value="M">Male</option>
						 				 <option value="F">Female</option>
										 </s:select></div>
								  
			</div></div>
			</div>
			
	<h3 id="headerSpouse" style="display:none"><a href="#">Spouse Information</a></h3>
		<div id="divSpouse" style="display:none">	
		
		<div class="container transtable"  style="background-color:#f2f2f2;">
			<div class="row">
			<div class="col-md-6">
				<div class="row"><div class="col-md-6"><label>Spouse Code</label><br><s:input id="txtSpouseCode"
									ondblclick="" readonly="true"
									type="text" path="strSpouseCode" ></s:input></div>
								   <div class="col-md-6"><label>First Name</label><br><s:input id="txtSpouseFirstName" placeholder="Enter First Name" path="strSpouseFirstName" 
									type="text"></s:input></div></div></div>
									
			<div class="col-md-6">						
				<div class="row"><div class="col-md-6"><label>Middle Name</label><br><s:input id="txtSpouseMiddleName" path="strSpouseMiddleName" placeholder="Enter Middle Name"
									type="text"></s:input></div>
									<div class="col-md-6"><label>Last Name</label><br><s:input id="txtSpouseLastName" path="strSpouseLastName" placeholder="Enter Last Name"
									cssStyle="width: 56%;" type="text"></s:input></div></div></div>
								
									
			<div class="col-md-6"><label>Profession Code</label><br>
					<div class="row"><div class="col-md-6"><s:input id="txtSpouseProfessionCode" cssClass="searchTextBox" readonly="true" placeholder="Select Profession Code" 
									ondblclick="funHelp('WCSpouseProfessionMaster')" 
									type="text" path="strSpouseProfessionCode" ></s:input></div>
									<div class="col-md-6"><s:input id="txtSpouseProfessionName" path=""  readonly="true" placeholder="Profession Name" 
									cssStyle="width: 100%;" type="text"></s:input></div></div></div>
									
			<div class="col-md-6">						
				<div class="row"><div class="col-md-6"><label>Date Of Birth</label><br><s:input id="txtdtSpouseDateofBirth" name="txtdtSpouseDateofBirth" cssClass="calenderTextBox" path="dteSpouseDateofBirth"/></div>
								<div class="col-md-6"><label>Mobile No</label><br><s:input id="txtSpouseResidentMobileNo" path="strSpouseResidentMobileNo"  placeholder="Enter Mobile No"
													class="decimal-places numberField" type="text"></s:input></div></div></div>
	
	        <div class="col-md-6">
				<div class="row"><div class="col-md-6"><label>Email ID</label><br><s:input id="txtSpouseResidentEmailID" path="strSpouseResidentEmailID" placeholder="Enter Email ID" 
						           type="text"></s:input></div>
				               <div class="col-md-6"><label>Anniversary Date</label><br><s:input id="txtdtAnniversary" name="txtdtAnniversary" path="dteAnniversary" /></div></div></div>
			
			<div class="col-md-6"><label>Company Code</label><br>
				<div class="row"><div class="col-md-6"><s:input id="txtSpouseCompanyCode" placeholder="Company Code"
									ondblclick="" 
									 type="text" path="strSpouseCompanyCode" ></s:input></div>
								 <div class="col-md-6"><s:input id="txtSpouseCompanyName" path=""  
										type="text"></s:input></div></div></div>
							
			<div class="col-md-6"><label>Job Profile</label><br>
				<div class="row"><div class="col-md-6"><s:input id="txtSpouseJobProfileCode"
									ondblclick="" type="text" path="strSpouseJobProfileCode" ></s:input></div>
								<div class="col-md-6"><s:input id="txtSpouseJobProfileName" path=""  type="text"></s:input></div></div></div>
			<div class="col-md-6">
				<div class="row"><div class="col-md-6"><label>Spouse Block</label><br><s:select id="cmbSpouseFacilityBlock" name="cmbSpouseFacilityBlock" path="strSpouseBlocked">
											 <option value="N">No</option>
							 				 <option value="Y">Yes</option>
											 </s:select></div>
								<div class="col-md-6"><label>StopCredit Supply</label><br><s:select id="cmbSpouseStopCredit" name="cmbSpouseStopCredit" path="strSpouseStopCredit">
											 <option value="N">No</option>
								 			 <option value="Y">Yes</option>
											 </s:select></div></div></div>
			   </div></div>
			   </div>
    	
    <h3><a href="#">Membership Information</a></h3>
		<div>		
			<div class="container transtable"  style="background-color:#f2f2f2;">
			<div class="row">
  				
  				<div class="col-md-6"><label>Membership Category</label><br>
  					<div class="row"><div class="col-md-6"><s:input id="txtMSCategoryCode" readonly="true" placeholder="Select Membership Category Code" 
									ondblclick="funHelp('WCCatMaster')"  cssClass="searchTextBox"
									type="text" path="strCategoryCode" required="required" ></s:input></div>
								 <div class="col-md-6"><s:input id="txtMemberName" path="" readonly="true" placeholder="Membership Category Name" 
										type="text"></s:input></div></div></div>
				<%-- 
				<div class="col-md-6"><label>Proposer Code</label><br>
					<div class="row"><div class="col-md-6"><s:input id="txtProposerCode"
									ondblclick="" cssClass="searchTextBox"
									type="text" path="strProposerCode" ></s:input></div>
								  <div class="col-md-6"><s:input id="txtProposerName" path="" 
										type="text"></s:input></div></div></div>
										
				<div class="col-md-6"><label>Seconder Code</label><br>
					<div class="row"><div class="col-md-6"><s:input id="txtSeconderCode"
									ondblclick=""  cssClass="searchTextBox"
									type="text" path="strSeconderCode" ></s:input></div>
									<div class="col-md-6"><s:input id="txtSeconderName" path=""
											 type="text"></s:input></div></div></div>
		
			<div class="col-md-6"><label>Father/Mother Code</label><br>
				<div class="row"><div class="col-md-6"><s:input id="txtFatherMemberCode"
									ondblclick=""  cssClass="searchTextBox"
									type="text" path="strFatherMemberCode" ></s:input></div>
								  <div class="col-md-6"><s:input id="txtFatherMemberName" path="" 
										 type="text"></s:input></div></div></div>
										 
			<div class="col-md-6"><label>Status</label><br>
				<div class="row"><div class="col-md-6"><s:input id="txtStatusCode"
									ondblclick=""  cssClass="searchTextBox"
									type="text" path="" ></s:input></div>
								<div class="col-md-6"><s:input id="txtStatusName" path=""
											 type="text"></s:input></div></div></div> --%>
											 
			<div class="col-md-6"><label>Reason Code</label><br>
					<div class="row"><div class="col-md-6"><s:input id="txtBlockedReasonCode" readonly="true" placeholder="Select Reason Code" 
									ondblclick="funHelp('WCBlockReasonMaster')"  cssClass="searchTextBox"
									type="text" path="strBlockedreasonCode"  ></s:input></div>
									<div class="col-md-6"><s:input id="txtBlockedReasonName" path="" placeholder="Reason Name" 
									type="text"></s:input></div></div></div>
		    
		    <div class="col-md-6"><label>Qualification</label><br>
					<div class="row"><div class="col-md-6"><s:input id="txtQualification" readonly="true" placeholder="Select Qualification"
									ondblclick="funHelp('WCEducationMaster')" cssClass="searchTextBox"
									type="text" path="strQualification" ></s:input></div>
									<div class="col-md-6"><s:input id="txtQualificationName" path=""  readonly="true" placeholder="Qualification Name"
									type="text"></s:input></div></div></div>
			
			<div class="col-md-6"><label>Designation</label><br>
				<div class="row"><div class="col-md-6"><s:input id="txtDesignationCode"
									ondblclick="funHelp('WCDesignationMaster')"  cssClass="searchTextBox" readonly="true" placeholder="Select Designation"
									type="text" path="strDesignationCode" ></s:input></div>
							      <div class="col-md-6"><s:input id="txtDesignationName" path=""  readonly="true" placeholder="Designation Name"
												type="text"></s:input></div></div></div>
			
			<div class="col-md-6">
				<div class="row"><div class="col-md-6"><label>Member From</label><br><s:input id="txtdtMembershipStartDate" name="txtdtMembershipStartDate" cssClass="calenderTextBox" path="dteMembershipStartDate"/></div>
				                  <div class="col-md-6"><label>Member To</label><br><s:input id="txtdtMembershipEndDate" name="txtdtMembershipEndDate" cssClass="calenderTextBox" path="dteMembershipEndDate"/></div></div></div>									
				
			<div class="col-md-6">
				<div class="row"><div class="col-md-6"><%-- <label>Ballot Date</label><br><s:input id="txtdtBallotDate" name="txtdtBallotDate" cssClass="calenderTextBox" path=""/> --%></div>
				                 <div class="col-md-6"><label>Allow Card Validation</label><br><s:checkbox element="li" id="chkCardValidtion" path="" value="Yes" /></div></div></div>
				
			<div class="col-md-6">
				<div class="row"><div class="col-md-6"><label>Member Blocked</label><br><s:select id="cmbMemberBlock" name="" path="strBlocked">
														 <option value="N">No</option>
										 				 <option value="Y">Yes</option>
														 </s:select></div>	
								<div class="col-md-6"><label>Entrance Fee</label><br><s:input id="txtdblEntranceFee" path="dblEntranceFee" 
									class="decimal-places numberField" type="text"></s:input></div></div></div>
			
			<div class="col-md-6">
				<div class="row"><div class="col-md-6"><label>Subscription Fee</label><br><s:input id="txtdblSubscriptionFee" path="dblSubscriptionFee" 
									class="decimal-places numberField" type="text"></s:input></div>
							    <div class="col-md-6"><label>Pan Number</label><br><s:input id="txtPanNumber" path="strPanNumber" placeholder="Enter Pan Number" 
												type="text"></s:input></div></div></div>
												
			<div class="col-md-6">
				<div class="row"><div class="col-md-6"><label>Billing Detail</label><br><s:select id="cmbBillingDetail" name="cmbBillingDetail" path=""></s:select></div>
				                  <div class="col-md-6"><label>Locker Detail</label><br><s:select id="cmbLockerDetail" name="cmbLockerDetail" path="strLocker" >
																 <option value="N">No</option>
												 				 <option value="Y">Yes</option>
																 </s:select></div></div></div>
														
			<div class="col-md-6">
				<div class="row"><div class="col-md-6"><label>Library Facility</label><br><s:select id="cmbLockerDetail" name="cmbLockerDetail" path="strLibrary" >
															       <option value="N">No</option>
											 				       <option value="Y">Yes</option>
															       </s:select></div>
							     <div class="col-md-6"><label>Senior Citizen</label><br><s:select id="cmbSeniorCitizen" name="cmbSeniorCitizen" path="strSeniorCitizen">
																	 <option value="N">No</option>
													 				 <option value="Y">Yes</option>
																	 </s:select></div></div></div>
			
			<div class="col-md-6">
				<div class="row"><div class="col-md-6"><label>Stop Credit Supply</label><br><s:select id="cmbStopCredit" name="cmbStopCredit" path="strStopCredit" >
															 <option value="N">No</option>
											 				 <option value="Y">Yes</option>
															 </s:select></div>
								<div class="col-md-6"><label>Resident</label><br><s:select id="cmbResident" name="cmbResident" path="">
															 <option value="N">No</option>
											 				 <option value="Y">Yes</option>
															 </s:select></div></div></div>
								
		    <div class="col-md-6">
				<div class="row"><%-- <div class="col-md-6"><label>Instation</label><br><s:select id="txtInstation" name="txtInstation" path="strInstation">
															 <option value="N">No</option>
											 				 <option value="Y">Yes</option>
															 </s:select></div> --%>
							   <div class="col-md-6"><label>Golf Membership</label><br><s:select id="cmbGolfMemberShip" name="cmbGolfMemberShip" path="strGolfMemberShip">
															 <option value="N">No</option>
											 				 <option value="Y">Yes</option>
															 </s:select></div></div></div>			 
			
			<div class="col-md-6">
				<div class="row"><div class="col-md-6"><label>Send Innvoice through</label><br><s:select id="cmbsendInnvoicethrough" name="cmbSendInnvoicethrough" path="" >
																 <option value="N">No</option>
												 				 <option value="Y">Yes</option>
																 </s:select></div>
			                     <div class="col-md-6"><label>Circulars/Notice</label><br><s:select id="cmbNotice" name="cmbNotice" path="">
														 <option value="N">No</option>
										 				 <option value="Y">Yes</option>
														 </s:select></div></div></div><br>
											
		</div></div>
		</div>
				
		
		
			
			
			
	<h3 id="headerDependent" style="display:none"><a href="#">Dependent List</a></h3>
		<div id="divDependent" style="display:none">	
			<div class="container masterTable"  style="background-color:#f2f2f2;">
			<div class="row">
			
			<div class="col-md-6">				
				<div class="row"><div class="col-md-6"><label>Dependent Code</label><br><s:input id="txtDependentCode" path=""  cssClass="searchTextBox"
						 ondblclick="" /></div>
								<div class="col-md-6"><label>Dependent Name</label><br><s:input type="text" id="txtDependentName" 
														name="txtDependentName" path="" 
														cssStyle= "text-transform: uppercase;"/> <s:errors path=""></s:errors></div></div></div>
											
			<div class="col-md-6"><label>Change Dependent Code</label><br>				
				<div class="row"><div class="col-md-6"><s:input type="text" id="txtChangeDependentMemberCode" 
														name="txtChangeDependentMemberCode" path="" readonly="true"/><s:errors path=""></s:errors></div>
								 <div class="col-md-6"><s:input  type="text" id="txtChangeDependentCode" 
														name="txtChangeDependentCode" path="" /> <s:errors path=""></s:errors></div></div></div>
			
			<div class="col-md-6"><label>Profession Code</label><br>
				<div class="row"><div class="col-md-6"><s:input id="txtDependentProfessionCode" readonly="true"
									ondblclick="funHelp('WCDependentProfessionMaster')"  cssClass="searchTextBox"
									type="text" path="strDependentProfessionCode" ></s:input></div>
						         <div class="col-md-6"><s:input id="strDependentProfessionName" path="" readonly="true"
									cssStyle="width: 30%%;" type="text"></s:input></div></div></div>	
									
			<div class="col-md-6"><label>Block Reason Code</label><br>
				<div class="row"><div class="col-md-6"><s:input id="txtDependentReasonCode"
									ondblclick="funHelp('WCDependentReasonMaster')"  cssClass="searchTextBox" readonly="true"
									type="text" path="strDependentReasonCode"></s:input></div>
								<div class="col-md-6"><s:input id="txtDependentReasonName" path=""  readonly="true"
									 type="text"></s:input></div></div></div>	
									 						
				<div class="col-md-6">
				<div class="row"><div class="col-md-6"><label>Date Of Birth</label><br><s:input id="txtdteDependentDateofBirth"  cssClass="calenderTextBox"
								name="txtdteDependentDateofBirth" path="dteDependentDateofBirth"/></div>
			                    <div class="col-md-6"><label>Member Exp Date</label><br><s:input id="txtdteDependentMemExpDate" cssClass="calenderTextBox"
								   name="txtdteDependentMemExpDate" path="dteDependentMemExpDate"/></div></div></div>
			
			<div class="col-md-6">
				<div class="row"><div class="col-md-6"><label>Relation</label><br><s:input id="txtDependentRelation" path="strDependentRelation" type="text"></s:input></div>
			                     <div class="col-md-6"><label>Blocked</label><br><s:select id="cmbDependentBlock" name="cmbDependentBlock"
									path="strDependentBlock">
									<option value="N">No</option>
									<option value="Y">Yes</option>
								</s:select></div></div></div>	
		
			
			<div class="col-md-6">
				<div class="row"><div class="col-md-6"><label>Sex</label><br><s:select id="cmbDependentGender" name="cmbDependentGender"
										path="strDependentGender">
										<option value="M">Male</option>
										<option value="F">Female</option></s:select></div>			
			                    <div class="col-md-6"><label>Marital Status</label><br><s:select id="cmbDependentMaritalStatus"
											name="cmbDependentMaritalStatus" path="strDependentMaritalStatus">
											<option value="Single">Single</option>
											<option value="married">married</option>
										     </s:select></div></div></div>
			
		
		    </div></div>
		    
			
						<div class="center">
						
						<a href="#"><button class="btn btn-primary center-block" value="Add" onclick="return btnAdd_onclick()" value="Reset" onclick="funResetTableData()()" style="margin:13px"
						class="form_button">Add</button></a>
			</div>
			
			<div class="masterTable" style="height:293px !important width :803px!important " >
			<div class="container">
			<div class="row" style="background-color:#f2f2f2;">
			
					<div class="col-md-1" style="width:10%">Member Code</div>
					<div class="col-md-2" style="width:15%">Full Name</div>
					
					<div class="col-md-1" style="width:6%">Relation</div>
					
					<div class="col-md-1" style="width:2%">Sex</div>
					
					<div class="col-md-1" style="width:8%">Marital</div>
					
					<div class="col-md-1" style="width:9%">DOB</div>
					
					<div class="col-md-1" style="width:5%">Blocked</div>
					
					<div class="col-md-1" style="width:9%">Blocked Reason</div>
					
					<div class="col-md-1" style="width:9%">Profession</div>
					
					<div class="col-md-1" style="width:9%">Mem Exp Date</div>
					<div class="col-md-1" style="width:0%"></div>
				</div>
			</div>	
			<div
							style="background-color: #ffffff; border: 1px solid #b3b0b3; display: block; height: 250px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 99.80%;">
						     <div class="container" id="tblDependentData"
									style="width: 100%; background-color: #ffffff;border: #0F0; table-layout: fixed; overflow: scroll"
									class="transTablex col8-center">
								<div class="row">
									<col class="col-md-1" style="width:10%">					
									<col class="col-md-2" style="width:15%">
									<col class="col-md-1" style="width:6%">
									<col class="col-md-1" style="width:2%">
									<col class="col-md-1" style="width:8%">
									<col class="col-md-1" style="width:9%">
									<col class="col-md-1" style="width:5%">
									<col class="col-md-1" style="width:9%">
									<col class="col-md-1" style="width:9%">
									<col class="col-md-1" style="width:9%">
									<col class="col-md-1" style="width:0%">
								</div>
							</div>
						</div>
					</div>
		</div>
		</div > 
			<br>
			
		<div id="paraSubmit" class="center" style="display:none">
						
						<a href="#"><button class="btn btn-primary center-block" value="Submit" onclick="return funValidate()" 
						class="form_button">Submit</button></a>
						<a href="#"><button class="btn btn-primary center-block" value="Reset" onclick="funResetField()"
						class="form_button">Reset</button></a>
			</div>
		
		<div>
				<s:input type="hidden" id="txtCustCode"  path="strCustomerCode" ></s:input>
				<s:input type="hidden" id="txtSpouseCustCode"  path="strSpouseCustomerCode" ></s:input>
		</div>
	
	</s:form> 
</div>  
		
		
<script type="text/javascript">
		$(function(){
			$('#multiAccordion').multiAccordion({
// 				active: [1, 2],
				click: function(event, ui) {
				},
				init: function(event, ui) {
				},
				tabShown: function(event, ui) {
				},
				tabHidden: function(event, ui) {
				}
				
			});
			
			$('#multiAccordion').multiAccordion("option", "active", [0]);  // in this line [0,1,2] wirte then these index are open
		});
	</script>

	
</body>
</html>