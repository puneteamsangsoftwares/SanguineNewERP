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

<script type="text/javascript">
	var fieldName;

	$(function() 
	{
	});

	function funSetData(code){

		switch(fieldName){

			case 'CorporateCode' : 
				funSetCorporateCode(code);
				break;
		}
	}

	
	/**
	 *  Check Validation Before Saving Record
	 **/
	function funCallFormAction(actionName,object) 
	{
		var flg=true;
		if($('#txtMobileNo').val()=='')
		{
			alert('Enter Mobile Number ');
			flg=false;								  
		}
		
		if($('#txtPersonIncharge').val()=='')
		{
			alert('Enter Name Of Person in charge ');
			flg=false;								  
		}
		
		
		return flg;
	}

	function funSetCorporateCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadCorporateCode.html?corpcode=" + code,
			dataType : "json",
			success: function(response)
	        {
				
	        	if(response.strCorporateCode=='Invalid Code')
	        	{
	        		alert("Invalid Agent Code");
	        		$("#txtCorporateCode").val('');
	        	}
	        	else
	        	{					        	    	        		
	        		$("#txtCorporateCode").val(response.strCorporateCode);
	        		$("#txtCorporateDesc").val(response.strCorporateDesc);
	        	    $("#txtPersonIncharge").val(response.strPersonIncharge);
	        		$("#txtAddress").val(response.strAddress);
	        		$("#txtCity").val(response.strCity);
	        		$("#txtState").val(response.strState);
	        		$("#txtCountry").val(response.strCountry);
	        		$("#txtMobileNo").val(response.lngMobileNo);
	        		$("#txtTelephoneNo").val(response.lngTelephoneNo);
	        		$("#txtFax").val(response.lngFax);
	        		$("#txtArea").val(response.strArea);
	        		$("#txtPinCode").val(response.intPinCode);
	        		$("#txtSegmentCode").val(response.strSegmentCode);
	        		$("#txtPlanCode").val(response.strPlanCode);
	        		$("#txtRemarks").val(response.strRemarks);
	        		$("#txtAgentType").val(response.strAgentType);
	        		$("#txtCreditLimit").val(response.dblCreditLimit);
	        		$("#txtDiscountPer").val(response.dblDiscountPer);
	        		
	        		if(response.strBlackList=='Y')
			    	{
			    		document.getElementById("chkBlackList").checked=true;
			    	}
			    	else
			    	{
			    		document.getElementById("chkBlackList").checked=false;
			    	}
			    	
			    	if(response.strCreditAllowed=='Y')
			    	{
			    		document.getElementById("chkCreditAllowed").checked=true;
			    	}
			    	else
			    	{
			    		document.getElementById("chkCreditAllowed").checked=false;
			    	}
			    	
	        	}
			},
			error: function(jqXHR, exception) 
			{
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



	function funHelp(transactionName)
	{
		fieldName=transactionName;
		window.open("searchform.html?formname="+transactionName+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
		//1window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
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
	
	 $('#baseUrl').click(function() 
				{  
					 if($("#txtCorporateCode").val().trim()=="")
					{
						alert("Please Select Corporate Code... ");
						return false;
					} 
						window.open('attachDoc.html?transName=frmCorporateMaster.jsp&formName=Member Profile&code='+$('#txtCorporateCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
				});
	
	
</script>

</head>
<body>
  <div class="container masterTable">
	 <label id="formHeading">Corporate Master</label>
	       <s:form name="CorporateMaster" method="POST" action="saveCorporateMaster.html">

		    <div class="row">
		    	  <div class="col-md-2">
		    	  	  <label>Corporate Code</label>
				       <s:input  type="text" id="txtCorporateCode" path="strCorporateCode" cssClass="searchTextBox"  ondblclick="funHelp('CorporateCode');"/>
				  </div>
				  <div class="col-md-2">
				  	   <s:input  type="text" id="txtCorporateDesc" path="strCorporateDesc" style="margin-top:26px;"/>
				 </div>
			
			      <div class="col-md-2"><label>Person Incharge</label>
				      <s:input type="text" id="txtPersonIncharge" path="strPersonIncharge"/>
			      </div>
		
		           <div class="col-md-2"><label>Discount %</label>
				     <s:input type="text" id="txtDiscountPer" path="dblDiscountPer" style="text-align:right;width:60%;"/>
				   </div>
		
			       <div class="col-md-2"><label>Address</label>
				       <s:input type="text" id="txtAddress" path="strAddress" />
				   </div>
					<div class="col-md-2"></div>
			       <div class="col-md-2"><label>City</label>
				     <s:select  id="txtCity" path="strCity"  items="${cityArrLsit}" style="width: auto;"></s:select>
				   </div>
			     
			       <div class="col-md-2"><label>State</label>
				       <s:select id="txtState" path="strState"  items="${stateArrLsit}" style="width:auto;"> </s:select>
				   </div>
			
			        <div class="col-md-2"><label>Country</label>
				       <s:select id="txtCountry" path="strCountry"  items="${countryArrLsit}" style="width: auto;"></s:select>
				    </div>
			      
			        <div class="col-md-2"><label>Mobile No</label>
			             <s:input type="text" class="numeric" id="txtMobileNo" style="text-align:right;" path="lngMobileNo"/>
				    </div>
			      
			        <div class="col-md-2"><label>Telephone No</label>
				         <s:input colspan="3" type="text" id="txtTelephoneNo" style="text-align:right;" path="lngTelephoneNo"/>
				    </div>
			      	<div class="col-md-2"></div>
			        <div class="col-md-2"><label>Fax</label>
			            <s:input type="text" id="txtFax" path="lngFax"/>
				    </div>
			      
			        <div class="col-md-2">
			        	<label>Area</label>
				      		<s:select id="txtArea" path="strArea" style="width:60%;">
				        		 <s:option value="Select">Select</s:option>
				     		</s:select>
				    </div>
		          
		            <div class="col-md-2"><label>Pin Code</label>
				       <s:input type="text" class="numeric" style="text-align:right;" id="txtPinCode" path="intPinCode" />
				    </div>
			       
			      <div class="col-md-2"><label>Segment Code</label>
				         <s:select id="txtSegmentCode" path="strSegmentCode" style="width:80%;">
					         <s:option value="Select">Select</s:option>
					      </s:select>
				   </div>
				   
			       <div class="col-md-2"><label>Plan Code</label>
				     <s:select id="txtPlanCode" path="strPlanCode">
					      <s:option value="Select">Select</s:option>
					      <s:option value="American Plan">American Plan</s:option>
					      <s:option value="Continental Plan">Continental Plan</s:option>
					       <s:option value="Modified American Plan">Modified American Plan</s:option>
					       <s:option value="Not Applicable">Not Applicable</s:option>
					 </s:select>
			       </div>
	 		 <div class="col-md-2"></div>
				<div class="col-md-2"><label>Remarks</label>
					<s:input type="text" id="txtRemarks" path="strRemarks"/>
				</div>
		
			    <div class="col-md-2"><label>AgentType</label>
					<s:input type="text" id="txtAgentType" path="strAgentType"/>
				</div>
			
				<div class="col-md-2"><label>Credit Limit</label>
					<s:input type="number" step="0.01" style="text-align:right;" id="txtCreditLimit" path="dblCreditLimit"/>
				</div>
			
					
<!-- 					<label>CreditAllowed</label> -->
<!-- 				</td> -->
				

				 <div class="col-md-2"><label>Credit Allowed</label><br>
				     <s:checkbox  id="chkCreditAllowed" path="strCreditAllowed"  value="" />
				 </div>
				
				 <div class="col-md-2"><label>Black List this corporate</label><br>
				     <s:checkbox id="chkBlackList" path="strBlackList" value="" />
				 </div>
				
			</div>
		
		<br />
		<br />
		<p align="right" style="margin-right: 18%;">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" onclick="return funCallFormAction('submit',this);" />&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>
    </s:form>
	</div>
</body>
</html>
