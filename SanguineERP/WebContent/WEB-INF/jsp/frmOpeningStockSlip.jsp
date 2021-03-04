<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  	<link rel="stylesheet" type="text/css" href="default.css" />
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Opening Stock Slip</title>
     <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
    
    <script type="text/javascript">
    	
	    /**
		  *  Global variable
		 **/
    	var fieldName;
    
    	/**
		  *  Reset the form
		 **/
    	function funResetFields()
    	{
    		$("#txtOpStkCode").val('');
    	}
    	
    	/**
		  * Open help form
		 **/
    	function funHelp(transactionName)
		{
			fieldName=transactionName;
			//window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=", 'window', 'width=600,height=600');
		//	 window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
			 window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	    }
    	
    	/**
    	* 	Get and Set from Help From windows
    	**/
		function funSetData(code)
		{
			$("#txtOpStkCode").val(code);
		}
    	
		 /**
		  *  Check Validation Before Submit The Form
		 **/
		function funCallFormAction(actionName,object) 
		{	
			
		  if($("#txtOpStkCode").val()=="")
			{
				alert("Please Opening Stock Code");
				return false;
			}
			else
			{
				if (actionName == 'submit') 
				{
						document.forms[0].action = "rptOpeningStockSlip.html";
				}
			}
		}
    
    </script>
  </head>
<body>
<div class="container masterTable">
		<label id="formHeading">Opening Stock Slip</label>
      <s:form name="GRNSlip" method="GET" action="rptOpeningStockSlip.html" target="_blank">

   <div class="row">
			 <div class="col-md-2"><label>Opening Stock Code</label>
		          <s:input type ="text" path="strDocCode" id="txtOpStkCode" name="strGRNCode" readonly="readonly"  class="searchTextBox" style="width: 150px;background-position: 136px 4px;" ondblclick="funHelp('opstockslip')"/>
	         </div>
             <div class="col-md-10"></div>
             
	        <div class="col-md-2"><label>Report Type</label>
				  <s:select id="cmbDocType" path="strDocType" style="width:auto;">
				    		<s:option value="PDF">PDF</s:option>
				    		<s:option value="XLS">EXCEL</s:option>
				    		<s:option value="HTML">HTML</s:option>
				    		<s:option value="CSV">CSV</s:option>
			     </s:select>
			</div>
	 </div>
	<br>
		<p align="center" style="margin-right: 61%;">
			<input type="submit" value="Submit" onclick="return funCallFormAction('submit',this)" class="btn btn-primary center-block" class="form_button"/>
			&nbsp;
		    <input type="button" value="Reset" class="btn btn-primary center-block" class="form_button" />
		</p>

</s:form>
</div>
</body>
</html>