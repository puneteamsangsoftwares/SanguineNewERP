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

		<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 
	 	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
	 
<script type="text/javascript">
	var fieldName;

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
	
	
	$(document).ready(function() {	
		
		$( "#txtMemberCode" ).blur(function() {
			var memberCode=$( "#txtMemberCode" ).val();
			  $('#lblmemberCode').text(memberCode);
			});
		
		$( "#txtMemberName" ).blur(function() {
			var memberName=$( "#txtMemberName" ).val();
			  $('#lblmemberName').text(memberName);
			});
		
	});


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
	 
	 
	 function funResetFields()
		{
			location.reload(true); 
		}
	 
	 
	 function funSetData(code){

		switch(fieldName){

			case 'WCmemProfileCustomer' : 
				funloadMemberData(code);
				break;
		}
	 }
	 
	 
	 function funloadMemberData(code)
		{
			var searchurl=getContextPath()+"/loadWebClubMemberProfileCustomerData.html?customerCode="+code;
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
					        	$("#txtMemberCode").val(response.strMemberCode);
					        	$('#txtMemberName').focus();
					        	$("#txtMemberName").val(response.strFullName);
					        	$('#memberImage').focus();
					        	funloadMemberPhoto(response.strMemberCode);
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
			searchUrl=getContextPath()+"/loadWebClubMemberPhoto.html?docCode="+code;
			$("#memImage").attr('src', searchUrl);
		}
	 
	 

	function funHelp(transactionName)
	{
		fieldName=transactionName;
	//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
	function funReset()
	{
		location.reload(true); 
	}
	
</script>

</head>
<body>
	<div class="container">
		<label id="formHeading">Member Photo</label>
		<s:form name="WebClubMemberPhoto" method="POST" action="saveWebClubMemberPhoto.html"  enctype="multipart/form-data">
			<div class="row masterTable">
				<div class="col-md-6">
					<label>Member Code</label>
					<div class="row">
						<div class="col-md-6"><s:input id="txtMemberCode" ondblclick="funHelp('WCmemProfileCustomer')" cssClass="searchTextBox"
							readonly="true" placeholder="Member Code" type="text" path="strMemberCode"></s:input>
						</div>
					
						<div class="col-md-6"><s:input id="txtMemberName" path="strMemberName" readonly="true"
									 placeholder="Member Code" type="text"></s:input>
						</div>
					</div>
				</div>
				<div class="col-md-6"></div>
					<table class="container masterTable" style="margin-top:30px; background-color:#fff;">
						<tr>
							<td style="border: 1px solid black;"><label>Member Code</label></td>
							<td style="border: 1px solid black;"><label>Member Name</label></td>
							<td style="border: 1px solid black;"><label>Member Photo</label></td>
						</tr>
						<tr>
							<td style="border: 1px solid black;">
								<label id="lblmemberCode"></label>
							</td>
							<td style="border: 1px solid #646777;">
								<label id="lblmemberName"></label>
							</td>
							<td style="border: 1px solid black; width:33%;">
				 				<div style="width:150px"><img id="memImage" src="" width="150px" height="155px" alt="Member Image"></div>
								<div ><input  id="memberImage" name="memberImage"  type="file" accept="image/gif,image/png,image/jpeg" class="btn btn-primary center-block" onchange="funShowImagePreview(this);" /></div>
							</td>
						</tr>
					</table>
			</div>
			<div class="center">
				<a href="#"><button class="btn btn-primary center-block" value="Submit" onclick=""
					class="form_button">Submit</button></a>
				<a href="#"><button class="btn btn-primary center-block" type="reset"
					value="Reset" class="form_button" onclick="funResetField()" >Reset</button></a>
			</div>	
		</s:form>
	</div>
	
	<%-- <div id="formHeading">
	<label>Member Photo</label>
	</div>

<br/>
<br/>

	<s:form name="WebClubMemberPhoto" method="POST" action="saveWebClubMemberPhoto.html"  enctype="multipart/form-data">

		<table class="masterTable">
		<tr>
		<td width="104px"><label>Member Code</label></td>
							<td width="109px"><s:input id="txtMemberCode" path = "strMemberCode" readonly="true"
									ondblclick="funHelp('WCmemProfileCustomer')" cssClass="searchTextBox"
									type="text"  ></s:input></td>
			
							<td colspan="2"><s:input id="txtMemberName"  path="strMemberName" readonly="true"
									cssClass="longTextBox" type="text" style="width: 233px"></s:input></td>	
									
		</tr>
		
		</table>
		<br>
		<br>
		<table class="masterTable">
				<tr>
				<td style="background-color: #C0E4FF;border: 1px solid black;"><label>Member Code</label></td>
				<td style="background-color: #C0E4FF;border: 1px solid black;"><label>Member Name</label></td>
				<td style="background-color: #C0E4FF;border: 1px solid black;"><label>Member Photo</label></td>
			</tr>
			
			<tr>
				<td style="background-color: #C0E4FF;border: 1px solid black;">
				<label id="lblmemberCode"></label>
				</td>
				
				<td style="background-color: #C0E4FF;border: 1px solid black;">
				<label id="lblmemberName"></label>
				</td>
				
				<td style="width:150px;background-color: #C0E4FF;border: 1px solid black;">
				
				 <div style="width:150px" > <img id="memImage" src="" width="150px" height="155px" alt="Member Image"  ></div>
				<div ><input  id="memberImage" name="memberImage"   type="file" accept="image/gif,image/png,image/jpeg" onchange="funShowImagePreview(this);" /></div>

				</td>
			
			
			</tr>
		
		</table>

		<br />
		<br />
		<p align="center">
			<input type="submit" value="Submit" tabindex="3" class="form_button" />
			<input type="reset" value="Reset" class="form_button" onclick="funReset()"/>
		</p>

	</s:form> --%>
</body>
</html>
