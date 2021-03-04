<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
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

<body style="height: 100%">
 <div style="width: 100%;height: 100%;background-color:#f2f2f2">
<div id="formHeading">
		<label id="formName" style="color:#2d5884">Attached Documents</label>
	</div>
	
	<s:form method="post" action="uploadFile.html"
		enctype="multipart/form-data">
		<input type="hidden" value="<c:out value="${transactionName}" />" name="transactionName">
		<table class="masterTable" style="width:30%;">
			<tr>
			<th colspan="4" align="left" style="color: #2d5884">${formTitle} - Attached Documents</th>
			</tr>
			<tr><td colspan="4"> &nbsp; </td></tr>
			<tr>
				<td style="border:1px solid white; padding:5px; background-color:#c0c1c0">Transaction  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<span  style="background-color:white; padding: 4px;"><input type="hidden" name="formName" id="formId" value="<c:out value="${formTitle}"/>" /> 
					<input type="hidden" name="test" value="<c:out value="${formTitle}"/>" /> <c:out value="${formTitle}" /></span></td>
			</tr>
			<tr><td colspan="4"> &nbsp; </td></tr>
			<tr>	
				<td>Code  &nbsp;&nbsp;
				<span  style="background-color:white; padding: 4px;"><input type="hidden" style="width: 100%; name="code" id="code" value="<c:out value="${docCode}"/>" /> <c:out value="${docCode}" /></span></td>
			</tr>
			<tr><td colspan="4"> &nbsp; </td></tr>
			<%--<tr>
				  <td><s:label path="strActualFileName">Name</s:label>&nbsp&nbsp
				   <s:input path="strActualFileName" /></td>  --%>
				   <%-- <td style="border:1px solid white; padding:5px; background-color:#c0c1c0">
				   <s:label path="binContent">Document</s:label>&nbsp&nbsp &nbsp&nbsp
				<input type="file" name="file" id="file_upload"></input></td> 
			</tr>--%>
			<!--<tr><td colspan="4"> &nbsp; </td></tr>
			<tr>
				
				<td> input type="submit" style="background-color:#007bff; color:white;padding:5px;" value="Add Document" /> &nbsp&nbsp
				     <input type="text" id="txtEmailIds"/> </td>
			</tr>-->
	<!-- <td><input type="button" id="btnSendEmail" value="Send Email" onclick="funSendEmail();"/></td>  -->
		</table><br>
	</s:form> 
	<br />
	<!-- <h3 style="padding-left: 10%">Document List</h3> -->
	<c:if test="${!empty documentList}">
		<table id="tblDoc" class="masterTable">
			<tr>
				<th>Name</th>
				<th>Description</th>
				<!-- <th>Delete</th> -->

			</tr>

			<c:forEach items="${documentList}" var="doc" varStatus="i" >
				<tr>
					<td width="200px">${doc.strActualFileName}</td>
					<td><a
						href="${pageContext.request.contextPath}/download/${doc.strCode},${doc.intId}.html">${doc.strActualFileName}</a>

					</td>
					<%-- <td><input  class="deletebutton" class="delete" value="${doc.strActualFileName}" onclick="Javacsript:funDeleteRow(this)" ></td> --%>
				</tr>
			</c:forEach>
		</table>
	</c:if>
<br><br>
</div>
</body>

</html>