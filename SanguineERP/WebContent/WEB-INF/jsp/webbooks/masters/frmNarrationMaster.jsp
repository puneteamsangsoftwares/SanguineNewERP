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
	
	 $(function() {
			
			$('#txtRemarkCode').blur(function() {
				var code = $('#txtRemarkCode').val();
				if(code.trim().length > 0 && code !="?" && code !="/")
				{
					funSetRemarkData(code);
				}
			});
			
		
		});
	
	
	function funSetRemarkData(remarkCode)
	 {
	     $("#txtRemarkCode").val(remarkCode);
			var searchurl=getContextPath()+"/loadNarrationMasterData.html?remarkCode="+remarkCode;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strRemarkCode=='Invalid Code')
				        	{
				        		alert("Invalid Remark Code");
				        		$("#txtRemarkCode").val('');
				        		$("#txtDescription").val('');
				        	}
				        	else
				        	{
					        	$("#txtDescription").val(response.strDescription);
					        	$("#txtDescription").focus();		
					        	if(response.strActiveYN=="Yes")
					            {
					        	    $("#chkActiveYN").prop('checked',true);	
					        	    $("#chkActiveYN").val("Yes");
					        	}
					        	else
					        	{
					        	    $("#chkActiveYN").prop('checked',false);
					        	    $("#chkActiveYN").val("No");
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

	function funSetData(code){

		switch(fieldName)
		{		
			case "remarkCode":
			    funSetRemarkData(code);			    
				 break;
		}
	}

	function funHelp(transactionName)
	{
		fieldName=transactionName;
	//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
	function funSetActiveYN()
	{
	    var activeYN="No";
	    if($("#chkActiveYN").prop("checked") == true)
	    {           
	        activeYN="Yes";
        }
	    if($("#chkActiveYN").prop("checked") == false)
        {         
	        activeYN="No";
        }
	    $("#chkActiveYN").val(activeYN);	
	    	   
	}
</script>

</head>
<body>
	<div class="container">
		<label id="formHeading">Remark Master</label>
			<s:form name="BankMaster" method="POST" action="saveNarrationMaster.html">
				<div class="row masterTable">
						<div class="col-md-2"><label >Remark Code</label>
							<s:input id="txtRemarkCode"  ondblclick="funHelp('remarkCode')" cssClass="searchTextBox" style="height:50%"
							  readOnly="true" type="text" path="strRemarkCode"></s:input>
						</div>
						
						<div class="col-md-4"><label >Description</label>
						<s:input id="txtDescription" path="strDescription" 
							 type="text" required="true"></s:input>
						</div>
						<div class="col-md-1"><label >Active</label><br>
						<s:checkbox id="chkActiveYN"  path="strActiveYN" value=""  onclick="funSetActiveYN()"  />
						</div>
				</div>
				<div class="center" style="margin-right: 46%;">
				<a href="#"><button class="btn btn-primary center-block" tabindex="3" onclick=""
					class="form_button">Submit</button></a>&nbsp
				<a href="#"><button class="btn btn-primary center-block" type="reset"
					value="Reset" class="form_button" onclick="funResetField()" >Reset</button></a>
			</div>
		</s:form>
	</div>

</body>
</html>
