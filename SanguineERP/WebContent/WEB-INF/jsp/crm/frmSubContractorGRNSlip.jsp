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

function funHelp(transactionName)
		{
			fieldName = transactionName;
		//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
			window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;top=500,left=500")
			
		}

		 	function funSetData(code)
			{
				switch (fieldName)
				{
					    	
				    case 'SCGRNCode' :
				    	 $('#txtSCCode').val(code);
				    	break;
				    	
				    case 'SCGRNCodeslip' :
				    	 $('#txtSCCode').val(code);
				    	break;
				        
				}
			}
		 	
</script>
</head>
<body onload="funOnLoad();">
	<div class="container transTable">
		<label id="formHeading">Sub Contractor GRN Slip</label>
	<s:form name="SubContractorGRNSlip" method="GET"
		action="rptSubContractorGRNSlip.html" >
		<input type="hidden" value="${urlHits}" name="saddr">
		<br>
		     <div class="row">
							<div class="col-md-5">
			                       <div class="row">
			                           <div class="col-md-5"><label>Sub-Contractor Return  Code</label>
									        <s:input path="strDocCode" id="txtSCCode"
											ondblclick="funHelp('SCGRNCodeslip')"
											cssClass="searchTextBox" /></div>
										<div class="col-md-7"><label id="lblJobOrderName"
										class="namelabel" style="background-color:#dcdada94; width: 100%; height: 50%; margin-top:11%"></label></div>
							  </div></div>
							
				<div class="col-md-2"><label>Report Type</label>
			         <s:select id="cmbDocType" path="strDocType" style="width:45%">
						<s:option value="PDF">PDF</s:option>
						<s:option value="XLS">EXCEL</s:option>
						<s:option value="HTML">HTML</s:option>
						<s:option value="CSV">CSV</s:option>
					</s:select>
			     </div>

		    </div>
		<br>
		<p align="right" style="margin-right:50%">
			<input type="submit" value="Submit"
				onclick="return funCallFormAction('submit',this)" class="btn btn-primary center-block" 
				class="form_button" /> &nbsp;
			 <a STYLE="text-decoration: none"
				href="frmSubContractorGRNSlip.html?saddr=${urlHits}"><input
				type="button" id="reset" name="reset" value="Reset" class="btn btn-primary center-block" 
				class="form_button" /></a>
		</p>
		<br>
		<div id="wait"
			style="display: none; width: 60px; height: 60px; border: 0px solid black; position: absolute; top: 60%; left: 55%; padding: 2px;">
			<img
				src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif"
				width="60px" height="60px" />
		</div>
	</s:form>
  </div>
</body>
</html>