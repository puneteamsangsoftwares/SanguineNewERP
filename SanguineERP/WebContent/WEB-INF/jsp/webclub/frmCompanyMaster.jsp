<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta http-equiv="X-UA-Compatible" content="IE=8">
<title></title>

	 <script type="text/javascript">
	var fieldName;

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
	
});
	
	function funHelp(transactionName)
	{
		fieldName=transactionName;
	//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	

	function funSetData(code){

		switch(fieldName){

			case 'WCCompanyCode' : 
				funSetCompanyCode(code);
				break;
			case 'WCComAreaMaster' : 
				funSetComAreaCode(code);
				break;
			case 'WCComCityMaster' : 
				funSetComCityCode(code);
				break;
			case 'WCComStateMaster' : 
				funSetComStateCode(code);
				break;
			case 'WCComRegionMaster' : 
				funSetComRegionCode(code);
				break;
			case 'WCComCountryMaster' : 
				funSetComCountryCode(code);
				break;
			case 'WCCategoryMaster' : 
				funSetComRegionCode(code);
				break;
				
			case 'WCmemProfileCustomer' :
				funloadMemberData(code);
				break;

			case 'WCCatMaster' :
				funSetCategoryData(code);
				
		}
	}


	function funSetCompanyCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadWebClubCompanyData.html?docCode=" + code,
			dataType : "json",
			success : function(response){ 

				if(response.strCompanyCode=='Invalid Code')
	        	{
	        		alert("Invalid Company Code");
	        		$("#txtCompanyCode").val('');
	        	}
	        	else
	        	{      
		        	$("#txtCompanyCode").val(code);
		        	$("#txtCompanyName").val(response.strCompanyName);
		        	$("#txtAnnualTrunover").val(response.dblAnnualTrunover);
		        	$("#txtCapital").val(response.dblCapital);
		        	$("#txtMemberCode").val(response.strMemberCode);
		        	$("#txtCategoryCode").val(response.strCategoryCode);
		        	$("#txtActiveNominee").val(response.strActiveNominee);
		        	$("#txtAddress1").val(response.strAddress1);
		        	$("#txtAddress2").val(response.strAddress2);
		        	$("#txtAddress3").val(response.strAddress3);
		        	$("#txtLandMark").val(response.strLandmark);
		        	$("#txtAreaCode").val(response.strAreaCode);
		        	$("#txtCtCode").val(response.strCityCode);
		        	$("#txtStateCode").val(response.strStateCode);
		        	$("#txtRegionCode").val(response.strRegionCode);
		        	$("#txtCountryCode").val(response.strCountryCode);
		        	
		        	$("#txtPinCode").val(response.strPin);
		        	$("#txtTelePhone1").val(response.strTelephone1);
		        	$("#txtTelePhone2").val(response.strTelephone2);
		        	$("#txtFax1").val(response.strFax1);
		        	$("#txtFax2").val(response.strFax2);
// 		        	$("#").val(response.);	        	
					funSetComAreaCode(response.strAreaCode);				
					funSetComCityCode(response.strCityCode);					
					funSetComStateCode(response.strStateCode);					
					funSetComRegionCode(response.strRegionCode);			
					funSetComCountryCode(response.strCountryCode);								
					funloadMemberData(response.strMemberCode);					
					funSetCategoryData(response.strCategoryCode);		
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

		$("#txtAreaCode").val(code);
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
			        	$("#txtAreaName").val(response.strAreaName);
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
		//alert("Hii");
		$("#txtCtCode").val(code);
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
						funSetComCountryCode(response.strCountryCode);
		        		funSetComStateCode(response.strStateCode);								
						$("#txtPinCode").val(response.strSTDCode);
						$("#txtCityName").val(response.strCityName);
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
		  
		$("#txtCountryCode").val(code);
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
		        		$("#txtCountryName").val(response.strCountryName);
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
		  
		$("#txtStateCode").val(code);
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

		        		funSetComRegionCode(response.strRegionCode);
		        		$("#txtStateName").val(response.strStateName);
		        		 
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
				
				$("#txtRegionCode").val(code);
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
				        		$("#txtRegionName").val(response.strRegionName);
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
	
			
			function funSetCategoryData(code)
			{
				$("#txtCategoryCode").val(code);
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
					        		$("#txtCatCode").val('');
					        	}
					        	else
					        	{
						        	//$("#txtCategoryCode").val(code);
						        	$("#strCategoryName").val(response.strCategoryName);
						        	
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
			
			
			function funloadMemberData(code)
			{
				$("#txtMemberCode").val(code);
				var searchurl=getContextPath()+"/loadWebClubMemberProfileData.html?primaryCode="+code;
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
					        		$("#txtMemberName").val(response[0].strFullName);
						        	
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
			
			
			function funSetCategoryData(code)
			{
				$("#txtCategoryCode").val(code);
				var searchurl=getContextPath()+"/loadWebClubMemberCategoryMaster.html?catCode="+code;
				//alert(searchurl);
				 $.ajax({
					        type: "GET",
					        url: searchurl,
					        dataType: "json",
					        success: function(response)
					        {
					        	if(response.strCatCode=='Invalid Code')
					        	{
					        		alert("Invalid Category Code");
					        		$("#txtCategoryCode").val('');
					        	}
					        	else
					        	{
					        		
						        	$("#txtCategoryName").val(response.strCatName);
						        	
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
			function funValidateFields()
			{
				var flag=true;				
				if($("#txtCompanyName").val().trim().length==0)
				{
					alert("Please Enter Company Name.");
					flag=false;
				}
				else if($("#txtMemberCode").val().trim().length==0)
				{
					alert("Please Enter Member Code.");
					flag=false;
				}
				else if($("#txtCategoryCode").val().trim().length==0)
				{
					alert("Please Enter Category Code.");
					flag=false;
				}				
				else if($("#txtAreaCode").val().trim().length==0)
				{
					alert("Please Enter Area Code.");
					flag=false;
				}				
				else if($("#txtCtCode").val().trim().length==0)
				{
					alert("Please Enter City Code.");
					flag=false;
				}				
				else if($("#txtStateCode").val().trim().length==0)
				{
					alert("Please Enter State Code.");
					flag=false;
				}				
				else if($("#txtRegionCode").val().trim().length==0)
				{
					alert("Please Enter Region Code.");
					flag=false;
				}				
				else if($("#txtCountryCode").val().trim().length==0)
				{
					alert("Please Enter Country Code.");
					flag=false;
				}				
				return flag;
			}
			
	
			function funResetFields()
			{
				location.reload(true); 
			}
	
	
</script>

</head>
<body>	
	 <div class="container">
		<label id="formHeading">Company Master</label>
		<s:form name="CompanyMaster" method="POST" action="saveCompanyMaster.html">
			<div class="row masterTable">
				<div class="col-md-4">
					<label>Company Name:</label>
					<div class="row">
						<div class="col-md-6"><s:input id="txtCompanyCode" ondblclick="funHelp('WCCompanyCode')" cssClass="searchTextBox"
							readonly="true" type="text" path="strCompanyCode"></s:input>
						</div>
					
						<div class="col-md-6"><s:input id="txtCompanyName" required="true" path="strCompanyName" 
									 placeholder="Company Name" type="text" ></s:input>
						</div>
					</div>
				</div>	
				<div class="col-md-4">
					<div class="row">
						<div class="col-md-6">
							<label>Type of Company:</label>
								<s:select id="cmbCompanyType" name="cmbCompanyType" path="" style="width:50%;">
									 <option value="N">No</option>
				 				 	<option value="Y">Yes</option>
				 				</s:select>
						</div>
						<div class="col-md-6">
							<label>Annual Turnover:</label>
								<s:input id="txtAnnualTrunover" path="dblAnnualTrunover" type="text" pattern="^\d+(\.\d{1,2})?$" style="width:50%;"></s:input>
						</div>
					</div>
				</div>
				<div class="col-md-4"></div>
				<div class="col-md-4">
					<label>Member Code:</label>
						<div class="row">
							<div class="col-md-6"><s:input id="txtMemberCode"
									ondblclick="funHelp('WCmemProfileCustomer')" cssClass="searchTextBox"
									type="text" path="strMemberCode" readonly="true"></s:input>
							</div>
							<div class="col-md-6"><s:input id="txtMemberName" path=""
									 placeholder="Member name" type="text" readonly="true"></s:input>
							</div>
						</div>
				</div>
				<div class="col-md-4">
					<div class="row">
						<div class="col-md-6">
							<label>Capital and Reserved:</label>
								<s:input id="txtCapital" path="dblCapital"
							 placeholder="Annual Turnover" type="text" value="0.0"></s:input>
						</div>
						<div class="col-md-6">
							<label>No. of Active:</label>
								<s:input id="txtActiveNominee" path="strActiveNominee" type="text"></s:input>
						</div>
					</div>
				</div>	
				<div class="col-md-4"></div>
				
				<div class="col-md-4">
					<label>Category Code:</label>
					<div class="row">
						<div class="col-md-6"><s:input id="txtCategoryCode"
									ondblclick="funHelp('WCCatMaster')" cssClass="searchTextBox"
									type="text" path="strCategoryCode" readonly="true"></s:input>
						</div>
						<div class="col-md-6"><s:input id="txtCategoryName"  path=""
									 placeholder="Category Name" type="text" readonly="true"></s:input>
						</div>
					</div>
				</div>	
				<div class="col-md-4">
					<div class="row">
						<div class="col-md-6">
							<label>Address Line 1:</label>
								<s:input id="txtAddress1" path="strAddress1" type="text"></s:input>
						</div>
						<div class="col-md-6">
							<label>Address Line 2:</label>
								<s:input id="txtAddress2" path="strAddress2" type="text"></s:input>
						</div>
					</div>
				</div>
				<div class="col-md-4"></div>
					
				<div class="col-md-4">
					<label>Area Code:</label>
					<div class="row">
						<div class="col-md-6"><s:input id="txtAreaCode" path="strAreaCode" class="searchTextBox" 
							ondblclick="funHelp('WCComAreaMaster')" type="text" value="" readonly="true"></s:input>
						</div>
						<div class="col-md-6">
						   <s:input id="txtAreaName"  path=""  placeholder="Area Name" type="text" value="" readonly="true"></s:input>
						</div>
					</div>
				</div>
				<div class="col-md-4">
					<div class="row">
						<div class="col-md-6">
							<label>Address Line 3:</label>
						<s:input id="txtAddress3" path="strAddress3" type="text"></s:input>
						</div>
						<div class="col-md-6">
							<label>Landmark:</label>
						<s:input id="txtLandMark" path="strLandmark" type="text" value=""></s:input>
						</div>
					</div>
				</div>	
				<div class="col-md-4"></div>
				
				<div class="col-md-4">
					<label>City Code:</label>
					<div class="row">
						<div class="col-md-6"><s:input id="txtCtCode" path="strCityCode" cssClass="searchTextBox" 
						       ondblclick="funHelp('WCComCityMaster')" type="text" value="" readonly="true"></s:input>
						</div>
						<div class="col-md-6"><s:input id="txtCityName"  path=""
									 placeholder="City name" type="text" value="" readonly="true"></s:input>
						</div>
					</div>
				</div>
				<div class="col-md-4">
					<label>State Code:</label>
					<div class="row">
						<div class="col-md-6"><s:input id="txtStateCode" path="strStateCode" class="searchTextBox" 
							 ondblclick="funHelp('WCComStateMaster')" type="text" value="" readonly="true"></s:input>
						</div>
						<div class="col-md-6"><s:input id="txtStateName"  path=""
									 placeholder="State Name" type="text" value="" readonly="true"></s:input>
						</div>
					</div>
				</div>
				<div class="col-md-4"></div>
				
				<div class="col-md-4">
					<label>Region  Code:</label>
					<div class="row">
						<div class="col-md-6"><s:input id="txtRegionCode" path="strRegionCode" class="searchTextBox" 
							 ondblclick="funHelp('WCComRegionMaster')" type="text" value="" readonly="true"></s:input>
						</div>
						<div class="col-md-6"><s:input id="txtRegionName"  path=""
						    placeholder="Region Name" type="text" value="" readonly="true"></s:input>
						</div>
					</div>
				</div>
				<div class="col-md-4">
					<label>Country Code:</label>
					<div class="row">
						<div class="col-md-6"><s:input id="txtCountryCode" path="strCountryCode" class="searchTextBox" 
							 ondblclick="funHelp('WCComCountryMaster')" type="text" value="" readonly="true"></s:input>
						</div>
						<div class="col-md-6"><s:input id="txtCountryName" readonly="true" path=""
									 placeholder="Country Name" type="text" value="" ></s:input>
						</div>
					</div>
				</div>
				<div class="col-md-4"></div>
				
				<div class="col-md-4">
					<label>Telephone:</label>
					<div class="row">
						<div class="col-md-6"><s:input id="txtTelePhone1" path="strTelephone1" class="decimal-places numberField"
							type="text" value=""></s:input>
						</div>
						<div class="col-md-6"><s:input id="txtTelePhone2"  path="strTelephone2" class="decimal-places numberField" 
							 type="text" value=""></s:input>
						</div>
					</div>
				</div>
				<div class="col-md-4">
					<label>Fax:</label>
					<div class="row">
						<div class="col-md-6"><s:input id="txtFax1" path="strFax1" class="decimal-places numberField"
							 type="text" value=""></s:input>
						</div>
						<div class="col-md-6"><s:input id="txtFax2"  path="strFax2" class="decimal-places numberField" 
							 type="text" value=""></s:input>
						</div>
					</div>
				</div>
				<div class="col-md-4"></div>
				
				<div class="col-md-2">
					<label>PinCode:</label>
						<s:input id="txtPinCode" path="strPin" type="text" class="decimal-places numberField" value=""></s:input>
				</div>
			</div>
		
			<div align="right" style="margin-right:34%;">
				<a href="#"><button class="btn btn-primary center-block" value="Submit" onclick="return funValidateFields()"
					class="form_button">Submit</button></a>&nbsp;
				<a href="#"><button class="btn btn-primary center-block" type="reset"
					value="Reset" class="form_button" onclick="funResetField()" >Reset</button></a>
			</div>
		</s:form>
	</div>
</body>
</html>


		        
	<%-- <div id="formHeading">
		<label>CompanyMaster</label>
	</div>
	<s:form name="CompanyMaster" method="POST" action="saveCompanyMaster.html">
		<table class="masterTable">
					<tr>
					<td ><label>Company Name</label></td>
							<td ><s:input id="txtCompanyCode"
							ondblclick="funHelp('WCCompanyCode')" cssClass="searchTextBox" 
							readonly="true" type="text" path="strCompanyCode" ></s:input></td>
									
							<td colspan="2"><s:input id="txtCompanyName" path="strCompanyName" 
									cssClass="longTextBox" type="text"></s:input></td>
							<td>Type of Company</td>
					<td><s:select id="cmbCompanyType" name="cmbCompanyType" path="" cssClass="BoxW124px" >
								 <option value="N">No</option>
				 				 <option value="Y">Yes</option>
				 		</s:select></td>		
									
							
		</tr>
		<tr>
						<td>Annual Turnover</td>
					<td colspan="2"><s:input id="txtAnnualTrunover" path="dblAnnualTrunover" 
									cssClass="longTextBox" type="text"></s:input> In Cr. </td>
					<td>Capital and Reserved</td>
					<td colspan="2"><s:input id="txtCapital" path="dblCapital" 
									cssClass="longTextBox" type="text"></s:input> In Cr. </td>				
		
		</tr>
		<tr>
					<td ><label>Member Code</label></td>
							<td width="150px"><s:input id="txtMemberCode"
									ondblclick="funHelp('WCmemProfileCustomer')" cssClass="searchTextBox"
									type="text" path="strMemberCode" ></s:input></td>
					<td colspan="4"><s:input id="txtMemberName" path=""
									cssClass="longTextBox" type="text"  style="width: 34%" ></s:input></td>
		
		</tr>
		<tr>
					<td ><label>Category Code</label></td>
							<td width="150px"><s:input id="txtCategoryCode"
									ondblclick="funHelp('WCCatMaster')" cssClass="searchTextBox"
									type="text" path="strCategoryCode" ></s:input></td>
					<td colspan="4"><s:input id="txtCategoryName"  path=""
									cssClass="longTextBox" type="text"  style="width: 34%"  ></s:input></td>
		
		</tr>
		<tr>
							<td><label>No. of Active </label></td>
							<td colspan="5"><s:input id="txtActiveNominee" path="strActiveNominee" 
									cssClass="longTextBox" type="text" style="width: 21%"></s:input></td>
		</tr>
		
		<tr>
						
						
						<td ><label>Address Line1</label></td>
						<td colspan="5"><s:input id="txtAddress1" path="strAddress1" 
									cssClass="longTextBox" type="text"  style="width: 34%" ></s:input></td>
		</tr>
		<tr>
						<td width="120px"><label>Address Line2</label></td>
						<td colspan="2"><s:input id="txtAddress2" path="strAddress2" 
									cssClass="longTextBox" type="text" style="width: 83%" ></s:input></td>
									
						<td width="120px"><label>Address Line3</label></td>
						<td colspan="2"><s:input id="txtAddress3" path="strAddress3" 
									cssClass="longTextBox" type="text"></s:input></td>					
</tr></table></s:form>		 --%>

