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
<style type="text/css">
.ui-timepicker-wrapper
{
	width: 95px;
}
.timePickerTextBox {
	font-size:13px;
}
#tab_container{
	overflow:hidden;
}
ul.tabs1 li.active {
	border-bottom: 2px solid #007bff;
    border-radius: 0 0px;
    color: #000;
    transition: all 0.9s ease 0s;
    margin-bottom: 10px;
}
.Box{

}
.searchTextBox{
/* background: #ecebeb url(../images/textboxsearchimage.png) no-repeat right;
 */width: 70%;
 border: 1px solid #adaaaa;
} 
</style>

<script type="text/javascript">
	var fieldName;
	var acBrandrow;
	var reservationMessage;
	var smsAPI;
	var smsContentForReservation;
	var emailContentForCheckIn;
	var emailContentForReservation;
	var enableHousekeeping;
	var enableWebCam;
	var billFormat; 
	var ratePickUp;
	var OnlineIntegration;
	var dayforhousekeeping;
	
	$(document).ready(function() {

		funTaxLinkUpData('Tax');
		funDepartmentLinkUpData('Department');
		funSettlementLinkUpData('Settlement');
		funRoomTypeLinkUpData('Room Type');
		funPackageLinkUpData('Package');
		
		
		$(".tab_content").hide();
		$(".tab_content:first").show();

		$("ul.tabs li").click(function() {
			$("ul.tabs li").removeClass("active");
			$(this).addClass("active");
			$(".tab_content").hide();

			var activeTab = $(this).attr("data-state");
			$("#" + activeTab).fadeIn();
		});
		
		
		$(".tab_content1").hide();
		$(".tab_content1:first").show();
		
		$("ul.tabs1 li").click(function() {
			$("ul.tabs1 li").removeClass("active");
			$(this).addClass("active");
			$(".tab_content1").hide();

			var activeTab = $(this).attr("data-state");
			$("#" + activeTab).fadeIn();
		});
		
		
		
	});
	
	
// 	function funValidateFields()
// 	{
// 		var flag=false;
// 		if($('#tmeCheckInTime').val().trim().length==0)
// 		{
// 			 alert("Please Select Check In Time");		 	 
// 		}
// 		else if($('#tmeCheckOutTime').val().trim().length==0)
// 		{
// 			 alert("Please Select Check Out Time");
// 		}
// 		else
// 		{
// 			//checkins
// 			var checkin=$('#tmeCheckInTime').val();
// 			var inHH="00";var inMM="00";var inSS="00";
// 			if(checkin.contains("am"))
// 			{
// 				var checkinvalue=checkin.split("am")[0];
// 				var inHH=checkinvalue.split(":")[0];
// 				var inMM=checkinvalue.split(":")[1];				
// 			}
// 			else
// 			{
// 				var checkinvalue=checkin.split("pm")[0];
// 				var inHH=checkinvalue.split(":")[0];
// 				var inMM=checkinvalue.split(":")[1];				
// 			}
			
// 			//checkouts
// 			var checkout=$('#tmeCheckOutTime').val();
// 			var outHH="00";var outMM="00";var outSS="00";
// 			if(checkout.contains("am"))
// 			{
// 				var checkoutvalue=checkout.split("am")[0];
// 				var outHH=checkoutvalue.split(":")[0];
// 				var outMM=checkoutvalue.split(":")[1];				
// 			}
// 			else
// 			{
// 				var checkoutvalue=checkout.split("pm")[0];
// 				var outHH=checkoutvalue.split(":")[0];
// 				var outMM=checkoutvalue.split(":")[1];				
// 			}
			
// 			$('#tmeCheckInTime').val(inHH+":"+inMM+":"+inSS);
// 			$('#tmeCheckOutTime').val(outHH+":"+outMM+":"+outSS);
			
// 			flag=true;
// 		}
		
// 		return flag;
// 	}
	
	$(function() 
	{	
		$('#tmeCheckInTime').timepicker();
		$('#tmeCheckOutTime').timepicker();	
		
		
		$('#tmeCheckInTime').timepicker({
		       
			datepicker:false,
		    formatTime:"h:i A",
		    step:60,
		    format:"h:i A"
		});
		 
		$('#tmeCheckOutTime').timepicker({
			datepicker:false,
		    formatTime:"h:i A",
		    step:60,
		    format:"h:i A"
		}); 			
		/* 
		$('#tmeCheckInTime').timepicker('setTime', new Date());
		$('#tmeCheckOutTime').timepicker('setTime', new Date());*/

	}); 
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

		var billfooter="${billFooter}";
		var checkinFooter=  "${checkInFooter}";
		$('#txtBillFooter').val(billfooter);
		$('#txtCheckInFooter').val(checkinFooter); 
		var emailId="${emailId}";
		$('#txtEmailId').val(emailId); 
		
		reservationMessage=value="${ReservationEmail}"
		$('#txtReservationEmailContent').val(reservationMessage);
		
		smsAPI=value="${SmsApi}";
		$('#txtSMSAPI').val(smsAPI);
		
		
		smsContentForReservation=value="${smsContentForReservatiojn}"
		$('#txtReservationSMSContent').val(smsContentForReservation);
		
		emailContentForCheckIn=value="${emailContentForCheckIn}"
		$('#txtCheckINEmailContent').val(emailContentForCheckIn);
		
		emailContentForReservation=value="${emailContentForReservation}"
		$('#txtReservationEmailContent').val(emailContentForReservation);
			
		enableHousekeeping=value="${enableHousekeeping}"
		$("#txtHouseKeeping").val(enableHousekeeping);
		if(enableHousekeeping.includes('Y'))
		{
		  document.getElementById("txtHouseKeeping").checked = true;
		}
		else
		{
		
		}
		
		enableWebCam=value="${enableHousekeeping}"
			$("#txtEnableWebCam").val(enableWebCam);
			if(enableWebCam.includes('Y'))
				{
				document.getElementById("txtEnableWebCam").checked = true;
				}
			else
				{
				
				}
			
			billFormat=value="${BillFormat}"
				$("#cmbBillFormat").val(billFormat);
			
			ratePickUp=value="${ratePickUpFrom}"
				$("#cmbBRatepickupfrom").val(ratePickUp);
			
			OnlineIntegration =value="${OnlineIntegration}";
			
			$("#cmbOnlineIntegration").val(OnlineIntegration);
			
			dayforhousekeeping=value="${dayForHousekeeping}";
			if(dayforhousekeeping.length>0)
			{
				$("#cmbDayForHousekeeping").val(dayforhousekeeping);

			}
			
	});
	/**
		* Success Message After Saving Record
	**/
	
	function funHelp(transactionName)
	{
		fieldName=transactionName;
		window.open("searchform.html?formname="+transactionName+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
		//window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
	
	function funCreateSMS1()
	{
	 	 	
		var field =$("#cmbReservationSMSField").val();
		var content='';
		var mainSMS =$("#txtReservationSMSContent").val();
		
		if(field=='CompanyName')
		{
			content='%%CompanyName';
		}
		if(field=='PropertyName')
		{
			content='%%PropertyName';
		}
		if(field=='RNo')
		{
			content='%%RNo';
		}
		if(field=='RDate')
		{
			content='%%RDate';
		}
	
		if(field=='GuestName')
		{
			content='%%GuestName';
		}
		
		if(field=='RoomNo')
		{
			content='%%RoomNo';
		}
		
		if(field=='NoNights')
		{
			content='%%NoNights';
		}
		
		mainSMS+=content;
		$("#txtReservationSMSContent").val(mainSMS);
	 }
		
	function funCreateSMS2()
		{
		
		   
		var field =$("#cmbCheckINSMSField").val();
		var content='';
		var mainSMS =$("#txtCheckINSMSContent").val();
		
		if(field=='CompanyName')
		{
			content='%%CompanyName';
		}
		if(field=='PropertyName')
		{
			content='%%PropertyName';
		}
		if(field=='CheckIn')
		{
			content='%%CheckIn';
		}
		if(field=='GuestName')
		{
			content='%%GuestName';
		}
		if(field=='CheckInDate')
		{
			content='%%CheckInDate';
		}
		
		if(field=='RoomNo')
		{
			content='%%RoomNo';
		}
		
		if(field=='NoNights')
		{
			content='%%NoNights';
		}
		mainSMS+=content;
		$("#txtCheckINSMSContent").val(mainSMS);
		
		}	
		
	
	function funCreateSMS3()
		{	
		
		var field =$("#cmbAdvAmtSMSField").val();
		var content='';
		var mainSMS =$("#txtAdvAmtSMSContent").val();
		
		if(field=='CompanyName')
		{
			content='%%CompanyName';
		}
		if(field=='PropertyName')
		{
			content='%%PropertyName';
		}
		if(field=='PaymentNo')
		{
			content='%%PaymentNo';
		}
		if(field=='SettlementDesc')
		{
			content='%%SettlementDesc';
		}
	
		if(field=='Amount')
		{
			content='%%Amount';
		}
		mainSMS+=content;
		$("#txtAdvAmtSMSContent").val(mainSMS);
		}	
	
	
		function funCreateSMS4()
		{
			
		var field =$("#cmbCheckOutSMSField").val();
		var content='';
		var mainSMS =$("#txtCheckOutSMSContent").val();
		
		if(field=='CompanyName')
		{
			content='%%CompanyName';
		}
		if(field=='PropertyName')
		{
			content='%%PropertyName';
		}
		if(field=='CheckOut')
		{
			content='%%CheckOut';
		}
		if(field=='GuestName')
		{
			content='%%GuestName';
		}
	
		if(field=='RoomNo')
		{
			content='%%RoomNo';
		}
		if(field=='checkOutDate')
		{
			content='%%checkOutDate';
		}
		mainSMS+=content;
		$("#txtCheckOutSMSContent").val(mainSMS);
		}		
		
		function funCreateEmail1()
		{
		 	 	
			var field =$("#cmbReservationEmailField").val();
			var content='';
			var mainSMS =$("#txtReservationEmailContent").val();
			
			if(field=='CompanyName')
			{
				content='%%CompanyName';
			}
			if(field=='PropertyName')
			{
				content='%%PropertyName';
			}
			if(field=='RNo')
			{
				content='%%RNo';
			}
			if(field=='RDate')
			{
				content='%%RDate';
			}
		
			if(field=='GuestName')
			{
				content='%%GuestName';
			}
			
			if(field=='RoomNo')
			{
				content='%%RoomNo';
			}
			
			if(field=='NoNights')
			{
				content='%%NoNights';
			}
			
			mainSMS+=content;
			$("#txtReservationEmailContent").val(mainSMS);
		 }
		function funCreateEmail2()
		{
		
		   
		var field =$("#cmbCheckINEmailField").val();
		var content='';
		var mainSMS =$("#txtCheckINEmailContent").val();
		
		if(field=='CompanyName')
		{
			content='%%CompanyName';
		}
		if(field=='PropertyName')
		{
			content='%%PropertyName';
		}
		if(field=='CheckIn')
		{
			content='%%CheckIn';
		}
		if(field=='GuestName')
		{
			content='%%GuestName';
		}
		if(field=='CheckInDate')
		{
			content='%%CheckInDate';
		}
		
		if(field=='RoomNo')
		{
			content='%%RoomNo';
		}
		
		if(field=='NoNights')
		{
			content='%%NoNights';
		}
		mainSMS+=content;
		$("#txtCheckINEmailContent").val(mainSMS);
		
		}
		
		
		function funValidateFields()
		{
			var roomLimit =  parseFloat($("#txtRoomLimit").val());
			var noOfRoom =  parseFloat($("#txtNoOfRooms").val());
			
			var e = document.getElementById("cmbOnlineIntegration");
			var strOnlineIntegrate = e.options[e.selectedIndex].value;
			
			if(strOnlineIntegrate == 'Yes')
			{
				var strIntegrationURL=document.getElementById("txtIntegratrionURL").value;
				if(strIntegrationURL == '')
				{
					alert("Please Enter Integration URL with port no..");
				}
			}
			
			/* if(roomLimit =="0" || roomLimit == "")
			{
				 alert("Please Enter Room Limit");
				 return false;
			} 
			else if(roomLimit!="0")
			{
				
				if(roomLimit > noOfRoom)
				   {
					alert("Room Limit Cannot be greater than Number of Room.");
				   	return false;
				   }*/
			
				
		}
		
		function funRoomTypeLinkUpData(code)
		{
			var searchUrl="";
			var property=$('#strPropertyCode').val();
			searchUrl=getContextPath()+"/loadPMSLinkUpData.html?strDoc="+code;
			$.ajax
			({
		        type: "POST",
		        url: searchUrl,
			    dataType: "json",
			    success: function(response)
			    {
			    	//funDeleteTableAllRowsOfParticulorTable(code);
			    	$.each(response, function(i,item)
							{
					    		//var arr = jQuery.makeArray( response[i] );
					    		funAddRowRoomTypeLinkUpData(item);
					    		
							}); 
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
		
		function funPackageLinkUpData(code)
		{
			var searchUrl="";
			var property=$('#strPropertyCode').val();
			searchUrl=getContextPath()+"/loadPMSLinkUpData.html?strDoc="+code;
			$.ajax
			({
		        type: "POST",
		        url: searchUrl,
			    dataType: "json",
			    success: function(response)
			    {
			    	//funDeleteTableAllRowsOfParticulorTable(code);
			    	$.each(response, function(i,item)
							{
					    		//var arr = jQuery.makeArray( response[i] );
					    		funAddRowPackageLinkUpData(item);
					    		
							}); 
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
		
		function funSettlementLinkUpData(code)
		{
			var searchUrl="";
			var property=$('#strPropertyCode').val();
			searchUrl=getContextPath()+"/loadPMSLinkUpData.html?strDoc="+code;
			$.ajax
			({
		        type: "POST",
		        url: searchUrl,
			    dataType: "json",
			    success: function(response)
			    {
			    	//funDeleteTableAllRowsOfParticulorTable(code);
			    	$.each(response, function(i,item)
							{
					    		//var arr = jQuery.makeArray( response[i] );
					    		funAddRowSettlementLinkUpData(item);
					    		
							}); 
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
		
		function funTaxLinkUpData(code)
		{
			var searchUrl="";
			var property=$('#strPropertyCode').val();
			searchUrl=getContextPath()+"/loadPMSLinkUpData.html?strDoc="+code;
			$.ajax
			({
		        type: "POST",
		        url: searchUrl,
			    dataType: "json",
			    success: function(response)
			    {
			    	//funDeleteTableAllRowsOfParticulorTable(code);
			    	$.each(response, function(i,item)
							{
					    		//var arr = jQuery.makeArray( response[i] );
					    		funAddRowTaxLinkUpData(item);
					    		
							}); 
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
		
		function funDepartmentLinkUpData(code)
		{
			var searchUrl="";
			var property=$('#strPropertyCode').val();
			searchUrl=getContextPath()+"/loadPMSLinkUpData.html?strDoc="+code;
			$.ajax
			({
		        type: "POST",
		        url: searchUrl,
			    dataType: "json",
			    success: function(response)
			    {
			    	//funDeleteTableAllRowsOfParticulorTable(code);
			    	$.each(response, function(i,item)
							{
					    		//var arr = jQuery.makeArray( response[i] );
					    		funAddRowDeptLinkUpData(item);
					    		
							}); 
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
		
		
		
		function funDeleteTableAllRowsOfParticulorTable(tableName)
		{
			switch(tableName)
			{
				case "Department" :
				{
					$("#tbl"+tableName+ " tr").remove();
					break;
				}
				case "Tax" :
				{
					$("#tbl"+tableName+ " tr").remove();
					break;
				}
				
				case "Room Type" :
				{
					$("#tbl"+tableName+ " tr").remove();
					break;
				}
				case "Package" :
				{
					$("#tbl"+tableName+ " tr").remove();
					break;
				}
							
				case "Settlement" :
				{
					$("#tbl"+tableName+ " tr").remove();
					break;
				}
				
				
			}
		}
		
		function funAddRowDeptLinkUpData(rowData)
		{
			$('#hidLinkup').val("");
			$('#hidLinkup').val("DeptLinkup");
			var table = document.getElementById("tblDepartment");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    var strMasterCode = rowData.strMasterCode;
	    	var strMasterName = rowData.strMasterName;
	    	var strAcCode = rowData.strAccountCode;
	    	var strAcName = rowData.strMasterDesc;
    		if(strAcCode==null && strAcName == null)
   			{
   				strAcCode = "";
   				strAcName = "";
			}
    		else
   			{
    			strAcCode =	rowData.strAccountCode;
				strAcName = rowData.strMasterDesc;
   			}
			row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" name=\"listDeptLinkUp["+(rowCount)+"].strMasterCode\"  id=\"txtMasterCode."+(rowCount)+"\" value='"+strMasterCode+"' />";
		    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" name=\"listDeptLinkUp["+(rowCount)+"].strMasterName\"  id=\"txtMasterName."+(rowCount)+"\" value='"+strMasterName+"' />";
		    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"searchTextBox\"  name=\"listDeptLinkUp["+(rowCount)+"].strAccountCode\"   id=\"txtSettlement."+(rowCount)+"\" value='"+strAcCode+"' ondblclick=\"funHelp1("+(rowCount)+",'Dept-Service')\" />";
		    row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box\"  name=\"listDeptLinkUp["+(rowCount)+"].strMasterDesc\"   id=\"txtSettlementName."+(rowCount)+"\" value='"+strAcName+"' />";
	 	}
		
		function funAddRowPackageLinkUpData(rowData)
		{
			$('#hidLinkup').val("");
			$('#hidLinkup').val("Package");
			var table = document.getElementById("tblPackage");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    var strTaxCode = rowData.strMasterCode;
	    	var strDesc = rowData.strMasterName;
	    	var strAcCode = rowData.strAccountCode;
	    	var strAcName = rowData.strMasterDesc;
    		if(strAcCode==null && strAcName == null)
   			{
   				strAcCode = "";
   				strAcName = "";
			}
    		else
   			{
    			strAcCode =	rowData.strAccountCode;
				strAcName = rowData.strMasterDesc;
   			}
		    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" name=\"listTaxLinkUp["+(rowCount)+"].strMasterCode\"  id=\"txtTaxCode."+(rowCount)+"\" value='"+strTaxCode+"' />";
		    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" name=\"listTaxLinkUp["+(rowCount)+"].strMasterName\"  id=\"txtTaxDesc."+(rowCount)+"\" value='"+strDesc+"' />";
		    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"searchTextBox\"  name=\"listTaxLinkUp["+(rowCount)+"].strAccountCode\"   id=\"txtTaxAcCode."+(rowCount)+"\" value='"+strAcCode+"' ondblclick=\"funHelp1("+(rowCount)+",'Package-Service')\" />";
		    row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box\"  name=\"listTaxLinkUp["+(rowCount)+"].strMasterDesc\"   id=\"txtTaxAcName."+(rowCount)+"\" value='"+strAcName+"' />";
	 	}
		
		
		function funAddRowRoomTypeLinkUpData(rowData)
		{
			$('#hidLinkup').val("");
			$('#hidLinkup').val("RoomType");
			var table = document.getElementById("tblrmType");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    var strTaxCode = rowData.strMasterCode;
	    	var strDesc = rowData.strMasterName;
	    	var strAcCode = rowData.strAccountCode;
	    	var strAcName = rowData.strMasterDesc;
    		if(strAcCode==null && strAcName == null)
   			{
   				strAcCode = "";
   				strAcName = "";
			}
    		else
   			{
    			strAcCode =	rowData.strAccountCode;
				strAcName = rowData.strMasterDesc;
   			}
			
		    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" name=\"listTaxLinkUp["+(rowCount)+"].strMasterCode\"  id=\"txtTaxCode."+(rowCount)+"\" value='"+strTaxCode+"' />";
		    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" name=\"listTaxLinkUp["+(rowCount)+"].strMasterName\"  id=\"txtTaxDesc."+(rowCount)+"\" value='"+strDesc+"' />";
		    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"searchTextBox\"  name=\"listTaxLinkUp["+(rowCount)+"].strAccountCode\"   id=\"txtTaxAcCode."+(rowCount)+"\" value='"+strAcCode+"' ondblclick=\"funHelp1("+(rowCount)+",'RoomType-Service')\" />";
		    row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box\"  name=\"listTaxLinkUp["+(rowCount)+"].strMasterDesc\"   id=\"txtTaxAcName."+(rowCount)+"\" value='"+strAcName+"' />";
	 	}
		
		
		function funAddRowSettlementLinkUpData(rowData)
		{
			$('#hidLinkup').val("");
			$('#hidLinkup').val("SettlementLinkup");
			var table = document.getElementById("tblSettlement");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    var strTaxCode = rowData.strMasterCode;
	    	var strDesc = rowData.strMasterName;
	    	var strAcCode = rowData.strAccountCode;
	    	var strAcName = rowData.strMasterDesc;
    		if(strAcCode==null && strAcName == null)
   			{
   				strAcCode = "";
   				strAcName = "";
			}
    		else
   			{
    			strAcCode =	rowData.strAccountCode;
				strAcName = rowData.strMasterDesc;
   			}
			
		    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" name=\"listTaxLinkUp["+(rowCount)+"].strMasterCode\"  id=\"txtTaxCode."+(rowCount)+"\" value='"+strTaxCode+"' />";
		    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" name=\"listTaxLinkUp["+(rowCount)+"].strMasterName\"  id=\"txtTaxDesc."+(rowCount)+"\" value='"+strDesc+"' />";
		    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"searchTextBox\"  name=\"listTaxLinkUp["+(rowCount)+"].strAccountCode\"   id=\"txtTaxAcCode."+(rowCount)+"\" value='"+strAcCode+"' ondblclick=\"funHelp1("+(rowCount)+",'Settlement-Service')\" />";
		    row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box\"  name=\"listTaxLinkUp["+(rowCount)+"].strMasterDesc\"   id=\"txtTaxAcName."+(rowCount)+"\" value='"+strAcName+"' />";
	 	}
		
		function funAddRowTaxLinkUpData(rowData)
		{
			$('#hidLinkup').val("");
			$('#hidLinkup').val("taxLinkup");
			var table = document.getElementById("tblTax");
		    var rowCount = table.rows.length;
		    var row = table.insertRow(rowCount);
		    var strTaxCode = rowData.strMasterCode;
	    	var strDesc = rowData.strMasterName;
	    	var strAcCode = rowData.strAccountCode;
	    	var strAcName = rowData.strMasterDesc;
    		if(strAcCode==null && strAcName == null)
   			{
   				strAcCode = "";
   				strAcName = "";
			}
    		else
   			{
    			strAcCode =	rowData.strAccountCode;
				strAcName = rowData.strMasterDesc;
   			}
		    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box\" name=\"listTaxLinkUp["+(rowCount)+"].strMasterCode\"  id=\"txtTaxCode."+(rowCount)+"\" value='"+strTaxCode+"' />";
		    row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box\" name=\"listTaxLinkUp["+(rowCount)+"].strMasterName\"  id=\"txtTaxDesc."+(rowCount)+"\" value='"+strDesc+"' />";
		    row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"searchTextBox\"  name=\"listTaxLinkUp["+(rowCount)+"].strAccountCode\"   id=\"txtTaxAcCode."+(rowCount)+"\" value='"+strAcCode+"' ondblclick=\"funHelp1("+(rowCount)+",'Tax-Service')\" />";
		    row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box\"  name=\"listTaxLinkUp["+(rowCount)+"].strMasterDesc\"   id=\"txtTaxAcName."+(rowCount)+"\" value='"+strAcName+"' />";
	 	}
		
		function funHelp1(row,transactionName)
		{
			acBrandrow=row;
			fieldName = transactionName;
			
			if(transactionName=='SubGroup' || transactionName=='Supplier')
			{
				transactionName='AccountMasterGLOnlyWeb-Service';
			}
			 if(transactionName=='Excess' || transactionName=='Shortage')
			{ //
				transactionName='LocationWeb-Service';
			} 
			
			window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:1000px;top=500,left=500")
		}
		
		function funSetData(code){

		switch(fieldName){
				
			case 'Dept-Service' : 
				funSetDept(code);
				break;
		        
			case 'Tax-Service':
		    	funSetTax(acBrandrow,code);
		        break; 
		        
			case 'Settlement-Service':
		    	funSetSettlement(acBrandrow,code);
		        break;      
		        
			case 'Package-Service':
		    	funSetPackage(acBrandrow,code);
		        break;    
		        
			case 'RoomType-Service':
		    	funSetRoomType(acBrandrow,code);
		        break;  
		        
			
		}
	}
		
		function funSetDept(acBrandrow,code)
		{
			$.ajax({
				type : "GET",
				url : getContextPath()+ "/loadCRMTaxLinkupDataFormWebService.html?strDocCode=" + code,
				dataType : "json",
				success : function(response){
					document.getElementById("txtSettlement."+acBrandrow).value=response.strAccountCode;
					document.getElementById("txtSettlementName."+acBrandrow).value=response.strAccountName;
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
		
		
		function funSetTax(acBrandrow,code)
		{
			$.ajax({
				type : "GET",
				url : getContextPath()+ "/loadTaxLinkupDataFormWebService.html?strDocCode=" + code,
				dataType : "json",
				success : function(response){
					document.getElementById("txtTaxAcCode."+acBrandrow).value=response.strAccountCode;
					document.getElementById("txtTaxAcName."+acBrandrow).value=response.strAccountName;
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
		
		function funTaxOnTaxableStateChange()
		{
			var isSelected=$("#txtHouseKeeping").prop('checked');
			if(isSelected==true)
			{
				$("#txtHouseKeeping").val("Y");				
			}
			else
			{
				$("#txtHouseKeeping").val("N");				
			}
		}
		
		function funEnableWebCam()
		{
			var isSelected=$("#txtEnableWebCam").prop('checked');
			if(isSelected==true)
			{
				$("#txtEnableWebCam").val("Y");				
			}
			else
			{
				$("#txtEnableWebCam").val("N");				
			}
		}

		
</script>

</head>
<body>

	<div class="container">
		<label id="formHeading">Property Setup</label>

	<s:form name="PropertySetup" method="POST" action="savePropertySetup.html">
		<div class="row">
			<div class="col-md-2">
				<label>Property</label>
				<s:select id="strPropertyCode" path="strPropertyCode" items="${listOfProperty}" required="true"></s:select>				    						    		        			 
			</div>
		</div>
	
		<div style="border: 0px solid black; width: 100%; height:100%;">
			<div id="tab_container">
					<ul class="tabs">
						<li data-state="tab1">General</li>
						<li data-state="tab2">SMS Setup</li>
						<li data-state="tab3">Linkup</li>
						<li data-state="tab4">E-mail Setup</li>
						<li data-state="tab5">Online Integration</li>
					</ul>
				<div id="tab1" class="tab_content">
					<br><br>
					<div class="row masterTable">
<!-- 					<tr> -->
<!-- 						<td  style="width: 100px;"><label>Property</label></td> -->
<%-- 						<td colspan="5"><s:select id="strPropertyCode" path="strPropertyCode" items="${listOfProperty}" required="true" cssClass="BoxW200px"></s:select></td>				    						    		        			  --%>
<!-- 					</tr> -->
						<div class="col-md-2">
							<label>Check In Time</label>
								<s:input path="tmeCheckInTime"  id="tmeCheckInTime" value="${checkInTime}"  class="timePickerTextBox" style="width: 60%;" />
						</div>	
						<div class="col-md-2"> 
							<label>Check Out Time</label>
							<s:input path="tmeCheckOutTime"  id="tmeCheckOutTime" value="${checkOutTime}" class="timePickerTextBox" style="width: 60%;" />
						</div>
						<div class="col-md-2"> 
							<label>GST No</label>
							<s:input path="strGSTNo"  id="txtGSTNo"  value="${GSTNo}"/>							    						    		        			
						</div>
						<div class="col-md-2"> 
							<label>Total Numbers of Room</label>
							<input type="text" class="numeric" id="txtNoOfRooms" Class="longTextBox" value="${listOfRoom}" style="width:70%;"/>
						</div>
						<div class="col-md-4"></div><br><br><br>
						<div class="col-md-2"> 
							<label>Room Limit</label>
							<s:input type="text" class="numeric" id="txtRoomLimit" path="strRoomLimit" value="${RoomLimit}"/>
						</div>
						<div class="col-md-2"> 
							<label>Bank Ac Name</label>
							<s:input type="text" class="numeric" id="txtbankAcName" value="${bankAcName}" path="strBankAcName"/>
						</div>			
						<div class="col-md-2"> 
							<label>Bank Ac Number</label>
							<s:input type="text" class="numeric" id="txtbankAcNum" value="${BankACNumber}" path="strBankAcNumber"/>
						</div>
						<div class="col-md-2"> 			
							<label>Bank IFS Code</label>
							<s:input  type="text" class="numeric" id="txtbankIFSC" value="${BankIFSC}" path="strBankIFSC"/>
						</div>
							
						<div class="col-md-4"></div><br><br><br>			
						<div class="col-md-2">
							<label>Branch Name</label>
							<s:input type="text" class="numeric" id="txtBranchName" value="${BranchName}" path="stBranchName"/>
						</div>	
						<div class="col-md-2">		
							<label>Pan Number</label>
							<s:input type="text" class="numeric" id="txtPANNo" value="${panNo}" path="strPanNo"/>
						</div>
						<div class="col-md-2">
							<label>HSN Code/SAC</label>
							<s:input type="text" class="numeric" id="txtHSCCode" value="${HSCCode}" path="strHscCode"/>
						</div>
						
						<div class="col-md-2">
							<label>Enable Housekeeping</label><br>
							<s:checkbox id="txtHouseKeeping"  value="N" path="strEnableHousekeeping" onclick="funTaxOnTaxableStateChange()" />
<%-- 							<s:input type="checkbox"  id="txtHouseKeeping" value="N"  path="strEnableHousekeeping"/>
 --%>						</div>	
 
                     
							<%-- <tr>
								<td ><label>Amount Decimal Places</label></td>
									<td><s:select path="intdec" id="intdec"
										cssClass="BoxW48px">
										<s:option value="0">0</s:option>
										<s:option value="1">1</s:option>
										<s:option value="2">2</s:option>
										<s:option value="3">3</s:option>
										<s:option value="4">4</s:option>
										<s:option value="5">5</s:option>
										<s:option value="6">6</s:option>
										<s:option value="7">7</s:option>
										<s:option value="8">8</s:option>
										<s:option value="9">9</s:option>
										<s:option value="10">10</s:option>
								</s:select></td>
									</tr> --%>
									<div class="col-md-4"></div><br><br><br>
									
									<div class="col-md-2">
							<label>Enable Web-cam</label><br>
							<s:checkbox id="txtEnableWebCam"  value="N" path="strEnableWebCam" onclick="funEnableWebCam()" />
<%-- 							<s:input type="checkbox"  id="txtHouseKeeping" value="N"  path="strEnableHousekeeping"/>
 --%>						</div>	
 
 						<div class="col-md-2">
							<label >Bill Format </label>
							
							<s:select  id="cmbBillFormat" path="strBillFormat"  style="width:70%;">
								<option value="Format 1">Format 1</option>
								<option value="Format 2">Format 2</option>
							</s:select>
						</div>
						
						<div class="col-md-2">
							<label >Rate pickup From </label>
							
							<s:select  id="cmbBRatepickupfrom" path="strRatepickUpFrom"  style="width:100%;">
								<option value="Room Type Master">Room Type Master</option>
								<option value="Rate management">Rate management</option>
							</s:select>
						</div>
						
						
						
 				<div class="col-md-2">
							<label >Day for Housekeeping </label>
							
							<s:select  id="cmbDayForHousekeeping" path="strDayForHousekeeping"  style="width:100%;">
								<option value="Select" selected >Select</option>
								<option value="Sunday">Sunday</option>
								<option value="Monday">Monday</option>
								<option value="Tuesday">Tuesday</option>
								<option value="Wednesday">Wednesday</option>
								<option value="Thursday">Thursday</option>
								<option value="Friday">Friday</option>
								<option value="Saturday">Saturday</option>						
							</s:select>
						</div>	
						
						<div class="col-md-4"></div><br><br><br>
						<div class="col-md-2">		
							<label>Bill Footer</label>
							<s:textarea id="txtBillFooter" path="strBillFooter" value="${billFooter}" type="text" style="height: 57%;width: 177%;"/>
							<%-- <s:input type="text" class="numeric" id="txtBillFooter" value="${billFooter}" path="strBillFooter"/> --%>
						</div>
					
						<div class="col-md-2"></div><br><br><br>
						<div class="col-md-2">		
							<label>CheckIn Footer</label>
							<s:textarea id="txtCheckInFooter" path="strCheckInFooter" value="${checkInFooter}" type="text" style="height: 57%;width: 177%;"/>
							
						</div>
						
						<div class="col-md-2"></div><br><br><br> 
						<div class="col-md-2">		
							<label>EmailId</label>
							<s:textarea id="txtEmailId" path="strEmailId" value="${emailId}" type="text" style="height: 57%;width: 177%;"/>
							
						</div>
						
 			
					</div>
					
				</div>
				<div id="tab2" class="tab_content">
					<div id="tblAudit" class="row transTable">
						<div class="col-md-3">
							<label >SMS Provider</label>
							<s:select  id="cmbSMSProvider" path="strSMSProvider"  style="width:70%;">
								<option value="SANGUINE">SANGUINE</option>
							</s:select>
						</div>			
						<div class="col-md-3">
							<label>SMS API</label>
							<s:textarea  id="txtSMSAPI" text="${SmsApi}" path="strSMSAPI"  cssStyle="width:100%; margin-bottom: 10px;" />
						</div>	
						<div class="col-md-6"></div>
						
						 <div class="col-md-3">
							<label >SMS Content For Reservation </label>
								<select  id="cmbReservationSMSField" class="BoxW48px" style="width:70%;" >
									<option value="CompanyName">Company Name</option>
									<option value="PropertyName">Property Name</option>
									<option value="RNo">Reservation No</option>
									<option value="RDate">Reservation Date</option>
									<option value="GuestName">GuestName</option>
									<option value="RoomNo">Room No</option>
									<option value="NoNights">No of Nights</option>
								</select>
						</div>
						 <div class="col-md-1">
							<input type="button" value="Add" class="btn btn-primary center-block" onclick="funCreateSMS1();" id=btnAddSMS1 style="margin-top:13%;"/>
						</div>
						 <div class="col-md-3">
								<s:textarea cssStyle="height: 50px; width: 100%; margin-bottom: 10px;" id="txtReservationSMSContent" path="strReservationSMSContent"  />
						</div>
						<div class="col-md-5"></div>
						<div class="col-md-3">
							<label >Email Content For Check IN </label>
							<select  id="cmbCheckINSMSField"  style="width:70%" >
								<option value="CompanyName">Company Name</option>
								<option value="PropertyName">Property Name</option>
								<option value="CheckIn">Check IN</option>
								<option value="GuestName">GuestName</option>
								<option value="RoomNo">RoomNo</option>
								<option value="NoNights">No of Nights</option>
								<option value="RDate">CheckInDate</option>
							</select>
						</div>
						<div class="col-md-1">
							<input type="button" value="Add" class="btn btn-primary center-block" onclick="funCreateSMS2();" id=btnAddSMS2 style="margin-top:13%;"/>
						</div>
						<div class="col-md-3">
							<s:textarea cssStyle="height: 50px; width: 100%; margin-bottom: 10px;" id="txtCheckINSMSContent" path="strCheckInSMSContent"  />
						</div>
							<div class="col-md-5"></div>
						<div class="col-md-3">
							<label >SMS Content For Advance Amount </label>
								<select  id="cmbAdvAmtSMSField" style="width:70%" >
									<option value="CompanyName">Company Name</option>
									<option value="PropertyName">Property Name</option>
									<option value="PaymentNo">Payment Recipt No</option>
									<option value="Amount">Amount</option>
									<option value="SettlementDesc">Settlement Description</option>
								</select>
						</div>
						
						<div class="col-md-1">
							<input type="button" value="Add" class="btn btn-primary center-block" onclick="funCreateSMS3();" id=btnAddSMS3 style="margin-top:13%;"/>
						</div>
						<div class="col-md-3">
							<s:textarea cssStyle="height:50px; width: 100%; margin-bottom: 10px;" id="txtAdvAmtSMSContent" path="strAdvAmtSMSContent"  />
						</div>
						<div class="col-md-5"></div>
						<div class="col-md-3">
							<label >SMS Content For check Out </label>
							<select  id="cmbCheckOutSMSField"  style="width:70%" >
								<option value="CompanyName">Company Name</option>
									<option value="PropertyName">Property Name</option>
									<option value="CheckOut">Check Out</option>
									<option value="GuestName">GuestName</option>
									<option value="RoomNo">RoomNo</option>
									<option value="checkOutDate">CheckOutDate</option>
							</select>
						</div>
						<div class="col-md-1">
							<input type="button" value="Add" class="btn btn-primary center-block" onclick="funCreateSMS4();" id=btnAddSMS4 style="margin-top:13%;"/>
						</div>
						<div class="col-md-3">
							<s:textarea cssStyle="height: 50px; width: 100%; margin-bottom: 10px;" id="txtCheckOutSMSContent" path="strCheckOutSMSContent"  />
						</div>
							
					</div>							
				</div>
							
				<div id="tab3" class="tab_content">
				<br/><br/>
					<div id="tab_container1" class="masterTable">
						<ul class="tabs1">
							<li class="active" data-state="divSubGroup">Department</li>
							<li data-state="divTax">Tax</li>
							<li data-state="divSupplier">Room Type</li>
							<li data-state="divDiscount">Package</li>
							<li data-state="divRoundOff">Settlement</li>
						 </ul>
						<div id="divSubGroup" class="tab_content1" style="height: 500px;margin-top: 20px;">
							<table style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
								<tr bgcolor="#c0c0c0">
									<td style="width:10%;">Department Code</td>
									<td style="width:10%;">Department Code</td>
									<td style="width:20%;">Account Code</td>
									<td style="width:20%;">Account Name</td>
								</tr>
							</table>
							
							<div style="background-color: #fbfafa; border: 1px solid #ccc; display: block; height: 250px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 99.80%;">
								<table id="tblDepartment" style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
										class="transTablex col8-center">
									<tbody>
										<col style="width:10%">
										<col style="width:10%">					
										<col style="width:20%">
										<col style="width:20%">
									</tbody>
								</table>
							</div>
						</div>
						<div id="divTax" class="tab_content1" style="height: 500px;margin-top: 20px;">
							<table style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
								<tr style="background:#c0c0c0;">
									<td style="width:10%;">Tax Code</td>
									<td style="width:10%;">Tax Name</td>
									<td style="width:20%;">Account Code</td>
									<td style="width:20%;">Account Name</td>
								</tr>
							</table>
							
							<div style="background-color: #fbfafa; border: 1px solid #ccc; display: block; height: 250px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 99.80%;">
								<table id="tblTax" style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
									     class="transTablex col8-center">
									<tbody>
										<col style="width:10%">
										<col style="width:10%">					
										<col style="width:20%">
										<col style="width:20%">
									</tbody>
								</table>
							</div>
						</div>
							
						<div id="divSupplier" class="tab_content1" style="height: 500px;margin-top: 20px;">
							<table style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
								<tr bgcolor="#c0c0c0">
									<td style="width:10%;">Room Code</td>
									<td style="width:10%;">Room Desc</td>
									<td style="width:20%;">Account Code</td>
									<td style="width:20%;">Account Name</td>
								</tr>
							</table>
							
							<div style="background-color: #fbfafa; border: 1px solid #ccc; display: block; height: 250px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 99.80%;">
								<table id="tblrmType" style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
									class="transTablex col8-center">
									<tbody>
										<col style="width:10%">
										<col style="width:10%">					
										<col style="width:20%">
										<col style="width:20%">
									</tbody>
								</table>
							</div>
						</div>
						
						<div id="divDiscount" class="tab_content1" style="height: 500px;margin-top: 20px;">
							<table style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
								<tr bgcolor="#c0c0c0">
									<td style="width:10%;">Package Code</td>
									<td style="width:10%;">Package Desc</td>
									<td style="width:20%;">Account Code</td>
									<td style="width:20%;">Account Name</td>
								</tr>
							</table>
							
							<div style="background-color: #fbfafa; border: 1px solid #ccc; display: block; height: 250px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 99.80%;">
								<table id="tblPackage" style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
									class="transTablex col8-center">
									<tbody>
										<col style="width:10%">
										<col style="width:10%">					
										<col style="width:20%">
										<col style="width:20%">
									</tbody>
								</table>
							</div>
						</div>
							
						<div id="divRoundOff" class="tab_content1" style="height: 500px;margin-top: 20px;">
							<table style="height: 28px; border: #0F0; width: 100%; font-size: 11px; font-weight: bold;">
								<tr bgcolor="#c0c0c0">
									<td style="width:10%;">Settlement Code</td>
									<td style="width:10%;">Settlement Desc</td>
									<td style="width:20%;">Account Code</td>
									<td style="width:20%;">Account Name</td>
								</tr>
							</table>
							
							<div style="background-color: #fbfafa; border: 1px solid #ccc; display: block; height: 250px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 99.80%;">
									<table id="tblSettlement" style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll"
									class="transTablex col8-center">
									<tbody>
										<col style="width:10%">
										<col style="width:10%">					
										<col style="width:20%">
										<col style="width:20%">
									</tbody>
								</table>
							</div>
						</div>						
					</div>
				</div>
				<div id="tab4" class="tab_content">
					<br><br><br>
					<div id="tblAudit" class="row transTable">
						<div class="col-md-3">
							<label >Email Content For Reservation </label><br>
								<select  id="cmbReservationEmailField" style="width:70%;">
									<option value="CompanyName">Company Name</option>
									<option value="PropertyName">Property Name</option>
									<option value="RNo">Reservation No</option>
									<option value="RDate">Reservation Date</option>
									<option value="GuestName">GuestName</option>
									<option value="RoomNo">Room No</option>
									<option value="NoNights">No of Nights</option>
								</select>
						</div>
						<div class="col-md-2">
							<input type="button" value="Add" class="btn btn-primary center-block" onclick="funCreateEmail1();" id=btnAddEmail1 style="margin-top:13%;"/>
						</div>
						<div class="col-md-3">
							<s:textarea cssStyle="height: 50px; width: 100%; margin-bottom: 10px;" id="txtReservationEmailContent" value="${ReservationEmail}" path="strReservationEmailContent"  />
						</div>
						<div class="col-md-4"></div>
						<div class="col-md-3">
							<label >Email Content For Check IN  </label>
								<select  id="cmbCheckINEmailField"  style="width:70%;">
									<option value="CompanyName">Company Name</option>
									<option value="PropertyName">Property Name</option>
									<option value="CheckIn">Check IN</option>
									<option value="GuestName">GuestName</option>
									<option value="RoomNo">RoomNo</option>
									<option value="NoNights">No of Nights</option>
									<option value="RDate">CheckInDate</option>
								</select>
						</div>
						<div class="col-md-2">
							<input type="button" value="Add" class="btn btn-primary center-block" onclick="funCreateEmail2();" id=btnAddEmail2 style="margin-top:13%;"/>
						</div>	
						<div class="col-md-3">
							<s:textarea cssStyle="height: 50px; width: 100%; margin-bottom: 10px;" id="txtCheckINEmailContent" path="strCheckInEmailContent"  />
						</div>	
					</div>
				</div>
				
				<!--For Online Integratoion  -->
				
				<div id="tab5" class="tab_content">
					<br><br><br>
					<div id="tblAudit" class="row transTable">
						<div class="col-md-3">
							<label >Online Integration </label><br>
								<s:select  id="cmbOnlineIntegration" path="strOnlineIntegration" style="width:70%;">
									<option value="Yes">Yes</option>
									<option value="No">No</option>
									
								</s:select>
						</div>
						
						<div class="col-md-2"> 
							<label>Integration URL</label>
							<s:input type="text" class="text" placeholder="URL" id="txtIntegratrionURL" path="strIntegrationUrl" value="${IntegrationUrl}"/>
						</div>
					
							
					</div>
				</div>
		</div>
	
		<br />
		<div class="center">
			<a href="#"><button class="btn btn-primary center-block" tabindex="3" value="Submit" onclick="return funValidateFields()"
				class="form_button">Submit</button></a>
			<a href="#"><button class="btn btn-primary center-block" value="Reset" onclick="funResetFields()"
				class="form_button">Reset</button></a>
		</div>
	</div>
	</s:form>
</div>
</body>
</html>
