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
	$(document).ready(function() 
			{		
				$(".tab_content").hide();
				$(".tab_content:first").show();

				$("ul.tabs li").click(function() {
					$("ul.tabs li").removeClass("active");
					$(this).addClass("active");
					$(".tab_content").hide();
					var activeTab = $(this).attr("data-state");
					$("#" + activeTab).fadeIn();
				});
					
				$(document).ajaxStart(function(){
				    $("#wait").css("display","block");
				});
				$(document).ajaxComplete(function(){
				   	$("#wait").css("display","none");
				});
				
				var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
				var message='';
				<%if (session.getAttribute("successForSplitBill") != null) {
					            if(session.getAttribute("successMessageForSplitBill") != null){%>
					            message='<%=session.getAttribute("successMessageForSplitBill").toString()%>';
					            <%
					            session.removeAttribute("successMessageForSplitBill");
					            }
								boolean test = ((Boolean) session.getAttribute("successForSplitBill")).booleanValue();
								session.removeAttribute("successForSplitBill");
								if (test) {
								%>
					           alert("Checkout is done successfully");
					           var strSelectBill="";
					           var splitAllBill=message.split("#");
					           for(var k=0;k<splitAllBill.length;k++)
				        	   {					        			        	
						       	   window.open(getContextPath()+"/rptBillPrinting.html?fromDate="+pmsDate+"&toDate="+pmsDate+"&billNo="+splitAllBill[k]+"&strSelectBill="+strSelectBill);
				        	   }					           
				<%
				}}%>
				
				var messageForPaymentCheck;
				<%if (session.getAttribute("balanceForPaymentCheck") != null) {
		            if(session.getAttribute("MessagebalanceForPaymentCheck") != null){%>
		            messageForPaymentCheck='<%=session.getAttribute("MessagebalanceForPaymentCheck").toString()%>';
		            <%
		            session.removeAttribute("MessagebalanceForPaymentCheck");
		            }
					boolean test = ((Boolean) session.getAttribute("balanceForPaymentCheck")).booleanValue();
					session.removeAttribute("balanceForPaymentCheck");
					if (test) {
					%>
					 alert(messageForPaymentCheck);
		            <% 
		            }}%>
				
			}); 
	function funValidateData()
	{
		var table=document.getElementById("tblRoomDtl");
		var rowCount=table.rows.length;
		if(rowCount>0)
		{
			var folioNo=document.getElementById("strFolioNo.0").defaultValue;
			var checkOutDate=document.getElementById("dteCheckOutDate.0").defaultValue;
			var searchUrl=getContextPath()+"/isCheckFolioStatus.html?folioNo="+folioNo+"&checkOutDate="+checkOutDate;
			$.ajax({
				
				url:searchUrl,
				type :"GET",
				dataType: "json",
				async:false,
		        success: function(response)
		        {
		           checkOutParam=response;
		 		   if(checkOutParam==false)
	 			   {
		 			  var test=confirm("Do you want to do Post Room Tariff ?");
						/* if(test)
						{
							window.open(getContextPath() +"/frmPostRoomTerrif.html",'_blank');
						}
						returnValue=false; */
						if(test)
						{
							window.open(getContextPath() +"/frmPostRoomTerrif.html",'_blank');
						}
						else
						{
							 var table=document.getElementById("tblRoomDtl");
								var rowCount=table.rows.length;
								var totalAmt=0.00;
								if(rowCount>0)
								{
								    for(var i=0;i<rowCount;i++)
								    {
								    	var balanceAmount=table.rows[i].cells[4].innerHTML;
								       	totalAmt=totalAmt+parseFloat($(balanceAmount).val());
								    }
								   	totalAmt=parseFloat(totalAmt).toFixed(maxAmountDecimalPlaceLimit);
								   	
								}
								
								if(totalAmt>0)
								{
									 alert("Payment is Pending !!!!");
									 returnValue= false;
								}
								else
								{
									 returnValue=true;
								
								}
						}	
					
	 			   }
		 		   else
	 			   {
		 			  var table=document.getElementById("tblRoomDtl");
						var rowCount=table.rows.length;
						var totalAmt=0.00;
						if(rowCount>0)
						{
						    for(var i=0;i<rowCount;i++)
						    {
						    	var balanceAmount=table.rows[i].cells[4].innerHTML;
						       	totalAmt=totalAmt+parseFloat($(balanceAmount).val());
						    }
						   	totalAmt=parseFloat(totalAmt).toFixed(maxAmountDecimalPlaceLimit);
						   	
						}
						
						if(totalAmt>0)
						{
							 alert("Payment is Pending !!!!");
							 returnValue= false;
						}
						else
						{
							 returnValue=true;
						
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
			
			return returnValue;
		}
		else
		{
			alert("Please Select Room Detail.");
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
	
	
	
	function funFillTableRevenueDtl(dataList)
	{
		$('#tblRoomRevenueDtl tbody > tr').remove();
		 for(var i=0;i<dataList.length;i++ )
	     {
			 var table=document.getElementById("tblRoomRevenueDtl");
			 var rowCount=table.rows.length;
			 var row=table.insertRow();
			 var list=dataList[i];
		 	 row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 5px;width: 100%;\" name=\"listCheckOutRevenueDtlBeans["+(rowCount)+"].strRevenueType\" id=\"strRevenueType."+(rowCount)+"\" value='"+list.strRevenueType+"' >";
		     row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 5px;width: 96%;text-align: end;\" name=\"listCheckOutRevenueDtlBeans["+(rowCount)+"].dblAmount\" id=\"RevenuedblAmount."+(rowCount)+"\"  value='"+list.dblAmount+"' >";
			 row.insertCell(2).innerHTML= "<input class=\"Box \"  style=\"padding-left: 5px;width: 68%;text-align: center;\" name=\"listCheckOutRevenueDtlBeans["+(rowCount)+"].strBillMergeNumber\" id=\"strBillMergeNumber."+(rowCount)+"\"  value='1' >";

	     }
				
	}
	
	
	function fillTableRow(index,obj)
	{
		var table=document.getElementById("tblRoomDtl");
		var rowCount=table.rows.length;
		var row=table.insertRow();
	   
 	    row.insertCell(0).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 5px;width: 100%;\" name=\"listCheckOutRoomDtlBeans["+(rowCount)+"].strRoomDesc\" id=\"strRoomDesc."+(rowCount)+"\" value='"+obj.strRoomDesc+"' >";
        row.insertCell(1).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 5px;width: 100%;\" name=\"listCheckOutRoomDtlBeans["+(rowCount)+"].strRegistrationNo\" id=\"strRegistrationNo."+(rowCount)+"\"  value='"+obj.strRegistrationNo+"' >";
		row.insertCell(2).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 5px;width: 100%;\" name=\"listCheckOutRoomDtlBeans["+(rowCount)+"].strFolioNo\" id=\"strFolioNo."+(rowCount)+"\"  value='"+obj.strFolioNo+"' >";
		row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 5px;width: 100%;\" name=\"listCheckOutRoomDtlBeans["+(rowCount)+"].strGuestName\" id=\"strGuestName."+(rowCount)+"\"  value='"+obj.strGuestName+"' >";
		row.insertCell(4).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-right: 5px;width: 100%;   text-align: right;\" name=\"listCheckOutRoomDtlBeans["+(rowCount)+"].dblAmount\" id=\"dblAmount."+(rowCount)+"\"  value='"+obj.dblAmount+"' >";
		row.insertCell(5).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 5px;width: 100%;\" name=\"listCheckOutRoomDtlBeans["+(rowCount)+"].dteCheckInDate\" id=\"dteCheckInDate."+(rowCount)+"\"  value='"+obj.dteCheckInDate+"' >";
		row.insertCell(6).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 5px;width: 100%;\" name=\"listCheckOutRoomDtlBeans["+(rowCount)+"].dteCheckOutDate\" id=\"dteCheckOutDate."+(rowCount)+"\"  value='"+obj.dteCheckOutDate+"' >";
		row.insertCell(7).innerHTML= "<input readonly=\"readonly\" class=\"Box \"  style=\"padding-left: 5px;width: 100%;\" name=\"listCheckOutRoomDtlBeans["+(rowCount)+"].strCorporate\" id=\"strCorporate."+(rowCount)+"\" value='"+obj.strCorporate+"' >";
		row.insertCell(8).innerHTML= "<input readonly=\"readonly\" type=\"checkbox\"  class=\"Box payeeSel\"  style=\"padding-left: 5px;width: 100%;\" name=\"listCheckOutRoomDtlBeans["+(rowCount)+"].strRemoveTax\" id=\"strRemoveTax."+(rowCount)+"\" value='Y' >";
		row.insertCell(9).innerHTML= "<input type=\"button\" class=\"deletebutton\" size=\"6%\" value = \"\" onClick=\"Javacsript:funDeleteRow(this)\"/>";
		row.insertCell(10).innerHTML= "<input type=\"hidden\" class=\"Box \" name=\"listCheckOutRoomDtlBeans["+(rowCount)+"].strRoomNo\" id=\"strRoomNo."+(rowCount)+"\" value='"+obj.strRoomNo+"' >";


	}
	
	
	
	function funGetRoomDtl(roomCode)
	{
		$('#tblRoomDtl tbody > tr').remove();
		
		var searchUrl=getContextPath()+"/getRoomDtlList.html?roomCode="+roomCode;
		$.ajax({
			
			url:searchUrl,
			type :"GET",
			dataType: "json",
	        success: function(response)
	        {
	 		   $.each(response, function(index,obj)
	 		   {
	 			   fillTableRow(index,obj);
	 			   funFillTableRevenueDtl(obj.listRevenueTypeDtl);
	 			   
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
	
	
	function funSetRoomMasterData(roomCode)
	{
		 var searchUrl=getContextPath()+"/loadRoomMasterData.html?roomCode="+roomCode;
		$.ajax({
			
			url:searchUrl,
			type :"GET",
			dataType: "json",
	        success: function(response)
	        {
	        	if(response.strRoomCode=='Invalid Code')
	        	{
	        		alert("Invalid Room Code");
	        		$("#strSearchTextField").val('');
	        	}
	        	else
	        	{
	        		$("#strSearchTextField").val(response.strRoomDesc);
	        		funGetRoomDtl(response.strRoomCode);
	        		$("#strRoomNo").val(response.strRoomCode);
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
	
	
	function funSetGroupCheckOutData(roomCode)
	{
		$('#tblRoomDtl tbody > tr').remove();
		
		var searchUrl=getContextPath()+"/getRoomDtlList.html?roomCode="+roomCode+"&groupCheckIn=Y";
		$.ajax({
			
			url:searchUrl,
			type :"GET",
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
		$("#dteCheckOutDate").datepicker({
			dateFormat : 'dd-mm-yy'
		});
		
		$("#dteCheckOutDate").datepicker('setDate', 'today');
	});	
	
	
//set time
/*
    setInterval(timer, 1000);
    function timer() 
    {
		var dateObj = new Date();
	    $('#tmeCheckOutTime').val(dateObj.toLocaleTimeString());
    }
    */
    
	/**
	* Success Message After Saving Record
	**/
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
		
		var roomNo='<%=session.getAttribute("checkOutNo").toString()%>';
		if(roomNo!='')
		 {
			 $("#strSearchTextField").val(roomNo);
			
			 funSetRoomMasterData(roomNo);
			 <%session.removeAttribute("checkOutNo");
			 %>
		 }
		 else
		 {
			
			 $("#strSearchTextField").val("");
			 <%session.removeAttribute("checkOutNo");
			 %>
			 
		 }
		
		
		
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
			 	
		}
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
	
	
	function funDeleteRow(obj)
	{
	    var index = obj.parentNode.parentNode.rowIndex;
	    var table = document.getElementById("tblRoomDtl");
	    table.deleteRow(index);
	    
	}
	
</script>

</head>
<body>

	<div class="container">
		<label id="formHeading">Check Out</label>
		<s:form name="frmCheckOut" method="POST" action="saveCheckOut.html" target="_blank">
			<div class="row masterTable" style="padding-top:15px;">
					<!-- <s:radiobutton id="strSearchTypePAX"   path="strSearchType"      style="margin-right:5px;"/>PAX
					<s:radiobutton id="strSearchTypeGroup" path="strSearchType"      style="margin-left: 20px;margin-right:5px;" />Group
					-->
				<div class="col-md-2">
					<s:radiobutton id="strSearchTypeRoom" path="strSearchType" style="margin-right:5px;" value="" checked="checked"/>Room
					<s:input id="strSearchTextField" path="strSearchTextField" readonly="true" cssClass="searchTextBox" ondblclick="funHelp('checkInRooms')"/>
				</div>
				
				<div class="col-md-2">
					<s:radiobutton id="strSearchTypeCheckIn" path="strSearchType" style="margin-right:5px;" />Group Check In
					<s:input id="strSearchTextField" path="strSearchTextField" readonly="true" cssClass="searchTextBox" ondblclick="funHelp('groupcheckOut')"/>
				</div>
				<div class="col-md-2">
					<s:input type="hidden" id="strRoomNo" path="strRoomNo" />
					<%-- <s:input type="hidden" id="strCheckOutStatus" path="strCheckOutStatus" /> --%>
				</div>
			</div> 
			
		<div class="row masterTable"> 
			<div class="col-md-2">
				<label >Check Out</label>
				<s:input type="text" id="dteCheckOutDate" path="dteCheckOutDate" value="${PMSDate}" required="true" disabled="true" class="calenderTextBox" cssStyle="width: 80%;"/>
			</div>
			<div class="col-md-2">
				<s:input type="text" id="tmeCheckOutTime" path="tmeCheckOutTime" value="${PMSDate}" readonly="true" disabled="true"  style="background-color:#dcdada94; width: 80%; height: 43%; margin: 23px 0px;"/>
			</div>
				<%-- <td><s:checkbox label="Extra Time Charges" id="chkExtraTimeCharges" path="" value="N" onclick=' funTaxOnTaxStateChange() '/></td>
				<td><s:input colspan="3" type="text" id="txtExtraCharge"  path="" cssClass="longTextBox" onblur="fun1(this);" onkeypress="javascript:return isNumber(event)" /></td>
 --%>			
			 
			
		
		</div>
	
		<br />
		
		<!-- Generate Dynamic Table   -->
		
		<!-- Generate Dynamic Table   -->
		
		
		
    <div id="tab_container" style="height:360px; overflow: hidden;">
				<ul class="tabs">
					<li data-state="tab1" style="width:7%"   class="active">General</li>
					<li data-state="tab2" style="width:7%"   >Detail</li>
				</ul>
							
				<!-- General Tab Start -->
				<div id="tab1" class="tab_content" style="height: 360px">
					<br> 
					<br>					
					
					
				
				<!-- <th align="right" colspan="6"><a id="baseUrl"
					href="#"> Attach Documents</a>&nbsp; &nbsp; &nbsp;
						&nbsp;</th> -->
		<div class="dynamicTableContainer" style="height:304px;">
				<input type="checkbox" id="chkBoxAll" name="chkBoxAll1" value="Bike" style="margin-left: 1050px;" onclick="funCheckbox()">
		<br />
		<br />
			<table style="height: 28px; border: #0F0; width: 100%;font-size:11px; font-weight: bold;">
				<tr bgcolor="#c0c0c0" style="height: 24px;">
					<!-- col1   -->
					<td  style="width: 65px;" align="center">Room No.</td>
					<!-- col1   -->
					
					<!-- col2   -->
					<td  style=" width:85px;" align="center">Registration No.</td>
					<!-- col2   -->
					
					<!-- col3   -->
					<td style="width: 65px;" align="center">Folio No.</td>
					<!-- col3   -->
					
					<!-- col4   -->
					<td style="width: 250px;" align="center">Guest Name</td>
					<!-- col4   -->
					
					<!-- col5   -->
					<td  style="width: 60px;"align="center" >Amount</td>
					<!-- col5   -->
					
					<!-- col6  -->
					<td  style="width: 75px;"align="center">Check-In Date</td>
					<!-- col6  -->
					
					<!-- col7   -->
					<td  style="width: 85px;"align="center">Check-Out Date</td>
					<!-- col7   -->
					
					
					<!-- col8   -->
					<td style="width: 70px;"align="center">Corporate</td>
					<!-- col8   -->
					
					<!-- col9   -->
					<td style="width: 70px;"align="center">Remove Taxes </td>
					<!-- col9   -->
					
					<!-- col10   -->
					<td style="width:20px;"align="center">Delete</td>
					<!-- col10   -->
					
									
				</tr>
			</table>
			<div style="background-color: #fbfafa; border: 1px solid #ccc; display: block; height: 215px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%;">
				<table id="tblRoomDtl" style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll" class="transTablex col9-center">
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
						
						<!-- col4   -->
						<col style="width: 311px;">
						<!-- col4   -->
						
						<!-- col5   -->
						<col style="width: 71px;">
						<!-- col5   -->
						
						<!-- col6   -->
						<col style="width: 95px;">
						<!-- col6   -->
						
						<!-- col7   -->
						<col style="width: 112px;">
						<!-- col7   -->
						
						<!-- col8   -->
						<col style="width: 93px;">
						<!-- col8   -->
						
						<!-- col9   -->
						<col style="width: 70px;">
						<!-- col9   -->
						
						<!-- col10   -->
						<col style="width: 20px;">
						<!-- col10   -->
						
										
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
		         </div>
						<!--General Tab End  -->
			
						
			<!-- Linkedup Details Tab Start -->
			<div id="tab2" class="tab_content" style="height: 360px">
			<br> 
			<br>			
				<div class="dynamicTableContainer" style="height: 200px;width: 106%;border: 0px;overflow-x: hidden;">
			<table style="height: 28px;border: #0F0;width: 62%;font-size:11px;font-weight: bold;">
				<tr bgcolor="#c0c0c0" style="height: 24px;">
					<!-- col1   -->
					<td style="width: 209px;">Particular</td>
					<!-- col1   -->
					
					<!-- col2   -->
					<td style="width: 29px;" align="center">Value</td>
					<!-- col2   -->
					
					<!-- col3   -->
					<td style="width: 65px;" align="center">Number</td>
					<!-- col3   -->
				</tr>
			</table>
			<div style="background-color: #fbfafa;border: 1px solid #ccc;display: block;height: 200px;/* margin: auto; */overflow-x: hidden;overflow-y: scroll;width: 62%;">
				<table id="tblRoomRevenueDtl" style="width: 100%; border: #0F0; table-layout: fixed; overflow: scroll" class="transTablex col9-center">
					<tbody>
						
						
						<col style="width: 349px;">
						<!-- col1   -->
						
						<!-- col2   -->
						<col style="width: 98px;">
						<!-- col2   -->
						
						<!-- col3   -->
						<col style="width: 60px;">
						<!-- col3   -->
						
						
						
										
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
			</div>
			
		</div>
		<div class="center">
			<a href="#"><button class="btn btn-primary center-block" value="Submit" onclick="return funValidateData()"
				class="form_button">Submit</button></a>
			<a href="#"><button class="btn btn-primary center-block" value="Reset" onclick="return funResetFields()"
				class="form_button">Reset</button></a>
		</div>
	</s:form>
</div>
</body>
</html>
