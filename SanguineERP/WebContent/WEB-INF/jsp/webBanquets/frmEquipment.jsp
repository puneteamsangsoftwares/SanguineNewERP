<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>
<%--      <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" /> 
	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script> --%>

<script type="text/javascript">
	var fieldName;

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

	$("#strOperational").attr('checked', true);
});

	function funValidate(data)
	{
		var flg=true;
		if($("#txtEquipmentName").val().trim().length==0)
			{
			alert("Please Select Name !!");
			 flg=false;
			 $("#txtEquipmentName").focus();
			}
		
		if($("#txtDepartmentCode").val().trim().length==0)
		{
		alert("Please Select Department Code !!");
		 flg=false;
		 $("#txtDepartmentCode").focus();
		}
		return flg;
	}
	
	function funSetData(code){

		switch(fieldName){

			case 'equipmentCode' : 
				funSetEquipmentName(code);
				break;
				
			case 'deptCode' : 
				funSetDepartmentCode(code);
				break;
		}
	}



	function funSetEquipmentName(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadEquipmentName.html?docCode=" + code,
			dataType : "json",
			success : function(response){ 

				if(response.strEquipmentCode=='Invalid Code')
	        	{
	        		alert("Invalid Equipment No");
	        		$("#txtEquipmentCode").val('');
	        	}
	        	else
	        	{
	        		if(response.strOperational=='Y')
		        	{
		        		document.getElementById("strOperational").checked = response.strOperational == 'Y' ? true: false;
		        	}
	        		else
		        	{
		        		$("#strOperational").attr('checked', false);
		        		
		        	}
	        		$("#txtEquipmentName").val(response.strEquipmentName);
	        		$("#txtEquipmentCode").val(response.strEquipmentCode);
	        		$("#txtDepartmentCode").val(response.strDeptCode);
	        		$("#dblEquipmentRate").val(response.dblEquipmentRate);
	        		$("#cmbTaxIndicator").val(response.strTaxIndicator);
	        	}
			},
			error : function(e){

			}
		});
	}
	function funSetDepartmentCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadDepartmentCode.html?deptCode=" + code,
			dataType : "json",
			success : function(response){ 

				if(response.strDeptCode=='Invalid Code')
	        	{
	        		alert("Invalid Department Code");
	        		$("#txtDepartmentCode").val('');
	        	}
	        	else
	        	{
	        	
	        		$("#txtDepartmentCode").val(response.strDeptCode);
	        	}
			},
			error : function(e){

			}
		});
	}


	function funHelp(transactionName)
	{
		fieldName=transactionName;
		window.open("searchform.html?formname="+fieldName+"&searchText=", 'window', 'width=600,height=600');
	}
	
	function isNumber(evt) {
        var iKeyCode = (evt.which) ? evt.which : evt.keyCode
        if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57))
            return false;

        return true;
    }  
</script>

</head>
<body>

	<div class="container masterTable">
	<label id="formHeading">Equipment Master</label>
      <s:form name="Equipment" method="POST" action="saveEquipment.html">

		 <div class="row">
          
				<div class="col-md-2"><label>Equipment Code</label>
				       <s:input type="text" id="txtEquipmentCode" path="strEquipmentCode" ondblclick="funHelp('equipmentCode')" cssClass="searchTextBox jQKeyboard form-control" style="height: 50%;"/>
				</div>
		
			     <div class="col-md-2"><label>Equipment Name</label>
				       <s:input type="text" path=""  id="txtEquipmentName"/><!--  path="strEquipmentName" -->
				</div>
				
				<div class="col-md-1"><label style="width:150%;">Equipment Rate</label>
				       <s:input type="text" value="0" path="dblEquipmentRate" id="dblEquipmentRate" style="text-align:right;height:50%;" onkeypress="javascript:return isNumber(event)" /> 
				</div>
				<div class="col-md-7"></div>
				
				<div class="col-md-2"><label>Department Code</label>
				      <s:input type="text" id="txtDepartmentCode" path="strDeptCode" ondblclick="funHelp('deptCode')" cssClass="searchTextBox jQKeyboard form-control" style="height: 50%;"/>
				</div>
			
			    <div class="col-md-1"><label style="width:120%;">Tax Indicator</label>
				       <s:select id="cmbTaxIndicator" name="taxIndicator" path="strTaxIndicator" items="${taxIndicatorList}"/>
			    </div>
			    
			    <div class="col-md-1"><label>Operational</label><br>
				      <s:checkbox id="strOperational" path="strOperational" value="Y"/>
			    </div>
		</div>

		<p align="center" style="margin-right: 32%;">
			<input type="submit" value="Submit" tabindex="3" onclick="return funValidate(this)" class="btn btn-primary center-block" class="form_button" />
			&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="return funResetFields()"/>
		</p>

	</s:form>
	</div>
</body>
</html>
