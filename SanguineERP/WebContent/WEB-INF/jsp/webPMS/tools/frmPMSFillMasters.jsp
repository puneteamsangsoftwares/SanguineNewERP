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
	var listGuest;
	$(document).ready(function() {

		/* funTaxLinkUpData('Tax');
		funDepartmentLinkUpData('Department');
		funSettlementLinkUpData('Settlement');
		funRoomTypeLinkUpData('Room Type');
		funPackageLinkUpData('Package'); */
		
		
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
		
		/* function funRoomTypeLinkUpData(code)
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
		 */
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
		
		/* function funSettlementLinkUpData(code)
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
		 */
		
		/* function funAddRowRoomTypeLinkUpData(rowData)
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
		 */
		
		/* function funAddRowSettlementLinkUpData(rowData)
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
		} */
		
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
		        
			case 'roomType':
		    	funSetRoomType(code);
		        break;  
		        
			case 'frmGuestMaster':
		    	funSetGuestList(code);
		        break;
		        
			case 'frmRoomMaster':
		    	funSetRoomList(code);
		        break; 
			
		}
		
	}
		function funSetGuestList(data)
		{
			listGuest = data;
		    funAddGuestData(listGuest);
		}
		
		function funSetRoomList(data)
		{
			loadRoomNumbersFromImport(data)
		}
		
		function funSetRoomType(code)
		{
			$("#txtRoomTypeCode").val(code);
			$.ajax({
				type : "GET",
				url : getContextPath()+ "/loadRoomTypeMasterData.html?roomCode=" + code,
				dataType : "json",
				success : function(response){ 
					if(response.strRoomTypeCode=='Invalid Code')
		        	{
		        		alert("Invalid Room Type");
		        		$("#txtRoomType").val('');
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
		
		function funDeleteRow(obj) {
			var index = obj.parentNode.parentNode.rowIndex;
			var table = document.getElementById("tblRoomTypeMaster");
			table.deleteRow(index);
		}
		function funAddRoom()
		   {
			   
			   document.getElementById('addRoomPopup').style.cssText = 'display: block';
		   }
		
		function hidePopup() {
	        document.getElementById('addRoomPopup').style.cssText = 'display: none';
	      }
		
		function loadRoomNumbers(data)
		{
				
			document.getElementById('addRoomPopup').style.cssText = 'display: none';
			
			var RoomTypeCode = data.form[24].value;
			
			var roomStartFrom = parseInt(data.form[25].value);
			
			var noOfRooms = parseInt(data.form[26].value);
			
			var roomTypeDesc = getRoomTypeDesc(RoomTypeCode);
			
			var table = document.getElementById("tblRoomNumberMaster");
		    var rowCount ;
		    var row ;
		    for(var i=0;i<=noOfRooms;i++)
		    	{
		    	 
		    	rowCount = table.rows.length;
			     row = table.insertRow(rowCount);
		   			row.insertCell(0).innerHTML= "<input name=\"listRoomMaster["+(rowCount)+"].strRoomTypeDesc\" class=\"Box\" readonly=readonly\ style=\"width:40%;\" id=\"strRoomTypeDesc."+(rowCount)+"\" value="+roomTypeDesc+">";
	    			row.insertCell(1).innerHTML= "<input name=\"listRoomMaster["+(rowCount)+"].strRoomDesc\" class=\"Box\" style=\"text-align: right;width:20%;\" id=\"strRoomDesc."+(rowCount)+"\" value="+roomStartFrom+">";
	   			 	row.insertCell(2).innerHTML= "<input name=\"listRoomMaster["+(rowCount)+"].strBedType\" class=\"Box\" style=\"width:40%;\" id=\"strBedType."+(rowCount)+"\" value='SINGLE'>";
	   			 	row.insertCell(3).innerHTML= "<input name=\"listRoomMaster["+(rowCount)+"].strRoomType\" class=\"Box\" hidden=hidden\style=\"width:1%;\" id=\"strRoomTypeCode."+(rowCount)+"\" value='"+RoomTypeCode+"'>";

	   			 rowCount++;
	   			roomStartFrom = roomStartFrom+1;
		    	}
		}
		
		function loadRoomNumbersFromImport(data)
		{
			var table = document.getElementById("tblRoomNumberMaster");
		    var rowCount ;
		    var row ;
		    for(var i=0;i<=data.length;i++)
		    	{
		    	 var RoomNo = data[i].strRoomDesc;
		    	 var roomType = data[i].strRoomTypeDesc;
		    	 var RoomTypeCode = "";
		    	rowCount = table.rows.length;
			     row = table.insertRow(rowCount);
		   			row.insertCell(0).innerHTML= "<input name=\"listMaster["+(rowCount)+"].strRoomTypeDesc\" class=\"Box\" readonly=readonly\ style=\"width:40%;\" id=\"strRoomTypeDesc."+(rowCount)+"\" value="+roomType+">";
	    			row.insertCell(1).innerHTML= "<input name=\"listMaster["+(rowCount)+"].strRoomDesc\" class=\"Box\" style=\"text-align: right;width:20%;\" id=\"strRoomDesc."+(rowCount)+"\" value="+RoomNo+">";
	   			 	row.insertCell(2).innerHTML= "<input name=\"listMaster["+(rowCount)+"].strBedType\" class=\"Box\" style=\"width:40%;\" id=\"strBedType."+(rowCount)+"\" value='SINGLE'>";
	   			 	row.insertCell(3).innerHTML= "<input name=\"listMaster["+(rowCount)+"].strRoomType\" class=\"Box\" hidden=hidden\style=\"width:1%;\" id=\"strRoomTypeCode."+(rowCount)+"\" value='"+RoomTypeCode+"'>";

	   			 rowCount++;
		    	}
		}
		
		function funAddGuestData(data)
		{
				
			var table = document.getElementById("tblGuestMaster");
		    var rowCount ;
		    var row ;
		    for(var i=0;i<=data.length;i++)
		    	{
		    	 
		    	var strFirstName = data[i].strFirstName;
		    	var strMiddleName = data[i].strMiddleName;
		    	var strLastName = data[i].strLastName;
		    	var intMobileNo = data[i].intMobileNo;
		    	var strGender = data[i].strGender;
		    	rowCount = table.rows.length;
			     row = table.insertRow(rowCount);
		   			row.insertCell(0).innerHTML= "<input name=\"listGuestMaster["+(rowCount)+"].strFirstName\" class=\"Box\" readonly=readonly\ style=\"width:100%;\" id=\"strRoomTypeDesc."+(rowCount)+"\" value="+strFirstName+">";
	    			row.insertCell(1).innerHTML= "<input name=\"listGuestMaster["+(rowCount)+"].strMiddleName\" class=\"Box\" style=\"width:100%;\" id=\"strRoomDesc."+(rowCount)+"\" value="+strMiddleName+">";
	   			 	row.insertCell(2).innerHTML= "<input name=\"listGuestMaster["+(rowCount)+"].strLastName\" class=\"Box\" style=\"width:100%;\" id=\"strBedType."+(rowCount)+"\" value='"+strLastName+"'>";
	   			 	row.insertCell(3).innerHTML= "<input name=\"listGuestMaster["+(rowCount)+"].strGender\" class=\"Box\" \style=\"width:100%;\" id=\"strRoomTypeCode."+(rowCount)+"\" value='"+strGender+"'>";
	   			 	row.insertCell(4).innerHTML= "<input name=\"listGuestMaster["+(rowCount)+"].intMobileNo\" class=\"Box\" \style=\"text-align: right;width:100%;\" id=\"strRoomTypeCode."+(rowCount)+"\" value='"+intMobileNo+"'>";
	   			 	row.insertCell(5).innerHTML= "<input name=\"listGuestMaster["+(rowCount)+"].strEmailId\" class=\"Box\" \style=\"width:100%;\" id=\"strRoomTypeCode."+(rowCount)+"\" value='sumeet@nsnm.com'>";



	   			 rowCount++;
		    	}
		}
		function getRoomTypeDesc(code)
		{
			var roomTypeDesc = '';
			$.ajax({
				type : "GET",
				url : getContextPath()+ "/loadRoomTypeMasterData.html?roomCode=" + code,
		        async: false,
				dataType : "json",
				success : function(response){ 
					if(response.strRoomTypeCode=='Invalid Code')
		        	{
		        		alert("Invalid Room Type");
		        		$("#txtRoomType").val('');
		        	}
		        	else
		        	{
		        		
		        		/* $("#lblRoomType").text(response.strRoomTypeDesc); */
		        		roomTypeDesc = response.strRoomTypeDesc;
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
			return roomTypeDesc;
		}
		
		function funOpenExportImportGuest()			
		{
			var transactionformName="frmGuestMaster";
			fieldName = transactionformName;
					window.open("frmExcelExportImport.html?formname="+transactionformName,"","dialogHeight:500px;dialogWidth:500px;dialogLeft:550px;");
					window.close();
			
		}
		
		function funOpenExportImport()			
		{
			var transactionformName="frmRoomMaster";
			//var guestCode=$('#txtGuestCode').val();
			fieldName = transactionformName;
			
		//	response=window.showModalDialog("frmExcelExportImport.html?formname="+transactionformName+"&strLocCode="+locCode,"","dialogHeight:500px;dialogWidth:500px;dialogLeft:550px;");
			response=window.open("frmExcelExportImport.html?formname="+transactionformName,"dialogHeight:500px;dialogWidth:500px;dialogLeft:550px;");
	        
			
		}
		
</script>

</head>
<body>

	<div class="container">
		<label id="formHeading">Fill Masters</label>

	<s:form name="FillMaster" method="POST" action="saveFillMaster.html">
		
	
		<div style="border: 0px solid black; width: 100%; height:100%;">
			<div id="tab_container">
					<ul class="tabs">
						<li data-state="tab1">Guest Master</li>
						<li data-state="tab2">Room type Master</li>
						<li data-state="tab3">Room Master</li>
						<li data-state="tab4">Tax Master</li>
					</ul>
				
				<br />
				
				<div id="tab1" class="tab_content">
							<div class="col-md-12" align="center"><a onclick="funOpenExportImportGuest()" style="margin-left: 46%"
					     href="javascript:void(0);"><u>Export/Import</u></a>
					<!-- <a id="baseUrl" href="#"> Attach Documents</a> -->
					</div>
							<div class="" style="height: 300px; background:#fbfafa;">
								<table style="height: 20px; border: #0F0;width: 100%;font-size:11px; font-weight: bold;">
									<tr bgcolor="#c0c0c0">
										<td width="10%">First Namne</td>
										<td width="10%">Midle Namne</td>
										<td width="10%">Last Namne</td>
										<td width="5%">Gender</td>
										<td width="10%">Mobile NO.</td>
										<td width="10%">Email Id.</td>
									</tr>
								</table>
								 <div>
									<table id="tblGuestMaster" style="width:100%; border:
											#0F0;table-layout:fixed;overflow:scroll;" class="transTablex col4-center">
										<tbody>    
							<col style="width:10%"><!--  COl1   -->
							<col style="width:10%"><!--  COl2   -->
							<col style="width:10%"><!--  COl3   -->
							<col style="width:5%"><!--  COl3   -->
							<col style="width:10%"><!--  COl3   -->
							<col style="width:10%"><!--  COl3   -->
							</tbody>
									</table>
								</div> 
							</div>
						</div>
				
				<div id="tab3" class="tab_content">
							<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="Button" value="Add Rooms" onclick="funAddRoom()" class="btn btn-primary center-block" style="margin-top:20px;" />
								
								<a onclick="funOpenExportImport()"
							href="javascript:void(0);">Export/Import</a>
							</div>
							<!-- <div class=""  align="center" style="margin-left: 12%"><a onclick="funOpenExportImport()"
							href="javascript:void(0);">Export/Import</a>&nbsp; &nbsp; &nbsp;
							&nbsp;
							</div> -->
							<div class="transTablex col15-center" style="height: 300px; background:#fbfafa;">
								<table style="height: 20px; border: #0F0;width: 100%;font-size:11px; font-weight: bold;">
									<tr bgcolor="#c0c0c0">
										<td width="10%">Room Type</td>
										<td width="10%">Room No</td>
										<td width="10%">Bed Type</td>
										<td width="1%"></td>
									</tr>
								</table>
							 	<div style="background-color: #fbfafa;border: 1px solid #ccc;display: block;height: 330px;margin: auto;width: 100%;">
									<table id="tblRoomNumberMaster" style="width:100%; border:
											#0F0;table-layout:fixed;" class="transTablex">
											<tbody>    
							<col style="width:10%"><!--  COl1   -->
							<col style="width:10%"><!--  COl2   -->
							<col style="width:10%"><!--  COl3   -->
							<col style="width:1%"><!--  COl3   -->
							</tbody>
									</table>
								</div>  
							</div>
						</div>
						
						<!-- Room master -->
						
						<div id="tab2" class="tab_content">
							
							<div class="" style="height: 300px; background:#fbfafa;">
								<table style="height: 20px; border: #0F0;width: 100%;font-size:11px; font-weight: bold;">
									<tr bgcolor="#c0c0c0">
										<td width="10%">Remove</td>
										<td width="20%">Type</td>
										<td width="30%">Description</td>
										<td width="10%">Single Tariff</td>
										<td width="10%">Double Tariff</td>
										<td width="10%">Tripple Tariff</td>
										<td width="10%">Extra Bed Tariff</td>
									</tr>
								</table>
								<div>
									<table id="tblRoomTypeMaster" style="width:100%; border:
											#0F0;table-layout:fixed;overflow:scroll;" class="transTablex col4-center">
										<c:forEach items="${listRoomTypeMaster}" var="SB" varStatus="status">
											<tr>
											
													<td style="width: 10%; height: 12px;text-align:center;"><input type="button" value = "Delete" class="deletebutton" onClick="Javacsript:funDeleteRow(this)"></td>
													
													<td style="width: 20%; height: 12px;"><input size="20%" class="Box"  
													name="listRoomTypeMaster[${status.index}].strRoomTypeCode"
													value="${SB.strRoomTypeCode}" /></td>
													
													<td style="width: 30%; height: 12px;"><input size="30%" class="Box"  
													name="listRoomTypeMaster[${status.index}].strRoomTypeDesc"
													value="${SB.strRoomTypeDesc}" /></td>
													
													<td style="width: 10%; height: 12px;"><input style="text-align:right;" size="10%" class="Box"  
													name="listRoomTypeMaster[${status.index}].dblRoomTerrif"
													value="${SB.dblRoomTerrif}" /></td>
													
													<td style="width: 10%; height: 12px;"><input style="text-align:right;" size="10%" class="Box"  
													name="listRoomTypeMaster[${status.index}].dblDoubleTariff"
													value="${SB.dblDoubleTariff}" /></td>
													
													<td style="width: 10%; height: 12px;"><input style="text-align:right;" size="10%" class="Box"  
													name="listRoomTypeMaster[${status.index}].dblTrippleTariff"
													value="${SB.dblTrippleTariff}" /></td>
											
												<td style="width: 10%; height: 12px;"><input style="text-align:right;" size="10%" class="Box"  
													name="listRoomTypeMaster[${status.index}].strGuestCapcity"
													value="${SB.strGuestCapcity}" /></td>
		
												
											</tr>
										</c:forEach>
									</table>
								</div> 
							</div>
						</div>
				
				
		</div>
		
		<!-- Add Room Pop -->
		
		<div class="popup-details" id="addRoomPopup">
        <div class="popup-backdrop">
          <div class="popup-data" style="height:80%;background-color: whitesmoke;margin-right: 25%;width: 40%">
            
              
            	<input type="Button" value="Save" onclick="return loadRoomNumbers(this)" class="btn btn-primary center-block" style="margin-top:20px;margin-left:70%;" />
            
				<input type="Button" value="Close" onclick="hidePopup()" class="btn btn-primary center-block" style="margin-top:20px;" />
              
              
				<div>
				<label style="padding-left:20px;width: 100%;text-align: center;background-color: #646777;color: white;">Add Rooms</label>
				</div>
				
				
				<div  class="col-md"></div>
				<div class="col-md-10" style="margin-left: 29%;">
						 <div class="row">
						    <div class="col-md-3.5"><label>Room Type</label></div>
						    <div class="col-md-5"><s:input id="txtRoomTypeCode" path=""  readonly="true" style="background-color: whitesmoke;width: 60%;" ondblclick="funHelp('roomType')" cssClass="searchTextBox"/></div>
						    <div class="col-md-4"><label  id="lblRoomType"></label></div>
						 </div></div>
						 
				<div class="col-md-10" style="margin-left: 8%;">
						 <div class="row">
						    <div class="col-md-3.5"><label>Room Number Starting From</label></div>
						    <div class="col-md-5"><s:input id="txtRoomNumberStart" path=""  style="text-align: right;width: 60%;"  cssClass="longTextBox"/></div>
						 </div></div>		 

				<div class="col-md-10" style="margin-left: 5%;">
						 <div class="row">
						    <div style="margin-left: 28.5%" class="col-md-3.5"><label>How many</label></div>
						    <div class="col-md-5"><s:input id="txtHowManyRooms" path=""  style="text-align: right;width: 60%;"  cssClass="longTextBox"/></div>
						 </div></div>
              
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
