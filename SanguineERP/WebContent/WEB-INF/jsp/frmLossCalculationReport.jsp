<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
     <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

</head>
<script type="text/javascript">

	/**
	* Reset The Group Name TextField
	**/
	function funResetFields()
	{
		$("#txtRecipeCode").focus();
    }
	
	function funSetData(code)
	{			
		switch (fieldName) 
		{			   
		   case 'bomcode':
		    	funSetBom(code);
		        break;
		        
		   case 'productmaster':
		    	funSetProduct(code);
		        break;
		        
		   case 'bomcodeslip':
		    	funSetBom(code);
		        break;
		}
	}
	function funSetProduct(code)
	{
		searchUrl=getContextPath()+"/loadProductData.html?prodCode="+code;
		//alert(searchUrl);
		$.ajax({
	        type: "GET",
	        url: searchUrl,
	        dataType: "json",
	        success: function(response)
	        {
	        	if(response.strParentCode!="Invalid Product Code")
	        		{
			        
		        		$("#lblParentName").text(response.strParentName);
		        		
	        		}
	        	else
	        		{
	        			alert("Invalid Parent Product Code");
	        			
	        			return false;
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
	
		/**
		* Open Help
		**/
		function funHelp(transactionName)
		{
			fieldName = transactionName;
		//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
			window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
			
		}
		
		/**
		* Get and Set data from help file and load data Based on Selection Passing Value(Group Code)
		**/
		function funSetBom(code)
		{
			$("#txtRecipeCode").val(code);
			var searchurl=getContextPath()+"/loadLossData.html?recipeCode="+code;
			//alert(searchurl);
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strBOMCode=='Invalid Code')
				        	{
				        		alert("Invalid Recipe Code");
				        		$("#txtRecipeCode").val('');
				        	}
				        	else
				        	{
				        		funSetProduct(response.strParentCode);
					        	
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
		
		
			
			/**
			* On Blur Event on TextField
			**/
			$('#txtRecipeCode').blur(function() 
			{
					var code = $('#txtRecipeCode').val();
					if (code.trim().length > 0 && code !="?" && code !="/")
					{				
						funSetData(code);							
					}
			});
			
		
</script>
<body>
	<div class="container masterTable">
      <label id="formHeading">Loss Calculation report </label>
	   <s:form name="frmLossCalculationReport" method="POST" action="rptLossCalculationReport.html?saddr=${urlHits}">
	 
	   <div class="row">	
		       <div class="col-md-2"><label>Recipe Code</label>
				     <s:input id="txtRecipeCode" path="strDocCode" cssClass="searchTextBox" readOnly="true" ondblclick="funHelp('bomcodeslip')" />
		       </div>
		      
			   <div class="col-md-2"><br><label id=lblParentName style="background-color:#dcdada94; width: 100%; heigh:58%;padding:4px;"> All Recipe </label></div>	
				<div class="col-md-8"></div>		
			   <div class="col-md-2"><label>Report Type</label>
				    <s:select id="cmbDocType" path="strDocType">
						<s:option value="PDF">PDF</s:option>
						<s:option value="XLS">EXCEL</s:option>
						<s:option value="HTML">HTML</s:option>
						<s:option value="CSV">CSV</s:option>
					</s:select>
			   </div>
	    </div>
	<br>
	<p align="center" style="margin-right:49%">
		        <input type="submit" value="Submit" class="btn btn-primary center-block" class="form_button" id="submit" /> 
	             &nbsp;
	            <input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" id="btnReset" />

	</p>
</s:form>
  </div>
</body>
</html>