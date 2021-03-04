<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta http-equiv="X-UA-Compatible" content="IE=8">
<title></title>

		<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />	
	 	
	 	<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
	 	<script type="text/javascript" src="<spring:url value="/resources/js/Accordian/jquery.multi-accordion-1.5.3.js"/>"></script>	
	
	 
	 <script type="text/javascript">
	var fieldName;
	//var garray=[];
	var gmap = new Map(); 
	$(document).ready(function()
			{
	var message='';
	var groupCode='';
	<%if (session.getAttribute("success") != null) {
		            if(session.getAttribute("successMessage") != null){%>
		            message='<%=session.getAttribute("successMessage").toString()%>';
		            groupCode='<%=session.getAttribute("GroupCodeAndRoomCode").toString()%>';
		            
		            <%
		            session.removeAttribute("successMessage");
		            session.removeAttribute("GroupCodeAndRoomCode");
		            }
					boolean test = ((Boolean) session.getAttribute("success")).booleanValue();
					session.removeAttribute("success");
					if (test) {
					%>	
		alert("Data Save successfully\n\n"+message);
		funOpenGroupBooking(groupCode);
	<%
	}}%>
	
});
	
	
	
$(document).ready(function(){
		
		var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
		
		$("#txtDob").datepicker({
			dateFormat : 'dd-mm-yy'
		});
		$("#txtDob").datepicker('setDate', pmsDate);

		
		
		$("#txtTravelDate").datepicker({
			dateFormat : 'dd-mm-yy'
		});
		$("#txtTravelDate").datepicker('setDate', pmsDate);
		
		
		 $("#txtCheckInDate").datepicker({
			dateFormat : 'dd-mm-yy'
		});
		/* $("#txtCheckInDate").datepicker('setDate', pmsDate); */
		
		
		$("#txtCheckoutDate").datepicker({
			dateFormat : 'dd-mm-yy'
		});
		/* $("#txtCheckoutDate").datepicker('setDate', pmsDate);  */
		
		$('#txtTravelTime').timepicker();
		
		$('#txtTravelTime').timepicker({
	        'timeFormat':'H:i:s'
		});
			
			$('#txtTravelTime').timepicker({
		        'timeFormat':'H:i:s'
		});
			
		$('#txtTravelTime').timepicker('setTime', new Date());
		funPayeeData();
		funRemoveProductRowsForIncomeHead();
	});
	
function funOpenGroupBooking(value) {
	window.opener.funSetGroupCode(value,gmap);
	window.close();
}
	
	function funHelp(transactionName)
	{
		fieldName=transactionName;
	//	window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	

	function funSetData(code){

		switch(fieldName){
		
			case 'guestCode' : 
				funSetGuestCode(code);
				break;
				
			case 'groupcode' : 
				funSetGroupCode(code);
				break;
				
			case 'CorporateCode' : 
				funSetCorporateCode(code);
				break;
				
			case "roomType":
				funSetRoomType(code);
				break;
				
			case "incomeHead":
				funSetIncomeHead(code);
				break;
		}
	}
	function funSetGuestCode(code){
		
		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadGuestCode.html?guestCode=" + code,
			dataType : "json",
			success : function(response){ 
				$("#txtGroupLeaderCode").val(code);
				$("#txtGroupLeaderName").val(response.strFirstName+" "+response.strMiddleName+" "+response.strLastName);
				$("#txtAddress").val(response.strAddress);
				$("#txtCity").val(response.strCity);
				$("#txtCountry").val(response.strCountry);
				$("#txtPin").val(response.intPinCode);	
				$("#txtPhone").val('');	
				$("#txtMobile").val(response.lngMobileNo);
				$("#txtFax").val(response.lngFaxNo);
				$("#txtEmail").val(response.strEmailId);
				$("#txtDob").val(response.dteDOB);
				$("#txtNationality").val(response.strNationality);
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


function funSetGroupCode(code){
		
		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadGroupCode.html?groupCode=" + code,
			dataType : "json",
			success : function(response){ 
				$("#txtGroupCode").val(code);
				$("#txtGroupName").val(response.strGroupName);	
				$("#txtDesignation").val(response.strDesignation);	
				
				
				$("#txtTravelDate").val(response.dteTravelDate);	
				$("#txtTravelTime").val(response.tmeTravelTime);	
				$("#txtPickupRequired").val(response.strPickupRequired);	
				
				
				$("#txtCheckInDate").val(response.dteCheckInDate);	
				$("#txtCheckoutDate").val(response.dteCheckoutDate);					
				$("#txtPax").val(response.strPax);	
				$("#txtSource").val(response.strSource);	
				$("#txtGuestType").val(response.strGuestType);	
				$("#txtExtraBed").val(response.strExtraBed);	
				$("#txtChild").val(response.strChild);	
				$("#txtInfant").val(response.strInfant);	
				$("#txtSalesChannel").val(response.strSalesChannel);	
				
				
				$("#txtRoomTaxes").val(response.strRoomTaxes);	
				$("#txtOtherTaxes").val(response.strOtherTaxes);	
				$("#txtServiceCharges").val(response.strServiceCharges);	
				$("#txtPayments").val(response.strPayments);	
				$("#txtDiscounts").val(response.strDiscounts);	
				
				$("#txtCard").val(response.strCard);	
				$("#txtCash").val(response.strCash);					
				funSetRoomType(response.strRoomType);
				funSetGuestCode(response.strGroupLeaderCode);
				funSetCorporateCode(response.strCompCode);
				funFillPayeeData(response.listPMSGroupBookingDtlModel);
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
	
function funSetCorporateCode(code){

	$.ajax({
		type : "GET",
		url : getContextPath()+ "/loadCorporateCode.html?corpcode=" + code,
		dataType : "json",
		success: function(response)
        {
			
        	if(response.strCorporateCode=='Invalid Code')
        	{
        		alert("Invalid Agent Code");
        		$("#txtCorporateCode").val('');
        	}
        	else
        	{					        	    	        		
        		$("#txtCompCode").val(response.strCorporateCode);
        		$("#txtCompName").val(response.strCorporateDesc);
        		$("#txtGICity").val(response.strCity);
        		$("#txtGIMobile").val(response.lngMobileNo);
        		$("#txtGIPhone").val(response.lngTelephoneNo);
        		$("#txtGIFax").val(response.lngFax);
        		
        		if(response.strBlackList=='Y')
		    	{
		    		document.getElementById("chkBlackList").checked=true;
		    	}
		    	else
		    	{
		    		document.getElementById("chkBlackList").checked=false;
		    	}
		    	
		    	if(response.strCreditAllowed=='Y')
		    	{
		    		document.getElementById("chkCreditAllowed").checked=true;
		    	}
		    	else
		    	{
		    		document.getElementById("chkCreditAllowed").checked=false;
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
	
function funSetRoomType(code){
	$("#txtRoomType").val(code);
	$.ajax({
		type : "GET",
		url : getContextPath()+ "/loadRoomTypeMasterData.html?roomCode=" + code,
		dataType : "json",
	    async:false,
		success : function(response){ 
			if(response.strAgentCode=='Invalid Code')
        	{
        		alert("Invalid Room Type");
        		$("#lblRoomType").text('');
        	}
        	else
        	{					        	    	        		
        		$("#txtRoomTypeDesc").val(response.strRoomTypeDesc);
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
	
			function funResetFields()
			{
				location.reload(true); 
			}
	
			function funPayeeData()
			{
								
				
				 var table=document.getElementById("tblPayeeDtl");
				 var rowCount=table.rows.length;
				 var service1="Room";
				 var service2="F&B";
				 var service3="Telephone";
				 var service4="Extras";
				 
				 var arr = ["Room", "F&B", "Telephone","Extras"];
				 for(var i=0;i<4;i++)
				{
					 
					 var row=table.insertRow();
					 var value="service"+(i+1);
					 
					 if(i==0)
					 {
						 row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-center: 5px;width:34%;\" name=\"listPMSGroupBookingDetailBean["+(i)+"].strRoom\"  id=\"dtDate."+(i)+"\" value='"+arr[i]+"' >";
				 	     row.insertCell(1).innerHTML= "<input type=\"radio\" style=\"text-align:right;width:34%;\" name=\"listPMSGroupBookingDetailBean["+(i)+"].strPayee\"  id=\"strPayee."+(i)+"\"\" value='Group Leader' checked >";
				 	     row.insertCell(2).innerHTML= "<input type=\"radio\" style=\"text-align:right;width:34%;\" name=\"listPMSGroupBookingDetailBean["+(i)+"].strPayee\"  id=\"strPayee."+(i)+"\" \" value='Guest' >";				 
					 }
					 else if(i==1)
					 {
						 row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-center: 5px;width:34%;\" name=\"listPMSGroupBookingDetailBean["+(i)+"].strFandB\"  id=\"dtDate."+(i)+"\" value='"+arr[i]+"' >";
				 	     row.insertCell(1).innerHTML= "<input type=\"radio\" style=\"text-align:right;width:34%;\" name=\"listPMSGroupBookingDetailBean["+(i)+"].strPayee\"  id=\"strPayee."+(i)+"\"\" value='Group Leader' checked >";
				 	     row.insertCell(2).innerHTML= "<input type=\"radio\" style=\"text-align:right;width:34%;\" name=\"listPMSGroupBookingDetailBean["+(i)+"].strPayee\"  id=\"strPayee."+(i)+"\" \" value='Guest' >";				 
					 }
					 else if(i==2)
					 {
						 row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-center: 5px;width:34%;\" name=\"listPMSGroupBookingDetailBean["+(i)+"].strTelephone\"  id=\"dtDate."+(i)+"\" value='"+arr[i]+"' >";
				 	     row.insertCell(1).innerHTML= "<input type=\"radio\" style=\"text-align:right;width:34%;\" name=\"listPMSGroupBookingDetailBean["+(i)+"].strPayee\"  id=\"strPayee."+(i)+"\"\" value='Group Leader' checked >";
				 	     row.insertCell(2).innerHTML= "<input type=\"radio\" style=\"text-align:right;width:34%;\" name=\"listPMSGroupBookingDetailBean["+(i)+"].strPayee\"  id=\"strPayee."+(i)+"\" \" value='Guest' >";				 
					 }
					 else if(i==3)
					 {
						 row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-center: 5px;width:34%;\" name=\"listPMSGroupBookingDetailBean["+(i)+"].strExtra\"  id=\"dtDate."+(i)+"\" value='"+arr[i]+"' >";
				 	     row.insertCell(1).innerHTML= "<input type=\"radio\" style=\"text-align:right;width:34%;\" name=\"listPMSGroupBookingDetailBean["+(i)+"].strPayee\"  id=\"strPayee."+(i)+"\"\" value='Group Leader' checked >";
				 	     row.insertCell(2).innerHTML= "<input type=\"radio\" style=\"text-align:right;width:34%;\" name=\"listPMSGroupBookingDetailBean["+(i)+"].strPayee\"  id=\"strPayee."+(i)+"\" \" value='Guest' >";				 
					 }
				}
			}
			
			
			function funFillPayeeData(list)
			{
				

				var table = document.getElementById("tblPayeeDtl");
				var rowCount = table.rows.length;
				while(rowCount>0)
				{
					table.deleteRow(0);
					rowCount--;
				}
				
				
				 var table=document.getElementById("tblPayeeDtl");
				 var rowCount=table.rows.length;
				 var service1="Room";
				 var service2="F&B";
				 var service3="Telephone";
				 var service4="Extras";
				 
				 var arr = ["Room", "F&B", "Telephone","Extras"];
				 for(var i=0;i<4;i++)
				{
					 
					 var row=table.insertRow();
					 var value="service"+(i+1);
					 
					 if(i==0)
					 {
						 var valGL="";
						 var valG="";
						 if(list[0].strRoom=="Y")
							 {
							 	valGL="checked";	
							 }
						 else
							 {
							 	valG="checked";	
							 }
						
						 row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-center: 5px;width:34%;\" name=\"listPMSGroupBookingDetailBean["+(i)+"].strRoom\"  id=\"dtDate."+(i)+"\" value='"+arr[i]+"' >";
				 	     row.insertCell(1).innerHTML= "<input type=\"radio\" style=\"text-align:right;width:34%;\" name=\"listPMSGroupBookingDetailBean["+(i)+"].strPayee\"  id=\"strPayee."+(i)+"\"\" value='Group Leader' "+valGL+" >";
				 	     row.insertCell(2).innerHTML= "<input type=\"radio\" style=\"text-align:right;width:34%;\" name=\"listPMSGroupBookingDetailBean["+(i)+"].strPayee\"  id=\"strPayee."+(i)+"\" \" value='Guest'  "+valG+" >";				 
					 }
					 else if(i==1)
					 {
						 var valGL="";
						 var valG="";
						 if(list[0].strFandB=="Y")
							 {
							 	valGL="checked";	
							 }
						 else
							 {
							 	valG="checked";	
							 }
						 row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-center: 5px;width:34%;\" name=\"listPMSGroupBookingDetailBean["+(i)+"].strFandB\"  id=\"dtDate."+(i)+"\" value='"+arr[i]+"' >";
				 	     row.insertCell(1).innerHTML= "<input type=\"radio\" style=\"text-align:right;width:34%;\" name=\"listPMSGroupBookingDetailBean["+(i)+"].strPayee\"  id=\"strPayee."+(i)+"\"\" value='Group Leader' "+valGL+" >";
				 	     row.insertCell(2).innerHTML= "<input type=\"radio\" style=\"text-align:right;width:34%;\" name=\"listPMSGroupBookingDetailBean["+(i)+"].strPayee\"  id=\"strPayee."+(i)+"\" \" value='Guest' "+valG+" >";				 
					 }
					 else if(i==2)
					 {
						 var valGL="";
						 var valG="";
						 if(list[0].strTelephone=="Y")
							 {
							 	valGL="checked";	
							 }
						 else
							 {
							 	valG="checked";	
							 }
						 row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-center: 5px;width:34%;\" name=\"listPMSGroupBookingDetailBean["+(i)+"].strTelephone\"  id=\"dtDate."+(i)+"\" value='"+arr[i]+"' >";
				 	     row.insertCell(1).innerHTML= "<input type=\"radio\" style=\"text-align:right;width:34%;\" name=\"listPMSGroupBookingDetailBean["+(i)+"].strPayee\"  id=\"strPayee."+(i)+"\"\" value='Group Leader' "+valGL+" >";
				 	     row.insertCell(2).innerHTML= "<input type=\"radio\" style=\"text-align:right;width:34%;\" name=\"listPMSGroupBookingDetailBean["+(i)+"].strPayee\"  id=\"strPayee."+(i)+"\" \" value='Guest' "+valG+" >";				 
					 }
					 else if(i==3)
					 {
						 var valGL="";
						 var valG="";
						 if(list[0].strExtra=="Y")
							 {
							 	valGL="checked";	
							 }
						 else
							 {
							 	valG="checked";	
							 }
						 row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-center: 5px;width:34%;\" name=\"listPMSGroupBookingDetailBean["+(i)+"].strExtra\"  id=\"dtDate."+(i)+"\" value='"+arr[i]+"' >";
				 	     row.insertCell(1).innerHTML= "<input type=\"radio\" style=\"text-align:right;width:34%;\" name=\"listPMSGroupBookingDetailBean["+(i)+"].strPayee\"  id=\"strPayee."+(i)+"\"\" value='Group Leader' "+valGL+"  >";
				 	     row.insertCell(2).innerHTML= "<input type=\"radio\" style=\"text-align:right;width:34%;\" name=\"listPMSGroupBookingDetailBean["+(i)+"].strPayee\"  id=\"strPayee."+(i)+"\" \" value='Guest' "+valG+" >";				 
					 }
				}
			}
			
			//package tab code
			
			//add income head
	function funAddIncomeHeadRow(incomeHeadCode,incomeHeadName,incomeHeadAmt)
	{
		/*var incomeHeadCode=$("#txtIncomeHead").val();
		var incomeHeadName=$("#txtIncomeHeadName").val();
		var incomeHeadAmt=$("#txtIncomeHeadAmt").val(); 
		*/var amount="0.0";
		var larray=[];
		var flag=false;
		flag=funChechDuplicate(incomeHeadCode);
		if(flag)
		{
			alert("Already Added.");
		}
		else
		{
			var table=document.getElementById("tblIncomeHeadDtl");
			var rowCount=table.rows.length;
			var row=table.insertRow();
			
			var incomehead = $("#hidIncomeHead").val();
			
			if(!incomehead==''){
				incomehead=incomehead+","+incomeHeadCode;
				 $("#hidIncomeHead").val(incomehead);
			}
			else{
				$("#hidIncomeHead").val(incomeHeadCode);
				
			}
			 
	 	    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 5px;width:50%;\"    id=\"strIncomeHeadCode."+(rowCount)+"\" value='"+incomeHeadCode+"' >";
	 	    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 5px;width:50%;\"  id=\"strIncomeHeadDesc."+(rowCount)+"\" value='"+incomeHeadName+"' >";
	 	    row.insertCell(2).innerHTML= "<input type=\"readonly\"   class=\"Box \"  style=\"text-align:right;\"    id=\"dblIncomeRate."+(rowCount)+"\" value='"+incomeHeadAmt+"' >";
	 	    row.insertCell(3).innerHTML= "<input type=\"button\" value=\"\" style=\"padding-right: 5px;width:80%;text-align: right;\" class=\"deletebutton\" onclick=\"funRemoveRow(this)\" />";	
	 	 
	 	   larray.push(incomeHeadCode, incomeHeadName, incomeHeadAmt);
			 gmap.set(incomeHeadCode,larray);
		//calculate totals
			funCalculateTotals();
		
			//$("#txtIncomeHead").val('');
			//$("#dblIncomeHeadAmt").val('');
		}
	}
			
			


	function funAddRow()
		{
			var flag=false;			
			if($("#txtIncomeHead").val().trim().length==0)
			{
				alert("Please Select Income Head.");
			}
			else
			{
				if($("#txtIncomeHeadAmt").val().trim().length==0)
				{
					alert("Please Enter Amount For Income Head.");
				}
				else
				{
					flag=true;
					funAddIncomeHeadRow($("#txtIncomeHead").val(),$("#txtIncomeHeadName").val(),$("#txtIncomeHeadAmt").val());
					$("#txtIncomeHead").val("");
					$("#txtIncomeHeadName").val("");
					$("#txtIncomeHeadAmt").val("");
					
					
				}
			}		
			return flag;
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
				
				$("#txtIncomeHead").val(data.strIncomeHeadCode);
				$("#txtIncomeHeadName").val(data.strIncomeHeadDesc);
			}
		
		function funChechDuplicate(incomeHeadCode)
		{
			var flag=false;
			var table=document.getElementById("tblIncomeHeadDtl");
			var rowCount=table.rows.length;
			if(rowCount>0)
			{
			    for(var i=0;i<rowCount;i++)
			    {
			       var containsAccountCode=table.rows[i].cells[0].innerHTML;
			       var addedIHCode=$(containsAccountCode).val();
			       if(addedIHCode==incomeHeadCode)
			       {
			    	   flag=true;
			    	   break;
			       }
			    }
			}
			return flag;
		}
		
		
		//calculate totals
		function funCalculateTotals()
		{			
			
			var totalAmt=0.00;
			var table=document.getElementById("tblIncomeHeadDtl");
			var rowCount=table.rows.length;
			if(rowCount>0)
			{
			    for(var i=0;i<rowCount;i++)
			    {
			    	var containsAccountCode=table.rows[i].cells[2].innerHTML;
			       	totalAmt=totalAmt+parseFloat($(containsAccountCode).val());
			    }
			   	totalAmt=parseFloat(totalAmt).toFixed(maxAmountDecimalPlaceLimit);
			}
			
			var table=document.getElementById("tblTotalPackageDtl");
			var rowCount=table.rows.length;
			while(rowCount>0)
			{table.deleteRow(0);
			   rowCount--;
			}
			var row=table.insertRow();
			row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 56%;width:100%; font-size:13px; font-weight: bold;text-align:right; \"  id=\"strPackageDesc."+(rowCount)+"\" value='Total' >";
	 	    row.insertCell(1).innerHTML= "<input type=\"text\" class=\"Box \"  style=\"text-align:right; font-size:13px; font-weight: bold;width:95%;\"  id=\"dblIncomeRate."+(rowCount)+"\" value='"+totalAmt+"' >";
	 	    
	 	    row=table.insertRow();
			/* row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 67%;width:100%; font-size:13px; font-weight: bold;text-align:right; \"  id=\"strPackageDesc."+(rowCount)+"\" value='Room Tarrif' >";
		    row.insertCell(1).innerHTML= "<input type=\"readonly\"   class=\"Box \" style=\"text-align:right; font-size:13px; font-weight: bold;width:95%;\"  id=\"dblIncomeRate."+(rowCount)+"\" value='"+totalTarriff+"' >";
		    */ var totalPkgAmt=0;
		    var rowCount=table.rows.length;
		    if(rowCount>0)
			{
			    for(var i=0;i<rowCount;i++)
			    {
			    	var containsAccountCode=table.rows[i].cells[1].innerHTML;
			    	totalPkgAmt=totalPkgAmt+parseFloat($(containsAccountCode).val());
			    }
			    totalPkgAmt=parseFloat(totalPkgAmt).toFixed(maxAmountDecimalPlaceLimit);
			}
		    row=table.insertRow();
			row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 70%;width:100%; font-size:13px; font-weight: bold;text-align:right; \"  id=\"strPackageDesc."+(rowCount)+"\" value='Total Package' >";
		    row.insertCell(1).innerHTML= "<input type=\"text\" class=\"Box \"  style=\"text-align:right; font-size:13px; font-weight: bold;width:95%;\"  id=\"dblIncomeRate."+(rowCount)+"\" value='"+totalPkgAmt+"' >";
		    $("#txtTotalPackageAmt").val(totalPkgAmt);
		}
		

/* funValidation code
	 if(document.getElementById("tblIncomeHeadDtl").rows.length>0)
			        {
			        	var table = document.getElementById("tblTotalPackageDtl");
					    var rowCount = table.rows.length;
						if(rowCount>0)
						{
							if($("#txtPackageName").val()=='')
							 {
								alert("Please Enter Package Name");
								flg=false;
							 }
						}
			        } */
			
			
			
			        function funRemoveProductRowsForIncomeHead()
			    	{
			    		var table = document.getElementById("tblIncomeHeadDtl");
			    		var rowCount = table.rows.length;
			    		while(rowCount>0)
			    		{
			    			table.deleteRow(0);
			    			rowCount--;
			    		}
			    	}
			
			        function funRemoveRow(obj)
			    	{
			    	    var index = obj.parentNode.parentNode.rowIndex;
			    	    var table = document.getElementById("tblIncomeHeadDtl");			    	   
			    	    var id="strIncomeHeadCode."+index;
			    	    document.getElementById(id).value;
			    	    	    	
			    	    if(gmap.has(document.getElementById(id).value))
			    	    	{
			    	    		gmap.delete(document.getElementById(id).value);
			    	    	}
			    	    table.deleteRow(index);		
			    	    funCalculateTotals();
			    	}
			
			
			function funSubmit()
			{
				window.opener.funGetMap(gmap);
			}
			
			
			
			
	
</script>

</head>
<body>	
	 <div class="container">
		<label id="formHeading">Group Reservation</label>
		<s:form name="CompanyMaster" method="POST" action="savePMSGroupReservation.html">
	 <br>
	<div id="multiAccordion">	
		<h3><a href="#">Group Reservation Details</a></h3>
			<div>
				<div class="container transtable" style="background-color:#f2f2f2;">
					<div class="row" style="padding-bottom:12px">
						<div class="col-md-2">
							<label>Reservation ID</label>
							<s:input id="txtReservationID" ondblclick="" cssClass="searchTextBox"
								readonly="true"  type="text" path="strReservationID"></s:input>
						</div>
						<div class="col-md-2"><s:input id="" path="" 
							placeholder="" type="text" style="margin-top:23px;"></s:input>
						</div>
						<div class="col-md-2">
							<label>Group Code</label>
							<s:input id="txtGroupCode" ondblclick="funHelp('groupcode');"  cssClass="searchTextBox" readonly="true"  type="text" path="strGroupCode"></s:input>
						</div>
						<label>Group Name</label>
						<div class="col-md-2"><s:input id="txtGroupName" required="true" path="strGroupName" 
							placeholder="Group Name" type="text" style="margin-top:23px;"></s:input>
						</div>
						<div class="col-md-2">
							<label>Group Leader</label>
							<s:input id="txtGroupLeaderCode" ondblclick="funHelp('guestCode');"  cssClass="searchTextBox" required="true"
								 type="text" path="strGroupLeaderCode"></s:input>
						</div>
						<div class="col-md-2"><s:input id="txtGroupLeaderName" required="true" path="" 
							placeholder="" type="text" style="margin-top:23px;"></s:input>
						</div>
						<div class="col-md-4">
							<label>Address</label>
							<s:input id="txtAddress" type="text" path="strAddress"></s:input>
						</div>
						<div class="col-md-2">
							<label>City</label>
							<s:input id="txtCity"  path="strCity" type="text"></s:input>
						</div>
						<div class="col-md-2">
							<label>Country</label>
							<s:input id="txtCountry"  path="strCountry" type="text"></s:input>
						</div>
						<div class="col-md-2">
							<label>Pin</label>
							<s:input id="txtPin"  path="strPin" type="text"></s:input>
						</div>
						<div class="col-md-2">
							<label>Phone</label>
							<s:input id="txtPhone"  path="strPhone" type="text"></s:input>
						</div>
						<div class="col-md-2">
							<label>Mobile</label>
							<s:input id="txtMobile"  path="strMobile" type="text"></s:input>
						</div>
						<div class="col-md-2">
							<label>Fax</label>
							<s:input id="txtFax"  path="strFax" type="text"></s:input>
						</div>
						<div class="col-md-2">
							<label>Email</label>
							<s:input id="txtEmail"  path="strEmail" type="text"></s:input>
						</div>
						<div class="col-md-2">
							<label>DOB</label>
							<s:input id="txtDob"  path="dteDob" type="text" cssClass="calenderTextBox" style="width:80%;"></s:input>
						</div>
						<div class="col-md-2">
							<label>Nationality</label>
							<s:input id="txtNationality"  path="strNationality" type="text" ></s:input>
						</div>
					</div>
				</div>	
			</div>
		
									
		<h3><a href="#">Group Instructions</a></h3>
			<div>							
				<div class="container transtable" style="background-color:#f2f2f2;">
					<div class="row" style="padding-bottom:12px">
						<div class="col-md-2">
							<label>Company</label>
							<s:input id="txtCompCode" ondblclick="funHelp('CorporateCode');" cssClass="searchTextBox"
								 type="text" path="strCompCode"></s:input>
						</div>
						<div class="col-md-2"><s:input id="txtCompName" path="strCompName" 
							placeholder="" type="text" style="margin-top:23px;"></s:input>
						</div>
						<div class="col-md-2">
							<label>Designation</label>
							<s:input id="txtDesignation" ondblclick="" cssClass="searchTextBox"
								  type="text" path="strDesignation"></s:input>
						</div>
						<div class="col-md-2">
							<label>City</label>
							<s:input id="txtGICity"  path="strGICity" type="text"></s:input>
						</div>
						<div class="col-md-2">
							<label>Phone</label>
							<s:input id="txtGIPhone"  path="strGIPhone" type="text"></s:input>
						</div>
						<div class="col-md-2">
							<label>Mobile</label>
							<s:input id="txtGIMobile"  path="strGIMobile" type="text"></s:input>
						</div>
						<div class="col-md-2">
							<label>Fax</label>
							<s:input id="txtGIFax"  path="strGIFax" type="text"></s:input>
						</div>
					</div>
				</div>
			</div>
			
					
       <h3><a href="#">Arrival Info</a></h3>
		<div>		
			<div class="container transtable" style="background-color:#f2f2f2;">
				<div class="row" style="padding-bottom:12px">
					<div class="col-md-12">
						<label>Travel Details</label>
					</div>
					<div class="col-md-2">
						<label>Date</label>
						<s:input id="txtTravelDate"  path="dteTravelDate" type="text" cssClass="calenderTextBox" style="width:80%;"></s:input>
					</div>
					<div class="col-md-2">
						<label>Time</label>
						<s:input id="txtTravelTime"  path="tmeTravelTime" type="text"></s:input>
					</div>
					<div class="col-md-2">
						<label>Pickup Required</label>
						<s:input id="txtPickupRequired"  path="strPickupRequired" type="text"></s:input>
					</div>
					
				</div>
			</div>
		</div>
    	
       <h3><a href="#"> Stay Details</a></h3>
		<div>	
			<div class="container transtable" style="background-color:#f2f2f2;">
				<div class="row" style="padding-bottom:12px">
					<div class="col-md-2">
						<label>Check in</label>
						<s:input id="txtCheckInDate"  path="dteCheckInDate" type="text" cssClass="calenderTextBox" style="width:80%;"></s:input>
					</div>
					<div class="col-md-2">
						<label>Checkout</label>
						<s:input id="txtCheckoutDate"  path="dteCheckoutDate" type="text" cssClass="calenderTextBox" style="width:80%;"></s:input>
					</div>
					<div class="col-md-2">
						<label>Pax</label>
						<s:input id="txtPax"  path="strPax" type="text"></s:input>
					</div>
					<div class="col-md-2">
						<label>Source</label>
						<s:input id="txtSource"  path="strSource" type="text"></s:input>
					</div>
					<div class="col-md-2">
						<label>Guest Type</label>
						<s:input id="txtGuestType"  path="strGuestType" type="text"></s:input>
					</div>
					<div class="col-md-2">
						<label>Extra Bed</label>
						<s:input id="txtExtraBed"  path="strExtraBed" type="text"></s:input>
					</div>
					<div class="col-md-2">
						<label>Child</label>
						<s:input id="txtChild"  path="strChild" type="text"></s:input>
					</div>
					<div class="col-md-2">
						<label>Infant</label>
						<s:input id="txtInfant"  path="strInfant" type="text"></s:input>
					</div>
					<div class="col-md-2">
						<label>Sales Channel</label>
						<s:input id="txtSalesChannel"  path="strSalesChannel" type="text"></s:input>
					</div>
				</div>
			</div>
		</div>
		
			<h3><a href="#">Rate Code</a></h3>
				<div>	
					<div class="container transtable" style="background-color:#f2f2f2;">
						<div class="row" style="padding-bottom:12px">
							<div class="col-md-2">
								<label>Room Type</label>
								<s:input id="txtRoomType" ondblclick="funHelp('roomType')" type="text" readonly="true" cssClass="searchTextBox" path="strRoomType"></s:input>
							</div>
							<div class="col-md-2">
								<label>Room Type Desc</label>
								<s:input id="txtRoomTypeDesc" ondblclick=""  readonly="true"  type="text" path="strRoomTypeDesc"></s:input>
							</div>
							<div class="col-md-2">
								<label>Room taxes</label>
								<s:input id="txtRoomTaxes" ondblclick=""  type="text" path="strRoomTaxes"></s:input>
							</div>
							<div class="col-md-2">
								<label>Other Taxes</label>
								<s:input id="txtOtherTaxes" ondblclick=""  type="text" path="strOtherTaxes"></s:input>
							</div>
							<div class="col-md-2">
								<label>Service Charges</label>
								<s:input id="txtServiceCharges" ondblclick=""   type="text" path="strServiceCharges"></s:input>
							</div>
							<div class="col-md-2">
								<label>Payments</label>
								<s:input id="txtPayments" ondblclick=""   type="text" path="strPayments"></s:input>
							</div>
							<div class="col-md-2">
								<label>Discounts</label>
								<s:input id="txtDiscounts" ondblclick=""   type="text" path="strDiscounts"></s:input>
							</div>
							<div class="col-md-12">
								<h6>Payment Details</h6>
							</div>
							<div class="col-md-2">
								<label>Card</label>
								<s:input id="txtCard" ondblclick=""   type="text" path="strCard"></s:input>
							</div>	
							<div class="col-md-2">
								<label>Cash</label>
								<s:input id="txtCash" ondblclick=""   type="text" path="strCash"></s:input>
							</div>
						</div>
					</div>
				</div>
			
	   <h3><a href="#">Billing Instructions</a></h3>
	    <div>
	    	<div class="container transtable" style="background-color:#f2f2f2;">
				
			
		
	  
	    <div class="dynamicTableContainer" style="">
			<table style="height: 28px; border: #0F0; width: 100%;font-size:11px; font-weight: bold;">
				<tr bgcolor="#c0c0c0" style="height: 24px;">
					<td align="left" style="width:">Services</td>
					<td align="left" style="width:500px">Payment By Group Leader</td>
					<td align="left" style="width:">Guest</td>									
				</tr>
			</table>
			<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 200px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
				<table id="tblPayeeDtl" style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll" class="transTablex col3-center">
					<tbody>
						<!-- col1   -->
						<col width="100%">
						<!-- col1   -->
						
						<!-- col2   -->
						<col width="100%" >
						<!-- col2   -->
						
						<!-- col3   -->
						<col width="100%" >
						<!-- col3   -->
						
						<!-- col4   -->
						<col  width="10%">
						<!-- col4   -->
					</tbody>
				</table>
			</div>	
	    </div>	
</div></div>

<!-- table package stars -->


  <h3><a href="#">Package</a></h3>
		<div>
		<div class="container transtable"  style="background-color:#f2f2f2;">
			<div class="row">
				
	 	     	<div class="col-md-2"><label>Package Code</label>
			    	<s:input id="txtPackageCode" path=""  readonly="true"  ondblclick="funHelp('package')" cssClass="searchTextBox"/>
				 </div>
			 
			    <div class="col-md-3"><label>Package Name</label>
			    	<s:input id="txtPackageName" path=""/>
				</div>
				<div class="col-md-7"></div>
				
			    <div class="col-md-2"><label>Income Head</label>
			    	<s:input id="txtIncomeHead" path=""  readonly="true"  ondblclick="funHelp('incomeHead')" cssClass="searchTextBox"/>
			    </div>
			    
			    <div class="col-md-3"><label>Income Head Name</label>
				    <input type="text" id="txtIncomeHeadName" path="" />
				</div> 
			
			    <div class="col-md-2"><label>Amount</label>
			    	<input type="text" id="txtIncomeHeadAmt" path=""/>
			    </div>
			    <div class="col-md-1"><br><input type="button" value="Add" class="btn btn-primary center-block" class="smallButton" onclick='return funAddRow()'/>
			    </div>
			
				<s:input type="hidden" id="txtGroupCode" path="" cssClass="searchTextBox" />
			    
			
		   </div>
		<br/>
		
		<!-- Generate Dynamic Table   -->		
		
		
		
		
		<div class="dynamicTableContainer" style="height: 320px; width: 80%">
			<table style="height: 28px; border: #0F0; width: 100%;font-size:11px; font-weight: bold;">
				<tr bgcolor="#c0c0c0" style="height: 24px;">
					<!-- col1   -->
					<td align="left" style="width: 30.6%">Income Head Code</td>
					<!-- col1   -->
					
					<!-- col2   -->
					<td align="left" style="width: 30.6%">Income Head Name</td>
					<!-- col2   -->
					
					<!-- col3   -->
					<td align="right" style="width: 25.6%">Amount</td>
					<!-- col3   -->
					
					<!-- col4   -->
					<td align="right">Delete</td>
					<!-- col4  -->									
				</tr>
			</table>
			<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 200px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
				<table id="tblIncomeHeadDtl" style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll" class="transTablex col3-center">
					<tbody>
						<!-- col1   -->
						<col width="100%">
						<!-- col1   -->
						
						<!-- col2   -->
						<col width="100%" >
						<!-- col2   -->
						
						<!-- col3   -->
						<col width="100%" >
						<!-- col3   -->
						
						<!-- col4   -->
						<col  width="10%">
						<!-- col4   -->
					</tbody>
				</table>
			</div>	
			
			<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 120px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
				<table id="tblTotalPackageDtl" style="width: 100%; border: #0F0; font-size:15px; font-weight: bold; table-layout: fixed; overflow: scroll" class="display dataTable no-footer">
					<tbody>
						<!-- col1   -->
						<col width="100%" >
						<!-- col1   -->
						
						<!-- col2   -->
						<col width="100%" >
						<!-- col2   -->
						
						<!-- col3   -->
						<col  width="10%">
						<!-- col3   -->
					</tbody>
				</table>
			</div>		
		</div>	
	
	<!-- table package ends -->
		
		
			
	 
	 </div>
	</div>
	
	






</div>
	<div class="center" style="text-align:center">
		<button class="btn btn-primary center-block" id="" onclick="funSubmit()">SAVE</button> &nbsp;
		<button class="btn btn-primary center-block" id="" onclick="">CANCEL</button> &nbsp;
	</div>
</s:form>                                                                              
</div>
			 
			

	

			
	
				
					  
<script type="text/javascript">
		$(function(){
			$('#multiAccordion').multiAccordion({
// 				active: [1, 2],
				click: function(event, ui) {
				},
				init: function(event, ui) {
				},
				tabShown: function(event, ui) {
				},
				tabHidden: function(event, ui) {
				}
				
			});
			
			$('#multiAccordion').multiAccordion("option", "active", [0]);  // in this line [0,1,2] wirte then these index are open
		});
	</script>
					
</body>
</html>

