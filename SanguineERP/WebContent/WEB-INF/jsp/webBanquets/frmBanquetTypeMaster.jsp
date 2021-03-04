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

	$(function() 
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

	function funValidate(data)
	{
		var flg=true;
		if($("#txtBanquetTypeName").val().trim().length==0)
			{
			alert("Please Enter Name !!");
			 flg=false;
			 $("#txtBanquetTypeName").focus();
			}
		
		if($("#cmbTaxIndicator").val().trim().length==0)
		{
		alert("Please Select Tax Indicator !!");
		 flg=false;
		 $("#cmbTaxIndicator").focus();
		}
		
		
		return flg;
	}
	
	function funSetData(code){

		switch(fieldName){
		
		case 'banquetTypeCode' : 
			funSetBanquetTypeName(code);
			break;

		}
	}


	function funSetBanquetTypeName(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadBanquetType.html?docCode=" + code,
			dataType : "json",
			success : function(response){ 

				if(response.strEquipmentCode=='Invalid Code')
	        	{
	        		alert("Invalid Equipment No");
	        		$("#txtBanquetTypeCode").val('');
	        	}
	        	else
	        	{
	        		
	        		$("#txtBanquetTypeName").val(response.strBanquetTypeName);
	        		$("#txtBanquetTypeCode").val(response.strBanquetTypeCode);
	        		$("#txtRate").val(response.dblRate);
	        		$("#cmbTaxIndicator").val(response.strTaxIndicator);
	        	}
			},
			error : function(e){

			}
		});
	}








	function funHelp(transactionName)
	{
		fieldName=transactionName;
		window.open("searchform.html?formname="+fieldName+"&searchText=", 'window', 'width=600,height=600');
	}
</script>

</head>
<body>

	<div class="container masterTable">
	<label id="formHeading">Banquet Type Master</label>
	     <s:form name="Banquet Type Master" method="POST" action="saveBanquetTypeMaster.html">

	 <div class="row">
          
				 <div class="col-md-2"><label>Banquet Type Code</label>
				      <s:input type="text" id="txtBanquetTypeCode" path="strBanquetTypeCode" ondblclick="funHelp('banquetTypeCode')" cssClass="searchTextBox jQKeyboard form-control" />
				 </div>
			
			     <div class="col-md-2"><label>Banquet Type Name</label>
				       <s:input style="width:60%;" type="text" id="txtBanquetTypeName" path="strBanquetTypeName"/>
				 </div>
	             <div class="col-md-8"></div>
	             
			     <div class="col-md-1"><label>Rate</label>
				       <s:input type="number" style="text-align:right;height: 45%;" step="0.01" id="txtRate" path="dblRate"/>
				</div>
		
			    <div class="col-md-1"><label style="width:122%;">Tax Indicator</label>
				       <s:select id="cmbTaxIndicator" name="taxIndicator" path="strTaxIndicator" items="${taxIndicatorList}"/>
			     </div>
		     </div>

		<br />
		<p align="center" style="margin-right: 60%;">
			<input type="submit" value="Submit" tabindex="3" onclick="return funValidate(this)" class="btn btn-primary center-block" class="form_button" />
			&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>

	</s:form>
	</div>
</body>
</html>
