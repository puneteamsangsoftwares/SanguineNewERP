<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Floor Master</title>
    <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
<script type="text/javascript">


        var fieldName="";
		/**
		* Open Help
		**/
		
		function funHelp(transactionName)
		{
			fieldName=transactionName;
			window.open("searchform.html?formname="+transactionName+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
		    //window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
		}
		
		
		function funSetData(code)
		{
			switch(fieldName){
			
				case "package":
					funSetPackageNo(code);
				break;
				
				case "incomeHead":
					funSetIncomeHead(code);
				break;
			}
			
		}
		
		/**
		* Success Message After Saving Record
		**/
		$(document).ready(function()
		{
			var message='';
			<%if (session.getAttribute("success") != null) {
				if (session.getAttribute("successMessage") != null) {%>
				            message='<%=session.getAttribute("successMessage").toString()%>';
				            <%session.removeAttribute("successMessage");
				}
				boolean test = ((Boolean) session.getAttribute("success"))
						.booleanValue();
				session.removeAttribute("success");
				if (test) {%>	
				alert("Data Save successfully\n\n"+message);
			<%}
			}%>

		});
	
		function funCallFormAction(actionName,object) 
		{
			var flg=true;
			if($('#txtFloorName').val()=='')
			{
				 alert('Enter Floor Name');
				 flg=false;
				  
			}
			return flg;
		}
		
		function funSetPackageNo(code){

			$.ajax({
				type : "GET",
				url : getContextPath()+ "/loadPackageDataFromMaster.html?docCode=" + code,
				dataType : "json",
				success : function(response)
				{ 
					if(response.strPackageCode!="Invalid")
			    	{
						$("#txtPackageCode").val(response.strPackageCode);
						$("#txtPackageName").val(response.strPackageName);
						$("#txtIncomeHeadCode").val(response.strIncomeHeadCode);
						$("#txtIncomeHeadName").val(response.strIncomeHeadName);
						$("#txtPackageAmt").val(response.strPackageAmount);
						$("#txtPackageInclusiveRoomTerrif").prop('checked', false);
						if(response.strPackageInclusiveRoomTerrif =='Y')
						{
							$("#txtPackageInclusiveRoomTerrif").prop('checked', true);
						}
			    	}
			    	else
				    {
				    	alert("Invalid Package No");				    	
				    	return false;
				    }
					
				},
				error : function(e){
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
		
		function funSetIncomeHead(code)
		{
			$("#txtIncomeHeadCode").val(code);
			var searchurl=getContextPath()+"/loadIncomeHeadMasterData.html?incomeCode="+code;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strIncomeHeadCode=='Invalid Code')
				        	{
				        		alert("Invalid Income Head Code");
				        		$("#txtIncomeHeadCode").val('');
				        	}
				        	else
				        	{
				        		funfillIncomHeadGrid(response);
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
		
		function funfillIncomHeadGrid(data){
			
			$("#txtIncomeHeadCode").val(data.strIncomeHeadCode);
			$("#txtIncomeHeadName").val(data.strIncomeHeadDesc);
		}
		
		function funPackageInclusiveRoomTerrif()
		{
			var isSelected=$("#txtPackageInclusiveRoomTerrif").prop('checked');
			if(isSelected==true)
			{
				$("#txtPackageInclusiveRoomTerrif").val("Y");				
			}
			else
			{
				$("#txtPackageInclusiveRoomTerrif").val("N");				
			}
		}
		
	</script>

</head>
<body>
    <div class="container masterTable">
	   <label id="formHeading">Package Master</label>
	   <s:form name="PackageMaster" method="GET" action="savePackageMaster.html?">
         <div class="row">
            <div class="col-md-2"><label>Package Code</label>
				     <s:input id="txtPackageCode" type="text" path="strPackageCode"
						cssClass="searchTextBox" ondblclick="funHelp('package')" style="height: 45%;"/>
			</div>

			<div class="col-md-2"><label>Package Name</label>
				    <s:input id="txtPackageName" path="strPackageName"/>
			</div>
			 </div>
			   <div class="row">
			<div class="col-md-2"><label>Income Head Code</label>
				     <s:input id="txtIncomeHeadCode" type="text" path="strIncomeHeadCode"
						cssClass="searchTextBox" ondblclick="funHelp('incomeHead')" style="height: 45%;"/>
			</div>
			<div class="col-md-2"><label>Income Head Name</label>
				     <s:input id="txtIncomeHeadName" type="text" path="strIncomeHeadName"
						/>
			</div>
			
			 <div class="col-md-1"><label>Amount</label>
				      <s:input id="txtPackageAmt" path="strPackageAmount" style="text-align:right;width:91px;"
						/>
			 </div>
			 <div class="col-md-3">
							<label style="margin-left: 6%;">Package Inclusive Room Terrif</label><br>
							<s:checkbox id="txtPackageInclusiveRoomTerrif"  value="N" path="strPackageInclusiveRoomTerrif" style="margin-top: 2%;margin-left: 6%;" onclick="funPackageInclusiveRoomTerrif()"/>
						</div>	
         </div>
          <br />
		<p align="center" style="margin-right: 31%;">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button"
				onclick="return funCallFormAction('submit',this);" />&nbsp; 
				<input type="reset" value="Reset" class="btn btn-primary center-block"  class="form_button" />
		</p>
      </s:form>
      </div>
</body>
</html>