<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<meta http-equiv="X-UA-Compatible" content="IE=8">

		<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 
	 	 
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

<title>ATTRIBUTE VALUE MASTER</title>
	
<script type="text/javascript">
$(document).ready(function(){
	 resetForms('frmAttrValMaster');
	   $("#txtAttValueName").focus();	
});
</script>	
	<script type="text/javascript">
	
		var fieldName;
		
		function funResetFields()
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
         
            $("#txtAttValueName").focus();
			$("#lblAttName").text("");
	    }
		
	
		function funHelp(transactionName)
		{
			fieldName=transactionName;	    
	        //window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	    	window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
		}
		
		function funSetAttVal(code)
		{
			$("#txtAttValueCode").val(code);
			var gurl=getContextPath()+"/loadAttributeValueMasterData.html?attValueCode=";
			$.ajax({
			        type: "GET",
			        url: gurl+code,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strAVCode=='Invalid Code')
			        	{
			        		alert("Invalid Att Value Code");
			        		$("#txtAttValueCode").val('');
			        	}
			        	else
			        	{
				        	$("#txtAttValueName").val(response.strAVName);
				        	$("#txtAttValueDesc").val(response.strAVDesc);
				        	funSetAttribute(response.strAttCode);
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
		
		function funSetAttribute(code)
		{
			$("#txtAttCode").val(code);
			var gurl=getContextPath()+"/loadAttributeMasterData.html?attCode=";
			$.ajax({
		        type: "GET",
		        url: gurl+code,
		        dataType: "json",
		        success: function(response)
		        {
		        	$("#txtAttCode").val(response.strAttCode);
		        	$("#lblAttName").text(response.strAttName);
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
		
		function funSetData(code)
		{
			switch (fieldName) 
			{
			   case 'attributevaluemaster':
			    	funSetAttVal(code);
			        break;
			   
			   case 'attributemaster':
			    	funSetAttribute(code);
			        break;
			}
		}
		
		$(function()
		{
			$("#txtAttValueName").focus();			
				    
			$('a#baseUrl').click(function() 
			{  
				if($("#txtAttValueCode").val().trim()=="")
				{
					alert("Please Select Attribute Value Code");
					return false;
					 
					
				}
				window.open('attachDoc.html?transName=frmAttributeValueMaster.jsp&formName=Attribute Value Master&code='+$('#txtAttValueCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
			  //	$(this).attr('target', '_blank');
			});
			
			
		$('#txtAttValueCode').keydown(function(e) {
					var code = $('#txtAttValueCode').val();
					if (code.trim().length > 0 && code !="?" && code !="/"){
						funSetAttVal(code);
					}
				
			});

		});
	</script>
	
</head>
<body onload="funResetFields()">
	<div class="container">
		<label id="formHeading">Attribute Value Master</label>
		<s:form name="frmAttrValMaster" method="POST" action="saveAttributeValueMaster.html?saddr=${urlHits}">
		
		<div class="row masterTable">
		 <!--  <a id="baseUrl" href="#"> Attach Documents </a> &nbsp; &nbsp; &nbsp; -->
			<div class="col-md-2">
		    	<label>Attribute Value Code</label>
		        <s:input id="txtAttValueCode" name="txtAttValueCode" path="strAVCode" ondblclick="funHelp('attributevaluemaster')"  cssClass="searchTextBox"/>
		    </div>
		    <div class="col-md-2">
		  		<label>Name</label>
		        <s:input type="text" id="txtAttValueName" size="80px" name="txtAttValueName" path="strAVName" required="true"/>
		        <s:errors path="strAVName"></s:errors>
		     </div>
		     <div class="col-md-2">
			  	<label>Description</label>
		        <s:input id="txtAttValueDesc"  name="txtAttValueDesc" path="strAVDesc"/>
		     </div>
		     <div class="col-md-6"></div>
		     <div class="col-md-2">
			   	<label>Attribute code</label>
			  	<s:input typr="text" id="txtAttCode" name="txtAttCode" path="strAttCode" ondblclick="funHelp('attributemaster')" required="true" cssClass="searchTextBox"/>
			    <s:errors path="strAttCode"></s:errors>
			 </div>
			 <div class="col-md-2">
			   	<label id="lblAttName" style="background-color:#dcdada94; width: 100%; height: 52%; margin-top: 26px; text-align:   center;"
			   	></label>
			  </div> 
			
		</div>
		
		<div class="center" style="margin-right:51%;">
			<a href="#"><button class="btn btn-primary center-block" value="Submit" onclick="return funValidateFields()"
				class="form_button">Submit</button></a>&nbsp;
			<a href="#"><button class="btn btn-primary center-block" id="reset" value="Reset" onclick="funResetFields()"
				class="form_button">Reset</button></a>
		</div>
	</s:form>
</div>
</body>
</html>