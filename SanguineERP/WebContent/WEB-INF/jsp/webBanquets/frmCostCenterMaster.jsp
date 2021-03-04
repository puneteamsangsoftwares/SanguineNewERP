<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>
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
	
	$("#txtOperational").attr('checked', true);

});
	
	function funValidate(data)
	{
		var flg=true;
		if($("#txtCostCenterName").val().trim().length==0)
			{
			alert("Please Select Name !!");
			 flg=false;
			}
		return flg;
	}
	
	function funSetData(code){

		switch(fieldName){

			case 'CostCenterCode' : 
				funSetCostCenterCode(code);
				break;
		}
	}


	function funSetCostCenterCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadCostCenterCode.html?docCode=" + code,
			dataType : "json",
			success : function(response){ 
				if(response.strCostCenterCode=='Invalid Code')
	        	{
	        		alert("Invalid Cost Center Code");
	        		$("#txtCostCenterCode").val('');
	        	}
	        	else
	        	{
	        		
	        		if(response.strOperational=='Y')
		        	{
		        		/* $("#txtOperational").attr('checked', true); */
		        		document.getElementById("txtOperational").checked = response.strOperational == 'Y' ? true: false;
		        	}
	        		else
		        	{
		        		$("#txtOperational").attr('checked', false);
		        		
		        	}
	        		$("#txtCostCenterName").val(response.strCostCenterName);
	        		$("#txtCostCenterCode").val(response.strCostCenterCode);
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
</script>

</head>
<body>

	<div class="container masterTable">
	<label id="formHeading">Cost Center Master</label>
	   <s:form name="CostCenterMaster" method="POST" action="saveCostCenterMaster.html">

		<div class="row">
          
				<div class="col-md-2"><label>Cost Center Code</label>
				       <s:input type="text" path="strCostCenterCode" id="txtCostCenterCode" ondblclick="funHelp('CostCenterCode')" cssClass="searchTextBox jQKeyboard form-control" />
				</div>
				
				<div class="col-md-2"><label>Cost Center Name</label>
				       <s:input type="text" path="strCostCenterName" id="txtCostCenterName"/>
				</div>
			    <div class="col-md-8"></div>
			    
			    <div class="col-md-2"><label>Operational</label><br>
				       <s:checkbox id="txtOperational" path="strOperational" value="Y"/>
			    </div>
			</div>
		
		
		<p align="center" style="margin-right:49%;">
			<input type="submit" value="Submit" tabindex="3" onclick="return funValidate(this)" class="btn btn-primary center-block" class="form_button" />
			&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>

	</s:form>
	</div>
</body>
</html>
