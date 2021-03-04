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
		
		$("#strOperational").attr('checked', true);
	});

	function funValidate(data)
	{
		var flg=true;
		if($("#txtBanquetName").val().trim().length==0)
		{
			alert("Please Enter Name !!");
			 flg=false;
		}
		else if($("#txtBanquetTypeCode").val().trim().length==0)
		{
			alert("Please Select Booking Type !!");
			 flg=false;
		}
		
		
		return flg;
	}
	
	function funSetData(code){

		switch(fieldName){

		case 'banquetCode' : 
			funSetBanquetName(code);
			break;
		case 'banquetTypeCode' : 
			funSetBanquetTypeName(code);
			break;

		
		
		
		}
	}


	function funSetBanquetName(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadBanquetName.html?docCode=" + code,
			dataType : "json",
			success : function(response){ 

				if(response.strEquipmentCode=='Invalid Code')
	        	{
	        		alert("Invalid Equipment No");
	        		$("#txtEquipmentCode").val('');
	        	}
	        	else
	        	{
	        		if(response.strOperational=='Y')
		        	{
		        		document.getElementById("strOperational").checked = response.strOperational == 'Y' ? true: false;
		        	}
	        		else
		        	{
		        		$("#strOperational").attr('checked', false);
		        		
		        	}
	        		$("#txtBanquetCode").val(response.strBanquetCode);
	        		$("#txtBanquetName").val(response.strBanquetName);
	        		$("#txtBanquetTypeCode").val(response.strBanquetTypeCode);
	        		if(response.strOperational=='Y')
		        	{
		        		document.getElementById("strOperational").checked = response.strOperational == 'Y' ? true: false;
		        	}
	        		else
		        	{
		        		$("#strOperational").attr('checked', false);
		        		
		        	}
	        		
	        	}
			},
			error : function(e){

			}
		});
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
	        		
	        		$("#txtBanquetTypeCode").val(response.strBanquetTypeCode);
	        		
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
	<label id="formHeading">Banquet Master</label>
	  <s:form name="BanquetMaster" method="POST" action="saveBanquetMaster.html">

		 <div class="row">
          
			<div class="col-md-2"><label>Banquet Code</label>
				   <s:input type="text" id="txtBanquetCode" path="strBanquetCode" ondblclick="funHelp('banquetCode')" cssClass="searchTextBox jQKeyboard form-control" />
			</div>
		
			<div class="col-md-2"><label>Banquet Name</label>
				   <s:input type="text" id="txtBanquetName" path="strBanquetName"/>
			</div>
			<div class="col-md-8"></div>
			
			<div class="col-md-2"><label>Banquet Type Code</label>
				   <s:input  type="text" id="txtBanquetTypeCode" path="strBanquetTypeCode" ondblclick="funHelp('banquetTypeCode')" cssClass="searchTextBox jQKeyboard form-control" />
			</div>
			
			<div class="col-md-2"><label>Operational</label><br>
				   <s:checkbox id="strOperational" path="strOperational" value="Y"/>
			</div>
		</div>

		<br />
		<p align="center" style="margin-right: 49%;">
			<input type="submit" value="Submit" tabindex="3" onclick="return funValidate(this)" class="btn btn-primary center-block" class="form_button" />
			&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>

	</s:form>
	</div>
</body>
</html>
