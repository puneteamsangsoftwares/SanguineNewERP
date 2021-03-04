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
	
<title>Excise Master</title>
</head>
<script type="text/javascript">


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
	
	function funSetData(code)
	{
		switch (fieldName) 
		{
		   
		   case 'subgroupExcisable':
			   $("#txtsubGroup").val(code);
		        break;
		        
		   case 'exciseDuty':
			   funSetExciseData(code);
		        break;
		   
		}
		
	}
			
		
		


function funSetExciseData(code)
{
	$("#txtGroupCode").val(code);
	var searchurl=getContextPath()+"/loadExciseMasterData.html?exciseCode="+code;
	 $.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        success: function(response)
		        {
		        	if(response.strExciseCode=='Invalid Code')
		        	{
		        		alert("Invalid Group Code");
		        		$("#txtExciseCode").val('');
		        	}
		        	else
		        	{
		        		$("#txtExciseCode").val(response.strExciseCode);
		        		$("#txtDescription").val(response.strDesc);
		        		$("#txtExciseChapterNo").val(response.strExciseChapterNo);
		        		$("#txtsubGroup").val(response.strSGCode);
		        		$("#txtExcisePer").val(response.dblExcisePercent);
		        		
		        	if(response.strCessTax=='Y')
			    	{
			    		document.getElementById("chkCessTax").checked=true;
			    	}
			    	else
			    	{
			    		document.getElementById("chkCessTax").checked=false;
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

</script>
<body >
	<div class="container">
		<label  id="formHeading">Excise Master</label>
		<s:form name="frmExciseMaster" method="GET" action="saveExciseMaster.html?saddr=${urlHits}">
		
		<div class="row masterTable">
			<div class="col-md-2">
				<label>ExciseCode Code</label>
				<s:input id="txtExciseCode" path="strExciseCode"
						cssClass="searchTextBox" ondblclick="funHelp('exciseDuty')" readOnly="true" />
			</div>
			<div class="col-md-2">
				<label>Description</label>
				<s:input type="text" id="txtDesc" name="txtDescription" path="strDesc" 
						cssStyle="text-transform: uppercase;" />
			</div>
			<div class="col-md-2">
				<label>Excise Chapter No.</label>
				<s:input  type="text" id="txtGroupName" 
						name="txtExciseChapterNo" path="strExciseChapterNo" required="true"
						cssStyle="text-transform: uppercase;" /> 
			</div>
			<div class="col-md-6"></div>
			<div class="col-md-2">
				<label>Sub Group code</label>
				<s:input  id="txtsubGroup" cssClass="searchTextBox" path="strSGCode"   ondblclick="funHelp('subgroupExcisable')" readOnly="true" />
			</div>
			<div class="col-md-2">
				<label>Excise Percentage</label>
				<s:input colspan="3" id="txtExcisePer" name="txtExcisePer"
						cssStyle="text-transform: uppercase;" path="dblExcisePercent"/> 
			</div>
			<div class="col-md-2">
			<label>Cess Tax</label><br>
				<s:checkbox  id="chkCessTax" path="strCessTax" value="" />
			</div>
			<div class="col-md-6"></div>
			<div class="col-md-2">
				<label>Category Sequence</label>
				<s:input colspan="3" id="txtRank" name="txtRank"
						cssStyle="text-transform: uppercase;" path="strRank"  />
			</div>
		</div>
		<div class="center" style="margin-right: 52%;">
				<a href="#"><button class="btn btn-primary center-block" tabindex="3" value="Submit" onclick="return funCallFormAction('submit',this);" 
				>Submit</button></a>
				<a href="#"><button class="btn btn-primary center-block"  value="reset" onclick="funResetFields()"
				>Reset</button></a>
		</div>
	</s:form>
</div>
</body>
</html>