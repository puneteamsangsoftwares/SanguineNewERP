<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>
       <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=8"/>
	
		<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 	<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 	<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />	
	 	 
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
		<script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
	<%-- 	<script type="text/javascript" src="<spring:url value="/resources/js/Accordian/jquery-ui-1.8.13.custom.min.js"/>"></script> --%>
	<script type="text/javascript" src="<spring:url value="/resources/js/Accordian/jquery.multi-accordion-1.5.3.js"/>"></script>	
	
<script type="text/javascript">

	var fieldName,listRow=0;
	var totalTerrAmt = 0.0;
	var dblPaxCnt = 0;
	var gRoomTypeCode="";
	var gRoomTypeDesc="";
	var gmap = new Map();
	  $(document).ready(function(){
		    
		  $(".tab_content").hide();
			$(".tab_content:first").show();

			$("ul.tabs li").click(function() {
				$("ul.tabs li").removeClass("active");
				$(this).addClass("active");
				$(".tab_content").hide();
				var activeTab = $(this).attr("data-state");
				$("#" + activeTab).fadeIn();
			});
			
		  $("#txtNoOfAdults").val(1);
		  $("#txtNoOfBookingRoom").val(1);
		  
<%-- 		  var pmsDate='<%=session.getAttribute("PMSDate").toString()%>'; --%>
// 		  var dte=pmsDate.split("-");
// 		  $("#txtPMSDate").val(dte[2]+"-"+dte[1]+"-"+dte[0]);
	   });

	$(function() 
	{
		//var arrivalTime=session.getAttribute("PMSCheckInTime");
		//var departureTime=session.getAttribute("PMSCheckOutTime");
		
		 <%-- var pmsDate='<%=session.getAttribute("PMSDate").toString()%>'; --%>
		 var tempPMSDate='<%=session.getAttribute("TempPMSDateForReservation").toString()%>';
		
		$('#txtArrivalTime').timepicker();
		$('#txtDepartureTime').timepicker();
		
		$('#txtArrivalTime').timepicker({
		        'timeFormat':'H:i:s'
		});
		$('#txtDepartureTime').timepicker({
		        'timeFormat':'H:i:s'
		});
		
		
		$("#txtArrivalTime").timepicker();
		$("#txtDepartureTime").timepicker();
		  
		
		$('#txtArrivalTime').timepicker({
	        'timeFormat':'H:i:s'
		});
		$('#txtDepartureTime').timepicker({
			        'timeFormat':'H:i:s'
		});
			
		$('#txtArrivalTime').timepicker('setTime', new Date());
		//$('#txtDepartureTime').timepicker('setTime', new Date());
		$('#txtDepartureTime').val("${tmeCheckOutPropertySetupTime}");
		
		$('#txtArrivalTime').timepicker();
		$('#txtDepartureTime').timepicker();
		
		
		
		$('#txtPickUpTime').timepicker();
		$('#txtDropTime').timepicker();
		
		$('#txtPickUpTime').timepicker({
		        'timeFormat':'H:i:s'
		});
		$('#txtDropTime').timepicker({
		        'timeFormat':'H:i:s'
		});
		
		$('#txtPickUpTime').timepicker('setTime', new Date());
		$('#txtDropTime').timepicker('setTime', new Date());
		
		
		$("#txtPickUpTime").timepicker();
		$("#txtDropTime").timepicker();
		  
		
// 		$( "#txtArrivalDate" ).datepicker({
// 			minDate: 0,
// 			 dateFormat: 'dd-mm-yy' 
// 		});
		
	
		$("#txtArrivalDate").datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtArrivalDate").datepicker('setDate', tempPMSDate);
		
// 		$( "#txtDepartureDate" ).datepicker({
// 			minDate: 0,
// 			 dateFormat: 'dd-mm-yy' 
// 		});
		
		$("#txtDepartureDate").datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtDepartureDate").datepicker('setDate', tempPMSDate);
	

		
// 		$("#txtArrivalDate").datepicker({ dateFormat: 'dd-mm-yy' });
// 		$("#txtArrivalDate").datepicker('setDate', pmsDate);
		
// 		$("#txtDepartureDate").datepicker({ dateFormat: 'dd-mm-yy' });
// 		$("#txtDepartureDate").datepicker('setDate', pmsDate);
		
		$("#txtCancelDate").datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtCancelDate").datepicker('setDate', tempPMSDate);
		
		$("#txtConfirmDate").datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtConfirmDate").datepicker('setDate', tempPMSDate);
		
		
		$('a#baseUrl').click(function() 
		{
			if($("#txtReservationNo").val().trim()=="")
			{
				alert("Please Select Reservation No ");
				return false;
			}
			window.open('attachDoc.html?transName=frmReservation.jsp&formName=Reservation &code='+$('#txtReservationNo').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
		});	
		
		
		
		var message='';
		var retval="";
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
				%> alert("Data Save successfully\n\n"+message);
				var reservationNo='';
				var AdvAmount='';
				//var isCheckOk=confirm("Do You Want to Generate Reservation Slip ?"); 
				var isOk=confirm("Do You Want to pay Advance Amount ?");
				<%-- if(isCheckOk)
				{
					reservationNo='<%=session.getAttribute("AdvanceAmount").toString()%>';
					window.open(getContextPath() + "/rptReservationSlip.html?reservationNo=" +reservationNo,'_blank');
				} --%>
				if(isOk)
 				{
					var checkAgainst="Reservation";
					AdvAmount='<%=session.getAttribute("AdvanceAmount").toString()%>';
	    			window.location.href=getContextPath()+"/frmPMSPaymentAdvanceAmount.html?AdvAmount="+AdvAmount ;
	    			session.removeAttribute("AdvanceAmount");
	    			
 				}<%
			}
		}%>
		
		var resNo='';
		<%if (session.getAttribute("ResNo") != null) 
		{
			%>
			resNo='<%=session.getAttribute("ResNo").toString()%>';
			funSetReservationNo(resNo);
		    <%
		    session.removeAttribute("ResNo");
		}%>
		
		
		var roomNo='';
		<%if (session.getAttribute("RoomCode") != null) 
		{
			%>
			roomNo='<%=session.getAttribute("RoomCode").toString()%>';
			funSetRoomNo(roomNo);
		    <%
		    session.removeAttribute("RoomCode");
		}%>
		
	});

	
	function funSetData(code){

		switch(fieldName){

			case 'ReservationNo' : 
				funSetReservationNo(code);
				break;
				
			case 'PropertyCode' : 
				funSetPropertyCode(code);
				break;
				
			case 'guestCode' : 
				funSetGuestCode(code);
				break;
				
			case 'CorporateCode' : 
				funSetCorporateCode(code);
				break;
				
			case 'BookingTypeCode' : 
				funSetBookingTypeCode(code);
				break;
				
			case 'BillingInstCode' : 
				funSetBillingInstCode(code);
				break;
				
			case 'BookerCode' : 
				funSetBookerCode(code);
				break;
				
			case 'business' : 
				funSetBusinessSourceCode(code);
				break;
				
			case 'AgentCode' : 
				funSetAgentCode(code);
				break;
				
			case 'roomCode' : 
				funSetRoomNo(code);
				break;
			
			case 'extraBed' : 
				funSetExtraBed(code);
				break;
				
			case 'marketsource' : 
				funSetMarketSourceCode(code);
			break;
			
			case "incomeHead":
				funSetIncomeHead(code);
			break;
			
			case "roomType":
				funSetRoomType(code);
			break;
			
			case "package":
				funSetPackageNo(code);
			break;
			
			case "roomByRoomType":
				funSetRoomNo(code);
			break;
			
			case 'roomByRoomType': 
				funSetRoomNo(code);
				break;
				
			case "plan":
				funSetPlanMasterData(code);
			break;		
		}
	}

	function funSetReservationNo(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadReservation.html?docCode=" + code,
			dataType : "json",
			success : function(response){ 
				if(response.strReservationNo!="Invalid")
		    	{
		    		funFillHdData(response);
		    	}
		    	else
			    {
			    	alert("Invalid Reservation No");
			    	$("#txtReservationNo").val("");
			    	$("#txtReservationNo").focus();
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

	function funSetPropertyCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadPropertyCode.html?docCode=" + code,
			dataType : "json",
			success : function(response){ 
				
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

	function funSetGuestCode(code){
			
		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadGuestCode.html?guestCode=" + code,
			dataType : "json",
			success : function(response){ 
				funSetGuestInfo(response);
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
			async:false,
			success : function(response){ 
				if(response.strCorporateCode=='Invalid Code')
	        	{
	        		alert("Invalid Agent Code");
	        		$("#txtCorporateCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtCorporateCode").val(response.strCorporateCode);
	        		$("#lblCorporateDesc").text(response.strCorporateDesc);
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

	
	function funSetBookingTypeCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadBookingTypeCode.html?bookingType=" + code,
			dataType : "json",
			success : function(response){ 
				if(response.strBookingTypeCode=='Invalid Code')
	        	{
	        		alert("Invalid Agent Code");
	        		$("#txtBookingTypeCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtBookingTypeCode").val(response.strBookingTypeCode);
	        	    $("#lblBookingTypeDesc").text(response.strBookingTypeDesc);
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

	
	

	function funSetBillingInstCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadBillingInstCode.html?billingInstructions=" + code,
			dataType : "json",
			success : function(response){
				$("#txtBillingInstCode").val(response.strBillingInstCode);
        	    $("#lblBillingInstDesc").text(response.strBillingInstDesc);
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

	
	function funSetBookerCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadBookerCode.html?bookerCode=" + code,
			dataType : "json",
			success : function(response){ 
				if(response.strBookerCode=='Invalid Code')
	        	{
	        		alert("Invalid Agent Code");
	        		$("#txtBookerCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtBookerCode").val(response.strBookerCode);
	        		$("#lblBookerName").text(response.strBookerName);
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

	
	function funSetBusinessSourceCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadBusinessMasterData.html?businessCode=" + code,
			dataType : "json",
			success : function(response){ 
				if(response.strBusinessSourceCode=='Invalid Code')
	        	{
	        		alert("Invalid Business Code");
	        		$("#txtBusinessSourceCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtBusinessSourceCode").val(response.strBusinessSourceCode);
		        	$("#lblBusinessSourceName").text(response.strDescription);
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

	
	function funSetAgentCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadAgentCode.html?agentCode=" + code,
			dataType : "json",
			success : function(response){ 
				if(response.strAgentCode=='Invalid Code')
	        	{
	        		alert("Invalid Agent Code");
	        		$("#txtAgentCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtAgentCode").val(response.strAgentCode);
	        		$("#lblAgentName").text(response.strDescription);
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

	
	
	function funSetRoomType(code){
		$("#txtRoomTypeCode").val(code);
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
	        		$("#lblRoomType").text(response.strRoomTypeDesc);
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
	
	
	
	function funSetRoomNo(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadRoomMasterData.html?roomCode=" + code,
			dataType : "json",
			success : function(response){ 
				if(response.strAgentCode=='Invalid Code')
	        	{
	        		alert("Invalid Room No");
	        		$("#txtRoomNo").val('');
	        	}
	        	else
	        	{
	        		$("#txtRoomNo").val(response.strRoomCode);
	        		$("#lblRoomNo").text(response.strRoomDesc);
	        		funSetRoomType(response.strRoomTypeCode);
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
	
	
	
	function funSetExtraBed(code)
	{
		$("#txtExtraBed").val(code);
		var searchurl=getContextPath()+"/loadExtraBedMasterData.html?extraBedCode="+code;
		 $.ajax({
			    type: "GET",
			    url: searchurl,
			    dataType: "json",
			    success: function(response)
			    {
			        if(response.strExtraBedTypeCode=='Invalid Code')
			        {
			        	alert("Invalid ExtraBed Code");
			        	$("#txtExtraBed").val('');
			        }
			        else
			        {
				        $("#lblExtraBed").text(response.strExtraBedTypeDesc);
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
	
	function funSetRoomNo(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadRoomMasterData.html?roomCode=" + code,
			dataType : "json",
			success : function(response){ 
				if(response.strRoomCode=='Invalid Code')
	        	{
	        		alert("Invalid Room No");
	        		$("#txtRoomNo").val('');
	        	}
	        	else
	        	{
	        		if(response.strStatus=='Blocked')
	        			{
	        			alert('This room is Blocked Please Select Different Room');
	        			}
	        		else
	        		{
	        			funSetRoom(response.strRoomCode)
	        		/* $("#txtRoomNo").val(response.strRoomCode);
	        		$("#lblRoomNo").text(response.strRoomDesc);
	        		funSetRoomType(response.strRoomTypeCode); */
	        		}
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
	
	function funSetRoom(roomCode)
	{
		var arrivalDate = $("#txtArrivalDate").val();
		$.ajax({
			type : "GET",
			url : getContextPath()+ "/setRoomCode.html?roomCode=" + roomCode+"&dteArrDate="+arrivalDate,
			dataType : "json",
			success : function(response){ 
				if(response.strRoomCode=='Invalid')
	        	{
	        		alert("This Room is booked for "+arrivalDate+" ");
	        		$("#txtRoomNo").val('');
	        	}
	        	
	        		else
	        		{
	        			
	        		$("#txtRoomNo").val(response.strRoomCode);
	        		$("#lblRoomNo").text(response.strRoomDesc);
	        		funSetRoomType(response.strRoomTypeCode);
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
	
	function funSetPackageNo(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadPackageMaster.html?docCode=" + code,
			dataType : "json",
			success : function(response)
			{ 
				if(response.strPackageCode!="Invalid")
		    	{
					$("#txtPackageCode").val(response.strPackageCode);
					var table = document.getElementById("tblResDetails");
				    var rowCount = table.rows.length;
					if(rowCount==0)
					{
						alert("Please Enter Guest For Reservation");
					}
					else
					{
						$("#txtPackageName").val(response.strPackageName);
						$.each(response.listPackageDtl, function(i,item)
						{
							funAddIncomeHeadRow(item.strIncomeHeadCode.split('#')[0],item.strIncomeHeadCode.split('#')[1],item.dblAmt);		
						});
					}
		    	}
		    	else
			    {
			    	alert("Invalid Package No");
			    	$("#txtPackageCode").val(code);
			    	$("#txtPackageCode").focus();
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
	
	
	
	function funSetGuestInfo(obj)
	{
		$("#txtGuestCode").val(obj.strGuestCode);
		$("#txtMobileNo").val(obj.lngMobileNo);
		$("#txtGFirstName").val(obj.strFirstName);
		$("#txtGMiddleName").val(obj.strMiddleName);
		$("#txtGLastName").val(obj.strLastName);
		$("#txtAddress").val(obj.strAddress);
		
	}
	
	
	
	function funFillHdData(response)
	{
		$("#txtReservationNo").val(response.strReservationNo);
		$("#txtPropertyCode").val(response.strPropertyCode);
		
		$("#txtGuestCode").val(response.strGuestCode);
		$("#txtGuestPrefix").val(response.strGuestPrefix);
		$("#txtGFirstName").val(response.strFirstName);
		$("#txtGMiddleName").val(response.strMiddleName);
		$("#txtGLastName").val(response.strLastName);
		$("#txtAddress").val(response.strAddress);
		
		
		if(response.strCorporateCode!='')
		{
			$("#txtCorporateCode").val(response.strCorporateCode);
			funSetCorporateCode(response.strCorporateCode);
		}
		
		if(response.strBookingTypeCode!='')
		{
			$("#txtBookingTypeCode").val(response.strBookingTypeCode);
			funSetBookingTypeCode(response.strBookingTypeCode);
		}
		
		if(response.strBillingInstCode!='')
		{
			$("#txtBillingInstCode").val(response.strBillingInstCode);
			funSetBillingInstCode(response.strBillingInstCode);
		}
		
		if(response.strBookerCode!='')
		{
			$("#txtBookerCode").val(response.strBookerCode);
			funSetBookerCode(response.strBookerCode);
		}
		
		if(response.strBusinessSourceCode!='')
		{
			$("#txtBusinessSourceCode").val(response.strBusinessSourceCode);
			funSetBusinessSourceCode(response.strBusinessSourceCode);
		}
		
		if(response.strAgentCode!='')
		{
			$("#txtAgentCode").val(response.strAgentCode);
			funSetAgentCode(response.strAgentCode);
		}
		
		if(response.strBillToCorporate=='Y')
    	{
    		document.getElementById("txtBillToCorporate").checked=true;
    	}
    	else
    	{
    		document.getElementById("txtBillToCorporate").checked=false;
       	}
		
		$("#txtRoomNo").val(response.strRoomNo);
		$("#lblRoomNo").text(response.strRoomDesc);
	    $("#txtExtraBed").val(response.strExtraBedCode);
	    $("#lblExtraBed").text(response.strExtraBedDesc);	    
	    $("#txtNoOfAdults").val(response.intNoOfAdults);
	    $("#txtNoOfChild").val(response.intNoOfChild);				
		$("#txtArrivalDate").val(response.dteArrivalDate);
		$("#txtDepartureDate").val(response.dteDepartureDate);
		$("#txtArrivalTime").val(response.tmeArrivalTime);
		$("#txtDepartureTime").val(response.tmeDepartureTime);
		$("#txtNoOfNights").val(response.intNoOfNights);
		$("#txtNoOfBookingRoom").val(response.intNoRoomsBooked);
		$("#txtContactPerson").val(response.strContactPerson);
		$("#txtEmailId").val(response.strEmailId);
		$("#txtMobileNo").val(response.lngMobileNo);		
		$("#txtRemarks").val(response.strRemarks);
		$("#txtCancelDate").val(response.dteCancelDate);
		$("#txtConfirmDate").val(response.dteConfirmDate);
		$("#txtOTANo").text(response.strOTANo);		
		$("#txtPickUpTime").val(response.tmePickUpTime);
		$("#txtDropTime").text(response.tmeDropTime);		
		$("#txtPackageCode").val(response.strPackageCode);
		$("#txtPackageName").val(response.strPackageName);		      
		$("#hidIncomeHead").val("");
		$("#txtExternalno").val(response.strExternalNo);
		
		if(response.strPlanCode!='')
		{
			$("#txtPlanCode").val(response.strPlanCode);
			funSetPlanMasterData(response.strPlanCode);
		}
		
		
		
		
		 if(response.strDontApplyTax=='Y')
	    	{
	    		document.getElementById("txtDontApplyTax").checked=true;
	    	}
	    	else
	    	{
	    		document.getElementById("txtDontApplyTax").checked=false;
	       	}
		funRemoveProductRowsForIncomeHead();
		funRemoveTariffRows();
		funFillDtlGrid(response.listReservationDetailsBean);
		funAddRommRateDtlOnReservationSelect(response.listReservationRoomRateDtl);
		funGetPreviouslyLoadedPkgList(response.listRoomPackageDtl);
		/*var incomeHeadCode =response.strIncomeHeadCode;
		if(incomeHeadCode!='')
		{
		var incomeHead = incomeHeadCode.split(',');
		for(var i=0; i<incomeHead.length; i++)
		{
		funSetIncomeHead(incomeHead[i]);
		}
		}
		*/
	}
	
	function funAddRommRateDtlOnReservationSelect(dataList)
	{
		 var table=document.getElementById("tblRommRate");
		 
		 for(var i=0;i<dataList.length;i++ )
	     {
			 var rowCount=table.rows.length;
			 var row=table.insertRow();
			 var list=dataList[i];
			 var date=list.dtDate;
	// 		 var roomDesc = funGetRoomDescOnLoad(list.strRoomNo);
		     var roomtypeDesc=funSetRoomType(list.strRoomType);
			 var roomtypeDesc=$("#lblRoomType").text();
			 $("#lblRoomType").text("");
			 var dateSplit = date.split("-");
			 date=dateSplit[2]+"-"+dateSplit[1]+"-"+dateSplit[0];
			 row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-center: 5px;width:50%;\" name=\"listReservationRoomRateDtl["+(rowCount)+"].dtDate\"  id=\"dtDate."+(rowCount)+"\" value='"+date+"' >";
	 	     row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"15%\" id=\"strRoomTypeDesc."+(rowCount)+"\" value='"+roomtypeDesc+"' />";
	 	     row.insertCell(2).innerHTML= "<input type=\"text\" style=\"text-align:right;\"  name=\"listReservationRoomRateDtl["+(rowCount)+"].dblRoomRate\" id=\"dblRoomRate."+(rowCount)+"\" onblur =\"Javacsript:funCalculateTotals()\" value='"+list.dblRoomRate+"' >";
	 	     row.insertCell(3).innerHTML= "<input type=\"hidden\" class=\"Box \" name=\"listReservationRoomRateDtl["+(rowCount)+"].strRoomType\" id=\"strRoomType."+(rowCount)+"\" value='"+list.strRoomType+"' >";
	 	    
	     }
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
	
	

	function funFillDtlGrid(resListResDtlBean)
		{
			funRemoveProductRows();
			var count=0;
			$.each(resListResDtlBean, function(i,item)
			{
				count=i;
				var roomDesc="";
				var roomtypeDesc=funSetRoomType(resListResDtlBean[i].strRoomType);
				var roomtypeDesc=$("#lblRoomType").text();
				$("#lblRoomType").text("");
				funAddDetailsRow(resListResDtlBean[i].strGuestName,resListResDtlBean[i].strGuestCode,resListResDtlBean[i].lngMobileNo
					,resListResDtlBean[i].strRoomType,resListResDtlBean[i].strRemark,resListResDtlBean[i].strRoomNo,roomDesc
					,resListResDtlBean[i].strExtraBedCode,resListResDtlBean[i].strExtraBedDesc,resListResDtlBean[i].strPayee,"",roomtypeDesc);
			});
			listRow=count+1;
		}


	function funGetRoomDescOnLoad(roomNo) 
		{
			var returnVal =0;
			var searchurl=getContextPath()+"/loadRoomDesc.html?roomNo="+roomNo;
			$.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        async:false,
				success: function(response)
		        {
		        	returnVal = response;
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
			
			return returnVal;
		}
	
	
	
//Delete a All record from a grid
	function funRemoveProductRows()
	{
		var table = document.getElementById("tblResDetails");
		var rowCount = table.rows.length;
		while(rowCount>0)
		{
			table.deleteRow(0);
			rowCount--;
		}
	}
	
	
//Function to Delete Selected Row From Grid
	function funDeleteRow(obj)
	{
	    var index = obj.parentNode.parentNode.rowIndex;
	    var table = document.getElementById("tblResDetails");
	    table.deleteRow(index);
	    dblPaxCnt--;
	}
	
	
	
// Reset Detail Fields
	function funResetDetailFields()
	{
		//$("#txtGuestCode").val('');
		//$("#txtMobileNo").val('');
		//$("#txtGFirstName").val('');
		//$("#txtGMiddleName").val('');
		//$("#txtGLastName").val('');
		//$("#txtAddress").val('');
		
		//$("#lblRoomType").text('');
	    $("#txtRoomNo").val('');
	    //$("#lblRoomNo").text('');
	    $("#txtExtraBed").val('');
	    //$("#lblExtraBed").text('');	
	    $("#txtRemark").text('');	
	    $("#txtRoomTypeCode").val('');
	    
	    
	}
	
	//Delete a All record from a grid
	function funRemoveTariffRows()
	{
		var table = document.getElementById("tblRommRate");
		var rowCount = table.rows.length;
		while(rowCount>0)
		{
			table.deleteRow(0);
			rowCount--;
		}
	}
	
	
	

// Get Detail Info From detail fields and pass them to function to add into detail grid
	function funGetDetailsRow() 
	{
	/*
		var table = document.getElementById("tblResDetails");
		var rowCount = table.rows.length;
		if(rowCount>0)
		{
			alert('Only One Guest is Allowed at a time.');
			return;
		}*/
		
		var labCorporate = $("#lblCorporateDesc").text();
		if(labCorporate=='')
		{
			if($("#txtRoomTypeCode").val()=='')
			{
				alert('Select RoomType!!');
			}
			else if($("#txtRoomNo").val()=='')
			{
				alert('Select Room Number!!');
			}
			else
			{
				var gCodeval=$("#txtGuestCode").val().trim();
				
				if(gCodeval==''){
					
					var gCode = funGetGuestCode(gCodeval);
					$("#txtGuestCode").val(gCode.strGuestCode);
					
				}				
				
				var guestCode=$("#txtGuestCode").val().trim();
				var mobileNo=$("#txtMobileNo").val().trim();
				var guestName=$("#txtGFirstName").val().trim()+" "+$("#txtGMiddleName").val().trim()+" "+$("#txtGLastName").val().trim();
				var roomType =$("#txtRoomTypeCode").val();
				var roomNo =$("#txtRoomNo").val();
				var roomDesc =$("#lblRoomNo").text().trim();
				var extraBedCode=$("#txtExtraBed").val();
				var extraBedDesc=$("#lblExtraBed").text();
				var remark=$("#txtRemark").val();
				var address=$("#txtAddress").val();
				var roomTypeDesc=$("#lblRoomType").text();
				
				
				if(gRoomTypeCode.trim().length>0)
				{
					gRoomTypeCode=gRoomTypeCode+","+roomType;					
				}
				else
				{
					gRoomTypeCode=roomType;
				}
				
				if(gRoomTypeDesc.trim().length>0)
				{
					gRoomTypeDesc=gRoomTypeDesc+","+roomTypeDesc;					
				}
				else
				{
					gRoomTypeDesc=roomTypeDesc;
				}
				
				if(roomTypeDesc=='')
				{
					funSetRoomType($("#txtRoomTypeCode").val().trim());
					roomTypeDesc=$("#lblRoomType").text();
				}
				
				if(mobileNo=='')
				{
					alert('Enter Mobile No!!!');
					$("#txtMobileNo").focus();
					return;
				}
				else
				{
					/*var phoneno = /^\d{10}$/;
					if((mobileNo.match(phoneno)))
					{
					}
					else
					{
						alert("Invalid Mobile No");
					    return;
					}
					*/
					
					var pattern = /^[\s()+-]*([0-9][\s()+-]*){6,20}$/;
					if (pattern.test(mobileNo)) 
					{
					}
					else
					{
						alert("Invalid Mobile No");
					    return;
					}	
				}
				
				
				
				
				if($("#txtGFirstName").val().trim()=='')
				{
					alert('Enter Guest First Name!!!');
					$("#txtGFirstName").focus();
					return;
				}
				
				funAddDetailsRow(guestName,guestCode,mobileNo,roomType,remark,roomNo,roomDesc,extraBedCode,extraBedDesc,"N",address,roomTypeDesc);

				funFillRoomRate(roomType,roomDesc);
			}
		}
		else
		{
			var flg=true;
			/* if(dblPaxCnt>0)
			{
				isCheckOk =	confirm("Do you want to do group reservation");
				if(isCheckOk)
				{
					funOpenGroupBooking();
					flg=false;
				}
			} */
			if($("#txtRoomTypeCode").val()=='')
			{
				alert('Select RoomType!!');
				flg=false;
			}
			var roomType =$("#txtRoomTypeCode").val();
			var roomTypeDesc =$("#lblRoomType").text();
			var guestCode=$("#txtGuestCode").val().trim();
			var mobileNo=$("#txtMobileNo").val().trim();
			var guestName=$("#txtGFirstName").val().trim()+" "+$("#txtGMiddleName").val().trim()+" "+$("#txtGLastName").val().trim();

			var extraBedCode=$("#txtExtraBed").val();
			var extraBedDesc=$("#lblExtraBed").text();
				
			gRoomTypeCode=roomType;	
			gRoomTypeDesc=roomTypeDesc;
					
		  /*funAddDetailsRow(guestName,guestCode,mobileNo,roomType,remark,roomNo,roomDesc,extraBedCode,extraBedDesc,"N",address,roomTypeDesc);  */
			if(flg==true)
			{
				funAddDetailsRow(guestName,guestCode,'0',roomType,'','',roomDesc,extraBedCode,extraBedDesc,"N",address,roomTypeDesc);
				funFillRoomRate(roomType,roomDesc);
				//dblPaxCnt++;	
			}	
		  	
		}
		
	}
	
	
	function funGetDetailsRowinGrid(ArrivalDate, DepartureDate) 
	{
		var returnVal =0;
		var searchurl=getContextPath()+"/loadRoomLimit.html?ArrivalDate="+ArrivalDate+"&DepartureDate="+DepartureDate;
		$.ajax({
	        type: "GET",
	        url: searchurl,
	        dataType: "json",
	        async:false,
			success: function(response)
	        {
	        	returnVal = response;
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
		
		return returnVal;
	}
	
	
// Function to add detail grid rows	
	function funAddDetailsRow(guestName,guestCode,mobileNo,roomType,remark,roomNo,roomDesc,extraBedCode,extraBedDesc,payee,address,roomTypeDesc)
	{
	    var table = document.getElementById("tblResDetails");
	    var rowCount = table.rows.length;
	    var row = table.insertRow(rowCount);
	    rowCount=listRow;

	    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"20%\" name=\"listReservationDetailsBean["+(rowCount)+"].strGuestName\" id=\"strGuestName."+(rowCount)+"\" value='"+guestName+"' />";
	    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" name=\"listReservationDetailsBean["+(rowCount)+"].lngMobileNo\" id=\"lngMobileNo."+(rowCount)+"\" value='"+mobileNo+"' />";
	    
	    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"7%\"  id=\"strRoomType."+(rowCount)+"\" value='"+roomTypeDesc+"' />";
	    row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"9%\" name=\"listReservationDetailsBean["+(rowCount)+"].strRemark\" id=\"strRemark."+(rowCount)+"\" value='"+remark+"' />";
	    
	    if(payee=='Y')
	    	{
	    		row.insertCell(4).innerHTML= "<input id=\"cbItemCodeSel."+(rowCount)+"\" type=\"radio\" checked=\"checked\" class=\"Box payeeSel\" name=\"listReservationDetailsBean.strPayee\" size=\"2%\"   value=\"Y\" onClick=\"Javacsript:funRadioRow(this)\"  />";
	    	}else
	    	{
	    		row.insertCell(4).innerHTML= "<input id=\"cbItemCodeSel."+(rowCount)+"\" type=\"radio\" class=\"Box payeeSel\" name=\"listReservationDetailsBean.strPayee\" size=\"2%\" value=\"N\" onClick=\"Javacsript:funRadioRow(this)\"  />";
	    	}
	    
	    row.insertCell(5).innerHTML= "<input type=\"button\" class=\"deletebutton\" size=\"2%\" value = \"\" onClick=\"Javacsript:funDeleteRow(this)\"/>";
	    
	    row.insertCell(6).innerHTML= "<input type=\"hidden\"  name=\"listReservationDetailsBean["+(rowCount)+"].strGuestCode\" id=\"strGuestCode."+(rowCount)+"\" value='"+guestCode+"' />";
	    row.insertCell(7).innerHTML= "<input type=\"hidden\" size=\"0%\" name=\"listReservationDetailsBean["+(rowCount)+"].strRoomNo\" id=\"strRoomNo."+(rowCount)+"\" value='"+roomNo+"' />";
	    row.insertCell(8).innerHTML= "<input type=\"hidden\" size=\"0%\" name=\"listReservationDetailsBean["+(rowCount)+"].strExtraBedCode\" id=\"strExtraBedCode."+(rowCount)+"\" value='"+extraBedCode+"' />";
	    row.insertCell(9).innerHTML= "<input type=\"hidden\" size=\"0%\" name=\"listReservationDetailsBean["+(rowCount)+"].strAddress\" id=\"strAddress."+(rowCount)+"\" value='"+address+"' />";
	    row.insertCell(10).innerHTML= "<input type=\"hidden\" size=\"0%\" id=\"strRoomDesc."+(rowCount)+"\" value='' />";
	    row.insertCell(11).innerHTML= "<input type=\"hidden\"  size=\"0%\" id=\"strExtraBedDesc."+(rowCount)+"\" value='"+extraBedDesc+"' />";
	    row.insertCell(12).innerHTML= "<input type=\"hidden\" size=\"0%\" name=\"listReservationDetailsBean["+(rowCount)+"].strRoomType\" id=\"strRoomType."+(rowCount)+"\" value='"+roomType+"' />";
	    $("#txtRemark").val(remark); 
	    funResetDetailFields();
	    
	    if(payee=='Y')
	    	{
	    	 	$("#hidPayee").val(guestCode);
	    	}
	    
	    listRow++;
	    dblPaxCnt++;
	    
	   
	}

	function funRadioRow(rowObj)
	{
		/* $( "input[type='radio']" ).prop({
			checked: false
			}); */
			var no=0;
			$('#tblResDetails tr').each(function() {
				
				if(document.getElementById("cbItemCodeSel."+no).checked == true)
					{
					  var gustcode = document.getElementById("strGuestCode."+no).value;
					  $("#hidPayee").val(gustcode);
					}
				no++;
			});
	}

	function funHelp(transactionName)
	{
		fieldName=transactionName;
		window.open("searchform.html?formname="+transactionName+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
		//window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
	function funHelp1(transactionName,row)
	{
		gridHelpRow=row;
		fieldName=transactionName;
		var condition = $("#txtRoomTypeCode").val();
		if(condition=='')
			{
			alert("Please Select Room Type")
			}
		else
			{
			if(transactionName=="roomByRoomType" && condition!=" ")
			{
				window.open("searchform.html?formname="+fieldName+"&strRoomTypeCode="+condition+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
			
			}
			else
			{
				if(condition==" ")
				{
					alert("Please Select Room Type !!!");
				}
				//window.open("searchform.html?formname="+transactionName+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
			}
			}
		
	}
		
	
	function funValidateForm()
	{
		var flg=false;
		if($("#txtCorporateCode").val()=='')
		{
			var ArrivalDate1 = $("#txtArrivalDate").val();
			var DepartureDate1 = $("#txtDepartureDate").val();
			if(ArrivalDate1>DepartureDate1){
				alert("Arrival Date must be Greater than DepartureDate")
				flg=false;
			}
			
			if($("#txtBookingTypeCode").val()=='')
			{
				alert("Please Select Booking Type");
				flg=false;
				$("#txtBookingTypeCode").focus();
			}
			else
			{
				if($('#txtEmailId').val()=='')
				{
					flg=true;
				}
				else
				{
					var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;

			        if (reg.test($('#txtEmailId').val()) == false) 
			        {
			            alert('Invalid Email Address');
			            flg=false;
			        }	
				}
				
				
				if($("#txtArrivalTime").val()=='')
				{
					alert("Please Enter Arrival Time");
					flg=false;
				}
				
				if($("#txtDepartureTime").val()=='')
				{
					alert("Please Enter Departure Time");
					flg=false;
				}
				
//		 		if($("#hidPayee").val()=='')
//		 		{
//		 			alert("Please Select One Payee");
//		 			return false;
//		 		}
			/* 	if($("#txtRoomNo").val()=='')
				{
					alert('Select Room No!!!');
					$("#txtRoomNo").focus();
					return false;
				}
				 */
				if($("#txtNoOfAdults").val()=='')
				{
					alert('Enter No of Adults!!!');
					$("#txtNoOfAdults").focus();
					flg=false;
				}
				
				if($("#txtNoOfChild").val()=='')
				{
					alert('Enter No of Child!!!');
					$("#txtNoOfChild").focus();
					flg=false;
				}
				
				var table = document.getElementById("tblResDetails");
			    var rowCount = table.rows.length;
				if(rowCount==0)
				{
					alert("Please Enter Guest For Reservation");
					flg=false;
				}
				
				var ArrivalDate = $("#txtArrivalDate").val();
				var DepartureDate = $("#txtDepartureDate").val();
				var roomLimitCount = funGetDetailsRowinGrid(ArrivalDate, DepartureDate)

				if(roomLimitCount == "0"){
					alert("Room Limit exceed for today");
					flg=false;
				}

				var ArrivalDate = new Date($("#txtArrivalDate").val()); //Year, Month, Date
		        var DepartureDate = new Date($("#txtDepartureDate").val()); //Year, Month, Date
		        if (ArrivalDate > DepartureDate) {
				    	alert("Departure Date Should not be come before Arrival Date");
				    	flg=false;
		        }
		        
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
		        }
		        
		        
				
			}
		}
		
		else
		{
			flg = true;
			var table = document.getElementById("tblResDetails");
		    var rowCount = table.rows.length;
			if(rowCount>0)
			{
				
			}			
			else
			{
				if($("#txtRoomTypeCode").val()=='')
				{
					alert("Please Select Room Type");
					flg=false;
					$("#txtRoomTypeCode").focus();
				}
				
				if($("#txtBookingTypeCode").val()=='')
				{
					alert("Please Select Booking Type");
					flg=false;
					$("#txtBookingTypeCode").focus();
				}				
			}
			
			/* if($("#txtRoomTypeCode").val()=='')
			{
				alert("Please Select Room Type");
				flg=false;
				$("#txtRoomTypeCode").focus();
			}*/
			
			if($("#txtBookingTypeCode").val()=='')
			{
				alert("Please Select Booking Type");
				flg=false;
				$("#txtBookingTypeCode").focus();
			} 
			var guestCode='';
			var mobileNo='0';
			var guestName='';
			var roomType =$("#txtRoomTypeCode").val();
			var roomNo =$("#txtRoomNo").val();
			var roomDesc =$("#lblRoomNo").text().trim();
			var extraBedCode=$("#txtExtraBed").val();
			var extraBedDesc=$("#lblExtraBed").text();
			var remark=$("#txtRemark").val();
			var address=$("#txtAddress").val();
			var roomTypeDesc=$("#lblRoomType").text();
			/* if(flg==true)
			{
				funAddDetailsRow(guestName,guestCode,mobileNo,roomType,remark,roomNo,roomDesc,extraBedCode,extraBedDesc,"N",address,roomTypeDesc);
				funFillRoomRate(roomType,roomDesc);	
			} */
			
		}
		
		dblPaxCnt = 0;
				
		return flg;
	}
	

	function funSetMarketSourceCode(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadMarketMasterData.html?marketCode=" + code,
			dataType : "json",
			success : function(response){ 
				if(response.strMarketSourceCode=='Invalid Code')
	        	{
	        		alert("Invalid Business Code");
	        		$("#txtMarketSourceCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtMarketSourceCode").val(response.strMarketSourceCode);
		        	$("#lblMarketSourceName").text(response.strDescription);
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

// 	//set Reservation Data
// 	function funSetIncomeHeadData(incomeCode)
// 	{
// 		$("#txtIncomeHead").val(incomeCode);
// 		var searchUrl=getContextPath()+"/loadIncomeHeadMasterData.html?incomeCode="+incomeCode;
// 		$.ajax({
			
// 			url:searchUrl,
// 			type :"GET",
// 			dataType: "json",
// 	        success: function(response)
// 	        {
// 	        	if(response.strIncomeHeadCode=='Invalid Code')
// 	        	{
// 	        		alert("Invalid Reservation No.");
// 	        		$("#txtIncomeHead").val('');
// 	        	}
// 	        	else
// 	        	{
// 	        		$("#txtIncomeHead").val(response.strIncomeHeadCode);
// 	        		$("#lblIncomeHeadName").text(response.strIncomeHeadDesc);
// 	        	}
// 			},
// 			error: function(jqXHR, exception) 
// 			{
// 	            if (jqXHR.status === 0) {
// 	                alert('Not connect.n Verify Network.');
// 	            } else if (jqXHR.status == 404) {
// 	                alert('Requested page not found. [404]');
// 	            } else if (jqXHR.status == 500) {
// 	                alert('Internal Server Error [500].');
// 	            } else if (exception === 'parsererror') {
// 	                alert('Requested JSON parse failed.');
// 	            } else if (exception === 'timeout') {
// 	                alert('Time out error.');
// 	            } else if (exception === 'abort') {
// 	                alert('Ajax request aborted.');
// 	            } else {
// 	                alert('Uncaught Error.n' + jqXHR.responseText);
// 	            }
// 	        }
// 		});
// 	}
	
	function funAddRow()
	{
		var flag=false;
		
		
		if($("#txtIncomeHead").val().trim().length==0)
		{
			alert("Please Select Income Head.");
		}
		
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
				var table = document.getElementById("tblResDetails");
			    var rowCount = table.rows.length;
				if(rowCount==0)
				{
					alert("Please Enter Guest For Reservation");
					
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
		}		
		return flag;
	}
	
	function funGetPreviouslyLoadedPkgList(resPackageIncomeHeadList)
	{
		$.each(resPackageIncomeHeadList, function(i,item)
		 {
	 		funAddIncomeHeadRow(item.strIncomeHeadCode,item.strIncomeHeadName,item.dblIncomeHeadAmt);
	 	 });
		
	}
	
	
	
	
	//add income head
	function funAddIncomeHeadRow(incomeHeadCode,incomeHeadName,incomeHeadAmt)
	{
		/*var incomeHeadCode=$("#txtIncomeHead").val();
		var incomeHeadName=$("#txtIncomeHeadName").val();
		var incomeHeadAmt=$("#txtIncomeHeadAmt").val(); 
		*/var amount="0.0";
		
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
			
			
			 
	 	    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 5px;width:50%;\"  name=\"listRoomPackageDtl["+(rowCount)+"].strIncomeHeadCode\"    id=\"strIncomeHeadCode."+(rowCount)+"\" value='"+incomeHeadCode+"' >";
	 	    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 5px;width:50%;\" name=\"listRoomPackageDtl["+(rowCount)+"].strIncomeHeadName\"   id=\"strIncomeHeadDesc."+(rowCount)+"\" value='"+incomeHeadName+"' >";
	 	    row.insertCell(2).innerHTML= "<input type=\"readonly\"   class=\"Box \"  style=\"text-align:right;\" name=\"listRoomPackageDtl["+(rowCount)+"].dblIncomeHeadAmt\"   id=\"dblIncomeRate."+(rowCount)+"\" value='"+incomeHeadAmt+"' >";
	 	    row.insertCell(3).innerHTML= "<input type=\"button\" value=\"\" style=\"padding-right: 5px;width:80%;text-align: right;\" class=\"deletebutton\" onclick=\"funRemoveRow(this)\" />";
					
		//calculate totals
			funCalculateTotals();
		
			//$("#txtIncomeHead").val('');
			//$("#dblIncomeHeadAmt").val('');
		}
	}
	var totalTarriff=0;
	//check duplicate value
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
	
	function funGetSelectedRow(obj)
	{
		 var index = obj.parentNode.parentNode.rowIndex;
		  //  var table = document.getElementById("tblRommRate");
		//    table.deleteRow(index);
		
		
		var isOk=confirm("Do You Want Change Amount For all Room Type Rate ?");
		if(isOk)
			{
				var value1=document.getElementById("dblRoomRate."+index).value;
				for(var i=0;i<document.getElementById("tblRommRate").rows.length;i++)
			    {
					document.getElementById("dblRoomRate."+i).value=value1;
					//var objName =document.getElementById("dblRoomRate."+i);
			       // totalTarriff=totalTarriff+parseFloat(objName.value);
			    }
			}
		funCalculateTotals();
	}
	
	//calculate totals
	function funCalculateTotals()
	{			
		
		/* var totalAmt=0.00;
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
		//$("#dblTotalAmt").text(totalAmt);
		
		//For tarrif
		
		
		totalTarriff=0;
		if(document.getElementById("tblRommRate").rows.length>0)
		{
			for(var i=0;i<document.getElementById("tblRommRate").rows.length;i++)
		    {
				var objName =document.getElementById("dblRoomRate."+i);
		        totalTarriff=totalTarriff+parseFloat(objName.value);
		    }
			totalTarriff=parseFloat(totalTarriff).toFixed(maxAmountDecimalPlaceLimit);
		}
		$("#txtTotalAmt").val(totalTarriff); 
		 */
		 
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
		//$("#dblTotalAmt").text(totalAmt);
		
		//For tarrif
		
		
		totalTarriff=0;
		if(document.getElementById("tblRommRate").rows.length>0)
		{
			for(var i=0;i<document.getElementById("tblRommRate").rows.length;i++)
		    {
				var objName =document.getElementById("dblRoomRate."+i);
		        totalTarriff=totalTarriff+parseFloat(objName.value);
		    }
			totalTarriff=parseFloat(totalTarriff).toFixed(maxAmountDecimalPlaceLimit);
		}
		$("#txtTotalAmt").val(totalTarriff); 
		
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
		row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 67%;width:100%; font-size:13px; font-weight: bold;text-align:right; \"  id=\"strPackageDesc."+(rowCount)+"\" value='Room Tarrif' >";
	    row.insertCell(1).innerHTML= "<input type=\"readonly\"   class=\"Box \" style=\"text-align:right; font-size:13px; font-weight: bold;width:95%;\"  id=\"dblIncomeRate."+(rowCount)+"\" value='"+totalTarriff+"' >";
	    var totalPkgAmt=0;
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
	
	function funFillRoomRate(roomNo,roomDesc)
	{
		
		 var arrivalDate= $("#txtArrivalDate").val();
		 var departureDate=$("#txtDepartureDate").val();
		 var roomDescList = new Array();
		 var table = document.getElementById("tblResDetails");
		 var rowCount = table.rows.length;
		 for (i = 0; i < rowCount; i++){
			 
			 var oCells = table.rows.item(i).cells;
			 
			 if(roomDescList!='')
			 {
					 roomDescList = roomDescList + ","+table.rows[i].cells[12].children[0].value;
				
			 }
			
			 else
			 {
				 roomDescList = table.rows[i].cells[12].children[0].value;	 
			 }	 

		}
		 $.ajax({  
				type : "GET",
				url : getContextPath()+ "/loadRoomRate.html?arrivalDate="+arrivalDate+"&departureDate="+departureDate+"&roomDescList="+roomDescList+"&noOfNights="+$("#txtNoOfNights").val(),
				dataType : "json",
				 async:false,
				success : function(response){ 
				funAddRommRateDtl(response,roomNo,roomDesc);
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

	

	function funAddRommRateDtl(dataList,roomNo,roomDesc)
	{
		$('#tblRommRate tbody').empty()
		 var table=document.getElementById("tblRommRate");
		 
		 for(var i=0;i<dataList.length;i++ )
	     {
			 var rowCount=table.rows.length;
			 var row=table.insertRow();
		 var list=dataList[i];
		 var date=list[0];
		 var dateSplit= date.split("-");
		 var month=dateSplit[1];
		 var day = dateSplit[2];
// 		 if(day<10) 
// 		 {
// 			 day='0'+day;
// 		 } 

// 		 if(month<10) 	
// 		 {
// 			 month='0'+month;
// 		 } 
		var dblRate = list[1];
		
		 date=day+"-"+month+"-"+dateSplit[0];
		 row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-center: 5px;width:50%;\" name=\"listReservationRoomRateDtl["+(rowCount)+"].dtDate\"  id=\"dtDate."+(rowCount)+"\" value='"+date+"' >";
 	     row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" id=\"strTypeRoomDesc."+(rowCount)+"\" value='"+list[2]+"' />";
 	     row.insertCell(2).innerHTML= "<input type=\"text\"    style=\"text-align:right;\"  name=\"listReservationRoomRateDtl["+(rowCount)+"].dblRoomRate\" id=\"dblRoomRate."+(rowCount)+"\" onchange =\"Javacsript:funGetSelectedRow(this)\" value='"+dblRate+"' >";
 	     row.insertCell(3).innerHTML= "<input type=\"hidden\" class=\"Box \"  name=\"listReservationRoomRateDtl["+(rowCount)+"].strRoomType\" id=\"strRoomType."+(rowCount)+"\" value='"+list[3]+"' >";
 	  
 	      totalTerrAmt =list[1];
 	  	 $("#txtTotalAmt").val(totalTerrAmt); 
 	   
 	  	
		}
		 
	}
	
	function CalculateDateDiff() 
	{

		var fromDate=$("#txtArrivalDate").val();
		var toDate=$("#txtDepartureDate").val()
		var frmDate= fromDate.split('-');
	    var fDate = new Date(frmDate[1]+"/"+frmDate[0]+"/"+frmDate[2]);//mm/dd/yyyy
	    
	    var tDate= toDate.split('-');
	    var t1Date = new Date(tDate[1]+"/"+tDate[0]+"/"+tDate[2]);//mm/dd/yyyy
	    var Difference_In_Time = t1Date.getTime() - fDate.getTime(); 
    	
  		 if (Difference_In_Time >= 0 ) 
  		 {
  			var total_days = (Difference_In_Time) / (1000 * 60 * 60 * 24);
  			$("#txtNoOfNights").val(total_days);
         	
         }else{
        	 alert("Please Check Departure Date");
        	 $("#txtDepartureDate").datepicker({ dateFormat: 'dd-mm-yy' });
			 $("#txtDepartureDate").datepicker('setDate', pmsDate);
        	 return false
         }
  		funFillRoomRate('','');
  		
		
	}
	
	function funChangeArrivalDate()
	{
		CalculateDateDiff(); 
		var arrivalDate=$("#txtArrivalDate").val();
	    var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
	    var fromDate=$("#txtArrivalDate").val();
		var toDate=$("#txtDepartureDate").val()
		if(toDate>fromDate){
			 alert("Please Check Arrival Date");
			 $("#txtDepartureDate").datepicker({ dateFormat: 'dd-mm-yy' });
			 $("#txtDepartureDate").datepicker('setDate', pmsDate);
			 return false
		}
		else{
			funFillRoomRate('','');
		}
    	/* if (arrivalDate < pmsDate) 
  		 {
		    	alert("Arrival Date Should not be come before PMS Date");
		    	$("#txtArrivalDate").datepicker({ dateFormat: 'dd-mm-yy' });
				$("#txtArrivalDate").datepicker('setDate', pmsDate);
				return false
         } */
    	funFillRoomRate('','');
    	
    	
	}

	
	function validateEmail(emailField){
        var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;

        if (reg.test(emailField.value) == false) 
        {
            alert('Invalid Email Address');
            return false;
        }

        return true;

	}
	
	function funRemoveRow(obj)
	{
	    var index = obj.parentNode.parentNode.rowIndex;
	    var table = document.getElementById("tblIncomeHeadDtl");
	    table.deleteRow(index);
	    funCalculateTotals();
	    dblPaxCnt--;
	}
	
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
	
	function funGetGuestCode(guestCode) 
	{	
		var returnVal =0;
		var searchurl=getContextPath()+"/getGuestCode.html?guestCode="+guestCode;
		 $.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        async:false,
		        success: function(response)
		        {
		        	returnVal = response;
				},
			error : function(e)
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
		
		 return returnVal;
	}
	function funCreateNewGuest(){
		
		window.open("frmGuestMaster.html", "myhelp", "scrollbars=1,width=500,height=350");
<%-- 		var GuestDetails='<%=session.getAttribute("GuestDetails").toString()%>'; --%>
// 		var guest=GuestDetails.split("#");
	
	}
	
/* 	function selectGST(){
		var GST=getElementById("divGST");
		GST.addEventListener("click" ()=>function{
				var showGST=getElementById("showGST");
				showGST.display="show";
		})
	}  */
	
		$(function () {
	        $("#divGST").click(function () {
	            if ($(this).is(":checked")) {
	                $("#showGST").show();
	                
	            } else {
	                $("#showGST").hide();
	                ;
	            }
	        });
	    });
	
	function funOpenGroupBooking()
	{
	    
		
		var strCorporateCode = $("#txtCorporateCode").val();
		var strArrDate = $("#txtArrivalDate").val();
		var strDepartureDate = $("#txtDepartureDate").val();
		var strArrivalTime = $("#txtArrivalTime").val();
		var strDepartureTime = $("#txtDepartureTime").val();
		var adultPax = $("#txtNoOfAdults").val();
		var childPax = $("#txtNoOfChild").val();
		
		var strPaxCnt = parseFloat(adultPax)+parseFloat(childPax);
		var lblCorporateDesc = $("#lblCorporateDesc").text();
	    window.open("frmPMSGroupReservationForReservation.html?lblCorporateDesc="+lblCorporateDesc+"&strPaxCnt="+strPaxCnt+"&strDepartureTime="+strDepartureTime+"&strArrivalTime="+strArrivalTime+"&strDepartureDate="+strDepartureDate+"&strCorporateCode="+strCorporateCode+"&strArrDate="+strArrDate+"&gRoomTypeCode="+gRoomTypeCode+"&gRoomTypeDesc="+gRoomTypeDesc,"","dialogHeight:600px;dialogWidth:800px;top=500,left=500")
	    

	}
	
	
	function funGetMap(gmap)
	{
		/* var lmap=new map();
		lmap=gmap; */
		gmap.forEach(logMapElements);		
	}
	function logMapElements(value, key, map) {
		funAddIncomeHeadRow(value[0],value[1],value[2]);		
		}
	
	
	
	async function funSetGroupCode(code){
		var gCode=code.split("#")[0];		
		$("#txtGroupCode").val(code.split("#")[0]);
		funSetCorporateCode(code.split("#")[2]);
		funSetRoomType(code.split("#")[1]);
		
		var guestCode=code.split("#")[3];
		var mobileNo='0';
		var guestName='';
		var roomType =$("#txtRoomTypeCode").val();
		var roomNo =$("#txtRoomNo").val();
		var roomDesc =$("#lblRoomNo").text().trim();
		var extraBedCode=$("#txtExtraBed").val();
		var extraBedDesc=$("#lblExtraBed").text();
		var remark=$("#txtRemark").val();
		var address=$("#txtAddress").val();
		var roomTypeDesc=$("#lblRoomType").text();
		
		
		funAddDetailsRow(guestName,guestCode,'0',roomType,'','',roomDesc,extraBedCode,extraBedDesc,"N",address,roomTypeDesc);
		funFillRoomRate(roomType,roomDesc);
		
		//$("form").submit();
		var flag=true;
		
		if ($("#txtBookingTypeCode").val() == '') {
			alert("Please Enter Booking Type Code");
			flag=false;
			//return false;
		}
		
		var table = document.getElementById("tblResDetails");
		var rowCount = table.rows.length;
		if (rowCount == 0) {
			alert("Please Add Brand in Grid");
			flag=false;
			//return false;
		}
		
		if(flag==true)
			{
				document.getElementById('txtsubmit').submit();
			}
		
		/* $("txtsubmit").submit(function() {

			if ($("#txtBookingTypeCode").val() == '') {
				alert("Please Enter Booking Type Code");
				return false;
			}
			
			var table = document.getElementById("tblResDetails");
			var rowCount = table.rows.length;
			if (rowCount == 0) {
				alert("Please Add Brand in Grid");
				return false;
			}
			
		});  */
		
		//alert(code);
	}
	function funCallGroupBooking()
	{
		var noOfRooms = $("#txtNoOfBookingRoom").val();
		if(noOfRooms>1)
			{
			isCheckOk =	confirm("Do you want to do group reservation");
			if(isCheckOk)
			{
				if ($("#txtBookingTypeCode").val() == '') {
					alert("Please Enter Booking Type Code");
					//return false;
				}
				else
				{
					funOpenGroupBooking();
				}
				
				
			}
			}
	}
	
	
	function isNumber(evt) {
        var iKeyCode = (evt.which) ? evt.which : evt.keyCode
        if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57))
            return false;

        return true;
    } 
	
	
	function funSetPlanMasterData(code)
	{
		$("#txtPlanCode").val(code);
		var searchurl=getContextPath()+"/loadPlanMasterData.html?planCode="+code;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strPlanCode=='Invalid Code')
			        	{
			        		alert("Invalid Plan Code");
			        		$("#txtPlanCode").val('');
			        	}
			        	else
			        	{
				        	$("#txtPlanDesc").val(response.strPlanDesc);
				        	
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

</script>

</head>
<body>
     <label id="formHeading"> Reservation </label>
	     <s:form  id ="txtsubmit" name="Reservation" method="POST" action="saveReservation.html">
	              <br>
		<div id="multiAccordion">	
		<h3><a href="#">Change/Edit Reservation</a></h3>
		  <div>
			<div class="container transtable"  style="background-color:#f2f2f2;">
				<div class="row" style="padding-bottom:12px">
			    	<div class="col-md-2"><label>Reservation No</label>
						<s:input type="text" id="txtReservationNo" path="strReservationNo" cssClass="searchTextBox" ondblclick="funHelp('ReservationNo');"/>
			    	</div>
			    	
			    	<div class="col-md-2"><label>Property</label>
				    <s:select id="strPropertyCode" path="strPropertyCode" items="${listOfProperty}" required="true"></s:select>
				</div>
				
				<div class="col-md-2"><label id="lblPropName" style="background-color:#dcdada94; width: 100%; height: 42%; margin: 23px 0px;"></label></div>
			
			
			<div class="col-md-2"><label>Corporate</label>
				   <s:input type="text" id="txtCorporateCode" path="strCorporateCode" cssClass="searchTextBox" ondblclick="funHelp('CorporateCode');"/>
			</div>
			
			<div class="col-md-2"><label id="lblCorporateDesc" style="background-color:#dcdada94; width: 100%; height: 42%; margin: 23px 0px;"></label></div>
			
			<div class="col-md-2"><label>Booking Type</label>
				<s:input type="text" id="txtBookingTypeCode" readonly="true" path="strBookingTypeCode" cssClass="searchTextBox" ondblclick="funHelp('BookingTypeCode');"/>
			</div>
			
			<div class="col-md-2"><label id="lblBookingTypeDesc" style="background-color:#dcdada94; width: 100%; height: 42%; margin: 23px 0px;"></label>
			</div>
			
			<div class="col-md-2"><label>Arrival Date</label>
				<s:input type="text" id="txtArrivalDate" path="dteArrivalDate" cssClass="calenderTextBox" style="width:75%;" onchange="funChangeArrivalDate();" />
			</div>
			
			<div class="col-md-2"><label>Departure Date</label>
				<s:input type="text" id="txtDepartureDate" path="dteDepartureDate" cssClass="calenderTextBox" style="width:75%;" onchange="CalculateDateDiff();" />
			</div>
			
			<div class="col-md-2"><label>Arrival Time</label>
				<s:input type="text" id="txtArrivalTime" path="tmeArrivalTime" style="width: 115px;" cssClass="calenderTextBox" />
			</div>
			
			<div class="col-md-2"><label>Departure Time</label>
				<s:input type="text" id="txtDepartureTime" path="tmeDepartureTime" items="${tmeCheckOutPropertySetupTime}" style="width: 115px;" cssClass="calenderTextBox"  />
			</div>
			 	
			<div class="col-md-1"><label>#Adult</label><br>
				 <s:input id="txtNoOfAdults" name="txtNoOfAdults" path="intNoOfAdults" style="width:70%;text-align: right;" type="number" min="1" step="1"/>
			</div>
			
			<div class="col-md-1"><label>#Child</label><br>
				 <s:input id="txtNoOfChild" path="intNoOfChild" style="text-align: right; width:70%;" type="number" min="0" step="1" name="txtNoOfChild"/>			
			</div>
					
			<div class="col-md-1"><label>No Of Nights</label>
				<s:input type="text" class="numeric" id="txtNoOfNights" path="intNoOfNights" style="width:70%;text-align: right;"/>
			</div>
				
			<div class="col-md-1"><label>Booking Rooms</label>
				 <s:input type="number" min="1" step="1" id="txtNoOfBookingRoom" path="intNoRoomsBooked" onchange="funCallGroupBooking()" style="text-align: right;width:70%;" />
			</div>
			
			<div class="col-md-2"><label>Contact Person</label>
				<s:input type="text" id="txtContactPerson" path="strContactPerson"/>
			</div>
			
			<div class="col-md-2"><label>Billing Instructions</label>
				<s:input type="text" id="txtBillingInstCode" path="strBillingInstCode" cssClass="searchTextBox" ondblclick="funHelp('BillingInstCode');"/>
			</div>
			
			<div class="col-md-2"><label id="lblBillingInstDesc" style="background-color:#dcdada94; width: 100%; height: 42%; margin: 23px 0px;"></label></div>
			
			<div class="col-md-2"><label>Booker</label>
			      <s:input type="text" id="txtBookerCode" path="strBookerCode" cssClass="searchTextBox" ondblclick="funHelp('BookerCode');"/>
			</div>
			
			<div class="col-md-2"><label id="lblBookerName" style="background-color:#dcdada94; width: 100%; height: 42%; margin: 23px 0px;"></label></div>
			
			 <div class="col-md-2"><label>Remarks</label>
				<s:input type="text" id="txtRemarks" path="strRemarks"/>
			</div>
			
			<div class="col-md-2"><label>Cancel Date</label>
				 <s:input type="text" id="txtCancelDate" path="dteCancelDate" cssClass="calenderTextBox" style="width: 75%;"/>
			</div>
			
			<div class="col-md-2"><label>Confirm Date</label>
				<s:input type="text" id="txtConfirmDate" path="dteConfirmDate" cssClass="calenderTextBox" style="width: 75%;"/>
			</div>
			
			<div class="col-md-2"><label>Market Source</label>
				 <s:input  type="text" id="txtMarketSourceCode" path="strMarketSourceCode" cssClass="searchTextBox" ondblclick="funHelp('marketsource');"/>
			</div>
			
			<div class="col-md-2"><label id="lblMarketSourceName" style="background-color:#dcdada94; width: 100%; height: 42%; margin: 23px 0px;"></label></div>
  	    
		    <div class="col-md-1"><label>OTA No</label>
				<s:input type="text" id="txtOTANo" path="strOTANo"/>
			</div>
			
  	       <div class="col-md-1"><label>Breakfast</label><br>
		          <input type="checkbox" name="Include Breakfast" value=""/> 
		    </div>
		       	 
		   <div class="col-md-1"><label>Discount %</label>
			    <s:input id="txtDiscountPer" path=""   class="decimal-places-amt numberField" value="0" placeholder="disc" onkeypress="javascript:return isNumber(event)" />
		   </div>
		   
			<div class="col-md-1"><label style="width:140%">Cost Per Night</label>
			    <s:input id="txtSubTotal" path=""   class="decimal-places-amt numberField" value="0" placeholder="amt" onkeypress="javascript:return isNumber(event)" />
			</div>
				
			<div class="col-md-1"><label>Total Cost</label>
			    <s:input id="txtSubTotal" path=""   class="decimal-places-amt numberField" value="0" placeholder="amt" onkeypress="javascript:return isNumber(event)" />
			</div>	
			
			
			 <div class="col-md-2"><label>Dont apply tax</label><br />
			     <s:checkbox id="txtDontApplyTax" path="strDontApplyTax" value="Y" />
			</div>
			
			<div class="col-md-2"><label>Bill To Corporate</label><br />
			     <s:checkbox id="txtBillToCorporate" path="strBillToCorporate" value="Y" />
			</div>
			
			<div class="col-md-2"><label>External Number</label>
				 	<s:input type="text" id="txtExternalno" path="strExternalNo" onkeypress="javascript:return isNumber(event)" />
				 	</div>
			
            <div class="col-md-4"><label>Plan </label><s:input id="txtPlanCode" path="strPlanCode" cssClass="searchTextBox" ondblclick="funHelp('plan')" style="height: 50%;width:46%;"/></div>				
			<div class="col-md-2" style="margin-left: -17%;"><label>Plan Desc</label><s:input id="txtPlanDesc" path="strPlanDesc"/></div>				
	
			
		  </div>
         </div>
	  </div>
									
		<h3><a href="#">Traveler/Guest Information</a></h3>
	     <div>
	         <div class="container transtable"  style="background-color:#f2f2f2;">
				<div class="row">
					
			         <div class="col-md-2"><label>Guest Code</label>
						<input id="txtGuestCode" ondblclick="funHelp('guestCode');" class="searchTextBox" />
					</div>
					
					<div class="col-md-1"><input type="Button" value="New Guest" onclick="return funCreateNewGuest()" class="btn btn-primary center-block" style="margin-top: 16px;" class="form_button" />
					</div>
					<div class="col-md-9"></div>
					<br>
				  <div class="col-md-2"><label id="lblGFirstName">First Name</label>
					  <input type="text" id="txtGFirstName"/>
			       </div>
					
				<div class="col-md-2"><label id="lblGMiddleName">Middle Name</label>
				 	<input type="text" id="txtGMiddleName"/>
				 </div>
					
				<div class="col-md-2"><label id="lblGLastName">Last Name</label>
					<input type="text" id="txtGLastName"/>
				</div>
				
				<div class="col-md-3"><label>Email Id</label>
				      <s:input type="text" id="txtEmailId" path="strEmailId"/>
				</div>
				
				<div class="col-md-2"><label>Mobile No</label>
						<input type="text" id="txtMobileNo"/>
				</div>
					
				<div class="col-md-2"><label id="lblRoomType">Room Type</label>
						<input type="text" id="txtRoomTypeCode" name="txtRoomTypeCode" Class="searchTextBox" ondblclick="funHelp('roomType')" />
				</div>
					
			   <div class="col-md-2"><label id="lblRoomNo">Room</label>
			    	<input type="text" id="txtRoomNo" name="txtRoomNo" path="strRoomNo" ondblclick="funHelp1('roomByRoomType')" Class="searchTextBox"/>
			    </div> 
				 
				<div class="col-md-2"><label id="lblExtraBed">Extra Bed</label>
					<input type="text" id="txtExtraBed" name="txtExtraBed" Class="searchTextBox" ondblclick="funHelp('extraBed')" />
				</div>
			
				<div class="col-md-3"><label>Address</label>
					 <input type="text" id="txtAddress"/>
				</div>
				<div class="col-md-2"><label>City</label>
					 <input type="text" id="txtAddress"/>
				</div>
				<div class="col-md-2"><label>State</label>
					 <input type="text" id="txtAddress"/>
				</div>
				
				<div class="col-md-2"><label>Country</label>
					 <input type="text" id="txtAddress"/>
				</div>
				
				<div class="col-md-2"><label>Special Information</label>
					<input type="text" id="txtRemark" path="strRemark"/>
				</div>
				
				 <div class="col-md-1"><label>GST No</label><br>
		              <input type="checkbox" name="GST No" value="" id="divGST" onclick="selectGST"/> 
		       	</div>
		       	<hr />
		       	
		  <div class="col-md-8" id="showGST" style="display: none;" >    
		  	<div class="row"> 	
		       	<div class="col-md-3"><label>GST Number</label>
					 <input type="text" id="txtAddress"/>
				</div>
				<div class="col-md-3"><label>Company Name</label>
					 <input type="text" id="txtAddress"/>
				</div>
				<div class="col-md-4"><label>Company Address</label>
					 <input type="text" id="txtAddress"/>
				</div>
			</div>
		 </div>
				<div class="col-md-1">
					<input type="Button" value="Add" onclick="return funGetDetailsRow()" class="btn btn-primary center-block" style="margin-top: 16px;margin-left:-90px;" class="smallButton" />
			    </div>
			    
			<!--     <div class="col-md-1" style="padding-left: 0px; padding-top: 16px;">
			        <a href="#" class="mdi  mdi-paperclip menu-link" id="" title="Attched document" style="font-size: 26px;margin-left:-100px;"></a>
			    </div> -->
			    
			    <div class="dynamicTableContainer" style="height: 300px;">
			<table style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
				<tr bgcolor="#c0c0c0">				
					<td style="width:17.5%;">Name</td>
					<td style="width:6%;">Mobile No</td>
<!-- 					<td style="width:7%;">Room No</td> -->
<!-- 					<td style="width:9%;">Extra Bed</td> -->
					<td style="width:5%;">Room Type</td>
					<td style="width:4%;">Remarks</td>
					<td style="width:4%;">Payee</td>
					<td style="width:25%;">Delete</td>
				</tr>
			</table>
		
			<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 250px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
				<table id="tblResDetails"
					style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
					class="transTablex col8-center">
					<tbody>
						<col style="width: 37%;">
						<col style="width: 16% ;">
						<col style="width: 80px;">
						<col style="width: 100px;">
						<col style="width: 10%;">
						<col style="width: 7%;">
						<col style="width: 8%;">
						<col style="width: 38%;">
						<col style="width: 0px;">
						<col style="width: 0px;">
						<col style="width: 0px;">
						<col style="width: 0px;">
						<col style="width: 0px;">
						<col style="width: 0px;">
						<col style="width: 0px;">
							
					</tbody>
				</table>
			</div>
		</div>	
				</div>							
		      </div>
			</div>
					
       <h3><a href="#">Special Requests</a></h3>
		  <div>
		     <div class="container transtable"  style="background-color:#f2f2f2;">
				<div class="row" style="padding:15px">
				<div class="row" >
				   <div class="col-md-12"><label>Special Requests</label></div>
				   
				   <div class="col-md-2"><label>Non Smoking Room</label><br>
		              <input type="checkbox" name="GST No" value=""/> 
		       	</div>
		       	<div class="col-md-2"><label>Late Check-in</label><br>
		              <input type="checkbox" name="GST No" value=""/> 
		       	</div>
		       	<div class="col-md-2"><label>Early Check-in</label><br>
		              <input type="checkbox" name="GST No" value=""/> 
		       	</div>
		       	<div class="col-md-2"><label>Room on a high floor</label><br>
		              <input type="checkbox" name="GST No" value=""/> 
		       	</div>
		       	<div class="col-md-1"><label>Large Bed</label><br>
		              <input type="checkbox" name="GST No" value=""/> 
		       	</div>
		       	<div class="col-md-1"><label>Twin Beds</label><br>
		              <input type="checkbox" name="GST No" value=""/> 
		       	</div>
		       	<div class="col-md-2"><label>Airport Transfer</label><br>
		              <input type="checkbox" name="GST No" value=""/> 
		       	</div>
		       	<div class="col-md-6"><label>ANY OTHER REQUESTS?</label><br>
		              <input type="text" name="GST No" value="" style="height:50%"/> 
		       	</div>
		       	<div class="col-md-6"></div><br>
		       	</div>
		       	
					<div class="col-md-2"><label>Business Source</label>
						<s:input type="text" id="txtBusinessSourceCode" path="strBusinessSourceCode" cssClass="searchTextBox" ondblclick="funHelp('business');"/>
					         <label id="lblBusinessSourceName"></label>
					 </div>
					 
					 <div class="col-md-2"><label>Agent</label>
						   <s:input type="text" id="txtAgentCode" path="strAgentCode" cssClass="searchTextBox" ondblclick="funHelp('AgentCode');"/>
					           <label id="lblAgentName"></label>
			          </div>
			          
			          <div class="col-md-2"><label>No Post Folio</label>
				            <s:input type="text" id="txtDropTime" path="tmeDropTime" cssClass="calenderTextBox"  />
				     </div>
				     
			          <div class="col-md-2"><label>Pick Up Time</label>
				            <s:input type="text" id="txtPickUpTime" path="tmePickUpTime" style="width: 70%;" cssClass="calenderTextBox" />
				      </div>
			
			         <div class="col-md-2"><label>Drop Time</label>
				            <s:input type="text" id="txtDropTime" path="tmeDropTime" style="width: 70%;" cssClass="calenderTextBox"  />
				     </div>
				     
			         <div class="col-md-3"><label>Arrival Location</label>
					 		<input type="text" id="txtArrivalLocation"/>
				     </div>
				     
					<div class="col-md-3"><label>Drop Location</label>
					 		<input type="text" id="txtDropLocation"/>
					</div>
					
					<div class="col-md-3"><label>Room Instructions</label>
					 		<input type="text" id="txtRoomInstructions"/>
					</div>
				</div>							
		      </div>
		  </div>
			
       <h3><a href="#">Tarif</a></h3>
		  <div>
		      <div class="container transtable"  style="background-color:#f2f2f2;">
				 <div class="row" style="padding:10px;">
				  <!-- Start of Tarif Tab -->

	              <!-- Generate Dynamic Table   -->		
	                   <br/><br/><br/>
		   <div class="dynamicTableContainer" style="height: 444px; width: 80%">
			   <table style="height: 28px; border: #0F0; width: 100%;font-size:11px; font-weight: bold;">
				<tr bgcolor="#c0c0c0" style="height: 24px;">
					<!-- col1   -->
					<td align="center" style="width: 30.6%;text-align:left">Date</td>
					<!-- col1   -->
					
					<!-- col2   -->
					<td align="center" style="width: 30.6%;text-align:left">Room Type.</td>
					<!-- col2   -->
					
					<!-- col3   -->
					<td align="center" style="width: 30.6%;text-align:left">Rate.</td>
					<!-- col3   -->
					
													
				</tr>
			    </table>
			<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 400px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
				<table id="tblRommRate" style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll" class="transTablex col3-center">
					<tbody>
						<!-- col1   -->
						<col width="100%">
						<!-- col1   -->
						
						<!-- col2   -->
						<col width="100%" >
						<!-- col2   -->
						
						<!-- col2   -->
						<col width="100%" >
						<!-- col2   -->
						
					</tbody>
				</table>
			</div>			
	
	
	</div>
	<div style="margin:auto;width: 12%; float:right; margin-right:225px; "><label>Total</label>
        <s:input id="txtTotalAmt" path="" style="text-align:right;" readonly="true" cssClass="shortTextBox"/>
	</div>

				 </div>							
		      </div>
	       </div>
	       
	    <h3><a href="#">Package</a></h3>
		<div>
		<div class="container transtable"  style="background-color:#f2f2f2;">
			<div class="row">
				
	 	     	<div class="col-md-2"><label>Package Code</label>
			    	<s:input id="txtPackageCode" path="strPackageCode"  readonly="true"  ondblclick="funHelp('package')" cssClass="searchTextBox"/>
				 </div>
			 
			    <div class="col-md-3"><label>Package Name</label>
			    	<s:input id="txtPackageName" path="strPackageName"/>
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
			
				<s:input type="hidden" id="txtGroupCode" path="strGroupCode" cssClass="searchTextBox" />
			    
			
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
			<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 148px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
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
	 
	 </div>
	</div>
			  
		<br /><br />
		<p align="center">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" onclick="return funValidateForm();" />
			&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetDetailFields()"/>
		</p>
		     <s:input type="hidden" id="hidPayee" path="strPayeeGuestCode"></s:input>
		     <s:input type="hidden" id="hidIncomeHead" path="strIncomeHeadCode"></s:input>
		     <s:input type="hidden" id="txtTotalPackageAmt" path="strTotalPackageAmt"></s:input>
	     </div>
	</s:form>                                                                              
			  
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
							