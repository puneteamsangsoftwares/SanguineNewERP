<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Department Master</title>
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
			window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
		}
		
		/**
		*   Attached document Link
		**/
		$(function()
		{
		
			$('a#baseUrl').click(function() 
			{
				if($("#txtDeptCode").val().trim()=="")
				{
					alert("Please Select Dept Code");
					return false;
				}
			   window.open('attachDoc.html?transName=frmDepartmentMaster.jsp&formName=Department Master&code='+$('#txtDeptCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
			});
			
			/**
			* On Blur Event on deptCode Textfield
			**/
			$('#txtDeptCode').blur(function() 
			{
					var code = $('#txtDeptCode').val();
					if (code.trim().length > 0 && code !="?" && code !="/")
					{				
						funSetData(code);
					}
			});
			
			$('#txtDeptName').blur(function () {
				 var strDName=$('#txtDeptName').val();
			      var st = strDName.replace(/\s{2,}/g, ' ');
			      $('#txtDeptName').val(st);
				});
			
			var strIndustryType='<%=session.getAttribute("selectedModuleName").toString()%>';
	   		if(strIndustryType=='3-WebPMS') 
	   		{
	   			$('#trEmail').hide();
	   			$('#trMobile').hide();
	   		}
			
		});
		
		
		/**
		 *  Check Validation Before Saving Record
		 **/
		function funCallFormAction(actionName,object) 
		{
			var flg=true;
			if($('#txtDeptDesc').val()=='')
			{
				alert('Enter Department Name ');
				flg=false;								  
			}
			return flg;
		}
		
		
		/**
		* Get and Set data from help file and load data Based on Selection Passing Value(Dept Code)
		**/
		function funSetData(code)
		{
			$("#txtDeptCode").val(code);
			var searchurl=getContextPath()+"/loadDeptMasterData.html?deptCode="+code;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strDeptCode=='Invalid Code')
				        	{
				        		alert("Invalid Dept Code");
				        		$("#txtDeptCode").val('');
				        	}
				        	else
				        	{
					        	$("#txtDeptDesc").val(response.strDeptDesc);
					        	$("#cmbOperational").val(response.strOperational);
					        	$("#cmbRevenueProducing").val(response.strRevenueProducing);
					        	$("#cmbDiscount").val(response.strDiscount);
					        	$("#cmdDeactivate").val(response.strDeactivate);
					        	$("#cmbType").val(response.strType);
					        	$("#txtDeptDesc").focus();
					        	$("#txtEmailId").val(response.strEmailId);
					        	$("#txtMobileNo").val(response.strMobileNo);
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
				alert("Data Save successfully \n\n"+message);
			<%
			}}%>
		});
		
		 $('#baseUrl').click(function() 
					{  
						 if($("#txtDeptCode").val().trim()=="")
						{
							alert("Please Select Department... ");
							return false;
						} 
							window.open('attachDoc.html?transName=frmDepartmentMaster.jsp&formName=Member Profile&code='+$('#txtDeptCode').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
					});
		
		
</script>

</head>
<body>
	<div class="container masterTable">
		<label  id="formHeading">Department Master</label>
	  <s:form name="Dept" method="POST" action="saveDepartmentMaster.html?" >
	     <div class="row">
			<!-- <div class="col-md-12" align="center" style="display:none"><a id="baseUrl"
					href="#"> Attach Documents</a>&nbsp; &nbsp; &nbsp;
						&nbsp;
			</div> -->
		
		<div class="col-md-5">
		   <div class="row">
			   <div class="col-md-5"><label>Department</label>
				   <s:input id="txtDeptCode" path="strDeptCode" cssClass="searchTextBox" style="height:50%" ondblclick="funHelp('deptCode')" />			
			   </div>
			   <div class="col-md-7"><label>Department Desc</label>
				   <s:input id="txtDeptDesc" path="strDeptDesc"/>				
			   </div>
		    </div>
		 </div>
		    
		  <div class="col-md-7"></div>
		  
			<div class="col-md-3" id="trEmail">
			      <label>Email Id</label>
				   <s:input id="txtEmailId" path="strEmailId"/>				
			</div>
			
			<div class="col-md-2" id="trMobile">
			      <label>Mobile No</label>
				  <s:input id="txtMobileNo" path="strMobileNo"/>				
			</div>
			 <div class="col-md-1"><label>Operational</label>
			     <s:select id="cmbOperational" path="strOperational">
				    <option selected="selected" value="Y">Yes</option>			           
			        <option value="N">No</option>
		         </s:select>
			</div>
			
			<div class="col-md-1"><label>Discount</label>
			     <s:select id="cmbDiscount" path="strDiscount">
				    <option selected="selected" value="Y">Yes</option>
			        <option value="N">No</option>
		         </s:select>
			</div>
			
			<div class="col-md-1"><label>Deactivate</label>
			     <s:select id="cmdDeactivate" path="strDeactivate">
				    <option selected="selected" value="N">No</option>
			        <option value="Y">Yes</option>
		         </s:select>
			</div>
			
			<div class="col-md-1"><label>Type</label>
			<s:select id="cmbType" path="strType">
				    <option selected="selected" value="Y">Yes</option>			           
			        <option value="N">No</option>
		         </s:select>
			</div>
			
			<div class="col-md-1"><label style="width:171%">Revenue Producing</label>
			     <s:select id="cmbRevenueProducing" path="strRevenueProducing">
				    <option selected="selected" value="Y">Yes</option>			           
			        <option value="N">No</option>
		         </s:select>
			</div>
			
		</div>
		
		<br />
		<p align="center" style="margin-right:31%;">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" onclick="return funCallFormAction('submit',this);" />&nbsp;
            <input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" />           
		</p>
	</s:form>
	</div>
</body>
</html>
