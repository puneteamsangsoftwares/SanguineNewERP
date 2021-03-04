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

	
	function funCallFormAction(actionName,object) 
	{
		var flg=true;
		if($('#txtBookerName').val()=='')
		{
			 alert('Enter Name of Booker');
			 flg=false;
			 return flg;
		}
		if($('#txtAddress').val()=='')
		{
			 alert('Enter Address');
			 flg=false;
			 return flg;
		}
		if($('#txtMobileNo').val()=='')
		{
			 alert('Enter Mobile Number');
			 flg=false;
			 return flg;
		}	
		if($('#txtTelephoneNo').val()=='')
		{
			 alert('Enter Telephone Number');
			 flg=false;
			 return flg;
		}	
		
		if($('#txtEmailId').val()=='')
		{
			 alert('Enter Email address');
			 flg=false;
			 return flg;
		}
		
		
		if($('#txtTelephoneNo').val()=='')
		{
			 alert('Enter Telephone Number');
			 flg=false;
			 return flg;
		}
		
		return flg;
	}
	
	function funSetData(code){

		switch(fieldName){

			case 'BookerCode' : 
				funSetBookerCode(code);
				break;
		}
	}


	function funSetBookerCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadBookerCode.html?bookerCode=" + code,
			dataType : "json",
			success: function(response)
	        {
				
	        	if(response.strBookerCode=='Invalid Code')
	        	{
	        		alert("Invalid Agent Code");
	        		$("#txtBookerCode").val('');
	        	}
	        	else
	        	{					        	    	        		
	        		$("#txtBookerCode").val(response.strBookerCode);
	        		$("#txtBookerName").val(response.strBookerName);
	        		$("#txtAddress").val(response.strCommisionPaid);
	        		$("#txtAddress").val(response.strAddress);
	        		$("#txtCity").val(response.strCity);
	        		$("#txtState").val(response.strState);
	        		$("#txtCountry").val(response.strCountry);
	        		$("#txtMobileNo").val(response.lngMobileNo);
	        		$("#txtTelephoneNo").val(response.lngTelephoneNo);
	        		$("#txtEmailId").val(response.strEmailId);
	        		
	        		if(response.strBlackList=='Y')
			    	{
			    		document.getElementById("chkBlackList").checked=true;
			    	}
			    	else
			    	{
			    		document.getElementById("chkBlackList").checked=false;
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
		//window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
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
					 if($("#txtBookerCode").val().trim()=="")
					{
						alert("Please Select Booker Code... ");
						return false;
					} 
						window.open('attachDoc.html?transName=frmBookerMaster.jsp&formName=Member Profile&code='+$('#txtBookerCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
				});
	
</script>

</head>
<body>
  <div class="container masterTable">
	<label id="formHeading">Booker Master</label>
	 <s:form name="BookerMaster" method="POST" action="saveBookerMaster.html">
	 
          <div class="row">
          
				<div class="col-md-5">
				  <div class="row">
				      <div class="col-md-5"><label>Booker Code</label>
				             <s:input type="text" id="txtBookerCode" path="strBookerCode" cssClass="searchTextBox" ondblclick="funHelp('BookerCode');"/>
				       </div>
		              <div class="col-md-7"><label>Booker Name</label>
					         <s:input type="text" id="txtBookerName" path="strBookerName"/>
				        </div>
			    </div></div>
		         
		          <div class="col-md-7"></div>
		          
				<div class="col-md-3">	<label>Address</label>
				    <s:input type="text" id="txtAddress" path="strAddress"/>
				</div>
			
			    <div class="col-md-1"><label>City</label>
				    <s:select id="txtCity" path="strCity" items="${cityArrLsit}" style="width: 120%;"/>
				</div>
	
			    <div class="col-md-2"><label>State</label>
				    <s:select id="txtState" path="strState"  items="${stateArrLsit}" style="width: 60%;"/>
				</div>
			
			    <div class="col-md-1" style="margin-left: -7%;"><label>Country</label>
					<s:select id="txtCountry" path="strCountry" items="${countryArrLsit}"/>
				</div>
		         <div class="col-md-5"></div>
		         
				<div class="col-md-2"><label>Mobile No</label>
					<s:input colspan="3" type="text" id="txtMobileNo" path="lngMobileNo"/>
				 </div>

				 <div class="col-md-2"><label>Telephone No</label>
				    <s:input type="text" id="txtTelephoneNo" path="lngTelephoneNo"/>
				</div>
			
			  <div class="col-md-2"><label>Email Id</label>
				  <s:input type="text" id="txtEmailId" path="strEmailId" style="width: 110%;"/>
			   </div>
		        <div class="col-md-6"></div> 
		        
			 <div class="col-md-2"><label>Black List this corporate</label><br>
			        <s:checkbox id="chkBlackList" path="strBlackList" value="" />
			 </div>
		 </div>
         
		<p align="center"  style="margin-right: 12%;">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" onclick="return funCallFormAction('submit',this);" />&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>

	</s:form>
	</div>
</body>
</html>
