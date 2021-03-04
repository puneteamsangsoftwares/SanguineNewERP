<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
     <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
<script type="text/javascript">
var fieldName;

/**
* Open Help
**/
function funHelp(transactionName)
{
	fieldName=transactionName;
	window.open("searchform.html?formname="+transactionName+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
    //window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
}

$(function() 
		{
			var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
			$("#txtMobileNo").val("");
			$("#txtDOB").datepicker('setDate', pmsDate);
			$("#txtDOB").val(pmsDate);
			var d = new Date();
			var year = d.getFullYear() - 0;
			var date=pmsDate.split
			var dateArr = pmsDate.split('-');
			d.setFullYear(year);
			$('#txtDOB').datepicker({ changeYear: true, changeMonth: true, yearRange: '1920:' + year + '',  maxDate: 0 ,defaultDate: d,dateFormat: 'dd-mm-yy'});
			//$("#txtDOB").datepicker({ dateFormat: 'dd-mm-yy' });
			
			
					
			$("#txtPassportExpiryDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtPassportExpiryDate").datepicker('setDate', pmsDate);
			
			$("#txtPassportIssueDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtPassportIssueDate").datepicker('setDate', pmsDate);
			
			$("#txtAnniversaryDte").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtAnniversaryDte").datepicker('setDate', pmsDate);
			
		});

function funSetData(code)
{

		switch(fieldName)
		{
		   case 'guestCode' : 
			   funSetGuestCode(code);
				break;
			
		}
}



/**
*   Attached document Link
**/
$(function()
{

	$('a#baseUrl').click(function() 
	{
		if($("#txtGuestCode").val().trim()=="")
		{
			alert("Please Select Guest Code");
			return false;
		}
	   window.open('attachDoc.html?transName=frmGuestMaster.jsp&formName=Guest Master&code='+$('#txtGuestCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
	});

});

function funSetGuestCode(code)
{
	var searchurl=getContextPath()+"/loadGuestCode.html?guestCode="+code;
	 $.ajax({
	        type: "GET",
	        url: searchurl,
	        dataType: "json",
	        success: function(response)
	        {
	        	if(response.strGuestCode=='Invalid Code')
	        	{
	        		alert("Invalid Walikn No");
	        		$("#txtGuestCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtGuestCode").val(response.strGuestCode);
		        	$("#cmbGuestPrefix").val(response.strGuestPrefix);
		        	$("#txtFirstName").val(response.strFirstName);
		        	$("#txtMiddleName").val(response.strMiddleName);
		        	$("#txtLastName").val(response.strLastName);
		        	$("#cmbGender").val(response.strGender);
		        	$("#txtDOB").val(response.dteDOB);
		        	$("#txtDesignation").val(response.strDesignation);
		        	$("#txtAddress").val(response.strAddress);
		        	$("#cmbCity").val(response.strCity);
		        	$("#cmbState").val(response.strState);
		        	$("#cmbCountry").val(response.strCountry);
		        	$("#txtNationality").val(response.strNationality);
		        	$("#txtPinCode").val(response.intPinCode);
		        	$("#txtMobileNo").val(response.lngMobileNo);
		        	$("#txtFaxNo").val(response.lngFaxNo);
		        	$("#txtEmailId").val(response.strEmailId);
		        	$("#txtPANNo").val(response.strPANNo);
		        	$("#txtArrivalFrom").val(response.strArrivalFrom);
		        	$("#txtProceedingTo").val(response.strProceedingTo);
		        	$("#txtStatus").val(response.strStatus);
		        	$("#txtVisitingType").val(response.strVisitingType);
		        	$("#txtPassportNo").val(response.strPassportNo);
		        	$("#txtPassportIssueDate").val(response.dtePassportIssueDate);
		        	$("#txtPassportExpiryDate").val(response.dtePassportExpiryDate);
		        	$("#txtGSTNo").val(response.strGSTNo);
		        	$("#txtAnniversaryDte").val(response.dteAnniversaryDate);
		        	$("#txtUIDNo").val(response.strUIDNo);
		        
		        	$("#cmbDefaultAddr").val(response.strDefaultAddr);
		        	
		        	$("#txtAddressLocal").val(response.strAddressLocal);
		        	$("#cmbCityLocal").val(response.strCityLocal);
		        	$("#cmbStateLocal").val(response.strStateLocal);
		        	$("#cmbCountryLocal").val(response.strCountryLocal);
		        	$("#txtPinCodeLocal").val(response.intPinCodeLocal);
		        	
		        	$("#txtAddressPermanent").val(response.strAddrPermanent);
		        	$("#cmbCityPermanent").val(response.strCityPermanent);
		        	$("#cmbStatePermanent").val(response.strStatePermanent);
		        	$("#cmbCountryPermanent").val(response.strCountryPermanent);
		        	$("#txtPinCodePermanent").val(response.intPinCodePermanent);
		        	
		        	$("#txtAddressOfc").val(response.strAddressOfc);
		        	$("#cmbCityOfc").val(response.strCityOfc);
		        	$("#cmbStateOfc").val(response.strStateOfc);
		        	$("#cmbCountryOfc").val(response.strCountryOfc);
		        	$("#txtPinCodeOfc").val(response.intPinCodeOfc);
		            $("#txtExternalID").val(response.strExternalID);
		        	$("#txtRemark").val(response.strRemark);

		        	
		        	
		        	
		        	funloadMemberPhoto(response.strGuestCode);
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

});

	function  funCallFormAction(actionName,object)
	{
		var flg=true;
		
		if($('#txtFirstName').val().trim().length==0)
		{
			alert("Guest name should not be empty!!");
			flg=false;
			document.getElementById("txtFirstName").focus();

		}
		else
		{
			var mobileNo =  $("#txtMobileNo").val();
			 if(mobileNo=="0")
				{
				  alert("Zero is not Valid Mobile Number");
				  flg= false;
				  document.getElementById("txtMobileNo").focus();
				} 
			 else  if(mobileNo!="0")
				{
					if($("#txtGuestCode").val()==""){
						
						var mobilecount = funGetGuestMobileNo(mobileNo)
					    if(mobilecount>0)
						   {
						   	 alert("Mobile Number Already Exist for Another Guest");
						   	 flg=false;
						   	document.getElementById("txtMobileNo").focus();
						   }
					}	
					if(flg){
					var pattern = /^[\s()+-]*([0-9][\s()+-]*){6,20}$/;
					if (pattern.test(mobileNo)) 
					{
						flg=true;
						
						 var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;

					        
						if($("#txtPANNo").val()=="")
						{}
						else
						{
							var panVal = $('#txtPANNo').val();
							var regpan = /^([a-zA-Z]){5}([0-9]){4}([a-zA-Z]){1}?$/;
							if(regpan.test(panVal))
							{
							   flg=true;
							}
							else // invalid pan card number
							{
								alert("Enter Valid PAN No!!");
								flg=false;
								
							}
						}
					         
					        if($("#txtUIDNo").val()=="")
							{
					        	
					        	//alert("Enter UID Number!");
								flg=false;
							   //	document.getElementById("txtUIDNo").focus();

								
							}
							else
							{ 
								var panVal = $('#txtUIDNo').val();
								var regpan = /^(([0-9]){12})/;
								if(regpan.test(panVal))
								{
								   flg=true;
								}
								else // invalid pan card number
								{
									alert("Enter Valid UID No!!");
									flg=false;
								}
							}
					}
					
					
					/* else
					{
						alert("Invalid Mobile No");
						flg=false;
					}	 */
					}
				}
		   	
			
			
			var regmob = /^\d{10}$/;
			if(regmob.test($('#txtMobileNo').val()))
			{
			   flg=true;
			}
			else // invalid pan card number
			{
			alert("Enter Valid Mobile No!!");
			flg=false;
		    }
			
	   }	
		
		
		return flg;
	}
	
	function funGetGuestMobileNo(mobileNo)
	{
		var returnVal =0;
		var searchurl=getContextPath()+"/checkGuestMobileNo.html?mobileNo="+mobileNo;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        async:false,
			        success: function(response)
			        {
			        	returnVal = response;
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
		 return returnVal;
	}
	
	
	function funOpenExportImport()			
		{
			var transactionformName="frmGuestMaster";
			//var guestCode=$('#txtGuestCode').val();
			
			
		//	response=window.showModalDialog("frmExcelExportImport.html?formname="+transactionformName+"&strLocCode="+locCode,"","dialogHeight:500px;dialogWidth:500px;dialogLeft:550px;");
			response=window.open("frmExcelExportImport.html?formname="+transactionformName,"dialogHeight:500px;dialogWidth:500px;dialogLeft:550px;");
	        
			
		}
	
	//Image Code
	
	function funloadMemberPhoto(code)
	{
		var searchUrl1=getContextPath()+"/loadGuestImage.html?guestCode="+code;
		 $.ajax({
		        type: "GET",
		        url: searchurl,
		        cache: false
		        
		 });
		$("#memImage").attr('src', searchUrl1);
	}  



 	function funShowImagePreview(input)
	 {
		 if (input.files && input.files[0])
		 {
			 var filerdr = new FileReader();
			 filerdr.onload = function(e) 
			 {
			 $('#memImage').attr('src', e.target.result);
			 }
			 filerdr.readAsDataURL(input.files[0]);
		 }
		 
		
	 }

</script>
</head>
<body>
	<div class="container">
		<label class="masterTable" id="formHeading">Guest Master</label>
	<s:form name="Guest" action="saveGuestMaster.html?saddr=${urlHits}" method="POST" enctype="multipart/form-data">
	
	<br>
	   <div class="row">
				<!-- <th align="right" colspan="6"><a id="baseUrl"
					href="#"> Attach Documents</a>&nbsp; &nbsp; &nbsp;
						&nbsp;</th> -->
						 
 					<div class="col-md-12" align="center"><a onclick="funOpenExportImport()" style="margin-right: -75%;"
					     href="javascript:void(0);"><u>Export/Import</u></a>
					<!-- <a id="baseUrl" href="#"> Attach Documents</a> -->
					</div>
					
					<c:if test="${!empty documentList}">
					<c:forEach items="${documentList}" var="doc" varStatus="i" >
				<tr>
					<td width="200px">${doc.strActualFileName}</td>
				
					<td><a
						href="${pageContext.request.contextPath}/download/${doc.strCode},${doc.intId}.html">${doc.strActualFileName}</a>

					</td>
				</tr>
			</c:forEach>
			</c:if>
				
			   <div class="col-md-2"><label>Guest Code</label>
				  <s:input id="txtGuestCode" path="strGuestCode" cssClass="searchTextBox" style="height:25px;" ondblclick="funHelp('guestCode')" />				
			   </div>
			   <div class="col-md-2"><label>External ID</label><label style="color: red;"></label>
					<s:input type="text" id="txtExternalID" path="strExternalID" />
				</div>
			   <div class="col-md-8"></div>
			   
		        <div class="col-md-2"><label>Guest Prefix</label>
					<s:select id="cmbGuestPrefix" path="strGuestPrefix" style="width:60%;">
				    	<s:options items="${prefix}"/>
				    </s:select>
				</div>
				
				<div class="col-md-2"><label>First Name</label><label style="color: red;"> *</label>
					<s:input type="text" id="txtFirstName" path="strFirstName" />
				</div>
							
				<div class="col-md-2"><label>Middle Name</label>
					<s:input type="text" id="txtMiddleName" path="strMiddleName"/>
				</div>
							
				<div class="col-md-2"><label>Last Name</label>
					<s:input type="text" id="txtLastName" path="strLastName"/>
				</div>
				<!-- <div class="col-md-5"></div>	 -->
				
				<div class="col-md-1">
					<label>Gender</label>
					 <s:select id="cmbGender" path="strGender">
				    	<s:options items="${gender}"/>
				      </s:select>
				</div>
				<div class="col-md-3"></div>
				<div class="col-md-2"><label>DOB</label>
					<s:input type="text" id="txtDOB" path="dteDOB" style="width:70%;" cssClass="calenderTextBox" />
				</div>
						
				<div class="col-md-2">
					<label>MobileNo</label>
				<!-- 	<label style="color: red;"> *</label> -->
					<s:input type="text" id="txtMobileNo" style="text-align:right;" path="intMobileNo" onblur="fun1(this);" />
				</div>
				
				<div class="col-md-2"><label>Email Id</label><br>
					  <s:input type="email" placeholder="Enter a valid email address" id="txtEmailId" style="width:100%;border:none;" path="strEmailId"/>
				</div>
				
				<div class="col-md-2"><label>PAN No</label>
					<s:input type="text" id="txtPANNo" path="strPANNo"/>
				</div>
				
				<div class="col-md-2"><label>Passport No</label>
					<s:input type="text" id="txtPassportNo" path="strPassportNo"/>
				</div>
				<div class="col-md-2"></div>
				<div class="col-md-2"><label>Passport Issue Date</label>
					<s:input type="text" id="txtPassportIssueDate" style="width:70%;" path="dtePassportIssueDate" cssClass="calenderTextBox" />
				</div>
				
				<div class="col-md-2"><label>PassportExpiryDate</label>
					 <s:input type="text" id="txtPassportExpiryDate" style="width:70%;" path="dtePassportExpiryDate" cssClass="calenderTextBox" />
				</div>
				
				<div class="col-md-2"><label>Nationality</label>
				     <s:input type="text" id="txtNationality" path="strNationality"/>
			    </div>
			    
				<div class="col-md-2"><label>Arrival From</label>
					<s:input type="text" id="txtArrivalFrom" path="strArrivalFrom"/>
				</div>
					
				<div class="col-md-2"><label>Proceeding To</label>
					   <s:input type="text" id="txtProceedingTo" path="strProceedingTo"/>
				</div>
				<div class="col-md-2"></div>
				<div class="col-md-2"><label>Status</label>
					<s:input  type="text" id="txtStatus" path="strStatus"/>
				</div>
				
				<div class="col-md-2"><label>Visiting Type</label>
					<s:input type="text" id="txtVisitingType" path="strVisitingType"/>
				</div>
				
				<div class="col-md-2"><label>GST No.</label>
					 <s:input type="text" id="txtGSTNo" path="strGSTNo" style="width: 80%;"/>
				</div>
						
				<div class="col-md-2">
					<label>Anniversary Date</label>
					<s:input type="text" id="txtAnniversaryDte" path="dteAnniversaryDate" style="width:70%;" cssClass="calenderTextBox" />
				</div>
						
				<div class="col-md-2"><label>UID No.</label><!-- <label style="color: red;"> *</label> -->
					<s:input type="text" id="txtUIDNo" style="text-align:right;" path="strUIDNo"/>
				</div>
									
				<div class="col-md-2"><label>Default Address</label>
					<s:select id="cmbDefaultAddr" path="strDefaultAddr" style="width:auto;">
			    		<s:option value="Local">Local</s:option><s:options/>
			    		<s:option value="Permanent">Permanent</s:option><s:options/>
			    		<s:option value="Office">Office</s:option><s:options/>
			    	</s:select>
			    </div>
			   
			    <div class="col-md-2"><label>Remark</label>
					<s:textarea id="txtRemark" path="strRemark"  type="text" style="height: 57%;width: 177%;"/>
				</div>
					
					
				<div class="col-md-2">					
				 	<div><img id="memImage" src="" style="width:auto;height:150px;margin: 10% 0%;font-size:14px;margin-left:119%;" alt="Member Image"></div>
			        <div><input  id="memberImage" name="memberImage" type="file" accept="image/gif,image/png,image/jpeg" onchange="funShowImagePreview(this);" style="width:220px; background-color: #fbfafa;margin-left:83%;"/></div>
       			</div>
					
				<div class="col-md-12" style="FONT-WEIGHT: bold;PADDING-TOP: 5px;">
						<label>Local Address</label>
				</div>
			
				<div class="col-md-2"><label>Address</label>
					<s:textarea id="txtAddressLocal" path="strAddressLocal"  type="text" style="height: 45%;"/>
				</div>
				
		        <div class="col-md-1"><label>City</label>
		        <s:input type="text" id="cmbCityLocal" path="strCityLocal"/>
					<%-- <s:select id="cmbCityLocal" path="strCityLocal" style="width:auto;">
			    		<s:options items="${listCity}"/>
			    	</s:select> --%>
				</div>
				
				<div class="col-md-1" style="padding-left:auto;"><label>State</label>
				<s:input type="text" id="cmbStateLocal" path="strStateLocal"/>
						<%--  <s:select id="cmbStateLocal" path="strStateLocal" style="width:auto;">
			    			<s:options items="${listState}"/>
			    		</s:select> --%>
			    </div>	
			    	
			    <div class="col-md-1" style="padding-left:35px;"><label>Country</label>
						 <s:select id="cmbCountryLocal" path="strCountryLocal" style="width:65px;">
			    			<s:options items="${listCountry}"/>
			    		</s:select>
				</div>
				
				<div class="col-md-1"><label>Pin Code</label>
					<s:input  type="text" id="txtPinCodeLocal" style="text-align:right;" path="intPinCodeLocal"/>
				</div>
				<div class="col-md-6"></div>
				
				<div class="col-md-12" style="FONT-WEIGHT: bold;PADDING-TOP: 5px;">
					<label>Permanent Address</label>
				</div>
				
				<div class="col-md-2"><label>Address</label>
					<s:textarea id="txtAddressPermanent" path="strAddrPermanent" type="text" style="height: 45%;" />
				</div>
						 
				 <div class="col-md-1"><label>City</label>
					<%-- <s:select id="cmbCityPermanent" path="strCityPermanent" style="width:auto;">
			    		<s:options items="${listCity}"/>
			    	</s:select> --%>
			    	<s:input type="text" id="cmbCityPermanent" path="strCityPermanent"/>
				 </div>
					
					<div class="col-md-1" style="padding-left:auto;"><label>State</label>
						 <%-- <s:select id="cmbStatePermanent" path="strStatePermanent"  style="width:auto;">
			    			<s:options items="${listState}"/>
			    		  </s:select> --%>
			    		  <s:input type="text" id="cmbStatePermanent" path="strStatePermanent"/>
			    	</div>
			    	
					<div class="col-md-1" style="padding-left:35px;"><label>Country</label>
						 <s:select id="cmbCountryPermanent" path="strCountryPermanent" style="width:65px;">
			    			<s:options items="${listCountry}"/>
			    		</s:select>
					</div>
					
				    <div class="col-md-1"><label>Pin Code</label>
						<s:input  type="text" id="txtPinCodePermanent" style="text-align:right;" path="intPinCodePermanent"/>
					</div>
				     <div class="col-md-6"></div>
				     
					<div class="col-md-12" style="FONT-WEIGHT: bold;PADDING-BOTTOM: 5px;">
						<label>Office Address</label>
					</div>
				
				    <div class="col-md-2"><label>Address</label>
					   <s:textarea id="txtAddressOfc" path="strAddressOfc" type="text" style="height: 45%;" />
					</div>
					     
				   <div class="col-md-1"> <label>City</label>
						<%-- <s:select id="cmbCityOfc" path="strCityOfc" style="width:auto;">
			    			<s:options items="${listCity}"/>
			    		</s:select> --%>
			    		<s:input type="text" id="cmbCityOfc" path="strCityOfc"/>
					</div>
					
					<div class="col-md-1"><label>State</label>
						<%--  <s:select id="cmbStateOfc" path="strStateOfc" style="width:auto;">
			    			<s:options items="${listState}"/>
			    		</s:select> --%>
			    		<s:input type="text" id="cmbStateOfc" path="strStateOfc"/>
			    	</div>
			    		
					<div class="col-md-1" style="padding-left:35px;"><label>Country</label>
						 <s:select id="cmbCountryOfc" path="strCountryOfc" style="width:65px;">
			    			<s:options items="${listCountry}"/>
			    		</s:select>
					</div>
					
				   <div class="col-md-1"><label>Pin Code</label>
					     <s:input type="text" id="txtPinCodeOfc" style="text-align:right;" path="intPinCodeOfc"/>
					</div>
					
				  <div class="col-md-12"><label style="color: red;"> * indicates mandatory fields</label>
				  </div>
		</div>
		
		<p align="center" style="margin-right: 155px;">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" onclick="return funCallFormAction('submit',this);" />&nbsp;
            <input type="reset" value="Reset" class="btn btn-primary center-block"  class="form_button" />
         </p>
	</s:form>
	</div>
</body>
</html>