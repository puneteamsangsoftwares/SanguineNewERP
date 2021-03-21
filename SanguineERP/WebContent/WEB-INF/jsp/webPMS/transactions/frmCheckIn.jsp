<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>
<link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap.min.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/design.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.css"/>" />
	 <link rel="stylesheet" type="text/css" media="screen" href="<spring:url value="/resources/css/newdesigncss/bootstrap-grid.min.css"/>" />
	 <link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/Accordian/jquery-ui-1.8.9.custom.css "/>" />
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.bundle.min.js"/>"></script>
	 <script type="text/javascript" src="<spring:url value="/resources/js/newdesignjs/bootstrap.min.js"/>"></script>
     <script type="text/javascript" src="<spring:url value="/resources/js/Accordian/jquery.multi-accordion-1.5.3.js"/>"></script>	
<style>
.transTable td{
padding-left:1px;

}
.dynamicTableContainer{
overflow-x: hidden;
}

</style>
<script type="text/javascript">
	
	var fieldName,gridHelpRow;
	var gset1 =[];
	var gTempAdultcount=0,gTotalNoRoom=0,gTotalNoGuest=0,listRow=0;
	var gAdultCount,cheGuestCode,gcount;
	var gAdult=[];
	var gcount;
	var gRoomMap = new Map();
	var gSetTotalRoom=new Set();
	
	var globalRoomNo=new Map();
	var globalNoOfGuest=new Map();
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
			
			
			$("#txttotrooms").val("0");
			$("#txttotguest").val("0");
			
 	});		
 	
 	$(function() 
 	{
 		var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
 		var rTypeCode= "";
 		$("#txtArrivalTime").timepicker();
 		$("#txtDepartureTime").timepicker();
 		
 		$("#txtArrivalDate").datepicker({ dateFormat: 'dd-mm-yy' });
 		$("#txtArrivalDate").datepicker('setDate', pmsDate);
 		
 		$("#txtDepartureDate").datepicker({ dateFormat: 'dd-mm-yy' });
 		$("#txtDepartureDate").datepicker('setDate', pmsDate);
 		$("#hidPayee").val('N')
		 
 		$('a#baseUrl').click(function() 
 		{
			if($("#txtCheckInNo").val().trim()=="")
			{
				alert("Please Select CheckIn No ");
				return false;
			}
			window.open('attachDoc.html?transName=frmCheckIN.jsp&formName=CheckIn &code='+$('#txtCheckInNo').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
		});
			
		var Warmessage='';
		<%
		if(session.getAttribute("WarningMsg") != null){%>
	     Warmessage='<%=session.getAttribute("WarningMsg").toString()%>';
	    <%
	    	session.removeAttribute("WarningMsg");
	    }%>	
	    if(Warmessage!='')
    	{
	      alert(Warmessage);
    	}
		
		var checkInNo='';
		<%if (session.getAttribute("checkInNo") != null) 
		{
			%>
			checkInNo='<%=session.getAttribute("checkInNo").toString()%>';
			funSetReservationNo(checkInNo);
		    <%
   		 	session.removeAttribute("checkInNo");
		}%>
		
		 var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
		  var dte=pmsDate.split("-");

		  
		 	 document.getElementById('txtReason').style.display = 'none';
			 document.getElementById('txtRemarks').style.display = 'none';
	});

	
	function funSetData(code){

		switch(fieldName){

			case 'RegistrationNo' : 
				funSetRegistrationNo(code);
				break;
				
			case 'ReservationNo' : 
				funSetReservationNo(code);
				break;
				
			case 'WalkinNo' : 
				funSetWalkinNo(code);
				break;
				
			case 'checkIn' : 
				funSetCheckInData(code);
				break;
				
			case 'roomByRoomType' : 
				funSetRoomNo(code,gridHelpRow);
				break;
			
			case 'extraBed' : 
				funSetExtraBed(code,gridHelpRow);
				break;
				
			case "incomeHead":
				funSetIncomeHead(code);
			break;
			
			case "package":
				funSetPackageNo(code);
			break;				
			
			case 'reasonPMS' : 
				funSetReasonData(code);
			break;
			
			case 'guestCode' : 
				funSetGuestCode(code);
				break;			
				
			case 'roomType' : 
				funSetRoomType2(code,gridHelpRow);
				break;
				
			case "plan":
				funSetPlanMasterData(code);
			break;		
	}

	}
	var message='';
	var retval="";
	var checkAgainst="";
	
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
			var checkInNo='';
			var against='';
			var clientCode=	'<%=session.getAttribute("clientCode").toString()%>';
			
			against='<%=session.getAttribute("against").toString()%>';
			if(clientCode != '387.001')
			{
				var isAdvanceOk=confirm("Do You Want to pay Advance Amount ?"); 
				var isCheckOk=confirm("Do You Want to Generate Check-In Slip ?"); 
				if(isCheckOk)
				{
					checkInNo='<%=session.getAttribute("AdvanceAmount").toString()%>';
					
					window.open(getContextPath() + "/rptCheckInSlip.html?checkInNo=" +checkInNo+"&cmbAgainst="+against,'_blank');
				
				 }
				
				if(isAdvanceOk)
				{
					checkInNo='<%=session.getAttribute("AdvanceAmount").toString()%>';
					window.open(getContextPath()+"/frmPMSPaymentAdvanceAmount.html?AdvAmount="+checkInNo+"&against="+against);
					session.removeAttribute("AdvanceAmount");
					session.removeAttribute("against");
					
				}
				
			}
		
			<%-- var isAdvanceOk=confirm("Do You Want to pay Advance Amount ?"); 
			
			if(isAdvanceOk)
			{
				checkInNo='<%=session.getAttribute("AdvanceAmount").toString()%>';
				window.open(getContextPath()+"/frmPMSPaymentAdvanceAmount.html?AdvAmount="+checkInNo+"&against="+against);
				session.removeAttribute("AdvanceAmount");
				session.removeAttribute("against");
				
			} --%>
			<%	
		}
	}%>
	
	function funSetCheckInData(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadCheckInData.html?docCode=" + code,
			dataType : "json",
			success : function(response){ 
				if(response.strCheckInNo!="Invalid")
		    	{
					funFillCheckInHdData(response);
					
		    	}
		    	else
			    {
			    	alert("Invalid Check In No");
			    	$("#txtCheckInNo").val("");
			    	$("#txtCheckInNo").focus();
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
	
	  function funFillCheckInHdData(response)
		{
		   
			$("#txtCheckInNo").val(response.strCheckInNo);
			$("#txtRegistrationNo").val(response.strRegistrationNo);
			$("#txtDocNo").val(response.strAgainstDocNo);
			$("#cmbAgainst").val(response.strType);
			if(response.strType=="Reservation")
			{
				$("#lblAgainst").text("Reservation");
			}
			else
			{
				$("#lblAgainst").text("Walk In No");
			}
					
			$("#txtArrivalDate").val(response.dteArrivalDate);
			$("#txtDepartureDate").val(response.dteDepartureDate);

			$("#txtArrivalTime").val(response.tmeArrivalTime);
			$("#txtDepartureTime").val(response.tmeDepartureTime);
			
			$("#txtRoomNo").val(response.strRoomNo);
			$("#lblRoomNo").text(response.strRoomDesc);
		    $("#txtExtraBed").val(response.strExtraBedCode);
		  /*   $("#lblExtraBed").text(response.strExtraBedDesc);	    */ 
		    $("#txtNoOfAdults").val(response.intNoOfAdults);
		    $("#txtNoOfChild").val(response.intNoOfChild);
		    
		    $("#txtPackageCode").val(response.strPackageCode);
			$("#txtPackageName").val(response.strPackageName);
			
			if(response.strPlanCode!='')
			{
				$("#txtPlanCode").val(response.strPlanCode);
				funSetPlanMasterData(response.strPlanCode);
			}
		   
		    if(response.strNoPostFolio=='Y')
	    	{
	    		document.getElementById("txtNoPostFolio").checked=true;
	    	}
	    	else
	    	{
	    		document.getElementById("txtNoPostFolio").checked=false;
	       	}
			    
		    if(response.strComplimentry=='Y')
	    	{
	    		document.getElementById("txtComplimentry").checked=true;
	    	}
	    	else
	    	{
	    		document.getElementById("txtComplimentry").checked=false;
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
			funFillDtlGrid(response.listCheckInDetailsBean);
			if(response.strType=="Reservation")
			{
				funAddRommRateDtlOnReservationSelect(response.listReservationRoomRateDtl);
			}
			else
			{
				funAddRommRateDtlOnWalkinSelect(response.listWalkinRoomRateDtl);
			}
			funGetPreviouslyLoadedPkgList(response.listRoomPackageDtl);	
			
		}
			
		
		function funFillDtlGrid(resListDtlBean)
		{
			funRemoveProductRows();
			$.each(resListDtlBean, function(i,item)
			{
				
				funAddDetailsRow(resListDtlBean[i].strGuestName,resListDtlBean[i].strGuestCode,resListDtlBean[i].lngMobileNo
					,resListDtlBean[i].strRoomNo,resListDtlBean[i].strRoomDesc,resListDtlBean[i].strExtraBedCode
					,resListDtlBean[i].strExtraBedDesc,resListDtlBean[i].strPayee,resListDtlBean[i].strRoomType);
			});
		}
		
		function funSetReservationNo(code){
			 funRemoveProductRows();
			$.ajax({
				type : "GET",
				url : getContextPath()+ "/loadReservation.html?docCode=" + code,
				dataType : "json",
				success : function(response){ 
					if(response.strReservationNo!="Invalid")
			    	{
					
						funFillHdDataAgainstRes(response);
						//funFillRoomRate();
			    	}
			    	else
				    {
				    	alert("Invalid Reservation No");
				    	$("#txtDocNo").val("");
				    	$("#txtDocNo").focus();
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
	
		
		function funFillHdDataAgainstRes(response)
		{
			
			//gset1=[];
			gAdult=[];
			gAdultCount=[];
			gRoomMap=new Map();
			gTempAdultcount=0,gTotalNoRoom=0,gTotalNoGuest=0,listRow=0;
			
			gcount=response.intNoRoomsBooked;
			gAdultCount=response.intNoOfAdults;
			cheGuestCode=response.strGuestCode;
			$("#txtDocNo").val(response.strReservationNo);
			
			$("#txtArrivalDate").val(response.dteArrivalDate);
			$("#txtDepartureDate").val(response.dteDepartureDate);

			$("#txtArrivalTime").val(response.tmeArrivalTime);
			$("#txtDepartureTime").val(response.tmeDepartureTime);
			
			$("#txtRoomNo").val(response.strRoomNo);
			$("#lblRoomNo").text(response.strRoomDesc);
		    $("#txtExtraBed").val(response.strExtraBedCode);
		    $("#lblExtraBed").text(response.strExtraBedDesc);
		    $("#txtNoOfAdults").val(response.intNoOfAdults);
		    $("#txtNoOfChild").val(response.intNoOfChild);
		    
		    $("#txtPackageCode").val(response.strPackageCode);
			$("#txtPackageName").val(response.strPackageName);
			
			if(response.strPlanCode!='')
			{
				$("#txtPlanCode").val(response.strPlanCode);
				funSetPlanMasterData(response.strPlanCode);
			}
			
			rTypeCode = response.listReservationDetailsBean[0].strRoomType;
		    funRemoveProductRowsForIncomeHead();
			funRemoveTariffRows();
			if(response.listReservationDetailsBean[0].strGuestName!=null)
			{
				funFillDtlGridAgainstRes(response.listReservationDetailsBean);
			}
			
			funAddRommRateDtlOnReservationSelect(response.listReservationRoomRateDtl);
			funGetPreviouslyLoadedPkgList(response.listRoomPackageDtl);
			if(response.strGroupCode.length >0 )
			{
			    for(var i=0;i<gcount;i++)
		    	{
			    	funSetGuestCode(cheGuestCode);
		    	}
				
			}
		}
			
		
		function funFillDtlGridAgainstRes(resListResDtlBean)
		{
			funRemoveProductRows();
			$.each(resListResDtlBean, function(i,item)
			{
				funAddDetailsRow(resListResDtlBean[i].strGuestName,resListResDtlBean[i].strGuestCode,resListResDtlBean[i].lngMobileNo
					,resListResDtlBean[i].strRoomNo,resListResDtlBean[i].strRoomDesc
					,resListResDtlBean[i].strExtraBedCode,resListResDtlBean[i].strExtraBedDesc,resListResDtlBean[i].strPayee,resListResDtlBean[i].strRoomType);
			});
		}
		
		function funSetRoomType(code){
			var retVal="";
			$.ajax({
				type : "GET",
				url : getContextPath()+ "/loadRoomTypeMasterData.html?roomCode=" + code,
				dataType : "json",
			    async:false,
				success : function(response){ 
					if(response.strAgentCode=='Invalid Code')
		        	{
						retVal= "Invalid Room Type" ;
//	 	        		$("#lblRoomType").text('');
		        	}
		        	else
		        	{			
		        	 	/* document.getElementById("strRoomType."+gridHelpRow).value=strRoomTypeCode;						
		    			document.getElementById("strRoomTypeDesc."+gridHelpRow).value=response.strRoomTypeDesc;  */
				   
		        		retVal= response.strRoomTypeDesc;
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
			return retVal;
		}
		
		function funSetWalkinNo(code){

			$.ajax({
				type : "GET",
				url : getContextPath()+ "/loadWalkinData.html?docCode=" + code,
				dataType : "json",
				success : function(response){ 
					if(response.strWalkinNo!="Invalid")
			    	{
						funFillHdDataAgainstWalkIn(response);
						//funFillRoomRate();
			    	}
			    	else
				    {
				    	alert("Invalid Walk In No");
				    	$("#txtDocNo").val("");
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
		
		
		function funFillHdDataAgainstWalkIn(response)
		{
			$("#txtDocNo").val(response.strWalkinNo);		
			$("#txtArrivalDate").val(response.dteWalkinDate);
			$("#txtDepartureDate").val(response.dteCheckOutDate);
			$("#txtArrivalTime").val(response.tmeWalkinTime);
			$("#txtDepartureTime").val(response.tmeCheckOutTime);
			$("#txtRoomNo").val(response.strRoomNo);
			$("#lblRoomNo").text(response.strRoomDesc);
		    $("#txtExtraBed").val(response.strExtraBedCode);
		    $("#lblExtraBed").text(response.strExtraBedDesc);
		    $("#txtNoOfAdults").val(response.intNoOfAdults);
		    $("#txtNoOfChild").val(response.intNoOfChild);
		    $("#txtPackageCode").val(response.strPackageCode);
			$("#txtPackageName").val(response.strPackageName); 
			if(response.strPlanCode!='')
			{
				$("#txtPlanCode").val(response.strPlanCode);
				funSetPlanMasterData(response.strPlanCode);
			}

		    funRemoveProductRowsForIncomeHead();
			funRemoveTariffRows();
			funFillDtlGridAgainstWalkIn(response.listWalkinDetailsBean);
			funAddRommRateDtlOnWalkinSelect(response.listWalkinRoomRateDtl);
			funGetPreviouslyLoadedPkgList(response.listRoomPackageDtl);
		}
			
		
		function funFillDtlGridAgainstWalkIn(resListWalkInDtlBean)
		{
			funRemoveProductRows();
			$.each(resListWalkInDtlBean, function(i,item)
			{
				var geustName=resListWalkInDtlBean[i].strGuestFirstName+' '+resListWalkInDtlBean[i].strGuestMiddleName+' '+resListWalkInDtlBean[i].strGuestLastName
				funAddDetailsRow(geustName,resListWalkInDtlBean[i].strGuestCode,resListWalkInDtlBean[i].lngMobileNo
					,resListWalkInDtlBean[i].strRoomNo,resListWalkInDtlBean[i].strRoomDesc,resListWalkInDtlBean[i].strExtraBedCode
					,resListWalkInDtlBean[i].strExtraBedDesc,"N",resListWalkInDtlBean[i].strRoomType);
			});
		}
		
		

		// Get Detail Info From detail fields and pass them to function to add into detail grid
		function funGetDetailsRow() 
		{
			var guestCode=$("#txtGuestCode").val().trim();
			var mobileNo=$("#txtMobileNo").val().trim();
			var guestName=$("#txtGFirstName").val().trim()+" "+$("#txtGMiddleName").val().trim()+" "+$("#txtGLastName").val().trim();
			
			var roomNo =$("#txtRoomNo").val().trim();
			var roomDesc =$("#lblRoomNo").text().trim();
			var extraBedCode=$("#txtExtraBed").val();
			var extraBedDesc=$("#lblExtraBed").text();
			
		    funAddDetailsRow(guestName,guestCode,mobileNo,roomNo,roomDesc,extraBedCode,extraBedDesc,"Y");
		}
	
		
		//Function to add detail grid rows	
		function funAddDetailsRow(guestName,guestCode,mobileNo,roomNo,roomDesc,extraBedCode,extraBedDesc,payee,roomTypeCode) 
		{
			
			if(gTempAdultcount>$("#txtNoOfAdults").val()){
				
			//	alert("Room Booking Full");
			}
			/* else if(gAdult.hasObject(guestName)){
							
				alert("Guest already Added");
			} */
			else
			{
					gTempAdultcount++;
					gAdult.push(guestName);
				    var table = document.getElementById("tblCheckInDetails");
				    var rowCount = table.rows.length;
				    var row = table.insertRow(rowCount);
				    rowCount=listRow;
				    var roomtypeDesc=funSetRoomType(roomTypeCode);
				    rTypeCode=roomTypeCode
				    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" style=\"width:90%;\" name=\"listCheckInDetailsBean["+(rowCount)+"].strGuestName\" id=\"strGuestName."+(rowCount)+"\" value='"+guestName+"'/>";	    
				    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" style=\"width:70%;margin-left: -6%;\" name=\"listCheckInDetailsBean["+(rowCount)+"].lngMobileNo\" id=\"lngMobileNo."+(rowCount)+"\" value='"+mobileNo+"' />";	   
				    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" style=\"width:75%;margin-left: -22%;\" id=\"strRoomTypeDesc."+(rowCount)+"\" value='"+roomtypeDesc+"' class=\"searchTextBox\"   ondblclick=\"Javacsript:funHelp1('roomType',"+(rowCount)+",'"+roomTypeCode+"' )\"/>";
				 //   row.insertCell(3).innerHTML= "<input readonly=\"readonly\" style=\"width:90%;margin-left: -44%;background-color: #dcdada94;\" class=\"searchTextBox\"  name=\"listCheckInDetailsBean["+(rowCount)+"].strRoomNo\" id=\"strRoomNo."+(rowCount)+"\" value='"+roomNo+"'  ondblclick=\"Javacsript:funHelp1('roomByRoomType',"+(rowCount)+",'"+roomTypeCode+"' )\"/>";
				 		    row.insertCell(3).innerHTML= "<input readonly=\"readonly\" style=\"width:90%;margin-left: -44%;background-color: #dcdada94;\" class=\"searchTextBox\"  name=\"listCheckInDetailsBean["+(rowCount)+"].strRoomNo\" id=\"strRoomNo."+(rowCount)+"\" value='"+roomNo+"'  ondblclick=\"Javacsript:funHelp1('roomByRoomType',"+(rowCount)+",'"+roomTypeCode+"' )\"/>";  
				    row.insertCell(4).innerHTML= "<input readonly=\"readonly\" style=\"width:73%;margin-left: -44%\"  id=\"strRoomDesc."+(rowCount)+"\" value='"+roomDesc+"' />";
				    row.insertCell(5).innerHTML= "<input readonly=\"readonly\" style=\"width:90%;margin-left: -55%;background-color: #dcdada94;\" class=\"searchTextBox\"  name=\"listCheckInDetailsBean["+(rowCount)+"].strExtraBedCode\" id=\"strExtraBedCode."+(rowCount)+"\" value='"+extraBedCode+"' ondblclick=\"Javacsript:funHelp1('extraBed',"+(rowCount)+",'')\" />";
				    
				    if(guestCode==cheGuestCode)
				    {
				    	if(rowCount == 0)
				    		{
				    		row.insertCell(6).innerHTML= "<input id=\"cbItemCodeSel."+(rowCount)+"\" type=\"checkbox\" checked=\"checked\" style=\"margin-left: -605%;\" class=\"Box payeeSel\" name=\"listCheckInDetailsBean["+(rowCount)+"].strPayee\"  value=\"Y\" onClick=\"Javacsript:funCheckBoxRow(this)\"  />";
				    		}
				    	else
				    		{
				    		row.insertCell(6).innerHTML= "<input id=\"cbItemCodeSel."+(rowCount)+"\" type=\"checkbox\" style=\"margin-left: -605%;\" class=\"Box payeeSel\" name=\"listCheckInDetailsBean["+(rowCount)+"].strPayee\"  value=\"N\" onClick=\"Javacsript:funCheckBoxRow(this)\"  />";
				    		}
				    }
				    else
				    {
				    	if(payee=='Y'){
				    		row.insertCell(6).innerHTML= "<input id=\"cbItemCodeSel."+(rowCount)+"\" type=\"checkbox\" checked=\"checked\" style=\"margin-left: -605%;\" class=\"Box payeeSel\" name=\"listCheckInDetailsBean["+(rowCount)+"].strPayee\"  value=\"Y\" onClick=\"Javacsript:funCheckBoxRow(this)\"  />";
				    	}
				    	else{
				    		
				    		row.insertCell(6).innerHTML= "<input id=\"cbItemCodeSel."+(rowCount)+"\" type=\"checkbox\" class=\"Box payeeSel\" style=\"margin-left: -605%;\" name=\"listCheckInDetailsBean["+(rowCount)+"].strPayee\" value=\"N\" onClick=\"Javacsript:funCheckBoxRow(this)\" />";
				    	}
				    		
				    } 			    
			    row.insertCell(7).innerHTML= "<input class=\"Box\" size=\"2%\" style=\"margin-left: -150%;\" name=\"listCheckInDetailsBean["+(rowCount)+"].intNoOfFolios\" id=\"intNoOfFolios."+(rowCount)+"\" value='1' />";
			    row.insertCell(8).innerHTML= "<input type=\"button\" class=\"deletebutton\" size=\"6%\" value = \"\" onClick=\"Javacsript:funDeleteRow(this)\"/>";
			    row.insertCell(9).innerHTML= "<input size=\"1%\" name=\"listCheckInDetailsBean["+(rowCount)+"].strGuestCode\" id=\"strGuestCode."+(rowCount)+"\" value='"+guestCode+"' type='hidden' />";
			    row.insertCell(10).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"2%\" id=\"strExtraBedDesc."+(rowCount)+"\" value='"+extraBedDesc+"' />";
			    row.insertCell(11).innerHTML= "<input type=\"hidden\" class=\"Box \" name=\"listCheckInDetailsBean["+(rowCount)+"].strRoomType\" id=\"strRoomType."+(rowCount)+"\" value='"+roomTypeCode+"' >"; 
			    funResetDetailFields(); 
			    if(payee=='Y')
			    {
			    	$("#hidPayee").val(guestCode);
			    }
			   //gTotalNoRoom++;
			    gTotalNoGuest++;
			   // $("#txttotrooms").val(gSetTotalRoom.size);
			   // $("#txttotguest").val(gTotalNoGuest);
			    listRow++;
			    
			    globalRoomNo=new Map();
				globalNoOfGuest=new Map();
			    var table = document.getElementById("tblCheckInDetails");
				var rowCount = table.rows.length;									
					for(var i=0;i<rowCount;i++)
					{
						var name=table.rows[i].cells[0].children[0].defaultValue;	
						var roomno=table.rows[i].cells[3].children[0].value;
						

						if(roomno!='')
						{
							if(!globalRoomNo.has(roomno))
							{
								globalRoomNo.set(roomno,roomno);									
							}
						}
						

						if(!globalNoOfGuest.has(name))
							{
								globalNoOfGuest.set(name,name);
							}
					}
					 
				    $("#txttotrooms").val(globalRoomNo.size);
				  	$("#txttotguest").val(globalNoOfGuest.size);
			    
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
							
							
							var table = document.getElementById("tblCheckInDetails");
							var rowCount = table.rows.length;
							var roomFound='N';
							if(rowCount>0)
							{
								for(var i=0;i<rowCount;i++)
								{
									 if(document.getElementById("strRoomNo."+i).value=='')
									 {
										roomFound='N';
									 }
									 else
									 {
										 roomFound='Y'; 
									 }	 
								}
								
							if(roomFound=='N')
							{
								alert('Select Room!!');
							}
							else
							{
								$("#txtPackageName").val(response.strPackageName);
								$.each(response.listPackageDtl, function(i,item)
								{
									funAddIncomeHeadRow(item.strIncomeHeadCode.split('#')[0],item.strIncomeHeadCode.split('#')[1],item.dblAmt,'');		
								});
							}
						}
						else
						{
							alert('Guest List Not Found!!');
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
				        		$("#txtReason").val(response.strReasonCode);
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
		
		
		function funfillIncomHeadGrid(data)
		{
			
			$("#txtIncomeHead").val(data.strIncomeHeadCode);
			$("#txtIncomeHeadName").val(data.strIncomeHeadDesc);
		}
		
		
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
					var table = document.getElementById("tblCheckInDetails");
					var rowCount = table.rows.length;
					var roomFound='N';
					if(rowCount>0)
					{
						for(var i=0;i<rowCount;i++)
						{
							 if(document.getElementById("strRoomNo."+i).value=='')
							 {
								roomFound='N';
							 }
							 else
							 {
								 roomFound='Y'; 
							 }	 
						}
						
						if(roomFound=='N')
						{
							alert('Select Room!!');
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
					else
					{
						flag=false;
						alert('Guest List Not Found!!');
					}
				}
			}		
			return flag;
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
			var totalTarriff=0;
			if(document.getElementById("tblRommRate").rows.length>0)
			{
				for(var i=0;i<document.getElementById("tblRommRate").rows.length;i++)
			    {
					var objName =document.getElementById("dblRoomRate."+i);
			        totalTarriff=totalTarriff+parseFloat(objName.value);
			    }
				totalTarriff=parseFloat(totalTarriff).toFixed(maxAmountDecimalPlaceLimit);
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
		
		
		function funFillRoomRate()
		{
			
			 var arrivalDate= $("#txtArrivalDate").val();
			 var departureDate=$("#txtDepartureDate").val();
			 var roomDescList = new Array();
			 var table = document.getElementById("tblCheckInDetails");
			 var rowCount = table.rows.length;
			 for (i = 0; i < rowCount; i++){
				 
				 var oCells = table.rows.item(i).cells;
				 
				 if(roomDescList!='')
				 {
						 roomDescList = roomDescList + ","+table.rows[i].cells[11].children[0].value;
					
				 }
				
				 else
				 {
					 roomDescList = table.rows[i].cells[11].children[0].value;	 
				 }	 

			}
			 $.ajax({  
					type : "GET",
					url : getContextPath()+ "/loadRoomRate.html?arrivalDate="+arrivalDate+"&departureDate="+departureDate+"&roomDescList="+roomDescList+"&noOfNights=0",
					dataType : "json",
					success : function(response){ 
					funAddRommRateDtl(response);
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
		
		
		/* function funAddRommRateDtl(dataList)
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
				 date=day+"-"+month+"-"+dateSplit[0];
				 row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-center: 5px;width:50%;\" name=\"listReservationRoomRateDtl["+(rowCount)+"].dtDate\"  id=\"dtDate."+(rowCount)+"\" value='"+date+"' >";
		 	     row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" id=\"strTypeRoomDesc."+(rowCount)+"\" value='"+list[2]+"' />";
		 	     row.insertCell(2).innerHTML= "<input type=\"text\"    style=\"text-align:right;\"  name=\"listReservationRoomRateDtl["+(rowCount)+"].dblRoomRate\" id=\"dblRoomRate."+(rowCount)+"\" onchange =\"Javacsript:funCalculateTotals()\" value='"+list[1]+"' >";
		 	     row.insertCell(3).innerHTML= "<input type=\"hidden\" class=\"Box \"  name=\"listReservationRoomRateDtl["+(rowCount)+"].strRoomType\" id=\"strRoomType."+(rowCount)+"\" value='"+list[3]+"' >";
			}
		} */
		
		var alreadyCheckInRow=0;
		function funAddRommRateDtlOnReservationSelect(dataList)
		{
			
			alreadyCheckInRow=dataList.length;
			 var table=document.getElementById("tblRommRate");
			 
			 for(var i=0;i<dataList.length;i++ )
		     {
				 var rowCount=table.rows.length;
				 var row=table.insertRow();
				 var list=dataList[i];
				 var date,roomtypeDesc,roomRate,roomType;
				 date=list.dtDate;
				 roomtypeDesc=funSetRoomType(list.strRoomType);
				 //roomtypeDesc=$("#lblRoomType").text();
				 roomRate=list.dblRoomRate;
				 roomType=list.strRoomType;
				 $("#lblRoomType").text("");
				 var dateSplit = date.split("-");
				 date=dateSplit[2]+"-"+dateSplit[1]+"-"+dateSplit[0];
				 row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-center: 5px;width:50%;\" name=\"listReservationRoomRateDtl["+(rowCount)+"].dtDate\"  id=\"dtDate."+(rowCount)+"\" value='"+date+"' >";
		 	     row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"15%\" id=\"strRoomTypeDesc."+(rowCount)+"\" value='"+roomtypeDesc+"' />";
		 	     row.insertCell(2).innerHTML= "<input  type=\"text\" style=\"text-align:right;\"  name=\"listReservationRoomRateDtl["+(rowCount)+"].dblRoomRate\" id=\"dblRoomRate."+(rowCount)+"\" onchange =\"Javacsript:funGetSelectedRow(this)\" value='"+roomRate+"' >";
		 	     row.insertCell(3).innerHTML= "<input type=\"hidden\" class=\"Box \" name=\"listReservationRoomRateDtl["+(rowCount)+"].strRoomType\" id=\"strRoomType."+(rowCount)+"\" value='"+roomType+"' >";
				 
		     }
		}
		
		function funGetPreviouslyLoadedPkgList(resPackageIncomeHeadList)
		{
			$.each(resPackageIncomeHeadList, function(i,item)
			 {
		 		funAddIncomeHeadRow(item.strIncomeHeadCode,item.strIncomeHeadName,item.dblIncomeHeadAmt);
		 	 });
			
		}
		
		function funAddRommRateDtlOnWalkinSelect(dataList)
		{
			alreadyCheckInRow=dataList.length;
			
			 var table=document.getElementById("tblRommRate");
			 
			 for(var i=0;i<dataList.length;i++ )
		     {
				 var rowCount=table.rows.length;
				 var row=table.insertRow();
				 var list=dataList[i];
				 var date,roomtypeDesc,roomRate,roomType;
				 date=list.dtDate;
				 roomtypeDesc=funSetRoomType(list.strRoomType);
				// roomtypeDesc=$("#lblRoomType").text();
				 roomRate=list.dblRoomRate;
				 roomType=list.strRoomType;
			 	$("#lblRoomType").text("");
				 var dateSplit = date.split("-");
				 date=dateSplit[2]+"-"+dateSplit[1]+"-"+dateSplit[0];
				 var dateSplit = date.split("-");
				 date=dateSplit[0]+"-"+dateSplit[1]+"-"+dateSplit[2];
				 row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-center: 5px;width:34%;\" name=\"listWalkinRoomRateDtl["+(rowCount)+"].dtDate\"  id=\"dtDate."+(rowCount)+"\" value='"+date+"' >";
		 	     row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"34%\" id=\"strRoomTypeDesc."+(rowCount)+"\" value='"+roomtypeDesc+"' />";
		 	     row.insertCell(2).innerHTML= "<input type=\"text\" style=\"text-align:right;width:34%;\"  name=\"listWalkinRoomRateDtl["+(rowCount)+"].dblRoomRate\" id=\"dblRoomRate."+(rowCount)+"\" onchange =\"Javacsript:funCalculateTotals()\" value='"+roomRate+"' >";
		 	     row.insertCell(3).innerHTML= "<input type=\"hidden\" class=\"Box \" name=\"listWalkinRoomRateDtl["+(rowCount)+"].strRoomType\" id=\"strRoomType."+(rowCount)+"\" value='"+roomType+"' >";
			 }
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
		    table.deleteRow(index);
		    funCalculateTotals();
		}


		// Reset Detail Fields
			function funResetDetailFields()
			{
				$("#txtGuestCode").val('');
				$("#txtMobileNo").val('');
				$("#txtGFirstName").val('');
				$("#txtGMiddleName").val('');
				$("#txtGLastName").val('');
			}
			
			function funCheckBoxRow(rowObj)
			{
				/* $( "input[type='radio']" ).prop({
					checked: false
					}); */
					var no=0;
					$('#tblCheckInDetails tr').each(function() {
						
						if(document.getElementById("cbItemCodeSel."+no).checked == true)
							{
							  document.getElementById("cbItemCodeSel."+no).value='Y';
							  $("#hidPayee").val('Y');
							  
							}else
								{
									document.getElementById("cbItemCodeSel."+no).value='N';
									$("#hidPayee").val('N');
								}
						no++;
					});
			}


			//Delete a All record from a grid
				function funRemoveProductRows()
				{
					var table = document.getElementById("tblCheckInDetails");
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
				    var table = document.getElementById("tblCheckInDetails");
				    table.deleteRow(index);
				    index=listRow;
				    var roomNo=obj.parentNode.parentNode.cells[3].firstElementChild.value;
				    var Name=obj.parentNode.parentNode.cells[0].firstElementChild.value;
				    var id="strRoomNo."+index;
				    var roomNo1=document.getElementById(id);
				    gTempAdultcount--;
				    if(gset1.hasObject(roomNo)){
				    	for( var i = gset1.length; i--;){
				    		if ( gset1[i] === roomNo){
				    			gset1.splice(i, 1);
				    			break;
				    		}
				    		}
				    	 
				    }
				    if(gAdult.hasObject(Name)){
				    	//gAdult.pop(Name);
				    	//gAdult.splice( gAdult.indexOf(Name), 1);
				    	for( var i = gAdult.length; i--;){
				    		if ( gAdult[i] === Name) gAdult.splice(i, 1);
				    		}
				    }
				    
				    if(gRoomMap.has(roomNo)){
				    	gRoomMap.delete(roomNo);
				    	/* for( var i = gRoomMap.size; i--;){
				    		if ( gRoomMap.has(roomNo)){
				    			gRoomMap.delete(roomNO);
				    			
				    		}
				    		break;
				    		}  */
				    	 
				    	  
				    }
				    if(gSetTotalRoom.has(roomNo)){
				    	gSetTotalRoom.delete(roomNo);
				    }
				    
				   
				    gTotalNoGuest--;
				  
				    //logic
				    globalRoomNo=new Map();
					globalNoOfGuest=new Map();
				    var table = document.getElementById("tblCheckInDetails");
					var rowCount = table.rows.length;									
						for(var i=0;i<rowCount;i++)
						{
							var name=table.rows[i].cells[0].children[0].defaultValue;	
							var roomno=table.rows[i].cells[3].children[0].value;
							if(roomno!='')
							{
								if(!globalRoomNo.has(roomno))
								{
									globalRoomNo.set(roomno,roomno);									
								}
							}					

							if(!globalNoOfGuest.has(name))
								{
									globalNoOfGuest.set(name,name);
								}
						}
						 
					    $("#txttotrooms").val(globalRoomNo.size);
					  	$("#txttotguest").val(globalNoOfGuest.size);				    	
				}
			


				function funHelp(transactionName)
				{
					fieldName=transactionName;
					window.open("searchform.html?formname="+transactionName+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
					//window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
				}
				
				function funHelp1(transactionName,row,condition)
				{
					gAdultCount=0;
					gridHelpRow=row;
					fieldName=transactionName;	
					if(transactionName=="roomByRoomType")
					{
						
						
							condition= document.getElementById("strRoomType."+row).value;
							window.open("searchform.html?formname="+fieldName+"&strRoomTypeCode="+condition+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
							
						
					}
					else if(transactionName=="roomType")
					{
						window.open("searchform.html?formname="+fieldName+"&strRoomTypeCode="+condition+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
					
					}
					else
					{
						window.open("searchform.html?formname="+transactionName+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
					}
					
				}
				
				
				function funHelpAgainst()
				{
					globalRoomNo=new Map();
					globalNoOfGuest=new Map();
					if ($("#cmbAgainst").val() == "Reservation")
					{
						fieldName="ReservationNo";
					}
					else if ($("#cmbAgainst").val() == "Walk In")
					{
						fieldName="WalkinNo";
					}
					
					window.open("searchform.html?formname="+fieldName+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
					//window.showModalDialog("searchform.html?formname="+fieldName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
				}
				
				function funOnChange() {
					if ($("#cmbAgainst").val() == "Reservation")
					{
						$("#lblAgainst").text("Reservation");
					}
					else if ($("#cmbAgainst").val() == "Walk In")
					{
						$("#lblAgainst").text("Walk In No");
					}
				}
				

				 /**
					*   Attached document Link
					**/
					$(function()
					{
					
						$('a#baseUrl').click(function() 
						{
							if($("#txtCheckInNo").val().trim()=="")
							{
								alert("Please Select CheckIN No ");
								return false;
							}
						   window.open('attachDoc.html?transName=frmCheckIN.jsp&formName=CheckIn &code='+$('#txtCheckInNo').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
						});
						
						
						var walkinNo='${walkinNo}';
						  
						  if(walkinNo!=''||walkinNo!="")
						  {
							  alert("Walkin No Is"+walkinNo);
							  $("#lblAgainst").text("Walk In No");
							  fieldName="WalkinNo";
							   $("#cmbAgainst").val("Walk In");
							   funSetWalkinNo(walkinNo);
						  }
					});
				 
					 
					 function funValidateForm()
					 {
						 var table = document.getElementById("tblCheckInDetails");
							var rowCount = table.rows.length;	
							var TotalPaxNo=0;
							for(var i=0;i<rowCount;i++)
							{
									
								TotalPaxNo=TotalPaxNo + parseInt(table.rows[i].cells[7].children[0].value);
																
							}
							if(TotalPaxNo > parseInt($("#txtNoOfAdults").val()))
							{
							  alert("Number of Pax is not matched");
							  return false;
							}
						 	var ArrivalDate1 = $("#txtArrivalDate").val();
							var DepartureDate1 = $("#txtDepartureDate").val();
							 var g2 = new Date(ArrivalDate1); 
							 
							 var g1 = new Date(DepartureDate1); 
							 /* if( g2.getTime() > g1.getTime() )
							 {
								 alert("Arrival Date must be Greater than DepartureDate")
								 return false;
							 } 
							  */
							/* if(ArrivalDate1 > DepartureDate1){
								alert("Arrival Date must be Greater than DepartureDate")
								return false;
							}
							 */
						//else{
								
							var table = document.getElementById("tblCheckInDetails");
						    var rowCount = table.rows.length;
							if(rowCount==0)
							{
								alert("Please Select Guest.");
								return false;
							}
							
							
							var table = document.getElementById("tblCheckInDetails");
							var rowCount = table.rows.length;
							var payee='N',roomFound='Y';
							for(var i=0;i<rowCount;i++)
							{
					    		if(rowCount==1)
					    		{
					    			
					    			 document.getElementById("cbItemCodeSel."+i).checked = true;
							    	 document.getElementById("cbItemCodeSel."+i).value='Y';
									 $("#hidPayee").val('Y');
									 payee='Y';
									 
									 if(document.getElementById("strRoomNo."+i).value=='')
									 {
										roomFound='N';
									 }
					    		}
					    		else
					    		{
					    			if(document.getElementById("cbItemCodeSel."+i).value=='Y')
									{
										payee='Y';
									}
					    			if(document.getElementById("strRoomNo."+i).value=='')
									{
							roomFound='N';
									}
					    		}	
							}	
							
							if(payee=='N')
							{
								alert("Please Select One Payee");
								return false;
							}
							/*rowCount = table.rows.length;
							for(var i=0;i<rowCount;i++)
							{
								if(document.getElementById("txtRoomNo."+i).value=='')
								{
									roomFound='N';
								}
							}
							*/
							
							if(roomFound=='N')
							{
								alert("Please Select Room No!!");
								return false;
							}
							
							if($("#txtComplimentry").val()=='Y')
							{
							
								if($("#txtReason").val()=='')
								{
									alert("Please Enter Reason and Remarks");							
								}
								else
								{
								   return true;
								
								}
								
								return false;
							}
							
							
							
							return true;	 
					// }
				}
					 
					 function funSetRoomNo(code,gridHelpRow){						 
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
						        		if(response.strStatus=='Blocked')
					        			{
					        				alert("This room is blocked Please select Different Room");
					        			}
						        		else
					        			{
											if(document.getElementById("strRoomNo."+gridHelpRow).value!="")
						    				{
								    			 if(gRoomMap.has(document.getElementById("strRoomNo."+gridHelpRow).value)){
												    	gRoomMap.delete(document.getElementById("strRoomNo."+gridHelpRow).value);
												    }
								    			 if(gSetTotalRoom.has(document.getElementById("strRoomNo."+gridHelpRow).value)){
												    	gSetTotalRoom.delete(document.getElementById("strRoomNo."+gridHelpRow).value);
												    }
						    					
						    				}
											
											if(gset1.length>=$("#txtNoOfAdults").val()){
												
												if(gset1.hasObject(response.strRoomCode)){
												    		gset1.push(response.strRoomCode);												    														    		
												    		if(!gRoomMap.has(response.strRoomCode))
															{
																gRoomMap.set(response.strRoomCode,response.strRoomCode);
															}	
												    		gSetTotalRoom.add(response.strRoomCode);
															//  $("#txttotrooms").val(gSetTotalRoom.size);
															document.getElementById("strRoomNo."+gridHelpRow).value=response.strRoomCode;						
											    			document.getElementById("strRoomDesc."+gridHelpRow).value=response.strRoomDesc;
											    			document.getElementById("strRoomTypeDesc."+gridHelpRow).value=response.strRoomTypeDesc;						
											    			document.getElementById("strRoomType."+gridHelpRow).value=response.strRoomTypeCode;
											    			 $( "#tblCheckInDetails" ).load( "your-current-page.html #tblCheckInDetails" );
												}
											    	else{
											    		alert("Room Not available");
											    	}
											    } 
											else{
												if(!gRoomMap.has(response.strRoomCode))
												{
													gRoomMap.set(response.strRoomCode,response.strRoomCode);
												}	
												gSetTotalRoom.add(response.strRoomCode);
												document.getElementById("strRoomNo."+gridHelpRow).value=response.strRoomCode;						
								    			document.getElementById("strRoomDesc."+gridHelpRow).value=response.strRoomDesc;
								    			document.getElementById("strRoomTypeDesc."+gridHelpRow).value=response.strRoomTypeDesc;						
								    			document.getElementById("strRoomType."+gridHelpRow).value=response.strRoomTypeCode;
								    			 $( "#tblCheckInDetails" ).load( "your-current-page.html #tblCheckInDetails" );
											}
							        	}
						        		globalRoomNo=new Map();
										globalNoOfGuest=new Map();
						        		var RoomNoType="";
						        		
						        		
						        		var table = document.getElementById("tblCheckInDetails");
					 				    var rowCount = table.rows.length;									
					 					for(var i=0;i<rowCount;i++)
					 					{
					 						var name=table.rows[i].cells[0].children[0].defaultValue;	
					 						var roomno=table.rows[i].cells[3].children[0].value;
					 						var roomTypeCode=table.rows[i].cells[11].children[0].value;
					 						if(roomno !="")
				 							{
						 						RoomNoType +=","+roomTypeCode +" "+roomno;

				 							}
					 						

					 						if(roomno!='')
					 						{
					 							if(!globalRoomNo.has(roomno))
					 							{
					 								globalRoomNo.set(roomno,roomno);									
					 							}
					 						}
					 						

					 						if(!globalNoOfGuest.has(name))
				 							{
				 								globalNoOfGuest.set(name,name);
				 							}
					 					}
						 					 
						 				    $("#txttotrooms").val(globalRoomNo.size);
						 				  	$("#txttotguest").val(globalNoOfGuest.size);
						 				  //	alert(RoomNoType);
						 				  if(roomno='')
					 						{
							 				  funFillTarrifData(RoomNoType);						 					  
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
						
					 function funSetExtraBed(code,gridHelpRow)
						{
						//	$("#txtExtraBed").val(code);
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
								        	document.getElementById("strExtraBedCode."+gridHelpRow).value=code;						
							    			document.getElementById("strExtraBedDesc."+gridHelpRow).value=response.strExtraBedTypeDesc; 
									       
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
					 
					 
					 function funSetRoomType2(code,indiex){
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
						        		document.getElementById("strRoomType."+gridHelpRow).value=code;						
						    			document.getElementById("strRoomTypeDesc."+gridHelpRow).value=response.strRoomTypeDesc; 
								     
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
					 
					 function funComplimentryChange(select)
					 {
						 
						 if(select.value=='Y')
							 {
								 $("#txtComplimentry").val('N');
							 }
						 else
							 {
							 $("#txtComplimentry").val('Y');
							 }
						 if(select.value == 'Y')
							 {
							 	document.getElementById('txtReason').style.display = 'block';
								document.getElementById('txtRemarks').style.display = 'block';
								document.getElementById('lblReasonDesc').style.display = 'block';
							 }
						 else
							 {
							 document.getElementById('txtReason').style.display = 'none';
							 document.getElementById('txtRemarks').style.display = 'none';
							 document.getElementById('lblReasonDesc').style.display = 'none';
							 
							 $("#txtReason").val('');
							 $("#txtRemarks").val('');
							 $("#lblReasonDesc").val('');
							 }
						 
						 
					 }
					 
					 function funSetGuestCode(code){
							
						
							$.ajax({
								type : "GET",
								url : getContextPath()+ "/loadGuestCode.html?guestCode=" + code,
								dataType : "json",
								success : function(response){ 
									 $("#txtGuestCode").val(response.strGuestCode);
									 var guestName = response.strFirstName+" "+response.strMiddleName+" "+response.strLastName;
									 var guestCode = response.strGuestCode;
									 var mobileNo = response.lngMobileNo;
									 var roomNo = "";
									 var roomDesc = "";
									 var extraBedCode = "";
									 var extraBedDesc = "";
									 var strPayee = "N";
									funAddDetailsRow(guestName,guestCode,mobileNo,roomNo,roomDesc,extraBedCode,extraBedDesc,strPayee,rTypeCode);
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
					 
					 function funChangeArrivalDate()
						{
							var arrivalDate=$("#txtArrivalDate").val();
						    var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
						    var fromDate=$("#txtArrivalDate").val();
							var toDate=$("#txtDepartureDate").val()
							if(fromDate>toDate){
								 alert("Please Check Arrival Date");
								 $("#txtDepartureDate").datepicker({ dateFormat: 'dd-mm-yy' });
								 $("#txtDepartureDate").datepicker('setDate', pmsDate);
								 return false
							}
							
					    	/* if (arrivalDate < pmsDate) 
					  		 {
							    	alert("Arrival Date Should not be come before PMS Date");
							    	$("#txtArrivalDate").datepicker({ dateFormat: 'dd-mm-yy' });
									$("#txtArrivalDate").datepicker('setDate', pmsDate);
									return false
					         } */
					    	
					    	
						}
					 
					 function CalculateDateDiff() 
						{

							var fromDate=$("#txtArrivalDate").val();
							var toDate=$("#txtDepartureDate").val()
							var frmDate= fromDate.split('-');
						    var fDate = new Date(frmDate[2],frmDate[1],frmDate[0]);
						    
						    var tDate= toDate.split('-');
						    var t1Date = new Date(tDate[2],tDate[1],tDate[0]);

					    	var dateDiff=t1Date-fDate;
					  		 if (dateDiff >= 0 ) 
					  		 {
					  			var total_days = (dateDiff) / (1000 * 60 * 60 * 24);
					  			$("#txtNoOfNights").val(total_days);
					  			funFillRoomRate(total_days);
					         	
					         }else{
					        	 alert("Please Check Departure Date");
					        	 $("#txtDepartureDate").datepicker({ dateFormat: 'dd-mm-yy' });
								 $("#txtDepartureDate").datepicker('setDate', pmsDate);
					        	 return false
					         }
					 	
						}
					 
					 
					 function funOpenExportImport()			
						{
							var transactionformName="frmCheckIn";
							//var guestCode=$('#txtGuestCode').val();
							
							
						//	response=window.showModalDialog("frmExcelExportImport.html?formname="+transactionformName+"&strLocCode="+locCode,"","dialogHeight:500px;dialogWidth:500px;dialogLeft:550px;");
							response=window.open("frmExcelExportImport.html?formname="+transactionformName,"dialogHeight:500px;dialogWidth:500px;dialogLeft:550px;");
						
							var timer = setInterval(function ()
								    {
									if(response.closed)
										{
											if (response.returnValue != null)
											{
                                                var roomNo=" ",roomDesc=" ",extraBedCode=" ",extraBedDesc=" ",payee=" ",roomTypeCode=" ";
												if(null!=response)
										        {
													response=response.returnValue;
													$.each(response, function(i,item)
													{
														var GuestName=item.strFirstName +" "+item.strMiddleName +" "+item.strLastName;
														 funAddDetailsRow(GuestName,item.strGuestCode,item.lngMobileNo,roomNo,roomDesc,extraBedCode,extraBedDesc,payee,rTypeCode);							
													});											    	 
										        }
							
											}
											clearInterval(timer);
										}
								    }, 500);
							
							
							
						}
					 function funFillTarrifData(RoomNoType)
					 {
						 var arrivalDate= $("#txtArrivalDate").val();
						 var departureDate=$("#txtDepartureDate").val();
						 $.ajax({
								type : "POST",
								url : getContextPath()+ "/loadRoomRateCheckIn.html?arrivalDate="+arrivalDate+"&departureDate="+departureDate+"&roomDescList="+RoomNoType,
							    dataType: "json",
						        async:false,
						        success: function(response)
						        {
						        	funAddRommRateDtl(response);
								},
								error: function(jqXHR, exception){
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
					 
					 function funFillRoomRate(total_days)
						{
								
								 var arrivalDate= $("#txtArrivalDate").val();
								 var departureDate=$("#txtDepartureDate").val();
								 var roomDescList = new Array();
								 var table = document.getElementById("tblCheckInDetails");
								 var rowCount = table.rows.length;
								 for (i = 0; i < rowCount; i++){
									 
									 var oCells = table.rows.item(i).cells;
									 
									 if(roomDescList!='')
									 {
											 roomDescList = roomDescList + ","+table.rows[i].cells[11].children[0].value;
										
									 }
									
									 else
									 {
										 roomDescList = table.rows[i].cells[11].children[0].value;	 
									 }	 

								}
								 $.ajax({  
										type : "GET",
										url : getContextPath()+ "/loadRoomRate.html?arrivalDate="+arrivalDate+"&departureDate="+departureDate+"&roomDescList="+roomDescList+"&noOfNights="+total_days,
										dataType : "json",
										 async:false,
										success : function(response){ 
										funAddRommRateDtl(response);
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
						 
						function funAddRommRateDtl(dataList)
						{
							//$('#tblRommRate tbody').empty()
							if ($("#cmbAgainst").val() == "Reservation")
							{
								funRemAlreadyCheckINRows();
								 var table=document.getElementById("tblRommRate");
								 
								 for(var i=alreadyCheckInRow;i<dataList.length;i++ )
							     {
									 var rowCount=table.rows.length;
									 var row=table.insertRow();
									 var list=dataList[i];
									 var date=list[0];
									 var dateSplit= date.split("-");
									 var month=dateSplit[1];
									 var day = dateSplit[2];
//						 		 if(day<10) 
//						 		 {
//						 			 day='0'+day;
//						 		 } 

//						 		 if(month<10) 	
//						 		 {
//						 			 month='0'+month;
//						 		 } 
								var dblRate = list[1];
								
								 date=day+"-"+month+"-"+dateSplit[0];
								 row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-center: 5px;width:50%;\" name=\"listReservationRoomRateDtl["+(rowCount)+"].dtDate\"  id=\"dtDate."+(rowCount)+"\" value='"+date+"' >";
						 	     row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" id=\"strTypeRoomDesc."+(rowCount)+"\" value='"+list[2]+"' />";
						 	     row.insertCell(2).innerHTML= "<input type=\"text\"    style=\"text-align:right;\"  name=\"listReservationRoomRateDtl["+(rowCount)+"].dblRoomRate\" id=\"dblRoomRate."+(rowCount)+"\" onchange =\"Javacsript:funGetSelectedRow(this)\" value='"+dblRate+"' >";
						 	     row.insertCell(3).innerHTML= "<input type=\"hidden\" class=\"Box \"  name=\"listReservationRoomRateDtl["+(rowCount)+"].strRoomType\" id=\"strRoomType."+(rowCount)+"\" value='"+list[3]+"' >";
						 	  
						 	    
						 	   
						 	  	
								}
							}
							else if ($("#cmbAgainst").val() == "Walk In")
							{
								
								funRemAlreadyCheckINRows();
								 var table=document.getElementById("tblRommRate");
								 
								 for(var i=alreadyCheckInRow;i<dataList.length;i++ )
							     {

									 var rowCount=table.rows.length;
									 var row=table.insertRow();
									 var list=dataList[i];
									 var date=list[0];
									 var dateSplit= date.split("-");
									 var month=dateSplit[1];
									 var day = dateSplit[2];
//						 		 if(day<10) 
//						 		 {
//						 			 day='0'+day;
//						 		 } 

//						 		 if(month<10) 	
//						 		 {
//						 			 month='0'+month;
//						 		 } 
								var dblRate = list[1];
								
								 date=day+"-"+month+"-"+dateSplit[0];
								 
									 row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-center: 5px;width:34%;\" name=\"listWalkinRoomRateDtl["+(rowCount)+"].dtDate\"  id=\"dtDate."+(rowCount)+"\" value='"+date+"' >";
							 	     row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"34%\" id=\"strRoomTypeDesc."+(rowCount)+"\" value='"+list[2]+"' />";
							 	     row.insertCell(2).innerHTML= "<input type=\"text\" style=\"text-align:right;width:34%;\"  name=\"listWalkinRoomRateDtl["+(rowCount)+"].dblRoomRate\" id=\"dblRoomRate."+(rowCount)+"\" onchange =\"Javacsript:funCalculateTotals()\" value='"+dblRate+"' >";
							 	     row.insertCell(3).innerHTML= "<input type=\"hidden\" class=\"Box \" name=\"listWalkinRoomRateDtl["+(rowCount)+"].strRoomType\" id=\"strRoomType."+(rowCount)+"\" value='"+list[3]+"' >";
								 }
								
							}
								
								
								 
						}
						function funRemAlreadyCheckINRows()
					    {
							var table = document.getElementById("tblRommRate");
							var rowCount = table.rows.length;
							for(var i=rowCount-1;i>alreadyCheckInRow;i--)
							{
								table.deleteRow(i);
							}
					    }
			</script>
			</head>
<body>
	<label id="formHeading">Check In</label>
	  <s:form name="frmCheckIn" method="POST" action="saveCheckIn.html">
	  <br>
	  <div id="multiAccordion">	
		  
     <h3><a href="#">Check In</a></h3>
			<div>
		<div class="container transTable"  style="background-color:#f2f2f2; margin:auto;">
			<!-- <a id="baseUrl" href="#"> Attach Documents</a> -->
			<div class="row">   
			<div class="col-md-2"><label>Check In No</label>
				  <s:input  type="text" id="txtCheckInNo" path="strCheckInNo" cssClass="searchTextBox" ondblclick="funHelp('checkIn');"/>
			</div>
							
			<div class="col-md-2"><label>Registration No</label>
				<s:input type="text" id="txtRegistrationNo" path="strRegistrationNo" cssClass="searchTextBox" ondblclick="funHelp('RegistrationNo');"/>
			</div>
			
		 	<div class="col-md-2"><label>Type</label>
				 <s:select id="cmbAgainst" path="strType" onchange="funOnChange();" style="width:60%;">
					    <option selected="selected" value="Reservation">Reservation</option>
				        <option value="Walk In">Walk In</option>
			     </s:select>
			</div>
							
		    <div class="col-md-2"><label id="lblAgainst">Reservation No</label>
				<s:input  type="text" id="txtDocNo" path="strAgainstDocNo" cssClass="searchTextBox" ondblclick="funHelpAgainst();"/>
			</div>
			
			<div class="col-md-2"><label>Arrival Date</label>
				<s:input  type="text" id="txtArrivalDate" path="dteArrivalDate" cssClass="calenderTextBox" style="width: 75%;" onchange="funChangeArrivalDate();" />
			</div>
			
			<div class="col-md-2"><label>Departure Date</label>
				 <s:input  type="text" id="txtDepartureDate" path="dteDepartureDate" cssClass="calenderTextBox" style="width: 75%;" onchange="CalculateDateDiff();"/>
			</div>
		
			<div class="col-md-2"><label>Arrival Time</label>
				<s:input  type="text" id="txtArrivalTime" path="tmeArrivalTime" cssClass="calenderTextBox" style="width: 75%;" />
			</div>
			
			<div class="col-md-2"><label>Departure Time</label>
				<s:input  type="text" id="txtDepartureTime" path="tmeDepartureTime" cssClass="calenderTextBox" style="width: 75%;"/>
			</div>
			
			<div class="col-md-2"><label>#Adult</label><br>
				 <s:input id="txtNoOfAdults" value = '1' name="txtNoOfAdults" path="intNoOfAdults" type="number" min="0" step="1" style="width: 38%;text-align: right;"/>
		    </div>
		    
			<div class="col-md-2"><label>#Child</label><br>
				<s:input id="txtNoOfChild" path="intNoOfChild" type="number" min="0" step="1" name="txtNoOfChild" style="width: 38%;text-align: right;"/>				
			</div> 
			
			<div class="col-md-2"><label>No Post Folio</label>
			     <s:checkbox id="txtNoPostFolio" path="strNoPostFolio" value="Y" />
			</div>
			
			<div class="col-md-2"><label>Complimentary</label>
			    <s:checkbox id="txtComplimentry" path="strComplimentry" value="N" onclick="funComplimentryChange(this);"/>
			</div>
			
			<div class="col-md-2"><label>Reason Code</label>
				<s:input  type="text" id="txtReason" path="strReasonCode" cssClass="searchTextBox" ondblclick="funHelp('reasonPMS');"/>
			</div>
			
			<div class="col-md-2"><label>Remarks</label>
				<s:input id="txtRemarks" path="strRemarks" style="width: 160px;height:35%"/>
			</div>
						
			<div class="col-md-2"><label id="lblReasonDesc" style="background-color:#dcdada94; width: 100%; height: 42%; margin: 27px 0px;"></label>
			</div>
			
			<!-- <div class="col-md-2"><input type="button" value="Proceed to Payment" class="btn btn-primary center-block" class="smallButton" onclick='return funAddRow()' style="margin-top:16%"/>
	        </div> -->
	        
	        <div class="col-md-2"><label>Guest Code</label>
						<input id="txtGuestCode" ondblclick="funHelp('guestCode');" class="searchTextBox" />
			</div>
	        
	        <div class="col-md-2"><label>Dont apply tax</label>
			     <s:checkbox id="txtDontApplyTax" path="strDontApplyTax" value="Y" />
			</div>
			
			<div class="col-md-3"><label>Plan </label>
	        <s:input id="txtPlanCode" path="strPlanCode" cssClass="searchTextBox" ondblclick="funHelp('plan')" style="height: 50%;width: 72%;"/>
	         </div>				
			<div class="col-md-2" style="margin-left:-5%"><label>Plan Desc</label>
			<s:input id="txtPlanDesc" path="strPlanDesc"/>
			</div>	
	        
<!-- 	        <div class="col-md-2"><input type="button" value="Add" class="btn btn-primary center-block" class="smallButton" onclick='return funAddRow()' style="margin-top:16%"/>
 -->	        <div class="col-md-12" align="center"><a onclick="funOpenExportImport()" style="margin-right: -75%;"
					     href="javascript:void(0);"><u>Export/Import</u></a>
					<!-- <a id="baseUrl" href="#"> Attach Documents</a> -->
					</div>
	        </div>
		
			<div class="dynamicTableContainer" style="height: 300px; width:100%;">
			<table style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
				<tr bgcolor="#c0c0c0">
				
					<td style="width:14.5%;">Name</td>
					<td style="width:11.5%;">Mb No</td>
					<td style="width:11%;">Room Type</td>
					<td style="width:14%;">Room Code</td>
					<td style="width:14%;">Room No</td>
					<td style="width:13%;">Extra Bed</td>					
					<td style="width:0.5%">Payee</td>
					<td style="width:3px;">Pax No</td><!-- No Of Folios replaceed by roomwise pax  -->
					<td style="width:10px;">Delete</td>
					
				</tr>
			</table> 
		
			<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 250px; overflow-x: hidden; overflow-y: scroll; width: 100%;">
				<table id="tblCheckInDetails"
					style="width: 100%; border: #0F0;  overflow: scroll"
					class="transTablex col8-center">
					<tbody> 
					<tr>
						<td style="width:10%;"></td>
						<td style="width:10%;"></td>
						<td style="width:10%;"></td>
						<td style="width:10%;"></td>
						<td style="width:14%;"></td>
						<td style="width:14%;"></td>
						<td style="width:5%;"></td>
						<td style="width:7%;"></td>
						<td style="width:2%;"></td>
						<!-- <td style="width: 0%;"></td>
						<td style="width: 0%;"></td>
						<td style="width: 0%;"></td>
					 -->
					<!-- 
						<col style="width=40%">
						<col style="width=10%">
						<col style="width=10%">
						<col style="width=10%">
						<col style="width:10%">
						<col style="width:5%">
						<col style="width:5%">
						<col style="width:5%">
						<col style="width:5%">
						<col style="width:5%">-->
						
						<td style="display:none;"></td>
					</tr>
					</tbody>
				</table>
			</div>	
		</div>
		
		
	<!-- 	
		<label >Email Content For Check IN </label>
		
		<div class="col-md-2"><label>Total Rooms</label><label id="txttotrooms" style="background-color:#dcdada94; width: 25px; height: 25px; margin: 27px 0px;"></label>
			
		<div class="col-md-2"><label>Total Guests</label><label id="txttotguest" style="background-color:#dcdada94; width: 25px; height: 25px; margin: 27px 0px;"></label>
			 -->
		
		<div class="col-md-2"><label>Total Rooms</label>
				  <input  type="text" id="txttotrooms" readonly="true"/>
		</div>
		
		<div class="col-md-2"><label>Total Guests</label>
			  <input  type="text" id="txttotguest" readonly="true"/>
		</div>	 
					
		</div>
	 </div></div>
									
		<h3><a href="#">Tariff</a></h3>
			<div>							
			<div class="dynamicTableContainer" style="height: 235px; width: 100%; margin:auto;">
			<table style="height: 28px; border: #0F0; width: 100%;font-size:13px; font-weight: bold;">
				<tr bgcolor="#c0c0c0" style="height: 24px;">
					<!-- col1   -->
					<td align="center" style="width: 30.6%;text-align:left">Date</td>
					<!-- col1   -->
					
					<!-- col2   -->
					<td align="center" style="width: 30.6%;text-align:left">Room Type.</td>
					<!-- col2   -->
					
					<!-- col3   -->
					<td align="center" style="width: 30.6%;text-align:left;">Rate.</td>
					<!-- col3   -->
					
													
				</tr>
			</table>
			<div style="background-color: #fafbfb; border: 1px solid #ccc; display: block; height: 200px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
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
	
	      </div></div>
			
		<h3><a href="#">Package</a></h3>
		<div>		
			<div class=" container transTable" style="background-color:#f2f2f2;height:40%">
	 	<div class="row" style="padding-bottom:10px;">
	 	    <div class="col-md-2"><label>Package Code</label>
			    <s:input id="txtPackageCode" path="strPackageCode"  readonly="true"  ondblclick="funHelp('package')" cssClass="searchTextBox"/>
			</div>
			
			 <div class="col-md-2"><label>Package Name</label>
			     <s:input id="txtPackageName" path="strPackageName" />
			</div>
			<div class="col-md-8"></div>
			
			<div class="col-md-2"><label>Income Head</label>
			    <s:input id="txtIncomeHead" path=""  readonly="true"  ondblclick="funHelp('incomeHead')" cssClass="searchTextBox"/>
		    </div>
		    
			<div class="col-md-2"><label>Income Head Name</label>
				<input type="text" id="txtIncomeHeadName" path="" />
			</div>
			
			<div class="col-md-2"><label>Amount</label>
			    <input type="text" id="txtIncomeHeadAmt" path="" />
			</div>
			
			<div class="col-md-2"><br><input type="button" value="Add" class="btn btn-primary center-block" class="smallButton" onclick='return funAddRow()'/>
	        </div>
	
		   </div>
		</div>
		   
		   <br/>
		<!-- Generate Dynamic Table   -->		
		<div class="dynamicTableContainer" style="height: 320px; width: 100%;margin:auto;">
			<table style="height: 28px; border: #0F0; width: 100%;font-size:11px; font-weight: bold;">
				<tr bgcolor="#c0c0c0" style="height: 24px;">
					<!-- col1   -->
					<td align="left" style="width: 32.6%">Income Head Code</td>
					<!-- col1   -->
					
					<!-- col2   -->
					<td align="left" style="width: 39.6%">Income Head Name</td>
					<!-- col2   -->
					
					<!-- col3   -->
					<td align="left" style="width: 21.6%">Amount</td>
					<!-- col3   -->
					
					<!-- col4   -->
					<td align="left" style="width: 10.6%">Delete</td>
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
	 
	    </div>
    	
		<br>
		<p align="center" style="margin-left:80%">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" onclick="return funValidateForm();"/>
			&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>
 		<s:input type="hidden" id="txtTotalPackageAmt" path="strTotalPackageAmt"></s:input>
		<br><br>
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
