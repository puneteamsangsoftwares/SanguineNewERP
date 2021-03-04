<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
	
	    <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />

		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
	
<link rel="stylesheet" type="text/css" href="default.css" />
<title>TC MASTER</title>
	<script type="text/javascript">
$(document).ready(function(){
	resetForms("tcmaster");
	$("#txtTCName").focus();
});

</script>
	<script type="text/javascript">
	
		function funHelp(transactionName)
		{	     
	       // window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	        window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	    }
		
		function funSetData(code)
		{	
			$.ajax({
			        type: "GET",
			        url: getContextPath()+"/loadTCData.html?tcCode="+code,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strTCCode=='Invalid Code')
			        	{
			        		alert("Invalid TC Code");
			        		$("#txtTCCode").val('');
			        	}
			        	else
			        	{
			        		$("#txtTCCode").val(response.strTCCode);
				        	$("#txtTCName").val(response.strTCName);
				        	if(response.strApplicable=='Y')
				        	{
				        		$("#chkApplicable").attr('checked', true);
				        	}
				        	else
				        	{
				        		$("#chkApplicable").attr('checked', false);
				        	}
				        	$("#txtMaxLength").val(response.intMaxLength);
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
		
		$(function()
		{
			$('a#baseUrl').click(function() 
			{
				if($("#txtTCCode").val().trim()=="")
				{
					alert("Please Select TC Code");
					return false;
				}

				 window.open('attachDoc.html?transName=frmTCMaster.jsp&formName=frmTCMaster.jsp&code='+$('#txtTCCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
			});
			
			$('#txtTCCode').blur(function() {				
					var code = $('#txtTCCode').val();
					if (code.trim().length > 0) {
						funSetData(code);
					}				
			});
		});
		
		function funOnLoad(){
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
		}
		
		function funCallFormAction(actionName,object) 
		{
			var flg=true;
			if($('#txtTCCode').val()=='')
			{
				var code = $('#txtTCName').val();
				 $.ajax({
				        type: "GET",
				        url: getContextPath()+"/checkTCName.html?TCName="+code,
				        async: false,
				        dataType: "text",
				        success: function(response)
				        {
				        	if(response=="true")
				        		{
				        			alert("Condition Name Already Exist!");
				        			$('#txtTCName').focus();
				        			flg= false;
					    		}
					    	else
					    		{
					    			flg=true;
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
			//alert("flg"+flg);
			return flg;
		}
	</script>

</head>
<body onload="funOnLoad();">
	<div class="container">
		<label id="formHeading">T C Master</label>
		<s:form name="tcmaster" method="POST" action="saveTCMaster.html?saddr=${urlHits}">
		
			<div class="row masterTable" >						
				<!--  <th  align="right" colspan="2"> <a id="baseUrl" href="#"> Attach Documents</a> &nbsp; &nbsp; &nbsp;
						&nbsp;</th> -->
			    <div class="col-md-2">
			    	<label>TC Code</label>
			        <s:input id="txtTCCode" path="strTCCode" readonly="true" ondblclick="funHelp('tc')"  cssClass="searchTextBox"/>
			   	</div>
			    <div class="col-md-2">
			        <label>TC Name</label>
			    	<s:input colspan="3" type="text" id="txtTCName" name="txtTCName" path="strTCName" required="true"/>		        	
			    </div>
			     <div class="col-md-8"></div>
			    <div class="col-md-2">
					<label>Applicable</label><br>
				 	<s:checkbox element="li" id="chkApplicable" path="strApplicable" value="true"/>			    	
				</div>
				<div class="col-md-2">
					<label>Max Length</label>
				  	<s:input colspan="3" id="txtMaxLength" name="txtMaxLength" path="intMaxLength" class="numeric"  />			    	
				</div>
			</div>
		
			<!-- <table  align="center">
				<tr>
			    	<td><input class="submitButton" type="submit" value="Submit" onclick="return funValidateFields()"/></td>
			    	<td><input class="submitButton" type="reset" value="Reset"  /></td>
		    	</tr>
			</table> -->
		
		<div class="center" style="margin-right: 69%;">
			<a href="#"><button class="btn btn-primary center-block"  value="Submit" onclick="return funCallFormAction('submit',this);"
				>Submit</button></a>
			<a href="#"><button class="btn btn-primary center-block" value="Reset" onclick=""
				>Reset</button></a>
		</div>
	</s:form>
</div>	
</body>
</html>