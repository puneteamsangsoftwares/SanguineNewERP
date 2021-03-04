<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>
     <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

<script type="text/javascript">
	var fieldName;

	var clickCount =0.0;	
	function funCallFormAction(actionName,object) 
		{
			
			if ($("#txtUDCName").val()=="") 
			    {
				 alert('Enter UDC Name');
				 $("#txtUDCName").focus();
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
	$(function() 
	{
	});

	function funSetData(code)
	{

		switch(fieldName)
		{

			case 'UDCCode' : 
				funSetUDCCode(code);
				break;
		}
	}


	function funSetUDCCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadUDCCode.html?docCode=" + code,
			dataType : "json",
			success : function(response){ 
				$("#txtUDCCode").val(response.strUDCCode);
	        	$("#txtUDCName").val(response.strUDCName);
	        	$("#txtUDCDesc").val(response.strUDCDesc);	        	
			},
			error : function(e){

			}
		});
	}

	function funHelp(transactionName)
	{
		fieldName=transactionName;
	//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
</script>

</head>
<body>
   <div class="container masterTable">
    <label id="formHeading">UD Report Category Master</label>
	<s:form name="UDReportCategoryMaster" method="POST" action="saveUDReportCategoryMaster.html">
   
	       <div class="row">
				<div class="col-md-2"><label>UDC Code</label>
				       <s:input type="text" id="txtUDCCode" readonly="true" path="strUDCCode" cssClass="searchTextBox" ondblclick="funHelp('UDCCode');"/>
				</div>
			
			<div class="col-md-3"><label>UDC Name</label>
				      <s:input type="text" id="txtUDCName" path="strUDCName" cssStyle="text-transform: uppercase;"/>
			</div>
		    <div class="col-md-7"></div>
		    
			<div class="col-md-3"><label>UDC Desc</label>
				    <s:input type="text" id="txtUDCDesc" path="strUDCDesc" cssStyle="text-transform: uppercase;"/>
			</div>
		</div>
		
		<br />
		<p align="center" style="margin-right: 32%;">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block"  class="form_button" onclick="return funCallFormAction('submit',this);"/>
			&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block"  class="form_button" onclick="funResetFields()"/>
		</p>

	</s:form>
	</div>
</body>
</html>
