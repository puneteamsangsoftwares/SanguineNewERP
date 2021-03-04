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
<style>
input[type=text]{
font-size:12px;}

</style>
<script type="text/javascript">
	var fieldName;

	$(function() 
	{
		var pmsDate='<%=session.getAttribute("PMSDate").toString()%>';
		
		$("#txtBillDate").timepicker();
		$("#txtBillDate").datepicker({ dateFormat: 'dd-mm-yy' });
		$("#txtBillDate").datepicker('setDate', pmsDate);
	});

	function funSetData(code){

		switch(fieldName){

			case 'billNo' : 
				funSetBillNo(code);
				break;
			case 'CheckInNo' : 
				funSetCheckInNo(code);
				break;
			case 'FolioNo' : 
				funSetFolioNo(code);
				break;
		}
	}


	function funSetBillNo(code){

		$.ajax({
			type : "POST",
			url : getContextPath()+ "/getBillData.html?docCode=" + code,
			dataType : "json",
			success : function(response){ 

				if(response.strBillNo=="Invalid Bill No")
		    	{
					alert("Invalid Bill No");
			    	$("#txtBillNo").val("");
			    	$("#txtBillNo").focus();
			    	return false;
		    	}
		    	else
			    {
		    		$("#txtBillNo").val(response.strBillNo);
		    		$("#txtBillDate").val(response.dteBillDate);
		    		$("#txtCheckInNo").val(response.strCheckInNo);
		    		$("#txtFolioNo").val(response.strFolioNo);
		    		
		    		funSetRoomMasterData(response.strRoomNo)
		    		$("#txtDiscAmt").val(response.dblDiscAmt);
		    		$("#txtGrandTotal").val(response.dblGrandTotal);
		    		$("#txtTotal").val(response.dblGrandTotal);
		    		
		    		$("#txtRemark").val('');
		    		$("#cmbReason").val('');
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


	function funSetCheckInNo(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadCheckInNo.html?docCode=" + code,
			dataType : "json",
			success : function(response){ 

			},
			error : function(e){

			}
		});
	}

	function funSetFolioNo(code){

		$.ajax({
			type : "GET",
			url : getContextPath()+ "/loadFolioNo.html?docCode=" + code,
			dataType : "json",
			success : function(response){ 

			},
			error : function(e){

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
	        		$("#txtRoomNo").val('');
	        	}
	        	else
	        	{
	        		$("#txtRoomNo").val(response.strRoomCode);
	        		$("#lblRoomDesc").text(response.strRoomDesc);
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

  function funHelp(transactionName)
	{
		fieldName=transactionName;
		window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;");
	}
	
	function funDiscountSelection(){
		if($("#cmbDiscountType").val()=="Amount"){
			document.getElementById("txtDiscPer").readOnly = true; 
			document.getElementById("txtDiscAmt").readOnly = false; 
			$("#txtDiscPer").val(0.0);
			$("#txtGrandTotal").val($("#txtTotal").val());
			document.getElementById('txtDiscAmt').style.display = 'block';
			document.getElementById('txtDiscPer').style.display = 'none';
			
		}
		if($("#cmbDiscountType").val()=="Per"){
			document.getElementById("txtDiscAmt").readOnly = true;
			document.getElementById("txtDiscPer").readOnly = false; 
			$("#txtDiscAmt").val(0.0);
			$("#txtGrandTotal").val($("#txtTotal").val());

			document.getElementById('txtDiscPer').style.display = 'block';
						document.getElementById('txtDiscAmt').style.display = 'none';
		}
	}
	function funCalculateDiscount()
	{
		if($("#cmbDiscountType").val()=="Amount"){
			var discAmt=$("#txtDiscAmt").val();
			$("#txtGrandTotal").val($("#txtTotal").val()-discAmt);
		}else{
			var discPer=$("#txtDiscPer").val();
			var grandTotCal=$("#txtTotal").val()-($("#txtTotal").val()*(discPer/100));
			
			$("#txtGrandTotal").val(grandTotCal);
		}
	}
	
	function funBtnSubmit(){
		
		if($("#txtBillNo").val()==''){
			alert("Select Bill No");
			return false;
		}
		if($("#txtGrandTotal").val()==''){
			alert("No Full Void");
			return false;
		}
		if($("#txtGrandTotal").val()==''){
			alert("No Full Void");
			return false;
		}
		
		if($("#txtRemark").val()==''){
			alert("Enter Valied Remark");
			return false;
		}
		
	}

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

	});
	
	 function funChangeDiscType()
	 {
		 
		 $("#cmbDiscountType").val('Per')
		 document.getElementById("txtDiscAmt").readOnly = true;
			document.getElementById("txtDiscPer").readOnly = false; 
			$("#txtDiscAmt").val(0.0);
			$("#txtGrandTotal").val($("#txtTotal").val());
			document.getElementById('txtDiscPer').style.display = 'block';
			document.getElementById('txtDiscAmt').style.display = 'none';
	 }
</script>

</head>
<body>
  <div class="container masterTable">
	<label id="formHeading">Modify Bill</label>
	<s:form name="BillDiscount" method="POST" action="saveBillDiscount.html">

		<div class="row">
			<div class="col-md-3">
			    <div class="row">
			         <div class="col-md-6"><label>Bill No</label>
				          <s:input type="text" path="strBillNo" id="txtBillNo" cssClass="searchTextBox" ondblclick="funHelp('billNo')" />
				     </div>
		             <div class="col-md-6"><label>Bill Date</label>
				          <s:input type="text" readonly="true" path="dteBillDate" id="txtBillDate" cssClass="calenderTextBox" />
				      </div>
	         </div></div>
	         
			 <div class="col-md-3">
			    <div class="row">
			           <div class="col-md-6"><label>CheckIn No</label>
				            <s:input type="text" readonly="true"  path="strCheckInNo" id="txtCheckInNo" />
				        </div>
		                <div class="col-md-6"><label>Folio No</label>
				             <s:input type="text" readonly="true"  path="strFolioNo"  id="txtFolioNo"/>
				        </div>
			</div></div>
			
			<div class="col-md-3">
			    <div class="row">
					<div class="col-md-5"><label>Room No</label>
				        <s:input type="text" readonly="true"  path="strRoomNo"  id="txtRoomNo"/></div>
				    <div class="col-md-7"><label id="lblRoomDesc" style="margin-top: 15%;"></label></div>
			  </div></div>
			<div class="col-md-3"></div>
			
			 <div class="col-md-3">
			     <div class="row">
			       <div class="col-md-6"><label>Disc On</label>
				    <s:select id="cmbDiscountOn" path="strDiscOn" onchange="funChangeDiscType();">
 					    <s:option value="All">All</s:option>
				    	<s:option value="Room Tariff">Room Tariff</s:option>
				    	<s:option value="Income Head">Income Head</s:option>
				   </s:select>
				   </div>
				   <div class="col-md-6"><label>Disc Type</label>
				     <s:select id="cmbDiscountType" path="strDiscountType" onchange="funDiscountSelection();"><!-- onchange="funDiscountSelection();" -->
 					    <s:option value="Amount">Amount</s:option>
				    	<s:option value="Per">Per</s:option>
				     </s:select>
		            </div>
			  </div></div>
			
	       <div class="col-md-3">
	          <div class="row">
			     <div class="col-md-6"><label>Disc Amt</label>
				     <s:input type="number" step="0.01"  path="dblDiscAmt"  id="txtDiscAmt" style = "text-align:right;width: 100%;" onblur="funCalculateDiscount();"/>
			      </div>
			      <div class="col-md-6"><label>Disc Per</label>
				      <s:input type="number" step="0.01"  path="dblDiscPer"  id="txtDiscPer" style = "text-align:right;width: 100%;" onblur="funCalculateDiscount();"/>
			       </div>
		    </div></div>
		 	
			<div class="col-md-3">
	          <div class="row">
	             <div class="col-md-6"><label>Total</label>
				     <s:input type="number" step="0.01" readonly="true"   path="dblTotal" style = "text-align:right;width: 100%;" id="txtTotal"/>
			     </div>
			     <div class="col-md-6"></div>
		    </div></div>
		    <div class="col-md-3"></div>
		    
		   <div class="col-md-1"><label style="width:110%">Grand Total</label>
				<s:input type="number" step="0.01" readonly="true" path="dblGrandTotal" style ="text-align:right;" id="txtGrandTotal"/>
			</div> 
			
			<div class="col-md-2"><label>Reason</label>
			    <s:select id="cmbReason" path="strReason">
    			   <s:options items="${listReason}"/>
    			</s:select>
   			</div>
   		      
   			<div class="col-md-2"><label>Remark</label>
    			<s:input id="txtRemark" path="strRemark"/>
			</div>
		</div>

		<br />
		<p align="center" style="margin-left: 11%;">
			<input type="submit" value="Submit" tabindex="3" class="btn btn-primary center-block" class="form_button" onclick="return funBtnSubmit()" />&nbsp;
			<input type="reset" value="Reset" class="btn btn-primary center-block" class="form_button" onclick="funResetFields()"/>
		</p>

	</s:form>
	</div>
</body>
</html>
