<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>
<script type="text/javascript">
	var fieldName;

	$(function() 
	{
	});

	function funSetData(code){

		switch(fieldName){

		}
	}





	function funHelp(transactionName)
	{
		fieldName=transactionName;
		window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
</script>

</head>
<body>

	<div class="container">
	<label id="formHeading">Weekend Master</label>
	
	<s:form name="BanquetWeekendMaster" method="POST" action="saveBanquetWeekendMaster.html">

		<div class="row masterTable">
		     <div class="col-md-12"><label>Days</label></div>
		   
			 <div class="col-md-2"><label>Sunday</label>
					<!-- <input type="checkbox" name="chkSunday" value="sunday">  -->
					<s:checkbox id="chkSunday" name="chkSunday" path="strSunday" value="Sunday" /> 
				
				</div>
				
				<div class="col-md-2"><label>Monday</label>
					<!-- <input type="checkbox" name="chkMonday" value="monday"> -->
					 <s:checkbox id="chkMonday" name="chkMonday" path="strMonday" value="Monday" /> 
				</div>
		
			    <div class="col-md-2"> <label>Tuesday</label>
					<!-- <input type="checkbox" name="chkTuesday" value="tuesday">  -->
					 <s:checkbox id="chkTuesday" name="chkTuesday" path="strTuesday" value="Tuesday" />
				</div>
				
				<div class="col-md-2"><label>Wednesday</label>
					<!-- <input type="checkbox" name="chkWednesday" value="wednesday">  -->
					 <s:checkbox id="chkWednesday" name="chkWednesday" path="strWednesday" value="Wednesday" />
				</div>
			    <div class="col-md-4"></div>
			    
			    <div class="col-md-2"><label>Thursday</label>
					<!-- <input type="checkbox" name="chkThursday" value="thursday">  -->
					 <s:checkbox id="chkThursday" name="chkSunday" path="strThursday" value="Thursday" />
				</div>
				
				<div class="col-md-2"><label>Friday</label>
					<!-- <input type="checkbox" name="chkFriday" value="friday">  -->
					  <s:checkbox id="chkFriday" name="chkFriday" path="strFriday" value="Friday" />
				</div>
				
			    <div class="col-md-2"><label>Saturday</label>
					<!-- <input type="checkbox" name="chkSaturday" value="saturday">  -->
					<s:checkbox id="chkSaturday" name="chkSaturday" path="strSaturday" value="Saturday" />
			    </div>
		    </div>

		<br />
		<br />
		<p align="center">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" />
			&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>

	</s:form>
	</div>
</body>
</html>
