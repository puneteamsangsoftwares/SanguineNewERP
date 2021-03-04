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
	
<title>Insert title here</title>
<script type="text/javascript">
    var loggedInProperty="",loggedInLocation="";
    
 			//Ajax Waiting
   			$(document).ready(function() 
    		{
    			$(document).ajaxStart(function()
    		 	{
    			    $("#wait").css("display","block");
    		  	});
    		 	
    			$(document).ajaxComplete(function()
    			{
    			    $("#wait").css("display","none");
    			});	
    		});
 			
   		    //Set Date in date picker with default Value
    		$(document).ready(function() 
			{
				var startDate="${startDate}";
				var startDateOfMonth="${startDateOfMonth}";
				var arr = startDate.split("/");
				Dat=arr[0]+"-"+arr[1]+"-"+arr[2];
				$("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy' });
				$("#txtFromDate").datepicker('setDate',startDateOfMonth);
				$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
				$("#txtToDate").datepicker('setDate', 'today');
			});
    		
   		    //Open Help
    		function funHelp(transactionName)
    		{
    			fieldName=transactionName;
    		//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
    			window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;dialogLeft:200px;")
    	    }
    		
   		    //Get Product Data based on help selection 
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
    			    	if ('Invalid Code' == response.strProdCode) {
							alert('Invalid Product Code');
							$("#txtProdCode").val('');
	    		        	$("#lblProdName").text('');
    			    	}
    			    	else
    			    	{
	    			    	$("#txtProdCode").val(response.strProdCode);
	    		        	$("#lblProdName").text(response.strProdName);
    			    	}
    			    },
    				error: function(e)
    			    {
    			       	alert('Error:=' + e);
    			    }
    		    });
    		}
    		
    		//Get and Set Data from Help Selection 
    		function funSetData(code)
    		{
    			switch (fieldName) 
    			{			        
    			    case 'productmaster':
    			    	funSetProduct(code);
    			        break;
    			    case 'suppcode':
    			    	funSetSupplier(code);
    			        break;
    			}
    		}
    		
    		//Get and Set Supplier Data based on passing value(supplier Code) 
    		function funSetSupplier(code) {
				var searchUrl = "";
				searchUrl = getContextPath()
						+ "/loadSupplierMasterData.html?partyCode=" + code;

				$.ajax({
					type : "GET",
					url : searchUrl,
					dataType : "json",
					success : function(response) {
						if ('Invalid Code' == response.strPCode) {
							alert('Invalid Supplier Code');
							$("#txtSuppCode").val('');
							$("#txtSuppName").text('');
							$("#txtSuppCode").focus();
						} else {
							$("#txtSuppCode").val(response.strPCode);
							$("#txtSuppName").text(response.strPName);
						}
					},
					error : function(jqXHR, exception) {
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
    		
    		//On blur Event TextField
    		$(function()
    				{
    				
    					$('#txtProdCode').blur(function() 
    					{
    							var code = $('#txtProdCode').val();
    							if (code.trim().length > 0 && code !="?" && code !="/")
    							{				
    								funSetProduct(code);							
    							}
    					});
    					$('#txtSuppCode').blur(function() 
    	    					{
    	    							var code = $('#txtSuppCode').val();
    	    							if (code.trim().length > 0 && code !="?" && code !="/")
    	    							{				
    	    								funSetSupplier(code);							
    	    							}
    	    					});
    				});
    		
    		//Reset field
    		function funResetFields()
    		{
    			location.reload(true); 
    		}
    </script>
</head>
<body>

	<div class="container">
		<label id="formHeading">Items Variance Report</label>
		<s:form action="rptItemsVarReport.html" method="POST" name="frmItemVariancePriceFlash" target="_blank">
		
		<div class="row transTable">
			<div class="col-md-2">
				<label id="lblFromDate">From Date</label>
			     <s:input id="txtFromDate" name="fromDate" path="dtFromDate" cssClass="calenderTextBox" style="width:70%;"/>
			      <s:errors path="dtFromDate"></s:errors>
			 </div> 
			 <div class="col-md-2">   
				<label id="lblToDate">To Date</label>
			  	<s:input id="txtToDate" name="toDate" path="dtToDate" cssClass="calenderTextBox" style="width:70%;"/>
			    <s:errors path="dtToDate"></s:errors>
			 </div> 
			 <div class="col-md-2">   
				<label>Product</label>
			    <s:input id="txtProdCode" ondblclick="funHelp('productmaster');" class="searchTextBox" path="strProdCode" placeholder="All Product" />
			  </div> 
			  <div class="col-md-2">   
			      <label  id="lblProdName" style="background-color:#dcdada94; width: 100%; height: 42%; margin: 27px 0px; text-align:center;"></label>
			  </div>
			  <div class="col-md-4"></div>    
			  <div class="col-md-2">   
					<label>Supplier</label>
				    <s:input id="txtSuppCode"  ondblclick="funHelp('suppcode')" Class="searchTextBox" path="strSuppCode" placeholder="All Supplier" />
			  </div>
			  <div class="col-md-4">   
					<label id="txtSuppName" style="background-color:#dcdada94; width: 100%; height: 42%; margin: 27px 0px; text-align:center;"></label>
			</div>
			<div class="col-md-2"> 	
					<label>Report Type</label>
					<s:select id="cmbDocType" path="strDocType" cssClass="BoxW124px">
				    	<s:option value="PDF">PDF</s:option>
				    	<s:option value="XLS">EXCEL</s:option>
				    	<s:option value="HTML">HTML</s:option>
				    	<s:option value="CSV">CSV</s:option>
				    </s:select>
			</div>		
			
		</div>
		<div class="center" style="margin-right: 40%;">
			<a href="#"><button class="btn btn-primary center-block" value="Submit">Submit</button></a>
			<a href="#"><button class="btn btn-primary center-block"  value="Reset" onclick="funResetFields()">Reset</button></a>
		</div>	
			
		<div id="wait"
			style="display: none; width: 60px; height: 60px; border: 0px solid black; position: absolute; top: 60%; left: 55%; padding: 2px;">
			<img src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif"
				width="60px" height="60px" />
		</div>
	</s:form>
	
</div>
</body>
</html>