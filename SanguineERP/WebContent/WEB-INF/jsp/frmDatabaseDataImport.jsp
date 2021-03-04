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

	<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />	
	<script type="text/javascript" src="<spring:url value="/resources/js/Accordian/jquery.multi-accordion-1.5.3.js"/>"></script>	
		
<title></title>
<script type="text/javascript">
	
/**
* Success/faild Message After Connect Record
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
		alert("Connection \n\n"+message);
	<%
	}}%>

});
	
	 	
	function funCheckTable()
	{
		if(flgSACode==true)
		{
			alert("Data Already Saved!!!!");
			return false;
		}
	}
	
	
	function funFillTableName()
	{
		
		var searchUrl="";
		var ipAdd=$("#txtIPAddress").val();
		var port=$("#txtPortNo").val();
		var dbName=$("#txtDBName").val();
		var userName=$("#txtUserName").val();
		var pass=$("#txtPass").val();
		var flgCon ="F";
		
		
		
		var param=ipAdd+","+port+","+dbName+","+userName+","+pass ;
		searchUrl=getContextPath()+"/loadDatabase.html?param="+param;
		//alert(searchUrl);
		$.ajax({
		        type: "GET",
		        url: searchUrl,
			    dataType: "json",
			
			    success: function(response)
			    {
			    	$('#cmbTableName').val('');
			    	document.all["lblTable"].style.display = 'block';
					document.all["cmbTableName"].style.display = 'block';
			    	$.each(response, function(i,item)
					{
			    		$('#cmbTableName').append(new Option(item, i));
			    		flgCon="T";
					}); 
			    	if(flgCon=="T")
					{
			    		alert("Connection \n\n"+"Established");
					}else
						{
						alert("Connection \n\n"+"Failed");
				        document.all["lblTable"].style.display = 'none';
						document.all["cmbTableName"].style.display = 'none';
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
	function funSetComboData()
	{
		var cmbval = $('#cmbTableName').find('option:selected').text();
		//var cmbval = $('#cmbTableName').text();
		//$('#cmbTableName').text(cmbval);
		$('#hidTableName').val(cmbval);
		//alert($("#cmbTableName").prop('selectedIndex'));
		//alert($('#cmbTableName')[2].selectedIndex);
		//alert(cmbval);
	}

</script>

</head>
<body>
<div class="container">
	<label id="formHeading">Database Data Import</label>
	<s:form name="POSItemMasterImport" method="POST" action="saveImportData.html?saddr=${urlHits}">
		<div class="row transTable">
			<div class="col-md-2">	
				<label>IP Address</label>
				<s:input type="text" id="txtIPAddress" 
					name="txtIPAddress" path="strIPAddress" required="true"/>
			</div>
			<div class="col-md-2">		
				<label>Port No</label>
				<s:input type="text" id="txtPortNo" 
						name="txtPortNo" path="strPortNo" required="true" cssStyle="text-transform: uppercase;"/>
			</div>
			<div class="col-md-2">
				<label>DataBase Name</label>		
				<s:input type="text" id="txtDBName" name="txtDBName" path="strDBName" required="true" />
			</div>
			<div class="col-md-6"></div>
			<div class="col-md-2">	
				<label>User Name</label>
				<s:input type="text" id="txtUserName"  name="txtUserName" path="strUserName" required="true"/>
			</div>
			<div class="col-md-2">				
				<label>Password</label>
				<s:input type="text" id="txtPass" name="txtPass" path="strPass" required="true"/>
			</div>
			<div class="col-md-2">			
				<label id="lblTable" style="display:none">Tables</label>
				<select id="cmbTableName" style="display:none" onchange="funSetComboData()"></select>
			</div>			
				
		</div>
<!-- 	<div>	 -->
<!-- 			<div> -->
<!-- 			<table class="transTable"> -->
<!-- 			<tr> -->
			
<!-- 				<td style="padding: 0 !important;"> -->
<!-- 							<div -->
<!-- 								style="background-color: #a4d7ff; border: 1px solid #ccc; display: block; height: 150px; overflow-x: hidden; overflow-y: scroll;"> -->
<!-- 								<table id="" class="display" -->
<!-- 									style="width: 100%; border-collapse: separate;"> -->
<!-- 									<tbody> -->
<!-- 										<tr bgcolor="#72BEFC"> -->
<!-- 											<td width="15%"><input type="checkbox" id="chkGALL" -->
<!-- 												checked="checked" onclick="funCheckUncheck()" />Select</td> -->
<!-- 											<td width="20%">Column</td> -->
											
	
<!-- 										</tr> -->
<!-- 									</tbody> -->
<!-- 								</table> -->
<!-- 								<table id="tblMySql" class="masterTable" -->
<!-- 									style="width: 100%; border-collapse: separate;"> -->
<!-- 									<tbody> -->
<!-- 										<tr bgcolor="#72BEFC"> -->
<!-- 											<td width="15%"></td> -->
<!-- 											<td width="20%"></td> -->
											
	
<!-- 										</tr> -->
<!-- 									</tbody> -->
<!-- 								</table> -->
<!-- 							</div> -->
<!-- 							</td> -->
			
			
<!-- 			</tr> -->
			
<!-- 			</table> -->
			
<!-- 			</div> -->
			
<!-- 			<div> -->
<!-- 			<table class="transTable"> -->
<!-- 			<tr> -->
			
<!-- 				<td style="padding: 0 !important;"> -->
<!-- 							<div -->
<!-- 								style="background-color: #a4d7ff; border: 1px solid #ccc; display: block; height: 150px; overflow-x: hidden; overflow-y: scroll;"> -->
<!-- 								<table id="" class="display" -->
<!-- 									style="width: 100%; border-collapse: separate;"> -->
<!-- 									<tbody> -->
<!-- 										<tr bgcolor="#72BEFC"> -->
<!-- 											<td width="15%"><input type="checkbox" id="chkGALL" -->
<!-- 												checked="checked" onclick="funCheckUncheck()" />Select</td> -->
<!-- 											<td width="20%">Column</td> -->
											
	
<!-- 										</tr> -->
<!-- 									</tbody> -->
<!-- 								</table> -->
<!-- 								<table id="tblMsSql" class="masterTable" -->
<!-- 									style="width: 100%; border-collapse: separate;"> -->
<!-- 									<tbody> -->
<!-- 										<tr bgcolor="#72BEFC"> -->
<!-- 											<td width="15%"></td> -->
<!-- 											<td width="20%"></td> -->
											
	
<!-- 										</tr> -->
<!-- 									</tbody> -->
<!-- 								</table> -->
<!-- 							</div> -->
<!-- 							</td> -->
			
			
<!-- 			</tr> -->
			
			
<!-- 			</table> -->
<!-- 			</div> -->
<!-- 	</div>	 -->


<!-- <table class="transTable"> -->
		
<!-- 			<tr></tr> -->
<!-- 			<tr> -->
<!-- 				<td style="padding: 0 !important;"> -->
<!-- 						<div -->
<!-- 							style="background-color: #a4d7ff; border: 1px solid #ccc; display: block; height: 250px; overflow-x: hidden; overflow-y: scroll;"> -->
<!-- 							<table id="" class="display" -->
<!-- 								style="width: 100%; border-collapse: separate;"> -->
<!-- 								<tbody> -->
<!-- 									<tr bgcolor="#72BEFC"> -->
<!-- 										<td width="15%"><input type="checkbox" id="chkGALL" -->
<!-- 											checked="checked" onclick="funCheckUncheck()" />Select</td> -->
<!-- 										<td width="20%">Column</td> -->
									

<!-- 									</tr> -->
<!-- 								</tbody> -->
<!-- 							</table> -->
<!-- 							<table id="tblMySql" class="masterTable" -->
<!-- 								style="width: 100%; border-collapse: separate;"> -->
<!-- 								<tbody> -->
<!-- 									<tr bgcolor="#72BEFC"> -->
<!-- 										<td width="15%"></td> -->
<!-- 										<td width="20%"></td> -->
									

<!-- 									</tr> -->
<!-- 								</tbody> -->
<!-- 							</table> -->
<!-- 						</div> -->
<!-- 						</td> -->
<!-- 						<td style="padding: 0 !important;"> -->
<!-- 						<div -->
<!-- 							style="background-color: #a4d7ff; border: 1px solid #ccc; display: block; height: 250px; overflow-x: hidden; overflow-y: scroll;"> -->

<!-- 							<table id="" class="masterTable" -->
<!-- 								style="width: 100%; border-collapse: separate;"> -->
<!-- 								<tbody> -->
<!-- 									<tr bgcolor="#72BEFC"> -->
<!-- 										<td width="15%"><input type="checkbox" id="chkSGALL" -->
<!-- 											checked="checked" onclick="funCheckUncheckSubGroup()" />Select</td> -->
<!-- 										<td width="25%">Column</td> -->
										

<!-- 									</tr> -->
<!-- 								</tbody> -->
<!-- 							</table> -->
<!-- 							<table id="tblMsSql" class="masterTable" -->
<!-- 								style="width: 100%; border-collapse: separate;"> -->
<!-- 								<tbody> -->
<!-- 									<tr bgcolor="#72BEFC"> -->
<!-- 										<td width="15%"></td> -->
<!-- 										<td width="25%"></td> -->
										
	
<!-- 									</tr> -->
<!-- 								</tbody> -->
<!-- 							</table> -->
<!-- 						</div> -->
<!-- 				</td> -->
<!-- 			</tr> -->
<!-- 		</table> -->
		<br />
		<div class="center" style="text-align:center; margin-right: 37%;">
			<a href="#"><button class="btn btn-primary center-block" tabindex="3" id="btnSubmit" value="Connect" onclick="funFillTableName()">Connect</button></a>&nbsp
			<a href="#"><button class="btn btn-primary center-block" tabindex="3" value="Excute" >Excute</button></a>&nbsp
			<a href="#"><button class="btn btn-primary center-block"  value="reset" onclick="funResetFields()">Reset</button></a>
			<s:input type="hidden" id="hidTableName" path="strSGName"></s:input>
		</div>
	</s:form>
</div>
</body>
</html>
