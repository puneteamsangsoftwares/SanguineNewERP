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
	var fieldName,settlementType="",gstrIndustryType;
	var pmsDate="";
	$(function() 
	{
		pmsDate='2019-11-11';
		pmsDate='<%=session.getAttribute("PMSDate").toString()%>'; 
		
		 <%-- '<%=session.getAttribute("PMSDate").toString()%>'; --%>
		 
		$("#txtExpiryDate").datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtExpiryDate").datepicker('setDate', pmsDate);		
		
	   var dte=pmsDate.split("-");
	   $("#txtPMSDate").val(dte[2]+"-"+dte[1]+"-"+dte[0]);
	  
	   var code='${code}';
	   var dblAmt='${dblBalanceAmt}';
	  
	   if(code!=''||code!="")
	   {
		    $("#txtDocCode").val(code);
		    $("#txtSettlementCode").focus();
		    $("#flagForAdvAmt").val("Y");
		    $("#lblBalnceAmount").text(dblAmt);
		   
	    
	   }
	   else{
		  
	  }
		  
		<%--   var strIndustryType='';
		  gstrIndustryType=strIndustryType;
		  if(strIndustryType=='7-WebBanquet') 
	   		{
	   			$('#trGuest').hide();
	   			
	   		}
	   		
	   		var bookingNo='<%=session.getAttribute("BookingNo").toString()%>';
	   		var obookingNo='<%=session.getAttribute("OBookingNo").toString()%>';	   		
	   		var invoiceCode='<%=session.getAttribute("invoiceCode").toString()%>';
	   		var date='<%=session.getAttribute("date").toString()%>';			   		
	   		if(invoiceCode!=''&&bookingNo!='')
	   		{
	   		 $("#txtDocCode").val(invoiceCode);				
	   		 $("#cmbAgainst").val('Invoice');
	   		 funSetPaymentGuestInvoiceCodeData(bookingNo,"Booking");  
	   		 <%session.removeAttribute("BookingNo");%>	
			 <%session.removeAttribute("invoiceCode");%>
	   		}
	   		else if(obookingNo!='')
	   		{
		   		$("#txtDocCode").val(invoiceCode);
				funSetPaymentGuestData(obookingNo,"Booking");
				<%session.removeAttribute("OBookingNo");%>	
	   		}
			else
			{				
				$("#txtDocCode").val("");
				<%session.removeAttribute("BookingNo");%>					 
				<%session.removeAttribute("invoiceCode");%>
				<%session.removeAttribute("date");%>
			} 
	   		 --%>
	   		
		  
	});


	function funSetData(code){

		switch(fieldName){

			case 'RegistrationNo':
				//funSetPaymentData(code);
				break;
				
			case 'ReservationNo':
				funSetPaymentGuestData(code,"Reservation");
				break;
				
			case 'folioPayee':
				funSetPaymentGuestData(code,"Folio-No");
				break;
				
			case 'checkInRooms':
				funSetPaymentGuestData(code,"CheckIn");
				break;
			
			case 'BillForPayment':
				funSetPaymentGuestData(code,"Bill");
				break;
				
			case 'settlementCode':
				funSetSettlementType(code);
				break;
				
			case 'receiptNo':
				funSetReceiptData(code);
				break;
				
			case 'guestCode' : 
				funSetGuestCode(code);
				break;
				
			case 'BillForBooking' : 
				funSetPaymentGuestData(code,"Booking");
				break;
				
			case 'proformaInvoice' : 
				funSetInvoiceData(code);
				break;
		}
	}

	function funSetInvoiceData(code)
	{
		gurl=getContextPath()+"/loadProFormaInvoiceHdData.html?invCode="+code;
		$.ajax({
	        type: "GET",
	        url: gurl,
	        dataType: "json",
	        success: function(response)
	        {		        	
	        		if(null == response.strInvCode){
	        			alert("Invalid  Invoice Code");
	        			$("#txtDocCode").val('');
	        			$("#txtDocCode").focus();	        			
	        		}else{		        			
	        			$('#txtDocCode').val(code);
	        			$('#txtReceiptAmt').val(response.dblGrandTotal);
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
	 function funSetBanquetCode(code){
		
		 $("#txtDocCode").val(code);
	} 
	function funSetGuestInfo(obj)
	{
		$("#txtCreditName").val(obj.strGuestCode);
		$("#txtCredit").val(obj.strFirstName);
	
	}	
	
	function funSetReceiptData(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadReceiptData.html?receiptNo=" + code,
			dataType : "json",
			success : function(response){ 
				funSetReceiptInfo(response);
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
	
	
	function funSetFolioNoData(code){

		$("#txtDocCode").val(code);
	}
	
	

	function funSetRegistrationNo(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadRegistrationNo.html?docCode=" + code,
			dataType : "json",
			success : function(response){ 
								
			},
			error : function(e){

			}
		});
	}

	function funSetReservationNo(code)
	{
		$("#txtDocCode").val(code);
	}
	
	
	//set PaymentGuestDetails Data
	function funSetPaymentGuestData(code,type)
	{
		var searchUrl=getContextPath()+"/loadPaymentGuestDetails.html?docCode="+code+ "&docName=" + type;
		$.ajax({
			
			url:searchUrl,
			type :"GET",
			dataType: "json",
	        success: function(response)
	        {
	        	if(response.strRoomCode=='Invalid Code')
	        	{
	        		alert("Invalid Doc Code");
	        		$("#txtDocCode").val('');
	        	}
	        	else
	        	{
	        		$("#txtDocCode").val(code);
	        		$("#lblGuestName").text("Guest Name");
	        		$("#lblGuestFullName").text(response[0].strFirstName+" "+response[0].strMiddleName+" "+response[0].strLastName);
	        		$( "#txtReceiptAmt" ).focus();
	        		$( "#lblBalnceAmount").text(response[0].dblBalanceAmount);
	        		 $("#txtReceiptAmt").val(response[0].dblBalanceAmount);
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

	
	//set PaymentGuestDetails redirected from diary
	function funSetPaymentGuestInvoiceCodeData(code,type)
	{
		var searchUrl=getContextPath()+"/loadPaymentGuestDetails.html?docCode="+code+ "&docName=" + type;
		$.ajax({
			
			url:searchUrl,
			type :"GET",
			dataType: "json",
	        success: function(response)
	        {
	        	if(response.strRoomCode=='Invalid Code')
	        	{
	        		alert("Invalid Doc Code");
	        		$("#txtDocCode").val('');
	        	}
	        	else
	        	{
	        		
	        		$("#lblGuestName").text("Guest Name");
	        		$("#lblGuestFullName").text(response[0].strFirstName+" "+response[0].strMiddleName+" "+response[0].strLastName);
	        		$( "#txtReceiptAmt" ).focus();
	        		$( "#lblBalnceAmount").text(response[0].dblBalanceAmount);
	        		 $("#txtReceiptAmt").val(response[0].dblBalanceAmount);
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
	
	function funSetBillNo(code)
	{
	  	$("#txtDocCode").val(code);
	}
	
	
	function funSetCheckinNo(code)
	{
		$("#txtDocCode").val(code);
	}
	
	
	function funSetSettlementType(code)
	{
		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadSettlementCode.html?settlementCode=" + code,
			dataType : "json",
			success : function(response)
			{
				if(response.strService=='Invalid Code')
	        	{
	        		alert("Invalid Service Code");
	        		$("#txtSettlement").val('');
	        	}
	        	else
	        	{
		        	$("#txtSettlementCode").val(response.strSettlementCode);
		        	$("#txtSettlementDesc").val(response.strSettlementDesc);
		        	settlementType=response.strSettlementType;
		        	$("#lblExpiryDate").text("Expiry Date"); 
	        		$("#lblCardNo").text("Card No");  
		        	if(settlementType=='Cheque')
	        		{
		        		$("#lblExpiryDate").text("Cheque Date"); 
		        		$("#lblCardNo").text("Cheque No");  		        		 		        		
	        		}
		        	
	        	}

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
	}
	
	//Open Against Form
	function funOpenAgainst() {
		if ($("#cmbAgainst").val() == "Reservation")
		{
			funHelp("ReservationNo");
			fieldName = "ReservationNo";
		}

		else if ($("#cmbAgainst").val() == "Folio-No") 
		{
			funHelp("folioPayee");
			fieldName = "folioPayee";
		}
		/* else if ($("#cmbAgainst").val() == "Check-In") 
		{
			funHelp("checkIn");
			fieldName = "checkInRooms";
		} */
		else if ($("#cmbAgainst").val() == "Bill")
		{
			funHelp("BillForPayment");
			fieldName = "BillForPayment";
		}
		else if ($("#cmbAgainst").val() == "Banquet")
		{
			funHelp("BillForBanquet");
			fieldName = "BillForBooking";
		}
		else if ($("#cmbAgainst").val() == "Invoice")
		{
			funHelp("proformaInvoice");
			fieldName = "proformaInvoice";
		}
		
	}
	
	function funSetReceiptInfo(response)
	{
		$("#txtReceiptNo").val(response.strReceiptNo);
		$("#cmbAgainst").val(response.strAgainst);
		$("#txtDocCode").val(response.strDocNo);
		$("#txtReceiptAmt").val(response.dblReceiptAmt);
		
		if(response.strAgainst=='Reservation')
		{
			funSetPaymentGuestData(response.strDocNo,"Reservation");
		}
		else if(response.strAgainst=='Check-In')
		{
			funSetPaymentGuestData(response.strDocNo,"CheckIn");
		}
		else if(response.strAgainst=='Bill')
		{
			funSetPaymentGuestData(response.strDocNo,"Bill");
		}
		
		$("#txtSettlementCode").val(response.strSettlementCode);
		funSetSettlementType(response.strSettlementCode);
		$("#txtCardNo").val(response.strCardNo);
		$("#txtExpiryDate").val(response.dteExpiryDate);
		$("#txtRemarks").val(response.strRemarks);
		$("#flagForAdvAmt").val(response.strFlagOfAdvAmt);
		
	}
	
	function funHelp(transactionName)
	{
		fieldName=transactionName;
		window.open("searchform.html?formname="+transactionName+"&searchText=","mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=900,height=600,left=400px");
		//window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
/**
* Success Message After Saving Record
**/
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
			{%>
				alert("Data Save successfully\n\n"+message);
				var reciptNo='';
				var isOk=confirm("Do You Want to Generate Slip?");
				if(isOk)
 				{
	 				reciptNo='<%=session.getAttribute("GenerateSlip").toString()%>';
	 				checkAgainst='<%=session.getAttribute("Against").toString()%>';
	    			window.open(getContextPath()+"/rptReservationPaymentRecipt.html?reciptNo="+reciptNo+"&checkAgainst="+checkAgainst,'_blank');
					session.removeAttribute("GenerateSlip");
					session.removeAttribute("Against");
				}<%
			}
		}%>
	
	
 	/**
	*   Attached document Link
	**/
	$(function()
	{
	
		$('a#baseUrl').click(function() 
		{
			if($("#txtReceiptNo").val().trim()=="")
			{
				alert("Please Select Receipt Number");
				return false;
			}
		   	window.open('attachDoc.html?transName=frmPMSPayment.jsp&formName=Payment&code='+$('#txtReceiptNo').val(),"mywindow","directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=600,left=400px");
		});
		
		/**
		* On Blur Event on Reservation Code Textfield
		**/
		$('#txtReceiptNo').blur(function() 
		{
			var code = $('#txtReceiptNo').val();
			if (code.trim().length > 0 && code !="?" && code !="/")
			{
				funSetData(code);
			}
		});
		
	});
 	
	function funValidateFields(actionName,object)
	{
		var flg=true;
		
		if($("#txtSettlementCode").val().trim().length==0)
		{
			alert("Please Select Payment mode!!");
			 flg=false;
		}
		
		if(settlementType=="Credit Card")
		{
			if($("#txtCardNo").val().trim().length==0)
			{
				alert("Please Enter cardNo!!");
				 flg=false;
			}
		}
		
		if(settlementType=="Credit")
		{
			if(gstrIndustryType!='7-WebBanquet')
				{
				if($("#txtCreditName").val().trim().length==0)
				{
					alert("Please Enter Credit Name !!");
					 flg=false;
				}
				}
			
		}
		
		if(parseFloat($("#lblBalnceAmount").text())>='0.0')
		{
			if($("#txtReceiptAmt").val()=='0'||$("#txtReceiptAmt").val()=='0.0' )
			{
				alert("Please Enter Amount");
				 flg=false;
			}
			/* else if(parseFloat($("#txtReceiptAmt").val())>parseFloat($("#lblBalnceAmount").text()))
			{
				

				alert("Amount should not be greatest than balance amount"); 
				 flg=false;
			} */
		}
		else
		{
			//alert("Please Enter Amount");
			 //flg=false;
		}	
	
		return flg;
	}
	
function funCreateNewGuest(){
		
		window.open("frmGuestMaster.html", "myhelp", "scrollbars=1,width=500,height=350");
<%-- 		var GuestDetails='<%=session.getAttribute("GuestDetails").toString()%>'; --%>
// 		var guest=GuestDetails.split("#");
	}
</script>

</head>
<body>
  <div class="container masterTable">
	<label id="formHeading">Payment</label>
	  <s:form name="Payment" method="GET" action="savePMSPayment.html">
	
	   <div class="row">
            <div class="col-md-2"><label>Payment Receipt No</label>
		            <s:input id="txtReceiptNo" path="strReceiptNo" readonly="readonly" ondblclick="funHelp('receiptNo');" style="height: 45%;" class="searchTextBox"></s:input>
			</div>
		
	   	    <div class="col-md-3"><label>Against</label>
	   	       <div class="row">
			     <div class="col-md-6"><s:select id="cmbAgainst" items="${listAgainst}" name="cmbAgainst" path="strAgainst"></s:select></div>
			     <div class="col-md-6"><s:input id="txtDocCode" path="strDocNo" readonly="readonly" ondblclick="funOpenAgainst()" style="height: 95%;" class="searchTextBox" ></s:input></div>
		    </div></div>
		  
	  	    <div class="col-md-2"><label id="lblGuestName"></label>
		          <label id="lblGuestFullName" style=" width: 100%; height: 45%;"></label>
		    </div>
            
            <div class="col-md-5"></div>
            
		    <div class="col-md-1"><label>Amount</label>
			     <s:input style="" id="txtReceiptAmt" path="dblReceiptAmt"/>
			</div>
			 
		    <div class="col-md-2"><label> Balance Amount</label><br>
			      <label id="lblBalnceAmount" readonly="readonly" style="background-color:#dcdada94; width: 100%; height: 42%;"></label>
			</div>
	
			<%-- <tr>
			<td>Settlement Type</td>
			
			<td>
				<s:select id="cmbAgainst" items="${listSettlement}" name="cmbSettlementType" path=""></s:select>
			</td>
		    </tr> --%>
		   
			<div class="col-md-2"><label>Settlement Code</label>
			      <s:input type="text" id="txtSettlementCode" path="strSettlementCode" style="height: 45%;" cssClass="searchTextBox" ondblclick="funHelp('settlementCode'); "/>
				<%-- onselect="funSelect();" --%>
			</div>
				  
			<div class="col-md-2"><label>Settlement Desc</label>
			      <s:input type="text" id="txtSettlementDesc" path="strSettlementDesc"/>
		    </div>
		
		    <div class="col-md-5"></div>
		    
			<div class="col-md-3">
	   	       <div class="row">
			     <div class="col-md-6" id="lblCardOrCheck"><label id="lblCardNo">Card No</label>
			        <s:input type="text" id="txtCardNo" path="strCardNo"/>
			     </div>
			     <div class="col-md-6"><label id="lblExpiryDate">Expiry Date</label>
			        <s:input type="text" id="txtExpiryDate" path="dteExpiryDate" cssClass="calenderTextBox" />
		         </div>
		   </div></div>
		   
		    <div class="col-md-4">
	   	       <div class="row"><div class="col-md-6" id="trGuest"><label>Credit Name</label>
		          <s:input id="txtCreditName" path="strCustomerCode" readonly="readonly" ondblclick="funHelp('guestCode');" style="height: 45%;" class="searchTextBox"></s:input>
			</div>
			<div class="col-md-6"><s:input id="txtCredit"  path="" readonly="true" style="margin-top: 27px;"></s:input>
			</div>
	       </div></div>
            <div class="col-md-5"></div>
            
		    <div class="col-md-2"><label>Remark</label>
			       <s:input type="text" id="txtRemarks" path="strRemarks"/>
		    </div>
		      
           <div class="col-md-1">
                   <input type="Button" value="New Guest" onclick="return funCreateNewGuest()" class="btn btn-primary center-block" class="form_button" style="margin-top: 25px;"/>
            </div>
        </div>
		<br />
		<p align="center" style="margin-right:-2%">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" onclick="return funValidateFields('submit',this)" />
			&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>
       <s:input type="hidden"  id="flagForAdvAmt" path="strFlagOfAdvAmt" value="N" name="saddr" />
	</s:form>
	</div>
</body>
</html>
