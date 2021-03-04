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

<title></title>

<script type="text/javascript">
	
	var fieldName,checkOutParam;
	var returnValue=false;;
	
	function funValidateData()
	{
		var table=document.getElementById("tblRoomDtl");
		var rowCount=table.rows.length;
		if(rowCount>0)
		{
			return true;
		}
		else
		{
			alert("Please Select Guest.");
			return false;
		}
		return returnValue;
	}
	
	function funPrintData()
	{
		var table=document.getElementById("tblRoomDtl");
		var rowCount=table.rows.length;
		if(rowCount>0)
		{
			var code = $("#txtGuestCode").val();
			
			window.open(getContextPath()+"/printGuestFeedback.html?guestCode="+code,'_blank');
			return false;
		}
		else
		{
			alert("Please Select Guest.");
			return false;
		}
		return returnValue;
	}
	
	
	function funResetFields()
	{
		$('#tblRoomDtl tbody > tr').remove();
		$("#strSearchTextField").val('');
		return false;
	}
	
	
	function fillTableRow(index,obj)
	{
		var table=document.getElementById("tblRoomDtl");
		var rowCount=table.rows.length;
		var row=table.insertRow();
		var guestCode = $("#txtGuestCode").val();
		var feedbackCode = $("#txtFeedback").val(); 
	   
 	    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"width: 100%;\"  value='"+obj.strFeedbackDesc+"' >";
        row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box \" hidden=hidden style=\"width: 1px%;\" name=\"listBean["+(rowCount)+"].strGuestCode\" id=\"strGuestCode."+(rowCount)+"\"  value='"+guestCode+"' >";
		if(obj.strExcellent.includes("Y"))
			{
				row.insertCell(2).innerHTML= "<input readonly=\"readonly\" type=\"checkbox\" checked=\"checked\" style=\"width: 100%;\" name=\"listBean["+(rowCount)+"].strExcellent\" id=\"strExcellent."+(rowCount)+"\"  value='Y' >";		
			}
		else
			{
			row.insertCell(2).innerHTML= "<input readonly=\"readonly\" type=\"checkbox\"  style=\"width: 100%;\" name=\"listBean["+(rowCount)+"].strExcellent\" id=\"strExcellent."+(rowCount)+"\"  value='Y' >";
			}
        
		
		if(obj.strGood.includes("Y"))
		{
			row.insertCell(3).innerHTML= "<input readonly=\"readonly\" type=\"checkbox\" checked=\"checked\"  style=\"width: 100%;   text-align: right;\" name=\"listBean["+(rowCount)+"].strGood\" id=\"strGood."+(rowCount)+"\"  value='Y' >";		
		}
	else
		{
		row.insertCell(3).innerHTML= "<input readonly=\"readonly\" type=\"checkbox\"  style=\"width: 100%;   text-align: right;\" name=\"listBean["+(rowCount)+"].strGood\" id=\"strGood."+(rowCount)+"\"  value='Y' >";
		}
		
		if(obj.strFair.includes("Y"))
		{
			row.insertCell(4).innerHTML= "<input readonly=\"readonly\" type=\"checkbox\" checked=\"checked\" style=\"width: 100%;\" name=\"listBean["+(rowCount)+"].strFair\" id=\"strFair."+(rowCount)+"\"  value='Y' >";		
		}
	else
		{
			row.insertCell(4).innerHTML= "<input readonly=\"readonly\" type=\"checkbox\"  style=\"width: 100%;\" name=\"listBean["+(rowCount)+"].strFair\" id=\"strFair."+(rowCount)+"\"  value='Y' >";
		}
		
		if(obj.strPoor.includes("Y"))
		{
			row.insertCell(5).innerHTML= "<input readonly=\"readonly\" type=\"checkbox\" checked=\"checked\"  style=\"width: 100%;\" name=\"listBean["+(rowCount)+"].strPoor\" id=\"strPoor."+(rowCount)+"\"  value='Y' >";		
		}
	else
		{
			row.insertCell(5).innerHTML= "<input readonly=\"readonly\" type=\"checkbox\"  style=\"width: 100%;\" name=\"listBean["+(rowCount)+"].strPoor\" id=\"strPoor."+(rowCount)+"\"  value='Y' >";
		}
		row.insertCell(6).innerHTML= "<input  type=\"text\" style=\"text-align:left;\"  style=\"width: 100%;\" name=\"listBean["+(rowCount)+"].strRemark\" id=\"strRemark."+(rowCount)+"\" value='' >";
 	    row.insertCell(7).innerHTML= "<input readonly=\"readonly\" type=\"hidden\"  style=\"width: 100%;\" name=\"listBean["+(rowCount)+"].strFeedbackCode\" id=\"strFeedbackCode."+(rowCount)+"\" value='"+obj.strFeedbackCode+"' >";
 	    row.insertCell(8).innerHTML= "<input readonly=\"readonly\" type=\"hidden\"  style=\"width: 100%;\" name=\"listBean["+(rowCount)+"].strGuestFeedbackCode\" id=\"strGuestFeedbackCode."+(rowCount)+"\" value='"+feedbackCode+"' >";

 	    
		//row.insertCell(8).innerHTML= "<input readonly=\"readonly\" type=\"checkbox\"  class=\"Box payeeSel\"  style=\"padding-left: 5px;width: 100%;\" name=\"listBean["+(rowCount)+"].strRemoveTax\" id=\"strRemoveTax."+(rowCount)+"\" value='Y' >";

	}
	
	
	
	
	

	
	/* set date values */
	function funSetDate(id,responseValue)
	{

		switch(fieldName)
		{
		   
			
		}
	
	}	
	
	function funSetGuestCode(code)
	{
		$("#txtGuestCode").val(code);
		funResetFields();
		
		var searchUrl=getContextPath()+"/loadAllFeedbacks.html?doccode="+code;
		$.ajax({
			
			url:searchUrl,
			type :"POST",
			dataType: "json",
	        success: function(response)
	        {
	 		   $.each(response, function(index,obj)
	 		   {
	 			  
	 			   fillTableRow(index,obj);
	 			  $("#lblGuestName").text(obj.strGuestName);
	 			   
	 		   });
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
	

	$(document).ready(function()
	{
		var message='';
		<%if (session.getAttribute("success") != null) 
		{
			if(session.getAttribute("successMessage") != null)
			{%>
				message='<%=session.getAttribute("successMessage").toString()%>';
			<%
			   	session.removeAttribute("successMessage");
			}
			boolean test = ((Boolean) session.getAttribute("success")).booleanValue();
			session.removeAttribute("success");
			if (test) 
			{
				%>
				/* alert("Data Save successfully\n\n"+message);
				var isCheckOk=confirm("Do you want to print the bill ?");
				if(isCheckOk){
				window.open(getContextPath() +"/frmBillPrinting.html",'_blank');
				} */
				
				
				<%
			}
		}%>
		
		
		
		
		
		 var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
		  var dte=pmsDate.split("-");
		  $("#txtPMSDate").val(dte[2]+"-"+dte[1]+"-"+dte[0]);
	});

	
	
	/**
		* Success Message After Saving Record
	**/

	function funSetData(code)
	{
		switch(fieldName)
		{
			case "checkInRooms":
			 	funSetRoomMasterData(code);
			 	break;
			 	
			case "billno":
			 	funSetRoomMasterData(code);
			 	break;
			 	
			case "groupcheckOut":
				funSetGroupCheckOutData(code);
			 	break;
			 	
			case 'guestCode' : 
				   funSetGuestCode(code);
					break;
					
			case 'guestFeedback' : 
				   funSetFeedbackCode(code);
					break;
			 	
		}
	}
		function funSetFeedbackCode(code)
		{
			$("#txtFeedback").val(code);
			funResetFields();
			var searchUrl=getContextPath()+"/frmPMSGuestFeedback1.html?doccode="+code;
			$.ajax({
				
				url:searchUrl,
				type :"POST",
				dataType: "json",
		        success: function(response)
		        {
		 		   $.each(response, function(index,obj)
		 		   {
		 			   fillTableRow(index,obj);
		 		   });
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
		
	
	function funHelp(transactionName)
	{
		fieldName=transactionName;
		window.open("searchform.html?formname="+transactionName+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
		//window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
	function funTaxOnTaxStateChange()
	{
		$("#chkExtraTimeCharges").val("Y");
		if($("#chkExtraTimeCharges").val()=="Y")
			{
			 $("#txtExtraCharge").attr("visibility", "visible"); 
			}
	}
	
	function isNumber(evt) {
        var iKeyCode = (evt.which) ? evt.which : evt.keyCode
        if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57))
            return false;

        return true;
    }
	
	
	
	function funCheckbox()
	{
		var table = document.getElementById("tblRoomDtl");
		var rowCount = table.rows.length;	
		if ($('#chkBoxAll').is(":checked"))
		{
		 	//check all			
			for(var i=0;i<rowCount;i++)
			{		
				//$("strRemoveTax.1").checked=true;
				document.getElementById("strRemoveTax."+i).checked=1;
				//$('strRemoveTax.1').prop('checked', true);
	    	}
		}
		else
		{
			//uncheck all
			//$("#chkBoxAll").prop('checked',false);				
			for(var i=0;i<rowCount;i++)
			{		
				document.getElementById("strRemoveTax."+i).checked=0;
	    	}
			
		}
		
	   
	}
	
	
</script>

</head>
<body  onload="funOnload();">

	<div class="container">
		<label id="formHeading">Feedback form</label>
		<s:form name="frmCheckOut" method="POST" action="savePMSGuestFeedback.html">
			<div class="row masterTable" style="padding-top:15px;">
					
			<%-- 	<div class="col-md-2">
					<label>GuestFeedback Code</label>
					<s:input id="txtFeedback" path="strGuestFeedbackCode" readonly="true" cssClass="searchTextBox" ondblclick="funHelp('guestFeedback')"/>
				</div> --%>
				
				<div class="col-md-2">
					<label>Guest Code</label>
					<s:input id="txtGuestCode" path="strGuestCode" readonly="true" cssClass="searchTextBox" ondblclick="funHelp('guestCode')"/>
					
					<label id="lblGuestName"></label>
				</div>
			</div> 
	
		<br />
		
		
		<div class="dynamicTableContainer" style="height: 200px;">
			<table style="height: 28px; border: #0F0; width: 100%;font-size:11px; font-weight: bold;">
				<tr bgcolor="#c0c0c0" style="height: 24px;">
					<!-- col1   -->
					<td  style="width: 50px;" align="center">Feedback</td>
					<!-- col1   -->
					
					<!-- col2   -->
					<!-- <td  style=" width:55px;" align="center">Guest Code</td> -->
					<!-- col2   -->
					
					<!-- col2   -->
					<td  style=" width:60px;" align="center">Excellent</td>
					<!-- col2   -->
					
					<!-- col3   -->
					<td style="width: 60px;" align="center">Good</td>
					<!-- col3   -->
					
					<!-- col4   -->
					<td style="width: 60px;" align="center">Fair</td>
					<!-- col4   -->
					
					<!-- col5   -->
					<td  style="width: 2px;"align="center" >Poor</td>
					<!-- col5   -->
					
					<!-- col6  -->
					<td  style="width: 175px;"align="center">Remark</td>
					<!-- col6  -->
					
					
									
				</tr>
			</table>
			<div style="background-color: #fbfafa; border: 1px solid #ccc; display: block; height: 200px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
				<table id="tblRoomDtl" style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll" class="transTablex col9-center">
					<tbody>
						<!-- col1   -->
						<col style="width: 100%;">
						<!-- col1   -->
						
						<!-- col2   -->
						<col  style="width: 1%;" >
						<!-- col2   -->
					
						<!-- col2   -->
						<col  style="width: 100%;" >
						<!-- col2   -->
						
						
						<!-- col3   -->
						<col style="width: 100%;">
						<!-- col3   -->
						
						<!-- col4   -->
						<col style="width: 100%;">
						<!-- col4   -->
						
						<!-- col5   -->
						<col style="width: 100%;" >
						<!-- col5   -->
						
						<!-- col6   -->
						<col style="width: 200%;">
						<!-- col6   -->
						
										
					</tbody>
					<%-- <c:forEach items="${command.listReqDtl}" var="reqdtl"
						varStatus="status">
						<tr>
							<td><input name="listReqDtl[${status.index}].strProdCode"
								value="${reqdtl.strProdCode}" /></td>
							<td>${reqdtl.strPartNo}</td>
							<td>${reqdtl.strProdName}</td>
							<td><input name="listReqDtl[${status.index}].dblQty"
								value="${reqdtl.dblQty}" /></td>
							<td><input name="listReqDtl[${status.index}].dblUnitPrice"
								value="${reqdtl.dblUnitPrice}" /></td>
							<td><input name="listReqDtl[${status.index}].dblTotalPrice"
								value="${reqdtl.dblTotalPrice}" /></td>
							<td><input name="listReqDtl[${status.index}].strRemarks"
								value="${reqdtl.strRemarks}" /></td>
							<td><input type="Button" value="Delete" class="deletebutton"
								onClick="Javacsript:funDeleteRow(this)" /></td>
						</tr>

					</c:forEach> --%>
				</table>
			</div>
		</div>
		<!-- Generate Dynamic Table   -->
		
		<br />
		<br />
		<div class="center">
			<a href="#"><button class="btn btn-primary center-block" value="Submit" onclick="return funValidateData()"
				class="form_button">Submit</button></a> 
			 <!--  <button type="button" class="btn btn-primary center-block" id="btnSubmit"  value="Submit" onclick="return funValidateData()">Submit</button> --> 
				
			<a href="#"><button class="btn btn-primary center-block" value="Print" onclick="return funPrintData()"
				class="form_button">Print</button></a> 
				
			 <a href="#"><button class="btn btn-primary center-block" value="Reset" onclick="return funResetFields()"
				class="form_button">Reset</button></a> 
			   
		</div>
	</s:form>
</div>
</body>
</html>
