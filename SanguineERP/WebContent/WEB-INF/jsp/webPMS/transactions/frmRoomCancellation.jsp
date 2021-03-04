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
	
// Validate form before submit
	
	function funValidateData()
	{
		var isValid=false;
		if($("#txtReservationNo").val().trim().length<1)
		{
			alert("Please Select Reservation.");
			$("#txtReservationNo").focus();
			isValid=false;
		}
		else if($("#txtReasonCode").val().trim().length<1)
		{
			alert("Please Select Reason.");
			$("#txtReasonCode").focus();
			isValid=false;
		}
		else if($("#txtRemarks").val().trim().length<1)
		{
			alert("Please Enter Remark.");
			$("#txtRemarks").focus();
			isValid=false;
		}
		else
		{
			isValid=true;
		}		
		return isValid;
	}

	
//set Reservation Data
	function funSetReservationData(reservationNo)
	{
		var arrivalFromDate=$("#txtArrivalFromDate").val();
		var arrivalToDate=$("#txtArrivalToDate").val();
		var searchUrl=getContextPath()+"/loadReservationDataForCheckIn.html?reservationNo="+reservationNo+"&arrivalFromDate="+arrivalFromDate+"&arrivalToDate="+arrivalToDate;
		$.ajax({
			
			url:searchUrl,
			type :"GET",
			dataType: "json",
	        success: function(response)
	        {
	        	if(response.strReservationNo=='Invalid Code')
	        	{
	        		alert("Invalid Reservation No.");
	        		$("#txtReservationNo").val('');
	        	}
	        	else
	        	{
	        		$("#txtReservationNo").val(response[0][0]);
	        		$("#txtGuestName").val(response[0][3]);
	        		$("#lblCorporateName").text(response[0][2]);
/* 	        		$("#txtGuestName").val(response[0][1]);
 */	        		$("#lblRoomNo").text(response[0][4]);
	        		$("#txtGuestCode").val(response[0][2]);
	        		$("#txtRemarks").text(response[0][6]);
	        		$("#txtRoomNo").val(response[0][6]);
	        		$("#dteResDate").val(response[0][7]);
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

	/* set date values */
	function funSetDate(id,responseValue)
	{
		var id=id;
		var value=responseValue;
		var date=responseValue.split(" ")[0];
		
		var y=date.split("-")[0];
		var m=date.split("-")[1];
		var d=date.split("-")[2];
		
		$(id).val(d+"-"+m+"-"+y);
	}	

	
//set date
	$(document).ready(function(){
		
		var pmsDate='today';
		<% if(session.getAttribute("PMSDate")!=null){ %>
		pmsDate='<%=session.getAttribute("PMSDate").toString() %>';
		
		 
		<%}%>; 
		
		 $("#txtArrivalFromDate").datepicker({dateFormat : 'dd-mm-yy'}); 
		 $("#txtArrivalFromDate").datepicker('setDate', pmsDate); 
		
		 $("#txtArrivalToDate").datepicker({dateFormat : 'dd-mm-yy'}); 
		 $("#txtArrivalToDate").datepicker('setDate', pmsDate); 
		 
		 $("#dteResDate").datepicker({dateFormat : 'dd-mm-yy'}); 
		 $("#dteResDate").datepicker('setDate', pmsDate); 
		
<%-- 		 var pmsDate='<%=session.getAttribute("PMSDate").toString()%>'; --%>
// 		  var dte=pmsDate.split("-");
// 		  $("#txtPMSDate").val(dte[2]+"-"+dte[1]+"-"+dte[0]);

			var strIndustryType='<%=session.getAttribute("selectedModuleName").toString()%>';
	   		if(strIndustryType=='7-WebBanquet') 
	   		{
	   			$('#lblFormName').text('Booking Cancellation');
	   			$('#lblNo').text('Booking No.');
	   			$('#trDate').hide(); 
	   			$('#txtCorporate').hide();
	   			$('#lblCorporate').hide();
	   			document.title = 'Booking Cancellation';	   			
	   		}
	   		else
   			{
	   			$('#lblFormName').text('Reservation Cancellation');
	   			$('#lblNo').text('Reservation No.');
	   			
   			}
	   		<%-- var strBookingNO='<%=session.getAttribute("BookingNo").toString()%>';
	   		if(strBookingNO!='')
			 {
				 $("#txtReservationNo").val(strBookingNO);				
				 funSetReservationData(strBookingNO);
				 <%session.removeAttribute("BookingNo");%>
			 }
			 else
			 {				
				 $("#txtReservationNo").val("");
				 <%session.removeAttribute("BookingNo");%>
				 
			 }  --%>
	   		
	});
	
	/**
	* Success Message After Saving Record
	**/
	$(document).ready(function()
	{
		var message='';
		<%if (session.getAttribute("success") != null) 
		{
			if(session.getAttribute("successMessage") != null){%>
				message='<%=session.getAttribute("successMessage").toString()%>';
			    <%
			    session.removeAttribute("successMessage");
			}
			boolean test = ((Boolean) session.getAttribute("success")).booleanValue();
			session.removeAttribute("success");
			if (test)
			{
				%>	
				alert("Data Save successfully\n\n"+message);
			<%
			}
		}%>
	});
	
	
	/**
		* Success Message After Saving Record
	**/
	function funSetData(code)
	{
		switch(fieldName)
		{
			case "ReservationNo":
				funSetReservationData(code);
			break;
			
			case 'reasonPMS' : 
				funSetReasonData(code);
			break;
			
			case 'roomCode' : 
				funSetRoomNo(code);
			break;
			
			case 'BookingNo' : 
				funSetReservationData(code);
			break;
			
			case 'reason' : 
				funSetReasonNo(code);
			break;
		}
	}
	
	function funHelp(transactionName)
	{
		var strIndustryType='<%=session.getAttribute("selectedModuleName").toString()%>';
		if(strIndustryType=='7-WebBanquet') 
   		{
			if(transactionName.includes('reasonPMS'))
				{
				transactionName='reason';	
				}
			else if(transactionName.includes('ReservationNo'))
				{
					transactionName='BookingNo';
				}
			
		}
   		
		fieldName=transactionName;
		window.open("searchform.html?formname="+transactionName+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
		//window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
	/**
	* Get and Set data from help file and load data Based on Selection Passing Value(Reason Code)
	**/
	function funSetBookingNo(code)
	{
		$("#txtReservationNo").val(code);
	}
	
	 function funSetReasonNo(code)
	{
		$("#txtReasonCode").val(code);
	} 
	
	function funSetReasonData(code)
	{
		$("#txtReasonCode").val(code);
		var searchurl=getContextPath()+"/loadPMSReasonMasterData.html?reasonCode="+code;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strReasonCode=='Invalid Code')
			        	{
			        		alert("Invalid Reason Code");
			        		$("#txtReasonCode").val('');
			        	}
			        	else
			        	{	
			        		$("#txtReasonCode").val(response.strReasonCode);
			        		$("#lblReasonDesc").text(response.strReasonDesc);
				        	
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

	function funSetRoomType(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadRoomTypeMasterData.html?roomCode=" + code,
			dataType : "json",
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

</script>

</head>
<body>
  <div class="container masterTable">
	<label id="formHeading"> Room Cancellation </label>     <!-- <label id="lblFormName"></label> -->
	   <s:form name="RoomCancellation" method="POST" action="saveRoomCancellation.html">
 
        <div class="row">
            <div class="col-md-2"><label> Property</label>
				  <s:select id="strPropertyCode" path="strPropertyCode" items="${listOfProperty}" required="true"></s:select>
			</div>
			
			<div class="col-md-2"><label id="lblNo"></label>
			      <s:input id="txtReservationNo" path="strReservationNo" readonly="true"  ondblclick="funHelp('ReservationNo')" cssClass="searchTextBox"/>
			</div>
			
			<div class="col-md-2"><label> Reservation Date </label>
				<s:input id="dteResDate" path="" class="calenderTextBox" style="width:70%;"  readonly="true" />
			</div>
			 <div class="col-md-6"></div>
			 
			 <div class="col-md-2"><label> Guest Name </label>
				<s:input id="txtGuestName" path="strGuestName"  readonly="true" />
			</div>
			<div class="col-md-2" id="trDate"><label> Arrival From Date </label>
				  <s:input type="text" id="txtArrivalFromDate" path="dteArrivalFromDate" required="true" class="calenderTextBox" style="width:70%;" />
		     </div>
		     
			<div class="col-md-2"><label> Arrival To Date </label>
				  <s:input type="text" id="txtArrivalToDate" path="dteArrivalToDate" required="true" class="calenderTextBox" style="width:70%;"/>
			</div>
			
<!-- 			<tr> -->
<!-- 				<td width="10%"><label>Room Type</label></td> -->
<!-- 				<td width="10%"><label id="lblRoomType"></label></td> -->
<!-- 				<td colspan="2"> -->
<!-- 			</tr> -->
			
				<div class="col-md-6"></div>
			
            <div class="col-md-2"><label> Reason Code </label>
			     <s:input type="text" id="txtReasonCode" path="strReasonCode" cssClass="searchTextBox" ondblclick="funHelp('reasonPMS');" style="height:45%"/>
			 </div>
			 
			 <div class="col-md-2"><br><label id="lblReasonDesc" style="background-color:#dcdada94; width: 100%; height: 50%;"></label></div>
			
			 
			<%-- <div class="col-md-2"><label id="lblCorporate"> Corporate </label>
				  <span id="txtCorporate"><s:input id="txtCorporateCode" path="strCorporate" readonly="true"/></span>
				<!-- <td><label id="lblCorporateName"></label></td> -->
			</div> --%>
			
			<div class="col-md-2"><label> Remarks </label>
				  <s:input type="text" id="txtRemarks" path="strRemarks"/>
			</div>
			
			<div class="col-md-2">
			      <s:input id="txtGuestCode" path="strGuestCode" type="hidden" readonly="true" placeholder="last"  />
			</div>
			
		</div>

		<br />
		<p align="center" style="margin-right:49%">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" onclick="return funValidateData()"/>
			&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>

	</s:form>
	</div>
</body>
</html>
