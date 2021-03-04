<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
     	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.css"/>" />
		<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" /> 
	     <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" /> 
	     <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 	
	 	
	 	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<%-- <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.js"/>"></script> --%>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
	<meta http-equiv="X-UA-Compatible" content="IE=8"/>


<script type="text/javascript">
		
		/**
		 * Global variable
		 */
		var fieldName;
	 $(document).ready(function()
					{
		 
		 $("#txtdtMemberFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
			$("#txtdtMemberFromDate" ).datepicker('setDate', 'today');
			$("#txtdtMemberFromDate").datepicker();
			
	        $("#txtdtMemberToDate").datepicker({ dateFormat: 'dd-mm-yy' });
	        $("#txtdtMemberToDate" ).datepicker('setDate', 'today');
	        $("#txtdtMemberToDate").datepicker();
	        
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
	    //    window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	        window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	        
	    }
	 
	 function funResetField()
		{
			location.reload(true); 
			
 			 $("#txtFormNo").val("");
     		$("#txtProspectName").val("");
//      		 $("#txtdtMemberFromDate").datepicker({ dateFormat: 'yy-mm-dd' });
// 			$("#txtdtMemberFromDate" ).datepicker('setDate', 'today');
// 			//$("#txtdtMemberFromDate").datepicker();

// 	        $("#txtdtMemberToDate").datepicker({ dateFormat: 'yy-mm-dd' });
// 	        $("#txtdtMemberToDate" ).datepicker('setDate', 'today');
	       // $("#txtdtMemberToDate").datepicker();
		}
	 
	 function funSetData(code)
		{
			switch (fieldName) 
			{
			    case 'WCMemberForm':
			    	funSetFormNo(code);
			        break; 
			        
			    case 'webClubBusinessSrcCode':
			    	funSetBusinessCodeDData(code);
			        break;  			        
			        
			    case 'WCCatMaster':
			    	funSetMemberCategoryData(code);
			        break; 
			}
		}
	 
	 function funSetBusinessCodeDData(code){
		 $.ajax({
				type : "GET",
				url : getContextPath()+ "/loadWebClubBusinessSourceData.html?docCode="+code,
				dataType : "json",
				success : function(response){ 

					if(response.strSCCode=='Invalid Code')
		        	{
		        		alert("Invalid Business Source Code");
		        		$("#txtBusinessSrcCode").val('');
		        	}
		        	else
		        	{      
			        	$("#txtBusinessSrcCode").val(code);
			        	$("#lblBSName").text(response[0][1]);
			        	//$("#txtBusinessSourcePercent").val(response[0][2]);
			        	
			        	
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
	 
	 function funSetMemberCategoryData(code){
		 
			$("#txtCatCode").val(code);
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
					        	$("#txtCategoryCode").val(code);
					        	$("#txtMCName").val(response.strCatName);
					        	
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
	 
	 
	 function funSetFormNo(code)
		{
			$("#txtFormNo").val(code);
			var searchurl=getContextPath()+"/loadMemberFormNoData.html?formNo="+code;
			//alert(searchurl);
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strFormNo=='invalid Code')
				        	{
				        		alert("Invalid Form No");
				        		$("#txtFormNo").val('');
				        		
				        	}
				        	else
				        	{
					        	$("#txtFormNo").val(code);
					        	$("#txtProspectName").val(response.strProspectName);
					        	$("#txtdtMemberFromDate").val(response.dteCreatedDate.split(" ")[0]);
					        	$("#txtdtMemberToDate").val(response.dtePrintDate.split(" ")[0]);
 					        	$("#txtdtMemberFromDate").val(response.dteCreatedDate);
 					        	$("#txtdtMemberToDate").val(response.dtePrintDate);
					        	$("#txtProspectName").focus();
					        	$("#txtBusinessSrcCode").val(response.strBusinessSourceCode);
					        	$("#txtCategoryCode").val(response.strCategoryCode);						        	
					        	funSetMemberCategoryData(response.strCategoryCode)
					        	funSetLabelName(response.strBusinessSourceCode)
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
		
	 function funSetLabelName(code)
	 {
		 $.ajax({
				type : "GET",
				url : getContextPath()+ "/loadWebClubBusinessSourceData.html?docCode="+code,
				dataType : "json",
				success : function(response){ 

					if(response.strSCCode=='Invalid Code')
		        	{
		        		alert("Invalid Business Source Code");
		        		$("#txtBusinessSrcCode").val('');
		        	}
		        	else
		        	{      
			        	$("#lblBSName").text(response[0][1]);
			        	
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
	 
	 
	 
	 
	 
</script>
		
</head>
<body><%-- 
  <div class="container">
		<label id="formHeading">Membership Form Generation</label>
			<s:form name="frmMembershipFormGenration" action="saveMembershipFormGenration.html?saddr=${urlHits}" method="POST" style="padding:0;">
				<div class="row masterTable">
					<div class="col-md-6">
						<div class="row">
							<div class="col-md-6">
								<label>Form No:</label>
									<s:input id="txtFormNo" name="txtFormNo" path="strFormNo" 
				             			type="text" cssClass="searchTextBox" ondblclick="funHelp('WCMemberForm')" /> <s:errors path=""></s:errors>	
				    		 </div>
				     		<div class="col-md-6">
								<label>Prospect Name:</label><br>
									<s:input id="txtProspectName" path="strProspectName" name="txtProspectName" required="true"
				            			type="text"/> <s:errors path=""></s:errors>	
				    		</div>
						</div>
					</div>
					<div class="col-md-6">
						<label>Member Category Code:</label><br>
							<div class="row">
								<div class="col-md-6"><s:input id="txtMemberCode" cssClass="searchTextBox" disabled />
								</div>
					
								<div class="col-md-6"><s:input id="txtMCName"  name="txtMCName" cssStyle="text-transform: uppercase;" cssClass="longTextBox"
				              		type="text" disabled />
								</div>
							</div>
					</div>
					<div class="col-md-6">
						<div class="row">
							<div class="col-md-6">
								<label>Form Generation Date:</label>
									<s:input id="txtdtMemberFromDate" name="dteGenration" path="dteGenration" 
				             			type="text" cssClass="calenderTextBox hasDatepicker" />	
				    		 </div>
				     		<div class="col-md-6">
								<label>Form Issue Date:</label><br>
									<s:input id="txtdtMemberToDate" name="dteFormIssue" class="calenderTextBox hasDatepicker" path="dteFormIssue" 
				            			type="text"/> 	
				    		</div>
						</div> 	
					</div>
					<div class="col-md-6">
						<div class="row">
							<div class="col-md-3">
								<label>Generate:</label>
									<input type=radio id="" name="print">
				    		 </div>
				     		<div class="col-md-3">
								<label>Print:</label><br>
									<input type=radio id="" name="print">	
				    		</div>
				    		<div class="col-md-6">
								<label>Business SourceCode:</label><br>
									<s:input id="txtBusinessSrcCode" path="strBusinessSourceCode" cssClass="searchTextBox" ondblclick="funHelp('webClubBusinessSrcCode')" />
				    		</div>
						</div> 	
					</div>
				</div>
	
	
				<div class="center">
					<a href="#"><button class="btn btn-primary center-block" value="Submit" onclick=""
						class="form_button">Submit</button></a>
					<a href="#"><button class="btn btn-primary center-block" type="reset"
						value="Reset" class="form_button" onclick="funResetField()" >Reset</button></a>
				</div>
		</s:form>
	</div>
	  --%>
	
	
	<div>
	<label id="formHeading" style="padding-left:55px;">Membership Form Generation</label>
	</div>
	<div>
	<s:form name="frmMembershipFormGenration" action="saveMembershipFormGenration.html?saddr=${urlHits}" method="POST" style="padding:0;">
		<br>
 			
		
		 <div class="container">
			<div class="row masterTable">
				<div class="col-md-6">
						<div class="row">
  				             <div class="col-sm-6"><label>Form No.</label><br><s:input type="text" id="txtFormNo" 
										name="txtFormNo" path="strFormNo" cssClass="searchTextBox" ondblclick="funHelp('WCMemberForm')" readonly="true" /> <s:errors path=""></s:errors></div>
							 <div class="col-sm-6"><label>Prospect Name</label><br><s:input type="text" id="txtProspectName" 
						name="txtProspectName" path="strProspectName" required="true"/> <s:errors path=""></s:errors></div>
				 		</div>
				 </div>
				 <div class="col-md-6"><label>Member Category Code</label><br>
						<div class="row">
				 			<div class="col-sm-6">					
				 			<s:input type="text" id="txtCategoryCode" path="strCategoryCode" cssClass="searchTextBox" ondblclick="funHelp('WCCatMaster')" readonly="true" required="true" style="border:none;padding:4px;" />
				 			
				 			</div>			            	
			            	<div class="col-sm-6"><input type="text" id="txtMCName" name="txtMCName" readonly="true"/> </div>
				 		</div>
				 </div>
				 <div class="col-md-6">
						<div class="row">
				 			<div class="col-sm-6"><label>Form Generation Date</label><br><s:input id="txtdtMemberFromDate" name="txtdtMemberFromDate" path="dteGenration"  cssClass="calenderTextBox" /></div>
				 			<div class="col-sm-6"><label>Form Issue Date</label><br><s:input id="txtdtMemberToDate" name="txtdtMemberToDate" path="dteFormIssue"  cssClass="calenderTextBox" /></div>
				 		</div>
				 </div>
				 <div class="col-md-6">
						<div class="row">		
							<div class="col-sm-6"><label>Generate</label><br><input type=radio id="" name="print" ></div>
				 			<div class="col-sm-6"><label>Print</label><br><input type=radio id="" name="print" ></div>
				 		</div>
				 </div>
				 <div class="col-sm-3"> <label>Business SourceCode</label><br><s:input id="txtBusinessSrcCode" path="strBusinessSourceCode" cssClass="searchTextBox" ondblclick="funHelp('webClubBusinessSrcCode')" readonly="true" />				
				        <label id ="lblBSName"></label></div>
			</div>	
		        <div class="center">
					<a href="#"><button class="btn btn-primary center-block" value="Submit" onclick=""
						class="form_button">Submit</button></a>
					<a href="#"><button class="btn btn-primary center-block" type="reset"
						value="Reset" class="form_button" onclick="funResetField()" >Reset</button></a>
				</div>
				 
			
		</div>			
		
	</s:form>
</div> 
	
</body>
</html>	