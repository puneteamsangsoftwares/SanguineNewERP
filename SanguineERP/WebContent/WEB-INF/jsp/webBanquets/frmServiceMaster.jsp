<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>
<script type="text/javascript">
	var fieldName;
    
	function funResetFields()
	{
		$("#txtServiceName").focus();
    }
	
	

function funSetData(code){

		switch(fieldName){

			case 'ServiceMaster' :{
				funSetServiceName(code);
				break;
		     }
			case 'deptCode' : {
				funSetDepartmentData(code);
				break;
			}
			
		}
	}



	function funSetServiceName(code)
	{
		$("#txtServiceCode").val(code);
		var searchurl=getContextPath()+ "/loadServiceMasterData.html?serviceCode=" + code;
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",
			success : function(response)
			{ 
				if(response.strServiceCode=='Invalid Code')
	        	{
	        		alert("Invalid Service Code");
	        		$("#txtServiceCode").val('');
	        	}
				else
				{
					$("#txtServiceCode").val(response.strServiceCode);
	        		$("#txtServiceName").val(response.strServiceName);
	        		//$("#txtOperational").val(response.strOperationalYN);
	        		$("#txtDeptCode").val(response.strDeptCode);
	        		$("#txtRate").val(response.dblRate);
	        		document.getElementById("txtOperational").checked = response.strOperationalYN == 'Yes' ? true
							: false;
	        		
	        		if (response.strOperationalYN == 'Y') {
						$("#txtOperational").prop('checked',
								true);
					} else
						$("#txtOperational").prop('checked',
								false);
	        		
	        		$("#cmbTaxIndicator").val(response.strTaxIndicator);
				}
			},
			error : function(jqXHR, exception){
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

	 function funSetDepartmentData(code)
		{
			$.ajax({
				type : "GET",
				url : getContextPath()+ "/loadDeptMasterData.html?deptCode=" + code,
				dataType : "json",
				success : function(response){ 
					if(response.strDeptCode=='Invalid Code')
		        	{
		        		alert("Invalid Department Code");
		        		$("#txtDeptCode").val('');
		        	}
		        	else
		        	{
		        		$("#txtDeptCode").val(response.strDeptCode);
		        		$("#lblDepartmentName").text(response.strDeptDesc);
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





	function funHelp(transactionName)
	{
		fieldName=transactionName;
		//window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
        window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")	
	}
</script>

</head>
<body>
    <div class="container masterTable">
	<label id="formHeading">Service Master</label>
	  <s:form name="ServiceMaster" method="POST" action="saveServiceMaster.html">

		<div class="row">
          
			<div class="col-md-2"><label>Service Code</label>
				   <s:input type="text" id="txtServiceCode" path="strServiceCode" cssClass="searchTextBox jQKeyboard form-control" ondblclick="funHelp('ServiceMaster')" />
			</div>
	
			<div class="col-md-2"><label>Service Name</label>
				   <s:input type="text" id="txtServiceName" path="strServiceName"/>
			</div>
		    <div class="col-md-8"></div>
		    
			<div class="col-md-2"><label>Operational Y/N</label><br>
				<s:checkbox path="strOperationalYN" id="txtOperational" value="Y" />
			</div>	
				<%-- <td ><s:checkbox value="true" path="strOperationalYN"  id="txtOperational"  /> --%>
			
			<div class="col-md-2"><label>Service Type</label>
                  <s:select id="cmbServiceType" path="strServiceType"  style="width:100px;">
                         <s:option value="Internal">Internal</s:option>
                         <s:option value="External">External</s:option>
                  </s:select>
             </div>
            <div class="col-md-8"></div>
            
			<div class="col-md-2"><label>Department Code</label>
				<s:input type="text" id="txtDeptCode" path="strDeptCode"  readonly="true" cssClass="searchTextBox jQKeyboard form-control" ondblclick="funHelp('deptCode')" style="background-color:#fff;"/>
			    <label id="lblDepartmentName"></label>		
			</div>
			
			<div class="col-md-1"><label>Rate</label>
				   <s:input type="text" id="txtRate" path="dblRate" cssClass="decimal-places numberField" style="text-align:right;"/>
		
				<!-- <td><label >Weight</label></td> -->
				<%--  <td><s:input id="txtWeight" name="weight" path="dblWeight" cssClass="decimal-places numberField"/></td> --%>
			</div>
			
			<div class="col-md-1"><label style="width:122%;">Tax Indicator</label>
				<s:select id="cmbTaxIndicator" name="taxIndicator" path="strTaxIndicator" items="${taxIndicatorList}"/>
			</div>
		</div>
		
		<br />
		<p align="center" style="margin-right:49%;">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" />
			&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>

	</s:form>
	</div>
</body>
</html>
