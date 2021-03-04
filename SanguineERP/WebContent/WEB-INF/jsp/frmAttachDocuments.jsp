<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=8"/>

	    <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />

		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
<title>Insert title here</title>
<script type="text/javascript">
	
	var deletedString="";
	
	function getContextPath() {
		return window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
	}	

	function deleteRow() {

		var table = document.getElementById("tblDoc");
		var rowCount = table.rows.length;
		if (rowCount > 0) {
			$('#tblDoc tr').each(function() {
				if ($(this).find('.del').is(":checked"))// `this` is TR DOM element
				{
					deletedString=deletedString+","+$(this).find('.del').val();
				}
			});
		}
		alert(deletedString);
	}
	
	
	function funDeleteRow(obj) 
	{
		var index = obj.parentNode.parentNode.rowIndex;
		var doc = document.getElementById('tblDoc');
		var value = $(doc.rows[index].cells[1]).text(); 
		funDeleteSelectedAttachment(value);
	}
	
	
	function funDeleteSelectedAttachment(name)
	{
		var code=$("#code").val();
		var searchUrl=getContextPath()+"/deleteAttachment.html?AttachmentName="+name+"&dcode="+code;
		$.ajax({
			type: "POST",
		    url: searchUrl,
			success: function(response)
			{	
				if(response){
			    	location.reload();
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
	
	
	
	
	
</script>

</head>
<body style="background:#d8d8d894;">
	<div class="container">
		<label id="formHeading" id="formName">Attached Documents</label>
			
		<s:form method="post" action="uploadFile.html" enctype="multipart/form-data">
			<input type="hidden" value="<c:out value="${transactionName}" />" name="transactionName">
		<div  class="row masterTable">
			<div class="col-md-12">
				<h5 style="color: #646777; text-align:center; padding:30px 0px;">${formTitle} - Attached Documents</h5>
			</div>
			<div class="col-md-3">		
				<label>Transaction</label><br>
				<input type="hidden" name="formName" id="formId" value="<c:out value="${formTitle}"/>" /> 
				<input type="hidden" name="test" value="<c:out value="${formTitle}"/>" /><c:out value="${formTitle}" />
			</div>
			<div class="col-md-3">	
				<label>Code</label><br>
				<input type="hidden" name="code" id="code" value="<c:out value="${docCode}"/>" /> <c:out value="${docCode}" />
			</div>
			<%-- <tr>
				 <td><s:label path="strActualFileName">Name</s:label></td>
				<td><s:input path="strActualFileName" /></td> 
			</tr> --%>
			<div class="col-md-3">			
				<s:label path="binContent">Document</s:label>
				<input type="file" name="file" id="file_upload"></input>
			</div>
			<div class="col-md-3">
				<input type="submit" value="Add Document" />
				<input type="text" id="txtEmailIds" style="margin-top:10px;"/>
				<!-- <td><input type="button" id="btnSendEmail" value="Send Email" onclick="funSendEmail();"/></td>  -->
			</div>
		</div>
	</s:form>

	<br />
	<!-- <h3 style="padding-left: 10%">Document List</h3> -->
	<c:if test="${!empty documentList}">
		<table id="tblDoc" class="masterTable" style="width:70%; background:#fbfafa;">
			<tr style="background-color:c0c0c0;">
				<th>Name</th>
				<th>Description</th>
				<th>Delete</th>
			</tr>
			<c:forEach items="${documentList}" var="doc" varStatus="i" >
				<tr>
					<td width="200px">${doc.strActualFileName}</td>
					<td><a
						href="${pageContext.request.contextPath}/download/${doc.strCode},${doc.intId}.html">${doc.strActualFileName}</a>

					</td>
					<td><input  class="deletebutton" class="delete" value="${doc.strActualFileName}" onclick="Javacsript:funDeleteRow(this)" ></td>
				</tr>
			</c:forEach>
		</table>
	</c:if>
<br><br>
</div>
</body>
</html>