<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<meta http-equiv="X-UA-Compatible" content="IE=8">

		<script type="text/javascript" src="<spring:url value="/resources/js/jQuery.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/jquery-ui.min.js"/>"></script>	
		<script type="text/javascript" src="<spring:url value="/resources/js/validations.js"/>"></script>
	
	


<title>Data Import</title>
<style>
.ui-autocomplete {
    max-height: 200px;
    overflow-y: auto;
    /* prevent horizontal scrollbar */
    overflow-x: hidden;
    /* add padding to account for vertical scrollbar */
    padding-right: 20px;
}
/* IE 6 doesn't support max-height
 * we use height instead, but this forces the menu to always be this tall
 */
* html .ui-autocomplete {
    height: 200px;
}
</style>

<script type="text/javascript">

function funShowImagePreview(input)
{
	 if (input.files && input.files[0])
	 {
		 var filerdr = new FileReader();
		 filerdr.onload = function(e) 
		 {
		 $('#itemImage').attr('src', e.target.result);
		 }
		 filerdr.readAsDataURL(input.files[0]);
	 }
	 
	
}
</script>

</head>
<body >

	<div class="container">
		<label id="formHeading">Database Data Import</label>
			<s:form name="DataImport" method="POST" action="saveDataImport.html?saddr=${urlHits}">
				<div class="row masterTable">
					<div class="col-md-4">
						<label>DataBase Path:</label><br>
						<s:input type="text" id="txtDBPath" placeholder="Enter full Database path with file name"  name="DbPath" path="strDBName" />
					</div>
					<div class="col-md-4"><!-- <input id="BrowseDB" name="BrowseDB"  type="file" accept=".mdb,.accda,.accdb" onchange="funShowDataBasePreview(this);" /> --></div>
					<div class="col-md-4"></div>
		
				</div>
				<div class="center" style="text-align:center;">
					<a href="#"><button class="btn btn-primary center-block"  tabindex="3" value="Excute" onclick="" 
						class="form_button">Execute</button></a>
				</div>
		</s:form>
	</div>
</body>
</html>