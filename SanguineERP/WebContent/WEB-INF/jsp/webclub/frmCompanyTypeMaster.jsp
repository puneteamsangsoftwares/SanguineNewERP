<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>
<meta http-equiv="X-UA-Compatible" content="IE=8">
	 	
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
	
});
	
	
	
	
	function funSetData(code){

		switch(fieldName){

		case 'WCCompanyTypeMaster' :
			funSetCompanyTypeData(code);
			break;
		}
	}


function funSetCompanyTypeData(code){

	$.ajax({
		type : "GET",
		url : getContextPath()+ "/loadWebClubCompanyTypeData.html?docCode=" + code,
		dataType : "json",
		success : function(response){ 

			if(response.strLocker=='Invalid Code')
        	{
        		alert("Invalid Company Type Code");
        		$("#textCompanyTypeCode").val('');
        	}
        	else
        	{      
	        	$("#textCompanyTypeCode").val(code);
	        	$("#textstrCompanyName").val(response.strCompanyName);
	        	$("#textAnnualTurnOver").val(response.strAnnualTurnOver);
	        	$("#textCapitalAndReserved").val(response.strCapitalAndReserved);
	      
	        	
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




function funResetFields()
{
	location.reload(true); 
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
	 <div class="container">
		<label id="formHeading">Company Type Master</label>
		<s:form name="WebClubCompanyTypeMaster" method="POST" action="saveWebClubCompanyTypeMaster.html">
		<div class="row masterTable">
			            <div class="col-md-2"><label>Company Type:</label><br>
						   <s:input id="textCompanyTypeCode" ondblclick="funHelp('WCCompanyTypeMaster')" cssClass="searchTextBox"  readonly="true"
							    type="text" required="true" path="strCompanyTypeCode" ></s:input>
						</div>
					
						<div class="col-md-2"><br>
						   <s:input id="textstrCompanyName" path="strCompanyName" required="true"
				              placeholder="Company Name" type="text" ></s:input>
						</div>
					    <div class="col-md-8"></div>
					    
					    <div class="col-md-2"><label>Min Annual TurnOvers:</label>
							<s:input id="textAnnualTurnOver" path="strAnnualTurnOver" required="true" type="text"></s:input>	
				       </div>
				    
				       <div class="col-md-2"><label>Min Capital & Reserved:</label>
						    <s:input id="textCapitalAndReserved" path="strCapitalAndReserved" required="true" type="text"></s:input>	
				       </div>
	   </div>
	   <br>
		<div align="center" style="margin-right:54%;">
			<a href="#"><button class="btn btn-primary center-block" tabindex="3" value="Submit" onclick=""
				class="form_button">Submit</button></a>&nbsp;
			<a href="#"><button class="btn btn-primary center-block" type="reset"
				value="Reset" class="form_button" onclick="funResetField()" >Reset</button></a>
		</div>
		
		</s:form>
	</div>
</body>
</html>
<%-- <br/>
<br/>

	<s:form name="WebClubCompanyTypeMaster" method="POST" action="saveWebClubCompanyTypeMaster.html">

		<table class="masterTable">
		<tr>    
		        <td width="100px">
		        <label>Company Type:</label></td>
		        <td width="20px"><s:input id="textCompanyTypeCode" path="strCompanyTypeCode" required=""
				              cssClass="searchTextBox" type="text" ondblclick="funHelp('WCCompanyTypeMaster')" ></s:input></td>
		       <td>
		       <s:input id="textstrCompanyName" path="strCompanyName" required=""
				            cssStyle="width:43% ;" cssClass="longTextBox" type="text" ></s:input></td>
		</tr>
		<tr>
		        <td width="160px">
		        <label>Minimum Annual TurnOvers:</label>
		        <td colspan="2"><s:input id="textAnnualTurnOver" path="strAnnualTurnOver" required=""
				            cssStyle="width:33% ;" cssClass="longTextBox" type="text" ></s:input>&nbsp;&nbsp;&nbsp;in cr</td>
	</tr>
	
		<tr>
		        <td width="180px">
		        <label>Minimum Capital and Reserved:</label>
		        <td colspan="2"><s:input id="textCapitalAndReserved" path="strCapitalAndReserved" required=""
				            cssStyle="width:33% ;" cssClass="longTextBox" type="text" ></s:input>&nbsp;&nbsp;&nbsp;in cr</td>
	</tr>
		</table>

		<br />
		<br />
		<p align="center">
			<input type="submit" value="Submit" tabindex="3" class="form_button" />
			<input type="reset" value="Reset" class="form_button" onclick="funResetFields()"/>
		</p>

	</s:form> --%>

