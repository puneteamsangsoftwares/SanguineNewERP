<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta http-equiv="X-UA-Compatible" content="IE=8">
<title></title>
		<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 	
	 	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

		<spring:url value="/resources/css/jquery.classyedit.css" var="classyEditCSS" />
		<spring:url value="/resources/js/jquery.classyedit.js" var="classyEditJS" />
	
<link href="${classyEditCSS}" rel="stylesheet" />
<script src="${classyEditJS}"></script>    


<style type="text/css">
	#divFieldSelection
	{
		 width:300px;
		 height: 300px;	
		 background-color: white;
		 overflow: scroll;		 
	}
	#divCriteriaConainer 
	{
		width: 488px; 
		height: 300px;
		background-color: white;		
	}	
	#divFieldSelection  a:link
	{
    	color: #0000FF;
    	text-decoration: none;
	}
</style>

<script type="text/javascript">
	var fieldName;
	

	$(document).ready(function()
	{
		$(".classy-editor").ClassyEdit();
	});
	
	/* when Enter key is press on textArea */
	$(document).ready(function()
	{
		$("#txtArea").keypress(function(event)
		{ 
		    var keyCode = event.keyCode;   
		    if(keyCode==13)
		    {
		    	var strCriteria=$("#txtArea").val();	
		    	$("#txtArea").val(strCriteria+"\n");
		    }	
		});
	});
	
	/* To add selected field to text criteria */
	function funCriteriaFieldSelected(selectedField)
	{
	    var a=$(selectedField).text();	   	    
	    var strCriteria=$("#txtArea").val();	    
	    $("#txtArea").val(strCriteria+" {"+a+"}");
	}
	
	/* To Set Letter Data */
	function funSetLetterData(letterCode)
	{		
		var searchurl=getContextPath()+"/loadLetterMasterData.html?letterCode="+letterCode;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strLetterCode=='Invalid Code')
			        	{
			        		alert("Invalid Letter Code");
			        		$("#txtLetterCode").val('');
			        		$("#txtLetterName").val('');
			        	}
			        	else
			        	{
			        		$("#txtLetterCode").val(response.strLetterCode);
				        	$("#txtLetterName").val(response.strLetterName);
				        	$("#txtLetterName").focus();
				        	if(response.strReminderYN.toUpperCase()=="Y")				        		
				        	{
				        		$("#chkReminderLetter").prop('checked',true);
				        		$("#chkReminderLetter").val("Y");
				        	}
				        	else
				        	{
				        		$("#chkReminderLetter").prop('checked',false);
				        		$("#chkReminderLetter").val("N");	
				        	}
				        	$("#cmbReminderLetter").val(response.strReminderLetter);
				        	if(response.strIsCircular.toUpperCase()=="Y")				        		
				        	{
				        		$("#chkIsCircular").prop('checked',true);
				        		$("#chkIsCircular").val("Y");
				        	}
				        	else
				        	{
				        		$("#chkIsCircular").prop('checked',false);
				        		$("#chkIsCircular").val("N");	
				        	}
				        	$("#cmbLetterProcessOn").val(response.strView);
				        	$("#txtArea").val(response.strArea);
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

	/* To Set CheckBox Value To Y/N */
	function funSetCheckBoxValueYN(currentCheckBox)
	{			    
	    if($(currentCheckBox).prop("checked") == true)
	    {           
	    	$(currentCheckBox).val("Y");	
        }
	    if($(currentCheckBox).prop("checked") == false)
        {         
	    	$(currentCheckBox).val("N");	
        }	    	    
	}	
	
	/**
	* Success Message After Saving Record
	**/
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

	
	 $(function() {
			
			$('#txtLetterCode').blur(function() {
				var code = $('#txtLetterCode').val();
				if(code.trim().length > 0 && code !="?" && code !="/")
				{
					funSetLetterData(code);
				}
			});

		});
	 
	function funSetData(code)
	{
		switch(fieldName)
		{
			case "letterCode":
				funSetLetterData(code);
				break;
		}
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
		<label id="formHeading">Letter Master</label>
			<s:form name="LetterMaster" method="POST" action="saveLetterMaster.html">
				<div class="row masterTable">
					<div class="col-md-6">
						<label>Letter Code:</label>
						<div class="row">
							<div class="col-md-5"><s:input id="txtLetterCode" ondblclick="funHelp('letterCode')" cssClass="searchTextBox"
								 placeholder="Letter Code" readonly="true" type="text" path="strLetterCode"></s:input>
							</div>
						
							<div class="col-md-7"><s:input id="txtLetterName" path="strLetterName" required="true"
								 placeholder="Letter Name" type="text"></s:input>
							</div>
						</div>
					</div>
					
					<div class="col-md-6"></div>
					
					<div class="col-md-3">
						<label>Reminder Letter:</label>
						<div class="row">
							<div class="col-md-6"><s:checkbox id="chkReminderLetter" path="strReminderYN" value="N" onclick="funSetCheckBoxValueYN(this)"/>
							</div>
							<div class="col-md-6"><s:select id="cmbReminderLetter" path="strReminderLetter" items="${listReminderLetter}" cssClass="BoxW124px" />
							</div>
							
						</div>
					</div>
					
					<div class="col-md-2"><label>Circular/Notice Letter</label><br>
									<s:checkbox id="chkIsCircular" path="strIsCircular" value="N" onclick="funSetCheckBoxValueYN(this)"/>
							</div>
							
					<div class="col-md-2.1">
							<label>Letter Process On</label>
								<s:select id="cmbLetterProcessOn" path="strView" items="${listLetterProcessOn}" cssClass="BoxW200px" />
							</div>
						
				</div>
				<br>
				<div id="divFieldSelectionAndDesigning">
		        	<table class="masterTable">
		        		<tr>
		        			<td style="padding-left: 0px;  width: 300px; height: 0px;">
								<div id="divFieldSelection">
									<c:forEach var="fieldCriteria" items="${listVMemberDebtorDtlColumnNames}">
										<a href="#" class="fieldCriteriaLink" ondblclick='funCriteriaFieldSelected(this)'>${fieldCriteria}</a><br>
								    </c:forEach>
								</div>
							</td>  
							<td></td>  
							<td style="width: 488px;">
								<div id="divViewConainer" >
									<s:textarea id="txtArea" path="strArea" style="width: 485px; height: 300px; resize: none;" />					    						
								</div>
							</td>         			
		        		</tr>             				
		        	</table>
		        </div>			<br />
			<br />
			<div class="center" style="margin-right:27%">
				<a href="#"><button class="btn btn-primary center-block" tabindex="3" onclick=""
					class="form_button">Submit</button></a>&nbsp
				<a href="#"><button class="btn btn-primary center-block" type="reset"
					value="Reset" class="form_button" onclick="funResetField()">Reset</button></a>
			</div> 
	</s:form> 
	</div>
</body>
</html>
