<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Business Source Master</title>
    <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

<script type="text/javascript">

		/**
		* Open Help
		**/
		function funHelp(transactionName)
		{
			window.open("searchform.html?formname="+transactionName+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
		    //window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
		}
		

// 		/**
// 		*   Attached document Link
// 		**/
// 		$(function()
// 		{
		
// 			$('a#baseUrl').click(function() 
// 			{
// 				if($("#txtMarketCode").val().trim()=="")
// 				{
// 					alert("Please Select Market Code");
// 					return false;
// 				}
// 			   	window.open('attachDoc.html?transName=frmMarketSource.jsp&formName=MarketSource Master&code='+$('#txtMarketCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
// 			});
			
// 			/**
// 			* On Blur Event on Market Code Textfield
// 			**/
// 			$('#txtMarketCode').blur(function() 
// 			{
// 				var code = $('#txtMarketCode').val();
// 				if (code.trim().length > 0 && code !="?" && code !="/")
// 				{
// 					funSetData(code);
// 				}
// 			});
			
// 			$('#txtMarketDesc').blur(function () {
// 				 var strDescription=$('#txtMarketDesc').val();
// 			      var st = strDescription.replace(/\s{2,}/g, ' ');
// 			      $('#txtMarketDesc').val(st);
// 				});
			
// 		});
		
	

		/**
		* Get and Set data from help file and load data Based on Selection Passing Value(Business Source Code)
		**/
		
		function funSetData(code)
		{
			$("#txtMarketCode").val(code);
			var searchurl=getContextPath()+"/loadMarketMasterData.html?marketCode="+code;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strMarketSourceCode=='Invalid Code')
				        	{
				        		alert("Invalid Business Code");
				        		$("#txtMarketCode").val('');
				        	}
				        	else
				        	{
					        	$("#txtMarketDesc").val(response.strDescription);
					        	$("#cmbRequestSlip").val(response.strReqSlipReqd);
					        	
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
		* Success Message After Saving Record
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
				alert("Data Save successfully\n\n"+message);
			<%
			}}%>

		});
	
		
		 /**
			 *  Check Validation Before Saving Record
			 **/
					function funCallFormAction(actionName,object) 
					{
						var flg=true;
						if($('#txtMarketDesc').val()=='')
						{
							 alert('Enter Market Description');
							 flg=false;
							  
						}
						return flg;
					}
		 
					 $('#baseUrl').click(function() 
								{  
									 if($("#txtMarketCode").val().trim()=="")
									{
										alert("Please Select Market Code... ");
										return false;
									} 
										window.open('attachDoc.html?transName=frmMarketSource.jsp&formName=Member Profile&code='+$('#txtMarketCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
								});
	
</script>

</head>
<body>
	<div class="container masterTable">
	  <label id="formHeading">Market Source Master</label>
	    <s:form name="Market" method="GET" action="saveMarketSourceMaster.html?" >
	

<!-- 				<th align="right" colspan="2"><a id="baseUrl" -->
<!-- 					href="#"> Attach Documents</a>&nbsp; &nbsp; &nbsp; -->
<!-- 						&nbsp;</th> -->
<!-- 			</tr> -->
       <div class="row">
			<div class="col-md-5">
		   	 <div class="row">
				<div class="col-md-5"><label>Market Code</label>
				    <s:input id="txtMarketCode" path="strMarketSourceCode" cssClass="searchTextBox" ondblclick="funHelp('marketsource')" style="height: 50%;"/>
				</div>				
			    <div class="col-md-7"><label>Description</label>
				    <s:input id="txtMarketDesc" path="strDescription"/>			
			    </div>
			 </div></div>
			 
			     <div class="col-md-1"><label style="width: 200%">Request Slip Required</label>
				     <s:select id="cmbRequestSlip" path="strReqSlipReqd">
				        <option selected="selected" value="Y">Yes</option>
			             <option value="N">No</option>
		              </s:select>
				  </div>
			</div>
		
		<br />
		<p align="center" style="margin-right: 14%;">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" onclick="return funCallFormAction('submit',this);" />&nbsp;
            <input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" />
         </p>
	</s:form>
	</div>
</body>
</html>