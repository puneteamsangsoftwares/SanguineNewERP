<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Sales Order</title>

<script type="text/javascript">
		
$(document).ready(function() 
		{		
			$(".tab_content").hide();
			$(".tab_content:first").show();
	
			$("ul.tabs li").click(function() {
				$("ul.tabs li").removeClass("active");
				$(this).addClass("active");
				$(".tab_content").hide();
				var activeTab = $(this).attr("data-state");
				$("#" + activeTab).fadeIn();
			});
			
			
		});
		
	function funHelp(transactionName)
		{
			fieldName = transactionName;
		//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
			window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
			
		}

		 	function funSetData(code)
			{
				switch (fieldName)
				{
					    	
				    case 'JOCode' :
				    	 $('#txtJOCode').val(code);
				    	break;
				        
				    case 'JOCodeslip' :
				    	 $('#txtJOCode').val(code);
				    	break;
				}
			}
		 	
		 	
		 	
$(function()
			{
				$("#txtJOCode").blur(function() 
						{
							var code=$('#txtJOCode').val();
							if(code.trim().length > 0 && code !="?" && code !="/")
							{
								funSetSalesData(code);
							}
						});
				
			});
		
</script>

</head>
<body onload="funOnLoad();">
	<div class="container transTable">
	<label id="formHeading">Job Order Slip</label>
       <s:form name="JobOrderSlip" method="GET"
		action="rptJobOrderSlip.html" >
		<input type="hidden" value="${urlHits}" name="saddr">
		<br>
		    <div class="row">
		    		<div class="col-md-5">
		    				<div class="row">
									<div class="col-md-5"><label>Job Code</label>
										<s:input path="strDocCode" id="txtJOCode"
											ondblclick="funHelp('JOCodeslip')"
											cssClass="searchTextBox" /></div>
									<div class="col-md-7"><label id="lblJobOrderName"
										class="namelabel" style="background-color:#dcdada94; width: 100%; height: 50%; margin-top:11%;"></label></div>
					</div></div>
					<div class="col-md-7"></div>
						
				<div class="col-md-2"><label>Report Type</label>
					<s:select id="cmbDocType" path="strDocType"
						style="width:50%">
						<s:option value="PDF">PDF</s:option>
						<s:option value="XLS">EXCEL</s:option>
						<s:option value="HTML">HTML</s:option>
						<s:option value="CSV">CSV</s:option>
					</s:select>
				</div>

		</div>
		
		<p align="right" style="margin-right:60%">
			<input type="submit" value="Submit"
				onclick="return funCallFormAction('submit',this)" class="btn btn-primary center-block" 
				class="form_button" /> &nbsp;
				 <a STYLE="text-decoration: none"
				href="frmJobOrderSlip.html?saddr=${urlHits}"><input
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