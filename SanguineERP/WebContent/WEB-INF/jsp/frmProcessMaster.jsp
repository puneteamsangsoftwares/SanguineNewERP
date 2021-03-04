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
	
<title>Process Master</title>
<script type="text/javascript">
	var fieldName;
	var clickCount =0.0;	
	function funCallFormAction(actionName,object) 
		{
			
			if ($("#strProcessName").val()=="") 
			    {
				 alert('Enter Process Name');
				 $("#strProcessName").focus();
				 return false;  
			   
			}
		if(clickCount==0){
			clickCount=clickCount+1;
		}
			else
			{
				return false;
			}
			return true; 
		}

	
	/**
	* Open Help
	**/
	function funHelp(transactionName)
	{	       
       // window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
        window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
    }

	/**
	* Get and Set data from help file and load data Based on Selection Passing Value(Group Code)
	**/
	function funSetData(code)
	{
		$("#txtProcessCode").val(code);
		var searchurl=getContextPath()+"/loadProcessData1.html?processCode="+code;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strProcessCode=='Invalid Code')
			        	{
			        		alert("Invalid Process Code");
			        		$("#txtProcessCode").val('');
			        	}
			        	else
			        	{
				        	$("#txtProcessName").val(response.strProcessName);
				        	$("#txtDesc").val(response.strDesc);
				        	$("#txtProcessName").focus();
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
	* Reset The Process Name TextField
	**/
	function funResetFields()
	{
		$("#txtProcessCode").focus();
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
	
	
	 $(function()
				{
	
		/**
		* On Blur Event on TextField
		**/
		$('#txtProcessCode').blur(function() 
		{
				var code = $('#txtProcessCode').val();
				if (code.trim().length > 0 && code !="?" && code !="/")
				{				
					funSetData(code);							
				}
		});
		$('#txtProcessName').blur(function () {
			 var strProcessName=$('#txtProcessName').val();
		      var st = strProcessName.replace(/\s{2,}/g, ' ');
		      $('#txtProcessName').val(st);
			});
		
		
	
	 });
	
	 
</script>

</head>
<body>
	<div class="container">
		<label id="formHeading">ProcessMaster</label>
		<s:form name="ProcessMaster" method="POST" action="saveProcessMaster.html">
		
		<div class="row masterTable">
			<div class="col-md-2">
				<label>Process Code</label>
				<s:input id="txtProcessCode" path="strProcessCode" readonly="true"
					cssClass="searchTextBox" ondblclick="funHelp('processcode')" />
			</div>
			<div class="col-md-2">
				<label>Name</label>
				<s:input colspan="3" type="text" id="txtProcessName" 
						name="txtProcessName" path="strProcessName" required="true"/>
			</div>
			<div class="col-md-2">
				<label>Description</label>
				<s:input colspan="3" id="txtDesc" name="txtDesc"
						cssStyle="text-transform: uppercase;" path="strDesc" autocomplete="off" /> </td>
			</div>
		</div>
		<div class="center" style="margin-right: 51%;">
			<a href="#"><button class="btn btn-primary center-block" tabindex="3" value="submit" onclick="return funCallFormAction('submit',this);"
				>submit</button></a>
			<a href="#"><button class="btn btn-primary center-block" value="Reset" onclick="funResetFields()"
				>Reset</button></a>
		</div>
		
	</s:form>
</div>
</body>
</html>
