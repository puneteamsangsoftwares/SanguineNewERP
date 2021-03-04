<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>ATTRIBUTE VALUE MASTER</title>
     <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

<script type="text/javascript">
$(document).ready(function(){
	 resetForms('attributemasterForm');
	   $("#txtAttName").focus();	
});
</script>
	<script type="text/javascript">
	
		var fieldName;
		
		
		var clickCount =0.0;	
		function funCallFormAction(actionName,object) 
			{
				
				if ($("#txtAttName").val()=="") 
				    {
					 alert('Enter Attribute Name');
					 $("#txtAttName").focus();
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
		function funResetFields()
		{
			
			$("#txtAttName").focus();
			$("#lblParentAttName").text("");
		}
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
		        	if(response.strAttCode=='Invalid Code')
		        	{
		        		alert("Invalid Att Value Code");
		        		$("#txtAttCode").val('');
		        		$("#txtAttName").focus();
		        	}
		        	else
		        	{
		        		$("#txtAttName").val(response.strAttName);
		        		$("#cmbAttType").val(response.strAttType);
		        		$("#txtAttDesc").val(response.strAttDesc);
		        		if(!response.strPAttCode=='')
		        		{
		        			funSetParentAttribute(response.strPAttCode);	
		        		}
		        		 $("#txtAttName").focus();	
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
		
		function funSetParentAttribute(code)
		{
			var gurl=getContextPath()+"/loadAttributeMasterData.html?attCode=";
			$.ajax({
		        type: "GET",
		        url: gurl+code,
		        dataType: "json",
		        success: function(response)
		        {
		        	$("#txtPAttCode").val(response.strAttCode);
		        	$("#lblParentAttName").text(response.strAttName);
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
		
		
		
		function funHelp(transactionName)
		{
			fieldName=transactionName;
	       // window.showModalDialog("searchform.html?formname=attributemaster&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	         window.open("searchform.html?formname=attributemaster&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	    } 
		
		
		function funSetData(code)
		{
			switch (fieldName) 
			{
			   case 'attributemaster':
			    	funSetAttribute(code);
			        break;
			        
			   case 'parentattr':
				   funSetParentAttribute(code);
				   break;
			}
		}
			
		
		$(function()
		{
			$('a#baseUrl').click(function() 
			{
				if($("#txtAttCode").val()=="")
				{
					alert("Please Select Attribute Code");
					return false;
				}
				
				//window.open('attachDoc.html?transName=frmAttributeMaster.jsp&formName=Attribute Master&code='+$("#txtAttCode").val(),"","Height:600px;Width:800px;Left:300px;");
				window.open('attachDoc.html?transName=frmAttributeMaster.jsp&formName=Attribute Master&code='+$("#txtAttCode").val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
			    //$(this).attr('target', '_blank');
			});
			$('#txtAttCode').blur(function () {
				 var code=$('#txtAttCode').val();
				 if(code.trim().length > 0 && code !="?" && code !="/"){
				       	  funSetAttribute(code);  
				      }				   
				});
		});
	</script>

</head>
<body onload="funResetFields()">
   <div class="container masterTable">
		<label id="formHeading" id="formName">Attribute Master</label>
	<s:form name="attributemasterForm" method="POST" id="frmAttributeMaster.jsp" action="saveAttributeMaster.html?saddr=${urlHits}">
	
		<!--  <a id="baseUrl" href="#"> Attach Documents</a> -->
		  <div class="row">
		    <div class="col-md-2"><label>Attribute Code</label>
		           <s:input id="txtAttCode" name="txtAttCode"  readonly="true" path="strAttCode" ondblclick="funHelp('attributemaster')" cssClass="searchTextBox"/>
		    </div>
		    	
		    <div class="col-md-2"><label>Name</label>
		       <s:input type="text" id="txtAttName" name="txtAttName" path="strAttName" required="true"/>
		        	<s:errors path="strAttName"></s:errors>
		    </div>
			    
		   <div class="col-md-1"><label style="width: 135%;">Attribute Type</label>
			    <s:select id="cmbAttType" name="cmbAttType" path="strAttType" items="${listAttType}" style="width: auto;"/>			    	
			    	<s:errors path="strAttType"></s:errors>
			</div>
			 <div class="col-md-7"></div> 
			   
		    <div class="col-md-2"><label>Description</label>
		          <s:input id="txtAttDesc" name="txtAttDesc" path="strAttDesc"/>
			</div>
			
			<div class="col-md-2"><label>Parent Attribute Code</label>
		          <s:input id="txtPAttCode" name="txtPAttCode" readonly="true" path="strPAttCode" cssClass="searchTextBox" ondblclick="funHelp('parentattr')"/>
		     </div>   	
		     <div class="col-md-2">
		           <label id="lblParentAttName"></label>
		    </div>
	      </div>
		<br />
		
		<p align="center" style=" margin-right: 31%;">
			<input type="submit" value="Submit" class="btn btn-primary center-block" class="form_button"onclick="return funCallFormAction('submit',this);" /> 
			&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>
		
	</s:form>
	</div>
</body>
</html>