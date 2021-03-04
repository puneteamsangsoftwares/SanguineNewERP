<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
  	<link rel="stylesheet" type="text/css" href="default.css" />
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Web Stocks</title>
     <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
    
    <script type="text/javascript">
    /**
	 * fill subgroup combox when user select Group
	 */
    function funFillCombo(code) {
		var searchUrl = getContextPath() + "/loadSubGroupCombo.html?code="
				+ code;
		//alert(searchUrl);
		if(code=="ALL")
			{
				var html = '<option value="ALL">ALL</option>';
				html += '</option>';
				$('#strSGCode').html(html);
			}
		else{
		$.ajax({
			type : "GET",
			url : searchUrl,
			dataType : "json",
			success : function(response) {
				var html = '<option value="ALL">ALL</option>';
				html += '</option>';
				$.each(response, function(key, value) {
					html += '<option value="' + key + '">' + value
							+ '</option>';
				});
				html += '</option>';
				$('#strSGCode').html(html);
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
	}
    
    function funCallFormAction(actionName,object) 
	{	
	
	 

			if($("#cmbDocType").val()=="XLS")
	    	{
	    		flag=false;
		    	var reportType=$("#cmbDocType").val();
				var locCodeFrom=$("#txtLocFrom").val();
				var locCodeTo=$("#txtLocTo").val();
				var param1=reportType+","+locCodeFrom+","+locCodeTo;

				document.forms[0].action =  "rptProductListExport.html";
	    	}
			else
				{
					 document.forms[0].action = "rptProductList.html";
				}
	    }
			  
    </script>
  </head>
  
	<body >
	<div class="container masterTable">
		<label id="formHeading">Product List</label>
	    <s:form name="prodList" method="GET" action="rptProductList.html" target="_blank">
			
	     <div class="row">	
		         <div class="col-md-2"><label>Product Type</label>
					   <s:select id="cmbProdType" path="strProdType" items="${typeList}" cssStyle="width:auto">
<%-- 				    		<s:option value="ALL">ALL</s:option> --%>
				    	</s:select>
				  </div>
				<div class="col-md-10"></div>
					
				<div class="col-md-3"><label>Group</label>
				     <s:select path="strGCode" items="${listgroup}" id="strGCode" onchange="funFillCombo(this.value);" cssStyle="width:auto"> </s:select>
				</div>
				
				<div class="col-md-2"><label>SubGroup</label>
			         <s:select path="strSGCode" items="${listsubGroup}" cssStyle="width:auto" id="strSGCode">
					</s:select>
				</div>
				<div class="col-md-7"></div>
					
				<div class="col-md-2"><label>Report Type</label>
					     <s:select id="cmbDocType" path="strDocType" cssStyle="width:auto">
				    		<s:option value="PDF">PDF</s:option>
				    		<s:option value="XLS">EXCEL</s:option>
				    		<s:option value="HTML">HTML</s:option>
				    		<s:option value="CSV">CSV</s:option>
				    	</s:select>
				</div>
				
				<!-- <td><input type="submit" value="Submit" /></td>
					<td><input type="reset" value="Reset" onclick="funResetFields()"/></td>	 -->				
				
			</div>
			<br>
			<p align="center" style="margin-right:51%">
				<input type="submit" value="Submit" class="btn btn-primary center-block"  class="form_button" onclick="return funCallFormAction('submit',this)" />
				&nbsp;
			   <input type="button" value="Reset" class="btn btn-primary center-block"  class="form_button " />
			</p>
			
		</s:form>
	  </div>
	</body>
</html>