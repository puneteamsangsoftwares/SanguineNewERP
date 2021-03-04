<%-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> --%>
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
	
});
	
	function funResetFields()
	{
		location.reload(true); 
	}
	
		function funSetData(code){

		switch(fieldName){

		case 'WCLockerMaster' :
			funSetLockerData(code);
			break;
		}
	}


function funSetLockerData(code){

	$.ajax({
		type : "GET",
		url : getContextPath()+ "/loadWebClubLockerData.html?docCode=" + code,
		dataType : "json",
		success : function(response){ 

			if(response.strLockerCode=='Invalid Code')
        	{
        		alert("Invalid Locker Code");
        		$("#txtLockerCode").val('');
        	}
        	else
        	{      
	        	$("#txtLockerCode").val(code);
	        	$("#textLockerName").val(response.strLockerName);
	        	$("#txtLockerDesc").val(response.strLockerDesc);
	        	
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
		<label  id="formHeading">Locker Master</label>
			<s:form name="WebClubLockerMaster" method="POST" action="saveWebClubLockerMaster.html">
				<div class="row masterTable">
					     <div class="col-md-2"><label>Locker Code:</label><br>
							    <s:input id="txtLockerCode" type="text"  path="strLockerCode" readonly="true" 
				                   cssClass="searchTextBox" ondblclick="funHelp('WCLockerMaster')" ></s:input>
						 </div>
						 
						 <div class="col-md-2"><br>
								<s:input id="textLockerName" path="strLockerName" required="" type="text" placeholder="Locker Name"></s:input>
						  </div>
			             <div class="col-md-8"></div>
			             
			            <div class="col-md-3"><label>Locker Description:</label><br>
							<s:input id="txtLockerDesc" path="strLockerDesc" required=""
				             type="text"></s:input>
				     </div>	
				</div>
					<div align="center" style="margin-right:54%;">
						<a href="#"><button class="btn btn-primary center-block" value="Submit" onclick=""
							class="form_button">Submit</button></a>&nbsp;
						<a href="#"><button class="btn btn-primary center-block" type="reset"
						 value="Reset" class="form_button" onclick="funResetField()" >Reset</button></a>
					</div>
			</s:form>
	</div>

</body>
</html>

	<%-- <s:form name="WebClubLockerMaster" method="POST" action="saveWebClubLockerMaster.html">

		<table class="masterTable">
		
			<tr>    
		        <td width="100px">
		        <label>Locker Code</label></td>
		        <td width="20px"><s:input id="txtLockerCode" path="strLockerCode" required=""
				              cssClass="searchTextBox" type="text" ondblclick="funHelp('WCLockerMaster')" ></s:input></td>
		       <td>
		       <s:input id="textLockerName" path="strLockerName" required=""
				            cssStyle="width:36% ;" cssClass="longTextBox" type="text" ></s:input></td>
		</tr>
		<tr>
		        <td width="160px">
		        <label>Locker Description</label>
		        <td colspan="2"><s:input id="txtLockerDesc" path="strLockerDesc" required=""
				            cssStyle="width:50% ;" cssClass="longTextBox" type="text" ></s:input></td>
	</tr>
		
		
		</table>

		<br />
		<br />
		<p align="center">
			<input type="submit" value="Submit" tabindex="3" class="form_button" />
			<input type="reset" value="Reset" class="form_button" onclick="funResetFields()"/>
		</p>

	</s:form> --%>

