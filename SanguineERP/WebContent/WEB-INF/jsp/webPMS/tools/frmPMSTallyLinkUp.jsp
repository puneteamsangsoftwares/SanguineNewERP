<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
	
	    <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />

		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
	
<title></title>
<script type="text/javascript">
	var fieldName;
	var rowNo;

	$(function() 
	{
	});

	function funSetData(code){

		switch(fieldName){
				
			case 'WSItemCode' : 
				funSetWSItemCode(code);
				break;
				
			case 'productmaster':
		    	funSetProduct(code);
		        break;
		}
	}


	function funSetWSItemCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadWSItemCode.html?docCode=" + code,
			dataType : "json",
			success : function(response){ 

			},
			error : function(e){

			}
		});
	}

	
	function funSetProduct(code)
	{
		var searchUrl="";
		searchUrl=getContextPath()+"/loadProductMasterData.html?prodCode="+code;
		$.ajax
		({
	        type: "GET",
	        url: searchUrl,
		    dataType: "json",
		    success: function(response)
		    {
		    	document.getElementById("strWSItemCode."+rowNo).value=response.strProdCode;
		    	document.getElementById("strWSItemName."+rowNo).value=response.strProdName;
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
	
	function funHelp1(row,transName)
	{
		fieldName=transName;
		rowNo=row;
	//	window.showModalDialog("searchform.html?formname="+transName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
		window.open("searchform.html?formname="+transName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
	
 	function funLinkupData()
 	{
 		var cmobo =$("#cmbLinkup").val()
		if(cmobo=="Room Type")
		{
			funSetPMSTallyData(cmobo)
		}
		
		if(cmobo=="Room No")
		{
			funSetPMSTallyData(cmobo)
		}
		
		if(cmobo=="Tax")
		{
			funSetPMSTallyData(cmobo)
 		}
		if(cmobo=="Guest")
		{
			funSetPMSTallyData(cmobo)
 		}
		if(cmobo=="Income Head")
		{
			funSetPMSTallyData(cmobo)
 		}
	
		
 	}
	
	
	function funSetPMSTallyData(code)
	{
		var searchUrl="";
		searchUrl=getContextPath()+"/LoadSupplierLinkUp.html";
		$.ajax
		({
	        type: "GET",
	        url: searchUrl,
		    dataType: "json",
		    success: function(response)
		    {
// 		    	document.getElementById("strWSItemCode."+rowNo).value=response.strProdCode;
// 		    	document.getElementById("strWSItemName."+rowNo).value=response.strProdName;
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
	
	function funLinkupData(code) {
	
		document.PMSTallyLinkUp.action = "loadLinkUpPMSData.html";
		document.PMSTallyLinkUp.submit();
		
	}

	
	
	
</script>

</head>
<body>
	<div class="container">
		<label id="formHeading">Tally Link Up</label>
		<s:form name="PMSTallyLinkUp" method="POST" action="savePMSTallyLinkUp.html">
		
		<div class="row masterTable">
			<div class="col-md-2">
				<label>Link up</lable>
				<s:select id="cmbLinkup" path="strLinkup" onchange="funLinkupData(this.value)">
				    <s:option value="Room Type">Room Type</s:option>
				     <s:option value="Package">Package</s:option>
				    <s:option value="Tax">Tax</s:option>
				    <s:option value="Guest">Guest</s:option>
				    <s:option value="Income Head">Income Head</s:option>
				    <s:option value="Settlement">Settlement</s:option>
				    
				 </s:select>
			</div>	
		</div>
		<br>
		<table class="masterTable" style="width:100%;">
			<tr bgcolor="#c0c0c0">
				<td style="width: 24%;">
					<label>Code</label>
				</td>
				
				<td style="width: 33%;">
					<label>Name</label>
				</td>
				
				<td style="width: 25%;">
					<label>Des</label>
				</td>
				
				<td style="width: 14%;">
					<label>Tally Alias Code</label>
				</td>	
				
				<td>
					<label>Delete</label>
				</td>				
			</tr>
		</table>

		<table class="masterTable" style=" width:100%; height: 100%; text-align: center; border: 1px solid #c0c0c0; font-size: 11px; font-weight: bold;">
			<tr>
				<td>
					<table  id="tblTermsAndCond">
						 <c:forEach items="${TallyLinkUpList.listTallyLinkUp}" var="tc"
							varStatus="status">
							<tr>
								<td align="left" width="10%"><input
									readonly="readonly" class="Box" type="text" size="20%"
									name="listTallyLinkUp[${status.index}].strGroupCode"
									value="${tc.strGroupCode}"></input></td>

								<td align="left" width="40%"><input type="text" size="50%"
									name="listTallyLinkUp[${status.index}].strGroupName"
									value="${tc.strGroupName}" class="longTextBox"></input></td>
								
								<td align="left" width="25%">
									<input type="text" size="60%" name="listTallyLinkUp[${status.index}].strGDes"
									value="${tc.strGDes}" class="longTextBox" 
									name="listTallyLinkUp[${status.index}].strGDes"
									id="strGDes.${status.index}" ></input></td>

								<td align="left" width="60%"><input type="text" size="40%"
									name="listTallyLinkUp[${status.index}].strTallyCode" 
									id="strTallyCode.${status.index}"  
									value="${tc.strTallyCode}" class="longTextBox"></input></td>
									
								<td><input type="button" class="deletebutton"
									value="Delete" onClick="Javacsript:funDeleteTCRow(this)"></td>
							</tr>
						</c:forEach> 

					</table>
				</td>
			</tr>
		</table>
		<br />
		<br />
		<div class="center">
			<a href="#"><button class="btn btn-primary center-block" tabindex="3" value="Submit">Submit</button></a>
			<a href="#"><button class="btn btn-primary center-block"  value="Reset" onclick="funResetFields()">Reset</button></a>
		</div>
	</s:form>
</div>
</body>
</html>
