<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Batch Monitor</title>
</head>
<body>
<div class="container">
	 <label id="formHeading">Supplier Tax Wise GRN Report</label>
	  <s:form name="frmBatchMonitorReport" method="POST" action="" >
		<input type="hidden" value="${urlHits}" name="saddr">
            <br />
	   		<div class="row transTable">
			  <!--  <tr><th colspan="10"></th></tr> -->
				
				<br>
				
				<div class="col-md-2"><label>Batch Code</label>
				      <s:input id="txtBatchCode" path="strBatchCode" readonly="true" ondblclick="funHelp('Batch')" cssClass="searchTextBox jQKeyboard form-control"/>
				</div>
			    <div class="col-md-10"></div>
			    
				<div class="col-md-2"> 
				      <input id="btnExecute" type="button" class="btn btn-primary center-block" class="form_button1" value="EXECUTE"/>
				 </div>
				 
				 <div class="col-md-2">						
					  <input id="btnExport" type="button" value="EXPORT" class="btn btn-primary center-block" class="form_button1"/>
				 </div>
			
			</div>
			<br>
			
		</s:form>
		</div>
</body>
</html>