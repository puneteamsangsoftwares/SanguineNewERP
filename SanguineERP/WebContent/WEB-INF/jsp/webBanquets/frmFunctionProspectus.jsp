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

	function funSetData(code){

		switch(fieldName){

		case 'BillForBanquet' : 
			funSetFunctionProspectusCode(code);
			break;
		}
	}
	
	function funSetFunctionProspectusCode(code)
	{
		$("#txtBookingNo").val(code);	
	}
	
	function funValidateFields()
	{
		var flag=false;
		if($("#txtBookingNo").val().trim().length==0)
		{
			alert("Please Select Booking No.");
		}
		else
		{
			flag=true;
		}
		return flag;
	}

	function funHelp(transactionName)
	{
		fieldName=transactionName;
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
</script>

</head>
<body>

	<div class="container masterTable">
	<label id="formHeading">Function Prospectus</label>
	 <s:form name="FunctionProspectus" method="POST" action="rptFunctionProspectus.html">

		<div class="row">
          
			<div class="col-md-2"><label>Booking No</label>
				  <s:input type="text" path="strBookingNo" id="txtBookingNo" ondblclick="funHelp('BillForBanquet')" cssClass="searchTextBox jQKeyboard form-control" />
			</div>
		</div>
		
		<br />
		<p align="center" style="margin-right: 60%;">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" onclick="return funValidateFields(this)" />
			&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>

	</s:form>
	</div>
</body>
</html>
