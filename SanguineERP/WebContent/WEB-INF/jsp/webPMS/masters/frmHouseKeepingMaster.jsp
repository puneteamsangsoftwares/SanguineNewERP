<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<meta http-equiv="X-UA-Compatible" content="IE=8">

		<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 
	 	 
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>

<title></title>
<script type="text/javascript">
	var fieldName;
	
	var listOfHouseKeep=${command.jsonArrHouseKeeping};
	$(function() 
	{

		$.each(listOfHouseKeep, function(i, obj) 
		{
		  
			funHouseKeeping(obj.strRoomTypeCode,obj.strRoomTypeDesc);
		
		});
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

	function funSetData(code){

		switch(fieldName){
		
		case 'houseKeepCode' : 
			funSetHouseKeepData(code);
			break;
			

		}
	}
	
	
	function funSetHouseKeepData(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadHouseKeepData.html?houseKeepCode=" + code,
			dataType : "json",
			success: function(response)
	        {
				
	        	if(response.strBookingTypeCode=='Invalid Code')
	        	{
	        		alert("Invalid Agent Code");
	        		$("#txtBookingTypeCode").val('');
	        	}
	        	else
	        	{					        	    	        		
	        		$("#txtHouseKeepCode").val(response.strHouseKeepCode);
	        	    $("#txtHouseKeepName").val(response.strHouseKeepName);
	        	    $("#txtRemarks").val(response.strRemarks);
	        	    
	        	    var roomTypeCode=response.strRoomTypeCode.split(",");
	        	  
	        	    var table=document.getElementById("tblRoom");
	        		var rowCount=table.rows.length;
	        		
	        		if(rowCount>0)
	        		{
	        		    for(var i=0;i<rowCount;i++)
	        		    {
	        		    	var roomType=table.rows[i].cells[0].innerHTML;
	        		        roomType=$(roomType).val();
	        		    	for(var j=0;j<roomTypeCode.length;j++)
	        		    	{
	        		    	var roomType1=roomTypeCode[j];
	        		    	if(roomType==roomType1)
	        		       		{
	        		    		document.getElementById("strIsRoomTypeSelected."+i).checked=1;
	        		       		}
	        		       	
	        		    	}
	        		    }
	        		}
	              	
	        	}
			},
			error: function(jqXHR, exception) 
			{
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



	 function funHouseKeeping(strRoomTypeCode,strRoomTypeDesc){
	 		
	 		var table=document.getElementById("tblRoom");
	 		var rowCount=table.rows.length;
	 		var row=table.insertRow();
	 		row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box payeeSel\"  style=\"padding-left: 5px;width: 70%;\" name=\"listOfHouseKeeping["+(rowCount)+"].strHouseKeepCode\" id=\"strHouseKeepCode."+rowCount+"\"value='"+strRoomTypeCode+"' >";
	 		row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 5px;width: 100%;margin-left: 14%;\" name=\"listOfHouseKeeping["+(rowCount)+"].strHouseKeepName\"  id=\"strHouseKeepName."+rowCount+"\" value='"+strRoomTypeDesc+"' >";
	 	    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" type=\"checkbox\"  class=\"Box payeeSel\"  style=\"padding-left: 5px;width: 170%;\" name=\"listOfHouseKeeping["+(rowCount)+"].strIsRoomTypeSelected\" onClick=\"Javacsript:funCheckHouseKeeping("+rowCount+")\"  id=\"strIsRoomTypeSelected."+rowCount+"\" value='N' >"; 
	 	    
	 	}

	 function funCheckHouseKeeping(count)
	 	{
	 		
	 		var no=0;
	 		$('#tblRoom tr').each(function() {
	 			
	 			if(document.getElementById("strIsRoomTypeSelected."+no).checked == true)
	 			{
	 				document.getElementById("strIsRoomTypeSelected."+no).value='Y';
	 			
	 			}
	 			else
	 			{
	 			 document.getElementById("strIsRoomTypeSelected."+no).value='N';
	 			}
	 			no++;
	 		});
	 	  }


	function funHelp(transactionName)
	{
		fieldName=transactionName;
		window.open("searchform.html?formname="+transactionName+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
	}
	
	function funHouseKeepRoomType()
	{
		var table = document.getElementById("tblRoom");
		var rowCount = table.rows.length;	
		if ($('#chkHouseKeepingStatus').is(":checked"))
		{
			for(var i=0;i<rowCount;i++)
			{		
			document.getElementById("strIsRoomTypeSelected."+i).checked=1;
			document.getElementById("strIsRoomTypeSelected."+i).value='Y';
	    	}
		}
		else
		{				
			for(var i=0;i<rowCount;i++)
			{		
				document.getElementById("strIsRoomTypeSelected."+i).checked=0;
				document.getElementById("strIsRoomTypeSelected."+i).value='N';
	    	}
			
		}
	 
	}
	 
	/**
     * Reset from
    **/
	function funResetFields()
	{
		location.reload(true); 
	}
</script>

</head>
<body>

	<div class="container">
		<label id="formHeading">Housekeeping Master</label>
		<s:form name="HouseKeepingMaster" method="POST" action="saveHouseKeepingMaster.html">

		<div class="row masterTable">
			<div class="col-md-2">
				<label>Housekeeping Code</label>
				<s:input colspan="3" type="text" id="txtHouseKeepCode" path="strHouseKeepCode" cssClass="searchTextBox" ondblclick="funHelp('houseKeepCode')" />
			</div>
			<div class="col-md-2">
				<label>Housekeeping Name</label>
				<s:input colspan="3" type="text" id="txtHouseKeepName" path="strHouseKeepName"  />
			</div>
			<div class="col-md-2">
				<label>Description</label>
				<s:input colspan="3" type="text" id="txtRemarks" path="strRemarks"  />
			</div>
		</div>
		
		  <div class="dynamicTableContainer" style="height: 400px;width:57%;">
			<table style="width: 100%; border: #0F0; table-layout: fixed;height: 10%;" class="transTablex col15-center">
				<tr bgcolor="#c0c0c0">
					<td width="20%">Room Type Code</td>
					<td width="40%" style="text-align:center">Room Description</td>
					<td style="width:30%;padding:5px;float: right;">Select All<br>
	    				<input type="checkbox" id="chkHouseKeepingStatus" name="chkBoxAll1" value="Bike" style="margin-left: 10px;" onclick="funHouseKeepRoomType()">
					</td>
				</tr>
			</table>
			
			<div style="background-color: #fbfafa; border: 1px solid #ccc; display: block; height: 337px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
				<table id="tblRoom" style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll" class="transTablex col9-center">
					<tbody>
						<!-- col1   -->
						<col style="width: 80px">
						<!-- col1   -->
						<!-- col1   -->
						
						<!-- col2   -->
						<col style="width: 118px;">
						<!-- col2   -->
						
						<!-- col3   -->
						<col style="width: 85px;">
						<!-- col3   -->
					</tbody>
				</table>
			</div>
		</div> 
		
	
		
		<div class="center" style="margin-right:52%;">
		   <!--  <input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" "/>&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()" /> -->
			 <a href="#"><button class="btn btn-primary center-block" value="Submit" 
				class="form_button">Submit</button></a>&nbsp;
			<a href="#"><button class="btn btn-primary center-block" value="Reset" onclick="funResetFields()"
				class="form_button">Reset</button></a> 
		</div>
	</s:form>
</div>
</body>
</html>
