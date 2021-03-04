<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
	
});
	
	
function funSetData(code){

		switch(fieldName){

		case 'WCSubCategoryMaster' :
			funSetSubCategoryData(code);
			break;
		}
	}
	
function funResetFields()
{
	location.reload(true); 
}


function funSetSubCategoryData(code){

	$.ajax({
		type : "GET",
		url : getContextPath()+ "/loadWebClubSubCategoryData.html?docCode=" + code,
		dataType : "json",
		success : function(response){ 

			if(response.strSCCode=='Invalid Code')
        	{
        		alert("Invalid Company Code");
        		$("#txtCompanyCode").val('');
        	}
        	else
        	{      
	        	$("#txtSCCode").val(code);
	        	$("#textSCName").val(response.strSCName);
	        	$("#txtSCDesc").val(response.strSCDesc);
	      
	        	
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
			<label id="formHeading">Sub Category Master</label>
			<s:form name="SubCategoryMaster" method="POST" action="saveSubCategoryMaster.html">
				<div class="row masterTable">
					
						<div class="col-md-2"><label style="width:110%;">Member Sub Category Code:</label>
							 <s:input id="txtSCCode" ondblclick="funHelp('WCSubCategoryMaster')" cssClass="searchTextBox" readonly="true" type="text" path="strSCCode" ></s:input>
						</div>
					
						<div class="col-md-2"><br>
						    <s:input id="textSCName" path="strSCName" required="" placeholder="Member Sub Category Name" type="text" ></s:input>
						</div>
						<div class="col-md-8"></div>
						
						<div class="col-md-3"><label>MemberShip Class Description:</label><br>
							<s:input id="txtSCDesc" path="strSCDesc" type="text"></s:input>
						</div>
				</div>
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

	
