<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Recipe Costing</title>
     <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

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
			var searchurl=getContextPath()+"/loadRecipeData.html?recipeCode="+code;
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


</head>

<body onload="funOnLoad();">
	<div class="container masterTable">
		<label id="formHeading">Recipe Costing</label>
	<s:form name="recipeCosting" method="GET" action="rptRecipeCosting.html?saddr=${urlHits}">
     
     <div class="row">	
		        <div class="col-md-2"><label>Recipe Code</label>
				     <s:input id="txtRecipeCode" readonly="true" path="strDocCode" cssClass="searchTextBox" ondblclick="funHelp('bomcodeslip')" />
				</div>
			
		        <div class="col-md-2"><label id=lblParentName  style="background-color:#dcdada94; width: 100%; height: 56%;margin-top:15%"> All Recipe </label>	
		        </div>	
				 <div class="col-md-8"></div>
				 
		        <div class="col-md-2"><label>Considering Yield % </label><br>
		                <s:checkbox element="li" id="chkYieldPer" path="strProdType" value="Yes" />
		        </div>
				
		        <div class="col-md-2"><label>Report Type</label>
				    <s:select id="cmbDocType" path="strDocType" style="width:auto;">
						<s:option value="PDF">PDF</s:option>
						<s:option value="XLS">EXCEL</s:option>
						<s:option value="HTML">HTML</s:option>
						<s:option value="CSV">CSV</s:option>
					</s:select>
			    </div>
		</div>

		<br />
		<p align="center" style="margin-right:51%">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" /> 
			&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>
	</s:form>
   </div>
	</body>
	</html>